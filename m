From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:12:04 -0700
Message-ID: <20121009181205.569EB5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45285 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab2JISMH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:12:07 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so285662wib.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:12:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shli@kernel.org, aarcange@redhat.com, mgorman@suse.de, minchan@kernel.org, shli@fusionio.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: abort compaction loop if lock is contended or run too long
has been removed from the -mm tree.  Its filename was
     mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: compaction: abort compaction loop if lock is contended or run too long

isolate_migratepages_range() might isolate no pages if for example when
zone->lru_lock is contended and running asynchronous compaction. In this
case, we should abort compaction, otherwise, compact_zone will run a
useless loop and make zone->lru_lock is even contended.

An additional check is added to ensure that cc.migratepages and
cc.freepages get properly drained whan compaction is aborted.

[minchan@kernel.org: Putback pages isolated for migration if aborting]
[akpm@linux-foundation.org: compact_zone_order requires non-NULL arg contended]
[akpm@linux-foundation.org: make compact_zone_order() require non-NULL arg `contended']
[minchan@kernel.org: Putback pages isolated for migration if aborting]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   17 ++++++++++++-----
 mm/internal.h   |    2 +-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff -puN mm/compaction.c~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long mm/compaction.c
--- a/mm/compaction.c~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long
+++ a/mm/compaction.c
@@ -70,8 +70,7 @@ static bool compact_checklock_irqsave(sp
 
 		/* async aborts if taking too long or contended */
 		if (!cc->sync) {
-			if (cc->contended)
-				*cc->contended = true;
+			cc->contended = true;
 			return false;
 		}
 
@@ -688,7 +687,7 @@ static isolate_migrate_t isolate_migrate
 
 	/* Perform the isolation */
 	low_pfn = isolate_migratepages_range(zone, cc, low_pfn, end_pfn);
-	if (!low_pfn)
+	if (!low_pfn || cc->contended)
 		return ISOLATE_ABORT;
 
 	cc->migrate_pfn = low_pfn;
@@ -848,6 +847,8 @@ static int compact_zone(struct zone *zon
 		switch (isolate_migratepages(zone, cc)) {
 		case ISOLATE_ABORT:
 			ret = COMPACT_PARTIAL;
+			putback_lru_pages(&cc->migratepages);
+			cc->nr_migratepages = 0;
 			goto out;
 		case ISOLATE_NONE:
 			continue;
@@ -896,6 +897,7 @@ static unsigned long compact_zone_order(
 				 bool sync, bool *contended,
 				 struct page **page)
 {
+	unsigned long ret;
 	struct compact_control cc = {
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
@@ -903,13 +905,18 @@ static unsigned long compact_zone_order(
 		.migratetype = allocflags_to_migratetype(gfp_mask),
 		.zone = zone,
 		.sync = sync,
-		.contended = contended,
 		.page = page,
 	};
 	INIT_LIST_HEAD(&cc.freepages);
 	INIT_LIST_HEAD(&cc.migratepages);
 
-	return compact_zone(zone, &cc);
+	ret = compact_zone(zone, &cc);
+
+	VM_BUG_ON(!list_empty(&cc.freepages));
+	VM_BUG_ON(!list_empty(&cc.migratepages));
+
+	*contended = cc.contended;
+	return ret;
 }
 
 int sysctl_extfrag_threshold = 500;
diff -puN mm/internal.h~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long mm/internal.h
--- a/mm/internal.h~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long
+++ a/mm/internal.h
@@ -130,7 +130,7 @@ struct compact_control {
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
-	bool *contended;		/* True if a lock was contended */
+	bool contended;			/* True if a lock was contended */
 	struct page **page;		/* Page captured of requested size */
 };
 
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
linux-next.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

