From: akpm@linux-foundation.org
Subject: + watchdog-orion5x_wdt-fix-compile-issue-by-providing-tclk-as-platform-data.patch added to -mm tree
Date: Tue, 24 Feb 2009 14:59:22 -0800
Message-ID: <200902242259.n1OMxM0Z018456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756143AbZBXXAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 18:00:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: treitmayr@devbase.at, bak@d2.dion.ne.jp, buytenh@wantstofly.org, kristof@sigsegv.be, nico@marvell.com, rmk@arm.linux.org.uk, sylver.bruneau@googlemail.com, tbm@cyrius.com, wim@iguana.be


The patch titled
     watchdog: orion5x_wdt: fix compile issue by providing tclk as platform data
has been added to the -mm tree.  Its filename is
     watchdog-orion5x_wdt-fix-compile-issue-by-providing-tclk-as-platform-data.patch

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
Subject: watchdog: orion5x_wdt: fix compile issue by providing tclk as platform data
From: Thomas Reitmayr <treitmayr@devbase.at>


The orion5x-wdt driver is now registered as a platform device and
receives the tclk value as platform data. This fixes a compile issue
cause by a previously removed define "ORION5X_TCLK".

Signed-off-by: Thomas Reitmayr <treitmayr@devbase.at>
Acked-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Kristof Provost <kristof@sigsegv.be>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
Cc: Kunihiko IMAI <bak@d2.dion.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-orion5x/common.c                 |   29 +++++
 arch/arm/plat-orion/include/plat/orion5x_wdt.h |   18 +++
 drivers/watchdog/orion5x_wdt.c                 |   75 ++++++++++++---
 3 files changed, 109 insertions(+), 13 deletions(-)

diff -puN arch/arm/mach-orion5x/common.c~watchdog-orion5x_wdt-fix-compile-issue-by-providing-tclk-as-platform-data arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c~watchdog-orion5x_wdt-fix-compile-issue-by-providing-tclk-as-platform-data
+++ a/arch/arm/mach-orion5x/common.c
@@ -31,6 +31,7 @@
 #include <plat/ehci-orion.h>
 #include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
+#include <plat/orion5x_wdt.h>
 #include <plat/time.h>
 #include "common.h"
 
@@ -526,6 +527,29 @@ void __init orion5x_xor_init(void)
 
 
 /*****************************************************************************
+ * Watchdog
+ ****************************************************************************/
+static struct orion5x_wdt_platform_data orion5x_wdt_data = {
+	.tclk			= 0,
+};
+
+static struct platform_device orion5x_wdt_device = {
+	.name		= "orion5x_wdt",
+	.id		= -1,
+	.dev		= {
+		.platform_data	= &orion5x_wdt_data,
+	},
+	.num_resources	= 0,
+};
+
+void __init orion5x_wdt_init(void)
+{
+	orion5x_wdt_data.tclk = orion5x_tclk;
+	platform_device_register(&orion5x_wdt_device);
+}
+
+
+/*****************************************************************************
  * Time handling
  ****************************************************************************/
 int orion5x_tclk;
@@ -624,6 +648,11 @@ void __init orion5x_init(void)
 		printk(KERN_INFO "Orion: Applying 5281 D0 WFI workaround.\n");
 		disable_hlt();
 	}
+
+	/*
+	 * Register watchdog driver
+	 */
+	orion5x_wdt_init();
 }
 
 /*
diff -puN /dev/null arch/arm/plat-orion/include/plat/orion5x_wdt.h
--- /dev/null
+++ a/arch/arm/plat-orion/include/plat/orion5x_wdt.h
@@ -0,0 +1,18 @@
+/*
+ * arch/arm/plat-orion/include/plat/orion5x_wdt.h
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef __PLAT_ORION5X_WDT_H
+#define __PLAT_ORION5X_WDT_H
+
+struct orion5x_wdt_platform_data {
+	u32	tclk;		/* no <linux/clk.h> support yet */
+};
+
+
+#endif
+
diff -puN drivers/watchdog/orion5x_wdt.c~watchdog-orion5x_wdt-fix-compile-issue-by-providing-tclk-as-platform-data drivers/watchdog/orion5x_wdt.c
--- a/drivers/watchdog/orion5x_wdt.c~watchdog-orion5x_wdt-fix-compile-issue-by-providing-tclk-as-platform-data
+++ a/drivers/watchdog/orion5x_wdt.c
@@ -16,11 +16,13 @@
 #include <linux/kernel.h>
 #include <linux/fs.h>
 #include <linux/miscdevice.h>
+#include <linux/platform_device.h>
 #include <linux/watchdog.h>
 #include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/spinlock.h>
+#include <plat/orion5x_wdt.h>
 
 /*
  * Watchdog timer block registers.
@@ -29,12 +31,14 @@
 #define  WDT_EN			0x0010
 #define WDT_VAL			(TIMER_VIRT_BASE + 0x0024)
 
-#define WDT_MAX_DURATION	(0xffffffff / ORION5X_TCLK)
+#define WDT_MAX_CYCLE_COUNT	0xffffffff
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
 
 static int nowayout = WATCHDOG_NOWAYOUT;
-static int heartbeat =  WDT_MAX_DURATION;	/* (seconds) */
+static int heartbeat = -1;		/* module parameter (seconds) */
+static unsigned int wdt_max_duration;	/* (seconds) */
+static unsigned int wdt_tclk;
 static unsigned long wdt_status;
 static spinlock_t wdt_lock;
 
@@ -45,7 +49,7 @@ static void wdt_enable(void)
 	spin_lock(&wdt_lock);
 
 	/* Set watchdog duration */
-	writel(ORION5X_TCLK * heartbeat, WDT_VAL);
+	writel(wdt_tclk * heartbeat, WDT_VAL);
 
 	/* Clear watchdog timer interrupt */
 	reg = readl(BRIDGE_CAUSE);
@@ -87,7 +91,7 @@ static void wdt_disable(void)
 static int orion5x_wdt_get_timeleft(int *time_left)
 {
 	spin_lock(&wdt_lock);
-	*time_left = readl(WDT_VAL) / ORION5X_TCLK;
+	*time_left = readl(WDT_VAL) / wdt_tclk;
 	spin_unlock(&wdt_lock);
 	return 0;
 }
@@ -157,7 +161,7 @@ static long orion5x_wdt_ioctl(struct fil
 		if (ret)
 			break;
 
-		if (time <= 0 || time > WDT_MAX_DURATION) {
+		if (time <= 0 || time > wdt_max_duration) {
 			ret = -EINVAL;
 			break;
 		}
@@ -209,23 +213,69 @@ static struct miscdevice orion5x_wdt_mis
 	.fops		= &orion5x_wdt_fops,
 };
 
-static int __init orion5x_wdt_init(void)
+static int __devinit orion5x_wdt_probe(struct platform_device *pdev)
 {
+	struct orion5x_wdt_platform_data *pdata = pdev->dev.platform_data;
 	int ret;
 
-	spin_lock_init(&wdt_lock);
+	if (pdata) {
+		wdt_tclk = pdata->tclk;
+	} else {
+		printk(KERN_ERR "Orion5x Watchdog misses platform data\n");
+		return -ENODEV;
+	}
+
+	if (orion5x_wdt_miscdev.parent)
+		return -EBUSY;
+	orion5x_wdt_miscdev.parent = &pdev->dev;
+
+	wdt_max_duration = WDT_MAX_CYCLE_COUNT / wdt_tclk;
+	if (heartbeat <= 0 || heartbeat > wdt_max_duration)
+		heartbeat = wdt_max_duration;
 
 	ret = misc_register(&orion5x_wdt_miscdev);
-	if (ret == 0)
-		printk("Orion5x Watchdog Timer: heartbeat %d sec\n",
-								heartbeat);
+	if (ret)
+		return ret;
+
+	printk(KERN_INFO "Orion5x Watchdog Timer: Initial timeout %d sec%s\n",
+				heartbeat, nowayout ? ", nowayout" : "");
+	return 0;
+}
+
+static int __devexit orion5x_wdt_remove(struct platform_device *pdev)
+{
+	int ret;
+
+	if (test_bit(WDT_IN_USE, &wdt_status)) {
+		wdt_disable();
+		clear_bit(WDT_IN_USE, &wdt_status);
+	}
+
+	ret = misc_deregister(&orion5x_wdt_miscdev);
+	if (!ret)
+		orion5x_wdt_miscdev.parent = NULL;
 
 	return ret;
 }
 
+static struct platform_driver orion5x_wdt_driver = {
+	.probe		= orion5x_wdt_probe,
+	.remove		= __devexit_p(orion5x_wdt_remove),
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= "orion5x_wdt",
+	},
+};
+
+static int __init orion5x_wdt_init(void)
+{
+	spin_lock_init(&wdt_lock);
+	return platform_driver_register(&orion5x_wdt_driver);
+}
+
 static void __exit orion5x_wdt_exit(void)
 {
-	misc_deregister(&orion5x_wdt_miscdev);
+	platform_driver_unregister(&orion5x_wdt_driver);
 }
 
 module_init(orion5x_wdt_init);
@@ -235,8 +285,7 @@ MODULE_AUTHOR("Sylver Bruneau <sylver.br
 MODULE_DESCRIPTION("Orion5x Processor Watchdog");
 
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default is "
-					__MODULE_STRING(WDT_MAX_DURATION) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds");
 
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
_

Patches currently in -mm which might be from treitmayr@devbase.at are

watchdog-orion5x_wdt-fix-compile-issue-by-providing-tclk-as-platform-data.patch

