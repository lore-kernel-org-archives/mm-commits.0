From: akpm@linux-foundation.org
Subject: + mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
 added to -mm tree
Date: Thu, 21 Apr 2016 15:50:00 -0700
Message-ID: <57195918.HOBjS66FIe8SIc0m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60850 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbcDUWuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2016 18:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: cover all compaction mode in compact_zone
has been added to the -mm tree.  Its filename is
     mm-compaction-cover-all-compaction-mode-in-compact_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-cover-all-compaction-mode-in-compact_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-cover-all-compaction-mode-in-compact_zone.patch

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
Subject: mm, compaction: cover all compaction mode in compact_zone

The compiler is complaining after "mm, compaction: change COMPACT_
constants into enum"

mm/compaction.c: In function `compact_zone':
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_DEFERRED' not handled in switch [-Wswitch]
  switch (ret) {
  ^
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_COMPLETE' not handled in switch [-Wswitch]
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_NO_SUITABLE_PAGE' not handled in switch [-Wswitch]
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_NOT_SUITABLE_ZONE' not handled in switch [-Wswitch]
mm/compaction.c:1350:2: warning: enumeration value `COMPACT_CONTENDED' not handled in switch [-Wswitch]

compaction_suitable is allowed to return only COMPACT_PARTIAL,
COMPACT_SKIPPED and COMPACT_CONTINUE so other cases are simply
impossible. Put a VM_BUG_ON to catch an impossible return value.

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

 mm/compaction.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cover-all-compaction-mode-in-compact_zone mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cover-all-compaction-mode-in-compact_zone
+++ a/mm/compaction.c
@@ -1430,15 +1430,12 @@ static enum compact_result compact_zone(
 
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
-	switch (ret) {
-	case COMPACT_PARTIAL:
-	case COMPACT_SKIPPED:
-		/* Compaction is likely to fail */
+	/* Compaction is likely to fail */
+	if (ret == COMPACT_PARTIAL || ret == COMPACT_SKIPPED)
 		return ret;
-	case COMPACT_CONTINUE:
-		/* Fall through to compaction */
-		;
-	}
+
+	/* huh, compaction_suitable is returning something unexpected */
+	VM_BUG_ON(ret != COMPACT_CONTINUE);
 
 	/*
 	 * Clear pageblock skip if there were failures recently and compaction
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

