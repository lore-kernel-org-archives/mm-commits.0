From: akpm@linux-foundation.org
Subject: - introduce-high_order-delineating-easily-reclaimable-orders-cleanups.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:17:08 -0700
Message-ID: <200704270817.l3R8H86t023137@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35588 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755507AbXD0IRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     lumpy: introduce HIGH_ORDER delineating easily reclaimable orders cleanups
has been removed from the -mm tree.  Its filename was
     introduce-high_order-delineating-easily-reclaimable-orders-cleanups.patch

This patch was dropped because it was folded into lumpy-reclaim-v4.patch

------------------------------------------------------
Subject: lumpy: introduce HIGH_ORDER delineating easily reclaimable orders cleanups
From: Andy Whitcroft <apw@shadowen.org>

Switch from HIGH_ORDER to the more logical and descriptive
PAGE_ALLOC_COSTLY_ORDER indicating the boundary between orders easily
reclaimed and allocated and those which are not.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    9 +++++----
 mm/page_alloc.c        |    3 ++-
 mm/vmscan.c            |    7 ++++---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff -puN include/linux/mmzone.h~introduce-high_order-delineating-easily-reclaimable-orders-cleanups include/linux/mmzone.h
--- a/include/linux/mmzone.h~introduce-high_order-delineating-easily-reclaimable-orders-cleanups
+++ a/include/linux/mmzone.h
@@ -26,11 +26,12 @@
 #define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
 
 /*
- * The boundary between small and large allocations.  That is between
- * allocation orders which should colesce naturally under reasonable
- * reclaim pressure and those which will not.
+ * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
+ * costly to service.  That is between allocation orders which should
+ * coelesce naturally under reasonable reclaim pressure and those which
+ * will not.
  */
-#define HIGH_ORDER 3
+#define PAGE_ALLOC_COSTLY_ORDER 3
 
 #ifdef CONFIG_PAGE_GROUP_BY_MOBILITY
 #define MIGRATE_UNMOVABLE     0
diff -puN mm/page_alloc.c~introduce-high_order-delineating-easily-reclaimable-orders-cleanups mm/page_alloc.c
--- a/mm/page_alloc.c~introduce-high_order-delineating-easily-reclaimable-orders-cleanups
+++ a/mm/page_alloc.c
@@ -1677,7 +1677,8 @@ nofail_alloc:
 	 */
 	do_retry = 0;
 	if (!(gfp_mask & __GFP_NORETRY)) {
-		if ((order <= HIGH_ORDER) || (gfp_mask & __GFP_REPEAT))
+		if ((order <= PAGE_ALLOC_COSTLY_ORDER) ||
+						(gfp_mask & __GFP_REPEAT))
 			do_retry = 1;
 		if (gfp_mask & __GFP_NOFAIL)
 			do_retry = 1;
diff -puN mm/vmscan.c~introduce-high_order-delineating-easily-reclaimable-orders-cleanups mm/vmscan.c
--- a/mm/vmscan.c~introduce-high_order-delineating-easily-reclaimable-orders-cleanups
+++ a/mm/vmscan.c
@@ -487,7 +487,7 @@ static unsigned long shrink_page_list(st
 
 		referenced = page_referenced(page, 1);
 		/* In active use or really unfreeable?  Activate it. */
-		if (sc->order <= HIGH_ORDER &&
+		if (sc->order <= PAGE_ALLOC_COSTLY_ORDER &&
 					referenced && page_mapping_inuse(page))
 			goto activate_locked;
 
@@ -521,7 +521,7 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
-			if (sc->order <= HIGH_ORDER && referenced)
+			if (sc->order <= PAGE_ALLOC_COSTLY_ORDER && referenced)
 				goto keep_locked;
 			if (!may_enter_fs)
 				goto keep_locked;
@@ -793,7 +793,8 @@ static unsigned long shrink_inactive_lis
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
 			     &zone->inactive_list,
 			     &page_list, &nr_scan, sc->order,
-			     (sc->order > HIGH_ORDER)? ISOLATE_BOTH : 0);
+			     (sc->order > PAGE_ALLOC_COSTLY_ORDER)?
+							ISOLATE_BOTH : 0);
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
