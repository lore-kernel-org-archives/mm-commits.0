From: akpm@linux-foundation.org
Subject: - hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:41:24 -0700
Message-ID: <200710190341.l9J3fOCA012816@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37359 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934259AbXJSD4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, ak@suse.de, pavel@ucw.cz, mm-commits@vger.kernel.org


The patch titled
     Hibernation: Pass CR3 in the image header on x86_64
has been removed from the -mm tree.  Its filename was
     hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/x86/kernel/suspend_64.c     |   16 ++++++++++++----
 arch/x86/kernel/suspend_asm_64.S |    8 +++++---
 2 files changed, 17 insertions(+), 7 deletions(-)

diff -puN arch/x86/kernel/suspend_64.c~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2 arch/x86/kernel/suspend_64.c
--- a/arch/x86/kernel/suspend_64.c~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2
+++ a/arch/x86/kernel/suspend_64.c
@@ -156,6 +156,12 @@ extern int restore_image(void);
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
@@ -254,7 +260,8 @@ int pfn_is_nosave(unsigned long pfn)
 
 struct restore_data_record {
 	unsigned long jump_address;
-	unsigned long control;
+	unsigned long cr3;
+	unsigned long magic;
 };
 
 #define RESTORE_MAGIC	0x0123456789ABCDEFUL
@@ -271,7 +278,8 @@ int arch_hibernation_header_save(void *a
 	if (max_size < sizeof(struct restore_data_record))
 		return -EOVERFLOW;
 	rdr->jump_address = restore_jump_address;
-	rdr->control = (restore_jump_address ^ RESTORE_MAGIC);
+	rdr->cr3 = restore_cr3;
+	rdr->magic = RESTORE_MAGIC;
 	return 0;
 }
 
@@ -285,7 +293,7 @@ int arch_hibernation_header_restore(void
 	struct restore_data_record *rdr = addr;
 
 	restore_jump_address = rdr->jump_address;
-	return (rdr->control == (restore_jump_address ^ RESTORE_MAGIC)) ?
-			0 : -EINVAL;
+	restore_cr3 = rdr->cr3;
+	return (rdr->magic == RESTORE_MAGIC) ? 0 : -EINVAL;
 }
 #endif /* CONFIG_HIBERNATION */
diff -puN arch/x86/kernel/suspend_asm_64.S~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2 arch/x86/kernel/suspend_asm_64.S
--- a/arch/x86/kernel/suspend_asm_64.S~hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2
+++ a/arch/x86/kernel/suspend_asm_64.S
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
git-acpi.patch
revert-x86_64-mm-cpa-einval.patch
shrink_slab-handle-bad-shrinkers.patch
