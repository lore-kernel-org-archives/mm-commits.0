From: akpm@linux-foundation.org
Subject: + mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch added to -mm tree
Date: Mon, 14 Nov 2011 15:21:04 -0800
Message-ID: <201111142321.pAENL4sw014701@wpaz24.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:33856 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab1KNXVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2011 18:21:08 -0500
Received: by faap16 with SMTP id p16so82901faa.1
        for <mm-commits@vger.kernel.org>; Mon, 14 Nov 2011 15:21:06 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de


The patch titled
     Subject: mm: reduce the amount of work done when updating min_free_kbytes
has been added to the -mm tree.  Its filename is
     mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch

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
From: Mel Gorman <mgorman@suse.de>
Subject: mm: reduce the amount of work done when updating min_free_kbytes

When min_free_kbytes is updated, some pageblocks are marked
MIGRATE_RESERVE.  Ordinarily, this work is unnoticable as it happens early
in boot but on large machines with 1TB of memory, this has been reported
to delay boot times, probably due to the NUMA distances involved.

The bulk of the work is due to calling calling pageblock_is_reserved() an
unnecessary amount of times and accessing far more struct page metadata
than is necessary.  This patch significantly reduces the amount of work
done by setup_zone_migrate_reserve() improving boot times on 1TB machines.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff -puN mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes
+++ a/mm/page_alloc.c
@@ -3457,25 +3457,28 @@ static void setup_zone_migrate_reserve(s
 		if (page_to_nid(page) != zone_to_nid(zone))
 			continue;
 
-		/* Blocks with reserved pages will never free, skip them. */
-		block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
-		if (pageblock_is_reserved(pfn, block_end_pfn))
-			continue;
-
 		block_migratetype = get_pageblock_migratetype(page);
 
-		/* If this block is reserved, account for it */
-		if (reserve > 0 && block_migratetype == MIGRATE_RESERVE) {
-			reserve--;
-			continue;
-		}
+		/* Only test what is necessary when the reserves are not met */
+		if (reserve > 0) {
+			/* Blocks with reserved pages will never free, skip them. */
+			block_end_pfn = min(pfn + pageblock_nr_pages, end_pfn);
+			if (pageblock_is_reserved(pfn, block_end_pfn))
+				continue;
 
-		/* Suitable for reserving if this block is movable */
-		if (reserve > 0 && block_migratetype == MIGRATE_MOVABLE) {
-			set_pageblock_migratetype(page, MIGRATE_RESERVE);
-			move_freepages_block(zone, page, MIGRATE_RESERVE);
-			reserve--;
-			continue;
+			/* If this block is reserved, account for it */
+			if (block_migratetype == MIGRATE_RESERVE) {
+				reserve--;
+				continue;
+			}
+
+			/* Suitable for reserving if this block is movable */
+			if (block_migratetype == MIGRATE_MOVABLE) {
+				set_pageblock_migratetype(page, MIGRATE_RESERVE);
+				move_freepages_block(zone, page, MIGRATE_RESERVE);
+				reserve--;
+				continue;
+			}
 		}
 
 		/*
_
Subject: Subject: mm: reduce the amount of work done when updating min_free_kbytes

Patches currently in -mm which might be from mgorman@suse.de are

mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
mm-avoid-livelock-on-__gfp_fs-allocations.patch
mm-avoid-livelock-on-__gfp_fs-allocations-fix.patch
mm-reduce-the-amount-of-work-done-when-updating-min_free_kbytes.patch

