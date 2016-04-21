From: akpm@linux-foundation.org
Subject: +
 mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch added to -mm tree
Date: Thu, 21 Apr 2016 15:50:08 -0700
Message-ID: <57195920.Zh3lXyZrYIypH/nW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60899 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbcDUWuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: simplify __alloc_pages_direct_compact feedback interface
has been added to the -mm tree.  Its filename is
     mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch

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
Subject: mm, compaction: simplify __alloc_pages_direct_compact feedback interface

__alloc_pages_direct_compact communicates potential back off by two
variables:
	- deferred_compaction tells that the compaction returned
	  COMPACT_DEFERRED
	- contended_compaction is set when there is a contention on
	  zone->lock resp. zone->lru_lock locks

__alloc_pages_slowpath then backs of for THP allocation requests to
prevent from long stalls. This is rather messy and it would be much
cleaner to return a single compact result value and hide all the nasty
details into __alloc_pages_direct_compact.

This patch shouldn't introduce any functional changes.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   67 +++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface
+++ a/mm/page_alloc.c
@@ -3223,29 +3223,21 @@ out:
 static struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum migrate_mode mode, int *contended_compaction,
-		bool *deferred_compaction)
+		enum migrate_mode mode, enum compact_result *compact_result)
 {
-	enum compact_result compact_result;
 	struct page *page;
+	int contended_compaction;
 
 	if (!order)
 		return NULL;
 
 	current->flags |= PF_MEMALLOC;
-	compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-						mode, contended_compaction);
+	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
+						mode, &contended_compaction);
 	current->flags &= ~PF_MEMALLOC;
 
-	switch (compact_result) {
-	case COMPACT_DEFERRED:
-		*deferred_compaction = true;
-		/* fall-through */
-	case COMPACT_SKIPPED:
+	if (*compact_result <= COMPACT_INACTIVE)
 		return NULL;
-	default:
-		break;
-	}
 
 	/*
 	 * At least in one zone compaction wasn't deferred or skipped, so let's
@@ -3271,6 +3263,24 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 	 */
 	count_vm_event(COMPACTFAIL);
 
+	/*
+	 * In all zones where compaction was attempted (and not
+	 * deferred or skipped), lock contention has been detected.
+	 * For THP allocation we do not want to disrupt the others
+	 * so we fallback to base pages instead.
+	 */
+	if (contended_compaction == COMPACT_CONTENDED_LOCK)
+		*compact_result = COMPACT_CONTENDED;
+
+	/*
+	 * If compaction was aborted due to need_resched(), we do not
+	 * want to further increase allocation latency, unless it is
+	 * khugepaged trying to collapse.
+	 */
+	if (contended_compaction == COMPACT_CONTENDED_SCHED
+		&& !(current->flags & PF_KTHREAD))
+		*compact_result = COMPACT_CONTENDED;
+
 	cond_resched();
 
 	return NULL;
@@ -3279,8 +3289,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum migrate_mode mode, int *contended_compaction,
-		bool *deferred_compaction)
+		enum migrate_mode mode, enum compact_result *compact_result)
 {
 	return NULL;
 }
@@ -3425,8 +3434,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
-	bool deferred_compaction = false;
-	int contended_compaction = COMPACT_CONTENDED_NONE;
+	enum compact_result compact_result;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -3515,8 +3523,7 @@ retry:
 	 */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
 					migration_mode,
-					&contended_compaction,
-					&deferred_compaction);
+					&compact_result);
 	if (page)
 		goto got_pg;
 
@@ -3529,25 +3536,14 @@ retry:
 		 * to heavily disrupt the system, so we fail the allocation
 		 * instead of entering direct reclaim.
 		 */
-		if (deferred_compaction)
-			goto nopage;
-
-		/*
-		 * In all zones where compaction was attempted (and not
-		 * deferred or skipped), lock contention has been detected.
-		 * For THP allocation we do not want to disrupt the others
-		 * so we fallback to base pages instead.
-		 */
-		if (contended_compaction == COMPACT_CONTENDED_LOCK)
+		if (compact_result == COMPACT_DEFERRED)
 			goto nopage;
 
 		/*
-		 * If compaction was aborted due to need_resched(), we do not
-		 * want to further increase allocation latency, unless it is
-		 * khugepaged trying to collapse.
+		 * Compaction is contended so rather back off than cause
+		 * excessive stalls.
 		 */
-		if (contended_compaction == COMPACT_CONTENDED_SCHED
-			&& !(current->flags & PF_KTHREAD))
+		if(compact_result == COMPACT_CONTENDED)
 			goto nopage;
 	}
 
@@ -3595,8 +3591,7 @@ noretry:
 	 */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags,
 					    ac, migration_mode,
-					    &contended_compaction,
-					    &deferred_compaction);
+					    &compact_result);
 	if (page)
 		goto got_pg;
 nopage:
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

