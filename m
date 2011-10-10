From: akpm@google.com
Subject: + vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch added to -mm tree
Date: Mon, 10 Oct 2011 16:36:12 -0700
Message-ID: <201110102336.p9ANaCH2010028@wpaz33.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:33057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1JJXgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Oct 2011 19:36:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, hannes@cmpxchg.org, jwboyer@redhat.com, minchan.kim@gmail.com, riel@redhat.com


The patch titled
     Subject: vmscan: abort reclaim/compaction if compaction can proceed
has been added to the -mm tree.  Its filename is
     vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 mm/vmscan.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/vmscan.c~vmscan-abort-reclaim-compaction-if-compaction-can-proceed mm/vmscan.c
--- a/mm/vmscan.c~vmscan-abort-reclaim-compaction-if-compaction-can-proceed
+++ a/mm/vmscan.c
@@ -2091,14 +2091,19 @@ restart:
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
@@ -2116,12 +2121,15 @@ static void shrink_zones(int priority, s
 			if (COMPACTION_BUILD) {
 				/*
 				 * If we already have plenty of memory free
-				 * for compaction, don't free any more.
+				 * for compaction in this zone , don't free any
+				 * more.
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
@@ -2140,6 +2148,8 @@ static void shrink_zones(int priority, s
 
 		shrink_zone(priority, zone, sc);
 	}
+
+	return should_abort_reclaim;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2204,7 +2214,9 @@ static unsigned long do_try_to_free_page
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
Subject: Subject: vmscan: abort reclaim/compaction if compaction can proceed

Patches currently in -mm which might be from mgorman@suse.de are

mm-compaction-trivial-clean-up-in-acct_isolated.patch
mm-change-isolate-mode-from-define-to-bitwise-type.patch
mm-change-isolate-mode-from-define-to-bitwise-type-fix.patch
mm-compaction-make-isolate_lru_page-filter-aware.patch
mm-compaction-make-isolate_lru_page-filter-aware-fix.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware.patch
mm-zone_reclaim-make-isolate_lru_page-filter-aware-fix.patch
mm-migration-clean-up-unmap_and_move.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
mm-vmscan-remove-dead-code-related-to-lumpy-reclaim-waiting-on-pages-under-writeback.patch
xfs-warn-if-direct-reclaim-tries-to-writeback-pages.patch
ext4-warn-if-direct-reclaim-tries-to-writeback-pages.patch
mm-vmscan-do-not-writeback-filesystem-pages-in-kswapd-except-in-high-priority.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback.patch
mm-vmscan-throttle-reclaim-if-encountering-too-many-dirty-pages-under-writeback-update.patch
mm-vmscan-immediately-reclaim-end-of-lru-dirty-pages-when-writeback-completes.patch
vmscan-count-pages-into-balanced-for-zone-with-good-watermark.patch
mremap-check-for-overflow-using-deltas.patch
mremap-avoid-sending-one-ipi-per-page.patch
thp-mremap-support-and-tlb-optimization.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
kswapd-avoid-unnecessary-rebalance-after-an-unsuccessful-balancing.patch
kswapd-assign-new_order-and-new_classzone_idx-after-wakeup-in-sleeping.patch
vmscan-limit-direct-reclaim-for-higher-order-allocations.patch
vmscan-abort-reclaim-compaction-if-compaction-can-proceed.patch

