From: akpm@linux-foundation.org
Subject: + mm-compaction-abstract-compaction-feedback-to-helpers.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 14:51:25 -0700
Message-ID: <5704335d.A92XUtdF706Bh9ea%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760506AbcDEVv1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:51:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: Abstract compaction feedback to helpers
has been added to the -mm tree.  Its filename is
     mm-compaction-abstract-compaction-feedback-to-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-abstract-compaction-feedback-to-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-abstract-compaction-feedback-to-helpers.patch

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
Subject: mm, compaction: Abstract compaction feedback to helpers

Compaction can provide a wild variation of feedback to the caller.  Many
of them are implementation specific and the caller of the compaction
(especially the page allocator) shouldn't be bound to specifics of the
current implementation.

This patch abstracts the feedback into three basic types:
	- compaction_made_progress - compaction was active and made some
	  progress.
	- compaction_failed - compaction failed and further attempts to
	  invoke it would most probably fail and therefore it is not
	  worth retrying
	- compaction_withdrawn - compaction wasn't invoked for an
          implementation specific reasons. In the current implementation
          it means that the compaction was deferred, contended or the
          page scanners met too early without any progress. Retrying is
          still worthwhile.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |   74 +++++++++++++++++++++++++++++++++++
 mm/page_alloc.c            |   25 ++---------
 2 files changed, 80 insertions(+), 19 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-abstract-compaction-feedback-to-helpers
+++ a/include/linux/compaction.h
@@ -78,6 +78,70 @@ extern void compaction_defer_reset(struc
 				bool alloc_success);
 extern bool compaction_restarting(struct zone *zone, int order);
 
+/* Compaction has made some progress and retrying makes sense */
+static inline bool compaction_made_progress(enum compact_result result)
+{
+	/*
+	 * Even though this might sound confusing this in fact tells us
+	 * that the compaction successfully isolated and migrated some
+	 * pageblocks.
+	 */
+	if (result == COMPACT_PARTIAL)
+		return true;
+
+	return false;
+}
+
+/* Compaction has failed and it doesn't make much sense to keep retrying. */
+static inline bool compaction_failed(enum compact_result result)
+{
+	/* All zones where scanned completely and still not result. */
+	if (result == COMPACT_COMPLETE)
+		return true;
+
+	return false;
+}
+
+/*
+ * Compaction  has backed off for some reason. It might be throttling or
+ * lock contention. Retrying is still worthwhile.
+ */
+static inline bool compaction_withdrawn(enum compact_result result)
+{
+	/*
+	 * Compaction backed off due to watermark checks for order-0
+	 * so the regular reclaim has to try harder and reclaim something.
+	 */
+	if (result == COMPACT_SKIPPED)
+		return true;
+
+	/*
+	 * If compaction is deferred for high-order allocations, it is
+	 * because sync compaction recently failed. If this is the case
+	 * and the caller requested a THP allocation, we do not want
+	 * to heavily disrupt the system, so we fail the allocation
+	 * instead of entering direct reclaim.
+	 */
+	if (result == COMPACT_DEFERRED)
+		return true;
+
+	/*
+	 * If compaction in async mode encounters contention or blocks higher
+	 * priority task we back off early rather than cause stalls.
+	 */
+	if (result == COMPACT_CONTENDED)
+		return true;
+
+	/*
+	 * Page scanners have met but we haven't scanned full zones so this
+	 * is a back off in fact.
+	 */
+	if (result == COMPACT_PARTIAL_SKIPPED)
+		return true;
+
+	return false;
+}
+
 extern int kcompactd_run(int nid);
 extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
@@ -113,6 +177,16 @@ static inline bool compaction_deferred(s
 {
 	return true;
 }
+
+static inline bool compaction_made_progress(enum compact_result result)
+{
+	return false;
+}
+
+static inline bool compaction_withdrawn(enum compact_result result)
+{
+	return true;
+}
 
 static inline int kcompactd_run(int nid)
 {
diff -puN mm/page_alloc.c~mm-compaction-abstract-compaction-feedback-to-helpers mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-abstract-compaction-feedback-to-helpers
+++ a/mm/page_alloc.c
@@ -3366,25 +3366,12 @@ retry:
 	if (page)
 		goto got_pg;
 
-	/* Checks for THP-specific high-order allocations */
-	if (is_thp_gfp_mask(gfp_mask)) {
-		/*
-		 * If compaction is deferred for high-order allocations, it is
-		 * because sync compaction recently failed. If this is the case
-		 * and the caller requested a THP allocation, we do not want
-		 * to heavily disrupt the system, so we fail the allocation
-		 * instead of entering direct reclaim.
-		 */
-		if (compact_result == COMPACT_DEFERRED)
-			goto nopage;
-
-		/*
-		 * Compaction is contended so rather back off than cause
-		 * excessive stalls.
-		 */
-		if(compact_result == COMPACT_CONTENDED)
-			goto nopage;
-	}
+	/*
+	 * Checks for THP-specific high-order allocations and back off
+	 * if the the compaction backed off
+	 */
+	if (is_thp_gfp_mask(gfp_mask) && compaction_withdrawn(compact_result))
+		goto nopage;
 
 	/*
 	 * It can become very expensive to allocate transparent hugepages at
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-rework-oom-detection.patch
mm-throttle-on-io-only-when-there-are-too-many-dirty-and-writeback-pages.patch
mm-compaction-change-compact_-constants-into-enum.patch
mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
mm-compaction-update-compaction_result-ordering.patch
mm-compaction-simplify-__alloc_pages_direct_compact-feedback-interface.patch
mm-compaction-abstract-compaction-feedback-to-helpers.patch
mm-oom-protect-costly-allocations-some-more.patch
mm-consider-compaction-feedback-also-for-costly-allocation.patch

