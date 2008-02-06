From: akpm@linux-foundation.org
Subject: + uml-fix-mm_context-memory-leak.patch added to -mm tree
Date: Wed, 06 Feb 2008 14:20:23 -0800
Message-ID: <200802062220.m16MKO6w000638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39942 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760568AbYBFWUp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 17:20:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com, miklos@szeredi.hu


The patch titled
     uml: fix mm_context memory leak
has been added to the -mm tree.  Its filename is
     uml-fix-mm_context-memory-leak.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-__const_udelay-declaration-and-definition-mismatches.patch
git-kvm.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
uml-runtime-host-vmsplit-detection.patch
uml-style-fixes-in-arch-um-os-linux.patch
uml-x86_64-should-copy-%fs-during-fork.patch
uml-fix-mm_context-memory-leak.patch
