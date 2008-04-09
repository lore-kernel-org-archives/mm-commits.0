From: akpm@linux-foundation.org
Subject: + watchdog-fix-platform-driver-hotplug-coldplug.patch added to -mm tree
Date: Wed, 09 Apr 2008 15:57:42 -0700
Message-ID: <200804092257.m39MvhCf001537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48068 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752913AbYDIW55 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Apr 2008 18:57:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kay.sievers@vrfy.org, dbrownell@users.sourceforge.net, greg@kroah.com, wim@iguana.be


The patch titled
     watchdog: fix platform driver hotplug/coldplug
has been added to the -mm tree.  Its filename is
     watchdog-fix-platform-driver-hotplug-coldplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog: fix platform driver hotplug/coldplug
From: Kay Sievers <kay.sievers@vrfy.org>

Since 43cc71eed1250755986da4c0f9898f9a635cb3bf, the platform modalias is
prefixed with "platform:".  Add MODULE_ALIAS() to the hotpluggable watchdog
drivers, to re-enable auto loading.

[dbrownell@users.sourceforge.net: more drivers; registration fixes]
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/at32ap700x_wdt.c |    3 +++
 drivers/watchdog/at91rm9200_wdt.c |    1 +
 drivers/watchdog/davinci_wdt.c    |    2 ++
 drivers/watchdog/ks8695_wdt.c     |    1 +
 drivers/watchdog/mpc83xx_wdt.c    |    2 ++
 drivers/watchdog/mpcore_wdt.c     |    3 +++
 drivers/watchdog/mtx-1_wdt.c      |    2 ++
 drivers/watchdog/mv64x60_wdt.c    |    1 +
 drivers/watchdog/omap_wdt.c       |    1 +
 drivers/watchdog/pnx4008_wdt.c    |    2 ++
 drivers/watchdog/s3c2410_wdt.c    |    1 +
 drivers/watchdog/txx9wdt.c        |    1 +
 12 files changed, 20 insertions(+)

diff -puN drivers/watchdog/at32ap700x_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/at32ap700x_wdt.c
--- a/drivers/watchdog/at32ap700x_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/at32ap700x_wdt.c
@@ -418,6 +418,9 @@ static int at32_wdt_resume(struct platfo
 #define at32_wdt_resume NULL
 #endif
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:at32_wdt");
+
 static struct platform_driver at32_wdt_driver = {
 	.remove		= __exit_p(at32_wdt_remove),
 	.suspend	= at32_wdt_suspend,
diff -puN drivers/watchdog/at91rm9200_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/at91rm9200_wdt.c
--- a/drivers/watchdog/at91rm9200_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/at91rm9200_wdt.c
@@ -286,3 +286,4 @@ MODULE_AUTHOR("Andrew Victor");
 MODULE_DESCRIPTION("Watchdog driver for Atmel AT91RM9200");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:at91_wdt");
diff -puN drivers/watchdog/davinci_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/davinci_wdt.c
--- a/drivers/watchdog/davinci_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/davinci_wdt.c
@@ -248,6 +248,7 @@ static int davinci_wdt_remove(struct pla
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "watchdog",
+		.owner	= THIS_MODULE,
 	},
 	.probe = davinci_wdt_probe,
 	.remove = davinci_wdt_remove,
@@ -277,3 +278,4 @@ MODULE_PARM_DESC(heartbeat,
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:watchdog");
diff -puN drivers/watchdog/ks8695_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/ks8695_wdt.c
--- a/drivers/watchdog/ks8695_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/ks8695_wdt.c
@@ -306,3 +306,4 @@ MODULE_AUTHOR("Andrew Victor");
 MODULE_DESCRIPTION("Watchdog driver for KS8695");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:ks8695_wdt");
diff -puN drivers/watchdog/mpc83xx_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/mpc83xx_wdt.c
--- a/drivers/watchdog/mpc83xx_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/mpc83xx_wdt.c
@@ -206,6 +206,7 @@ static struct platform_driver mpc83xx_wd
 	.remove		= __devexit_p(mpc83xx_wdt_remove),
 	.driver		= {
 		.name	= "mpc83xx_wdt",
+		.owner	= THIS_MODULE,
 	},
 };
 
@@ -226,3 +227,4 @@ MODULE_AUTHOR("Dave Updegraff, Kumar Gal
 MODULE_DESCRIPTION("Driver for watchdog timer in MPC83xx uProcessor");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:mpc83xx_wdt");
diff -puN drivers/watchdog/mpcore_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/mpcore_wdt.c
--- a/drivers/watchdog/mpcore_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/mpcore_wdt.c
@@ -392,6 +392,9 @@ static int __devexit mpcore_wdt_remove(s
 	return 0;
 }
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:mpcore_wdt");
+
 static struct platform_driver mpcore_wdt_driver = {
 	.probe		= mpcore_wdt_probe,
 	.remove		= __devexit_p(mpcore_wdt_remove),
diff -puN drivers/watchdog/mtx-1_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/mtx-1_wdt.c
--- a/drivers/watchdog/mtx-1_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/mtx-1_wdt.c
@@ -243,6 +243,7 @@ static struct platform_driver mtx1_wdt =
 	.probe = mtx1_wdt_probe,
 	.remove = mtx1_wdt_remove,
 	.driver.name = "mtx1-wdt",
+	.driver.owner = THIS_MODULE,
 };
 
 static int __init mtx1_wdt_init(void)
@@ -262,3 +263,4 @@ MODULE_AUTHOR("Michael Stickel, Florian 
 MODULE_DESCRIPTION("Driver for the MTX-1 watchdog");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:mtx1-wdt");
diff -puN drivers/watchdog/mv64x60_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/mv64x60_wdt.c
--- a/drivers/watchdog/mv64x60_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/mv64x60_wdt.c
@@ -324,3 +324,4 @@ MODULE_AUTHOR("James Chapman <jchapman@k
 MODULE_DESCRIPTION("MV64x60 watchdog driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:" MV64x60_WDT_NAME);
diff -puN drivers/watchdog/omap_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/omap_wdt.c
--- a/drivers/watchdog/omap_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/omap_wdt.c
@@ -387,3 +387,4 @@ module_exit(omap_wdt_exit);
 MODULE_AUTHOR("George G. Davis");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:omap_wdt");
diff -puN drivers/watchdog/pnx4008_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/pnx4008_wdt.c
--- a/drivers/watchdog/pnx4008_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/pnx4008_wdt.c
@@ -321,6 +321,7 @@ static int pnx4008_wdt_remove(struct pla
 static struct platform_driver platform_wdt_driver = {
 	.driver = {
 		.name = "watchdog",
+		.owner	= THIS_MODULE,
 	},
 	.probe = pnx4008_wdt_probe,
 	.remove = pnx4008_wdt_remove,
@@ -354,3 +355,4 @@ MODULE_PARM_DESC(nowayout,
 
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:watchdog");
diff -puN drivers/watchdog/s3c2410_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/s3c2410_wdt.c
--- a/drivers/watchdog/s3c2410_wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/s3c2410_wdt.c
@@ -561,3 +561,4 @@ MODULE_AUTHOR("Ben Dooks <ben@simtec.co.
 MODULE_DESCRIPTION("S3C2410 Watchdog Device Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:s3c2410-wdt");
diff -puN drivers/watchdog/txx9wdt.c~watchdog-fix-platform-driver-hotplug-coldplug drivers/watchdog/txx9wdt.c
--- a/drivers/watchdog/txx9wdt.c~watchdog-fix-platform-driver-hotplug-coldplug
+++ a/drivers/watchdog/txx9wdt.c
@@ -274,3 +274,4 @@ module_exit(watchdog_exit);
 MODULE_DESCRIPTION("TXx9 Watchdog Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
+MODULE_ALIAS("platform:txx9wdt");
_

Patches currently in -mm which might be from kay.sievers@vrfy.org are

i2c-fix-platform-driver-hotplug-coldplug.patch
spi-fix-platform-driver-hotplug-coldplug.patch
usb-gadget-fix-platform-driver-hotplug-coldplug.patch
usb-host-fix-platform-driver-hotplug-coldplug.patch
watchdog-fix-platform-driver-hotplug-coldplug.patch
rtc-fix-platform-driver-hotplug-coldplug.patch
pm-remove-destroy_suspended_device.patch
sysfs-refill-attribute-buffer-when-reading-from-offset-0.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-platform-bus-type-rev-3.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
infrastructure-to-debug-dynamic-objects.patch
debugobjects-add-documentation.patch
debugobjects-add-timer-specific-object-debugging-code.patch
add-hrtimer-specific-debugobjects-code.patch
cpu-change-cpu_sys_devices-from-array-to-per_cpu-variable.patch

