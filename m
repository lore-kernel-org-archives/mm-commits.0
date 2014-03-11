From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch removed from -mm tree
Date: Tue, 11 Mar 2014 11:25:03 -0700
Message-ID: <531f54ff.whUFfG4p+TqXsxxr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208AbaCKSZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:25:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, b.zolnierkie@samsung.com, lauraa@codeaurora.org

Subject: [merged] mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch removed from -mm tree
To: lauraa@codeaurora.org,b.zolnierkie@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,stable@vger.kernel.org,vbabka@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:25:03 -0700


The patch titled
     Subject: mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block
has been removed from the -mm tree.  Its filename was
     mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Laura Abbott <lauraa@codeaurora.org>
Subject: mm/compaction: break out of loop on !PageBuddy in isolate_freepages_block

We received several reports of bad page state when freeing CMA pages
previously allocated with alloc_contig_range:

[ 1258.084111] BUG: Bad page state in process Binder_A  pfn:63202
[ 1258.089763] page:d21130b0 count:0 mapcount:1 mapping:  (null) index:0x7dfbf
[ 1258.096109] page flags: 0x40080068(uptodate|lru|active|swapbacked)

Based on the page state, it looks like the page was still in use.  The
page flags do not make sense for the use case though.  Further debugging
showed that despite alloc_contig_range returning success, at least one
page in the range still remained in the buddy allocator.

There is an issue with isolate_freepages_block.  In strict mode (which CMA
uses), if any pages in the range cannot be isolated,
isolate_freepages_block should return failure 0.  The current check keeps
track of the total number of isolated pages and compares against the size
of the range:

        if (strict && nr_strict_required > total_isolated)
                total_isolated = 0;

After taking the zone lock, if one of the pages in the range is not in the
buddy allocator, we continue through the loop and do not increment
total_isolated.  If in the last iteration of the loop we isolate more than
one page (e.g.  last page needed is a higher order page), the check for
total_isolated may pass and we fail to detect that a page was skipped. 
The fix is to bail out if the loop immediately if we are in strict mode. 
There's no benfit to continuing anyway since we need all pages to be
isolated.  Additionally, drop the error checking based on
nr_strict_required and just check the pfn ranges.  This matches with what
isolate_freepages_range does.

Signed-off-by: Laura Abbott <lauraa@codeaurora.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff -puN mm/compaction.c~mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block mm/compaction.c
--- a/mm/compaction.c~mm-compaction-break-out-of-loop-on-pagebuddy-in-isolate_freepages_block
+++ a/mm/compaction.c
@@ -251,7 +251,6 @@ static unsigned long isolate_freepages_b
 {
 	int nr_scanned = 0, total_isolated = 0;
 	struct page *cursor, *valid_page = NULL;
-	unsigned long nr_strict_required = end_pfn - blockpfn;
 	unsigned long flags;
 	bool locked = false;
 
@@ -264,11 +263,12 @@ static unsigned long isolate_freepages_b
 
 		nr_scanned++;
 		if (!pfn_valid_within(blockpfn))
-			continue;
+			goto isolate_fail;
+
 		if (!valid_page)
 			valid_page = page;
 		if (!PageBuddy(page))
-			continue;
+			goto isolate_fail;
 
 		/*
 		 * The zone lock must be held to isolate freepages.
@@ -289,12 +289,10 @@ static unsigned long isolate_freepages_b
 
 		/* Recheck this is a buddy page under lock */
 		if (!PageBuddy(page))
-			continue;
+			goto isolate_fail;
 
 		/* Found a free page, break it into order-0 pages */
 		isolated = split_free_page(page);
-		if (!isolated && strict)
-			break;
 		total_isolated += isolated;
 		for (i = 0; i < isolated; i++) {
 			list_add(&page->lru, freelist);
@@ -305,7 +303,15 @@ static unsigned long isolate_freepages_b
 		if (isolated) {
 			blockpfn += isolated - 1;
 			cursor += isolated - 1;
+			continue;
 		}
+
+isolate_fail:
+		if (strict)
+			break;
+		else
+			continue;
+
 	}
 
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
@@ -315,7 +321,7 @@ static unsigned long isolate_freepages_b
 	 * pages requested were isolated. If there were any failures, 0 is
 	 * returned and CMA will fail.
 	 */
-	if (strict && nr_strict_required > total_isolated)
+	if (strict && blockpfn < end_pfn)
 		total_isolated = 0;
 
 	if (locked)
_

Patches currently in -mm which might be from lauraa@codeaurora.org are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

