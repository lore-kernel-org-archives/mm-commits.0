From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-cleanup-isolate_freepages-fix3.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:25:19 -0700
Message-ID: <538f9ccf.dYLdUdtNRqvk2FPJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbaFDWZU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:25:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vbabka@suse.de, sunghwan.yun@samsung.com, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, iamjoonsoo.kim@lge.com

Subject: [folded-merged] mm-compaction-cleanup-isolate_freepages-fix3.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,sunghwan.yun@samsung.com,vbabka@suse.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:25:19 -0700


The patch titled
     Subject: mm-compaction-cleanup-isolate_freepages-fix3
has been removed from the -mm tree.  Its filename was
     mm-compaction-cleanup-isolate_freepages-fix3.patch

This patch was dropped because it was folded into mm-compaction-cleanup-isolate_freepages.patch

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm-compaction-cleanup-isolate_freepages-fix3

What I did here is taking end_pfn out of the loop and considering zone
boundary once.  After then, we can just set previous pfn to end_pfn on
every iteration to move scanning window.  With this change, we can remove
local variable, z_end_pfn.

Another things I did are removing max() operation and un-needed assignment
to isolate variable.

In addition, I change both the variable names, from pfn and end_pfn to
block_start_pfn and block_end_pfn, respectively.  They represent their
meaning perfectly.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.de>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   46 +++++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 25 deletions(-)

diff -puN mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix3 mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cleanup-isolate_freepages-fix3
+++ a/mm/compaction.c
@@ -662,10 +662,10 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long pfn;	     /* scanning cursor */
+	unsigned long block_start_pfn;	/* start of current pageblock */
+	unsigned long block_end_pfn;	/* end of current pageblock */
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
 	unsigned long next_free_pfn; /* start pfn for scaning at next round */
-	unsigned long z_end_pfn;     /* zone's end pfn */
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
@@ -673,31 +673,33 @@ static void isolate_freepages(struct zon
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
-	 * Seed the value for max(next_free_pfn, pfn) updates. If no pages are
-	 * isolated, the pfn < low_pfn check will kick in.
+	 * If no pages are isolated, the block_start_pfn < low_pfn check
+	 * will kick in.
 	 */
 	next_free_pfn = 0;
 
-	z_end_pfn = zone_end_pfn(zone);
-
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
@@ -706,7 +708,7 @@ static void isolate_freepages(struct zon
 		 */
 		cond_resched();
 
-		if (!pfn_valid(pfn))
+		if (!pfn_valid(block_start_pfn))
 			continue;
 
 		/*
@@ -716,7 +718,7 @@ static void isolate_freepages(struct zon
 		 * i.e. it's possible that all pages within a zones range of
 		 * pages do not belong to a single zone.
 		 */
-		page = pfn_to_page(pfn);
+		page = pfn_to_page(block_start_pfn);
 		if (page_zone(page) != zone)
 			continue;
 
@@ -729,14 +731,8 @@ static void isolate_freepages(struct zon
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
@@ -744,9 +740,9 @@ static void isolate_freepages(struct zon
 		 * looking for free pages, the search will restart here as
 		 * page migration may have returned some pages to the allocator
 		 */
-		if (isolated) {
+		if (isolated && next_free_pfn == 0) {
 			cc->finished_update_free = true;
-			next_free_pfn = max(next_free_pfn, pfn);
+			next_free_pfn = block_start_pfn;
 		}
 	}
 
@@ -757,7 +753,7 @@ static void isolate_freepages(struct zon
 	 * If we crossed the migrate scanner, we want to keep it that way
 	 * so that compact_finished() may detect this
 	 */
-	if (pfn < low_pfn)
+	if (block_start_pfn < low_pfn)
 		next_free_pfn = cc->migrate_pfn;
 
 	cc->free_pfn = next_free_pfn;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-compaction-embed-migration-mode-in-compact_control-fix-fix.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
zram-correct-offset-usage-in-zram_bio_discard.patch

