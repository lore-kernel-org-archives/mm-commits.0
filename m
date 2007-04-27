From: akpm@linux-foundation.org
Subject: - lumpy-only-count-taken-pages-as-scanned.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:16:59 -0700
Message-ID: <200704270816.l3R8Gx3t023124@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754140AbXD0IRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:17:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     lumpy: only count taken pages as scanned
has been removed from the -mm tree.  Its filename was
     lumpy-only-count-taken-pages-as-scanned.patch

This patch was dropped because it was folded into lumpy-reclaim-v4.patch

------------------------------------------------------
Subject: lumpy: only count taken pages as scanned
From: Andy Whitcroft <apw@shadowen.org>

When scanning the order sized area around the tag page we pull all pages of
the matching active state; the non-matching pages are not otherwise affected. 
We currently count these as scanned increasing the apparent scan rates. 
Previously we would only count a page scanned if it was actually removed from
the LRU, either then being reclaimed or rotated back onto the head of the LRU.

The effect of this is to cause reclaim to terminate artificially early when
the scan count is reached, reducing effectivness.  Move to counting only those
pages we actually remove from the LRU as scanned.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmscan.c~lumpy-only-count-taken-pages-as-scanned mm/vmscan.c
--- a/mm/vmscan.c~lumpy-only-count-taken-pages-as-scanned
+++ a/mm/vmscan.c
@@ -724,11 +724,11 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
-			scan++;
 			switch (__isolate_lru_page(cursor_page, active)) {
 			case 0:
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;
+				scan++;
 				break;
 
 			case -EBUSY:
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-a-configure-option-to-group-pages-by-mobility.patch
move-free-pages-between-lists-on-steal.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone.patch
handle-kernelcore=-boot-parameter-in-common-code-to-avoid-boot-problem-on-ia64.patch
lumpy-reclaim-v4.patch
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
slab-numa-kmem_cache-diet.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
