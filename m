From: akpm@linux-foundation.org
Subject: [merged]
 power-restart-call-machine_restart-instead-of-arm_pm_restart.patch removed
 from -mm tree
Date: Tue, 30 Sep 2014 14:20:50 -0700
Message-ID: <542b1eb2./sElxjLa0Z74Gm29%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbaI3VUv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 17:20:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: power/restart: call machine_restart instead of arm_pm_restart
has been removed from the -mm tree.  Its filename was
     power-restart-call-machine_restart-instead-of-arm_pm_restart.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: power/restart: call machine_restart instead of arm_pm_restart

machine_restart is supported on non-ARM platforms, and and ultimately
calls arm_pm_restart, so dont call arm_pm_restart directly but use the
more generic function.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/reset/restart-poweroff.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/power/reset/restart-poweroff.c~power-restart-call-machine_restart-instead-of-arm_pm_restart drivers/power/reset/restart-poweroff.c
--- a/drivers/power/reset/restart-poweroff.c~power-restart-call-machine_restart-instead-of-arm_pm_restart
+++ a/drivers/power/reset/restart-poweroff.c
@@ -20,7 +20,8 @@
 
 static void restart_poweroff_do_poweroff(void)
 {
-	arm_pm_restart(REBOOT_HARD, NULL);
+	reboot_mode = REBOOT_HARD;
+	machine_restart(NULL);
 }
 
 static int restart_poweroff_probe(struct platform_device *pdev)
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

