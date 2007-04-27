From: akpm@linux-foundation.org
Subject: - move-free-pages-between-lists-on-steal-fix.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:08:35 -0700
Message-ID: <200704270808.l3R88ZZL022907@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33473 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbXD0IJM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:09:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, clameter@engr.sgi.com, mm-commits@vger.kernel.org


The patch titled
     Fix boot problem on IA64 with CONFIG_HOLE_IN_ZONES and CONFIG_PAGE_GROUP_BY_MOBILITY
has been removed from the -mm tree.  Its filename was
     move-free-pages-between-lists-on-steal-fix.patch

This patch was dropped because it was folded into move-free-pages-between-lists-on-steal.patch

------------------------------------------------------
Subject: Fix boot problem on IA64 with CONFIG_HOLE_IN_ZONES and CONFIG_PAGE_GROUP_BY_MOBILITY
From: mel@skynet.ie (Mel Gorman)

Usually, a mem_map is aligned on MAX_ORDER_NR_PAGES boundaries and the
struct pages are always valid.  However, this is not always the case when
CONFIG_HOLES_IN_ZONE is set.

move_freepages_block() checks that pages within a MAX_ORDER_NR_PAGES block
are in the same zone using page_zone().  However, if an invalid page is
passed to page_zone(), it can result in breakage on machines requiring
CONFIG_HOLES_IN_ZONE.  This patch avoids the use of page_zone() and instead
checks the PFNs against the PFN ranges of the zone.  This fixes a boot
problem on IA64 using the config arch/ia64/configs/sn2_defconfig .

Credit to Christoph Lameter for testing, reporting the bug and verifying
this fixes the problem.  Credit to Andy Whitcroft for giving the patch a
quick review to ensure no functionality was changed.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~move-free-pages-between-lists-on-steal-fix mm/page_alloc.c
--- a/mm/page_alloc.c~move-free-pages-between-lists-on-steal-fix
+++ a/mm/page_alloc.c
@@ -700,18 +700,19 @@ int move_freepages(struct zone *zone,
 
 int move_freepages_block(struct zone *zone, struct page *page, int migratetype)
 {
-	unsigned long start_pfn;
+	unsigned long start_pfn, end_pfn;
 	struct page *start_page, *end_page;
 
 	start_pfn = page_to_pfn(page);
 	start_pfn = start_pfn & ~(MAX_ORDER_NR_PAGES-1);
 	start_page = pfn_to_page(start_pfn);
 	end_page = start_page + MAX_ORDER_NR_PAGES;
+	end_pfn = start_pfn + MAX_ORDER_NR_PAGES;
 
 	/* Do not cross zone boundaries */
-	if (page_zone(page) != page_zone(start_page))
+	if (start_pfn < zone->zone_start_pfn)
 		start_page = page;
-	if (page_zone(page) != page_zone(end_page))
+	if (end_pfn >= zone->zone_start_pfn + zone->spanned_pages)
 		return 0;
 
 	return move_freepages(zone, start_page, end_page, migratetype);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
move-free-pages-between-lists-on-steal-fix.patch
move-free-pages-between-lists-on-steal-fix-2.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
move-free-pages-between-lists-on-steal-do-not-cross-section-boundary-when-moving-pages-between-mobility-lists.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone.patch
create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
lumpy-reclaim-v4.patch
lumpy-back-out-removal-of-active-check-in-isolate_lru_pages.patch
lumpy-only-count-taken-pages-as-scanned.patch
kswapd-use-reclaim-order-in-background-reclaim.patch
lumpy-increase-pressure-at-the-end-of-the-inactive-list.patch
introduce-high_order-delineating-easily-reclaimable-orders.patch
introduce-high_order-delineating-easily-reclaimable-orders-cleanups.patch
lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups.patch
add-pfn_valid_within-helper-for-sub-max_order-hole-detection.patch
anti-fragmentation-switch-over-to-pfn_valid_within.patch
lumpy-move-to-using-pfn_valid_within.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks-tidy-fix.patch
remove-page_group_by_mobility.patch
dont-group-high-order-atomic-allocations.patch
do-not-disable-interrupts-when-reading-min_free_kbytes.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
