From: akpm@linux-foundation.org
Subject: + rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch added to -mm tree
Date: Thu, 17 May 2007 13:15:09 -0700
Message-ID: <200705172015.l4HKF93R031903@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41550 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492AbXEQUSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 16:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com


The patch titled
     Rename GFP_HIGH_MOVABLE to GFP_HIGHUSER_MOVABLE
has been added to the -mm tree.  Its filename is
     rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Rename GFP_HIGH_MOVABLE to GFP_HIGHUSER_MOVABLE
From: Mel Gorman <mel@csn.ul.ie>

__GFP_HIGH are used to flag allocations that can access emergency
pools. GFP_HIGH_MOVABLE has little to do with __GFP_HIGH and the name is
misleading. This patch renames GFP_HIGH_MOVABLE to GFP_HIGHUSER_MOVABLE so
that it is clearer.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_prefetch.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_prefetch.c~rename-gfp_high_movable-to-gfp_highuser_movable-prefetch mm/swap_prefetch.c
--- a/mm/swap_prefetch.c~rename-gfp_high_movable-to-gfp_highuser_movable-prefetch
+++ a/mm/swap_prefetch.c
@@ -208,7 +208,7 @@ static enum trickle_return trickle_swap_
 	 * Get a new page to read from swap. We have already checked the
 	 * watermarks so __alloc_pages will not call on reclaim.
 	 */
-	page = alloc_pages_node(node, GFP_HIGH_MOVABLE & ~__GFP_WAIT, 0);
+	page = alloc_pages_node(node, GFP_HIGHUSER_MOVABLE & ~__GFP_WAIT, 0);
 	if (unlikely(!page)) {
 		ret = TRICKLE_DELAY;
 		goto out;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix-alloc_zeroed_user_highpage-on-m68knommu.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-bio_alloc-allocations-correctly.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-rename-gfp_high_movable-to-gfp_highuser_movable.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-mark-page-cache-pages-as-__gfp_pagecache-instead-of-__gfp_movable.patch
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
group-short-lived-and-reclaimable-kernel-allocations-add-__gfp_temporary-to-identify-allocations-that-are-short-lived.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
dont-group-high-order-atomic-allocations-remove-unused-parameter-to-allocflags_to_migratetype.patch
remove-alloc_zeroed_user_highpage.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
handle-kernelcore=-generic.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0-fix.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
rename-gfp_high_movable-to-gfp_highuser_movable-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
