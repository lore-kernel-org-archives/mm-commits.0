From: akpm@linux-foundation.org
Subject: + group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch added to -mm tree
Date: Thu, 17 May 2007 12:41:29 -0700
Message-ID: <200705171941.l4HJfT13031305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47062 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754478AbXEQToZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 15:44:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com


The patch titled
     Do not annotate shmem allocations explicitly
has been added to the -mm tree.  Its filename is
     group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Do not annotate shmem allocations explicitly
From: Mel Gorman <mel@csn.ul.ie>

shmem support allocates pages for two purposes.  Firstly, shmem_dir_alloc()
allocates pages to track swap vectors.  These are not movable so this patch
clears all mobility-flags related to the allocation.  Secondly,
shmem_alloc_pages() allocates pages on behalf of shmem_getpage(), whose flags
come from a file mapping which already sets the appropriate mobility flags. 
These allocations do not need to be explicitly flagged so this patch removes
the unnecessary annotations.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly mm/shmem.c
--- a/mm/shmem.c~group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly
+++ a/mm/shmem.c
@@ -95,9 +95,9 @@ static inline struct page *shmem_dir_all
 	 * BLOCKS_PER_PAGE on indirect pages, assume PAGE_CACHE_SIZE:
 	 * might be reconsidered if it ever diverges from PAGE_SIZE.
 	 *
-	 * __GFP_MOVABLE is masked out as swap vectors cannot move
+	 * Mobility flags are masked out as swap vectors cannot move
 	 */
-	return alloc_pages((gfp_mask & ~__GFP_MOVABLE) | __GFP_ZERO,
+	return alloc_pages((gfp_mask & ~GFP_MOVABLE_MASK) | __GFP_ZERO,
 				PAGE_CACHE_SHIFT-PAGE_SHIFT);
 }
 
@@ -1053,9 +1053,7 @@ shmem_alloc_page(gfp_t gfp, struct shmem
 	pvma.vm_policy = mpol_shared_policy_lookup(&info->policy, idx);
 	pvma.vm_pgoff = idx;
 	pvma.vm_end = PAGE_SIZE;
-	page = alloc_page_vma(
-			set_migrateflags(gfp | __GFP_ZERO, __GFP_RECLAIMABLE),
-								&pvma, 0);
+	page = alloc_page_vma(gfp | __GFP_ZERO, &pvma, 0);
 	mpol_free(pvma.vm_policy);
 	return page;
 }
@@ -1075,8 +1073,7 @@ shmem_swapin(struct shmem_inode_info *in
 static inline struct page *
 shmem_alloc_page(gfp_t gfp,struct shmem_inode_info *info, unsigned long idx)
 {
-	return alloc_page(
-			set_migrateflags(gfp | __GFP_ZERO, __GFP_RECLAIMABLE));
+	return alloc_page(gfp | __GFP_ZERO);
 }
 #endif
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix-alloc_zeroed_user_highpage-on-m68knommu.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
group-short-lived-and-reclaimable-kernel-allocations-do-not-annotate-shmem-allocations-explicitly.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch
add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
rename-gfp_high_movable-to-gfp_highuser_movable.patch
mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
