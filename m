From: akpm@linux-foundation.org
Subject: [patch 006/114] mm, compaction: add migratetype to
 compact_control
Date: Mon, 08 May 2017 15:54:46 -0700
Message-ID: <20170508225446.VDzD0aLph%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45618 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751676AbdEHWys (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:54:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org, rientjes@google.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: add migratetype to compact_control

Preparation patch.  We are going to need migratetype at lower layers than
compact_zone() and compact_finished().

Link: http://lkml.kernel.org/r/20170307131545.28577-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   15 +++++++--------
 mm/internal.h   |    1 +
 2 files changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/compaction.c~mm-compaction-add-migratetype-to-compact_control mm/compaction.c
--- a/mm/compaction.c~mm-compaction-add-migratetype-to-compact_control
+++ a/mm/compaction.c
@@ -1279,10 +1279,11 @@ static inline bool is_via_compact_memory
 	return order == -1;
 }
 
-static enum compact_result __compact_finished(struct zone *zone, struct compact_control *cc,
-			    const int migratetype)
+static enum compact_result __compact_finished(struct zone *zone,
+						struct compact_control *cc)
 {
 	unsigned int order;
+	const int migratetype = cc->migratetype;
 
 	if (cc->contended || fatal_signal_pending(current))
 		return COMPACT_CONTENDED;
@@ -1338,12 +1339,11 @@ static enum compact_result __compact_fin
 }
 
 static enum compact_result compact_finished(struct zone *zone,
-			struct compact_control *cc,
-			const int migratetype)
+			struct compact_control *cc)
 {
 	int ret;
 
-	ret = __compact_finished(zone, cc, migratetype);
+	ret = __compact_finished(zone, cc);
 	trace_mm_compaction_finished(zone, cc->order, ret);
 	if (ret == COMPACT_NO_SUITABLE_PAGE)
 		ret = COMPACT_CONTINUE;
@@ -1476,9 +1476,9 @@ static enum compact_result compact_zone(
 	enum compact_result ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
-	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 
+	cc->migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
 	/* Compaction is likely to fail */
@@ -1528,8 +1528,7 @@ static enum compact_result compact_zone(
 
 	migrate_prep_local();
 
-	while ((ret = compact_finished(zone, cc, migratetype)) ==
-						COMPACT_CONTINUE) {
+	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
 		int err;
 
 		switch (isolate_migratepages(zone, cc)) {
diff -puN mm/internal.h~mm-compaction-add-migratetype-to-compact_control mm/internal.h
--- a/mm/internal.h~mm-compaction-add-migratetype-to-compact_control
+++ a/mm/internal.h
@@ -193,6 +193,7 @@ struct compact_control {
 	unsigned long last_migrated_pfn;/* Not yet flushed page being freed */
 	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	int order;			/* order a direct compactor needs */
+	int migratetype;		/* migratetype of direct compactor */
 	const unsigned int alloc_flags;	/* alloc flags of a direct compactor */
 	const int classzone_idx;	/* zone index of a direct compactor */
 	enum migrate_mode mode;		/* Async or sync migration mode */
_
