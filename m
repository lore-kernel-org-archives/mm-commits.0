From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:48:44 -0800
Message-ID: <20130225204844.ADFC95A41B6@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:40599 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab3BYUsp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:48:45 -0500
Received: by mail-qa0-f73.google.com with SMTP id g10so361231qah.2
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:48:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: do not accidentally skip pageblocks in the migrate scanner
has been removed from the -mm tree.  Its filename was
     mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: do not accidentally skip pageblocks in the migrate scanner

Compaction uses the ALIGN macro incorrectly with the migrate scanner by
adding pageblock_nr_pages to a PFN.  It happened to work when initially
implemented as the starting PFN was also aligned but with caching restarts
and isolating in smaller chunks this is no longer always true.

The impact is that the migrate scanner scans outside its current
pageblock.  As pfn_valid() is still checked properly it does not cause any
failure and the impact of the bug is that in some cases it will scan more
than necessary when it crosses a page boundary but by no more than
COMPACT_CLUSTER_MAX.  It is highly unlikely this is even measurable but
it's still wrong so this patch addresses the problem.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/compaction.c~mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-do-not-accidentally-skip-pageblocks-in-the-migrate-scanner
+++ a/mm/compaction.c
@@ -611,8 +611,7 @@ check_compact_cluster:
 		continue;
 
 next_pageblock:
-		low_pfn += pageblock_nr_pages;
-		low_pfn = ALIGN(low_pfn, pageblock_nr_pages) - 1;
+		low_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages) - 1;
 		last_pageblock_nr = pageblock_nr;
 	}
 
@@ -795,7 +794,7 @@ static isolate_migrate_t isolate_migrate
 	low_pfn = max(cc->migrate_pfn, zone->zone_start_pfn);
 
 	/* Only scan within a pageblock boundary */
-	end_pfn = ALIGN(low_pfn + pageblock_nr_pages, pageblock_nr_pages);
+	end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
 
 	/* Do not cross the free scanner or scan within a memory hole */
 	if (end_pfn > cc->free_pfn || !pfn_valid(low_pfn)) {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
linux-next.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-memmap_init_zone-performance-improvement.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

