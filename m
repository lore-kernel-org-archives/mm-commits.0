From: akpm@linux-foundation.org
Subject: + reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch added to -mm tree
Date: Wed, 08 May 2013 13:45:28 -0700
Message-ID: <20130508204529.057D031C082@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:41645 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3EHUpa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 May 2013 16:45:30 -0400
Received: by mail-vc0-f201.google.com with SMTP id hz10so222599vcb.4
        for <mm-commits@vger.kernel.org>; Wed, 08 May 2013 13:45:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de


The patch titled
     Subject: reboot: arm: remove unused restart_mode fields from some arm subarchs
has been added to the -mm tree.  Its filename is
     reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
kernel-sysc-remove-stable-friendly-pf_thread_bound-define.patch
reboot-move-shutdown-reboot-related-functions-to-kernel-rebootc.patch
reboot-checkpatchpl-the-new-kernel-rebootc-file.patch
reboot-x86-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch
reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch

