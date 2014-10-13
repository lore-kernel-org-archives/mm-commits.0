From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:45 -0700
Message-ID: <543c17c1.WWj1Kc0pEi7BcaJ7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaJMSTp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, cl@linux.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: remember position within pageblock in free pages scanner
has been removed from the -mm tree.  Its filename was
     mm-compaction-remember-position-within-pageblock-in-free-pages-scanner.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: remember position within pageblock in free pages scanner

Unlike the migration scanner, the free scanner remembers the beginning of
the last scanned pageblock in cc->free_pfn.  It might be therefore
rescanning pages uselessly when called several times during single
compaction.  This might have been useful when pages were returned to the
buddy allocator after a failed migration, but this is no longer the case.

This patch changes the meaning of cc->free_pfn so that if it points to a
middle of a pageblock, that pageblock is scanned only from cc->free_pfn to
the end.  isolate_freepages_block() will record the pfn of the last page
it looked at, which is then used to update cc->free_pfn.

In the mmtests stress-highalloc benchmark, this has resulted in lowering
the ratio between pages scanned by both scanners, from 2.5 free pages per
migrate page, to 2.25 free pages per migrate page, without affecting
success rates.

With __GFP_NO_KSWAPD allocations, this appears to result in a worse ratio
(2.1 instead of 1.8), but page migration successes increased by 10%, so
this could mean that more useful work can be done until need_resched()
aborts this kind of compaction.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN mm/compaction.c~mm-compaction-remember-position-within-pageblock-in-free-pages-scanner mm/compaction.c
--- a/mm/compaction.c~mm-compaction-remember-position-within-pageblock-in-free-pages-scanner
+++ a/mm/compaction.c
@@ -330,7 +330,7 @@ static bool suitable_migration_target(st
  * (even though it may still end up isolating some pages).
  */
 static unsigned long isolate_freepages_block(struct compact_control *cc,
-				unsigned long blockpfn,
+				unsigned long *start_pfn,
 				unsigned long end_pfn,
 				struct list_head *freelist,
 				bool strict)
@@ -339,6 +339,7 @@ static unsigned long isolate_freepages_b
 	struct page *cursor, *valid_page = NULL;
 	unsigned long flags;
 	bool locked = false;
+	unsigned long blockpfn = *start_pfn;
 
 	cursor = pfn_to_page(blockpfn);
 
@@ -415,6 +416,9 @@ isolate_fail:
 
 	}
 
+	/* Record how far we have got within the block */
+	*start_pfn = blockpfn;
+
 	trace_mm_compaction_isolate_freepages(nr_scanned, total_isolated);
 
 	/*
@@ -463,14 +467,16 @@ isolate_freepages_range(struct compact_c
 
 	for (; pfn < end_pfn; pfn += isolated,
 				block_end_pfn += pageblock_nr_pages) {
+		/* Protect pfn from changing by isolate_freepages_block */
+		unsigned long isolate_start_pfn = pfn;
 
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
 		if (!pageblock_pfn_to_page(pfn, block_end_pfn, cc->zone))
 			break;
 
-		isolated = isolate_freepages_block(cc, pfn, block_end_pfn,
-						   &freelist, true);
+		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
+						block_end_pfn, &freelist, true);
 
 		/*
 		 * In strict mode, isolate_freepages_block() returns 0 if
@@ -769,6 +775,7 @@ static void isolate_freepages(struct com
 	struct zone *zone = cc->zone;
 	struct page *page;
 	unsigned long block_start_pfn;	/* start of current pageblock */
+	unsigned long isolate_start_pfn; /* exact pfn we start at */
 	unsigned long block_end_pfn;	/* end of current pageblock */
 	unsigned long low_pfn;	     /* lowest pfn scanner is able to scan */
 	int nr_freepages = cc->nr_freepages;
@@ -777,14 +784,15 @@ static void isolate_freepages(struct com
 	/*
 	 * Initialise the free scanner. The starting point is where we last
 	 * successfully isolated from, zone-cached value, or the end of the
-	 * zone when isolating for the first time. We need this aligned to
-	 * the pageblock boundary, because we do
+	 * zone when isolating for the first time. For looping we also need
+	 * this pfn aligned down to the pageblock boundary, because we do
 	 * block_start_pfn -= pageblock_nr_pages in the for loop.
 	 * For ending point, take care when isolating in last pageblock of a
 	 * a zone which ends in the middle of a pageblock.
 	 * The low boundary is the end of the pageblock the migration scanner
 	 * is using.
 	 */
+	isolate_start_pfn = cc->free_pfn;
 	block_start_pfn = cc->free_pfn & ~(pageblock_nr_pages-1);
 	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
 						zone_end_pfn(zone));
@@ -797,7 +805,8 @@ static void isolate_freepages(struct com
 	 */
 	for (; block_start_pfn >= low_pfn && cc->nr_migratepages > nr_freepages;
 				block_end_pfn = block_start_pfn,
-				block_start_pfn -= pageblock_nr_pages) {
+				block_start_pfn -= pageblock_nr_pages,
+				isolate_start_pfn = block_start_pfn) {
 		unsigned long isolated;
 
 		/*
@@ -822,13 +831,25 @@ static void isolate_freepages(struct com
 		if (!isolation_suitable(cc, page))
 			continue;
 
-		/* Found a block suitable for isolating free pages from */
-		cc->free_pfn = block_start_pfn;
-		isolated = isolate_freepages_block(cc, block_start_pfn,
+		/* Found a block suitable for isolating free pages from. */
+		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
 					block_end_pfn, freelist, false);
 		nr_freepages += isolated;
 
 		/*
+		 * Remember where the free scanner should restart next time,
+		 * which is where isolate_freepages_block() left off.
+		 * But if it scanned the whole pageblock, isolate_start_pfn
+		 * now points at block_end_pfn, which is the start of the next
+		 * pageblock.
+		 * In that case we will however want to restart at the start
+		 * of the previous pageblock.
+		 */
+		cc->free_pfn = (isolate_start_pfn < block_end_pfn) ?
+				isolate_start_pfn :
+				block_start_pfn - pageblock_nr_pages;
+
+		/*
 		 * Set a flag that we successfully isolated in this pageblock.
 		 * In the next loop iteration, zone->compact_cached_free_pfn
 		 * will not be updated and thus it will effectively contain the
_

Patches currently in -mm which might be from vbabka@suse.cz are

origin.patch

