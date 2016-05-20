From: akpm@linux-foundation.org
Subject: [patch 010/162] mm, compaction: simplify
 __alloc_pages_direct_compact feedback interface
Date: Fri, 20 May 2016 16:56:53 -0700
Message-ID: <573fa445.owPck1YrysBNTK8k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52135 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbcETX4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:56:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com

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
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   67 +++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff -puN mm/page_alloc.c~mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface
+++ a/mm/page_alloc.c
@@ -3185,29 +3185,21 @@ out:
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
@@ -3233,6 +3225,24 @@ __alloc_pages_direct_compact(gfp_t gfp_m
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
@@ -3241,8 +3251,7 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
-		enum migrate_mode mode, int *contended_compaction,
-		bool *deferred_compaction)
+		enum migrate_mode mode, enum compact_result *compact_result)
 {
 	return NULL;
 }
@@ -3387,8 +3396,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long pages_reclaimed = 0;
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
-	bool deferred_compaction = false;
-	int contended_compaction = COMPACT_CONTENDED_NONE;
+	enum compact_result compact_result;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -3475,8 +3483,7 @@ retry:
 	 */
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags, ac,
 					migration_mode,
-					&contended_compaction,
-					&deferred_compaction);
+					&compact_result);
 	if (page)
 		goto got_pg;
 
@@ -3489,25 +3496,14 @@ retry:
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
 
@@ -3555,8 +3551,7 @@ noretry:
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
