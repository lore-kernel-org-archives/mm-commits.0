From: akpm@linux-foundation.org
Subject: + mm-compaction-fix-compiler-warning.patch added to -mm tree
Date: Wed, 14 Nov 2012 14:42:50 -0800
Message-ID: <20121114224251.3354220004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:54971 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178Ab2KNWmy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Nov 2012 17:42:54 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so71529lbo.1
        for <mm-commits@vger.kernel.org>; Wed, 14 Nov 2012 14:42:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thierry.reding@avionic-design.de, mgorman@suse.de, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: compaction: Fix compiler warning
has been added to the -mm tree.  Its filename is
     mm-compaction-fix-compiler-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Thierry Reding <thierry.reding@avionic-design.de>
Subject: mm: compaction: Fix compiler warning

compact_capture_page() is only used if compaction is enabled so it should
be moved into the corresponding #ifdef.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |  108 +++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 54 deletions(-)

diff -puN mm/compaction.c~mm-compaction-fix-compiler-warning mm/compaction.c
--- a/mm/compaction.c~mm-compaction-fix-compiler-warning
+++ a/mm/compaction.c
@@ -215,60 +215,6 @@ static bool suitable_migration_target(st
 	return false;
 }
 
-static void compact_capture_page(struct compact_control *cc)
-{
-	unsigned long flags;
-	int mtype, mtype_low, mtype_high;
-
-	if (!cc->page || *cc->page)
-		return;
-
-	/*
-	 * For MIGRATE_MOVABLE allocations we capture a suitable page ASAP
-	 * regardless of the migratetype of the freelist is is captured from.
-	 * This is fine because the order for a high-order MIGRATE_MOVABLE
-	 * allocation is typically at least a pageblock size and overall
-	 * fragmentation is not impaired. Other allocation types must
-	 * capture pages from their own migratelist because otherwise they
-	 * could pollute other pageblocks like MIGRATE_MOVABLE with
-	 * difficult to move pages and making fragmentation worse overall.
-	 */
-	if (cc->migratetype == MIGRATE_MOVABLE) {
-		mtype_low = 0;
-		mtype_high = MIGRATE_PCPTYPES;
-	} else {
-		mtype_low = cc->migratetype;
-		mtype_high = cc->migratetype + 1;
-	}
-
-	/* Speculatively examine the free lists without zone lock */
-	for (mtype = mtype_low; mtype < mtype_high; mtype++) {
-		int order;
-		for (order = cc->order; order < MAX_ORDER; order++) {
-			struct page *page;
-			struct free_area *area;
-			area = &(cc->zone->free_area[order]);
-			if (list_empty(&area->free_list[mtype]))
-				continue;
-
-			/* Take the lock and attempt capture of the page */
-			if (!compact_trylock_irqsave(&cc->zone->lock, &flags, cc))
-				return;
-			if (!list_empty(&area->free_list[mtype])) {
-				page = list_entry(area->free_list[mtype].next,
-							struct page, lru);
-				if (capture_free_page(page, cc->order, mtype)) {
-					spin_unlock_irqrestore(&cc->zone->lock,
-									flags);
-					*cc->page = page;
-					return;
-				}
-			}
-			spin_unlock_irqrestore(&cc->zone->lock, flags);
-		}
-	}
-}
-
 /*
  * Isolate free pages onto a private freelist. Caller must hold zone->lock.
  * If @strict is true, will abort returning 0 on any invalid PFNs or non-free
@@ -945,6 +891,60 @@ unsigned long compaction_suitable(struct
 	return COMPACT_CONTINUE;
 }
 
+static void compact_capture_page(struct compact_control *cc)
+{
+	unsigned long flags;
+	int mtype, mtype_low, mtype_high;
+
+	if (!cc->page || *cc->page)
+		return;
+
+	/*
+	 * For MIGRATE_MOVABLE allocations we capture a suitable page ASAP
+	 * regardless of the migratetype of the freelist is is captured from.
+	 * This is fine because the order for a high-order MIGRATE_MOVABLE
+	 * allocation is typically at least a pageblock size and overall
+	 * fragmentation is not impaired. Other allocation types must
+	 * capture pages from their own migratelist because otherwise they
+	 * could pollute other pageblocks like MIGRATE_MOVABLE with
+	 * difficult to move pages and making fragmentation worse overall.
+	 */
+	if (cc->migratetype == MIGRATE_MOVABLE) {
+		mtype_low = 0;
+		mtype_high = MIGRATE_PCPTYPES;
+	} else {
+		mtype_low = cc->migratetype;
+		mtype_high = cc->migratetype + 1;
+	}
+
+	/* Speculatively examine the free lists without zone lock */
+	for (mtype = mtype_low; mtype < mtype_high; mtype++) {
+		int order;
+		for (order = cc->order; order < MAX_ORDER; order++) {
+			struct page *page;
+			struct free_area *area;
+			area = &(cc->zone->free_area[order]);
+			if (list_empty(&area->free_list[mtype]))
+				continue;
+
+			/* Take the lock and attempt capture of the page */
+			if (!compact_trylock_irqsave(&cc->zone->lock, &flags, cc))
+				return;
+			if (!list_empty(&area->free_list[mtype])) {
+				page = list_entry(area->free_list[mtype].next,
+							struct page, lru);
+				if (capture_free_page(page, cc->order, mtype)) {
+					spin_unlock_irqrestore(&cc->zone->lock,
+									flags);
+					*cc->page = page;
+					return;
+				}
+			}
+			spin_unlock_irqrestore(&cc->zone->lock, flags);
+		}
+	}
+}
+
 static int compact_zone(struct zone *zone, struct compact_control *cc)
 {
 	int ret;
_

Patches currently in -mm which might be from thierry.reding@avionic-design.de are

linux-next.patch
mm-compaction-fix-compiler-warning.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch

