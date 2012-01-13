From: akpm@linux-foundation.org
Subject: [merged] mm-remove-isolate_pages.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:01 -0800
Message-ID: <20120113203601.9467910004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:56060 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759123Ab2AMUgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:02 -0500
Received: by mail-yx0-f202.google.com with SMTP id l1so72336yen.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove isolate_pages()
has been removed from the -mm tree.  Its filename was
     mm-remove-isolate_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: remove isolate_pages()

The isolate_pages() level in vmscan.c offers little but indirection: merge
it into isolate_lru_pages() as the compiler does, and use the names
nr_to_scan and nr_scanned in each case.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   61 ++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff -puN mm/vmscan.c~mm-remove-isolate_pages mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-isolate_pages
+++ a/mm/vmscan.c
@@ -1136,25 +1136,36 @@ int __isolate_lru_page(struct page *page
  * Appropriate locks must be held before calling this function.
  *
  * @nr_to_scan:	The number of pages to look through on the list.
- * @src:	The LRU list to pull pages off.
+ * @mz:		The mem_cgroup_zone to pull pages from.
  * @dst:	The temp list to put pages on to.
- * @scanned:	The number of pages that were scanned.
+ * @nr_scanned:	The number of pages that were scanned.
  * @order:	The caller's attempted allocation order
  * @mode:	One of the LRU isolation modes
+ * @active:	True [1] if isolating active pages
  * @file:	True [1] if isolating file [!anon] pages
  *
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
-		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned, int order, isolate_mode_t mode,
-		int file)
+		struct mem_cgroup_zone *mz, struct list_head *dst,
+		unsigned long *nr_scanned, int order, isolate_mode_t mode,
+		int active, int file)
 {
+	struct lruvec *lruvec;
+	struct list_head *src;
 	unsigned long nr_taken = 0;
 	unsigned long nr_lumpy_taken = 0;
 	unsigned long nr_lumpy_dirty = 0;
 	unsigned long nr_lumpy_failed = 0;
 	unsigned long scan;
+	int lru = LRU_BASE;
+
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
+	if (active)
+		lru += LRU_ACTIVE;
+	if (file)
+		lru += LRU_FILE;
+	src = &lruvec->lists[lru];
 
 	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
 		struct page *page;
@@ -1263,7 +1274,7 @@ static unsigned long isolate_lru_pages(u
 			nr_lumpy_failed++;
 	}
 
-	*scanned = scan;
+	*nr_scanned = scan;
 
 	trace_mm_vmscan_lru_isolate(order,
 			nr_to_scan, scan,
@@ -1273,23 +1284,6 @@ static unsigned long isolate_lru_pages(u
 	return nr_taken;
 }
 
-static unsigned long isolate_pages(unsigned long nr, struct mem_cgroup_zone *mz,
-				   struct list_head *dst,
-				   unsigned long *scanned, int order,
-				   isolate_mode_t mode, int active, int file)
-{
-	struct lruvec *lruvec;
-	int lru = LRU_BASE;
-
-	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
-	if (active)
-		lru += LRU_ACTIVE;
-	if (file)
-		lru += LRU_FILE;
-	return isolate_lru_pages(nr, &lruvec->lists[lru], dst,
-				 scanned, order, mode, file);
-}
-
 /*
  * clear_active_flags() is a helper for shrink_active_list(), clearing
  * any active bits from the pages in the list.
@@ -1559,9 +1553,9 @@ shrink_inactive_list(unsigned long nr_to
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_pages(nr_to_scan, mz, &page_list,
-				 &nr_scanned, sc->order,
-				 reclaim_mode, 0, file);
+	nr_taken = isolate_lru_pages(nr_to_scan, mz, &page_list,
+				     &nr_scanned, sc->order,
+				     reclaim_mode, 0, file);
 	if (global_reclaim(sc)) {
 		zone->pages_scanned += nr_scanned;
 		if (current_is_kswapd())
@@ -1700,13 +1694,13 @@ static void move_active_pages_to_lru(str
 		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
 
-static void shrink_active_list(unsigned long nr_pages,
+static void shrink_active_list(unsigned long nr_to_scan,
 			       struct mem_cgroup_zone *mz,
 			       struct scan_control *sc,
 			       int priority, int file)
 {
 	unsigned long nr_taken;
-	unsigned long pgscanned;
+	unsigned long nr_scanned;
 	unsigned long vm_flags;
 	LIST_HEAD(l_hold);	/* The pages which were snipped off */
 	LIST_HEAD(l_active);
@@ -1726,16 +1720,15 @@ static void shrink_active_list(unsigned 
 
 	spin_lock_irq(&zone->lru_lock);
 
-	nr_taken = isolate_pages(nr_pages, mz, &l_hold,
-				 &pgscanned, sc->order,
-				 reclaim_mode, 1, file);
