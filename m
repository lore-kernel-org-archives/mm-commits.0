From: akpm@linux-foundation.org
Subject: [folded] mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:30:16 -0700
Message-ID: <200909212130.n8LLUGJH021563@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873AbZIUVaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:30:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, eric.whitney@hp.com, lee.schermerhorn@hp.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak
has been removed from the -mm tree.  Its filename was
     mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak.patch

This patch was dropped because it was folded into mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Eric Whitney <eric.whitney@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak mm/mmap.c
--- a/mm/mmap.c~mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak
+++ a/mm/mmap.c
@@ -573,7 +573,7 @@ again:			remove_next = 1 + (end > next->
 	 * When changing only vma->vm_end, we don't really need
 	 * anon_vma lock.
 	 */
-	if ((file || insert || importer) && vma->anon_vma)
+	if (vma->anon_vma && (insert || importer || start != vma->vm_start))
 		anon_vma = vma->anon_vma;
 	if (anon_vma) {
 		spin_lock(&anon_vma->lock);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-vmstat-add-isolate-pages.patch
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
ksm-clean-up-obsolete-references.patch
ksm-unmerge-is-an-origin-of-ooms.patch
ksm-mremap-use-err-from-ksm_madvise.patch
mm-add_to_swap_cache-must-not-sleep.patch
mm-add_to_swap_cache-does-not-return-eexist.patch
mm-includecheck-fix-for-mm-shmemc.patch
mm-introduce-page_lru_base_type.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-move-highest_memmap_pfn.patch
mmap-remove-unnecessary-code.patch
tmpfs-depend-on-shmem.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust.patch
mmap-avoid-unnecessary-anon_vma-lock-acquisition-in-vma_adjust-tweak.patch
mmap-save-some-cycles-for-the-shared-anonymous-mapping.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
mm-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
hugetlb-add-map_hugetlb-example.patch
shmem-initialize-struct-shmem_sb_info-to-zero.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

