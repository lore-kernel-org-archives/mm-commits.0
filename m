From: akpm@linux-foundation.org
Subject: + ksm-fix-deadlock-with-munlock-in-exit_mmap.patch added to -mm tree
Date: Wed, 02 Sep 2009 16:22:03 -0700
Message-ID: <200909022322.n82NM3tt020317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbZIBXWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Sep 2009 19:22:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hugh.dickins@tiscali.co.uk, ieidus@redhat.com, jforbes@redhat.com


The patch titled
     ksm: fix deadlock with munlock in exit_mmap
has been added to the -mm tree.  Its filename is
     ksm-fix-deadlock-with-munlock-in-exit_mmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: fix deadlock with munlock in exit_mmap
From: Andrea Arcangeli <aarcange@redhat.com>

Rawhide users have reported hang at startup when cryptsetup is run: the
same problem can be simply reproduced by running a program int main() {
mlockall(MCL_CURRENT | MCL_FUTURE); return 0; }

The problem is that exit_mmap() applies munlock_vma_pages_all() to
clean up VM_LOCKED areas, and its current implementation (stupidly)
tries to fault in absent pages, for example where PROT_NONE prevented
them being faulted in when mlocking.  Whereas the "ksm: fix oom
deadlock" patch, knowing there's a race by which KSM might try to fault
in pages after exit_mmap() had finally zapped the range, backs out of
such faults doing nothing when its ksm_test_exit() notices mm_users 0.

So revert that part of "ksm: fix oom deadlock" which moved the
ksm_exit() call from before exit_mmap() to the middle of exit_mmap();
and remove those ksm_test_exit() checks from the page fault paths, so
allowing the munlocking to proceed without interference.

ksm_exit, if there are rmap_items still chained on this mm slot, takes
mmap_sem write side: so preventing KSM from working on an mm while
exit_mmap runs.  And KSM will bail out as soon as it notices that
mm_users is already zero, thanks to its internal ksm_test_exit checks. 
So that when a task is killed by OOM killer or the user, KSM will not
indefinitely prevent it from running exit_mmap to release its memory.

This does break a part of what "ksm: fix oom deadlock" was trying to
achieve.  When unmerging KSM (echo 2 >/sys/kernel/mm/ksm), and even
when ksmd itself has to cancel a KSM page, it is possible that the
first OOM-kill victim would be the KSM process being faulted: then its
memory won't be freed until a second victim has been selected (freeing
memory for the unmerging fault to complete).

But the OOM killer is already liable to kill a second victim once the
intended victim's p->mm goes to NULL: so there's not much point in
rejecting this KSM patch before fixing that OOM behaviour.  It is very
much more important to allow KSM users to boot up, than to haggle over
an unlikely and poorly supported OOM case.

We also intend to fix munlocking to not fault pages: at which point
this patch _could_ be reverted; though that would be controversial, so
we hope to find a better solution.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Justin M. Forbes <jforbes@redhat.com>
Acked-for-now-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |   11 ++++-------
 kernel/fork.c       |    1 +
 mm/ksm.c            |    5 +----
 mm/memory.c         |    4 ++--
 mm/mmap.c           |    7 -------
 5 files changed, 8 insertions(+), 20 deletions(-)

diff -puN include/linux/ksm.h~ksm-fix-deadlock-with-munlock-in-exit_mmap include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-fix-deadlock-with-munlock-in-exit_mmap
+++ a/include/linux/ksm.h
@@ -18,8 +18,7 @@ struct mmu_gather;
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 		unsigned long end, int advice, unsigned long *vm_flags);
 int __ksm_enter(struct mm_struct *mm);
-void __ksm_exit(struct mm_struct *mm,
-		struct mmu_gather **tlbp, unsigned long end);
+void __ksm_exit(struct mm_struct *mm);
 
 static inline int ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
@@ -41,11 +40,10 @@ static inline bool ksm_test_exit(struct 
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static inline void ksm_exit(struct mm_struct *mm,
-			    struct mmu_gather **tlbp, unsigned long end)
+static inline void ksm_exit(struct mm_struct *mm)
 {
 	if (test_bit(MMF_VM_MERGEABLE, &mm->flags))
-		__ksm_exit(mm, tlbp, end);
+		__ksm_exit(mm);
 }
 
 /*
@@ -86,8 +84,7 @@ static inline bool ksm_test_exit(struct 
 	return 0;
 }
 
-static inline void ksm_exit(struct mm_struct *mm,
-			    struct mmu_gather **tlbp, unsigned long end)
+static inline void ksm_exit(struct mm_struct *mm)
 {
 }
 
diff -puN kernel/fork.c~ksm-fix-deadlock-with-munlock-in-exit_mmap kernel/fork.c
--- a/kernel/fork.c~ksm-fix-deadlock-with-munlock-in-exit_mmap
+++ a/kernel/fork.c
@@ -508,6 +508,7 @@ void mmput(struct mm_struct *mm)
 
 	if (atomic_dec_and_test(&mm->mm_users)) {
 		exit_aio(mm);
+		ksm_exit(mm);
 		exit_mmap(mm);
 		set_mm_exe_file(mm, NULL);
 		if (!list_empty(&mm->mmlist)) {
diff -puN mm/ksm.c~ksm-fix-deadlock-with-munlock-in-exit_mmap mm/ksm.c
--- a/mm/ksm.c~ksm-fix-deadlock-with-munlock-in-exit_mmap
+++ a/mm/ksm.c
@@ -1423,8 +1423,7 @@ int __ksm_enter(struct mm_struct *mm)
 	return 0;
 }
 
-void __ksm_exit(struct mm_struct *mm,
-		struct mmu_gather **tlbp, unsigned long end)
+void __ksm_exit(struct mm_struct *mm)
 {
 	struct mm_slot *mm_slot;
 	int easy_to_free = 0;
@@ -1457,10 +1456,8 @@ void __ksm_exit(struct mm_struct *mm,
 		clear_bit(MMF_VM_MERGEABLE, &mm->flags);
 		mmdrop(mm);
 	} else if (mm_slot) {
-		tlb_finish_mmu(*tlbp, 0, end);
 		down_write(&mm->mmap_sem);
 		up_write(&mm->mmap_sem);
-		*tlbp = tlb_gather_mmu(mm, 1);
 	}
 }
 
diff -puN mm/memory.c~ksm-fix-deadlock-with-munlock-in-exit_mmap mm/memory.c
--- a/mm/memory.c~ksm-fix-deadlock-with-munlock-in-exit_mmap
+++ a/mm/memory.c
@@ -2603,7 +2603,7 @@ static int do_anonymous_page(struct mm_s
 	entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
-	if (!pte_none(*page_table) || ksm_test_exit(mm))
+	if (!pte_none(*page_table))
 		goto release;
 
 	inc_mm_counter(mm, anon_rss);
@@ -2753,7 +2753,7 @@ static int __do_fault(struct mm_struct *
 	 * handle that later.
 	 */
 	/* Only go through if we didn't race with anybody else... */
-	if (likely(pte_same(*page_table, orig_pte) && !ksm_test_exit(mm))) {
+	if (likely(pte_same(*page_table, orig_pte))) {
 		flush_icache_page(vma, page);
 		entry = mk_pte(page, vma->vm_page_prot);
 		if (flags & FAULT_FLAG_WRITE)
diff -puN mm/mmap.c~ksm-fix-deadlock-with-munlock-in-exit_mmap mm/mmap.c
--- a/mm/mmap.c~ksm-fix-deadlock-with-munlock-in-exit_mmap
+++ a/mm/mmap.c
@@ -2113,13 +2113,6 @@ void exit_mmap(struct mm_struct *mm)
 	end = unmap_vmas(&tlb, vma, 0, -1, &nr_accounted, NULL);
 	vm_unacct_memory(nr_accounted);
 
-	/*
-	 * For KSM to handle OOM without deadlock when it's breaking COW in a
-	 * likely victim of the OOM killer, we must serialize with ksm_exit()
-	 * after freeing mm's pages but before freeing its page tables.
-	 */
-	ksm_exit(mm, &tlb, end);
-
 	free_pgtables(tlb, vma, FIRST_USER_ADDRESS, 0);
 	tlb_finish_mmu(tlb, 0, end);
 
_

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
ksm-add-mmu_notifier-set_pte_at_notify.patch
ksm-first-tidy-up-madvise_vma.patch
ksm-define-madv_mergeable-and-madv_unmergeable.patch
ksm-the-mm-interface-to-ksm.patch
ksm-no-debug-in-page_dup_rmap.patch
ksm-identify-pageksm-pages.patch
ksm-kernel-samepage-merging.patch
ksm-prevent-mremap-move-poisoning.patch
ksm-change-copyright-message.patch
ksm-change-ksm-nice-level-to-be-5.patch
ksm-rename-kernel_pages_allocated.patch
ksm-move-pages_sharing-updates.patch
ksm-pages_unshared-and-pages_volatile.patch
ksm-break-cow-once-unshared.patch
ksm-keep-quiet-while-list-empty.patch
ksm-five-little-cleanups.patch
ksm-fix-endless-loop-on-oom.patch
ksm-distribute-remove_mm_from_lists.patch
ksm-fix-oom-deadlock.patch
ksm-fix-deadlock-with-munlock-in-exit_mmap.patch
ksm-sysfs-and-defaults.patch
ksm-add-some-documentation.patch
ksm-remove-vm_mergeable_flags.patch
page-types-move-from-documentation-vm-to-tools-vm.patch
pagemap-export-kpf_hwpoison.patch
pagemap-document-kpf_ksm-and-show-it-in-page-types.patch

