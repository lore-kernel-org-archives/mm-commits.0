From: akpm@linux-foundation.org
Subject: [patch 007/162] mm, compaction: distinguish COMPACT_DEFERRED from COMPACT_SKIPPED
Date: Fri, 20 May 2016 16:56:44 -0700
Message-ID: <573fa43c.s2zatdhOv4b5cM2x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbcETX4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@techsingularity.net, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com

From: Michal Hocko <mhocko@suse.com>
Subject: mm, compaction: distinguish COMPACT_DEFERRED from COMPACT_SKIPPED

try_to_compact_pages() can currently return COMPACT_SKIPPED even when the
compaction is defered for some zone just because zone DMA is skipped in
99% of cases due to watermark checks.  This makes COMPACT_DEFERRED
basically unusable for the page allocator as a feedback mechanism.

Make sure we distinguish those two states properly and switch their
ordering in the enum.  This would mean that the COMPACT_SKIPPED will be
returned only when all eligible zones are skipped.

As a result COMPACT_DEFERRED handling for THP in __alloc_pages_slowpath
will be more precise and we would bail out rather than reclaim.

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

 include/linux/compaction.h        |    7 +++++--
 include/trace/events/compaction.h |    2 +-
 mm/compaction.c                   |    8 +++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-distinguish-compact_deferred-from-compact_skipped include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-distinguish-compact_deferred-from-compact_skipped
+++ a/include/linux/compaction.h
@@ -4,13 +4,16 @@
 /* Return values for compact_zone() and try_to_compact_pages() */
 /* When adding new states, please adjust include/trace/events/compaction.h */
 enum compact_result {
-	/* compaction didn't start as it was deferred due to past failures */
-	COMPACT_DEFERRED,
 	/*
 	 * compaction didn't start as it was not possible or direct reclaim
 	 * was more suitable
 	 */
 	COMPACT_SKIPPED,
+	/* compaction didn't start as it was deferred due to past failures */
+	COMPACT_DEFERRED,
+	/* compaction not active last round */
+	COMPACT_INACTIVE = COMPACT_DEFERRED,
+
 	/* compaction should continue to another pageblock */
 	COMPACT_CONTINUE,
 	/*
diff -puN include/trace/events/compaction.h~mm-compaction-distinguish-compact_deferred-from-compact_skipped include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-distinguish-compact_deferred-from-compact_skipped
+++ a/include/trace/events/compaction.h
@@ -10,8 +10,8 @@
 #include <trace/events/mmflags.h>
 
 #define COMPACTION_STATUS					\
-	EM( COMPACT_DEFERRED,		"deferred")		\
 	EM( COMPACT_SKIPPED,		"skipped")		\
+	EM( COMPACT_DEFERRED,		"deferred")		\
 	EM( COMPACT_CONTINUE,		"continue")		\
 	EM( COMPACT_PARTIAL,		"partial")		\
 	EM( COMPACT_COMPLETE,		"complete")		\
diff -puN mm/compaction.c~mm-compaction-distinguish-compact_deferred-from-compact_skipped mm/compaction.c
--- a/mm/compaction.c~mm-compaction-distinguish-compact_deferred-from-compact_skipped
+++ a/mm/compaction.c
@@ -1578,7 +1578,7 @@ enum compact_result try_to_compact_pages
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
 	struct zone *zone;
-	enum compact_result rc = COMPACT_DEFERRED;
+	enum compact_result rc = COMPACT_SKIPPED;
 	int all_zones_contended = COMPACT_CONTENDED_LOCK; /* init for &= op */
 
 	*contended = COMPACT_CONTENDED_NONE;
@@ -1595,8 +1595,10 @@ enum compact_result try_to_compact_pages
 		enum compact_result status;
 		int zone_contended;
 
-		if (compaction_deferred(zone, order))
+		if (compaction_deferred(zone, order)) {
+			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
+		}
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
 				&zone_contended, alloc_flags,
@@ -1667,7 +1669,7 @@ break_loop:
 	 * If at least one zone wasn't deferred or skipped, we report if all
 	 * zones that were tried were lock contended.
 	 */
-	if (rc > COMPACT_SKIPPED && all_zones_contended)
+	if (rc > COMPACT_INACTIVE && all_zones_contended)
 		*contended = COMPACT_CONTENDED_LOCK;
 
 	return rc;
_
