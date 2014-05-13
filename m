From: akpm@linux-foundation.org
Subject: + mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch added to
 -mm tree
Date: Tue, 13 May 2014 15:00:06 -0700
Message-ID: <537295e6.lp8MNFowwudVebIG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaEMWAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 May 2014 18:00:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, hannes@cmpxchg.org

Subject: + mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch added to -mm tree
To: hannes@cmpxchg.org,hughd@google.com
From: akpm@linux-foundation.org
Date: Tue, 13 May 2014 15:00:06 -0700


The patch titled
     Subject: mm: madvise: fix MADV_WILLNEED on shmem swapouts
has been added to the -mm tree.  Its filename is
     mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

origin.patch
mm-madvise-fix-madv_willneed-on-shmem-swapouts.patch
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
memcg-mm-introduce-lowlimit-reclaim.patch
memcg-mm-introduce-lowlimit-reclaim-fix.patch
memcg-allow-setting-low_limit.patch
memcg-doc-clarify-global-vs-limit-reclaims.patch
memcg-doc-clarify-global-vs-limit-reclaims-fix.patch
memcg-document-memorylow_limit_in_bytes.patch
mm-memcontrolc-remove-null-assignment-on-static.patch
vmscan-memcg-always-use-swappiness-of-the-reclaimed-memcg-swappiness-and-oom_control.patch
mm-introduce-kmemleak_update_trace.patch
lib-update-the-kmemleak-stack-trace-for-radix-tree-allocations.patch
mm-memcontrol-clean-up-memcg-zoneinfo-lookup.patch
mm-memcontrol-remove-unnecessary-memcg-argument-from-soft-limit-functions.patch
memcg-fold-mem_cgroup_stolen.patch
memcg-fold-mem_cgroup_stolen-fix.patch
memcg-correct-comments-for-__mem_cgroup_begin_update_page_stat.patch
memcg-get-rid-of-memcg_create_cache_name.patch
memcg-memcg_kmem_create_cache-make-memcg_name_buf.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
memcg-deprecate-memoryforce_empty-knob.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
memcg-cleanup-kmem-cache-creation-destruction-functions-naming.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

