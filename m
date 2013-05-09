From: akpm@linux-foundation.org
Subject: [to-be-updated] reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch removed from -mm tree
Date: Thu, 09 May 2013 13:51:50 -0700
Message-ID: <20130509205150.9935E5A4282@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:54473 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab3EIUvw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:51:52 -0400
Received: by mail-vb0-f73.google.com with SMTP id e13so333564vbg.2
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:51:51 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: arm: prepare reboot_mode for moving to generic kernel code.
has been removed from the -mm tree.  Its filename was
     reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: arm: prepare reboot_mode for moving to generic kernel code.

Prepare for the moving the parsing of reboot= to the generic kernel code
by making reboot_mode into a more generic form.

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

 arch/arm/include/asm/mach/arch.h   |    3 ++-
 arch/arm/kernel/process.c          |    8 ++++----
 arch/arm/kernel/setup.c            |    6 +++---
 arch/arm/mach-footbridge/cats-hw.c |    2 +-
 4 files changed, 10 insertions(+), 9 deletions(-)

diff -puN arch/arm/include/asm/mach/arch.h~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/include/asm/mach/arch.h
--- a/arch/arm/include/asm/mach/arch.h~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/include/asm/mach/arch.h
@@ -9,6 +9,7 @@
  */
 
 #ifndef __ASSEMBLY__
+#include <linux/reboot.h>
 
 struct tag;
 struct meminfo;
@@ -39,7 +40,7 @@ struct machine_desc {
 	unsigned char		reserve_lp0 :1;	/* never has lp0	*/
 	unsigned char		reserve_lp1 :1;	/* never has lp1	*/
 	unsigned char		reserve_lp2 :1;	/* never has lp2	*/
-	char			restart_mode;	/* default restart mode	*/
+	enum reboot_mode	reboot_mode;	/* default restart mode	*/
 	struct smp_operations	*smp;		/* SMP operations	*/
 	void			(*fixup)(struct tag *, char **,
 					 struct meminfo *);
diff -puN arch/arm/kernel/process.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/kernel/process.c
--- a/arch/arm/kernel/process.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/kernel/process.c
@@ -174,14 +174,14 @@ void arch_cpu_idle(void)
 		default_idle();
 }
 
-static char reboot_mode = 'h';
+enum reboot_mode reboot_mode;
 
-int __init reboot_setup(char *str)
+static int __init reboot_setup(char *str)
 {
-	reboot_mode = str[0];
+	if ('s' == str[0])
+		reboot_mode = REBOOT_WARM;
 	return 1;
 }
-
 __setup("reboot=", reboot_setup);
 
 void machine_shutdown(void)
diff -puN arch/arm/kernel/setup.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/kernel/setup.c
--- a/arch/arm/kernel/setup.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/kernel/setup.c
@@ -73,7 +73,7 @@ __setup("fpe=", fpe_setup);
 
 extern void paging_init(struct machine_desc *desc);
 extern void sanity_check_meminfo(void);
-extern void reboot_setup(char *str);
+extern enum reboot_mode reboot_mode;
 extern void setup_dma_zone(struct machine_desc *desc);
 
 unsigned int processor_id;
@@ -782,8 +782,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_dma_zone(mdesc);
 
-	if (mdesc->restart_mode)
-		reboot_setup(&mdesc->restart_mode);
+	if (mdesc->reboot_mode != REBOOT_COLD)
+		reboot_mode = mdesc->reboot_mode;
 
 	init_mm.start_code = (unsigned long) _text;
 	init_mm.end_code   = (unsigned long) _etext;
diff -puN arch/arm/mach-footbridge/cats-hw.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/arm/mach-footbridge/cats-hw.c
--- a/arch/arm/mach-footbridge/cats-hw.c~reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/arm/mach-footbridge/cats-hw.c
@@ -86,7 +86,7 @@ fixup_cats(struct tag *tags, char **cmdl
 MACHINE_START(CATS, "Chalice-CATS")
 	/* Maintainer: Philip Blundell */
 	.atag_offset	= 0x100,
-	.restart_mode	= 's',
+	.reboot_mode	= REBOOT_WARM,
 	.fixup		= fixup_cats,
 	.map_io		= footbridge_map_io,
 	.init_irq	= footbridge_init_irq,
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
migrate-shutdown-reboot-to-boot-cpu.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch

