From: akpm@linux-foundation.org
Subject: + watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate.patch added to -mm tree
Date: Tue, 24 Feb 2009 12:46:15 -0800
Message-ID: <200902242046.n1OKkFI1009725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbZBXUq6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 15:46:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Kristof@sigsegv.be, buytenh@wantstofly.org, kristof@sigsegv.be, nico@cam.org, rmk@arm.linux.org.uk, wim@iguana.be


The patch titled
     watchdog: make orion5x_wdt aware of runtime-determined timer tick rate
has been added to the -mm tree.  Its filename is
     watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate.patch

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
Subject: watchdog: make orion5x_wdt aware of runtime-determined timer tick rate
From: Kristof Provost <Kristof@sigsegv.be>

orion5x_wdt no longer compiled after the changes in
ebe35aff883496c07248df82c8576c3b6e84bbbe ("Orion: prepare for
runtime-determined timer tick rate").

The tick rate define (ORION5X_TCLK) was removed in favor of a runtime
detection.  This value is now passed to the watchdog timer.

Signed-off-by: Kristof Provost <kristof@sigsegv.be>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Nicolas Pitre <nico@cam.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-orion5x/common.c                |   17 +++++
 arch/arm/mach-orion5x/common.h                |    1 
 arch/arm/mach-orion5x/include/mach/hardware.h |    3 +
 arch/arm/mach-orion5x/ts78xx-setup.c          |    1 
 arch/arm/plat-orion/include/plat/wdt.h        |   14 ++++
 drivers/watchdog/orion5x_wdt.c                |   47 ++++++++++++----
 6 files changed, 72 insertions(+), 11 deletions(-)

diff -puN arch/arm/mach-orion5x/common.c~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate arch/arm/mach-orion5x/common.c
--- a/arch/arm/mach-orion5x/common.c~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate
+++ a/arch/arm/mach-orion5x/common.c
@@ -32,6 +32,7 @@
 #include <plat/mv_xor.h>
 #include <plat/orion_nand.h>
 #include <plat/time.h>
+#include <plat/wdt.h>
 #include "common.h"
 
 /*****************************************************************************
@@ -427,6 +428,21 @@ void __init orion5x_uart1_init(void)
 	platform_device_register(&orion5x_uart1);
 }
 
+static struct orion5x_wdt_platform_data orion5x_wdt_data = {
+	.tclk = 0,
+};
+
+static struct platform_device orion5x_wdt = {
+	.name = "orion5x_wdt",
+	.dev  = {
+		.platform_data = &orion5x_wdt_data,
+	},
+};
+
+void __init orion5x_wdt_init(void)
+{
+	platform_device_register(&orion5x_wdt);
+}
 
 /*****************************************************************************
  * XOR engine
@@ -610,6 +626,7 @@ void __init orion5x_init(void)
 	orion5x_spi_plat_data.tclk = orion5x_tclk;
 	orion5x_uart0_data[0].uartclk = orion5x_tclk;
 	orion5x_uart1_data[0].uartclk = orion5x_tclk;
+	orion5x_wdt_data.tclk = orion5x_tclk;
 
 	/*
 	 * Setup Orion address map
diff -puN arch/arm/mach-orion5x/common.h~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate arch/arm/mach-orion5x/common.h
--- a/arch/arm/mach-orion5x/common.h~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate
+++ a/arch/arm/mach-orion5x/common.h
@@ -36,6 +36,7 @@ void orion5x_sata_init(struct mv_sata_pl
 void orion5x_spi_init(void);
 void orion5x_uart0_init(void);
 void orion5x_uart1_init(void);
+void orion5x_wdt_init(void);
 void orion5x_xor_init(void);
 
 /*
diff -puN arch/arm/mach-orion5x/include/mach/hardware.h~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate arch/arm/mach-orion5x/include/mach/hardware.h
--- a/arch/arm/mach-orion5x/include/mach/hardware.h~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate
+++ a/arch/arm/mach-orion5x/include/mach/hardware.h
@@ -17,5 +17,8 @@
 #define PCIBIOS_MIN_MEM		0x01000000
 #define PCIMEM_BASE		ORION5X_PCIE_MEM_PHYS_BASE
 
+struct orion_wdt_data {
+	int tclk;
+};
 
 #endif
diff -puN arch/arm/mach-orion5x/ts78xx-setup.c~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate arch/arm/mach-orion5x/ts78xx-setup.c
--- a/arch/arm/mach-orion5x/ts78xx-setup.c~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate
+++ a/arch/arm/mach-orion5x/ts78xx-setup.c
@@ -255,6 +255,7 @@ static void __init ts78xx_init(void)
 	orion5x_sata_init(&ts78xx_sata_data);
 	orion5x_uart0_init();
 	orion5x_uart1_init();
+	orion5x_wdt_init();
 	orion5x_xor_init();
 
 	orion5x_setup_dev_boot_win(TS78XX_NOR_BOOT_BASE,
diff -puN /dev/null arch/arm/plat-orion/include/plat/wdt.h
--- /dev/null
+++ a/arch/arm/plat-orion/include/plat/wdt.h
@@ -0,0 +1,14 @@
+/*
+ * arch/arm/plat-orion/include/plat/wdt.h
+ *
+ * Marvell watchdog platform device data definition file.
+ */
+
+#ifndef __PLAT_WDT_H
+#define __PLAT_WDT_H
+
+struct orion5x_wdt_platform_data {
+	int tclk;
+};
+
+#endif
diff -puN drivers/watchdog/orion5x_wdt.c~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate drivers/watchdog/orion5x_wdt.c
--- a/drivers/watchdog/orion5x_wdt.c~watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate
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
+#include <plat/wdt.h>
 
 /*
  * Watchdog timer block registers.
@@ -29,12 +31,13 @@
 #define  WDT_EN			0x0010
 #define WDT_VAL			(TIMER_VIRT_BASE + 0x0024)
 
-#define WDT_MAX_DURATION	(0xffffffff / ORION5X_TCLK)
 #define WDT_IN_USE		0
 #define WDT_OK_TO_CLOSE		1
 
+struct orion5x_wdt_platform_data *orion5x_wdt_data;
+
 static int nowayout = WATCHDOG_NOWAYOUT;
-static int heartbeat =  WDT_MAX_DURATION;	/* (seconds) */
+static int heartbeat;
 static unsigned long wdt_status;
 static spinlock_t wdt_lock;
 
@@ -45,7 +48,7 @@ static void wdt_enable(void)
 	spin_lock(&wdt_lock);
 
 	/* Set watchdog duration */
-	writel(ORION5X_TCLK * heartbeat, WDT_VAL);
+	writel(orion5x_wdt_data->tclk * heartbeat, WDT_VAL);
 
 	/* Clear watchdog timer interrupt */
 	reg = readl(BRIDGE_CAUSE);
@@ -87,7 +90,7 @@ static void wdt_disable(void)
 static int orion5x_wdt_get_timeleft(int *time_left)
 {
 	spin_lock(&wdt_lock);
-	*time_left = readl(WDT_VAL) / ORION5X_TCLK;
+	*time_left = readl(WDT_VAL) / orion5x_wdt_data->tclk;
 	spin_unlock(&wdt_lock);
 	return 0;
 }
@@ -157,7 +160,7 @@ static long orion5x_wdt_ioctl(struct fil
 		if (ret)
 			break;
 
-		if (time <= 0 || time > WDT_MAX_DURATION) {
+		if (time <= 0 || time * orion5x_wdt_data->tclk > 0xffffffff) {
 			ret = -EINVAL;
 			break;
 		}
@@ -193,7 +196,6 @@ static int orion5x_wdt_release(struct in
 	return 0;
 }
 
-
 static const struct file_operations orion5x_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -205,15 +207,21 @@ static const struct file_operations orio
 
 static struct miscdevice orion5x_wdt_miscdev = {
 	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
+	.name		= "orion5x_wdt",
 	.fops		= &orion5x_wdt_fops,
 };
 
-static int __init orion5x_wdt_init(void)
+static int __init orion5x_wdt_probe(struct platform_device *pdev)
 {
 	int ret;
 
+	orion5x_wdt_data = pdev->dev.platform_data;
+
+	if (!orion5x_wdt_data)
+		return -ENODEV;
+
 	spin_lock_init(&wdt_lock);
+	heartbeat = 0xffffffff / orion5x_wdt_data->tclk;
 
 	ret = misc_register(&orion5x_wdt_miscdev);
 	if (ret == 0)
@@ -223,9 +231,27 @@ static int __init orion5x_wdt_init(void)
 	return ret;
 }
 
+static int __devexit orion5x_wdt_remove(struct platform_device *pdev)
+{
+	return misc_deregister(&orion5x_wdt_miscdev);
+}
+
+static struct platform_driver orion5x_wdt_driver = {
+	.remove = __devexit_p(orion5x_wdt_remove),
+	.driver = {
+		.name = "orion5x_wdt",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init orion5x_wdt_init(void)
+{
+	return platform_driver_probe(&orion5x_wdt_driver, orion5x_wdt_probe);
+}
+
 static void __exit orion5x_wdt_exit(void)
 {
-	misc_deregister(&orion5x_wdt_miscdev);
+	platform_driver_unregister(&orion5x_wdt_driver);
 }
 
 module_init(orion5x_wdt_init);
@@ -235,8 +261,7 @@ MODULE_AUTHOR("Sylver Bruneau <sylver.br
 MODULE_DESCRIPTION("Orion5x Processor Watchdog");
 
 module_param(heartbeat, int, 0);
-MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default is "
-					__MODULE_STRING(WDT_MAX_DURATION) ")");
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds.");
 
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
_

Patches currently in -mm which might be from Kristof@sigsegv.be are

watchdog-make-orion5x_wdt-aware-of-runtime-determined-timer-tick-rate.patch

