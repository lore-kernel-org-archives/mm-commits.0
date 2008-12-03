From: akpm@linux-foundation.org
Subject: - memcg-remove-mem_cgroup_calc_reclaim.patch removed from -mm tree
Date: Tue, 02 Dec 2008 21:38:11 -0800
Message-ID: <200812030538.mB35cBbP018470@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752055AbYLCFih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 00:38:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove mem_cgroup_calc_reclaim()
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_calc_reclaim.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove mem_cgroup_calc_reclaim()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Now, get_scan_ratio() return correct value although memcg reclaim.  Then,
mem_cgroup_calc_reclaim() can be removed.

So, memcg reclaim get the same capability of anon/file reclaim balancing
as global reclaim now.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 ----------
 mm/memcontrol.c            |   21 ---------------------
 mm/vmscan.c                |   27 ++++++++++-----------------
 3 files changed, 10 insertions(+), 48 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_calc_reclaim include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_calc_reclaim
+++ a/include/linux/memcontrol.h
@@ -87,9 +87,6 @@ extern void mem_cgroup_note_reclaim_prio
 							int priority);
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
-
-extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
-					int priority, enum lru_list lru);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
@@ -234,13 +231,6 @@ static inline void mem_cgroup_record_rec
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
diff -puN mm/memcontrol.c~memcg-remove-mem_cgroup_calc_reclaim mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_calc_reclaim
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
diff -puN mm/vmscan.c~memcg-remove-mem_cgroup_calc_reclaim mm/vmscan.c
--- a/mm/vmscan.c~memcg-remove-mem_cgroup_calc_reclaim
+++ a/mm/vmscan.c
@@ -1512,30 +1512,23 @@ static void shrink_zone(int priority, st
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
 			if (nr[l] >= sc->swap_cluster_max)
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
memcg-remove-mem_cgroup_calc_reclaim.patch
memcg-show-inactive_ratio.patch
memcg-show-reclaim_stat.patch

