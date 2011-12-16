From: akpm@linux-foundation.org
Subject: + mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch added to -mm tree
Date: Fri, 16 Dec 2011 15:29:59 -0800
Message-ID: <20111216233000.6A7D210004D@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37121 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760308Ab1LPXaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 18:30:02 -0500
Received: by ghrr15 with SMTP id r15so175862ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 15:30:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, aarcange@redhat.com, adi@hexapodia.org, davej@redhat.com, jack@suse.cz, jweiner@redhat.com, minchan.kim@gmail.com, nai.xia@gmail.com, riel@redhat.com


The patch titled
     Subject: mm: page allocator: do not call direct reclaim for THP allocations while compaction is deferred
has been added to the -mm tree.  Its filename is
     mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred.patch

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
Subject: mm: page allocator: do not call direct reclaim for THP allocations while compaction is deferred

If compaction is deferred, direct reclaim is used to try to free enough
pages for the allocation to succeed.  For small high-orders, this has a
reasonable chance of success.  However, if the caller has specified
__GFP_NO_KSWAPD to limit the disruption to the system, it makes more sense
to fail the allocation rather than stall the caller in direct reclaim. 
This patch skips direct reclaim if compaction is deferred and the caller
specifies __GFP_NO_KSWAPD.

Async compaction only considers a subset of pages so it is possible for
compaction to be deferred prematurely and not enter direct reclaim even in
cases where it should.  To compensate for this, this patch also defers
compaction only if sync compaction failed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Rik van Riel<riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Andy Isaacson <adi@hexapodia.org>
Cc: Nai Xia <nai.xia@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-allocator-do-not-call-direct-reclaim-for-thp-allocations-while-compaction-is-deferred
+++ a/mm/page_alloc.c
@@ -2003,14 +2003,20 @@ static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress,
-	bool sync_migration)
+	int migratetype, bool sync_migration,
+	bool *deferred_compaction,
+	unsigned long *did_some_progress)
 {
 	struct page *page;
 
-	if (!order || compaction_deferred(preferred_zone))
+	if (!order)
 		return NULL;
 
+	if (compaction_deferred(preferred_zone)) {
+		*deferred_compaction = true;
+		return NULL;
+	}
+
 	current->flags |= PF_MEMALLOC;
 	*did_some_progress = try_to_compact_pages(zonelist, order, gfp_mask,
 						nodemask, sync_migration);
@@ -2038,7 +2044,13 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 		 * but not enough to satisfy watermarks.
 		 */
 		count_vm_event(COMPACTFAIL);
-		defer_compaction(preferred_zone);
+
+		/*
+		 * As async compaction considers a subset of pageblocks, only
+		 * defer if the failure was a sync compaction failure.
+		 */
+		if (sync_migration)
+			defer_compaction(preferred_zone);
 
 		cond_resched();
 	}
@@ -2050,8 +2062,9 @@ static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
-	int migratetype, unsigned long *did_some_progress,
-	bool sync_migration)
+	int migratetype, bool sync_migration,
+	bool *deferred_compaction,
+	unsigned long *did_some_progress)
 {
 	return NULL;
 }
@@ -2201,6 +2214,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	bool sync_migration = false;
+	bool deferred_compaction = false;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2281,12 +2295,22 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress,
-					sync_migration);
+					migratetype, sync_migration,
+					&deferred_compaction,
+					&did_some_progress);
 	if (page)
 		goto got_pg;
 	sync_migration = true;
 
+	/*
+	 * If compaction is deferred for high-order allocations, it is because
+	 * sync compaction recently failed. In this is the case and the caller
+	 * has requested the system not be heavily disrupted, fail the
+	 * allocation now instead of entering direct reclaim
+	 */
+	if (deferred_compaction && (gfp_mask & __GFP_NO_KSWAPD))
+		goto nopage;
+
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
 					zonelist, high_zoneidx,
@@ -2350,8 +2374,9 @@ rebalance:
 					zonelist, high_zoneidx,
 					nodemask,
 					alloc_flags, preferred_zone,
-					migratetype, &did_some_progress,
-					sync_migration);
+					migratetype, sync_migration,
+					&deferred_compaction,
+					&did_some_progress);
 		if (page)
 			goto got_pg;
 	}
_
Subject: Subject: mm: page allocator: do not call direct reclaim for THP allocations while compaction is deferred

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

