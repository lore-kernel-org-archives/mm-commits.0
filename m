From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-make-compact_zone_order-static.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:11:19 -0700
Message-ID: <201111012111.pA1LBJAb030282@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1KAVLY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:11:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyungmin.park@samsung.com, minchan.kim@gmail.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: make compact_zone_order() static
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-compact_zone_order-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: mm: compaction: make compact_zone_order() static

There's no compact_zone_order() user outside file scope, so make it static.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    8 --------
 mm/compaction.c            |    2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-make-compact_zone_order-static include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-make-compact_zone_order-static
+++ a/include/linux/compaction.h
@@ -24,8 +24,6 @@ extern unsigned long try_to_compact_page
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
-extern unsigned long compact_zone_order(struct zone *zone, int order,
-					gfp_t gfp_mask, bool sync);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -69,12 +67,6 @@ static inline unsigned long compaction_s
 	return COMPACT_SKIPPED;
 }
 
-static inline unsigned long compact_zone_order(struct zone *zone, int order,
-					       gfp_t gfp_mask, bool sync)
-{
-	return COMPACT_CONTINUE;
-}
