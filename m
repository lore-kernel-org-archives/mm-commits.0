From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-get_scan_count-for-small-targets.patch removed from -mm tree
Date: Fri, 27 May 2011 12:58:12 -0700
Message-ID: <201105271956.p4RJuH6s017538@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab1E0UP1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 May 2011 16:15:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, nishimura@mxp.nes.nec.co.jp, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix get_scan_count() for small targets
has been removed from the -mm tree.  Its filename was
     memcg-fix-get_scan_count-for-small-targets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix get_scan_count() for small targets
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

During memory reclaim we determine the number of pages to be scanned per
zone as

	(anon + file) >> priority.
Assume
	scan = (anon + file) >> priority.

If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time and
priority gets higher.  This has some problems.

  1. This increases priority as 1 without any scan.
     To do scan in this priority, amount of pages should be larger than 512M.
     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
     batched, later. (But we lose 1 priority.)
     If memory size is below 16M, pages >> priority is 0 and no scan in
     DEF_PRIORITY forever.

  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
     So, x86's ZONE_DMA will never be recoverred until the user of pages
     frees memory by itself.

  3. With memcg, the limit of memory can be small. When using small memcg,
     it gets priority < DEF_PRIORITY-2 very easily and need to call
     wait_iff_congested().
     For doing scan before priorty=9, 64MB of memory should be used.

Then, this patch tries to scan SWAP_CLUSTER_MAX of pages in force...when

  1. the target is enough small.
  2. it's kswapd or memcg reclaim.

Then we can avoid rapid priority drop and may be able to recover
all_unreclaimable in a small zones.  And this patch removes nr_saved_scan.
 This will allow scanning in this priority even when pages >> priority is
very small.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Ying Han <yinghan@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 ---
 mm/page_alloc.c        |    4 --
 mm/vmscan.c            |   60 +++++++++++++++++++++------------------
 3 files changed, 34 insertions(+), 35 deletions(-)

diff -puN include/linux/mmzone.h~memcg-fix-get_scan_count-for-small-targets include/linux/mmzone.h
--- a/include/linux/mmzone.h~memcg-fix-get_scan_count-for-small-targets
+++ a/include/linux/mmzone.h
@@ -273,11 +273,6 @@ struct zone_reclaim_stat {
 	 */
 	unsigned long		recent_rotated[2];
 	unsigned long		recent_scanned[2];
-
-	/*
-	 * accumulated for batching
-	 */
-	unsigned long		nr_saved_scan[NR_LRU_LISTS];
 };
 
 struct zone {
diff -puN mm/page_alloc.c~memcg-fix-get_scan_count-for-small-targets mm/page_alloc.c
--- a/mm/page_alloc.c~memcg-fix-get_scan_count-for-small-targets
+++ a/mm/page_alloc.c
@@ -4323,10 +4323,8 @@ static void __paginginit free_area_init_
 		zone->zone_pgdat = pgdat;
 
 		zone_pcp_init(zone);
-		for_each_lru(l) {
+		for_each_lru(l)
 			INIT_LIST_HEAD(&zone->lru[l].list);
-			zone->reclaim_stat.nr_saved_scan[l] = 0;
-		}
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
 		zone->reclaim_stat.recent_scanned[0] = 0;
diff -puN mm/vmscan.c~memcg-fix-get_scan_count-for-small-targets mm/vmscan.c
--- a/mm/vmscan.c~memcg-fix-get_scan_count-for-small-targets
+++ a/mm/vmscan.c
@@ -1718,26 +1718,6 @@ static unsigned long shrink_list(enum lr
 }
 
 /*
- * Smallish @nr_to_scan's are deposited in @nr_saved_scan,
- * until we collected @swap_cluster_max pages to scan.
- */
-static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
-				       unsigned long *nr_saved_scan)
-{
-	unsigned long nr;
-
-	*nr_saved_scan += nr_to_scan;
-	nr = *nr_saved_scan;
-
-	if (nr >= SWAP_CLUSTER_MAX)
-		*nr_saved_scan = 0;
-	else
-		nr = 0;
-
-	return nr;
-}
-
-/*
  * Determine how aggressively the anon and file LRU lists should be
  * scanned.  The relative value of each set of LRU lists is determined
  * by looking at the fraction of the pages scanned we did rotate back
@@ -1755,6 +1735,22 @@ static void get_scan_count(struct zone *
 	u64 fraction[2], denominator;
 	enum lru_list l;
 	int noswap = 0;
+	int force_scan = 0;
+
+
+	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
+	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
+		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
+
+	if (((anon + file) >> priority) < SWAP_CLUSTER_MAX) {
+		/* kswapd does zone balancing and need to scan this zone */
+		if (scanning_global_lru(sc) && current_is_kswapd())
+			force_scan = 1;
+		/* memcg may have small limit and need to avoid priority drop */
+		if (!scanning_global_lru(sc))
+			force_scan = 1;
+	}
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1765,11 +1761,6 @@ static void get_scan_count(struct zone *
 		goto out;
 	}
 
-	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
-	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
-		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_FILE);
-
 	if (scanning_global_lru(sc)) {
 		free  = zone_page_state(zone, NR_FREE_PAGES);
 		/* If we have very few page cache pages,
@@ -1836,8 +1827,23 @@ out:
 			scan >>= priority;
 			scan = div64_u64(scan * fraction[file], denominator);
 		}
-		nr[l] = nr_scan_try_batch(scan,
-					  &reclaim_stat->nr_saved_scan[l]);
+
+		/*
+		 * If zone is small or memcg is small, nr[l] can be 0.
+		 * This results no-scan on this priority and priority drop down.
+		 * For global direct reclaim, it can visit next zone and tend
+		 * not to have problems. For global kswapd, it's for zone
+		 * balancing and it need to scan a small amounts. When using
+		 * memcg, priority drop can cause big latency. So, it's better
+		 * to scan small amount. See may_noscan above.
+		 */
+		if (!scan && force_scan) {
+			if (file)
+				scan = SWAP_CLUSTER_MAX;
+			else if (!noswap)
+				scan = SWAP_CLUSTER_MAX;
+		}
+		nr[l] = scan;
 	}
 }
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
mm-increase-reclaim_distance-to-30.patch
vmscanmemcg-memcg-aware-swap-token.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch

