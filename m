From: akpm@linux-foundation.org
Subject: - lumpy-increase-pressure-at-the-end-of-the-inactive-list.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:17:03 -0700
Message-ID: <200704270817.l3R8H3tD023130@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755506AbXD0IRj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:17:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     lumpy: increase pressure at the end of the inactive list
has been removed from the -mm tree.  Its filename was
     lumpy-increase-pressure-at-the-end-of-the-inactive-list.patch

This patch was dropped because it was folded into lumpy-reclaim-v4.patch

------------------------------------------------------
Subject: lumpy: increase pressure at the end of the inactive list
From: Andy Whitcroft <apw@shadowen.org>

Having selected an area at the end of the inactive list, reclaim is
attempted for all LRU pages within that contiguous area.  Currently, any
pages in this area found to still be active or referenced are rotated back
to the active list as normal and the rest reclaimed.  At low orders there
is a reasonable likelyhood of finding contigious inactive areas for
reclaim.  However when reclaiming at higher order there is a very low
chance all pages in the area being inactive, unreferenced and therefore
reclaimable.

This patch modifies behaviour when reclaiming at higher order (order >= 4).
 All LRU pages within the target area are reclaimed, including both active
and recently referenced pages.

[mel@csn.ul.ie: additionally apply pressure to referenced paged]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   38 +++++++++++++++++++++++++++++++++-----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff -puN mm/vmscan.c~lumpy-increase-pressure-at-the-end-of-the-inactive-list mm/vmscan.c
--- a/mm/vmscan.c~lumpy-increase-pressure-at-the-end-of-the-inactive-list
+++ a/mm/vmscan.c
@@ -487,7 +487,7 @@ static unsigned long shrink_page_list(st
 
 		referenced = page_referenced(page, 1);
 		/* In active use or really unfreeable?  Activate it. */
-		if (referenced && page_mapping_inuse(page))
+		if (sc->order <= 3 && referenced && page_mapping_inuse(page))
 			goto activate_locked;
 
 #ifdef CONFIG_SWAP
@@ -520,7 +520,7 @@ static unsigned long shrink_page_list(st
 		}
 
 		if (PageDirty(page)) {
-			if (referenced)
+			if (sc->order <= 3 && referenced)
 				goto keep_locked;
 			if (!may_enter_fs)
 				goto keep_locked;
@@ -614,6 +614,7 @@ keep:
  *
  * returns 0 on success, -ve errno on failure.
  */
+#define ISOLATE_BOTH -1		/* Isolate both active and inactive pages. */
 static int __isolate_lru_page(struct page *page, int active)
 {
 	int ret = -EINVAL;
@@ -623,7 +624,8 @@ static int __isolate_lru_page(struct pag
 	 * dealing with comparible boolean values.  Take the logical not
 	 * of each.
 	 */
-	if (PageLRU(page) && (!PageActive(page) == !active)) {
+	if (PageLRU(page) && (active == ISOLATE_BOTH ||
+					(!PageActive(page) == !active))) {
 		ret = -EBUSY;
 		if (likely(get_page_unless_zero(page))) {
 			/*
@@ -745,6 +747,26 @@ static unsigned long isolate_lru_pages(u
 }
 
 /*
+ * deactivate_pages() is a helper for shrink_active_list(), it deactivates
+ * all active pages on the passed list.
+ */
+static unsigned long deactivate_pages(struct list_head *page_list)
+{
+	int nr_active = 0;
+	struct list_head *entry;
+
+	list_for_each(entry, page_list) {
+		struct page *page = list_entry(entry, struct page, lru);
+		if (PageActive(page)) {
+			ClearPageActive(page);
+			nr_active++;
+		}
+	}
+
+	return nr_active;
+}
+
+/*
  * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
  * of reclaimed pages
  */
@@ -765,11 +787,17 @@ static unsigned long shrink_inactive_lis
 		unsigned long nr_taken;
 		unsigned long nr_scan;
 		unsigned long nr_freed;
+		unsigned long nr_active;
 
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
 				     &zone->inactive_list,
-				     &page_list, &nr_scan, sc->order, 0);
-		__mod_zone_page_state(zone, NR_INACTIVE, -nr_taken);
+				     &page_list, &nr_scan, sc->order,
+				     (sc->order > 3)? ISOLATE_BOTH : 0);
+		nr_active = deactivate_pages(&page_list);
+
+		__mod_zone_page_state(zone, NR_ACTIVE, -nr_active);
+		__mod_zone_page_state(zone, NR_INACTIVE,
+						-(nr_taken - nr_active));
 		zone->pages_scanned += nr_scan;
 		spin_unlock_irq(&zone->lru_lock);
 
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
