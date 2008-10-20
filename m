From: akpm@linux-foundation.org
Subject: - vmscan-second-chance-replacement-for-anonymous-pages.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:40 -0700
Message-ID: <200810202032.m9KKWeql010454@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbYJTUja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:39:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: second chance replacement for anonymous pages
has been removed from the -mm tree.  Its filename was
     vmscan-second-chance-replacement-for-anonymous-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: second chance replacement for anonymous pages
From: Rik van Riel <riel@redhat.com>

We avoid evicting and scanning anonymous pages for the most part, but
under some workloads we can end up with most of memory filled with
anonymous pages.  At that point, we suddenly need to clear the referenced
bits on all of memory, which can take ages on very large memory systems.

We can reduce the maximum number of pages that need to be scanned by not
taking the referenced state into account when deactivating an anonymous
page.  After all, every anonymous page starts out referenced, so why
check?

If an anonymous page gets referenced again before it reaches the end of
the inactive list, we move it back to the active list.

To keep the maximum amount of necessary work reasonable, we scale the
active to inactive ratio with the size of memory, using the formula
active:inactive ratio = sqrt(memory in GB * 10).

Kswapd CPU use now seems to scale by the amount of pageout bandwidth,
instead of by the amount of memory present in the system.

[kamezawa.hiroyu@jp.fujitsu.com: fix OOM with memcg]
[kamezawa.hiroyu@jp.fujitsu.com: memcg: lru scan fix]
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_inline.h |   19 ++++++++++++++++
 include/linux/mmzone.h    |    6 +++++
 mm/page_alloc.c           |   41 ++++++++++++++++++++++++++++++++++++
 mm/vmscan.c               |   38 +++++++++++++++++++++++++++++----
 mm/vmstat.c               |    6 +++--
 5 files changed, 104 insertions(+), 6 deletions(-)

diff -puN include/linux/mm_inline.h~vmscan-second-chance-replacement-for-anonymous-pages include/linux/mm_inline.h
--- a/include/linux/mm_inline.h~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/include/linux/mm_inline.h
@@ -117,4 +117,23 @@ static inline enum lru_list page_lru(str
 	return lru;
 }
 
+/**
+ * inactive_anon_is_low - check if anonymous pages need to be deactivated
+ * @zone: zone to check
+ *
+ * Returns true if the zone does not have enough inactive anon pages,
+ * meaning some active anon pages need to be deactivated.
+ */
+static inline int inactive_anon_is_low(struct zone *zone)
+{
+	unsigned long active, inactive;
+
+	active = zone_page_state(zone, NR_ACTIVE_ANON);
+	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
+
+	if (inactive * zone->inactive_ratio < active)
+		return 1;
+
+	return 0;
+}
 #endif
diff -puN include/linux/mmzone.h~vmscan-second-chance-replacement-for-anonymous-pages include/linux/mmzone.h
--- a/include/linux/mmzone.h~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/include/linux/mmzone.h
@@ -323,6 +323,12 @@ struct zone {
 	 */
 	int prev_priority;
 
+	/*
+	 * The target ratio of ACTIVE_ANON to INACTIVE_ANON pages on
+	 * this zone's LRU.  Maintained by the pageout code.
+	 */
+	unsigned int inactive_ratio;
+
 
 	ZONE_PADDING(_pad2_)
 	/* Rarely used or read-mostly fields */
diff -puN mm/page_alloc.c~vmscan-second-chance-replacement-for-anonymous-pages mm/page_alloc.c
--- a/mm/page_alloc.c~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/mm/page_alloc.c
@@ -4263,6 +4263,46 @@ void setup_per_zone_pages_min(void)
 	calculate_totalreserve_pages();
 }
 
+/**
+ * setup_per_zone_inactive_ratio - called when min_free_kbytes changes.
+ *
+ * The inactive anon list should be small enough that the VM never has to
+ * do too much work, but large enough that each inactive page has a chance
+ * to be referenced again before it is swapped out.
+ *
+ * The inactive_anon ratio is the target ratio of ACTIVE_ANON to
+ * INACTIVE_ANON pages on this zone's LRU, maintained by the
+ * pageout code. A zone->inactive_ratio of 3 means 3:1 or 25% of
+ * the anonymous pages are kept on the inactive list.
+ *
+ * total     target    max
+ * memory    ratio     inactive anon
+ * -------------------------------------
+ *   10MB       1         5MB
+ *  100MB       1        50MB
+ *    1GB       3       250MB
+ *   10GB      10       0.9GB
+ *  100GB      31         3GB
+ *    1TB     101        10GB
+ *   10TB     320        32GB
+ */
+void setup_per_zone_inactive_ratio(void)
+{
+	struct zone *zone;
+
+	for_each_zone(zone) {
+		unsigned int gb, ratio;
+
+		/* Zone size in gigabytes */
+		gb = zone->present_pages >> (30 - PAGE_SHIFT);
+		ratio = int_sqrt(10 * gb);
+		if (!ratio)
+			ratio = 1;
+
+		zone->inactive_ratio = ratio;
+	}
+}
+
 /*
  * Initialise min_free_kbytes.
  *
@@ -4300,6 +4340,7 @@ static int __init init_per_zone_pages_mi
 		min_free_kbytes = 65536;
 	setup_per_zone_pages_min();
 	setup_per_zone_lowmem_reserve();
+	setup_per_zone_inactive_ratio();
 	return 0;
 }
 module_init(init_per_zone_pages_min)
diff -puN mm/vmscan.c~vmscan-second-chance-replacement-for-anonymous-pages mm/vmscan.c
--- a/mm/vmscan.c~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/mm/vmscan.c
@@ -1090,6 +1090,7 @@ static void shrink_active_list(unsigned 
 		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
 
+	pgmoved = 0;
 	while (!list_empty(&l_hold)) {
 		cond_resched();
 		page = lru_to_page(&l_hold);
@@ -1098,6 +1099,13 @@ static void shrink_active_list(unsigned 
 	}
 
 	/*
+	 * Count the referenced pages as rotated, even when they are moved
+	 * to the inactive list.  This helps balance scan pressure between
+	 * file and anonymous pages in get_scan_ratio.
+ 	 */
+	zone->recent_rotated[!!file] += pgmoved;
+
+	/*
 	 * Now put the pages back on the appropriate [file or anon] inactive
 	 * and active lists.
 	 */
@@ -1158,7 +1166,6 @@ static void shrink_active_list(unsigned 
 		}
 	}
 	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	zone->recent_rotated[!!file] += pgmoved;
 
 	__count_zone_vm_events(PGREFILL, zone, pgscanned);
 	__count_vm_events(PGDEACTIVATE, pgdeactivate);
@@ -1174,7 +1181,13 @@ static unsigned long shrink_list(enum lr
 {
 	int file = is_file_lru(lru);
 
-	if (lru == LRU_ACTIVE_ANON || lru == LRU_ACTIVE_FILE) {
+	if (lru == LRU_ACTIVE_FILE) {
+		shrink_active_list(nr_to_scan, zone, sc, priority, file);
+		return 0;
+	}
+
+	if (lru == LRU_ACTIVE_ANON &&
+	    (!scan_global_lru(sc) || inactive_anon_is_low(zone))) {
 		shrink_active_list(nr_to_scan, zone, sc, priority, file);
 		return 0;
 	}
@@ -1310,8 +1323,8 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
-	while (nr[LRU_ACTIVE_ANON] || nr[LRU_INACTIVE_ANON] ||
-			nr[LRU_ACTIVE_FILE] || nr[LRU_INACTIVE_FILE]) {
+	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
+					nr[LRU_INACTIVE_FILE]) {
 		for_each_lru(l) {
 			if (nr[l]) {
 				nr_to_scan = min(nr[l],
@@ -1324,6 +1337,15 @@ static unsigned long shrink_zone(int pri
 		}
 	}
 
+	/*
+	 * Even if we did not try to evict anon pages at all, we want to
+	 * rebalance the anon lru active/inactive ratio.
+	 */
+	if (!scan_global_lru(sc) || inactive_anon_is_low(zone))
+		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
+	else if (!scan_global_lru(sc))
+		shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
+
 	throttle_vm_writeout(sc->gfp_mask);
 	return nr_reclaimed;
 }
@@ -1617,6 +1639,14 @@ loop_again:
 			    priority != DEF_PRIORITY)
 				continue;
 
+			/*
+			 * Do some background aging of the anon list, to give
+			 * pages a chance to be referenced before reclaiming.
+			 */
+			if (inactive_anon_is_low(zone))
+				shrink_active_list(SWAP_CLUSTER_MAX, zone,
+							&sc, priority, 0);
+
 			if (!zone_watermark_ok(zone, order, zone->pages_high,
 					       0, 0)) {
 				end_zone = i;
diff -puN mm/vmstat.c~vmscan-second-chance-replacement-for-anonymous-pages mm/vmstat.c
--- a/mm/vmstat.c~vmscan-second-chance-replacement-for-anonymous-pages
+++ a/mm/vmstat.c
@@ -738,10 +738,12 @@ static void zoneinfo_show_print(struct s
 	seq_printf(m,
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
-		   "\n  start_pfn:         %lu",
+		   "\n  start_pfn:         %lu"
+		   "\n  inactive_ratio:    %u",
 			   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
-		   zone->zone_start_pfn);
+		   zone->zone_start_pfn,
+		   zone->inactive_ratio);
 	seq_putc(m, '\n');
 }
 
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch

