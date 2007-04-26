From: akpm@linux-foundation.org
Subject: + lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups.patch added to -mm tree
Date: Wed, 25 Apr 2007 18:49:18 -0700
Message-ID: <200704260149.l3Q1nIAR018285@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754041AbXDZBuB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 21:50:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org, mel@csn.ul.ie


The patch titled
     lumpy: increase pressure at the end of the inactive list cleanups
has been added to the -mm tree.  Its filename is
     lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lumpy: increase pressure at the end of the inactive list cleanups
From: Andy Whitcroft <apw@shadowen.org>

1) introduces ISOLATE_[ACTIVE,INACTIVE],
2) changes the name of the deactivate_pages() helper to clear_active_flags(),
3) cleans up and simplifies the checks in __isolate_lru_pages(), and
4) changes the parameter active to mode throughout.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   64 +++++++++++++++++++++++++++-----------------------
 1 file changed, 35 insertions(+), 29 deletions(-)

diff -puN mm/vmscan.c~lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups mm/vmscan.c
--- a/mm/vmscan.c~lumpy-increase-pressure-at-the-end-of-the-inactive-list-cleanups
+++ a/mm/vmscan.c
@@ -605,38 +605,46 @@ keep:
 	return nr_reclaimed;
 }
 
+/* LRU Isolation modes. */
+#define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
+#define ISOLATE_ACTIVE 1	/* Isolate active pages. */
+#define ISOLATE_BOTH 2		/* Isolate both active and inactive pages. */
+
 /*
  * Attempt to remove the specified page from its LRU.  Only take this page
  * if it is of the appropriate PageActive status.  Pages which are being
  * freed elsewhere are also ignored.
  *
  * page:	page to consider
- * active:	active/inactive flag only take pages of this type
+ * mode:	one of the LRU isolation modes defined above
  *
  * returns 0 on success, -ve errno on failure.
  */
-#define ISOLATE_BOTH -1		/* Isolate both active and inactive pages. */
-static int __isolate_lru_page(struct page *page, int active)
+static int __isolate_lru_page(struct page *page, int mode)
 {
 	int ret = -EINVAL;
 
+	/* Only take pages on the LRU. */
+	if (!PageLRU(page))
+		return ret;
+
 	/*
 	 * When checking the active state, we need to be sure we are
 	 * dealing with comparible boolean values.  Take the logical not
 	 * of each.
 	 */
-	if (PageLRU(page) && (active == ISOLATE_BOTH ||
-					(!PageActive(page) == !active))) {
-		ret = -EBUSY;
-		if (likely(get_page_unless_zero(page))) {
-			/*
-			 * Be careful not to clear PageLRU until after we're
-			 * sure the page is not being freed elsewhere -- the
-			 * page release code relies on it.
-			 */
-			ClearPageLRU(page);
-			ret = 0;
-		}
+	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode))
+		return ret;
+
+	ret = -EBUSY;
+	if (likely(get_page_unless_zero(page))) {
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		ClearPageLRU(page);
+		ret = 0;
 	}
 
 	return ret;
@@ -657,13 +665,13 @@ static int __isolate_lru_page(struct pag
  * @dst:	The temp list to put pages on to.
  * @scanned:	The number of pages that were scanned.
  * @order:	The caller's attempted allocation order
- * @active:	The caller's trying to obtain active or inactive pages
+ * @mode:	One of the LRU isolation modes
  *
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned, int order, int active)
+		unsigned long *scanned, int order, int mode)
 {
 	unsigned long nr_taken = 0;
 	unsigned long scan;
@@ -680,7 +688,7 @@ static unsigned long isolate_lru_pages(u
 
 		VM_BUG_ON(!PageLRU(page));
 
-		switch (__isolate_lru_page(page, active)) {
+		switch (__isolate_lru_page(page, mode)) {
 		case 0:
 			list_move(&page->lru, dst);
 			nr_taken++;
@@ -727,7 +735,7 @@ static unsigned long isolate_lru_pages(u
 			/* Check that we have not crossed a zone boundary. */
 			if (unlikely(page_zone_id(cursor_page) != zone_id))
 				continue;
-			switch (__isolate_lru_page(cursor_page, active)) {
+			switch (__isolate_lru_page(cursor_page, mode)) {
 			case 0:
 				list_move(&cursor_page->lru, dst);
 				nr_taken++;
@@ -748,21 +756,19 @@ static unsigned long isolate_lru_pages(u
 }
 
 /*
- * deactivate_pages() is a helper for shrink_active_list(), it deactivates
- * all active pages on the passed list.
+ * clear_active_flags() is a helper for shrink_active_list(), clearing
+ * any active bits from the pages in the list.
  */
-static unsigned long deactivate_pages(struct list_head *page_list)
+static unsigned long clear_active_flags(struct list_head *page_list)
 {
 	int nr_active = 0;
-	struct list_head *entry;
+	struct page *page;
 
-	list_for_each(entry, page_list) {
-		struct page *page = list_entry(entry, struct page, lru);
+	list_for_each_entry(page, page_list, lru)
 		if (PageActive(page)) {
 			ClearPageActive(page);
 			nr_active++;
 		}
-	}
 
 	return nr_active;
 }
@@ -794,8 +800,8 @@ static unsigned long shrink_inactive_lis
 			     &zone->inactive_list,
 			     &page_list, &nr_scan, sc->order,
 			     (sc->order > PAGE_ALLOC_COSTLY_ORDER)?
-							ISOLATE_BOTH : 0);
-		nr_active = deactivate_pages(&page_list);
+					     ISOLATE_BOTH : ISOLATE_INACTIVE);
+		nr_active = clear_active_flags(&page_list);
 
 		__mod_zone_page_state(zone, NR_ACTIVE, -nr_active);
 		__mod_zone_page_state(zone, NR_INACTIVE,
@@ -944,7 +950,7 @@ force_reclaim_mapped:
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = isolate_lru_pages(nr_pages, &zone->active_list,
-				    &l_hold, &pgscanned, sc->order, 1);
+			    &l_hold, &pgscanned, sc->order, ISOLATE_ACTIVE);
 	zone->pages_scanned += pgscanned;
 	__mod_zone_page_state(zone, NR_ACTIVE, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
_

Patches currently in -mm which might be from apw@shadowen.org are

pci-device-ensure-sysdata-initialised-v2.patch
add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages-fix.patch
add-a-configure-option-to-group-pages-by-mobility-speedup.patch
move-free-pages-between-lists-on-steal-fix.patch
do-not-group-pages-by-mobility-type-on-low-memory-systems.patch
fix-corruption-of-memmap-on-ia64-sparsemem-when-mem_section-is-not-a-power-of-2.patch
create-the-zone_movable-zone-align-zone_movable-to-a-max_order_nr_pages-boundary.patch
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
slab-numa-kmem_cache-diet.patch
sched-implement-staircase-deadline-cpu-scheduler-misc-fixes.patch
