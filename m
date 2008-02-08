From: akpm@linux-foundation.org
Subject: - uml-fix-mm_context-memory-leak.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:21:12 -0800
Message-ID: <200802082020.m18KKrWh011264@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33345 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932890AbYBHUlc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:41:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     uml: fix mm_context memory leak
has been removed from the -mm tree.  Its filename was
     uml-fix-mm_context-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: fix mm_context memory leak
From: Jeff Dike <jdike@addtoit.com>

[ Spotted by Miklos ]

Fix a memory leak in init_new_context.  The struct page ** buffer allocated
for install_special_mapping was never recorded, and thus leaked when the
mm_struct was freed.  Fix it by saving the pointer in mm_context_t and freeing
it in arch_exit_mmap.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/um_mmu.h  |    1 +
 arch/um/kernel/skas/mmu.c |    5 +++++
 2 files changed, 6 insertions(+)

diff -puN arch/um/include/um_mmu.h~uml-fix-mm_context-memory-leak arch/um/include/um_mmu.h
--- a/arch/um/include/um_mmu.h~uml-fix-mm_context-memory-leak
+++ a/arch/um/include/um_mmu.h
@@ -13,6 +13,7 @@
 typedef struct mm_context {
 	struct mm_id id;
 	struct uml_ldt ldt;
+	struct page **stub_pages;
 } mm_context_t;
 
 extern void __switch_mm(struct mm_id * mm_idp);
diff -puN arch/um/kernel/skas/mmu.c~uml-fix-mm_context-memory-leak arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-fix-mm_context-memory-leak
+++ a/arch/um/kernel/skas/mmu.c
@@ -91,6 +91,8 @@ int init_new_context(struct task_struct 
 		goto out_free;
 	}
 
+	to_mm->stub_pages = NULL;
+
 	return 0;
 
  out_free:
@@ -126,6 +128,7 @@ void arch_dup_mmap(struct mm_struct *old
 
 	pages[0] = virt_to_page(&__syscall_stub_start);
 	pages[1] = virt_to_page(mm->context.id.stack);
+	mm->context.stub_pages = pages;
 
 	/* dup_mmap already holds mmap_sem */
 	err = install_special_mapping(mm, STUB_START, STUB_END - STUB_START,
@@ -147,6 +150,8 @@ void arch_exit_mmap(struct mm_struct *mm
 {
 	pte_t *pte;
 
+	if (mm->context.stub_pages != NULL)
+		kfree(mm->context.stub_pages);
 	pte = virt_to_pte(mm, STUB_CODE);
 	if (pte != NULL)
 		pte_clear(mm, STUB_CODE, pte);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
uml-update-defconfig.patch
random-add-async-notification-support-to-dev-random.patch
