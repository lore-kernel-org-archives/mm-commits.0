From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:24:35 -0700
Message-ID: <51db11f3.8mF+NrMX/3Nu8iU8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTYg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:24:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zcalusic@bitsync.net, riel@redhat.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, jslaby@suse.cz, hannes@cmpxchg.org, dormando@rydia.net, Valdis.Kletnieks@vt.edu, mgorman@suse.de

Subject: [merged] mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch removed from -mm tree
To: mgorman@suse.de,Valdis.Kletnieks@vt.edu,dormando@rydia.net,hannes@cmpxchg.org,jslaby@suse.cz,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,riel@redhat.com,zcalusic@bitsync.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:24:35 -0700


The patch titled
     Subject: mm: vmscan: obey proportional scanning requirements for kswapd
has been removed from the -mm tree.  Its filename was
     mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: obey proportional scanning requirements for kswapd

Simplistically, the anon and file LRU lists are scanned proportionally
depending on the value of vm.swappiness although there are other factors
taken into account by get_scan_count().  The patch "mm: vmscan: Limit the
number of pages kswapd reclaims" limits the number of pages kswapd
reclaims but it breaks this proportional scanning and may evenly shrink
anon/file LRUs regardless of vm.swappiness.

This patch preserves the proportional scanning and reclaim.  It does mean
that kswapd will reclaim more than requested but the number of pages will
be related to the high watermark.

[mhocko@suse.cz: Correct proportional reclaim for memcg and simplify]
[kamezawa.hiroyu@jp.fujitsu.com: Recalculate scan based on target]
[hannes@cmpxchg.org: Account for already scanned pages properly]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Cc: dormando <dormando@rydia.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   67 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 8 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-obey-proportional-scanning-requirements-for-kswapd mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-obey-proportional-scanning-requirements-for-kswapd
+++ a/mm/vmscan.c
@@ -1822,17 +1822,25 @@ out:
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
+	unsigned long targets[NR_LRU_LISTS];
 	unsigned long nr_to_scan;
 	enum lru_list lru;
 	unsigned long nr_reclaimed = 0;
 	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct blk_plug plug;
+	bool scan_adjusted = false;
 
 	get_scan_count(lruvec, sc, nr);
 
+	/* Record the original scan target for proportional adjustments later */
+	memcpy(targets, nr, sizeof(nr));
+
 	blk_start_plug(&plug);
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
+		unsigned long nr_anon, nr_file, percentage;
+		unsigned long nr_scanned;
+
 		for_each_evictable_lru(lru) {
 			if (nr[lru]) {
 				nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
@@ -1842,17 +1850,60 @@ static void shrink_lruvec(struct lruvec
 							    lruvec, sc);
 			}
 		}
+
+		if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
+			continue;
+
 		/*
-		 * On large memory systems, scan >> priority can become
-		 * really large. This is fine for the starting priority;
-		 * we want to put equal scanning pressure on each zone.
-		 * However, if the VM has a harder time of freeing pages,
-		 * with multiple processes reclaiming pages, the total
-		 * freeing target can get unreasonably large.
+		 * For global direct reclaim, reclaim only the number of pages
+		 * requested. Less care is taken to scan proportionally as it
+		 * is more important to minimise direct reclaim stall latency
+		 * than it is to properly age the LRU lists.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim &&
-		    sc->priority < DEF_PRIORITY)
+		if (global_reclaim(sc) && !current_is_kswapd())
 			break;
+
+		/*
+		 * For kswapd and memcg, reclaim at least the number of pages
+		 * requested. Ensure that the anon and file LRUs shrink
+		 * proportionally what was requested by get_scan_count(). We
+		 * stop reclaiming one LRU and reduce the amount scanning
+		 * proportional to the original scan target.
+		 */
+		nr_file = nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE];
+		nr_anon = nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON];
+
+		if (nr_file > nr_anon) {
+			unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
+						targets[LRU_ACTIVE_ANON] + 1;
+			lru = LRU_BASE;
+			percentage = nr_anon * 100 / scan_target;
+		} else {
+			unsigned long scan_target = targets[LRU_INACTIVE_FILE] +
+						targets[LRU_ACTIVE_FILE] + 1;
+			lru = LRU_FILE;
+			percentage = nr_file * 100 / scan_target;
+		}
+
+		/* Stop scanning the smaller of the LRU */
+		nr[lru] = 0;
+		nr[lru + LRU_ACTIVE] = 0;
+
+		/*
+		 * Recalculate the other LRU scan count based on its original
+		 * scan target and the percentage scanning already complete
+		 */
+		lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
+		nr_scanned = targets[lru] - nr[lru];
+		nr[lru] = targets[lru] * (100 - percentage) / 100;
+		nr[lru] -= min(nr[lru], nr_scanned);
+
+		lru += LRU_ACTIVE;
+		nr_scanned = targets[lru] - nr[lru];
+		nr[lru] = targets[lru] * (100 - percentage) / 100;
+		nr[lru] -= min(nr[lru], nr_scanned);
+
+		scan_adjusted = true;
 	}
 	blk_finish_plug(&plug);
 	sc->nr_reclaimed += nr_reclaimed;
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

