//
//  AppDelegate.swift
//  EndingViolence
//
//  Created by Steven Thompson on 2016-03-05.
//  Copyright © 2016 teamteamtwo. All rights reserved.
//

import UIKit
import ReachabilitySwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var reachability = try? Reachability.reachabilityForInternetConnection()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        ///// Use this to find the path to the realm file
        print(documentPath())
        
        ///// Reachability
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                selector: "reachabilityChanged:",
                name: ReachabilityChangedNotification,
                object: reachability
        )
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: "userLoggedIn", name: UserLoggedIn, object: nil)
        
        // NOTE: Call this AFTER setting up notification handlers
        startReachability()
        
        let loggedIn = true
        if loggedIn {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = vc
        } else {
            let vc = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
            self.window?.rootViewController = vc
        }
        return true
    }
    
    func userLoggedIn() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.rootViewController = vc
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        reachability?.stopNotifier()
        NSNotificationCenter.defaultCenter()
            .removeObserver(self,
                name: ReachabilityChangedNotification,
                object: reachability
        )
    }
    
    // MARK: Reachability
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Not reachable")
        }
    }

    private func startReachability() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

}

