From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch removed from -mm tree
Date: Wed, 10 Dec 2014 15:15:58 -0800
Message-ID: <5488d42e.xpwC1Uhx9LOyn7hx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166AbaLJXP7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Dec 2014 18:15:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-more-focused-lru-and-pcplists-draining-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch

This patch was dropped because it was folded into mm-compaction-more-focused-lru-and-pcplists-draining.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-more-focused-lru-and-pcplists-draining-fix

As Joonsoo Kim pointed out, last_migrate_pfn was reset to 0 by mistake at
each iteration in compact_zone().  This mistake could result in fail to
recognize immediately draining points for orders smaller than pageblock. 
Joonsoo has also suggested an improvement to detecting cc->order aligned
block where migration might have occurred - before this fix, some of the
drain opportunities might have been missed.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN mm/compaction.c~mm-compaction-more-focused-lru-and-pcplists-draining-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-more-focused-lru-and-pcplists-draining-fix
+++ a/mm/compaction.c
@@ -1158,6 +1158,7 @@ static int compact_zone(struct zone *zon
 	unsigned long end_pfn = zone_end_pfn(zone);
 	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
+	unsigned long last_migrated_pfn = 0;
 
 	ret = compaction_suitable(zone, cc->order, cc->alloc_flags,
 							cc->classzone_idx);
@@ -1203,7 +1204,7 @@ static int compact_zone(struct zone *zon
 	while ((ret = compact_finished(zone, cc, migratetype)) ==
 						COMPACT_CONTINUE) {
 		int err;
-		unsigned long last_migrated_pfn = 0;
+		unsigned long isolate_start_pfn = cc->migrate_pfn;
 
 		switch (isolate_migratepages(zone, cc)) {
 		case ISOLATE_ABORT:
@@ -1244,21 +1245,22 @@ static int compact_zone(struct zone *zon
 		}
 
 		/*
-		 * Record where we have freed pages by migration and not yet
-		 * flushed them to buddy allocator. Subtract 1, because often
-		 * we finish a pageblock and migrate_pfn points to the first
-		 * page* of the next one. In that case we want the drain below
-		 * to happen immediately.
+		 * Record where we could have freed pages by migration and not
+		 * yet flushed them to buddy allocator. We use the pfn that
+		 * isolate_migratepages() started from in this loop iteration
+		 * - this is the lowest page that could have been isolated and
+		 * then freed by migration.
 		 */
 		if (!last_migrated_pfn)
-			last_migrated_pfn = cc->migrate_pfn - 1;
+			last_migrated_pfn = isolate_start_pfn;
 
 check_drain:
 		/*
-		 * Have we moved away from the previous cc->order aligned block
-		 * where we migrated from? If yes, flush the pages that were
-		 * freed, so that they can merge and compact_finished() can
-		 * detect immediately if allocation should succeed.
+		 * Has the migration scanner moved away from the previous
+		 * cc->order aligned block where we migrated from? If yes,
+		 * flush the pages that were freed, so that they can merge and
+		 * compact_finished() can detect immediately if allocation
+		 * would succeed.
 		 */
 		if (cc->order > 0 && last_migrated_pfn) {
 			int cpu;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-introduce-single-zone-pcplists-drain.patch
mm-page_isolation-drain-single-zone-pcplists.patch
mm-cma-drain-single-zone-pcplists.patch
mm-memory_hotplug-failure-drain-single-zone-pcplists.patch
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch

