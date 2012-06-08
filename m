From: akpm@linux-foundation.org
Subject: + mm-account-the-total_vm-in-the-vm_stat_account.patch added to -mm tree
Date: Fri, 08 Jun 2012 13:48:45 -0700
Message-ID: <20120608204845.93629A022F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:59551 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2FHUss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jun 2012 16:48:48 -0400
Received: by bkty5 with SMTP id y5so126584bkt.1
        for <mm-commits@vger.kernel.org>; Fri, 08 Jun 2012 13:48:46 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shijie8@gmail.com


The patch titled
     Subject: mm: account the total_vm in the vm_stat_account()
has been added to the -mm tree.  Its filename is
     mm-account-the-total_vm-in-the-vm_stat_account.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Shijie <shijie8@gmail.com>
Subject: mm: account the total_vm in the vm_stat_account()

vm_stat_account() accounts the shared_vm, stack_vm and reserved_vm now. 
But we can also account for total_vm in the vm_stat_account() which makes
the code tidy.

Even for mprotect_fixup(), we can get the right result in the end.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/perfmon.c |    1 -
 include/linux/mm.h         |    1 +
 kernel/fork.c              |    4 +---
 mm/mmap.c                  |    5 ++---
 mm/mremap.c                |    2 --
 5 files changed, 4 insertions(+), 9 deletions(-)

diff -puN arch/ia64/kernel/perfmon.c~mm-account-the-total_vm-in-the-vm_stat_account arch/ia64/kernel/perfmon.c
--- a/arch/ia64/kernel/perfmon.c~mm-account-the-total_vm-in-the-vm_stat_account
+++ a/arch/ia64/kernel/perfmon.c
@@ -2353,7 +2353,6 @@ pfm_smpl_buffer_alloc(struct task_struct
 	 */
 	insert_vm_struct(mm, vma);
 
-	mm->total_vm  += size >> PAGE_SHIFT;
 	vm_stat_account(vma->vm_mm, vma->vm_flags, vma->vm_file,
 							vma_pages(vma));
 	up_write(&task->mm->mmap_sem);
diff -puN include/linux/mm.h~mm-account-the-total_vm-in-the-vm_stat_account include/linux/mm.h
--- a/include/linux/mm.h~mm-account-the-total_vm-in-the-vm_stat_account
+++ a/include/linux/mm.h
@@ -1553,6 +1553,7 @@ void vm_stat_account(struct mm_struct *,
 static inline void vm_stat_account(struct mm_struct *mm,
 			unsigned long flags, struct file *file, long pages)
 {
+	mm->total_vm += pages;
 }
 #endif /* CONFIG_PROC_FS */
 
diff -puN kernel/fork.c~mm-account-the-total_vm-in-the-vm_stat_account kernel/fork.c
--- a/kernel/fork.c~mm-account-the-total_vm-in-the-vm_stat_account
+++ a/kernel/fork.c
@@ -377,10 +377,8 @@ static int dup_mmap(struct mm_struct *mm
 		struct file *file;
 
 		if (mpnt->vm_flags & VM_DONTCOPY) {
-			long pages = vma_pages(mpnt);
-			mm->total_vm -= pages;
 			vm_stat_account(mm, mpnt->vm_flags, mpnt->vm_file,
-								-pages);
+							-vma_pages(mpnt));
 			continue;
 		}
 		charge = 0;
diff -puN mm/mmap.c~mm-account-the-total_vm-in-the-vm_stat_account mm/mmap.c
--- a/mm/mmap.c~mm-account-the-total_vm-in-the-vm_stat_account
+++ a/mm/mmap.c
@@ -943,6 +943,8 @@ void vm_stat_account(struct mm_struct *m
 	const unsigned long stack_flags
 		= VM_STACK_FLAGS & (VM_GROWSUP|VM_GROWSDOWN);
 
+	mm->total_vm += pages;
+
 	if (file) {
 		mm->shared_vm += pages;
 		if ((flags & (VM_EXEC|VM_WRITE)) == VM_EXEC)
@@ -1347,7 +1349,6 @@ munmap_back:
 out:
 	perf_event_mmap(vma);
 
-	mm->total_vm += len >> PAGE_SHIFT;
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
 		if (!mlock_vma_pages_range(vma, addr, addr + len))
@@ -1707,7 +1708,6 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */
-	mm->total_vm += grow;
 	if (vma->vm_flags & VM_LOCKED)
 		mm->locked_vm += grow;
 	vm_stat_account(mm, vma->vm_flags, vma->vm_file, grow);
@@ -1889,7 +1889,6 @@ static void remove_vma_list(struct mm_st
 
 		if (vma->vm_flags & VM_ACCOUNT)
 			nr_accounted += nrpages;
-		mm->total_vm -= nrpages;
 		vm_stat_account(mm, vma->vm_flags, vma->vm_file, -nrpages);
 		vma = remove_vma(vma);
 	} while (vma);
diff -puN mm/mremap.c~mm-account-the-total_vm-in-the-vm_stat_account mm/mremap.c
--- a/mm/mremap.c~mm-account-the-total_vm-in-the-vm_stat_account
+++ a/mm/mremap.c
@@ -260,7 +260,6 @@ static unsigned long move_vma(struct vm_
 	 * If this were a serious issue, we'd add a flag to do_munmap().
 	 */
 	hiwater_vm = mm->hiwater_vm;
-	mm->total_vm += new_len >> PAGE_SHIFT;
 	vm_stat_account(mm, vma->vm_flags, vma->vm_file, new_len>>PAGE_SHIFT);
 
 	if (do_munmap(mm, old_addr, old_len) < 0) {
@@ -497,7 +496,6 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 				goto out;
 			}
 
-			mm->total_vm += pages;
 			vm_stat_account(mm, vma->vm_flags, vma->vm_file, pages);
 			if (vma->vm_flags & VM_LOCKED) {
 				mm->locked_vm += pages;
_
Subject: Subject: mm: account the total_vm in the vm_stat_account()

Patches currently in -mm which might be from shijie8@gmail.com are

linux-next.patch
mm-account-the-total_vm-in-the-vm_stat_account.patch

