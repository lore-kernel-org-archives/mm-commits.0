From: akpm@linux-foundation.org
Subject: + mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
 added to -mm tree
Date: Wed, 19 Nov 2014 16:23:31 -0800
Message-ID: <546d3483.htfCH80iYPJDx8Rh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756442AbaKTAXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Nov 2014 19:23:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-more-focused-lru-and-pcplists-draining-fix
has been added to the -mm tree.  Its filename is
     mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-more-focused-lru-and-pcplists-draining-fix

As Joonsoo Kim pointed out, last_migrate_pfn was reset to 0 by mistake at
each iteration in compact_zone().  This mistake could result in fail to
recognize immediately draining points for orders smaller than pageblock. 
Joonsoo has also suggested an improvement to detecting cc->order aligned
block where migration might have occured - before this fix, some of the
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
mm-compaction-pass-classzone_idx-and-alloc_flags-to-watermark-checking-fix.patch
mm-compaction-simplify-deferred-compaction.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-compaction-defer-only-on-compact_complete.patch
mm-compaction-always-update-cached-scanner-positions.patch
mm-compaction-always-update-cached-scanner-positions-fix.patch
mm-compaction-always-update-cached-scanner-positions-fix-checkpatch-fixes.patch
mm-compaction-more-focused-lru-and-pcplists-draining.patch
mm-compaction-more-focused-lru-and-pcplists-draining-fix.patch
mm-debug-pagealloc-cleanup-page-guard-code.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value.patch
mm-page_alloc-store-updated-page-migratetype-to-avoid-misusing-stale-value-fix.patch

