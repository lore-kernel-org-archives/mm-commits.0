From: akpm@linux-foundation.org
Subject: + mm-compaction-abort-compaction-if-too-many-pages-are-isolated-and-caller-is-asynchronous-v2.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:19 -0700
Message-ID: <201106150124.p5F1OadZ031965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754293Ab1FOBZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, urykhy@gmail.com


The patch titled
     mm: compaction: abort compaction if too many pages are isolated and caller is asynchronous V2
has been added to the -mm tree.  Its filename is
     mm-compaction-abort-compaction-if-too-many-pages-are-isolated-and-caller-is-asynchronous-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: compaction: abort compaction if too many pages are isolated and caller is asynchronous V2
From: Mel Gorman <mgorman@suse.de>

Asynchronous compaction is used when promoting to huge pages.  This is all
very nice but if there are a number of processes in compacting memory, a
large number of pages can be isolated.  An "asynchronous" process can
stall for long periods of time as a result with a user reporting that
firefox can stall for 10s of seconds.  This patch aborts asynchronous
compaction if too many pages are isolated as it's better to fail a
hugepage promotion than stall a process.

[minchan.kim@gmail.com: return COMPACT_PARTIAL for abort]
Reported-and-tested-by: Ury Stankevich <urykhy@gmail.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <>
---

 mm/compaction.c |   29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff -puN mm/compaction.c~mm-compaction-abort-compaction-if-too-many-pages-are-isolated-and-caller-is-asynchronous-v2 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-abort-compaction-if-too-many-pages-are-isolated-and-caller-is-asynchronous-v2
+++ a/mm/compaction.c
@@ -251,11 +251,18 @@ static bool too_many_isolated(struct zon
 	return isolated > (inactive + active) / 2;
 }
 
+/* possible outcome of isolate_migratepages */
+typedef enum {
+	ISOLATE_ABORT,		/* Abort compaction now */
+	ISOLATE_NONE,		/* No pages isolated, continue scanning */
+	ISOLATE_SUCCESS,	/* Pages isolated, migrate */
+} isolate_migrate_t;
+
 /*
  * Isolate all pages that can be migrated from the block pointed to by
  * the migrate scanner within compact_control.
  */
-static unsigned long isolate_migratepages(struct zone *zone,
+static isolate_migrate_t isolate_migratepages(struct zone *zone,
 					struct compact_control *cc)
 {
 	unsigned long low_pfn, end_pfn;
@@ -272,7 +279,7 @@ static unsigned long isolate_migratepage
 	/* Do not cross the free scanner or scan within a memory hole */
 	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
 		cc->migrate_pfn = end_pfn;
-		return 0;
+		return ISOLATE_NONE;
 	}
 
 	/*
@@ -281,10 +288,14 @@ static unsigned long isolate_migratepage
 	 * delay for some time until fewer pages are isolated
 	 */
 	while (unlikely(too_many_isolated(zone))) {
+		/* async migration should just abort */
+		if (!cc->sync)
+			return ISOLATE_ABORT;
+
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
 
 		if (fatal_signal_pending(current))
-			return 0;
+			return ISOLATE_ABORT;
 	}
 
 	/* Time to isolate some pages for migration */
@@ -369,7 +380,7 @@ static unsigned long isolate_migratepage
 
 	trace_mm_compaction_isolate_migratepages(nr_scanned, nr_isolated);
 
-	return cc->nr_migratepages;
+	return ISOLATE_SUCCESS;
 }
 
 /*
@@ -535,8 +546,15 @@ static int compact_zone(struct zone *zon
 		unsigned long nr_migrate, nr_remaining;
 		int err;
 
-		if (!isolate_migratepages(zone, cc))
+		switch (isolate_migratepages(zone, cc)) {
+		case ISOLATE_ABORT:
+			ret = COMPACT_PARTIAL;
+			goto out;
+		case ISOLATE_NONE:
 			continue;
+		case ISOLATE_SUCCESS:
+			;
+		}
 
 		nr_migrate = cc->nr_migratepages;
 		err = migrate_pages(&cc->migratepages, compaction_alloc,
@@ -560,6 +578,7 @@ static int compact_zone(struct zone *zon
 
 	}
 
+out:
 	/* Release free pages and check accounting */
 	cc->nr_freepages -= release_freepages(&cc->freepages);
 	VM_BUG_ON(cc->nr_freepages != 0);
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-compaction-fix-special-case-1-order-checks.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
mm-compaction-ensure-that-the-compaction-free-scanner-does-not-move-to-the-next-zone.patch
mm-vmscan-do-not-use-page_count-without-a-page-pin.patch
mm-compaction-abort-compaction-if-too-many-pages-are-isolated-and-caller-is-asynchronous-v2.patch

