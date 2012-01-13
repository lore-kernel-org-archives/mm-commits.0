From: akpm@linux-foundation.org
Subject: [merged] mm-enum-lru_list-lru.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:53 -0800
Message-ID: <20120113203554.03CDD20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57647 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759101Ab2AMUfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:55 -0500
Received: by mail-ee0-f74.google.com with SMTP id e50so23684eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: enum lru_list lru
has been removed from the -mm tree.  Its filename was
     mm-enum-lru_list-lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: enum lru_list lru

Mostly we use "enum lru_list lru": change those few "l"s to "lru"s.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   26 +++++++++++++-------------
 include/linux/mmzone.h    |   16 ++++++++--------
 mm/page_alloc.c           |    6 +++---
 mm/vmscan.c               |   22 +++++++++++-----------
 4 files changed, 35 insertions(+), 35 deletions(-)

diff -puN include/linux/mm_inline.h~mm-enum-lru_list-lru include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~mm-enum-lru_list-lru
+++ a/include/linux/mm_inline.h
@@ -22,21 +22,21 @@ static inline int page_is_file_cache(str
 }
 
 static inline void
-add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
 	struct lruvec *lruvec;
 
-	lruvec = mem_cgroup_lru_add_list(zone, page, l);
-	list_add(&page->lru, &lruvec->lists[l]);
-	__mod_zone_page_state(zone, NR_LRU_BASE + l, hpage_nr_pages(page));
+	lruvec = mem_cgroup_lru_add_list(zone, page, lru);
+	list_add(&page->lru, &lruvec->lists[lru]);
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, hpage_nr_pages(page));
 }
 
 static inline void
-del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list l)
+del_page_from_lru_list(struct zone *zone, struct page *page, enum lru_list lru)
 {
-	mem_cgroup_lru_del_list(page, l);
+	mem_cgroup_lru_del_list(page, lru);
 	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + l, -hpage_nr_pages(page));
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
 }
 
 /**
@@ -57,21 +57,21 @@ static inline enum lru_list page_lru_bas
 static inline void
 del_page_from_lru(struct zone *zone, struct page *page)
 {
-	enum lru_list l;
+	enum lru_list lru;
 
 	if (PageUnevictable(page)) {
 		__ClearPageUnevictable(page);
-		l = LRU_UNEVICTABLE;
+		lru = LRU_UNEVICTABLE;
 	} else {
-		l = page_lru_base_type(page);
+		lru = page_lru_base_type(page);
 		if (PageActive(page)) {
 			__ClearPageActive(page);
-			l += LRU_ACTIVE;
+			lru += LRU_ACTIVE;
 		}
 	}
-	mem_cgroup_lru_del_list(page, l);
+	mem_cgroup_lru_del_list(page, lru);
 	list_del(&page->lru);
-	__mod_zone_page_state(zone, NR_LRU_BASE + l, -hpage_nr_pages(page));
+	__mod_zone_page_state(zone, NR_LRU_BASE + lru, -hpage_nr_pages(page));
 }
 
 /**
diff -puN include/linux/mmzone.h~mm-enum-lru_list-lru include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-enum-lru_list-lru
+++ a/include/linux/mmzone.h
@@ -140,23 +140,23 @@ enum lru_list {
 	NR_LRU_LISTS
 };
 
-#define for_each_lru(l) for (l = 0; l < NR_LRU_LISTS; l++)
+#define for_each_lru(lru) for (lru = 0; lru < NR_LRU_LISTS; lru++)
 
-#define for_each_evictable_lru(l) for (l = 0; l <= LRU_ACTIVE_FILE; l++)
+#define for_each_evictable_lru(lru) for (lru = 0; lru <= LRU_ACTIVE_FILE; lru++)
 
-static inline int is_file_lru(enum lru_list l)
+static inline int is_file_lru(enum lru_list lru)
 {
-	return (l == LRU_INACTIVE_FILE || l == LRU_ACTIVE_FILE);
+	return (lru == LRU_INACTIVE_FILE || lru == LRU_ACTIVE_FILE);
 }
 
-static inline int is_active_lru(enum lru_list l)
+static inline int is_active_lru(enum lru_list lru)
 {
-	return (l == LRU_ACTIVE_ANON || l == LRU_ACTIVE_FILE);
+	return (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE);
 }
 
-static inline int is_unevictable_lru(enum lru_list l)
+static inline int is_unevictable_lru(enum lru_list lru)
 {
-	return (l == LRU_UNEVICTABLE);
+	return (lru == LRU_UNEVICTABLE);
 }
 
 struct lruvec {
diff -puN mm/page_alloc.c~mm-enum-lru_list-lru mm/page_alloc.c
--- a/mm/page_alloc.c~mm-enum-lru_list-lru
+++ a/mm/page_alloc.c
@@ -4262,7 +4262,7 @@ static void __paginginit free_area_init_
 	for (j = 0; j < MAX_NR_ZONES; j++) {
 		struct zone *zone = pgdat->node_zones + j;
 		unsigned long size, realsize, memmap_pages;
-		enum lru_list l;
+		enum lru_list lru;
 
 		size = zone_spanned_pages_in_node(nid, j, zones_size);
 		realsize = size - zone_absent_pages_in_node(nid, j,
@@ -4312,8 +4312,8 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		for_each_lru(l)
-			INIT_LIST_HEAD(&zone->lruvec.lists[l]);
+		for_each_lru(lru)
+			INIT_LIST_HEAD(&zone->lruvec.lists[lru]);
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
 		zone->reclaim_stat.recent_scanned[0] = 0;
diff -puN mm/vmscan.c~mm-enum-lru_list-lru mm/vmscan.c
--- a/mm/vmscan.c~mm-enum-lru_list-lru
+++ a/mm/vmscan.c
@@ -1920,7 +1920,7 @@ static void get_scan_count(struct mem_cg
 	unsigned long ap, fp;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
 	u64 fraction[2], denominator;
-	enum lru_list l;
+	enum lru_list lru;
 	int noswap = 0;
 	bool force_scan = false;
 
@@ -2010,18 +2010,18 @@ static void get_scan_count(struct mem_cg
 	fraction[1] = fp;
 	denominator = ap + fp + 1;
 out:
-	for_each_evictable_lru(l) {
-		int file = is_file_lru(l);
+	for_each_evictable_lru(lru) {
+		int file = is_file_lru(lru);
 		unsigned long scan;
 
-		scan = zone_nr_lru_pages(mz, l);
+		scan = zone_nr_lru_pages(mz, lru);
 		if (priority || noswap) {
 			scan >>= priority;
 			if (!scan && force_scan)
 				scan = SWAP_CLUSTER_MAX;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
-		nr[l] = scan;
+		nr[lru] = scan;
 	}
 }
 
@@ -2097,7 +2097,7 @@ static void shrink_mem_cgroup_zone(int p
 {
 	unsigned long nr[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
-	enum lru_list l;
+	enum lru_list lru;
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
@@ -2110,13 +2110,13 @@ restart:
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
-		for_each_evictable_lru(l) {
-			if (nr[l]) {
+		for_each_evictable_lru(lru) {
+			if (nr[lru]) {
 				nr_to_scan = min_t(unsigned long,
-						   nr[l], SWAP_CLUSTER_MAX);
-				nr[l] -= nr_to_scan;
+						   nr[lru], SWAP_CLUSTER_MAX);
+				nr[lru] -= nr_to_scan;
 
-				nr_reclaimed += shrink_list(l, nr_to_scan,
+				nr_reclaimed += shrink_list(lru, nr_to_scan,
 							    mz, sc, priority);
 			}
 		}
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
linux-next.patch
prio_tree-debugging-patch.patch

