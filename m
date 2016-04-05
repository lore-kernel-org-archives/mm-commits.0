From: akpm@linux-foundation.org
Subject: +
 mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch added to -mm tree
Date: Tue, 05 Apr 2016 14:51:17 -0700
Message-ID: <57043355.1j6P0bbyvsjwXro6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760503AbcDEVvU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 17:51:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, hillf.zj@alibaba-inc.com, js1304@gmail.com, mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vbabka@suse.cz, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: distinguish COMPACT_DEFERRED from COMPACT_SKIPPED
has been added to the -mm tree.  Its filename is
     mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-distinguish-compact_deferred-from-compact_skipped.patch

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
Subject: mm, compaction: distinguish COMPACT_DEFERRED from COMPACT_SKIPPED

try_to_compact_pages can currently return COMPACT_SKIPPED even when the
compaction is defered for some zone just because zone DMA is skipped in
99% of cases due to watermark checks.  This makes COMPACT_DEFERRED
basically unusable for the page allocator as a feedback mechanism.

Make sure we distinguish those two states properly and switch their
ordering in the enum.  This would mean that the COMPACT_SKIPPED will be
returned only when all eligible zones are skipped.

This shouldn't introduce any functional change.

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
@@ -1632,7 +1632,7 @@ enum compact_result try_to_compact_pages
 	int may_perform_io = gfp_mask & __GFP_IO;
 	struct zoneref *z;
 	struct zone *zone;
-	enum compact_result rc = COMPACT_DEFERRED;
+	enum compact_result rc = COMPACT_SKIPPED;
 	int all_zones_contended = COMPACT_CONTENDED_LOCK; /* init for &= op */
 
 	*contended = COMPACT_CONTENDED_NONE;
@@ -1649,8 +1649,10 @@ enum compact_result try_to_compact_pages
 		enum compact_result status;
 		int zone_contended;
 
-		if (compaction_deferred(zone, order))
+		if (compaction_deferred(zone, order)) {
+			rc = max_t(enum compact_result, COMPACT_DEFERRED, rc);
 			continue;
+		}
 
 		status = compact_zone_order(zone, order, gfp_mask, mode,
 				&zone_contended, alloc_flags,
@@ -1721,7 +1723,7 @@ break_loop:
 	 * If at least one zone wasn't deferred or skipped, we report if all
 	 * zones that were tried were lock contended.
 	 */
-	if (rc > COMPACT_SKIPPED && all_zones_contended)
+	if (rc > COMPACT_INACTIVE && all_zones_contended)
 		*contended = COMPACT_CONTENDED_LOCK;
 
 	return rc;
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

