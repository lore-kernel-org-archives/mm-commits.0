From: akpm@linux-foundation.org
Subject: [merged]
 watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch removed from -mm tree
Date: Tue, 30 Sep 2014 14:20:58 -0700
Message-ID: <542b1eba.3TMD0mrjg69wSJV2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaI3VU7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 17:20:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: watchdog: alim7101: register restart handler with kernel restart handler
has been removed from the -mm tree.  Its filename was
     watchdog-alim7101-register-restart-handler-with-kernel-restart-handler.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

documentation-dt-bindings-trickle-charger-dt-binding-document-for-ds1339.patch
rtc-ds1307-add-trickle-charger-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-bq32000-add-trickle-charger-device-tree-binding.patch
linux-next.patch
watchdog-s3c2410-add-restart-handler.patch
clk-samsung-register-restart-handlers-for-s3c2412-and-s3c2443.patch
clk-rockchip-add-restart-handler.patch

