From: akpm@linux-foundation.org
Subject: [merged] mm-compaction-cleanup-isolate_freepages.patch removed
 from -mm tree
Date: Thu, 05 Jun 2014 12:49:59 -0700
Message-ID: <5390c9e7.3y0fjUAU/hjFV1Yw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55934 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaFETuA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:50:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: [merged] mm-compaction-cleanup-isolate_freepages.patch removed from -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:49:59 -0700


The patch titled
     Subject: mm/compaction: cleanup isolate_freepages()
has been removed from the -mm tree.  Its filename was
     mm-compaction-cleanup-isolate_freepages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/compaction: cleanup isolate_freepages()

isolate_freepages() is currently somewhat hard to follow thanks to many
looks like it is related to the 'low_pfn' variable, but in fact it is not.

This patch renames the 'high_pfn' variable to a hopefully less confusing name,
and slightly changes its handling without a functional change. A comment made
obsolete by recent changes is also updated.

[akpm@linux-foundation.org: comment fixes, per Minchan]
[iamjoonsoo.kim@lge.com: cleanups]
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   56 ++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cleanup-isolate_freepages mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages
+++ a/mm/compaction.c
@@ -665,7 +665,10 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long high_pfn, low_pfn, pfn, z_end_pfn;
+	unsigned long block_start_pfn;	/* start of current pageblock */
+	unsigned long block_end_pfn;	/* end of current pageblock */
+	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
+	unsigned long next_free_pfn; /* start pfn for scaning at next round */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -673,32 +676,33 @@ static void isolate_freepages(struct zon
 	 * Initialise the free scanner. The starting point is where we last
 	 * successfully isolated from, zone-cached value, or the end of the
 	 * zone when isolating for the first time. We need this aligned to
-	 * the pageblock boundary, because we do pfn -= pageblock_nr_pages
-	 * in the for loop.
+	 * the pageblock boundary, because we do
+	 * block_start_pfn -= pageblock_nr_pages in the for loop.
+	 * For ending point, take care when isolating in last pageblock of a
+	 * a zone which ends in the middle of a pageblock.
 	 * The low boundary is the end of the pageblock the migration scanner
 	 * is using.
 	 */
-	pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
+	block_start_pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
+	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
+						zone_end_pfn(zone));
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
-	 * Take care that if the migration scanner is at the end of the zone
-	 * that the free scanner does not accidentally move to the next zone
-	 * in the next isolation cycle.
+	 * If no pages are isolated, the block_start_pfn < low_pfn check
+	 * will kick in.
 	 */
-	high_pfn = min(low_pfn, pfn);
-
-	z_end_pfn = zone_end_pfn(zone);
+	next_free_pfn = 0;
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
 	 * pages on cc->migratepages. We stop searching if the migrate
 	 * and free page scanners meet or enough free pages are isolated.
 	 */
-	for (; pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
-					pfn -= pageblock_nr_pages) {
+	for (; block_start_pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
+				block_end_pfn = block_start_pfn,
+				block_start_pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
-		unsigned long end_pfn;
 
 		/*
 		 * This can iterate a massively long zone without finding any
@@ -707,7 +711,7 @@ static void isolate_freepages(struct zon
 		 */
 		cond_resched();
 
-		if (!pfn_valid(pfn))
+		if (!pfn_valid(block_start_pfn))
 			continue;
 
 		/*
@@ -717,7 +721,7 @@ static void isolate_freepages(struct zon
 		 * i.e. it's possible that all pages within a zones range of
 		 * pages do not belong to a single zone.
 		 */
-		page = pfn_to_page(pfn);
+		page = pfn_to_page(block_start_pfn);
 		if (page_zone(page) != zone)
 			continue;
 
@@ -730,14 +734,8 @@ static void isolate_freepages(struct zon
 			continue;
 
 		/* Found a block suitable for isolating free pages from */
-
-		/*
-		 * Take care when isolating in last pageblock of a zone which
-		 * ends in the middle of a pageblock.
-		 */
-		end_pfn = min(pfn + pageblock_nr_pages, z_end_pfn);
-		isolated = isolate_freepages_block(cc, pfn, end_pfn,
-						   freelist, false);
+		isolated = isolate_freepages_block(cc, block_start_pfn,
+					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
 
 		/*
@@ -745,9 +743,9 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated) {
+		if (isolated && next_free_pfn == 0) {
 			cc->finished_update_free = true;
-			high_pfn = max(high_pfn, pfn);
+			next_free_pfn = block_start_pfn;
 		}
 	}
 
@@ -758,10 +756,10 @@ static void isolate_freepages(struct zon
 	 * If we crossed the migrate scanner, we want to keep it that way
 	 * so that compact_finished() may detect this
 	 */
-	if (pfn < low_pfn)
-		cc->free_pfn = max(pfn, zone->zone_start_pfn);
-	else
-		cc->free_pfn = high_pfn;
+	if (block_start_pfn < low_pfn)
+		next_free_pfn = cc->migrate_pfn;
+
+	cc->free_pfn = next_free_pfn;
 	cc->nr_freepages = nr_freepages;
 }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
linux-next.patch

