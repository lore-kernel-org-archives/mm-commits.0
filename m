From: akpm@linux-foundation.org
Subject: - add-a-configure-option-to-group-pages-by-mobility-speedup.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:08:03 -0700
Message-ID: <200704270808.l3R883oQ022889@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbXD0IIp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:08:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Reduce the amount of time spent in the per-cpu allocator
has been removed from the -mm tree.  Its filename was
     add-a-configure-option-to-group-pages-by-mobility-speedup.patch

This patch was dropped because it was folded into add-a-configure-option-to-group-pages-by-mobility.patch

------------------------------------------------------
Subject: Reduce the amount of time spent in the per-cpu allocator
From: Mel Gorman <mel@csn.ul.ie>

The per-cpu allocator is the most frequently entered path in the page
allocator as the majority of allocations are order-0 allocations that use it. 
This patch is mainly a re-ordering to give the patch a cleaner flow and make
it more human-readable.

Performance wise, an unlikely() is added for a branch that is rarely executed
which improves performance very slightly.  A VM_BUG_ON() is removed because
when the situation does occur, it means we are just really low on memory not
that the VM is buggy.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff -puN mm/page_alloc.c~add-a-configure-option-to-group-pages-by-mobility-speedup mm/page_alloc.c
--- a/mm/page_alloc.c~add-a-configure-option-to-group-pages-by-mobility-speedup
+++ a/mm/page_alloc.c
@@ -996,33 +996,25 @@ again:
 			if (unlikely(!pcp->count))
 				goto failed;
 		}
+
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 		/* Find a page of the appropriate migrate type */
-		list_for_each_entry(page, &pcp->list, lru) {
-			if (page_private(page) == migratetype) {
-				list_del(&page->lru);
-				pcp->count--;
+		list_for_each_entry(page, &pcp->list, lru)
+			if (page_private(page) == migratetype)
 				break;
-			}
-		}
 
-		/*
-		 * Check if a page of the appropriate migrate type
-		 * was found. If not, allocate more to the pcp list
-		 */
-		if (&page->lru == &pcp->list) {
+		/* Allocate more to the pcp list if necessary */
+		if (unlikely(&page->lru == &pcp->list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
 					pcp->batch, &pcp->list, migratetype);
 			page = list_entry(pcp->list.next, struct page, lru);
-			VM_BUG_ON(page_private(page) != migratetype);
-			list_del(&page->lru);
-			pcp->count--;
 		}
 #else
 		page = list_entry(pcp->list.next, struct page, lru);
+#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
+
 		list_del(&page->lru);
 		pcp->count--;
-#endif /* CONFIG_PAGE_GROUP_BY_MOBILITY */
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
add-a-configure-option-to-group-pages-by-mobility-speedup.patch
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
