From: akpm@linux-foundation.org
Subject: - introduce-high_order-delineating-easily-reclaimable-orders.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:17:06 -0700
Message-ID: <200704270817.l3R8H6c8023134@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51011 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755493AbXD0IRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:17:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     introduce HIGH_ORDER delineating easily reclaimable orders
has been removed from the -mm tree.  Its filename was
     introduce-high_order-delineating-easily-reclaimable-orders.patch

This patch was dropped because it was folded into lumpy-reclaim-v4.patch

------------------------------------------------------
Subject: introduce HIGH_ORDER delineating easily reclaimable orders
From: Andy Whitcroft <apw@shadowen.org>

The memory allocator treats lower order (order <= 3) and higher order
(order >= 4) allocations in slightly different ways.  As lower orders are
much more likely to be available and also more likely to be simply
reclaimed it is deemed reasonable to wait longer for those.  Lumpy reclaim
also changes behaviour at this same boundary, more agressivly targetting
pages in reclaim at higher order.

This patch removes all these magical numbers and replaces with
with a constant HIGH_ORDER.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    7 +++++++
 mm/page_alloc.c        |    2 +-
 mm/vmscan.c            |   11 ++++++-----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff -puN include/linux/mmzone.h~introduce-high_order-delineating-easily-reclaimable-orders include/linux/mmzone.h
--- a/include/linux/mmzone.h~introduce-high_order-delineating-easily-reclaimable-orders
+++ a/include/linux/mmzone.h
@@ -25,6 +25,13 @@
 #endif
 #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
 
+/*
+ * The boundary between small and large allocations.  That is between
+ * allocation orders which should colesce naturally under reasonable
+ * reclaim pressure and those which will not.
+ */
+#define HIGH_ORDER 3
+
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 #define MIGRATE_UNMOVABLE     0
 #define MIGRATE_RECLAIMABLE   1
diff -puN mm/page_alloc.c~introduce-high_order-delineating-easily-reclaimable-orders mm/page_alloc.c
--- a/mm/page_alloc.c~introduce-high_order-delineating-easily-reclaimable-orders
+++ a/mm/page_alloc.c
@@ -1677,7 +1677,7 @@ nofail_alloc:
 	 */
 	do_retry = 0;
 	if (!(gfp_mask & __GFP_NORETRY)) {
-		if ((order <= 3) || (gfp_mask & __GFP_REPEAT))
+		if ((order <= HIGH_ORDER) || (gfp_mask & __GFP_REPEAT))
 			do_retry = 1;
 		if (gfp_mask & __GFP_NOFAIL)
 			do_retry = 1;
diff -puN mm/vmscan.c~introduce-high_order-delineating-easily-reclaimable-orders mm/vmscan.c
--- a/mm/vmscan.c~introduce-high_order-delineating-easily-reclaimable-orders
+++ a/mm/vmscan.c
@@ -487,7 +487,8 @@ static unsigned long shrink_page_list(st
 
 		referenced = page_referenced(page, 1);
 		/* In active use or really unfreeable?  Activate it. */
-		if (sc->order <= 3 && referenced && page_mapping_inuse(page))
+		if (sc->order <= HIGH_ORDER &&
+					referenced && page_mapping_inuse(page))
 			goto activate_locked;
 
 #ifdef CONFIG_SWAP
@@ -520,7 +521,7 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
-			if (sc->order <= 3 && referenced)
+			if (sc->order <= HIGH_ORDER && referenced)
 				goto keep_locked;
 			if (!may_enter_fs)
 				goto keep_locked;
@@ -790,9 +791,9 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_active;
 
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
-				     &zone->inactive_list,
-				     &page_list, &nr_scan, sc->order,
-				     (sc->order > 3)? ISOLATE_BOTH : 0);
+			     &zone->inactive_list,
+			     &page_list, &nr_scan, sc->order,
+			     (sc->order > HIGH_ORDER)? ISOLATE_BOTH : 0);
 		nr_active = deactivate_pages(&page_list);
 
 		__mod_zone_page_state(zone, NR_ACTIVE, -nr_active);
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
