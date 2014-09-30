From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
 removed from -mm tree
Date: Tue, 30 Sep 2014 14:21:00 -0700
Message-ID: <542b1ebc.8+KR0FHM5oy7MjG6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbaI3VVC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 17:21:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: sunxi: register restart handler with kernel restart handler
has been removed from the -mm tree.  Its filename was
     watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: watchdog: sunxi: register restart handler with kernel restart handler

The kernel core now provides an API to trigger a system restart.  Register
with it instead of setting arm_pm_restart.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/watchdog/sunxi_wdt.c |   31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff -puN drivers/watchdog/sunxi_wdt.c~watchdog-sunxi-register-restart-handler-with-kernel-restart-handler drivers/watchdog/sunxi_wdt.c
--- a/drivers/watchdog/sunxi_wdt.c~watchdog-sunxi-register-restart-handler-with-kernel-restart-handler
+++ a/drivers/watchdog/sunxi_wdt.c
@@ -21,14 +21,13 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/reboot.h>
 #include <linux/types.h>
 #include <linux/watchdog.h>
 
-#include <asm/system_misc.h>
-
 #define WDT_MAX_TIMEOUT         16
 #define WDT_MIN_TIMEOUT         1
 #define WDT_MODE_TIMEOUT(n)     ((n) << 3)
@@ -50,6 +49,7 @@ static unsigned int timeout = WDT_MAX_TI
 struct sunxi_wdt_dev {
 	struct watchdog_device wdt_dev;
 	void __iomem *wdt_base;
+	struct notifier_block restart_handler;
 };
 
 /*
@@ -74,24 +74,29 @@ static const int wdt_timeout_map[] = {
 	[16] = 0xB, /* 16s */
 };
 
-static void __iomem *reboot_wdt_base;
 
-static void sun4i_wdt_restart(enum reboot_mode mode, const char *cmd)
+static int sunxi_restart_handle(struct notifier_block *this, unsigned long mode,
+				void *cmd)
 {
+	struct sunxi_wdt_dev *sunxi_wdt = container_of(this,
+						       struct sunxi_wdt_dev,
+						       restart_handler);
+	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+
 	/* Enable timer and set reset bit in the watchdog */
-	writel(WDT_MODE_EN | WDT_MODE_RST_EN, reboot_wdt_base + WDT_MODE);
+	writel(WDT_MODE_EN | WDT_MODE_RST_EN, wdt_base + WDT_MODE);
 
 	/*
 	 * Restart the watchdog. The default (and lowest) interval
 	 * value for the watchdog is 0.5s.
 	 */
-	writel(WDT_CTRL_RELOAD, reboot_wdt_base + WDT_CTRL);
+	writel(WDT_CTRL_RELOAD, wdt_base + WDT_CTRL);
 
 	while (1) {
 		mdelay(5);
-		writel(WDT_MODE_EN | WDT_MODE_RST_EN,
-		       reboot_wdt_base + WDT_MODE);
+		writel(WDT_MODE_EN | WDT_MODE_RST_EN, wdt_base + WDT_MODE);
 	}
+	return NOTIFY_DONE;
 }
 
 static int sunxi_wdt_ping(struct watchdog_device *wdt_dev)
@@ -205,8 +210,12 @@ static int sunxi_wdt_probe(struct platfo
 	if (unlikely(err))
 		return err;
 
-	reboot_wdt_base = sunxi_wdt->wdt_base;
-	arm_pm_restart = sun4i_wdt_restart;
+	sunxi_wdt->restart_handler.notifier_call = sunxi_restart_handle;
+	sunxi_wdt->restart_handler.priority = 128;
+	err = register_restart_handler(&sunxi_wdt->restart_handler);
+	if (err)
+		dev_err(&pdev->dev,
+			"cannot register restart handler (err=%d)\n", err);
 
 	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
 			sunxi_wdt->wdt_dev.timeout, nowayout);
@@ -218,7 +227,7 @@ static int sunxi_wdt_remove(struct platf
 {
 	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
+	unregister_restart_handler(&sunxi_wdt->restart_handler);
 
 	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
 	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
_

Patches currently in -mm which might be from linux@roeck-us.net are

documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch
rtc-ds1307-add-trickle-charger-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-device-tree-binding.patch
linux-next.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch

