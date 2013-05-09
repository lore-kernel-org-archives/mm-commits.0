From: akpm@linux-foundation.org
Subject: [to-be-updated] reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch removed from -mm tree
Date: Thu, 09 May 2013 13:51:47 -0700
Message-ID: <20130509205147.969FC5A4282@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:46007 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3EIUvt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:51:49 -0400
Received: by mail-qa0-f74.google.com with SMTP id i13so358191qae.1
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:51:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: arm: remove unused restart_mode fields from some arm subarchs
has been removed from the -mm tree.  Its filename was
     reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: arm: remove unused restart_mode fields from some arm subarchs

These restart_mode fields are not used at all.  Remove them to make
moving the reboot= cmdline options to the general kernel easier.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ebsa110/core.c |    1 -
 arch/arm/mach-pxa/mioa701.c  |    1 -
 arch/arm/mach-pxa/spitz.c    |    3 ---
 arch/arm/mach-pxa/tosa.c     |    1 -
 4 files changed, 6 deletions(-)

diff -puN arch/arm/mach-ebsa110/core.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-ebsa110/core.c
--- a/arch/arm/mach-ebsa110/core.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-ebsa110/core.c
@@ -321,7 +321,6 @@ MACHINE_START(EBSA110, "EBSA110")
 	.atag_offset	= 0x400,
 	.reserve_lp0	= 1,
 	.reserve_lp2	= 1,
-	.restart_mode	= 's',
 	.map_io		= ebsa110_map_io,
 	.init_early	= ebsa110_init_early,
 	.init_irq	= ebsa110_init_irq,
diff -puN arch/arm/mach-pxa/mioa701.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-pxa/mioa701.c
--- a/arch/arm/mach-pxa/mioa701.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-pxa/mioa701.c
@@ -756,7 +756,6 @@ static void mioa701_machine_exit(void)
 
 MACHINE_START(MIOA701, "MIO A701")
 	.atag_offset	= 0x100,
-	.restart_mode	= 's',
 	.map_io		= &pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
 	.init_irq	= &pxa27x_init_irq,
diff -puN arch/arm/mach-pxa/spitz.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-pxa/spitz.c
--- a/arch/arm/mach-pxa/spitz.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-pxa/spitz.c
@@ -979,7 +979,6 @@ static void __init spitz_fixup(struct ta
 
 #ifdef CONFIG_MACH_SPITZ
 MACHINE_START(SPITZ, "SHARP Spitz")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
@@ -993,7 +992,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_BORZOI
 MACHINE_START(BORZOI, "SHARP Borzoi")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
@@ -1007,7 +1005,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_AKITA
 MACHINE_START(AKITA, "SHARP Akita")
-	.restart_mode	= 'g',
 	.fixup		= spitz_fixup,
 	.map_io		= pxa27x_map_io,
 	.nr_irqs	= PXA_NR_IRQS,
diff -puN arch/arm/mach-pxa/tosa.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs arch/arm/mach-pxa/tosa.c
--- a/arch/arm/mach-pxa/tosa.c~reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs
+++ a/arch/arm/mach-pxa/tosa.c
@@ -969,7 +969,6 @@ static void __init fixup_tosa(struct tag
 }
 
 MACHINE_START(TOSA, "SHARP Tosa")
-	.restart_mode	= 'g',
 	.fixup          = fixup_tosa,
 	.map_io         = pxa25x_map_io,
 	.nr_irqs	= TOSA_NR_IRQS,
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
migrate-shutdown-reboot-to-boot-cpu.patch
reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch

