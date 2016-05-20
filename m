From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:04:44 -0700
Message-ID: <573f7bec.XJkBOCAXbinaa4OX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbcETVEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hughd@google.com, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: wrap calculating first and last pfn of pageblock
has been removed from the -mm tree.  Its filename was
     mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: wrap calculating first and last pfn of pageblock

Compaction code has accumulated numerous instances of manual calculations
of the first (inclusive) and last (exclusive) pfn of a pageblock (or a
smaller block of given order), given a pfn within the pageblock.  Wrap
these calculations by introducing pageblock_start_pfn(pfn) and
pageblock_end_pfn(pfn) macros.

[vbabka@suse.cz: fix crash in get_pfnblock_flags_mask() from isolate_freepages():]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff -puN mm/compaction.c~mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock mm/compaction.c
--- a/mm/compaction.c~mm-compaction-wrap-calculating-first-and-last-pfn-of-pageblock
+++ a/mm/compaction.c
@@ -42,6 +42,11 @@ static inline void count_compact_events(
 #define CREATE_TRACE_POINTS
 #include <trace/events/compaction.h>
 
+#define block_start_pfn(pfn, order)	round_down(pfn, 1UL << (order))
+#define block_end_pfn(pfn, order)	ALIGN((pfn) + 1, 1UL << (order))
+#define pageblock_start_pfn(pfn)	block_start_pfn(pfn, pageblock_order)
+#define pageblock_end_pfn(pfn)		block_end_pfn(pfn, pageblock_order)
+
 static unsigned long release_freepages(struct list_head *freelist)
 {
 	struct page *page, *next;
@@ -161,7 +166,7 @@ static void reset_cached_positions(struc
 	zone->compact_cached_migrate_pfn[0] = zone->zone_start_pfn;
 	zone->compact_cached_migrate_pfn[1] = zone->zone_start_pfn;
 	zone->compact_cached_free_pfn =
-			round_down(zone_end_pfn(zone) - 1, pageblock_nr_pages);
+				pageblock_start_pfn(zone_end_pfn(zone) - 1);
 }
 
 /*
@@ -519,10 +524,10 @@ isolate_freepages_range(struct compact_c
 	LIST_HEAD(freelist);
 
 	pfn = start_pfn;
-	block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
+	block_start_pfn = pageblock_start_pfn(pfn);
 	if (block_start_pfn < cc->zone->zone_start_pfn)
 		block_start_pfn = cc->zone->zone_start_pfn;
-	block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+	block_end_pfn = pageblock_end_pfn(pfn);
 
 	for (; pfn < end_pfn; pfn += isolated,
 				block_start_pfn = block_end_pfn,
@@ -538,8 +543,8 @@ isolate_freepages_range(struct compact_c
 		 * scanning range to right one.
 		 */
 		if (pfn >= block_end_pfn) {
-			block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
-			block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+			block_start_pfn = pageblock_start_pfn(pfn);
+			block_end_pfn = pageblock_end_pfn(pfn);
 			block_end_pfn = min(block_end_pfn, end_pfn);
 		}
 
@@ -834,10 +839,10 @@ isolate_migratepages_range(struct compac
 
 	/* Scan block by block. First and last block may be incomplete */
 	pfn = start_pfn;
-	block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
+	block_start_pfn = pageblock_start_pfn(pfn);
 	if (block_start_pfn < cc->zone->zone_start_pfn)
 		block_start_pfn = cc->zone->zone_start_pfn;
-	block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+	block_end_pfn = pageblock_end_pfn(pfn);
 
 	for (; pfn < end_pfn; pfn = block_end_pfn,
 				block_start_pfn = block_end_pfn,
@@ -924,10 +929,10 @@ static void isolate_freepages(struct com
 	 * is using.
 	 */
 	isolate_start_pfn = cc->free_pfn;
-	block_start_pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
+	block_start_pfn = pageblock_start_pfn(cc->free_pfn);
 	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
 						zone_end_pfn(zone));
-	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
+	low_pfn = pageblock_end_pfn(cc->migrate_pfn);
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
@@ -1081,12 +1086,12 @@ static isolate_migrate_t isolate_migrate
 	 * initialized by compact_zone()
 	 */
 	low_pfn = cc->migrate_pfn;
-	block_start_pfn = cc->migrate_pfn & ~(pageblock_nr_pages - 1);
+	block_start_pfn = pageblock_start_pfn(low_pfn);
 	if (block_start_pfn < zone->zone_start_pfn)
 		block_start_pfn = zone->zone_start_pfn;
 
 	/* Only scan within a pageblock boundary */
-	block_end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
+	block_end_pfn = pageblock_end_pfn(low_pfn);
 
 	/*
 	 * Iterate over whole pageblocks until we find the first suitable.
@@ -1343,7 +1348,7 @@ static int compact_zone(struct zone *zon
 	cc->migrate_pfn = zone->compact_cached_migrate_pfn[sync];
 	cc->free_pfn = zone->compact_cached_free_pfn;
 	if (cc->free_pfn < start_pfn || cc->free_pfn >= end_pfn) {
-		cc->free_pfn = round_down(end_pfn - 1, pageblock_nr_pages);
+		cc->free_pfn = pageblock_start_pfn(end_pfn - 1);
 		zone->compact_cached_free_pfn = cc->free_pfn;
 	}
 	if (cc->migrate_pfn < start_pfn || cc->migrate_pfn >= end_pfn) {
@@ -1411,7 +1416,7 @@ check_drain:
 		if (cc->order > 0 && cc->last_migrated_pfn) {
 			int cpu;
 			unsigned long current_block_start =
-				cc->migrate_pfn & ~((1UL << cc->order) - 1);
+				block_start_pfn(cc->migrate_pfn, cc->order);
 
 			if (cc->last_migrated_pfn < current_block_start) {
 				cpu = get_cpu();
@@ -1436,7 +1441,7 @@ out:
 		cc->nr_freepages = 0;
 		VM_BUG_ON(free_pfn == 0);
 		/* The cached pfn is always the first in a pageblock */
-		free_pfn &= ~(pageblock_nr_pages-1);
+		free_pfn = pageblock_start_pfn(free_pfn);
 		/*
 		 * Only go back, not forward. The cached pfn might have been
 		 * already reset to zone end in compact_finished()
_

Patches currently in -mm which might be from vbabka@suse.cz are


