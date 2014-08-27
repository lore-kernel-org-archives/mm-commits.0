From: akpm@linux-foundation.org
Subject: +
 watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
 added to -mm tree
Date: Wed, 27 Aug 2014 14:24:42 -0700
Message-ID: <53fe4c9a.XO0uOGjy4s5e/zJZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:39366 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935709AbaH0VYo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:24:44 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so325634pab.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:24:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: sunxi: register restart handler with kernel restart handler
has been added to the -mm tree.  Its filename is
     watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kernel-add-support-for-kernel-restart-handler-call-chain.patch
power-restart-call-machine_restart-instead-of-arm_pm_restart.patch
arm64-support-restart-through-restart-handler-call-chain.patch
arm-support-restart-through-restart-handler-call-chain.patch
watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch
watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch
watchdog-sunxi-register-restart-handler-with-kernel-restart-handler.patch
arm-arm64-unexport-restart-handlers.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch
linux-next.patch

