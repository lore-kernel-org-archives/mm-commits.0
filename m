From: akpm@linux-foundation.org
Subject: + mm-compaction-update-compaction_result-ordering.patch added to
 -mm tree
Date: Thu, 21 Apr 2016 15:50:06 -0700
Message-ID: <5719591e.9OFb3E7MHCpmwbrE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbcDUWuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: Update compaction_result ordering
has been added to the -mm tree.  Its filename is
     mm-compaction-update-compaction_result-ordering.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-update-compaction_result-ordering.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-update-compaction_result-ordering.patch

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
Subject: mm, compaction: Update compaction_result ordering

compaction_result will be used as the primary feedback channel for
compaction users.  At the same time try_to_compact_pages (and potentially
others) assume a certain ordering where a more specific feedback takes
precendence.  This gets a bit awkward when we have conflicting feedback
from different zones.  E.g one returing COMPACT_COMPLETE meaning the full
zone has been scanned without any outcome while other returns with
COMPACT_PARTIAL aka made some progress.  The caller should get
COMPACT_PARTIAL because that means that the compaction still can make some
progress.  The same applies for COMPACT_PARTIAL vs. 
COMPACT_PARTIAL_SKIPPED.  Reorder PARTIAL to be the largest one so the
larger the value is the more progress we have done.

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

 include/linux/compaction.h |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-update-compaction_result-ordering include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-update-compaction_result-ordering
+++ a/include/linux/compaction.h
@@ -4,6 +4,8 @@
 /* Return values for compact_zone() and try_to_compact_pages() */
 /* When adding new states, please adjust include/trace/events/compaction.h */
 enum compact_result {
+	/* For more detailed tracepoint output - internal to compaction */
+	COMPACT_NOT_SUITABLE_ZONE,
 	/*
 	 * compaction didn't start as it was not possible or direct reclaim
 	 * was more suitable
@@ -11,30 +13,34 @@ enum compact_result {
 	COMPACT_SKIPPED,
 	/* compaction didn't start as it was deferred due to past failures */
 	COMPACT_DEFERRED,
+
 	/* compaction not active last round */
 	COMPACT_INACTIVE = COMPACT_DEFERRED,
 
+	/* For more detailed tracepoint output - internal to compaction */
+	COMPACT_NO_SUITABLE_PAGE,
 	/* compaction should continue to another pageblock */
 	COMPACT_CONTINUE,
+
 	/*
-	 * direct compaction partially compacted a zone and there are suitable
-	 * pages
+	 * The full zone was compacted scanned but wasn't successfull to compact
+	 * suitable pages.
 	 */
-	COMPACT_PARTIAL,
+	COMPACT_COMPLETE,
 	/*
 	 * direct compaction has scanned part of the zone but wasn't successfull
 	 * to compact suitable pages.
 	 */
 	COMPACT_PARTIAL_SKIPPED,
+
+	/* compaction terminated prematurely due to lock contentions */
+	COMPACT_CONTENDED,
+
 	/*
-	 * The full zone was compacted scanned but wasn't successfull to compact
-	 * suitable pages.
+	 * direct compaction partially compacted a zone and there might be
+	 * suitable pages
 	 */
-	COMPACT_COMPLETE,
-	/* For more detailed tracepoint output */
-	COMPACT_NO_SUITABLE_PAGE,
-	COMPACT_NOT_SUITABLE_ZONE,
-	COMPACT_CONTENDED,
+	COMPACT_PARTIAL,
 };
 
 /* Used to signal whether compaction detected need_sched() or lock contention */
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

