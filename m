From: akpm@linux-foundation.org
Subject: + mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch added to -mm tree
Date: Wed, 12 Sep 2012 15:23:57 -0700
Message-ID: <20120912222357.9E809100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:44946 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2ILWX7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 18:23:59 -0400
Received: by vcbfy27 with SMTP id fy27so117888vcb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 15:23:58 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, bhalevy@tonian.com, dhillf@gmail.com, rientjes@google.com


The patch titled
     Subject: mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links fix
has been added to the -mm tree.  Its filename is
     mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix mm/mmap.c
--- a/mm/mmap.c~mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix
+++ a/mm/mmap.c
@@ -2352,7 +2352,7 @@ struct vm_area_struct *copy_vma(struct v
 	}
 
 	if (find_vma_links(mm, addr, addr + len, &prev, &rb_link, &rb_parent))
-		BUG();
+		return NULL;	/* should never get here */
 	new_vma = vma_merge(mm, prev, addr, addr + len, vma->vm_flags,
 			vma->anon_vma, vma->vm_file, pgoff, vma_policy(vma));
 	if (new_vma) {
_

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
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
mm-mmapc-replace-find_vma_prepare-with-clearer-find_vma_links-fix.patch
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
mm-avoid-taking-rmap-locks-in-move_ptes.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock-fix.patch
mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
thp-khugepaged_prealloc_page-forgot-to-reset-the-page-alloc-indicator.patch

