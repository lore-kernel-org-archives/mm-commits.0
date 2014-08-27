From: akpm@linux-foundation.org
Subject: +
 watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch
 added to -mm tree
Date: Wed, 27 Aug 2014 14:24:40 -0700
Message-ID: <53fe4c98.SIXWtkXrurk9fMGJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:62415 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935709AbaH0VYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:24:41 -0400
Received: by mail-ob0-f202.google.com with SMTP id wp18so149986obc.1
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:24:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: moxart: register restart handler with kernel restart handler
has been added to the -mm tree.  Its filename is
     watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-moxart-register-restart-handler-with-kernel-restart-handler.patch

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
Subject: watchdog: moxart: register restart handler with kernel restart handler

The kernel now provides an API to trigger a system restart.  Register with
it instead of setting arm_pm_restart.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Cc: Arnd Bergmann <arnd@arndb.de>
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

 drivers/watchdog/moxart_wdt.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff -puN drivers/watchdog/moxart_wdt.c~watchdog-moxart-register-restart-handler-with-kernel-restart-handler drivers/watchdog/moxart_wdt.c
--- a/drivers/watchdog/moxart_wdt.c~watchdog-moxart-register-restart-handler-with-kernel-restart-handler
+++ a/drivers/watchdog/moxart_wdt.c
@@ -15,12 +15,12 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
+#include <linux/notifier.h>
 #include <linux/platform_device.h>
+#include <linux/reboot.h>
 #include <linux/watchdog.h>
 #include <linux/moduleparam.h>
 
-#include <asm/system_misc.h>
-
 #define REG_COUNT			0x4
 #define REG_MODE			0x8
 #define REG_ENABLE			0xC
@@ -29,17 +29,22 @@ struct moxart_wdt_dev {
 	struct watchdog_device dev;
 	void __iomem *base;
 	unsigned int clock_frequency;
+	struct notifier_block restart_handler;
 };
 
-static struct moxart_wdt_dev *moxart_restart_ctx;
-
 static int heartbeat;
 
-static void moxart_wdt_restart(enum reboot_mode reboot_mode, const char *cmd)
+static int moxart_restart_handle(struct notifier_block *this,
+				 unsigned long mode, void *cmd)
 {
-	writel(1, moxart_restart_ctx->base + REG_COUNT);
-	writel(0x5ab9, moxart_restart_ctx->base + REG_MODE);
-	writel(0x03, moxart_restart_ctx->base + REG_ENABLE);
+	struct moxart_wdt_dev *moxart_wdt = container_of(this,
+							 struct moxart_wdt_dev,
+							 restart_handler);
+	writel(1, moxart_wdt->base + REG_COUNT);
+	writel(0x5ab9, moxart_wdt->base + REG_MODE);
+	writel(0x03, moxart_wdt->base + REG_ENABLE);
+
+	return NOTIFY_DONE;
 }
 
 static int moxart_wdt_stop(struct watchdog_device *wdt_dev)
@@ -136,8 +141,12 @@ static int moxart_wdt_probe(struct platf
 	if (err)
 		return err;
 
-	moxart_restart_ctx = moxart_wdt;
-	arm_pm_restart = moxart_wdt_restart;
+	moxart_wdt->restart_handler.notifier_call = moxart_restart_handle;
+	moxart_wdt->restart_handler.priority = 128;
+	err = register_restart_handler(&moxart_wdt->restart_handler);
+	if (err)
+		dev_err(dev, "cannot register restart notifier (err=%d)\n",
+			err);
 
 	dev_dbg(dev, "Watchdog enabled (heartbeat=%d sec, nowayout=%d)\n",
 		moxart_wdt->dev.timeout, nowayout);
@@ -149,9 +158,8 @@ static int moxart_wdt_remove(struct plat
 {
 	struct moxart_wdt_dev *moxart_wdt = platform_get_drvdata(pdev);
 
-	arm_pm_restart = NULL;
+	unregister_restart_handler(&moxart_wdt->restart_handler);
 	moxart_wdt_stop(&moxart_wdt->dev);
-	watchdog_unregister_device(&moxart_wdt->dev);
 
 	return 0;
 }
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

