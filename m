From: akpm@linux-foundation.org
Subject: + only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch added to -mm tree
Date: Mon, 14 May 2007 20:07:16 -0700
Message-ID: <200705150307.l4F37GBu000327@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbXEODI3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 May 2007 23:08:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org, clameter@sgi.com


The patch titled
     Only check absolute watermarks for ALLOC_HIGH and ALLOC_HARDER allocations
has been added to the -mm tree.  Its filename is
     only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Only check absolute watermarks for ALLOC_HIGH and ALLOC_HARDER allocations
From: Mel Gorman <mel@csn.ul.ie>

zone_watermark_ok() checks if there are enough free pages including a reserve.
 High-order allocations additionally check if there are enough free high-order
pages in relation to the watermark adjusted based on the requested size.  If
there are not enough free high-order pages available, 0 is returned so that
the caller enters direct reclaim.

ALLOC_HIGH and ALLOC_HARDER allocations are allowed to dip further into the
reserves but also take into account if the number of free high-order pages
meet the adjusted watermarks.  As these allocations cannot sleep, they cannot
enter direct reclaim so the allocation can fail even though the pages are
available and the number of free pages is well above the watermark for
order-0.

This patch alters the behaviour of zone_watermark_ok() slightly.  Watermarks
are still obeyed but when an allocator is flagged ALLOC_HIGH or ALLOC_HARDER,
we only check that there is sufficient memory over the reserve to satisfy the
allocation, allocation size is ignored.  This patch also documents better what
zone_watermark_ok() is doing.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN mm/page_alloc.c~only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations mm/page_alloc.c
--- a/mm/page_alloc.c~only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations
+++ a/mm/page_alloc.c
@@ -1265,13 +1265,34 @@ int zone_watermark_ok(struct zone *z, in
 	long free_pages = zone_page_state(z, NR_FREE_PAGES) - (1 << order) + 1;
 	int o;
 
+	/*
+	 * Allow ALLOC_HIGH and ALLOC_HARDER to dip further into reserves
+	 * ALLOC_HIGH              => Reduce the required reserve by a half
+	 * ALLOC_HARDER            => Reduce the required reserve by a quarter
+	 * ALLOC_HIGH|ALLOC_HARDER => Reduce the required reserve by 5/8ths
+	 */
 	if (alloc_flags & ALLOC_HIGH)
 		min -= min / 2;
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
 
+	/* Ensure there are sufficient total pages less the reserve. */
 	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
 		return 0;
+
+	/*
+	 * If the allocation is flagged ALLOC_HARDER or ALLOC_HIGH, the
+	 * caller cannot enter direct reclaim, so allow them to take a page
+	 * if one exists as the absolute reserves have been met.
+	 */
+	if (alloc_flags & (ALLOC_HARDER | ALLOC_HIGH))
+		return 1;
+
+	/*
+	 * For higher order allocations that can sleep, check that there
+	 * are enough free high-order pages above a reserve adjusted
+	 * based on the requested order.
+	 */
 	for (o = 0; o < order; o++) {
 		/* At the next order, this order's pages become unavailable */
 		free_pages -= z->free_area[o].nr_free << o;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

x86_64-extract-helper-function-from-e820_register_active_regions.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix-alloc_zeroed_user_highpage-on-m68knommu.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-anti-fragmentation-switch-over-to-pfn_valid_within.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used.patch
group-short-lived-and-reclaimable-kernel-allocations-use-slab_account_reclaim-to-determine-when-__gfp_reclaimable-should-be-used-fix.patch
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
handle-kernelcore=-generic.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
lumpy-reclaim-v4.patch
lumpy-move-to-using-pfn_valid_within.patch
have-kswapd-keep-a-minimum-order-free-other-than-order-0.patch
only-check-absolute-watermarks-for-alloc_high-and-alloc_harder-allocations.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
