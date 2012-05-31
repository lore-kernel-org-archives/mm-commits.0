From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-push-lruvec-pointer-into-shrink_list.patch removed from -mm tree
Date: Thu, 31 May 2012 12:17:34 -0700
Message-ID: <20120531191734.60D13A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:47005 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980Ab2EaTRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:17:36 -0400
Received: by mail-bk0-f74.google.com with SMTP id y5so75419bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:17:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khlebnikov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: push lruvec pointer into shrink_list()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-push-lruvec-pointer-into-shrink_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm/vmscan: push lruvec pointer into shrink_list()

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   34 ++++++++++++----------------------
 1 file changed, 12 insertions(+), 22 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-shrink_list mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-push-lruvec-pointer-into-shrink_list
+++ a/mm/vmscan.c
@@ -1205,7 +1205,7 @@ putback_inactive_pages(struct lruvec *lr
  * of reclaimed pages
  */
 static noinline_for_stack unsigned long
-shrink_inactive_list(unsigned long nr_to_scan, struct mem_cgroup_zone *mz,
+shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 		     struct scan_control *sc, enum lru_list lru)
 {
 	LIST_HEAD(page_list);
@@ -1216,9 +1216,8 @@ shrink_inactive_list(unsigned long nr_to
 	unsigned long nr_writeback = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
-	struct zone *zone = mz->zone;
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
-	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, mz->mem_cgroup);
+	struct zone *zone = lruvec_zone(lruvec);
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1373,7 +1372,7 @@ static void move_active_pages_to_lru(str
 }
 
 static void shrink_active_list(unsigned long nr_to_scan,
-			       struct mem_cgroup_zone *mz,
+			       struct lruvec *lruvec,
 			       struct scan_control *sc,
 			       enum lru_list lru)
 {
@@ -1384,12 +1383,11 @@ static void shrink_active_list(unsigned 
 	LIST_HEAD(l_active);
 	LIST_HEAD(l_inactive);
 	struct page *page;
-	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(mz);
+	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 	unsigned long nr_rotated = 0;
 	isolate_mode_t isolate_mode = 0;
 	int file = is_file_lru(lru);
-	struct zone *zone = mz->zone;
-	struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, mz->mem_cgroup);
+	struct zone *zone = lruvec_zone(lruvec);
 
 	lru_add_drain();
 
@@ -1555,21 +1553,17 @@ static int inactive_list_is_low(struct l
 }
 
 static unsigned long shrink_list(enum lru_list lru, unsigned long nr_to_scan,
-				 struct mem_cgroup_zone *mz,
-				 struct scan_control *sc)
+				 struct lruvec *lruvec, struct scan_control *sc)
 {
 	int file = is_file_lru(lru);
 
 	if (is_active_lru(lru)) {
-		struct lruvec *lruvec = mem_cgroup_zone_lruvec(mz->zone,
-							       mz->mem_cgroup);
-
 		if (inactive_list_is_low(lruvec, file))
-			shrink_active_list(nr_to_scan, mz, sc, lru);
+			shrink_active_list(nr_to_scan, lruvec, sc, lru);
 		return 0;
 	}
 
-	return shrink_inactive_list(nr_to_scan, mz, sc, lru);
+	return shrink_inactive_list(nr_to_scan, lruvec, sc, lru);
 }
 
 static int vmscan_swappiness(struct scan_control *sc)
@@ -1812,7 +1806,7 @@ restart:
 				nr[lru] -= nr_to_scan;
 
 				nr_reclaimed += shrink_list(lru, nr_to_scan,
-							    mz, sc);
+							    lruvec, sc);
 			}
 		}
 		/*
@@ -1835,7 +1829,7 @@ restart:
 	 * rebalance the anon lru active/inactive ratio.
 	 */
 	if (inactive_anon_is_low(lruvec))
-		shrink_active_list(SWAP_CLUSTER_MAX, mz,
+		shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 				   sc, LRU_ACTIVE_ANON);
 
 	/* reclaim/compaction might need reclaim to continue */
@@ -2268,13 +2262,9 @@ static void age_active_anon(struct zone 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		struct lruvec *lruvec = mem_cgroup_zone_lruvec(zone, memcg);
-		struct mem_cgroup_zone mz = {
-			.mem_cgroup = memcg,
-			.zone = zone,
-		};
 
 		if (inactive_anon_is_low(lruvec))
-			shrink_active_list(SWAP_CLUSTER_MAX, &mz,
+			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
 					   sc, LRU_ACTIVE_ANON);
 
 		memcg = mem_cgroup_iter(NULL, memcg, NULL);
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

