From: akpm@linux-foundation.org
Subject: + watchdog-add-bcm47xx-driver-update.patch added to -mm tree
Date: Fri, 05 Jun 2009 13:49:00 -0700
Message-ID: <200906052049.n55Kn0aS016015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751970AbZFEUtO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Jun 2009 16:49:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: castet.matthieu@free.fr, biblbroks@sezampro.rs, ralf@linux-mips.org, wim@iguana.be


The patch titled
     watchdog-add-bcm47xx-driver-update
has been added to the -mm tree.  Its filename is
     watchdog-add-bcm47xx-driver-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: watchdog-add-bcm47xx-driver-update
From: matthieu castet <castet.matthieu@free.fr>

Cc: Aleksandar Radovanovic <biblbroks@sezampro.rs>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/Kconfig       |    8 +++----
 drivers/watchdog/bcm47xx_wdt.c |   33 ++++++++++++++-----------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff -puN drivers/watchdog/Kconfig~watchdog-add-bcm47xx-driver-update drivers/watchdog/Kconfig
--- a/drivers/watchdog/Kconfig~watchdog-add-bcm47xx-driver-update
+++ a/drivers/watchdog/Kconfig
@@ -784,10 +784,10 @@ config TXX9_WDT
 	  Hardware driver for the built-in watchdog timer on TXx9 MIPS SoCs.
 
 config BCM47XX_WDT
-    tristate "Broadcom BCM47xx Watchdog Timer"
-    depends on BCM47XX
-    help
-      Hardware driver for the Broadcom BCM47xx Watchog Timer.
+	tristate "Broadcom BCM47xx Watchdog Timer"
+	depends on BCM47XX
+	help
+	  Hardware driver for the Broadcom BCM47xx Watchog Timer.
 
 # PARISC Architecture
 
diff -puN drivers/watchdog/bcm47xx_wdt.c~watchdog-add-bcm47xx-driver-update drivers/watchdog/bcm47xx_wdt.c
--- a/drivers/watchdog/bcm47xx_wdt.c~watchdog-add-bcm47xx-driver-update
+++ a/drivers/watchdog/bcm47xx_wdt.c
@@ -2,6 +2,7 @@
  *  Watchdog driver for Broadcom BCM47XX
  *
  *  Copyright (C) 2008 Aleksandar Radovanovic <biblbroks@sezampro.rs>
+ *  Copyright (C) 2009 Matthieu CASTET <castet.matthieu@free.fr>
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -17,7 +18,7 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/notifier.h>
+#include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/watchdog.h>
@@ -45,8 +46,6 @@ MODULE_PARM_DESC(nowayout,
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 #endif
 
-static struct platform_device *bcm47xx_wdt_platform_device;
-
 static unsigned long bcm47xx_wdt_busy;
 static char expect_release;
 static struct timer_list wdt_timer;
@@ -65,12 +64,11 @@ static inline int bcm47xx_wdt_hw_stop(vo
 
 static void bcm47xx_timer_tick(unsigned long unused)
 {
-	if(!atomic_dec_and_test(&ticks)) {
+	if (!atomic_dec_and_test(&ticks)) {
 		bcm47xx_wdt_hw_start();
 		mod_timer(&wdt_timer, jiffies + HZ);
-	}
-	else {
-		printk(KERN_CRIT PFX "Watchdog will fire soon!!!.\n");
+	} else {
+		printk(KERN_CRIT DRV_NAME "Watchdog will fire soon!!!\n");
 	}
 }
 
@@ -87,7 +85,7 @@ static void bcm47xx_wdt_start(void)
 
 static void bcm47xx_wdt_pause(void)
 {
-	del_timer(&wdt_timer);
+	del_timer_sync(&wdt_timer);
 	bcm47xx_wdt_hw_stop();
 }
 
@@ -119,7 +117,8 @@ static int bcm47xx_wdt_release(struct in
 	if (expect_release == 42) {
 		bcm47xx_wdt_stop();
 	} else {
-		printk(KERN_CRIT DRV_NAME ": Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT DRV_NAME
+			": Unexpected close, not stopping watchdog!\n");
 		bcm47xx_wdt_start();
 	}
 
@@ -128,8 +127,8 @@ static int bcm47xx_wdt_release(struct in
 	return 0;
 }
 
-static ssize_t bcm47xx_wdt_write (struct file *file, const char __user *data,
-			      size_t len, loff_t * ppos)
+static ssize_t bcm47xx_wdt_write(struct file *file, const char __user *data,
+			      size_t len, loff_t *ppos)
 {
 	if (len) {
 		if (!nowayout) {
@@ -210,8 +209,8 @@ static long bcm47xx_wdt_ioctl(struct fil
 	}
 }
 
-static int bcm47xx_wdt_notify_sys(struct notifier_block *this, unsigned long code,
-	void *unused)
+static int bcm47xx_wdt_notify_sys(struct notifier_block *this,
+	   unsigned long code, void *unused)
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		bcm47xx_wdt_stop();
@@ -248,13 +247,14 @@ static int __init bcm47xx_wdt_init(void)
 
 	if (bcm47xx_wdt_settimeout(wdt_time)) {
 		bcm47xx_wdt_settimeout(WDT_DEFAULT_TIME);
-		printk(KERN_INFO DRV_NAME ": wdt_time value must be 1 <= wdt_time <= 256, using %d\n",
+		printk(KERN_INFO DRV_NAME
+			": wdt_time value must be 1 <= wdt_time <= 256, using %d\n",
 			wdt_time);
 	}
 
 	ret = register_reboot_notifier(&bcm47xx_wdt_notifier);
 	if (ret)
-		ret;
+		return ret;
 
 	ret = misc_register(&bcm47xx_wdt_miscdev);
 	if (ret) {
@@ -275,8 +275,6 @@ static void __exit bcm47xx_wdt_exit(void
 	misc_deregister(&bcm47xx_wdt_miscdev);
 
 	unregister_reboot_notifier(&bcm47xx_wdt_notifier);
