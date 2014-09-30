From: akpm@linux-foundation.org
Subject: [merged] arm-arm64-unexport-restart-handlers.patch removed from
 -mm tree
Date: Tue, 30 Sep 2014 14:21:02 -0700
Message-ID: <542b1ebe.9uuczsUxLcZCFWer%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaI3VVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Sep 2014 17:21:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: arm/arm64: unexport restart handlers
has been removed from the -mm tree.  Its filename was
     arm-arm64-unexport-restart-handlers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guenter Roeck <linux@roeck-us.net>
Subject: arm/arm64: unexport restart handlers

Implementing a restart handler in a module don't make sense as there would
be no guarantee that the module is loaded when a restart is needed. 
Unexport arm_pm_restart to ensure that no one gets the idea to do it
anyway.

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

 arch/arm/kernel/process.c   |    1 -
 arch/arm64/kernel/process.c |    1 -
 2 files changed, 2 deletions(-)

diff -puN arch/arm/kernel/process.c~arm-arm64-unexport-restart-handlers arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~arm-arm64-unexport-restart-handlers
+++ a/arch/arm/kernel/process.c
@@ -121,7 +121,6 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL(pm_power_off);
 
 void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
-EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 /*
  * This is our default idle handler.
diff -puN arch/arm64/kernel/process.c~arm-arm64-unexport-restart-handlers arch/arm64/kernel/process.c
--- a/arch/arm64/kernel/process.c~arm-arm64-unexport-restart-handlers
+++ a/arch/arm64/kernel/process.c
@@ -72,7 +72,6 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL_GPL(pm_power_off);
 
 void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
-EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 /*
  * This is our default idle handler.
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

