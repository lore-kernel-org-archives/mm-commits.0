From: akpm@linux-foundation.org
Subject: [merged]
 arm-support-restart-through-restart-handler-call-chain.patch removed from
 -mm tree
Date: Tue, 30 Sep 2014 14:20:54 -0700
Message-ID: <542b1eb6.YLtt9MjzTiFOM/g3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaI3VUz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 17:20:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: support restart through restart handler call chain
has been removed from the -mm tree.  Its filename was
     arm-support-restart-through-restart-handler-call-chain.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: arm: support restart through restart handler call chain

The kernel core now supports a restart handler call chain for system
restart functions.

With this change, the arm_pm_restart callback is now optional, so drop its
initialization and check if it is set before calling it.  Only call the
kernel restart handler if arm_pm_restart is not set.

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

 arch/arm/kernel/process.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN arch/arm/kernel/process.c~arm-support-restart-through-restart-handler-call-chain arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~arm-support-restart-through-restart-handler-call-chain
+++ a/arch/arm/kernel/process.c
@@ -114,17 +114,13 @@ void soft_restart(unsigned long addr)
 	BUG();
 }
 
-static void null_restart(enum reboot_mode reboot_mode, const char *cmd)
-{
-}
-
 /*
  * Function pointers to optional machine specific functions
  */
 void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
-void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd) = null_restart;
+void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
 EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 /*
@@ -230,7 +226,10 @@ void machine_restart(char *cmd)
 	local_irq_disable();
 	smp_send_stop();
 
-	arm_pm_restart(reboot_mode, cmd);
+	if (arm_pm_restart)
+		arm_pm_restart(reboot_mode, cmd);
+	else
+		do_kernel_restart(cmd);
 
 	/* Give a grace period for failure to restart of 1s */
 	mdelay(1000);
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

