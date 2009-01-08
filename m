From: akpm@linux-foundation.org
Subject: - memcg-remove-mem_cgroup_cal_reclaim.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:18 -0800
Message-ID: <200901082249.n08MnI16028597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34691 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763266AbZAHW7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:59:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, hugh@veritas.com, kamezawa.hiroyu@redhat.com, nishimura@mxp.nes.nec.co.jp, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove mem_cgroup_cal_reclaim()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_cal_reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove mem_cgroup_cal_reclaim()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, get_scan_ratio() return correct value although memcg reclaim.  Then,
mem_cgroup_calc_reclaim() can be removed.

So, memcg reclaim get the same capability of anon/file reclaim balancing
as global reclaim now.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ----------
 mm/memcontrol.c            |   21 ---------------------
 mm/vmscan.c                |   27 ++++++++++-----------------
 3 files changed, 10 insertions(+), 48 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_cal_reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_cal_reclaim
+++ a/include/linux/memcontrol.h
@@ -97,9 +97,6 @@ extern void mem_cgroup_note_reclaim_prio
 							int priority);
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
-
-extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
-					int priority, enum lru_list lru);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
@@ -244,13 +241,6 @@ static inline void mem_cgroup_record_rec
 {
 }
 
-static inline long mem_cgroup_calc_reclaim(struct mem_cgroup *mem,
-					struct zone *zone, int priority,
-					enum lru_list lru)
-{
-	return 0;
-}
-
 static inline bool mem_cgroup_disabled(void)
 {
 	return true;
diff -puN mm/memcontrol.c~memcg-remove-mem_cgroup_cal_reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_cal_reclaim
+++ a/mm/memcontrol.c
@@ -414,27 +414,6 @@ void mem_cgroup_record_reclaim_priority(
 	mem->prev_priority = priority;
 }
 
-/*
- * Calculate # of pages to be scanned in this priority/zone.
- * See also vmscan.c
- *
- * priority starts from "DEF_PRIORITY" and decremented in each loop.
- * (see include/linux/mmzone.h)
- */
-
-long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
-					int priority, enum lru_list lru)
-{
-	long nr_pages;
-	int nid = zone->zone_pgdat->node_id;
-	int zid = zone_idx(zone);
-	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(mem, nid, zid);
-
-	nr_pages = MEM_CGROUP_ZSTAT(mz, lru);
-
-	return (nr_pages >> priority);
-}
-
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
 {
 	unsigned long active;
diff -puN mm/vmscan.c~memcg-remove-mem_cgroup_cal_reclaim mm/vmscan.c
--- a/mm/vmscan.c~memcg-remove-mem_cgroup_cal_reclaim
+++ a/mm/vmscan.c
@@ -1466,30 +1466,23 @@ static void shrink_zone(int priority, st
 	get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
-		if (scan_global_lru(sc)) {
-			int file = is_file_lru(l);
-			int scan;
+		int file = is_file_lru(l);
+		int scan;
 
-			scan = zone_page_state(zone, NR_LRU_BASE + l);
-			if (priority) {
-				scan >>= priority;
-				scan = (scan * percent[file]) / 100;
-			}
+		scan = zone_page_state(zone, NR_LRU_BASE + l);
+		if (priority) {
+			scan >>= priority;
+			scan = (scan * percent[file]) / 100;
+		}
+		if (scan_global_lru(sc)) {
 			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= swap_cluster_max)
 				zone->lru[l].nr_scan = 0;
 			else
 				nr[l] = 0;
-		} else {
-			/*
-			 * This reclaim occurs not because zone memory shortage
-			 * but because memory controller hits its limit.
-			 * Don't modify zone reclaim related data.
-			 */
-			nr[l] = mem_cgroup_calc_reclaim(sc->mem_cgroup, zone,
-								priority, l);
-		}
+		} else
+			nr[l] = scan;
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
ia64-implement-interrupt-enabling-rwlocks.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

