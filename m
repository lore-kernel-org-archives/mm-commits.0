From: akpm@linux-foundation.org
Subject: - introduce-zone_reclaim-struct.patch removed from -mm tree
Date: Tue, 02 Dec 2008 21:37:42 -0800
Message-ID: <200812030537.mB35bgOr018179@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59984 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751369AbYLCFiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 00:38:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     introduce zone_reclaim struct
has been removed from the -mm tree.  Its filename was
     introduce-zone_reclaim-struct.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce zone_reclaim struct
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Make zone_reclam_stat a strut for latter enhancement.

A later patch uses this.  This patch doesn't any behavior change (yet).

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   24 +++++++++++--------
 mm/page_alloc.c        |    8 +++---
 mm/swap.c              |   12 ++++++---
 mm/vmscan.c            |   47 ++++++++++++++++++++++++---------------
 4 files changed, 56 insertions(+), 35 deletions(-)

diff -puN include/linux/mmzone.h~introduce-zone_reclaim-struct include/linux/mmzone.h
--- a/include/linux/mmzone.h~introduce-zone_reclaim-struct
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
 	unsigned long		slab_defrag_counter; /* since last defrag */
diff -puN mm/page_alloc.c~introduce-zone_reclaim-struct mm/page_alloc.c
--- a/mm/page_alloc.c~introduce-zone_reclaim-struct
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
diff -puN mm/swap.c~introduce-zone_reclaim-struct mm/swap.c
--- a/mm/swap.c~introduce-zone_reclaim-struct
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
@@ -398,6 +399,8 @@ void ____pagevec_lru_add(struct pagevec 
 {
 	int i;
 	struct zone *zone = NULL;
+	struct zone_reclaim_stat *reclaim_stat = NULL;
+
 	VM_BUG_ON(is_unevictable_lru(lru));
 
 	for (i = 0; i < pagevec_count(pvec); i++) {
@@ -409,6 +412,7 @@ void ____pagevec_lru_add(struct pagevec 
 			if (zone)
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
+			reclaim_stat = &zone->reclaim_stat;
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageActive(page));
@@ -416,10 +420,10 @@ void ____pagevec_lru_add(struct pagevec 
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
diff -puN mm/vmscan.c~introduce-zone_reclaim-struct mm/vmscan.c
--- a/mm/vmscan.c~introduce-zone_reclaim-struct
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
@@ -1076,6 +1082,7 @@ static unsigned long shrink_inactive_lis
 	struct pagevec pvec;
 	unsigned long nr_scanned = 0;
 	unsigned long nr_reclaimed = 0;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	pagevec_init(&pvec, 1);
 
@@ -1119,10 +1126,14 @@ static unsigned long shrink_inactive_lis
 
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
 
@@ -1183,7 +1194,7 @@ static unsigned long shrink_inactive_lis
 			add_page_to_lru_list(zone, page, lru);
 			if (PageActive(page) && scan_global_lru(sc)) {
 				int file = !!page_is_file_cache(page);
-				zone->recent_rotated[file]++;
+				reclaim_stat->recent_rotated[file]++;
 			}
 			if (!pagevec_add(&pvec, page)) {
 				spin_unlock_irq(&zone->lru_lock);
@@ -1243,6 +1254,7 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct pagevec pvec;
 	enum lru_list lru;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1255,7 +1267,7 @@ static void shrink_active_list(unsigned 
 	 */
 	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
-		zone->recent_scanned[!!file] += pgmoved;
+		reclaim_stat->recent_scanned[!!file] += pgmoved;
 	}
 
 	if (file)
@@ -1291,7 +1303,7 @@ static void shrink_active_list(unsigned 
 	 * pages in get_scan_ratio.
 	 */
 	if (scan_global_lru(sc))
-		zone->recent_rotated[!!file] += pgmoved;
+		reclaim_stat->recent_rotated[!!file] += pgmoved;
 
 	/*
 	 * Move the pages to the [file or anon] inactive list.
@@ -1391,6 +1403,7 @@ static void get_scan_ratio(struct zone *
 	unsigned long anon, file, free;
 	unsigned long anon_prio, file_prio;
 	unsigned long ap, fp;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (nr_swap_pages <= 0) {
@@ -1423,17 +1436,17 @@ static void get_scan_ratio(struct zone *
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
 
@@ -1449,11 +1462,11 @@ static void get_scan_ratio(struct zone *
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

vmscan-evict-streaming-io-first.patch
linux-next.patch
arch-ia64-kernel-iosapicc-fix-warnings.patch
mm-report-the-pagesize-backing-a-vma-in-proc-pid-smaps.patch
mm-report-the-mmu-pagesize-in-proc-pid-smaps.patch
oom-fix-zone_scan_mutex-name.patch
mm-get-rid-of-pagevec_release_nonlru.patch
cleanup-get-rid-of-ifdef-config_migration.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-make-page_lock_anon_vma-static.patch
memcg-reclaim-shouldnt-change-zone-recent_rotated-statistics.patch
mm-make-init_section_page_cgroup-static.patch
mm-make-maddr-__iomem.patch
mm-make-mem_cgroup_resize_limit-static.patch
mm-make-scan_all_zones_unevictable_pages-static.patch
mm-make-scan_zone_unevictable_pages-static.patch
mm-make-setup_per_zone_inactive_ratio-static.patch
mm-make-vread-and-vwrite-declaration.patch
vmscan-bail-out-of-direct-reclaim-after-swap_cluster_max-pages.patch
mm-kill-zone_is_near_oom.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
introduce-zone_reclaim-struct.patch
add-zone_nr_pages-helper-function.patch
make-get_scan_ratio-memcg-safe.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-remove-mem_cgroup_calc_reclaim.patch
memcg-show-inactive_ratio.patch
memcg-show-reclaim_stat.patch

