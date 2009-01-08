From: akpm@linux-foundation.org
Subject: - mm-introduce-zone_reclaim-struct.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:05 -0800
Message-ID: <200901082249.n08Mn5WW028384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761898AbZAHWt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:49:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: introduce zone_reclaim struct
has been removed from the -mm tree.  Its filename was
     mm-introduce-zone_reclaim-struct.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: introduce zone_reclaim struct
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Add zone_reclam_stat struct for later enhancement.

A later patch uses this.  This patch doesn't any behavior change (yet).

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   24 +++++++++++--------
 mm/page_alloc.c        |    8 +++---
 mm/swap.c              |   12 ++++++---
 mm/vmscan.c            |   47 ++++++++++++++++++++++++---------------
 4 files changed, 56 insertions(+), 35 deletions(-)

diff -puN include/linux/mmzone.h~mm-introduce-zone_reclaim-struct include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-introduce-zone_reclaim-struct
+++ a/include/linux/mmzone.h
@@ -263,6 +263,19 @@ enum zone_type {
 #error ZONES_SHIFT -- too many zones configured adjust calculation
 #endif
 
+struct zone_reclaim_stat {
+	/*
+	 * The pageout code in vmscan.c keeps track of how many of the
+	 * mem/swap backed and file backed pages are refeferenced.
+	 * The higher the rotated/scanned ratio, the more valuable
+	 * that cache is.
+	 *
+	 * The anon LRU stats live in [0], file LRU stats in [1]
+	 */
+	unsigned long		recent_rotated[2];
+	unsigned long		recent_scanned[2];
+};
+
 struct zone {
 	/* Fields commonly accessed by the page allocator */
 	unsigned long		pages_min, pages_low, pages_high;
@@ -315,16 +328,7 @@ struct zone {
 		unsigned long nr_scan;
 	} lru[NR_LRU_LISTS];
 
-	/*
-	 * The pageout code in vmscan.c keeps track of how many of the
-	 * mem/swap backed and file backed pages are refeferenced.
-	 * The higher the rotated/scanned ratio, the more valuable
-	 * that cache is.
-	 *
-	 * The anon LRU stats live in [0], file LRU stats in [1]
-	 */
-	unsigned long		recent_rotated[2];
-	unsigned long		recent_scanned[2];
+	struct zone_reclaim_stat reclaim_stat;
 
 	unsigned long		pages_scanned;	   /* since last reclaim */
 	unsigned long		flags;		   /* zone flags, see below */
diff -puN mm/page_alloc.c~mm-introduce-zone_reclaim-struct mm/page_alloc.c
--- a/mm/page_alloc.c~mm-introduce-zone_reclaim-struct
+++ a/mm/page_alloc.c
@@ -3523,10 +3523,10 @@ static void __paginginit free_area_init_
 			INIT_LIST_HEAD(&zone->lru[l].list);
 			zone->lru[l].nr_scan = 0;
 		}
-		zone->recent_rotated[0] = 0;
-		zone->recent_rotated[1] = 0;
-		zone->recent_scanned[0] = 0;
-		zone->recent_scanned[1] = 0;
+		zone->reclaim_stat.recent_rotated[0] = 0;
+		zone->reclaim_stat.recent_rotated[1] = 0;
+		zone->reclaim_stat.recent_scanned[0] = 0;
+		zone->reclaim_stat.recent_scanned[1] = 0;
 		zap_zone_vm_stats(zone);
 		zone->flags = 0;
 		if (!size)
diff -puN mm/swap.c~mm-introduce-zone_reclaim-struct mm/swap.c
--- a/mm/swap.c~mm-introduce-zone_reclaim-struct
+++ a/mm/swap.c
@@ -157,6 +157,7 @@ void  rotate_reclaimable_page(struct pag
 void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
+	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -169,8 +170,8 @@ void activate_page(struct page *page)
 		add_page_to_lru_list(zone, page, lru);
 		__count_vm_event(PGACTIVATE);
 
-		zone->recent_rotated[!!file]++;
-		zone->recent_scanned[!!file]++;
+		reclaim_stat->recent_rotated[!!file]++;
+		reclaim_stat->recent_scanned[!!file]++;
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -385,6 +386,8 @@ void ____pagevec_lru_add(struct pagevec 
 {
 	int i;
 	struct zone *zone = NULL;
+	struct zone_reclaim_stat *reclaim_stat = NULL;
+
 	VM_BUG_ON(is_unevictable_lru(lru));
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
@@ -396,6 +399,7 @@ void ____pagevec_lru_add(struct pagevec 
 			if (zone)
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
+			reclaim_stat = &zone->reclaim_stat;
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageActive(page));
@@ -403,10 +407,10 @@ void ____pagevec_lru_add(struct pagevec 
 		VM_BUG_ON(PageLRU(page));
 		SetPageLRU(page);
 		file = is_file_lru(lru);
-		zone->recent_scanned[file]++;
+		reclaim_stat->recent_scanned[file]++;
 		if (is_active_lru(lru)) {
 			SetPageActive(page);
-			zone->recent_rotated[file]++;
+			reclaim_stat->recent_rotated[file]++;
 		}
 		add_page_to_lru_list(zone, page, lru);
 	}
diff -puN mm/vmscan.c~mm-introduce-zone_reclaim-struct mm/vmscan.c
--- a/mm/vmscan.c~mm-introduce-zone_reclaim-struct
+++ a/mm/vmscan.c
@@ -130,6 +130,12 @@ static DECLARE_RWSEM(shrinker_rwsem);
 #define scan_global_lru(sc)	(1)
 #endif
 
+static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
+						  struct scan_control *sc)
+{
+	return &zone->reclaim_stat;
+}
+
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1029,6 +1035,7 @@ static unsigned long shrink_inactive_lis
 	struct pagevec pvec;
 	unsigned long nr_scanned = 0;
 	unsigned long nr_reclaimed = 0;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	pagevec_init(&pvec, 1);
 
@@ -1072,10 +1079,14 @@ static unsigned long shrink_inactive_lis
 
 		if (scan_global_lru(sc)) {
 			zone->pages_scanned += nr_scan;
-			zone->recent_scanned[0] += count[LRU_INACTIVE_ANON];
-			zone->recent_scanned[0] += count[LRU_ACTIVE_ANON];
-			zone->recent_scanned[1] += count[LRU_INACTIVE_FILE];
-			zone->recent_scanned[1] += count[LRU_ACTIVE_FILE];
+			reclaim_stat->recent_scanned[0] +=
+						      count[LRU_INACTIVE_ANON];
+			reclaim_stat->recent_scanned[0] +=
+						      count[LRU_ACTIVE_ANON];
+			reclaim_stat->recent_scanned[1] +=
+						      count[LRU_INACTIVE_FILE];
+			reclaim_stat->recent_scanned[1] +=
+						      count[LRU_ACTIVE_FILE];
 		}
 		spin_unlock_irq(&zone->lru_lock);
 
@@ -1136,7 +1147,7 @@ static unsigned long shrink_inactive_lis
 			add_page_to_lru_list(zone, page, lru);
 			if (PageActive(page) && scan_global_lru(sc)) {
 				int file = !!page_is_file_cache(page);
-				zone->recent_rotated[file]++;
+				reclaim_stat->recent_rotated[file]++;
 			}
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
@@ -1196,6 +1207,7 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct pagevec pvec;
 	enum lru_list lru;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1208,7 +1220,7 @@ static void shrink_active_list(unsigned 
 	 */
 	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
-		zone->recent_scanned[!!file] += pgmoved;
+		reclaim_stat->recent_scanned[!!file] += pgmoved;
 	}
 
 	if (file)
@@ -1251,7 +1263,7 @@ static void shrink_active_list(unsigned 
 	 * pages in get_scan_ratio.
 	 */
 	if (scan_global_lru(sc))
-		zone->recent_rotated[!!file] += pgmoved;
+		reclaim_stat->recent_rotated[!!file] += pgmoved;
 
 	while (!list_empty(&l_inactive)) {
 		page = lru_to_page(&l_inactive);
@@ -1344,6 +1356,7 @@ static void get_scan_ratio(struct zone *
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
 	unsigned long ap, fp;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (nr_swap_pages <= 0) {
@@ -1376,17 +1389,17 @@ static void get_scan_ratio(struct zone *
 	 *
 	 * anon in [0], file in [1]
 	 */
-	if (unlikely(zone->recent_scanned[0] > anon / 4)) {
+	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
 		spin_lock_irq(&zone->lru_lock);
-		zone->recent_scanned[0] /= 2;
-		zone->recent_rotated[0] /= 2;
+		reclaim_stat->recent_scanned[0] /= 2;
+		reclaim_stat->recent_rotated[0] /= 2;
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
-	if (unlikely(zone->recent_scanned[1] > file / 4)) {
+	if (unlikely(reclaim_stat->recent_scanned[1] > file / 4)) {
 		spin_lock_irq(&zone->lru_lock);
-		zone->recent_scanned[1] /= 2;
-		zone->recent_rotated[1] /= 2;
+		reclaim_stat->recent_scanned[1] /= 2;
+		reclaim_stat->recent_rotated[1] /= 2;
 		spin_unlock_irq(&zone->lru_lock);
 	}
 
@@ -1402,11 +1415,11 @@ static void get_scan_ratio(struct zone *
 	 * proportional to the fraction of recently scanned pages on
 	 * each list that were recently referenced and in active use.
 	 */
-	ap = (anon_prio + 1) * (zone->recent_scanned[0] + 1);
-	ap /= zone->recent_rotated[0] + 1;
+	ap = (anon_prio + 1) * (reclaim_stat->recent_scanned[0] + 1);
+	ap /= reclaim_stat->recent_rotated[0] + 1;
 
-	fp = (file_prio + 1) * (zone->recent_scanned[1] + 1);
-	fp /= zone->recent_rotated[1] + 1;
+	fp = (file_prio + 1) * (reclaim_stat->recent_scanned[1] + 1);
+	fp /= reclaim_stat->recent_rotated[1] + 1;
 
 	/* Normalize to percentages */
 	percent[0] = 100 * ap / (ap + fp + 1);
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

