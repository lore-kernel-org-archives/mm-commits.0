From: akpm@linux-foundation.org
Subject: + mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages.patch added to -mm tree
Date: Mon, 20 Aug 2012 14:19:23 -0700
Message-ID: <20120820211924.4DE111E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-iy0-f202.google.com ([209.85.210.202]:38630 "EHLO
	mail-iy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2HTVTZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Aug 2012 17:19:25 -0400
Received: by ialo24 with SMTP id o24so927748ial.1
        for <mm-commits@vger.kernel.org>; Mon, 20 Aug 2012 14:19:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, minchan@kernel.org, riel@redhat.com


The patch titled
     Subject: mm: have order > 0 compaction start near a pageblock with free pages
has been added to the -mm tree.  Its filename is
     mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: have order > 0 compaction start near a pageblock with free pages

7db8889a ("mm: have order > 0 compaction start off where it left")
introduced a caching mechanism to reduce the amount work the free page
scanner does in compaction.  However, it has a problem.  Consider two
process simultaneously scanning free pages

				    			C
Process A		M     S     			F
		|---------------------------------------|
Process B		M 	FS

C is zone->compact_cached_free_pfn
S is cc->start_pfree_pfn
M is cc->migrate_pfn
F is cc->free_pfn

In this diagram, Process A has just reached its migrate scanner, wrapped
around and updated compact_cached_free_pfn accordingly.

Simultaneously, Process B finishes isolating in a block and updates
compact_cached_free_pfn again to the location of its free scanner.

Process A moves to "end_of_zone - one_pageblock" and runs this check

                if (cc->order > 0 && (!cc->wrapped ||
                                      zone->compact_cached_free_pfn >
                                      cc->start_free_pfn))
                        pfn = min(pfn, zone->compact_cached_free_pfn);

compact_cached_free_pfn is above where it started so the free scanner
skips almost the entire space it should have scanned.  When there are
multiple processes compacting it can end in a situation where the entire
zone is not being scanned at all.  Further, it is possible for two
processes to ping-pong update to compact_cached_free_pfn which is just
random.

Overall, the end result wrecks allocation success rates.

There is not an obvious way around this problem without introducing new
locking and state so this patch takes a different approach.

First, it gets rid of the skip logic because it's not clear that it
matters if two free scanners happen to be in the same block but with
racing updates it's too easy for it to skip over blocks it should not.

Second, it updates compact_cached_free_pfn in a more limited set of
circumstances.

If a scanner has wrapped, it updates compact_cached_free_pfn to the end
	of the zone. When a wrapped scanner isolates a page, it updates
	compact_cached_free_pfn to point to the highest pageblock it
	can isolate pages from.

If a scanner has not wrapped when it has finished isolated pages it
	checks if compact_cached_free_pfn is pointing to the end of the
	zone. If so, the value is updated to point to the highest
	pageblock that pages were isolated from. This value will not
	be updated again until a free page scanner wraps and resets
	compact_cached_free_pfn.

This is not optimal and it can still race but the compact_cached_free_pfn
will be pointing to or very near a pageblock with free pages.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   54 +++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff -puN mm/compaction.c~mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-near-a-pageblock-with-free-pages
+++ a/mm/compaction.c
@@ -437,6 +437,20 @@ static bool suitable_migration_target(st
 }
 
 /*
+ * Returns the start pfn of the last page block in a zone.  This is the starting
+ * point for full compaction of a zone.  Compaction searches for free pages from
+ * the end of each zone, while isolate_freepages_block scans forward inside each
+ * page block.
+ */
+static unsigned long start_free_pfn(struct zone *zone)
+{
+	unsigned long free_pfn;
+	free_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	free_pfn &= ~(pageblock_nr_pages-1);
+	return free_pfn;
+}
+
+/*
  * Based on information in the current compact_control, find blocks
  * suitable for isolating free pages from and then isolate them.
  */
@@ -475,17 +489,6 @@ static void isolate_freepages(struct zon
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
 
-		/*
-		 * Skip ahead if another thread is compacting in the area
-		 * simultaneously. If we wrapped around, we can only skip
-		 * ahead if zone->compact_cached_free_pfn also wrapped to
-		 * above our starting point.
-		 */
-		if (cc->order > 0 && (!cc->wrapped ||
-				      zone->compact_cached_free_pfn >
-				      cc->start_free_pfn))
-			pfn = min(pfn, zone->compact_cached_free_pfn);
-
 		if (!pfn_valid(pfn))
 			continue;
 
@@ -527,7 +530,15 @@ static void isolate_freepages(struct zon
 		 */
 		if (isolated) {
 			high_pfn = max(high_pfn, pfn);
-			if (cc->order > 0)
+
+			/*
+			 * If the free scanner has wrapped, update
+			 * compact_cached_free_pfn to point to the highest
+			 * pageblock with free pages. This reduces excessive
+			 * scanning of full pageblocks near the end of the
+			 * zone
+			 */
+			if (cc->order > 0 && cc->wrapped)
 				zone->compact_cached_free_pfn = high_pfn;
 		}
 	}
@@ -537,6 +548,11 @@ static void isolate_freepages(struct zon
 
 	cc->free_pfn = high_pfn;
 	cc->nr_freepages = nr_freepages;
+
+	/* If compact_cached_free_pfn is reset then set it now */
+	if (cc->order > 0 && !cc->wrapped &&
+			zone->compact_cached_free_pfn == start_free_pfn(zone))
+		zone->compact_cached_free_pfn = high_pfn;
 }
 
 /*
@@ -623,20 +639,6 @@ static isolate_migrate_t isolate_migrate
 	return ISOLATE_SUCCESS;
 }
 
-/*
- * Returns the start pfn of the last page block in a zone.  This is the starting
- * point for full compaction of a zone.  Compaction searches for free pages from
- * the end of each zone, while isolate_freepages_block scans forward inside each
- * page block.
- */
-static unsigned long start_free_pfn(struct zone *zone)
-{
-	unsigned long free_pfn;
-	free_pfn = zone->zone_start_pfn + zone->spanned_pages;
-	free_pfn &= ~(pageblock_nr_pages-1);
-	return free_pfn;
-}
