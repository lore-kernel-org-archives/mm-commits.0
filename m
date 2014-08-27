From: akpm@linux-foundation.org
Subject: +
 watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch added to -mm tree
Date: Wed, 27 Aug 2014 14:24:41 -0700
Message-ID: <53fe4c99.3TbmsYN1njSE3QU4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:56465 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935888AbaH0VYm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:24:42 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so327699pab.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:24:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: alim7101: register restart handler with kernel restart handler
has been added to the -mm tree.  Its filename is
     watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch

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
Subject: watchdog: alim7101: register restart handler with kernel restart handler

The kernel core now provides an API to trigger a system restart.  Register
with it to restart the system instead of misusing the reboot notifier.

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

 drivers/watchdog/alim7101_wdt.c |   42 ++++++++++++++++++++++--------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff -puN drivers/watchdog/alim7101_wdt.c~watchdog-alim7101-register-restart-handler-with-kernel-restart-handler drivers/watchdog/alim7101_wdt.c
--- a/drivers/watchdog/alim7101_wdt.c~watchdog-alim7101-register-restart-handler-with-kernel-restart-handler
+++ a/drivers/watchdog/alim7101_wdt.c
@@ -301,6 +301,28 @@ static struct miscdevice wdt_miscdev = {
 	.fops	=	&wdt_fops,
 };
 
+static int wdt_restart_handle(struct notifier_block *this, unsigned long mode,
+			      void *cmd)
+{
+	/*
+	 * Cobalt devices have no way of rebooting themselves other
+	 * than getting the watchdog to pull reset, so we restart the
+	 * watchdog on reboot with no heartbeat.
+	 */
+	wdt_change(WDT_ENABLE);
+
+	/* loop until the watchdog fires */
+	while (true)
+		;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block wdt_restart_handler = {
+	.notifier_call = wdt_restart_handle,
+	.priority = 128,
+};
+
 /*
  *	Notifier for system down
  */
@@ -311,15 +333,6 @@ static int wdt_notify_sys(struct notifie
 	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 
-	if (code == SYS_RESTART) {
-		/*
-		 * Cobalt devices have no way of rebooting themselves other
-		 * than getting the watchdog to pull reset, so we restart the
-		 * watchdog on reboot with no heartbeat
-		 */
-		wdt_change(WDT_ENABLE);
-		pr_info("Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second\n");
-	}
 	return NOTIFY_DONE;
 }
 
@@ -338,6 +351,7 @@ static void __exit alim7101_wdt_unload(v
 	/* Deregister */
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
+	unregister_restart_handler(&wdt_restart_handler);
 	pci_dev_put(alim7101_pmu);
 }
 
@@ -390,11 +404,17 @@ static int __init alim7101_wdt_init(void
 		goto err_out;
 	}
 
+	rc = register_restart_handler(&wdt_restart_handler);
+	if (rc) {
+		pr_err("cannot register restart handler (err=%d)\n", rc);
+		goto err_out_reboot;
+	}
+
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
 		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 		       wdt_miscdev.minor, rc);
-		goto err_out_reboot;
+		goto err_out_restart;
 	}
 
 	if (nowayout)
@@ -404,6 +424,8 @@ static int __init alim7101_wdt_init(void
 		timeout, nowayout);
 	return 0;
 
+err_out_restart:
+	unregister_restart_handler(&wdt_restart_handler);
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out:
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

