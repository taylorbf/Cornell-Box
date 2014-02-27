//
//  MAGViewController.m
//  Mobile Music Template
//
//  Created by Jesse Allison on 10/17/12.
//  Copyright (c) 2012 MAG. All rights reserved.
//

#import "MAGViewController.h"

@interface MAGViewController ()

//@property (strong, nonatomic) IBOutlet UIWebView *mWebView;

@end

@implementation MAGViewController

@synthesize enabled;
@synthesize enableButton;

- (void)viewDidLoad
{
    NSLog(@"Log2");
    [super viewDidLoad];
	
    // _________________ LOAD Pd Patch ____________________
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"mag_template.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }
    enabled = NO;
    
    
    [mWebView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [mWebView setOpaque:NO];
    mWebView.scrollView.scrollEnabled = NO;
    mWebView.scrollView.bounces = NO;
    
    
    NSString*path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"WebApp"];
    NSURL*url= [NSURL fileURLWithPath:path];
    [mWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

/*
- (void)viewDidUnload
{
    // uncomment for pre-iOS 6 deployment
    [super viewDidUnload];
    [PdBase closeFile:patch];
    [PdBase setDelegate:nil];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)webView:(UIWebView *)mWebView shouldStartLoadWithRequest:(NSURLRequest *)request          navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    
    if([[request.URL absoluteString] hasPrefix:@"nexus"]) {
        // do stuff
        
        NSString *oscCommand = [url relativePath];
        
        NSArray *urlComponents = [oscCommand componentsSeparatedByString:@":"];
        
      //  NSLog( @"%@",[urlComponents objectAtIndex:0] );
        
        //   NSString *tester = [[NSString alloc] initWithFormat:@"ballinfo"];
        NSString *tester = @"/sampleset";
        NSString *tester2 = @"/tilt";
        
        if([[urlComponents objectAtIndex:0] isEqualToString:tester]) {
        
            NSString *valueString = [urlComponents objectAtIndex:1];
            [PdBase sendFloat:[valueString floatValue] toReceiver:@"sampleset"];
        
        }
        
        if([[urlComponents objectAtIndex:0] isEqualToString:tester2]) {
            
            NSString *valueString = [urlComponents objectAtIndex:1];
            [PdBase sendFloat:[valueString floatValue] toReceiver:@"tiltx"];
            
            NSString *valueString2 = [urlComponents objectAtIndex:2];
            [PdBase sendFloat:[valueString2 floatValue] toReceiver:@"tilty"];
            
            NSString *valueString3 = [urlComponents objectAtIndex:3];
            [PdBase sendFloat:[valueString3 floatValue] toReceiver:@"tiltz"];
        
        }

        
        return NO;
    }
    
    return YES;
}



/*

- (BOOL) webView:(UIWebView *)mWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = [request URL];
    NSLog(@"Log1");
    
    if([url isFileURL]) {
        return YES;
    } else if ([[url scheme] isEqualToString:@"nexus"]) {
        NSLog(@"Play a note");
        NSString *oscCommand = [url relativePath];
        
        NSArray *urlComponents = [oscCommand componentsSeparatedByString:@":"];
        NSString *valueString = [urlComponents objectAtIndex:1];
        
        [PdBase sendFloat:[valueString floatValue] toReceiver:@"control"];
        return NO;
    }
    
    return YES;
}

*/

/* _________________ UI Interactions with Pd Patch ____________________

- (IBAction)randomPitch:(UIButton *)sender {
    [PdBase sendBangToReceiver:@"random_note"];
}

- (IBAction)enable:(UIButton *)sender {
    
    if (enabled) {
        enabled = NO;
        // enableButton.titleLabel = @"Enable";
        [enableButton setTitle:@"Enable" forState:UIControlStateNormal];
        [PdBase sendFloat:0 toReceiver:@"enable"];
    } else {
        enabled = YES;
        [enableButton setTitle:@"Disable" forState:UIControlStateNormal];
        [PdBase sendFloat:1 toReceiver:@"enable"];
    }
    
} */

@end
