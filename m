From: akpm@linux-foundation.org
Subject: [merged] mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch
 removed from -mm tree
Date: Tue, 27 May 2014 13:22:17 -0700
Message-ID: <5384f3f9.ir+jrfYcUli6IhxO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaE0UWR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 May 2014 16:22:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org

Subject: [merged] mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch removed from -mm tree
To: hannes@cmpxchg.org,hughd@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 27 May 2014 13:22:17 -0700


The patch titled
     Subject: mm: madvise: fix MADV_WILLNEED on shmem swapouts
has been removed from the -mm tree.  Its filename was
     mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: madvise: fix MADV_WILLNEED on shmem swapouts

MADV_WILLNEED currently does not read swapped out shmem pages back in.

0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache radix
trees") made find_get_page() filter exceptional radix tree entries but
failed to convert all find_get_page() callers that WANT exceptional
entries over to find_get_entry().  One of them is shmem swap readahead in
madvise, which now skips over any swap-out records.

Convert it to find_get_entry().

Fixes: 0cd6144aadd2 ("mm + fs: prepare for non-page entries in page cache radix trees")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/madvise.c~mm-madvise-fix-madv_willneed-on-shmem-swapouts mm/madvise.c
--- a/mm/madvise.c~mm-madvise-fix-madv_willneed-on-shmem-swapouts
+++ a/mm/madvise.c
@@ -195,7 +195,7 @@ static void force_shm_swapin_readahead(s
 	for (; start < end; start += PAGE_SIZE) {
 		index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 
-		page = find_get_page(mapping, index);
+		page = find_get_entry(mapping, index);
 		if (!radix_tree_exceptional_entry(page)) {
 			if (page)
 				page_cache_release(page);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

slb-charge-slabs-to-kmemcg-explicitly.patch
mm-get-rid-of-__gfp_kmemcg.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control.patch
mm-memcontrol-remove-hierarchy-restrictions-for-swappiness-and-oom_control-fix.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
documentation-memcg-warn-about-incomplete-kmemcg-state.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
memcg-kill-config_mm_owner.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
memcg-slab-do-not-schedule-cache-destruction-when-last-page-goes-away.patch
memcg-slab-merge-memcg_bindrelease_pages-to-memcg_uncharge_slab.patch
memcg-slab-simplify-synchronization-scheme.patch
mm-avoid-throttling-reclaim-for-loop-back-nfsd-threads.patch
memcg-mm_update_next_owner-should-skip-kthreads.patch
memcg-optimize-the-search-everything-else-loop-in-mm_update_next_owner.patch
memcg-kill-start_kernel-mm_init_ownerinit_mm.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
memcg-get-rid-of-memcg_create_cache_name.patch
memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch
mm-page_alloc-do-not-update-zlc-unless-the-zlc-is-active.patch
mm-page_alloc-do-not-treat-a-zone-that-cannot-be-used-for-dirty-pages-as-full.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possiblefix-2.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref-fix.patch
mm-hugetlb-move-the-error-handle-logic-out-of-normal-code-path.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
lib-radix-treec-kernel-doc-warning-fix.patch
linux-next.patch
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
vmscan-memcg-check-whether-the-low-limit-should-be-ignored.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch

