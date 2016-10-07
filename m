From: akpm@linux-foundation.org
Subject: [patch 018/127] mm, compaction: rename COMPACT_PARTIAL to
 COMPACT_SUCCESS
Date: Fri, 07 Oct 2016 16:57:41 -0700
Message-ID: <57f83675.9AjtY/AEiCVHlxKW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38871 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5m (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: rename COMPACT_PARTIAL to COMPACT_SUCCESS

COMPACT_PARTIAL has historically meant that compaction returned after
doing some work without fully compacting a zone.  It however didn't
distinguish if compaction terminated because it succeeded in creating the
requested high-order page.  This has changed recently and now we only
return COMPACT_PARTIAL when compaction thinks it succeeded, or the
high-order watermark check in compaction_suitable() passes and no
compaction needs to be done.

So at this point we can make the return value clearer by renaming it to
COMPACT_SUCCESS.  The next patch will remove some redundant tests for
success where compaction just returned COMPACT_SUCCESS.

Link: http://lkml.kernel.org/r/20160810091226.6709-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h        |    8 ++++----
 include/trace/events/compaction.h |    2 +-
 mm/compaction.c                   |   12 ++++++------
 mm/vmscan.c                       |    2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-rename-compact_partial-to-compact_success include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-rename-compact_partial-to-compact_success
+++ a/include/linux/compaction.h
@@ -49,10 +49,10 @@ enum compact_result {
 	COMPACT_CONTENDED,
 
 	/*
-	 * direct compaction partially compacted a zone and there might be
-	 * suitable pages
+	 * direct compaction terminated after concluding that the allocation
+	 * should now succeed
 	 */
-	COMPACT_PARTIAL,
+	COMPACT_SUCCESS,
 };
 
 struct alloc_context; /* in mm/internal.h */
@@ -88,7 +88,7 @@ static inline bool compaction_made_progr
 	 * that the compaction successfully isolated and migrated some
 	 * pageblocks.
 	 */
-	if (result == COMPACT_PARTIAL)
+	if (result == COMPACT_SUCCESS)
 		return true;
 
 	return false;
diff -puN include/trace/events/compaction.h~mm-compaction-rename-compact_partial-to-compact_success include/trace/events/compaction.h
--- a/include/trace/events/compaction.h~mm-compaction-rename-compact_partial-to-compact_success
+++ a/include/trace/events/compaction.h
@@ -13,7 +13,7 @@
 	EM( COMPACT_SKIPPED,		"skipped")		\
 	EM( COMPACT_DEFERRED,		"deferred")		\
 	EM( COMPACT_CONTINUE,		"continue")		\
-	EM( COMPACT_PARTIAL,		"partial")		\
+	EM( COMPACT_SUCCESS,		"success")		\
 	EM( COMPACT_PARTIAL_SKIPPED,	"partial_skipped")	\
 	EM( COMPACT_COMPLETE,		"complete")		\
 	EM( COMPACT_NO_SUITABLE_PAGE,	"no_suitable_page")	\
diff -puN mm/compaction.c~mm-compaction-rename-compact_partial-to-compact_success mm/compaction.c
--- a/mm/compaction.c~mm-compaction-rename-compact_partial-to-compact_success
+++ a/mm/compaction.c
@@ -1329,13 +1329,13 @@ static enum compact_result __compact_fin
 
 		/* Job done if page is free of the right migratetype */
 		if (!list_empty(&area->free_list[migratetype]))
-			return COMPACT_PARTIAL;
+			return COMPACT_SUCCESS;
 
 #ifdef CONFIG_CMA
 		/* MIGRATE_MOVABLE can fallback on MIGRATE_CMA */
 		if (migratetype == MIGRATE_MOVABLE &&
 			!list_empty(&area->free_list[MIGRATE_CMA]))
-			return COMPACT_PARTIAL;
+			return COMPACT_SUCCESS;
 #endif
 		/*
 		 * Job done if allocation would steal freepages from
@@ -1343,7 +1343,7 @@ static enum compact_result __compact_fin
 		 */
 		if (find_suitable_fallback(area, order, migratetype,
 						true, &can_steal) != -1)
-			return COMPACT_PARTIAL;
+			return COMPACT_SUCCESS;
 	}
 
 	return COMPACT_NO_SUITABLE_PAGE;
@@ -1367,7 +1367,7 @@ static enum compact_result compact_finis
  * compaction_suitable: Is this suitable to run compaction on this zone now?
  * Returns
  *   COMPACT_SKIPPED  - If there are too few free pages for compaction
- *   COMPACT_PARTIAL  - If the allocation would succeed without compaction
+ *   COMPACT_SUCCESS  - If the allocation would succeed without compaction
  *   COMPACT_CONTINUE - If compaction should run now
  */
 static enum compact_result __compaction_suitable(struct zone *zone, int order,
@@ -1388,7 +1388,7 @@ static enum compact_result __compaction_
 	 */
 	if (zone_watermark_ok(zone, order, watermark, classzone_idx,
 								alloc_flags))
-		return COMPACT_PARTIAL;
+		return COMPACT_SUCCESS;
 
 	/*
 	 * Watermarks for order-0 must be met for compaction. Note the 2UL.
@@ -1477,7 +1477,7 @@ static enum compact_result compact_zone(
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
 	/* Compaction is likely to fail */
-	if (ret == COMPACT_PARTIAL || ret == COMPACT_SKIPPED)
+	if (ret == COMPACT_SUCCESS || ret == COMPACT_SKIPPED)
 		return ret;
 
 	/* huh, compaction_suitable is returning something unexpected */
diff -puN mm/vmscan.c~mm-compaction-rename-compact_partial-to-compact_success mm/vmscan.c
--- a/mm/vmscan.c~mm-compaction-rename-compact_partial-to-compact_success
+++ a/mm/vmscan.c
@@ -2495,7 +2495,7 @@ static inline bool should_continue_recla
 			continue;
 
 		switch (compaction_suitable(zone, sc->order, 0, sc->reclaim_idx)) {
-		case COMPACT_PARTIAL:
+		case COMPACT_SUCCESS:
 		case COMPACT_CONTINUE:
 			return false;
 		default:
_
