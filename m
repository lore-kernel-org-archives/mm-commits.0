From: akpm@linux-foundation.org
Subject: +
 mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
 added to -mm tree
Date: Thu, 21 Apr 2016 15:50:04 -0700
Message-ID: <5719591c.z0WVYoMYnERyIPFZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbcDUWuG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: distinguish between full and partial COMPACT_COMPLETE
has been added to the -mm tree.  Its filename is
     mm-compaction-distinguish-between-full-and-partial-compact_complete.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-distinguish-between-full-and-partial-compact_complete.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-distinguish-between-full-and-partial-compact_complete.patch

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
Subject: mm, compaction: distinguish between full and partial COMPACT_COMPLETE

COMPACT_COMPLETE now means that compaction and free scanner met.  This is
not very useful information if somebody just wants to use this feedback
and make any decisions based on that.  The current caller might be a poor
guy who just happened to scan tiny portion of the zone and that could be
the reason no suitable pages were compacted.  Make sure we distinguish the
full and partial zone walks.

Consumers should treat COMPACT_PARTIAL_SKIPPED as a potential success and
be optimistic in retrying.

The existing users of COMPACT_COMPLETE are conservatively changed to use
COMPACT_PARTIAL_SKIPPED as well but some of them should be probably
reconsidered and only defer the compaction only for COMPACT_COMPLETE with
the new semantic.

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

 include/linux/compaction.h        |   10 +++++++++-
 include/trace/events/compaction.h |    1 +
 mm/compaction.c                   |   14 +++++++++++---
 mm/internal.h                     |    1 +
 4 files changed, 22 insertions(+), 4 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-distinguish-between-full-and-partial-compact_complete include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-distinguish-between-full-and-partial-compact_complete
+++ a/include/linux/compaction.h
@@ -21,7 +21,15 @@ enum compact_result {
 	 * pages
 	 */
 	COMPACT_PARTIAL,
-	/* The full zone was compacted */
+	/*
+	 * direct compaction has scanned part of the zone but wasn't successfull
+	 * to compact suitable pages.
+	 */
+	COMPACT_PARTIAL_SKIPPED,
+	/*
+	 * The full zone was compacted scanned but wasn't successfull to compact
+	 * suitable pages.
+	 */
 	COMPACT_COMPLETE,
 	/* For more detailed tracepoint output */
 	COMPACT_NO_SUITABLE_PAGE,
diff -puN include/trace/events/compaction.h~mm-compaction-distinguish-between-full-and-partial-compact_complete include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-distinguish-between-full-and-partial-compact_complete
+++ a/include/trace/events/compaction.h
@@ -14,6 +14,7 @@
 	EM( COMPACT_DEFERRED,		"deferred")		\
 	EM( COMPACT_CONTINUE,		"continue")		\
 	EM( COMPACT_PARTIAL,		"partial")		\
+	EM( COMPACT_PARTIAL_SKIPPED,	"partial_skipped")	\
 	EM( COMPACT_COMPLETE,		"complete")		\
 	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
 	EM( COMPACT_NOT_SUITABLE_ZONE,	"not_suitable_zone")	\
diff -puN mm/compaction.c~mm-compaction-distinguish-between-full-and-partial-compact_complete mm/compaction.c
--- a/mm/compaction.c~mm-compaction-distinguish-between-full-and-partial-compact_complete
+++ a/mm/compaction.c
@@ -1299,7 +1299,10 @@ static enum compact_result __compact_fin
 		if (cc->direct_compaction)
 			zone->compact_blockskip_flush = true;
 
-		return COMPACT_COMPLETE;
+		if (cc->whole_zone)
+			return COMPACT_COMPLETE;
+		else
+			return COMPACT_PARTIAL_SKIPPED;
 	}
 
 	if (is_via_compact_memory(cc->order))
@@ -1460,6 +1463,10 @@ static enum compact_result compact_zone(
 		zone->compact_cached_migrate_pfn[0] = cc->migrate_pfn;
 		zone->compact_cached_migrate_pfn[1] = cc->migrate_pfn;
 	}
+
+	if (cc->migrate_pfn == start_pfn)
+		cc->whole_zone = true;
+
 	cc->last_migrated_pfn = 0;
 
 	trace_mm_compaction_begin(start_pfn, cc->migrate_pfn,
@@ -1690,7 +1697,8 @@ enum compact_result try_to_compact_pages
 			goto break_loop;
 		}
 
-		if (mode != MIGRATE_ASYNC && status == COMPACT_COMPLETE) {
+		if (mode != MIGRATE_ASYNC && (status == COMPACT_COMPLETE ||
+					status == COMPACT_PARTIAL_SKIPPED)) {
 			/*
 			 * We think that allocation won't succeed in this zone
 			 * so we defer compaction there. If it ends up
@@ -1936,7 +1944,7 @@ static void kcompactd_do_work(pg_data_t
 						cc.classzone_idx, 0)) {
 			success = true;
 			compaction_defer_reset(zone, cc.order, false);
-		} else if (status == COMPACT_COMPLETE) {
+		} else if (status == COMPACT_PARTIAL_SKIPPED || status == COMPACT_COMPLETE) {
 			/*
 			 * We use sync migration mode here, so we defer like
 			 * sync direct compaction does.
diff -puN mm/internal.h~mm-compaction-distinguish-between-full-and-partial-compact_complete mm/internal.h
--- a/mm/internal.h~mm-compaction-distinguish-between-full-and-partial-compact_complete
+++ a/mm/internal.h
@@ -179,6 +179,7 @@ struct compact_control {
 	enum migrate_mode mode;		/* Async or sync migration mode */
 	bool ignore_skip_hint;		/* Scan blocks even if marked skip */
 	bool direct_compaction;		/* False from kcompactd or /proc/... */
+	bool whole_zone;		/* Whole zone has been scanned */
 	int order;			/* order a direct compactor needs */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	const unsigned int alloc_flags;	/* alloc flags of a direct compactor */
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

