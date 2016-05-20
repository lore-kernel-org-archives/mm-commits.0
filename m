From: akpm@linux-foundation.org
Subject: [patch 014/162] mm, oom: protect !costly allocations some more
Date: Fri, 20 May 2016 16:57:06 -0700
Message-ID: <573fa452.INzQBgWHH13pSfvj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbcETX5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom: protect !costly allocations some more

should_reclaim_retry will give up retries for higher order allocations if
none of the eligible zones has any requested or higher order pages
available even if we pass the watermak check for order-0.  This is done
because there is no guarantee that the reclaimable and currently free
pages will form the required order.

This can, however, lead to situations where the high-order request
(e.g.  order-2 required for the stack allocation during fork) will
trigger OOM too early - e.g.  after the first reclaim/compaction round.
Such a system would have to be highly fragmented and there is no
guarantee further reclaim/compaction attempts would help but at least
make sure that the compaction was active before we go OOM and keep
retrying even if should_reclaim_retry tells us to oom if

	- the last compaction round backed off or
	- we haven't completed at least MAX_COMPACT_RETRIES active
	  compaction rounds.

The first rule ensures that the very last attempt for compaction was not
ignored while the second guarantees that the compaction has done some
work.  Multiple retries might be needed to prevent occasional pigggy
backing of other contexts to steal the compacted pages before the current
context manages to retry to allocate them.

compaction_failed() is taken as a final word from the compaction that the
retry doesn't make much sense.  We have to be careful though because the
first compaction round is MIGRATE_ASYNC which is rather weak as it ignores
pages under writeback and gives up too easily in other situations.  We
therefore have to make sure that MIGRATE_SYNC_LIGHT mode has been used
before we give up.  With this logic in place we do not have to increase
the migration mode unconditionally and rather do it only if the compaction
failed for the weaker mode.  A nice side effect is that the stronger
migration mode is used only when really needed so this has a potential of
smaller latencies in some cases.

Please note that the compaction doesn't tell us much about how successful
it was when returning compaction_made_progress so we just have to blindly
trust that another retry is worthwhile and cap the number to something
reasonable to guarantee a convergence.

If the given number of successful retries is not sufficient for a
reasonable workloads we should focus on the collected compaction
tracepoints data and try to address the issue in the compaction code.  If
this is not feasible we can increase the retries limit.

[mhocko@suse.com: fix warning]
  Link: http://lkml.kernel.org/r/20160512061636.GA4200@dhcp22.suse.cz
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

 mm/page_alloc.c |   88 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 78 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more mm/page_alloc.c
--- a/mm/page_alloc.c~mm-oom-protect-costly-allocations-some-more
+++ a/mm/page_alloc.c
@@ -3180,6 +3180,13 @@ out:
 	return page;
 }
 
+
+/*
+ * Maximum number of compaction retries wit a progress before OOM
+ * killer is consider as the only way to move forward.
+ */
+#define MAX_COMPACT_RETRIES 16
+
 #ifdef CONFIG_COMPACTION
 /* Try memory compaction for high-order allocations before reclaim */
 static struct page *
@@ -3247,14 +3254,60 @@ __alloc_pages_direct_compact(gfp_t gfp_m
 
 	return NULL;
 }
+
+static inline bool
+should_compact_retry(unsigned int order, enum compact_result compact_result,
+		     enum migrate_mode *migrate_mode,
+		     int compaction_retries)
+{
+	if (!order)
+		return false;
+
+	/*
+	 * compaction considers all the zone as desperately out of memory
+	 * so it doesn't really make much sense to retry except when the
+	 * failure could be caused by weak migration mode.
+	 */
+	if (compaction_failed(compact_result)) {
+		if (*migrate_mode == MIGRATE_ASYNC) {
+			*migrate_mode = MIGRATE_SYNC_LIGHT;
+			return true;
+		}
+		return false;
+	}
+
+	/*
+	 * !costly allocations are really important and we have to make sure
+	 * the compaction wasn't deferred or didn't bail out early due to locks
+	 * contention before we go OOM. Still cap the reclaim retry loops with
+	 * progress to prevent from looping forever and potential trashing.
+	 */
+	if (order <= PAGE_ALLOC_COSTLY_ORDER) {
+		if (compaction_withdrawn(compact_result))
+			return true;
+		if (compaction_retries <= MAX_COMPACT_RETRIES)
+			return true;
+	}
+
+	return false;
+}
 #else
 static inline struct page *
 __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		unsigned int alloc_flags, const struct alloc_context *ac,
 		enum migrate_mode mode, enum compact_result *compact_result)
 {
+	*compact_result = COMPACT_SKIPPED;
 	return NULL;
 }
+
+static inline bool
+should_compact_retry(unsigned int order, enum compact_result compact_result,
+		     enum migrate_mode *migrate_mode,
+		     int compaction_retries)
+{
+	return false;
+}
 #endif /* CONFIG_COMPACTION */
 
 /* Perform direct synchronous page reclaim */
@@ -3501,6 +3554,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 	unsigned long did_some_progress;
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	enum compact_result compact_result;
+	int compaction_retries = 0;
 	int no_progress_loops = 0;
 
 	/*
@@ -3612,13 +3666,8 @@ retry:
 			goto nopage;
 	}
 
-	/*
-	 * It can become very expensive to allocate transparent hugepages at
-	 * fault, so use asynchronous memory compaction for THP unless it is
-	 * khugepaged trying to collapse.
-	 */
-	if (!is_thp_gfp_mask(gfp_mask) || (current->flags & PF_KTHREAD))
-		migration_mode = MIGRATE_SYNC_LIGHT;
+	if (order && compaction_made_progress(compact_result))
+		compaction_retries++;
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order, alloc_flags, ac,
@@ -3649,6 +3698,17 @@ retry:
 				 no_progress_loops))
 		goto retry;
 
+	/*
+	 * It doesn't make any sense to retry for the compaction if the order-0
+	 * reclaim is not able to make any progress because the current
+	 * implementation of the compaction depends on the sufficient amount
+	 * of free memory (see __compaction_suitable)
+	 */
+	if (did_some_progress > 0 &&
+			should_compact_retry(order, compact_result,
+				&migration_mode, compaction_retries))
+		goto retry;
+
 	/* Reclaim has failed us, start killing things */
 	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
 	if (page)
@@ -3662,10 +3722,18 @@ retry:
 
 noretry:
 	/*
-	 * High-order allocations do not necessarily loop after
-	 * direct reclaim and reclaim/compaction depends on compaction
-	 * being called after reclaim so call directly if necessary
+	 * High-order allocations do not necessarily loop after direct reclaim
+	 * and reclaim/compaction depends on compaction being called after
+	 * reclaim so call directly if necessary.
+	 * It can become very expensive to allocate transparent hugepages at
+	 * fault, so use asynchronous memory compaction for THP unless it is
+	 * khugepaged trying to collapse. All other requests should tolerate
+	 * at least light sync migration.
 	 */
+	if (is_thp_gfp_mask(gfp_mask) && !(current->flags & PF_KTHREAD))
+		migration_mode = MIGRATE_ASYNC;
+	else
+		migration_mode = MIGRATE_SYNC_LIGHT;
 	page = __alloc_pages_direct_compact(gfp_mask, order, alloc_flags,
 					    ac, migration_mode,
 					    &compact_result);
_
