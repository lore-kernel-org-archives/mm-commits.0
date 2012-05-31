From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:32 -0700
Message-ID: <20120531191732.6408EA0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:42805 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:33 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so134652ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:32 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: push lruvec pointer into inactive_list_is_low()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: push lruvec pointer into inactive_list_is_low()

Switch mem_cgroup_inactive_anon_is_low() to lruvec pointers,
mem_cgroup_get_lruvec_size() is more effective than
mem_cgroup_zone_nr_lru_pages()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   10 +++-----
 mm/memcontrol.c            |   20 +++++------------
 mm/vmscan.c                |   40 +++++++++++++++++++----------------
 3 files changed, 32 insertions(+), 38 deletions(-)

diff -puN include/linux/memcontrol.h~mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low
+++ a/include/linux/memcontrol.h
@@ -118,10 +118,8 @@ void mem_cgroup_iter_break(struct mem_cg
 /*
  * For memory reclaim.
  */
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
-				    struct zone *zone);
-int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg,
-				    struct zone *zone);
+int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec);
+int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec);
 int mem_cgroup_select_victim_node(struct mem_cgroup *memcg);
 unsigned long mem_cgroup_get_lruvec_size(struct lruvec *lruvec, enum lru_list);
 struct zone_reclaim_stat*
@@ -330,13 +328,13 @@ static inline bool mem_cgroup_disabled(v
 }
 
 static inline int
-mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
+mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
 	return 1;
 }
 
 static inline int
-mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg, struct zone *zone)
+mem_cgroup_inactive_file_is_low(struct lruvec *lruvec)
 {
 	return 1;
 }
diff -puN mm/memcontrol.c~mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low mm/memcontrol.c
--- a/mm/memcontrol.c~mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low
+++ a/mm/memcontrol.c
@@ -1208,19 +1208,15 @@ int task_in_mem_cgroup(struct task_struc
 	return ret;
 }
 
-int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
+int mem_cgroup_inactive_anon_is_low(struct lruvec *lruvec)
 {
 	unsigned long inactive_ratio;
-	int nid = zone_to_nid(zone);
-	int zid = zone_idx(zone);
 	unsigned long inactive;
 	unsigned long active;
 	unsigned long gb;
 
-	inactive = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
-						BIT(LRU_INACTIVE_ANON));
-	active = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
-					      BIT(LRU_ACTIVE_ANON));
+	inactive = mem_cgroup_get_lruvec_size(lruvec, LRU_INACTIVE_ANON);
+	active = mem_cgroup_get_lruvec_size(lruvec, LRU_ACTIVE_ANON);
 
 	gb = (inactive + active) >> (30 - PAGE_SHIFT);
 	if (gb)
@@ -1231,17 +1227,13 @@ int mem_cgroup_inactive_anon_is_low(stru
 	return inactive * inactive_ratio < active;
 }
 
-int mem_cgroup_inactive_file_is_low(struct mem_cgroup *memcg, struct zone *zone)
+int mem_cgroup_inactive_file_is_low(struct lruvec *lruvec)
 {
 	unsigned long active;
 	unsigned long inactive;
-	int zid = zone_idx(zone);
-	int nid = zone_to_nid(zone);
 
-	inactive = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
-						BIT(LRU_INACTIVE_FILE));
-	active = mem_cgroup_zone_nr_lru_pages(memcg, nid, zid,
-					      BIT(LRU_ACTIVE_FILE));
+	inactive = mem_cgroup_get_lruvec_size(lruvec, LRU_INACTIVE_FILE);
+	active = mem_cgroup_get_lruvec_size(lruvec, LRU_ACTIVE_FILE);
 
 	return (active > inactive);
 }
diff -puN mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-inactive_list_is_low
+++ a/mm/vmscan.c
@@ -1488,13 +1488,12 @@ static int inactive_anon_is_low_global(s
 
 /**
  * inactive_anon_is_low - check if anonymous pages need to be deactivated
- * @zone: zone to check
- * @sc:   scan control of this context
+ * @lruvec: LRU vector to check
  *
  * Returns true if the zone does not have enough inactive anon pages,
  * meaning some active anon pages need to be deactivated.
  */
-static int inactive_anon_is_low(struct mem_cgroup_zone *mz)
+static int inactive_anon_is_low(struct lruvec *lruvec)
 {
 	/*
 	 * If we don't have swap space, anonymous page deactivation
@@ -1504,13 +1503,12 @@ static int inactive_anon_is_low(struct m
 		return 0;
 
 	if (!mem_cgroup_disabled())
-		return mem_cgroup_inactive_anon_is_low(mz->mem_cgroup,
-						       mz->zone);
+		return mem_cgroup_inactive_anon_is_low(lruvec);
 
-	return inactive_anon_is_low_global(mz->zone);
+	return inactive_anon_is_low_global(lruvec_zone(lruvec));
 }
 #else
-static inline int inactive_anon_is_low(struct mem_cgroup_zone *mz)
+static inline int inactive_anon_is_low(struct lruvec *lruvec)
 {
 	return 0;
 }
@@ -1528,7 +1526,7 @@ static int inactive_file_is_low_global(s
 
 /**
  * inactive_file_is_low - check if file pages need to be deactivated
- * @mz: memory cgroup and zone to check
+ * @lruvec: LRU vector to check
  *
  * When the system is doing streaming IO, memory pressure here
  * ensures that active file pages get deactivated, until more
@@ -1540,21 +1538,20 @@ static int inactive_file_is_low_global(s
  * This uses a different ratio than the anonymous pages, because
  * the page cache uses a use-once replacement algorithm.
  */
-static int inactive_file_is_low(struct mem_cgroup_zone *mz)
+static int inactive_file_is_low(struct lruvec *lruvec)
 {
 	if (!mem_cgroup_disabled())
-		return mem_cgroup_inactive_file_is_low(mz->mem_cgroup,
-						       mz->zone);
+		return mem_cgroup_inactive_file_is_low(lruvec);
 
-	return inactive_file_is_low_global(mz->zone);
+	return inactive_file_is_low_global(lruvec_zone(lruvec));
 }
 
-static int inactive_list_is_low(struct mem_cgroup_zone *mz, int file)
+static int inactive_list_is_low(struct lruvec *lruvec, int file)
 {
 	if (file)
-		return inactive_file_is_low(mz);
+		return inactive_file_is_low(lruvec);
 	else
-		return inactive_anon_is_low(mz);
+		return inactive_anon_is_low(lruvec);
 }
 
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
@@ -1564,7 +1561,10 @@ static unsigned long shrink_list(enum lr
 	int file = is_file_lru(lru);
 
 	if (is_active_lru(lru)) {
-		if (inactive_list_is_low(mz, file))
+		struct lruvec *lruvec = mem_cgroup_zone_lruvec(mz->zone,
+							       mz->mem_cgroup);
+
+		if (inactive_list_is_low(lruvec, file))
 			shrink_active_list(nr_to_scan, mz, sc, lru);
 		return 0;
 	}
@@ -1793,6 +1793,9 @@ static void shrink_mem_cgroup_zone(struc
 	unsigned long nr_reclaimed, nr_scanned;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
+	struct lruvec *lruvec;
+
+	lruvec = mem_cgroup_zone_lruvec(mz->zone, mz->mem_cgroup);
 
 restart:
 	nr_reclaimed = 0;
@@ -1831,7 +1834,7 @@ restart:
 	 * Even if we did not try to evict anon pages at all, we want to
 	 * rebalance the anon lru active/inactive ratio.
 	 */
-	if (inactive_anon_is_low(mz))
+	if (inactive_anon_is_low(lruvec))
 		shrink_active_list(SWAP_CLUSTER_MAX, mz,
 				   sc, LRU_ACTIVE_ANON);
 
@@ -2264,12 +2267,13 @@ static void age_active_anon(struct zone 
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
+		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
 		struct mem_cgroup_zone mz = {
 			.mem_cgroup = memcg,
 			.zone = zone,
 		};
 
-		if (inactive_anon_is_low(&mz))
+		if (inactive_anon_is_low(lruvec))
 			shrink_active_list(SWAP_CLUSTER_MAX, &mz,
 					   sc, LRU_ACTIVE_ANON);
 
_

Patches currently in -mm which might be from khlebnikov@openvz.org are

origin.patch
linux-next.patch
mm-correctly-synchronize-rss-counters-at-exit-exec.patch
proc-report-file-anon-bit-in-proc-pid-pagemap.patch
proc-smaps-carefully-handle-migration-entries.patch
proc-smaps-show-amount-of-nonlinear-ptes-in-vma.patch
proc-smaps-show-amount-of-hwpoison-pages.patch
fork-call-complete_vfork_done-after-clearing-child_tid-and-flushing-rss-counters.patch
c-r-prctl-add-ability-to-set-new-mm_struct-exe_file-update-after-mm-num_exe_file_vmas-removal.patch

