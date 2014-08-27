From: akpm@linux-foundation.org
Subject: + arm-arm64-unexport-restart-handlers.patch added to -mm tree
Date: Wed, 27 Aug 2014 14:24:43 -0700
Message-ID: <53fe4c9b.JzFiF4XupwfoYU3/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:55119 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935908AbaH0VYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Aug 2014 17:24:46 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so327746pab.0
        for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2014 14:24:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@roeck-us.net, arnd@arndb.de, catalin.marinas@arm.com, dbaryshkov@gmail.com, dwmw2@infradead.org, heiko@sntech.de, jonas.jensen@gmail.com, linux@arm.linux.org.uk, maxime.ripard@free-electrons.com, mingo@kernel.org, rdunlap@infradead.org, rostedt@goodmis.org, t.figa@samsung.com, will.deacon@arm.com, wim@iguana.be, mm-commits@vger.kernel.org


The patch titled
     Subject: arm/arm64: unexport restart handlers
has been added to the -mm tree.  Its filename is
     arm-arm64-unexport-restart-handlers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-arm64-unexport-restart-handlers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-arm64-unexport-restart-handlers.patch

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
@@ -98,7 +98,6 @@ void (*pm_power_off)(void);
 EXPORT_SYMBOL_GPL(pm_power_off);
 
 void (*arm_pm_restart)(enum reboot_mode reboot_mode, const char *cmd);
-EXPORT_SYMBOL_GPL(arm_pm_restart);
 
 /*
  * This is our default idle handler.
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

