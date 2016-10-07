From: akpm@linux-foundation.org
Subject: [patch 017/127] mm, compaction: cleanup unused functions
Date: Fri, 07 Oct 2016 16:57:38 -0700
Message-ID: <57f83672.4yIvoHf2/muNfDqw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38861 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751068AbcJGX5j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:57:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: cleanup unused functions

Since kswapd compaction moved to kcompactd, compact_pgdat() is not called
anymore, so we remove it.  The only caller of __compact_pgdat() is
compact_node(), so we merge them and remove code that was only reachable
from kswapd.

Link: http://lkml.kernel.org/r/20160810091226.6709-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compaction.h |    5 --
 mm/compaction.c            |   60 +++++++++--------------------------
 2 files changed, 17 insertions(+), 48 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-cleanup-unused-functions include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-cleanup-unused-functions
+++ a/include/linux/compaction.h
@@ -70,7 +70,6 @@ extern int fragmentation_index(struct zo
 extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 		unsigned int order, unsigned int alloc_flags,
 		const struct alloc_context *ac, enum compact_priority prio);
-extern void compact_pgdat(pg_data_t *pgdat, int order);
 extern void reset_isolation_suitable(pg_data_t *pgdat);
 extern enum compact_result compaction_suitable(struct zone *zone, int order,
 		unsigned int alloc_flags, int classzone_idx);
@@ -154,10 +153,6 @@ extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
 
 #else
-static inline void compact_pgdat(pg_data_t *pgdat, int order)
-{
-}
-
 static inline void reset_isolation_suitable(pg_data_t *pgdat)
 {
 }
diff -puN mm/compaction.c~mm-compaction-cleanup-unused-functions mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-unused-functions
+++ a/mm/compaction.c
@@ -1736,10 +1736,18 @@ enum compact_result try_to_compact_pages
 
 
 /* Compact all zones within a node */
-static void __compact_pgdat(pg_data_t *pgdat, struct compact_control *cc)
+static void compact_node(int nid)
 {
+	pg_data_t *pgdat = NODE_DATA(nid);
 	int zoneid;
 	struct zone *zone;
+	struct compact_control cc = {
+		.order = -1,
+		.mode = MIGRATE_SYNC,
+		.ignore_skip_hint = true,
+		.whole_zone = true,
+	};
+
 
 	for (zoneid = 0; zoneid < MAX_NR_ZONES; zoneid++) {
 
@@ -1747,53 +1755,19 @@ static void __compact_pgdat(pg_data_t *p
 		if (!populated_zone(zone))
 			continue;
 
-		cc->nr_freepages = 0;
-		cc->nr_migratepages = 0;
-		cc->zone = zone;
-		INIT_LIST_HEAD(&cc->freepages);
-		INIT_LIST_HEAD(&cc->migratepages);
-
-		if (is_via_compact_memory(cc->order) ||
-				!compaction_deferred(zone, cc->order))
-			compact_zone(zone, cc);
-
-		VM_BUG_ON(!list_empty(&cc->freepages));
-		VM_BUG_ON(!list_empty(&cc->migratepages));
+		cc.nr_freepages = 0;
+		cc.nr_migratepages = 0;
+		cc.zone = zone;
+		INIT_LIST_HEAD(&cc.freepages);
+		INIT_LIST_HEAD(&cc.migratepages);
 
-		if (is_via_compact_memory(cc->order))
-			continue;
+		compact_zone(zone, &cc);
 
-		if (zone_watermark_ok(zone, cc->order,
-				low_wmark_pages(zone), 0, 0))
-			compaction_defer_reset(zone, cc->order, false);
+		VM_BUG_ON(!list_empty(&cc.freepages));
+		VM_BUG_ON(!list_empty(&cc.migratepages));
 	}
 }
 
-void compact_pgdat(pg_data_t *pgdat, int order)
-{
-	struct compact_control cc = {
-		.order = order,
-		.mode = MIGRATE_ASYNC,
-	};
-
-	if (!order)
-		return;
-
-	__compact_pgdat(pgdat, &cc);
-}
-
-static void compact_node(int nid)
-{
-	struct compact_control cc = {
-		.order = -1,
-		.mode = MIGRATE_SYNC,
-		.ignore_skip_hint = true,
-		.whole_zone = true,
-	};
-
-	__compact_pgdat(NODE_DATA(nid), &cc);
-}
