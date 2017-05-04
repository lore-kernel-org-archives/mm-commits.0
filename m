From: akpm@linux-foundation.org
Subject: [merged]
 mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch removed
 from -mm tree
Date: Thu, 04 May 2017 12:09:16 -0700
Message-ID: <20170504190916.zLvzktO8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756367AbdEDTJS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:09:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hejianet@gmail.com, hillf.zj@alibaba-inc.com, mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't avoid high-priority reclaim on memcg limit reclaim
has been removed from the -mm tree.  Its filename was
     mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: don't avoid high-priority reclaim on memcg limit reclaim

246e87a93934 ("memcg: fix get_scan_count() for small targets") sought to
avoid high reclaim priorities for memcg by forcing it to scan a minimum
amount of pages when lru_pages >> priority yielded nothing.  This was done
at a time when reclaim decisions like dirty throttling were tied to the
priority level.

Nowadays, the only meaningful thing still tied to priority dropping below
DEF_PRIORITY - 2 is gating whether laptop_mode=1 is generally allowed to
write.  But that is from an era where direct reclaim was still allowed to
call ->writepage, and kswapd nowadays avoids writes until it's scanned
every clean page in the system.  Potential changes to how quick
sc->may_writepage could trigger are of little concern.

Remove the force_scan stuff, as well as the ugly multi-pass target
calculation that it necessitated.

Link: http://lkml.kernel.org/r/20170228214007.5621-7-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Jia He <hejianet@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   98 +++++++++++++++++++-------------------------------
 1 file changed, 39 insertions(+), 59 deletions(-)

diff -puN mm/vmscan.c~mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim mm/vmscan.c
--- a/mm/vmscan.c~mm-dont-avoid-high-priority-reclaim-on-memcg-limit-reclaim
+++ a/mm/vmscan.c
@@ -2123,21 +2123,8 @@ static void get_scan_count(struct lruvec
 	unsigned long anon_prio, file_prio;
 	enum scan_balance scan_balance;
 	unsigned long anon, file;
-	bool force_scan = false;
 	unsigned long ap, fp;
 	enum lru_list lru;
-	bool some_scanned;
-	int pass;
-
-	/*
-	 * If the zone or memcg is small, nr[l] can be 0. When
-	 * reclaiming for a memcg, a priority drop can cause high
-	 * latencies, so it's better to scan a minimum amount. When a
-	 * cgroup has already been deleted, scrape out the remaining
-	 * cache forcefully to get rid of the lingering state.
-	 */
-	if (!global_reclaim(sc) || !mem_cgroup_online(memcg))
-		force_scan = true;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || mem_cgroup_get_nr_swap_pages(memcg) <= 0) {
@@ -2268,55 +2255,48 @@ static void get_scan_count(struct lruvec
 	fraction[1] = fp;
 	denominator = ap + fp + 1;
 out:
-	some_scanned = false;
-	/* Only use force_scan on second pass. */
-	for (pass = 0; !some_scanned && pass < 2; pass++) {
-		*lru_pages = 0;
-		for_each_evictable_lru(lru) {
-			int file = is_file_lru(lru);
-			unsigned long size;
-			unsigned long scan;
-
-			size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
-			scan = size >> sc->priority;
-
-			if (!scan && pass && force_scan)
-				scan = min(size, SWAP_CLUSTER_MAX);
-
-			switch (scan_balance) {
-			case SCAN_EQUAL:
-				/* Scan lists relative to size */
-				break;
-			case SCAN_FRACT:
-				/*
-				 * Scan types proportional to swappiness and
-				 * their relative recent reclaim efficiency.
-				 */
-				scan = div64_u64(scan * fraction[file],
-							denominator);
-				break;
-			case SCAN_FILE:
-			case SCAN_ANON:
-				/* Scan one type exclusively */
-				if ((scan_balance == SCAN_FILE) != file) {
-					size = 0;
-					scan = 0;
-				}
-				break;
-			default:
-				/* Look ma, no brain */
-				BUG();
-			}
-
-			*lru_pages += size;
-			nr[lru] = scan;
-
+	*lru_pages = 0;
+	for_each_evictable_lru(lru) {
+		int file = is_file_lru(lru);
+		unsigned long size;
+		unsigned long scan;
+
+		size = lruvec_lru_size(lruvec, lru, sc->reclaim_idx);
+		scan = size >> sc->priority;
+		/*
+		 * If the cgroup's already been deleted, make sure to
+		 * scrape out the remaining cache.
+		 */
+		if (!scan && !mem_cgroup_online(memcg))
+			scan = min(size, SWAP_CLUSTER_MAX);
+
+		switch (scan_balance) {
+		case SCAN_EQUAL:
+			/* Scan lists relative to size */
+			break;
+		case SCAN_FRACT:
 			/*
-			 * Skip the second pass and don't force_scan,
-			 * if we found something to scan.
+			 * Scan types proportional to swappiness and
+			 * their relative recent reclaim efficiency.
 			 */
-			some_scanned |= !!scan;
+			scan = div64_u64(scan * fraction[file],
+					 denominator);
+			break;
+		case SCAN_FILE:
+		case SCAN_ANON:
+			/* Scan one type exclusively */
+			if ((scan_balance == SCAN_FILE) != file) {
+				size = 0;
+				scan = 0;
+			}
+			break;
+		default:
+			/* Look ma, no brain */
+			BUG();
 		}
+
+		*lru_pages += size;
+		nr[lru] = scan;
 	}
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are


