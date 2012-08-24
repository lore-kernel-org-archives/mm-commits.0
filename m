From: akpm@linux-foundation.org
Subject: [merged] mm-change-nr_ptes-bug_on-to-warn_on.patch removed from -mm tree
Date: Fri, 24 Aug 2012 11:41:06 -0700
Message-ID: <20120824184106.AA4631E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:64814 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab2HXSlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Aug 2012 14:41:07 -0400
Received: by yhl10 with SMTP id 10so313066yhl.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Aug 2012 11:41:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: change nr_ptes BUG_ON to WARN_ON
has been removed from the -mm tree.  Its filename was
     mm-change-nr_ptes-bug_on-to-warn_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: change nr_ptes BUG_ON to WARN_ON

Occasionally an isolated BUG_ON(mm->nr_ptes) gets reported, indicating
that not all the page tables allocated could be found and freed when
exit_mmap() tore down the user address space.

There's usually nothing we can say about it, beyond that it's probably a
sign of some bad memory or memory corruption; though it might still
indicate a bug in vma or page table management (and did recently reveal a
race in THP, fixed a few months ago).

But one overdue change we can make is from BUG_ON to WARN_ON.

It's fairly likely that the system will crash shortly afterwards in some
other way (for example, the BUG_ON(page_mapped(page)) in
__delete_from_page_cache(), once an inode mapped into the lost page tables
gets evicted); but might tell us more before that.

Change the BUG_ON(page_mapped) to WARN_ON too?  Later perhaps: I'm less
eager, since that one has several times led to fixes.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-change-nr_ptes-bug_on-to-warn_on mm/mmap.c
--- a/mm/mmap.c~mm-change-nr_ptes-bug_on-to-warn_on
+++ a/mm/mmap.c
@@ -2309,7 +2309,7 @@ void exit_mmap(struct mm_struct *mm)
 	}
 	vm_unacct_memory(nr_accounted);
 
-	BUG_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
+	WARN_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
 }
 
 /* Insert vm structure into process list sorted by address
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
x86-pat-remove-the-dependency-on-vm_pgoff-in-track-untrack-pfn-vma-routines.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn.patch
mm-x86-pat-rework-linear-pfn-mmap-tracking.patch
mm-introduce-arch-specific-vma-flag-vm_arch_1.patch
mm-kill-vma-flag-vm_insertpage.patch
mm-kill-vma-flag-vm_can_nonlinear.patch
mm-use-mm-exe_file-instead-of-first-vm_executable-vma-vm_file.patch
mm-kill-vma-flag-vm_executable-and-mm-num_exe_file_vmas.patch
mm-prepare-vm_dontdump-for-using-in-drivers.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter.patch
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
thp-fix-the-count-of-thp_collapse_alloc.patch
thp-remove-unnecessary-check-in-start_khugepaged.patch
thp-move-khugepaged_mutex-out-of-khugepaged.patch
thp-remove-unnecessary-khugepaged_thread-check.patch
thp-remove-wake_up_interruptible-in-the-exit-path.patch
thp-remove-some-code-depend-on-config_numa.patch
thp-merge-page-pre-alloc-in-khugepaged_loop-into-khugepaged_do_scan.patch
thp-release-page-in-page-pre-alloc-path.patch
thp-introduce-khugepaged_prealloc_page-and-khugepaged_alloc_page.patch
thp-remove-khugepaged_loop.patch
thp-use-khugepaged_enabled-to-remove-duplicate-code.patch
thp-remove-unnecessary-set_recommended_min_free_kbytes.patch
prio_tree-debugging-patch.patch

