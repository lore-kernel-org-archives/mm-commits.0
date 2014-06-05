From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:51:55 -0700
Message-ID: <5390ca5b.MsOs1WD7Gr6ceE4E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaFETv4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:51:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: [merged] mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch removed from -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:51:55 -0700


The patch titled
     Subject: mm/compaction: avoid rescanning pageblocks in isolate_freepages
has been removed from the -mm tree.  Its filename was
     mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/compaction: avoid rescanning pageblocks in isolate_freepages

The compaction free scanner in isolate_freepages() currently remembers PFN
of the highest pageblock where it successfully isolates, to be used as the
starting pageblock for the next invocation.  The rationale behind this is
that page migration might return free pages to the allocator when
migration fails and we don't want to skip them if the compaction
continues.

Since migration now returns free pages back to compaction code where they
can be reused, this is no longer a concern.  This patch changes
isolate_freepages() so that the PFN for restarting is updated with each
pageblock where isolation is attempted.  Using stress-highalloc from
mmtests, this resulted in 10% reduction of the pages scanned by the free
scanner.

Note that the somewhat similar functionality that records highest
successful pageblock in zone->compact_cached_free_pfn, remains unchanged. 
This cache is used when the whole compaction is restarted, not for
multiple invocations of the free scanner during single compaction.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff -puN mm/compaction.c~mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages
+++ a/mm/compaction.c
@@ -688,7 +688,6 @@ static void isolate_freepages(struct zon
 	unsigned long block_start_pfn;	/* start of current pageblock */
 	unsigned long block_end_pfn;	/* end of current pageblock */
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
-	unsigned long next_free_pfn; /* start pfn for scaning at next round */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -709,12 +708,6 @@ static void isolate_freepages(struct zon
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * If no pages are isolated, the block_start_pfn < low_pfn check
-	 * will kick in.
-	 */
-	next_free_pfn = 0;
-
-	/*
 	 * Isolate free pages until enough are available to migrate the
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
@@ -754,19 +747,19 @@ static void isolate_freepages(struct zon
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
+		cc->free_pfn = block_start_pfn;
 		isolated = isolate_freepages_block(cc, block_start_pfn,
 					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
 
 		/*
-		 * Record the highest PFN we isolated pages from. When next
-		 * looking for free pages, the search will restart here as
-		 * page migration may have returned some pages to the allocator
+		 * Set a flag that we successfully isolated in this pageblock.
+		 * In the next loop iteration, zone->compact_cached_free_pfn
+		 * will not be updated and thus it will effectively contain the
+		 * highest pageblock we isolated pages from.
 		 */
-		if (isolated && next_free_pfn == 0) {
+		if (isolated)
 			cc->finished_update_free = true;
-			next_free_pfn = block_start_pfn;
-		}
 	}
 
 	/* split_free_page does not map the pages */
@@ -777,9 +770,8 @@ static void isolate_freepages(struct zon
 	 * so that compact_finished() may detect this
 	 */
 	if (block_start_pfn < low_pfn)
-		next_free_pfn = cc->migrate_pfn;
+		cc->free_pfn = cc->migrate_pfn;
 
-	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch

