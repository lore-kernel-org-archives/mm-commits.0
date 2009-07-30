From: akpm@linux-foundation.org
Subject: [merged] rtc-mark-if-rtc-cmos-drivers-were-successfully-registered.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:35:10 -0700
Message-ID: <200907302035.n6UKZAdR007753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751862AbZG3Ufl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:35:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cascardo@holoscopio.com, alessandro.zummo@towertech.it, bjorn.helgaas@hp.com, david-b@pacbell.net, greg@kroah.com, kay.sievers@vrfy.org, mingo@elte.hu, ozan@pardus.org.tr, torvalds@li


The patch titled
     rtc: mark if rtc-cmos drivers were successfully registered
has been removed from the -mm tree.  Its filename was
     rtc-mark-if-rtc-cmos-drivers-were-successfully-registered.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: mark if rtc-cmos drivers were successfully registered
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

rtc-cmos has two drivers, one PNP and one platform.  When PNP has not
succeeded probing, platform is registered.  However, it tries to
unregister both drivers unconditionally, instead of only unregistering
those that were successfully registered.  This causes runtime warnings to
be emitted from the driver core code.

Fix this with a boolean variable for each driver indicating whether
registering was successful.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Cc: Ozan Caglayan <ozan@pardus.org.tr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-mark-if-rtc-cmos-drivers-were-successfully-registered drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-mark-if-rtc-cmos-drivers-were-successfully-registered
+++ a/drivers/rtc/rtc-cmos.c
@@ -1174,23 +1174,34 @@ static struct platform_driver cmos_platf
 	}
 };
 
+#ifdef CONFIG_PNP
+static bool pnp_driver_registered;
+#endif
+static bool platform_driver_registered;
+
 static int __init cmos_init(void)
 {
 	int retval = 0;
 
 #ifdef	CONFIG_PNP
-	pnp_register_driver(&cmos_pnp_driver);
+	retval = pnp_register_driver(&cmos_pnp_driver);
+	if (retval == 0)
+		pnp_driver_registered = true;
 #endif
 
-	if (!cmos_rtc.dev)
+	if (!cmos_rtc.dev) {
 		retval = platform_driver_probe(&cmos_platform_driver,
 					       cmos_platform_probe);
+		if (retval == 0)
+			platform_driver_registered = true;
+	}
 
 	if (retval == 0)
 		return 0;
 
 #ifdef	CONFIG_PNP
-	pnp_unregister_driver(&cmos_pnp_driver);
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&cmos_pnp_driver);
 #endif
 	return retval;
 }
@@ -1199,9 +1210,11 @@ module_init(cmos_init);
 static void __exit cmos_exit(void)
 {
 #ifdef	CONFIG_PNP
-	pnp_unregister_driver(&cmos_pnp_driver);
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&cmos_pnp_driver);
 #endif
-	platform_driver_unregister(&cmos_platform_driver);
+	if (platform_driver_registered)
+		platform_driver_unregister(&cmos_platform_driver);
 }
 module_exit(cmos_exit);
 
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

origin.patch
linux-next.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio.patch
leds-fix-coding-style-in-worker-thread-code-for-ledtrig-gpio-checkpatch-fixes.patch
leds-fix-multiple-requests-and-releases-of-irq-for-gpio-led-trigger.patch
leds-after-setting-inverted-attribute-we-must-update-the-led.patch

