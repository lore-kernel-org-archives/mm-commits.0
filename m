From: akpm@linux-foundation.org
Subject: + mm-compaction-ensure-that-the-compaction-free-scanner-does-not-move-to-the-next-zone.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:18 -0700
Message-ID: <201106150124.p5F1OZWW031957@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754416Ab1FOBZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com


The patch titled
     mm: compaction: ensure that the compaction free scanner does not move to the next zone
has been added to the -mm tree.  Its filename is
     mm-compaction-ensure-that-the-compaction-free-scanner-does-not-move-to-the-next-zone.patch

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
Subject: mm: compaction: ensure that the compaction free scanner does not move to the next zone
From: Mel Gorman <mgorman@suse.de>

Compaction works with two scanners, a migration and a free scanner.  When
the scanners crossover, migration within the zone is complete.  The
location of the scanner is recorded on each cycle to avoid excesive
scanning.

When a zone is small and mostly reserved, it's very easy for the migration
scanner to be close to the end of the zone.  Then the following situation
can occurs

  o migration scanner isolates some pages near the end of the zone
  o free scanner starts at the end of the zone but finds that the
    migration scanner is already there
  o free scanner gets reinitialised for the next cycle as
    cc->migrate_pfn + pageblock_nr_pages
    moving the free scanner into the next zone
  o migration scanner moves into the next zone

When this happens, NR_ISOLATED accounting goes haywire because some of the
accounting happens against the wrong zone.  One zones counter remains
positive while the other goes negative even though the overall global
count is accurate.  This was reported on X86-32 with !SMP because !SMP
allows the negative counters to be visible.  The fact that it is the bug
should theoritically be possible there.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-ensure-that-the-compaction-free-scanner-does-not-move-to-the-next-zone mm/compaction.c
--- a/mm/compaction.c~mm-compaction-ensure-that-the-compaction-free-scanner-does-not-move-to-the-next-zone
+++ a/mm/compaction.c
@@ -144,9 +144,20 @@ static void isolate_freepages(struct zon
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
+	/*
+	 * Initialise the free scanner. The starting point is where we last
+	 * scanned from (or the end of the zone if starting). The low point
+	 * is the end of the pageblock the migration scanner is using.
+	 */
 	pfn = cc->free_pfn;
 	low_pfn = cc->migrate_pfn + pageblock_nr_pages;
-	high_pfn = low_pfn;
+
+	/*
+	 * Take care that if the migration scanner is at the end of the zone
+	 * that the free scanner does not accidentally move to the next zone
+	 * in the next isolation cycle.
+	 */
+	high_pfn = min(low_pfn, pfn);
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-compaction-fix-special-case-1-order-checks.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
mm-compaction-ensure-that-the-compaction-free-scanner-does-not-move-to-the-next-zone.patch
mm-vmscan-do-not-use-page_count-without-a-page-pin.patch
mm-compaction-abort-compaction-if-too-many-pages-are-isolated-and-caller-is-asynchronous-v2.patch

