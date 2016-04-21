From: akpm@linux-foundation.org
Subject: + mm-oom-rework-oom-detection.patch added to -mm tree
Date: Thu, 21 Apr 2016 15:50:16 -0700
Message-ID: <57195928.2Cxs3CHV3XI1NFOi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbcDUWuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: rework oom detection
has been added to the -mm tree.  Its filename is
     mm-oom-rework-oom-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-rework-oom-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-rework-oom-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: rework oom detection

__alloc_pages_slowpath has traditionally relied on the direct reclaim and
did_some_progress as an indicator that it makes sense to retry allocation
rather than declaring OOM.  shrink_zones had to rely on zone_reclaimable
if shrink_zone didn't make any progress to prevent from a premature OOM
killer invocation - the LRU might be full of dirty or writeback pages and
direct reclaim cannot clean those up.

zone_reclaimable allows to rescan the reclaimable lists several times and
restart if a page is freed.  This is really subtle behavior and it might
lead to a livelock when a single freed page keeps allocator looping but
the current task will not be able to allocate that single page.  OOM
killer would be more appropriate than looping without any progress for
unbounded amount of time.

This patch changes OOM detection logic and pulls it out from shrink_zone
which is too low to be appropriate for any high level decisions such as
OOM which is per zonelist property.  It is __alloc_pages_slowpath which
knows how many attempts have been done and what was the progress so far
therefore it is more appropriate to implement this logic.

The new heuristic is implemented in should_reclaim_retry helper called
from __alloc_pages_slowpath.  It tries to be more deterministic and easier
to follow.  It builds on an assumption that retrying makes sense only if
the currently reclaimable memory + free pages would allow the current
allocation request to succeed (as per __zone_watermark_ok) at least for
one zone in the usable zonelist.

This alone wouldn't be sufficient, though, because the writeback might get
stuck and reclaimable pages might be pinned for a really long time or even
depend on the current allocation context.  Therefore there is a backoff
mechanism implemented which reduces the reclaim target after each reclaim
round without any progress.  This means that we should eventually converge
to only NR_FREE_PAGES as the target and fail on the wmark check and
proceed to OOM.  The backoff is simple and linear with 1/16 of the
reclaimable pages for each round without any progress.  We are optimistic
and reset counter for successful reclaim rounds.

Costly high order pages mostly preserve their semantic and those without
__GFP_REPEAT fail right away while those which have the flag set will back
off after the amount of reclaimable pages reaches equivalent of the
requested order.  The only difference is that if there was no progress
during the reclaim we rely on zone watermark check.  This is more logical
thing to do than previous 1<<order attempts which were a result of
zone_reclaimable faking the progress.

[vdavydov@virtuozzo.com: check classzone_idx for shrink_zone]
[hannes@cmpxchg.org: separate the heuristic into should_reclaim_retry]
[rientjes@google.com: use zone_page_state_snapshot for NR_FREE_PAGES]
[rientjes@google.com: shrink_zones doesn't need to return anything]
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/page_alloc.c      |  100 +++++++++++++++++++++++++++++++++++++----
 mm/vmscan.c          |   25 +---------
 3 files changed, 97 insertions(+), 29 deletions(-)

diff -puN include/linux/swap.h~mm-oom-rework-oom-detection include/linux/swap.h
--- a/include/linux/swap.h~mm-oom-rework-oom-detection
+++ a/include/linux/swap.h
@@ -316,6 +316,7 @@ extern void lru_cache_add_active_or_unev
 						struct vm_area_struct *vma);
 
 /* linux/mm/vmscan.c */
+extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
 extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
diff -puN mm/page_alloc.c~mm-oom-rework-oom-detection mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-rework-oom-detection
+++ a/mm/page_alloc.c
@@ -3424,6 +3424,77 @@ static inline bool is_thp_gfp_mask(gfp_t
 	return (gfp_mask & (GFP_TRANSHUGE | __GFP_KSWAPD_RECLAIM)) == GFP_TRANSHUGE;
 }
 
+/*
+ * Maximum number of reclaim retries without any progress before OOM killer
+ * is consider as the only way to move forward.
+ */
+#define MAX_RECLAIM_RETRIES 16
+
+/*
+ * Checks whether it makes sense to retry the reclaim to make a forward progress
+ * for the given allocation request.
+ * The reclaim feedback represented by did_some_progress (any progress during
+ * the last reclaim round), pages_reclaimed (cumulative number of reclaimed
+ * pages) and no_progress_loops (number of reclaim rounds without any progress
+ * in a row) is considered as well as the reclaimable pages on the applicable
+ * zone list (with a backoff mechanism which is a function of no_progress_loops).
+ *
+ * Returns true if a retry is viable or false to enter the oom path.
+ */
+static inline bool
+should_reclaim_retry(gfp_t gfp_mask, unsigned order,
+		     struct alloc_context *ac, int alloc_flags,
+		     bool did_some_progress, unsigned long pages_reclaimed,
+		     int no_progress_loops)
+{
+	struct zone *zone;
+	struct zoneref *z;
+
+	/*
+	 * Make sure we converge to OOM if we cannot make any progress
+	 * several times in the row.
+	 */
+	if (no_progress_loops > MAX_RECLAIM_RETRIES)
+		return false;
+
+	if (order > PAGE_ALLOC_COSTLY_ORDER) {
+		if (pages_reclaimed >= (1<<order))
+			return false;
+
+		if (did_some_progress)
+			return true;
+	}
+
+	/*
+	 * Keep reclaiming pages while there is a chance this will lead somewhere.
+	 * If none of the target zones can satisfy our allocation request even
+	 * if all reclaimable pages are considered then we are screwed and have
+	 * to go OOM.
+	 */
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist, ac->high_zoneidx,
+					ac->nodemask) {
+		unsigned long available;
+
+		available = zone_reclaimable_pages(zone);
+		available -= DIV_ROUND_UP(no_progress_loops * available,
+					  MAX_RECLAIM_RETRIES);
+		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
+
+		/*
+		 * Would the allocation succeed if we reclaimed the whole
+		 * available?
+		 */
+		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
+				ac->high_zoneidx, alloc_flags, available)) {
+			/* Wait for some write requests to complete then retry */
+			wait_iff_congested(zone, BLK_RW_ASYNC, HZ/50);
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -3435,6 +3506,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	enum compact_result compact_result;
+	int no_progress_loops = 0;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -3554,23 +3626,35 @@ retry:
 	if (gfp_mask & __GFP_NORETRY)
 		goto noretry;
 
-	/* Keep reclaiming pages as long as there is reasonable progress */
-	pages_reclaimed += did_some_progress;
-	if ((did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER) ||
-	    ((gfp_mask & __GFP_REPEAT) && pages_reclaimed < (1 << order))) {
-		/* Wait for some write requests to complete then retry */
-		wait_iff_congested(ac->preferred_zoneref->zone, BLK_RW_ASYNC, HZ/50);
-		goto retry;
+	/*
+	 * Do not retry costly high order allocations unless they are
+	 * __GFP_REPEAT
+	 */
+	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_REPEAT))
+		goto noretry;
+
+	if (did_some_progress) {
+		no_progress_loops = 0;
+		pages_reclaimed += did_some_progress;
+	} else {
+		no_progress_loops++;
 	}
 
+	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
+				 did_some_progress > 0, pages_reclaimed,
+				 no_progress_loops))
+		goto retry;
+
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
 	if (page)
 		goto got_pg;
 
 	/* Retry as long as the OOM killer is making progress */
-	if (did_some_progress)
+	if (did_some_progress) {
+		no_progress_loops = 0;
 		goto retry;
+	}
 
 noretry:
 	/*
diff -puN mm/vmscan.c~mm-oom-rework-oom-detection mm/vmscan.c
--- a/mm/vmscan.c~mm-oom-rework-oom-detection
+++ a/mm/vmscan.c
@@ -191,7 +191,7 @@ static bool sane_reclaim(struct scan_con
 }
 #endif
 
-static unsigned long zone_reclaimable_pages(struct zone *zone)
+unsigned long zone_reclaimable_pages(struct zone *zone)
 {
 	unsigned long nr;
 
@@ -2507,10 +2507,8 @@ static inline bool compaction_ready(stru
  *
  * If a zone is deemed to be full of pinned pages then just give it a light
  * scan then give up on it.
- *
- * Returns true if a zone was reclaimable.
  */
-static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
+static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -2518,7 +2516,6 @@ static bool shrink_zones(struct zonelist
 	unsigned long nr_soft_scanned;
 	gfp_t orig_mask;
 	enum zone_type requested_highidx = gfp_zone(sc->gfp_mask);
-	bool reclaimable = false;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2583,17 +2580,10 @@ static bool shrink_zones(struct zonelist
 						&nr_soft_scanned);
 			sc->nr_reclaimed += nr_soft_reclaimed;
 			sc->nr_scanned += nr_soft_scanned;
-			if (nr_soft_reclaimed)
-				reclaimable = true;
 			/* need some check for avoid more shrink_zone() */
 		}
 
-		if (shrink_zone(zone, sc, zone_idx(zone) == classzone_idx))
-			reclaimable = true;
-
-		if (global_reclaim(sc) &&
-		    !reclaimable && zone_reclaimable(zone))
-			reclaimable = true;
+		shrink_zone(zone, sc, zone_idx(zone) == classzone_idx);
 	}
 
 	/*
@@ -2601,8 +2591,6 @@ static bool shrink_zones(struct zonelist
 	 * promoted it to __GFP_HIGHMEM.
 	 */
 	sc->gfp_mask = orig_mask;
-
-	return reclaimable;
 }
 
 /*
@@ -2627,7 +2615,6 @@ static unsigned long do_try_to_free_page
 	int initial_priority = sc->priority;
 	unsigned long total_scanned = 0;
 	unsigned long writeback_threshold;
-	bool zones_reclaimable;
 retry:
 	delayacct_freepages_start();
 
@@ -2638,7 +2625,7 @@ retry:
 		vmpressure_prio(sc->gfp_mask, sc->target_mem_cgroup,
 				sc->priority);
 		sc->nr_scanned = 0;
-		zones_reclaimable = shrink_zones(zonelist, sc);
+		shrink_zones(zonelist, sc);
 
 		total_scanned += sc->nr_scanned;
 		if (sc->nr_reclaimed >= sc->nr_to_reclaim)
@@ -2685,10 +2672,6 @@ retry:
 		goto retry;
 	}
 
-	/* Any of the zones still reclaimable?  Don't OOM. */
-	if (zones_reclaimable)
-		return 1;
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper-clear-oom_reaper_list-before-clearing-tif_memdie.patch
vmscan-consider-classzone_idx-in-compaction_ready.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-use-compaction-feedback-for-thp-backoff-conditions.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch
mm-oom-compaction-prevent-from-should_compact_retry-looping-for-ever-for-costly-orders.patch

