From: akpm@linux-foundation.org
Subject: + mm-have-order-0-compaction-start-off-where-it-left-v3.patch added to -mm tree
Date: Wed, 11 Jul 2012 14:20:45 -0700
Message-ID: <20120711212046.2AD1120004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:55083 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387Ab2GKVUt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jul 2012 17:20:49 -0400
Received: by lbbgp10 with SMTP id gp10so102193lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jul 2012 14:20:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, jaschut@sandia.gov, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, minchan.kim@gmail.com


The patch titled
     Subject: mm: have order > 0 compaction start off where it left
has been added to the -mm tree.  Its filename is
     mm-have-order-0-compaction-start-off-where-it-left-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: have order > 0 compaction start off where it left

This patch makes the comment for cc->wrapped longer, explaining what is
really going on.  It also incorporates the comment fix pointed out by
Minchan.

Additionally, Minchan found that, when no pages get isolated, high_pte
could be a value that is much lower than desired, which might potentially
cause compaction to skip a range of pages.

Only assign zone->compact_cache_free_pfn if we actually isolated free
pages for compaction.

Split out the calculation to get the start of the last page block in a
zone into its own, commented function.

Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Jim Schutt <jaschut@sandia.gov>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 +-
 mm/compaction.c        |   30 ++++++++++++++++++++++--------
 mm/internal.h          |    6 +++++-
 3 files changed, 28 insertions(+), 10 deletions(-)

diff -puN include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left-v3 include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-have-order-0-compaction-start-off-where-it-left-v3
+++ a/include/linux/mmzone.h
@@ -368,7 +368,7 @@ struct zone {
 	spinlock_t		lock;
 	int                     all_unreclaimable; /* All pages pinned */
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
-	/* pfn where the last order > 0 compaction isolated free pages */
+	/* pfn where the last incremental compaction isolated free pages */
 	unsigned long		compact_cached_free_pfn;
 #endif
 #ifdef CONFIG_MEMORY_HOTPLUG
diff -puN mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3 mm/compaction.c
--- a/mm/compaction.c~mm-have-order-0-compaction-start-off-where-it-left-v3
+++ a/mm/compaction.c
@@ -472,10 +472,11 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated)
+		if (isolated) {
 			high_pfn = max(high_pfn, pfn);
-		if (cc->order > 0)
-			zone->compact_cached_free_pfn = high_pfn;
+			if (cc->order > 0)
+				zone->compact_cached_free_pfn = high_pfn;
+		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -569,6 +570,21 @@ static isolate_migrate_t isolate_migrate
 	return ISOLATE_SUCCESS;
 }
 
+/*
+ * Returns the start pfn of the laste page block in a zone.
+ * This is the starting point for full compaction of a zone.
+ * Compaction searches for free pages from the end of each zone,
+ * while isolate_freepages_block scans forward inside each page
+ * block.
+ */
+static unsigned long start_free_pfn(struct zone *zone)
+{
+	unsigned long free_pfn;
+	free_pfn = zone->zone_start_pfn + zone->spanned_pages;
+	free_pfn &= ~(pageblock_nr_pages-1);
+	return free_pfn;
+}
+
 static int compact_finished(struct zone *zone,
 			    struct compact_control *cc)
 {
@@ -587,10 +603,9 @@ static int compact_finished(struct zone 
 	if (cc->free_pfn <= cc->migrate_pfn) {
 		if (cc->order > 0 && !cc->wrapped) {
 			/* We started partway through; restart at the end. */
-			unsigned long free_pfn;
-			free_pfn = zone->zone_start_pfn + zone->spanned_pages;
-			free_pfn &= ~(pageblock_nr_pages-1);
+			unsigned long free_pfn = start_free_pfn(zone);
 			zone->compact_cached_free_pfn = free_pfn;
+			cc->free_pfn = free_pfn;
 			cc->wrapped = 1;
 			return COMPACT_CONTINUE;
 		}
@@ -703,8 +718,7 @@ static int compact_zone(struct zone *zon
 		cc->start_free_pfn = cc->free_pfn;
 	} else {
 		/* Order == -1 starts at the end of the zone. */
-		cc->free_pfn = cc->migrate_pfn + zone->spanned_pages;
-		cc->free_pfn &= ~(pageblock_nr_pages-1);
+		cc->free_pfn = start_free_pfn(zone);
 	}
 
 	migrate_prep_local();
diff -puN mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left-v3 mm/internal.h
--- a/mm/internal.h~mm-have-order-0-compaction-start-off-where-it-left-v3
+++ a/mm/internal.h
@@ -121,7 +121,11 @@ struct compact_control {
 	unsigned long start_free_pfn;	/* where we started the search */
 	unsigned long migrate_pfn;	/* isolate_migratepages search base */
 	bool sync;			/* Synchronous migration */
-	bool wrapped;			/* Last round for order>0 compaction */
+	bool wrapped;			/* Order > 0 compactions are
+					   incremental, once free_pfn
+					   and migrate_pfn meet, we restart
+					   from the top of the zone;
+					   remember we wrapped around. */
 
 	int order;			/* order a direct compactor needs */
 	int migratetype;		/* MOVABLE, RECLAIMABLE etc */
_
Subject: Subject: mm: have order > 0 compaction start off where it left

Patches currently in -mm which might be from riel@redhat.com are

mm-thp-abort-compaction-if-migration-page-cannot-be-charged-to-memcg.patch
linux-next.patch
swap-allow-swap-readahead-to-be-merged.patch
memcg-prevent-oom-with-too-many-dirty-pages.patch
mm-clear-pages_scanned-only-if-draining-a-pcp-adds-pages-to-the-buddy-allocator-again.patch
mm-remove-unused-lru_all_evictable.patch
mm-have-order-0-compaction-start-off-where-it-left.patch
mm-have-order-0-compaction-start-off-where-it-left-checkpatch-fixes.patch
mm-have-order-0-compaction-start-off-where-it-left-v3.patch
tmpfs-implement-numa-node-interleaving.patch
tmpfs-implement-numa-node-interleaving-fix.patch

