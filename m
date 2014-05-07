From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
 removed from -mm tree
Date: Wed, 07 May 2014 12:05:07 -0700
Message-ID: <536a83e3.WI4n3CEInj5DzKoL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56136 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaEGTFR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sunghwan.yun@samsung.com, stable@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, minchan@kernel.org, mina86@mina86.com, mgorman@suse.de, iamjoonsoo.kim@lge.com, heesub.shin@samsung.com, d.j.shin@samsung.com, cl@linux.com, b.zolnierkie@samsung.com, vbabka@suse.cz

Subject: [merged] mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch removed from -mm tree
To: vbabka@suse.cz,b.zolnierkie@samsung.com,cl@linux.com,d.j.shin@samsung.com,heesub.shin@samsung.com,iamjoonsoo.kim@lge.com,mgorman@suse.de,mina86@mina86.com,minchan@kernel.org,n-horiguchi@ah.jp.nec.com,riel@redhat.com,stable@vger.kernel.org,sunghwan.yun@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:07 -0700


The patch titled
     Subject: mm/compaction: make isolate_freepages start at pageblock boundary
has been removed from the -mm tree.  Its filename was
     mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/compaction: make isolate_freepages start at pageblock boundary

The compaction freepage scanner implementation in isolate_freepages() starts
by taking the current cc->free_pfn value as the first pfn. In a for loop, it
scans from this first pfn to the end of the pageblock, and then subtracts
pageblock_nr_pages from the first pfn to obtain the first pfn for the next
for loop iteration.

This means that when cc->free_pfn starts at offset X rather than being aligned
on pageblock boundary, the scanner will start at offset X in all scanned
pageblock, ignoring potentially many free pages. Currently this can happen when

a) zone's end pfn is not pageblock aligned, or

b) through zone->compact_cached_free_pfn with CONFIG_HOLES_IN_ZONE
   enabled and a hole spanning the beginning of a pageblock

This patch fixes the problem by aligning the initial pfn in
isolate_freepages() to pageblock boundary.  This also permits replacing
the end-of-pageblock alignment within the for loop with a simple
pageblock_nr_pages increment.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Heesub Shin <heesub.shin@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Dongjun Shin <d.j.shin@samsung.com>
Cc: Sunghwan Yun <sunghwan.yun@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN mm/compaction.c~mm-compaction-make-isolate_freepages-start-at-pageblock-boundary mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-isolate_freepages-start-at-pageblock-boundary
+++ a/mm/compaction.c
@@ -671,16 +671,20 @@ static void isolate_freepages(struct zon
 				struct compact_control *cc)
 {
 	struct page *page;
-	unsigned long high_pfn, low_pfn, pfn, z_end_pfn, end_pfn;
+	unsigned long high_pfn, low_pfn, pfn, z_end_pfn;
 	int nr_freepages = cc->nr_freepages;
 	struct list_head *freelist = &cc->freepages;
 
 	/*
 	 * Initialise the free scanner. The starting point is where we last
-	 * scanned from (or the end of the zone if starting). The low point
-	 * is the end of the pageblock the migration scanner is using.
+	 * successfully isolated from, zone-cached value, or the end of the
+	 * zone when isolating for the first time. We need this aligned to
+	 * the pageblock boundary, because we do pfn -= pageblock_nr_pages
+	 * in the for loop.
+	 * The low boundary is the end of the pageblock the migration scanner
+	 * is using.
 	 */
-	pfn = cc->free_pfn;
+	pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
 	low_pfn = ALIGN(cc->migrate_pfn + 1, pageblock_nr_pages);
 
 	/*
@@ -700,6 +704,7 @@ static void isolate_freepages(struct zon
 	for (; pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
 					pfn -= pageblock_nr_pages) {
 		unsigned long isolated;
+		unsigned long end_pfn;
 
 		/*
 		 * This can iterate a massively long zone without finding any
@@ -734,13 +739,10 @@ static void isolate_freepages(struct zon
 		isolated = 0;
 
 		/*
-		 * As pfn may not start aligned, pfn+pageblock_nr_page
-		 * may cross a MAX_ORDER_NR_PAGES boundary and miss
-		 * a pfn_valid check. Ensure isolate_freepages_block()
-		 * only scans within a pageblock
+		 * Take care when isolating in last pageblock of a zone which
+		 * ends in the middle of a pageblock.
 		 */
-		end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
-		end_pfn = min(end_pfn, z_end_pfn);
+		end_pfn = min(pfn + pageblock_nr_pages, z_end_pfn);
 		isolated = isolate_freepages_block(cc, pfn, end_pfn,
 						   freelist, false);
 		nr_freepages += isolated;
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages-fix.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch

