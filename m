From: akpm@linux-foundation.org
Subject: [merged] mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:35:32 -0800
Message-ID: <20120113203532.DA2651E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:42894 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069Ab2AMUfd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:35:33 -0500
Received: by mail-yw0-f74.google.com with SMTP id j52so102112yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:35:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: check if reclaim should really abort even if compaction_ready() is true for one zone
has been removed from the -mm tree.  Its filename was
     mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: vmscan: check if reclaim should really abort even if compaction_ready() is true for one zone

If compaction can proceed for a given zone, shrink_zones() does not
reclaim any more pages from it.  After commit [e0c2327: vmscan: abort
reclaim/compaction if compaction can proceed], do_try_to_free_pages()
tries to finish as soon as possible once one zone can compact.

This was intended to prevent slabs being shrunk unnecessarily but there
are side-effects.  One is that a small zone that is ready for compaction
will abort reclaim even if the chances of successfully allocating a THP
from that zone is small.  It also means that reclaim can return too early
even though sc->nr_to_reclaim pages were not reclaimed.

This partially reverts the commit until it is proven that slabs are really
being shrunk unnecessarily but preserves the check to return 1 to avoid
OOM if reclaim was aborted prematurely.

[aarcange@redhat.com: This patch replaces a revert from Andrea]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone
+++ a/mm/vmscan.c
@@ -2217,7 +2217,8 @@ static inline bool compaction_ready(stru
  *
  * This function returns true if a zone is being reclaimed for a costly
  * high-order allocation and compaction is ready to begin. This indicates to
- * the caller that it should retry the allocation or fail.
+ * the caller that it should consider retrying the allocation instead of
+ * further reclaim.
  */
 static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
@@ -2226,7 +2227,7 @@ static bool shrink_zones(int priority, s
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
-	bool should_abort_reclaim = false;
+	bool aborted_reclaim = false;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2252,7 +2253,7 @@ static bool shrink_zones(int priority, s
 				 * allocations.
 				 */
 				if (compaction_ready(zone, sc)) {
-					should_abort_reclaim = true;
+					aborted_reclaim = true;
 					continue;
 				}
 			}
@@ -2274,7 +2275,7 @@ static bool shrink_zones(int priority, s
 		shrink_zone(priority, zone, sc);
 	}
 
-	return should_abort_reclaim;
+	return aborted_reclaim;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2328,7 +2329,7 @@ static unsigned long do_try_to_free_page
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long writeback_threshold;
-	bool should_abort_reclaim;
+	bool aborted_reclaim;
 
 	get_mems_allowed();
 	delayacct_freepages_start();
@@ -2340,9 +2341,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->target_mem_cgroup);
-		should_abort_reclaim = shrink_zones(priority, zonelist, sc);
-		if (should_abort_reclaim)
-			break;
+		aborted_reclaim = shrink_zones(priority, zonelist, sc);
 
 		/*
 		 * Don't shrink slabs when reclaiming memory from
@@ -2409,8 +2408,8 @@ out:
 	if (oom_killer_disabled)
 		return 0;
 
-	/* Aborting reclaim to try compaction? don't OOM, then */
-	if (should_abort_reclaim)
+	/* Aborted reclaim to try compaction? don't OOM, then */
+	if (aborted_reclaim)
 		return 1;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
mm-__count_immobile_pages-make-sure-the-node-is-online.patch

