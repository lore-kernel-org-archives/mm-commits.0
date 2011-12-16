From: akpm@linux-foundation.org
Subject: + mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:30:11 -0800
Message-ID: <20111216233012.DD4995C0064@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:47864 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1LPXaQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:30:16 -0500
Received: by eaad1 with SMTP id d1so103923eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:30:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: vmscan: check if reclaim should really abort even if compaction_ready() is true for one zone
has been added to the -mm tree.  Its filename is
     mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch

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
@@ -2164,7 +2164,8 @@ static inline bool compaction_ready(stru
  *
  * This function returns true if a zone is being reclaimed for a costly
  * high-order allocation and compaction is ready to begin. This indicates to
- * the caller that it should retry the allocation or fail.
+ * the caller that it should consider retrying the allocation instead of
+ * further reclaim.
  */
 static bool shrink_zones(int priority, struct zonelist *zonelist,
 					struct scan_control *sc)
@@ -2173,7 +2174,7 @@ static bool shrink_zones(int priority, s
 	struct zone *zone;
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
-	bool should_abort_reclaim = false;
+	bool aborted_reclaim = false;
 
 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
 					gfp_zone(sc->gfp_mask), sc->nodemask) {
@@ -2199,7 +2200,7 @@ static bool shrink_zones(int priority, s
 				 * allocations.
 				 */
 				if (compaction_ready(zone, sc)) {
-					should_abort_reclaim = true;
+					aborted_reclaim = true;
 					continue;
 				}
 			}
@@ -2221,7 +2222,7 @@ static bool shrink_zones(int priority, s
 		shrink_zone(priority, zone, sc);
 	}
 
-	return should_abort_reclaim;
+	return aborted_reclaim;
 }
 
 static bool zone_reclaimable(struct zone *zone)
@@ -2275,7 +2276,7 @@ static unsigned long do_try_to_free_page
 	struct zoneref *z;
 	struct zone *zone;
 	unsigned long writeback_threshold;
-	bool should_abort_reclaim;
+	bool aborted_reclaim;
 
 	get_mems_allowed();
 	delayacct_freepages_start();
@@ -2287,9 +2288,7 @@ static unsigned long do_try_to_free_page
 		sc->nr_scanned = 0;
 		if (!priority)
 			disable_swap_token(sc->mem_cgroup);
-		should_abort_reclaim = shrink_zones(priority, zonelist, sc);
-		if (should_abort_reclaim)
-			break;
+		aborted_reclaim = shrink_zones(priority, zonelist, sc);
 
 		/*
 		 * Don't shrink slabs when reclaiming memory from
@@ -2356,8 +2355,8 @@ out:
 	if (oom_killer_disabled)
 		return 0;
 
-	/* Aborting reclaim to try compaction? don't OOM, then */
-	if (should_abort_reclaim)
+	/* Aborted reclaim to try compaction? don't OOM, then */
+	if (aborted_reclaim)
 		return 1;
 
 	/* top priority shrink_zones still had more to do? don't OOM, then */
_
Subject: Subject: mm: vmscan: check if reclaim should really abort even if compaction_ready() is true for one zone

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes-checkpatch-fixes.patch
mm-avoid-livelock-on-__gfp_fs-allocations-v2.patch
mm-more-intensive-memory-corruption-debug.patch
mm-more-intensive-memory-corruption-debug-fix.patch
pm-hibernate-do-not-count-debug-pages-as-savable.patch
slub-min-order-when-debug_guardpage_minorder-0.patch
mm-debug-test-for-online-nid-when-allocating-on-single-node.patch
mm-exclude-reserved-pages-from-dirtyable-memory.patch
mm-exclude-reserved-pages-from-dirtyable-memory-fix.patch
mm-try-to-distribute-dirty-pages-fairly-across-zones.patch
mm-filemap-pass-__gfp_write-from-grab_cache_page_write_begin.patch
btrfs-pass-__gfp_write-for-buffered-write-page-allocations.patch
mm-compaction-push-isolate-search-base-of-compact-control-one-pfn-ahead.patch
mm-fix-off-by-two-in-__zone_watermark_ok.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma.patch
mremap-enforce-rmap-src-dst-vma-ordering-in-case-of-vma_merge-succeeding-in-copy_vma-update.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
revert-mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-compaction-allow-compaction-to-isolate-dirty-pages.patch
mm-compaction-use-synchronous-compaction-for-proc-sys-vm-compact_memory.patch
mm-vmscan-check-if-we-isolated-a-compound-page-during-lumpy-scan.patch
mm-vmscan-do-not-oom-if-aborting-reclaim-to-start-compaction.patch
mm-compaction-determine-if-dirty-pages-can-be-migrated-without-blocking-within-migratepage.patch
mm-compaction-make-isolate_lru_page-filter-aware-again.patch
mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch
mm-compaction-introduce-sync-light-migration-for-use-by-compaction.patch
mm-vmscan-when-reclaiming-for-compaction-ensure-there-are-sufficient-free-pages-available.patch
mm-vmscan-check-if-reclaim-should-really-abort-even-if-compaction_ready-is-true-for-one-zone.patch
mm-isolate-pages-for-immediate-reclaim-on-their-own-lru.patch

