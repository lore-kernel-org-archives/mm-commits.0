From: akpm@linux-foundation.org
Subject: + mm-vmscan-cleanup-lru-size-claculations.patch added to -mm tree
Date: Tue, 17 Jan 2017 13:18:00 -0800
Message-ID: <587e8a08.96GoOqBinP6Xtmse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40564 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751186AbdAQVSB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 16:18:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, mgorman@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmscan: cleanup lru size claculations
has been added to the -mm tree.  Its filename is
     mm-vmscan-cleanup-lru-size-claculations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-cleanup-lru-size-claculations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-cleanup-lru-size-claculations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, vmscan: cleanup lru size claculations

lruvec_lru_size returns the full size of the LRU list while we sometimes
need a value reduced only to eligible zones (e.g. for lowmem requests).
inactive_list_is_low is one such user. Later patches will add more of
them. Add a new parameter to lruvec_lru_size and allow it filter out
zones which are not eligible for the given context.

Link: http://lkml.kernel.org/r/20170117103702.28542-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 
 mm/vmscan.c            |   89 +++++++++++++++++++--------------------
 mm/workingset.c        |    2 
 3 files changed, 46 insertions(+), 47 deletions(-)

diff -puN include/linux/mmzone.h~mm-vmscan-cleanup-lru-size-claculations include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-vmscan-cleanup-lru-size-claculations
+++ a/include/linux/mmzone.h
@@ -780,7 +780,7 @@ static inline struct pglist_data *lruvec
 #endif
 }
 
-extern unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru);
+extern unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx);
 
 #ifdef CONFIG_HAVE_MEMORY_PRESENT
 void memory_present(int nid, unsigned long start, unsigned long end);
diff -puN mm/vmscan.c~mm-vmscan-cleanup-lru-size-claculations mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-cleanup-lru-size-claculations
+++ a/mm/vmscan.c
@@ -234,22 +234,39 @@ bool pgdat_reclaimable(struct pglist_dat
 		pgdat_reclaimable_pages(pgdat) * 6;
 }
 
-unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru)
+/**
+ * lruvec_lru_size -  Returns the number of pages on the given LRU list.
+ * @lruvec: lru vector
+ * @lru: lru to use
+ * @zone_idx: zones to consider (use MAX_NR_ZONES for the whole LRU list)
+ */
+unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone_idx)
 {
+	unsigned long lru_size;
+	int zid;
+
 	if (!mem_cgroup_disabled())
-		return mem_cgroup_get_lru_size(lruvec, lru);
+		lru_size = mem_cgroup_get_lru_size(lruvec, lru);
+	else
+		lru_size = node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
 
-	return node_page_state(lruvec_pgdat(lruvec), NR_LRU_BASE + lru);
-}
+	for (zid = zone_idx + 1; zid < MAX_NR_ZONES; zid++) {
+		struct zone *zone = &lruvec_pgdat(lruvec)->node_zones[zid];
+		unsigned long size;
 
-unsigned long lruvec_zone_lru_size(struct lruvec *lruvec, enum lru_list lru,
-				   int zone_idx)
-{
-	if (!mem_cgroup_disabled())
-		return mem_cgroup_get_zone_lru_size(lruvec, lru, zone_idx);
+		if (!managed_zone(zone))
+			continue;
+
+		if (!mem_cgroup_disabled())
+			size = mem_cgroup_get_zone_lru_size(lruvec, lru, zid);
+		else
+			size = zone_page_state(&lruvec_pgdat(lruvec)->node_zones[zid],
+				       NR_ZONE_LRU_BASE + lru);
+		lru_size -= min(size, lru_size);
+	}
+
+	return lru_size;
 
-	return zone_page_state(&lruvec_pgdat(lruvec)->node_zones[zone_idx],
-			       NR_ZONE_LRU_BASE + lru);
 }
 
 /*
@@ -2049,11 +2066,10 @@ static bool inactive_list_is_low(struct
 						struct scan_control *sc, bool trace)
 {
 	unsigned long inactive_ratio;
-	unsigned long total_inactive, inactive;
-	unsigned long total_active, active;
+	unsigned long inactive, active;
+	enum lru_list inactive_lru = file * LRU_FILE;
+	enum lru_list active_lru = file * LRU_FILE + LRU_ACTIVE;
 	unsigned long gb;
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-	int zid;
 
 	/*
 	 * If we don't have swap space, anonymous page deactivation
@@ -2062,27 +2078,8 @@ static bool inactive_list_is_low(struct
 	if (!file && !total_swap_pages)
 		return false;
 
-	total_inactive = inactive = lruvec_lru_size(lruvec, file * LRU_FILE);
-	total_active = active = lruvec_lru_size(lruvec, file * LRU_FILE + LRU_ACTIVE);
-
-	/*
-	 * For zone-constrained allocations, it is necessary to check if
-	 * deactivations are required for lowmem to be reclaimed. This
-	 * calculates the inactive/active pages available in eligible zones.
-	 */
-	for (zid = sc->reclaim_idx + 1; zid < MAX_NR_ZONES; zid++) {
-		struct zone *zone = &pgdat->node_zones[zid];
-		unsigned long inactive_zone, active_zone;
-
-		if (!managed_zone(zone))
-			continue;
-
-		inactive_zone = lruvec_zone_lru_size(lruvec, file * LRU_FILE, zid);
-		active_zone = lruvec_zone_lru_size(lruvec, (file * LRU_FILE) + LRU_ACTIVE, zid);
-
-		inactive -= min(inactive, inactive_zone);
-		active -= min(active, active_zone);
-	}
+	inactive = lruvec_lru_size(lruvec, inactive_lru, sc->reclaim_idx);
+	active = lruvec_lru_size(lruvec, active_lru, sc->reclaim_idx);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -2091,10 +2088,12 @@ static bool inactive_list_is_low(struct
 		inactive_ratio = 1;
 
 	if (trace)
-		trace_mm_vmscan_inactive_list_is_low(pgdat->node_id,
+		trace_mm_vmscan_inactive_list_is_low(lruvec_pgdat(lruvec)->node_id,
 				sc->reclaim_idx,
-				total_inactive, inactive,
-				total_active, active, inactive_ratio, file);
+				lruvec_lru_size(lruvec, inactive_lru, MAX_NR_ZONES), inactive,
+				lruvec_lru_size(lruvec, active_lru, MAX_NR_ZONES), active,
+				inactive_ratio, file);
+
 	return inactive * inactive_ratio < active;
 }
 
@@ -2234,7 +2233,7 @@ static void get_scan_count(struct lruvec
 	 * system is under heavy pressure.
 	 */
 	if (!inactive_list_is_low(lruvec, true, sc, false) &&
-	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE) >> sc->priority) {
+	    lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES) >> sc->priority) {
 		scan_balance = SCAN_FILE;
 		goto out;
 	}
@@ -2260,10 +2259,10 @@ static void get_scan_count(struct lruvec
 	 * anon in [0], file in [1]
 	 */
 
-	anon  = lruvec_lru_size(lruvec, LRU_ACTIVE_ANON) +
-		lruvec_lru_size(lruvec, LRU_INACTIVE_ANON);
-	file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE) +
-		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE);
+	anon  = lruvec_lru_size(lruvec, LRU_ACTIVE_ANON, MAX_NR_ZONES) +
+		lruvec_lru_size(lruvec, LRU_INACTIVE_ANON, MAX_NR_ZONES);
+	file  = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES) +
+		lruvec_lru_size(lruvec, LRU_INACTIVE_FILE, MAX_NR_ZONES);
 
 	spin_lock_irq(&pgdat->lru_lock);
 	if (unlikely(reclaim_stat->recent_scanned[0] > anon / 4)) {
@@ -2301,7 +2300,7 @@ out:
 			unsigned long size;
 			unsigned long scan;
 
-			size = lruvec_lru_size(lruvec, lru);
+			size = lruvec_lru_size(lruvec, lru, MAX_NR_ZONES);
 			scan = size >> sc->priority;
 
 			if (!scan && pass && force_scan)
diff -puN mm/workingset.c~mm-vmscan-cleanup-lru-size-claculations mm/workingset.c
--- a/mm/workingset.c~mm-vmscan-cleanup-lru-size-claculations
+++ a/mm/workingset.c
@@ -267,7 +267,7 @@ bool workingset_refault(void *shadow)
 	}
 	lruvec = mem_cgroup_lruvec(pgdat, memcg);
 	refault = atomic_long_read(&lruvec->inactive_age);
-	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE);
+	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES);
 	rcu_read_unlock();
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-throttle-show_mem-from-warn_alloc.patch
mm-trace-extract-compaction_status-and-zone_type-to-a-common-header.patch
oom-trace-add-oom-detection-tracepoints.patch
oom-trace-add-compaction-retry-tracepoint.patch
mm-vmscan-remove-unused-mm_vmscan_memcg_isolate.patch
mm-vmscan-add-active-list-aging-tracepoint.patch
mm-vmscan-add-active-list-aging-tracepoint-update.patch
mm-vmscan-show-the-number-of-skipped-pages-in-mm_vmscan_lru_isolate.patch
mm-vmscan-show-lru-name-in-mm_vmscan_lru_isolate-tracepoint.patch
mm-vmscan-extract-shrink_page_list-reclaim-counters-into-a-struct.patch
mm-vmscan-enhance-mm_vmscan_lru_shrink_inactive-tracepoint.patch
mm-vmscan-add-mm_vmscan_inactive_list_is_low-tracepoint.patch
trace-vmscan-postprocess-sync-with-tracepoints-updates.patch
mm-vmscan-do-not-count-freed-pages-as-pgdeactivate.patch
mm-vmscan-cleanup-lru-size-claculations.patch
mm-vmscan-consider-eligible-zones-in-get_scan_count.patch
revert-mm-bail-out-in-shrink_inactive_list.patch

