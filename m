From: akpm@linux-foundation.org
Subject: + mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch added to -mm tree
Date: Tue, 11 Sep 2012 16:35:20 -0700
Message-ID: <20120911233520.BC4781E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:54382 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2IKXfW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 19:35:22 -0400
Received: by vcqp1 with SMTP id p1so125760vcq.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 16:35:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shli@kernel.org, aarcange@redhat.com, mgorman@suse.de, minchan@kernel.org, shli@fusionio.com


The patch titled
     Subject: mm: compaction: abort compaction loop if lock is contended or run too long
has been added to the -mm tree.  Its filename is
     mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: mm: compaction: abort compaction loop if lock is contended or run too long

isolate_migratepages_range() might isolate no pages, for example, when
zone->lru_lock is contended and compaction is async.  In this case, we
should abort compaction, otherwise, compact_zone will run a useless loop
and make zone->lru_lock is even contended.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Shaohua Li <shli@fusionio.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   12 +++++++-----
 mm/internal.h   |    2 +-
 2 files changed, 8 insertions(+), 6 deletions(-)

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
@@ -896,6 +895,7 @@ static unsigned long compact_zone_order(
 				 bool sync, bool *contended,
 				 struct page **page)
 {
+	unsigned long ret;
 	struct compact_control cc = {
 		.nr_freepages = 0,
 		.nr_migratepages = 0,
@@ -903,13 +903,15 @@ static unsigned long compact_zone_order(
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
+	if (contended)
+		*contended = cc.contended;
+	return ret;
 }
 
 int sysctl_extfrag_threshold = 500;
diff -puN mm/internal.h~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long mm/internal.h
--- a/mm/internal.h~mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long
+++ a/mm/internal.h
@@ -131,7 +131,7 @@ struct compact_control {
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
 	struct zone *zone;
-	bool *contended;		/* True if a lock was contended */
+	bool contended;			/* True if a lock was contended */
 	struct page **page;		/* Page captured of requested size */
 };
 
_

Patches currently in -mm which might be from shli@kernel.org are

linux-next.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch

