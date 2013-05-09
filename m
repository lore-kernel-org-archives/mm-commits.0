From: akpm@linux-foundation.org
Subject: [to-be-updated] reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch removed from -mm tree
Date: Thu, 09 May 2013 13:51:44 -0700
Message-ID: <20130509205144.963E05A42C1@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:42092 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3EIUvq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 May 2013 16:51:46 -0400
Received: by mail-yh0-f74.google.com with SMTP id t59so334494yho.5
        for <mm-commits@vger.kernel.org>; Thu, 09 May 2013 13:51:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, gxt@mprc.pku.edu.cn, hpa@zytor.com, linux@arm.linux.org.uk, mingo@elte.hu, rja@sgi.com, shawn.guo@linaro.org, srivatsa.bhat@linux.vnet.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: reboot: unicore32: prepare reboot_mode for moving to generic kernel code.
has been removed from the -mm tree.  Its filename was
     reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: reboot: unicore32: prepare reboot_mode for moving to generic kernel code.

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

 arch/unicore32/kernel/process.c |   10 +++++-----
 arch/unicore32/kernel/setup.h   |    2 +-
 arch/unicore32/mm/mmu.c         |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN arch/unicore32/kernel/process.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/unicore32/kernel/process.c
--- a/arch/unicore32/kernel/process.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/unicore32/kernel/process.c
@@ -51,14 +51,14 @@ void arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-static char reboot_mode = 'h';
+static enum reboot_mode reboot_mode;
 
 int __init reboot_setup(char *str)
 {
-	reboot_mode = str[0];
+	if ('s' == str[0])
+		reboot_mode = REBOOT_WARM;
 	return 1;
 }
-
 __setup("reboot=", reboot_setup);
 
 void machine_halt(void)
@@ -88,7 +88,7 @@ void machine_restart(char *cmd)
 	 * we may need it to insert some 1:1 mappings so that
 	 * soft boot works.
 	 */
-	setup_mm_for_reboot(reboot_mode);
+	setup_mm_for_reboot();
 
 	/* Clean and invalidate caches */
 	flush_cache_all();
@@ -102,7 +102,7 @@ void machine_restart(char *cmd)
 	/*
 	 * Now handle reboot code.
 	 */
-	if (reboot_mode == 's') {
+	if (reboot_mode == REBOOT_WARM) {
 		/* Jump into ROM at address 0xffff0000 */
 		cpu_reset(VECTORS_BASE);
 	} else {
diff -puN arch/unicore32/kernel/setup.h~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/unicore32/kernel/setup.h
--- a/arch/unicore32/kernel/setup.h~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/unicore32/kernel/setup.h
@@ -22,7 +22,7 @@ extern void puv3_ps2_init(void);
 extern void pci_puv3_preinit(void);
 extern void __init puv3_init_gpio(void);
 
-extern void setup_mm_for_reboot(char mode);
+extern void setup_mm_for_reboot(void);
 
 extern char __stubs_start[], __stubs_end[];
 extern char __vectors_start[], __vectors_end[];
diff -puN arch/unicore32/mm/mmu.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code arch/unicore32/mm/mmu.c
--- a/arch/unicore32/mm/mmu.c~reboot-unicore32-prepare-reboot_mode-for-moving-to-generic-kernel-code
+++ a/arch/unicore32/mm/mmu.c
@@ -445,7 +445,7 @@ void __init paging_init(void)
  * the user-mode pages.  This will then ensure that we have predictable
  * results when turning the mmu off
  */
-void setup_mm_for_reboot(char mode)
+void setup_mm_for_reboot(void)
 {
 	unsigned long base_pmdval;
 	pgd_t *pgd;
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu-fix.patch
cpu-hotplug-provide-a-generic-helper-to-disable-enable-cpu-hotplug.patch
migrate-shutdown-reboot-to-boot-cpu.patch
reboot-arm-remove-unused-restart_mode-fields-from-some-arm-subarchs.patch
reboot-arm-prepare-reboot_mode-for-moving-to-generic-kernel-code.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode.patch
reboot-arm-change-reboot_mode-to-use-enum-reboot_mode-checkpatch-fixes.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix.patch
reboot-move-arch-x86-reboot=-handling-to-generic-kernel-fix-2.patch

