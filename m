From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 15:59:48 -0700
Message-ID: <20121008225948.BAA01100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:50972 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2JHW7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 18:59:50 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so536698ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 15:59:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, bhalevy@tonian.com, dhillf@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links fix
has been removed from the -mm tree.  Its filename was
     mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch

This patch was dropped because it was folded into mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links fix

Strangely, I can no longer get an uninitialized variable warning out of
copy_vma(), with or without the BUG() there; but David Rientjes gets it
when he builds with CONFIG_BUG off, which is understandable.

uninitialized_var() can be a useful tool, but I do prefer to avoid it:
partly because it might hide future errors, partly because I misspell it,
but mainly because the need for it comes and goes so mysteriously.

Given David's preference for no warning, mine for no uninitialized_var,
and Linus's for renaming BUG() to I_AM_A_MORON() to discourage its use in
the first place: copy_vma() seems a prime candidate for returning failure
to mremap instead of crashing the system.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Benny Halevy <bhalevy@tonian.com>
Cc: Hillf Danton <dhillf@gmail.com>
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix
+++ a/mm/mmap.c
@@ -2351,7 +2351,7 @@ struct vm_area_struct *copy_vma(struct v
 	}
 
 	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent))
-		BUG();
+		return NULL;	/* should never get here */
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
 			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma));
 	if (new_vma) {
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
mm-mmu_notifier-init-notifier-if-necessary.patch
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
mm-fix-potential-anon_vma-locking-issue-in-mprotect.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-anon-rmap-in-mremap-set-the-new-vmas-position-before-anon_vma_clone.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
cma-fix-watermark-checking-fix.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-remove-vma-arg-from-page_evictable.patch
mm-clear_page_mlock-in-page_remove_rmap.patch
mm-remove-free_page_mlock.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end-fix.patch
mm-remove-unevictable_pgs_mlockfreed.patch
mm-thp-fix-mapped-pages-avoiding-unevictable-list-on-mlock.patch
mm-thp-fix-mlock-statistics.patch
mm-thp-fix-mlock-statistics-fix.patch

