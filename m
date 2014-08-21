From: akpm@linux-foundation.org
Subject: + mm-compaction-pass-gfp-mask-to-compact_control.patch added to
 -mm tree
Date: Thu, 21 Aug 2014 15:22:11 -0700
Message-ID: <53f67113.y1WOSBEGWB82pHlh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:59328 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471AbaHUWWM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 18:22:12 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2702717pab.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 15:22:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: pass gfp mask to compact_control
has been added to the -mm tree.  Its filename is
     mm-compaction-pass-gfp-mask-to-compact_control.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-pass-gfp-mask-to-compact_control.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-pass-gfp-mask-to-compact_control.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, compaction: pass gfp mask to compact_control

struct compact_control currently converts the gfp mask to a migratetype,
but we need the entire gfp mask in a follow-up patch.

Pass the entire gfp mask as part of struct compact_control.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   12 +++++++-----
 mm/internal.h   |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-pass-gfp-mask-to-compact_control mm/compaction.c
--- a/mm/compaction.c~mm-compaction-pass-gfp-mask-to-compact_control
+++ a/mm/compaction.c
@@ -1035,8 +1035,8 @@ static isolate_migrate_t isolate_migrate
 	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
 }
 
-static int compact_finished(struct zone *zone,
-			    struct compact_control *cc)
+static int compact_finished(struct zone *zone, struct compact_control *cc,
+			    const int migratetype)
 {
 	unsigned int order;
 	unsigned long watermark;
@@ -1082,7 +1082,7 @@ static int compact_finished(struct zone
 		struct free_area *area = &zone->free_area[order];
 
 		/* Job done if page is free of the right migratetype */
-		if (!list_empty(&area->free_list[cc->migratetype]))
+		if (!list_empty(&area->free_list[migratetype]))
 			return COMPACT_PARTIAL;
 
 		/* Job done if allocation would set block type */
@@ -1148,6 +1148,7 @@ static int compact_zone(struct zone *zon
 	int ret;
 	unsigned long start_pfn = zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(zone);
+	const int migratetype = gfpflags_to_migratetype(cc->gfp_mask);
 	const bool sync = cc->mode != MIGRATE_ASYNC;
 
 	ret = compaction_suitable(zone, cc->order);
@@ -1190,7 +1191,8 @@ static int compact_zone(struct zone *zon
 
 	migrate_prep_local();
 
-	while ((ret = compact_finished(zone, cc)) == COMPACT_CONTINUE) {
+	while ((ret = compact_finished(zone, cc, migratetype)) ==
+						COMPACT_CONTINUE) {
 		int err;
 
 		switch (isolate_migratepages(zone, cc)) {
@@ -1245,7 +1247,7 @@ static unsigned long compact_zone_order(
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
 		.order = order,
-		.migratetype = gfpflags_to_migratetype(gfp_mask),
+		.gfp_mask = gfp_mask,
 		.zone = zone,
 		.mode = mode,
 	};
diff -puN mm/internal.h~mm-compaction-pass-gfp-mask-to-compact_control mm/internal.h
--- a/mm/internal.h~mm-compaction-pass-gfp-mask-to-compact_control
+++ a/mm/internal.h
@@ -142,7 +142,7 @@ struct compact_control {
 	bool finished_update_migrate;
 
 	int order;			/* order a direct compactor needs */
-	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
+	const gfp_t gfp_mask;		/* gfp mask of a direct compactor */
 	struct zone *zone;
 	int contended;			/* Signal need_sched() or lock
 					 * contention detected during
_

Patches currently in -mm which might be from rientjes@google.com are

x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
memory-hotplug-add-sysfs-zones_online_to-attribute.patch
mm-page_alloc-determine-migratetype-only-once.patch
mm-thp-dont-hold-mmap_sem-in-khugepaged-when-allocating-thp.patch
mm-compaction-defer-each-zone-individually-instead-of-preferred-zone.patch
mm-compaction-do-not-count-compact_stall-if-all-zones-skipped-compaction.patch
mm-compaction-do-not-recheck-suitable_migration_target-under-lock.patch
mm-compaction-move-pageblock-checks-up-from-isolate_migratepages_range.patch
mm-compaction-reduce-zone-checking-frequency-in-the-migration-scanner.patch
mm-compaction-khugepaged-should-not-give-up-due-to-need_resched.patch
mm-compaction-periodically-drop-lock-and-restore-irqs-in-scanners.patch
mm-compaction-skip-rechecks-when-lock-was-already-held.patch
mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch
mm-compaction-skip-buddy-pages-by-their-order-in-the-migrate-scanner.patch
mm-rename-allocflags_to_migratetype-for-clarity.patch
mm-compaction-pass-gfp-mask-to-compact_control.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

