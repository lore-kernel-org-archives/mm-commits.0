From: akpm@linux-foundation.org
Subject: [merged] vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:12:11 -0700
Message-ID: <201111012112.pA1LCB8e005665@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:15951 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVMT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:12:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aarcange@redhat.com, jwboyer@redhat.com, jweiner@redhat.com, minchan.kim@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: abort reclaim/compaction if compaction can proceed
has been removed from the -mm tree.  Its filename was
     vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: vmscan: abort reclaim/compaction if compaction can proceed

If compaction can proceed, shrink_zones() stops doing any work but its
callers still call shrink_slab() which raises the priority and potentially
sleeps.  This is unnecessary and wasteful so this patch aborts direct
reclaim/compaction entirely if compaction can proceed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: Johannes Weiner <jweiner@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff -puN mm/vmscan.c~vmscan-abort-reclaim-compaction-if-compaction-can-proceed mm/vmscan.c
--- a/mm/vmscan.c~vmscan-abort-reclaim-compaction-if-compaction-can-proceed
+++ a/mm/vmscan.c
@@ -2103,14 +2103,19 @@ restart:
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
+ *
+ * This function returns true if a zone is being reclaimed for a costly
+ * high-order allocation and compaction is either ready to begin or deferred.
+ * This indicates to the caller that it should retry the allocation or fail.
  */
-static void shrink_zones(int priority, struct zonelist *zonelist,
+static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
+	bool should_abort_reclaim = false;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2127,19 +2132,20 @@ static void shrink_zones(int priority, s
 				continue;	/* Let kswapd poll it */
 			if (COMPACTION_BUILD) {
 				/*
-				 * If we already have plenty of memory
-				 * free for compaction, don't free any
-				 * more.  Even though compaction is
-				 * invoked for any non-zero order,
-				 * only frequent costly order
-				 * reclamation is disruptive enough to
-				 * become a noticable problem, like
-				 * transparent huge page allocations.
+				 * If we already have plenty of memory free for
+				 * compaction in this zone, don't free any more.
+				 * Even though compaction is invoked for any
+				 * non-zero order, only frequent costly order
+				 * reclamation is disruptive enough to become a
+				 * noticable problem, like transparent huge page
+				 * allocations.
 				 */
 				if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
 					(compaction_suitable(zone, sc->order) ||
-					 compaction_deferred(zone)))
+					 compaction_deferred(zone))) {
+					should_abort_reclaim = true;
 					continue;
+				}
 			}
 			/*
 			 * This steals pages from memory cgroups over softlimit
@@ -2158,6 +2164,8 @@ static void shrink_zones(int priority, s
 
 		shrink_zone(priority, zone, sc);
 	}
+
+	return should_abort_reclaim;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2222,7 +2230,9 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		shrink_zones(priority, zonelist, sc);
+		if (shrink_zones(priority, zonelist, sc))
+			break;
+
 		/*
 		 * Don't shrink slabs when reclaiming memory from
 		 * over limit cgroups
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
thp-tail-page-refcounting-fix-5.patch
powerpc-remove-superfluous-pagetail-checks-on-the-pte-gup_fast.patch
powerpc-get_hugepte-dont-put_page-the-wrong-page.patch
powerpc-gup_hugepte-avoid-to-free-the-head-page-too-many-times.patch
powerpc-gup_hugepte-support-thp-based-tail-recounting.patch
powerpc-gup_huge_pmd-return-0-if-pte-changes.patch
s390-gup_huge_pmd-support-thp-tail-recounting.patch
s390-gup_huge_pmd-return-0-if-pte-changes.patch
sparc-gup_pte_range-support-thp-based-tail-recounting.patch
thp-share-get_huge_page_tail.patch

