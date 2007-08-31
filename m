From: akpm@linux-foundation.org
Subject: + hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:11:49 -0700
Message-ID: <200708311811.l7VIBnjU020153@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41863 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965758AbXHaSMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ak@suse.de, pavel@ucw.cz


The patch titled
     Hibernation: Pass CR3 in the image header on x86_64
has been added to the -mm tree.  Its filename is
     hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Hibernation: Pass CR3 in the image header on x86_64
From: Rafael J. Wysocki <rjw@sisk.pl>

Since we already pass the address of restore_registers() in the image header,
we can also pass the value of the CR3 register from before the hibernation in
the same way.  This will allow us to avoid using init_level4_pgt page tables
during the restore.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/suspend.c     |   16 ++++++++++++----
 arch/x86_64/kernel/suspend_asm.S |    8 +++++---
 2 files changed, 17 insertions(+), 7 deletions(-)

diff -puN arch/x86_64/kernel/suspend.c~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2 arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2
+++ a/arch/x86_64/kernel/suspend.c
@@ -151,6 +151,12 @@ extern int restore_image(void);
  */
 unsigned long restore_jump_address;
 
+/*
+ * Value of the cr3 register from before the hibernation (this value is passed
+ * in the image header).
+ */
+unsigned long restore_cr3;
+
 pgd_t *temp_level4_pgt;
 
 void *relocated_restore_code;
@@ -249,7 +255,8 @@ int pfn_is_nosave(unsigned long pfn)
 
 struct restore_data_record {
 	unsigned long jump_address;
-	unsigned long control;
+	unsigned long cr3;
+	unsigned long magic;
 };
 
 #define RESTORE_MAGIC	0x0123456789ABCDEFUL
@@ -266,7 +273,8 @@ int arch_hibernation_header_save(void *a
 	if (max_size < sizeof(struct restore_data_record))
 		return -EOVERFLOW;
 	rdr->jump_address = restore_jump_address;
-	rdr->control = (restore_jump_address ^ RESTORE_MAGIC);
+	rdr->cr3 = restore_cr3;
+	rdr->magic = RESTORE_MAGIC;
 	return 0;
 }
 
@@ -280,7 +288,7 @@ int arch_hibernation_header_restore(void
 	struct restore_data_record *rdr = addr;
 
 	restore_jump_address = rdr->jump_address;
-	return (rdr->control == (restore_jump_address ^ RESTORE_MAGIC)) ?
-			0 : -EINVAL;
+	restore_cr3 = rdr->cr3;
+	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
 }
 #endif /* CONFIG_HIBERNATION */
diff -puN arch/x86_64/kernel/suspend_asm.S~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2 arch/x86_64/kernel/suspend_asm.S
--- a/arch/x86_64/kernel/suspend_asm.S~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2
+++ a/arch/x86_64/kernel/suspend_asm.S
@@ -39,6 +39,9 @@ ENTRY(swsusp_arch_suspend)
 	/* save the address of restore_registers */
 	movq	$restore_registers, %rax
 	movq	%rax, restore_jump_address(%rip)
+	/* save cr3 */
+	movq	%cr3, %rax
+	movq	%rax, restore_cr3(%rip)
 
 	call swsusp_save
 	ret
@@ -60,6 +63,7 @@ ENTRY(restore_image)
 
 	/* prepare to jump to the image kernel */
 	movq	restore_jump_address(%rip), %rax
+	movq	restore_cr3(%rip), %rbx
 
 	/* prepare to copy image data to their original locations */
 	movq	restore_pblist(%rip), %rdx
@@ -98,9 +102,7 @@ done:
 
 ENTRY(restore_registers)
 	/* go back to the original page tables */
-	movq    $(init_level4_pgt - __START_KERNEL_map), %rax
-	addq    phys_base(%rip), %rax
-	movq    %rax, %cr3
+	movq    %rbx, %cr3
 
 	/* Flush TLB, including "global" things (vmalloc) */
 	movq	mmu_cr4_features(%rip), %rax
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
uli526x-add-suspend-and-resume-routines.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch
