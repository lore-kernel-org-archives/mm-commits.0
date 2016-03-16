From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:16 -0700
Message-ID: <56e9ba9c.jQ8OKxxO648q3k+C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39115 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934390AbcCPT5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aaron.lu@intel.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: pass only pageblock aligned range to pageblock_pfn_to_page
has been removed from the -mm tree.  Its filename was
     mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/compaction: pass only pageblock aligned range to pageblock_pfn_to_page

pageblock_pfn_to_page() is used to check there is valid pfn and all pages
in the pageblock is in a single zone.  If there is a hole in the
pageblock, passing arbitrary position to pageblock_pfn_to_page() could
cause to skip whole pageblock scanning, instead of just skipping the hole
page.  For deterministic behaviour, it's better to always pass pageblock
aligned range to pageblock_pfn_to_page().  It will also help further
optimization on pageblock_pfn_to_page() in the following patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff -puN mm/compaction.c~mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page mm/compaction.c
--- a/mm/compaction.c~mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page
+++ a/mm/compaction.c
@@ -555,13 +555,17 @@ unsigned long
 isolate_freepages_range(struct compact_control *cc,
 			unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned long isolated, pfn, block_end_pfn;
+	unsigned long isolated, pfn, block_start_pfn, block_end_pfn;
 	LIST_HEAD(freelist);
 
 	pfn = start_pfn;
+	block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
+	if (block_start_pfn < cc->zone->zone_start_pfn)
+		block_start_pfn = cc->zone->zone_start_pfn;
 	block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 
 	for (; pfn < end_pfn; pfn += isolated,
+				block_start_pfn = block_end_pfn,
 				block_end_pfn += pageblock_nr_pages) {
 		/* Protect pfn from changing by isolate_freepages_block */
 		unsigned long isolate_start_pfn = pfn;
@@ -574,11 +578,13 @@ isolate_freepages_range(struct compact_c
 		 * scanning range to right one.
 		 */
 		if (pfn >= block_end_pfn) {
+			block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
 			block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 			block_end_pfn = min(block_end_pfn, end_pfn);
 		}
 
-		if (!pageblock_pfn_to_page(pfn, block_end_pfn, cc->zone))
+		if (!pageblock_pfn_to_page(block_start_pfn,
+					block_end_pfn, cc->zone))
 			break;
 
 		isolated = isolate_freepages_block(cc, &isolate_start_pfn,
@@ -864,18 +870,23 @@ unsigned long
 isolate_migratepages_range(struct compact_control *cc, unsigned long start_pfn,
 							unsigned long end_pfn)
 {
-	unsigned long pfn, block_end_pfn;
+	unsigned long pfn, block_start_pfn, block_end_pfn;
 
 	/* Scan block by block. First and last block may be incomplete */
 	pfn = start_pfn;
+	block_start_pfn = pfn & ~(pageblock_nr_pages - 1);
+	if (block_start_pfn < cc->zone->zone_start_pfn)
+		block_start_pfn = cc->zone->zone_start_pfn;
 	block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
 
 	for (; pfn < end_pfn; pfn = block_end_pfn,
+				block_start_pfn = block_end_pfn,
 				block_end_pfn += pageblock_nr_pages) {
 
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
-		if (!pageblock_pfn_to_page(pfn, block_end_pfn, cc->zone))
+		if (!pageblock_pfn_to_page(block_start_pfn,
+					block_end_pfn, cc->zone))
 			continue;
 
 		pfn = isolate_migratepages_block(cc, pfn, block_end_pfn,
@@ -1104,7 +1115,9 @@ int sysctl_compact_unevictable_allowed _
 static isolate_migrate_t isolate_migratepages(struct zone *zone,
 					struct compact_control *cc)
 {
-	unsigned long low_pfn, end_pfn;
+	unsigned long block_start_pfn;
+	unsigned long block_end_pfn;
+	unsigned long low_pfn;
 	unsigned long isolate_start_pfn;
 	struct page *page;
 	const isolate_mode_t isolate_mode =
@@ -1116,16 +1129,21 @@ static isolate_migrate_t isolate_migrate
 	 * initialized by compact_zone()
 	 */
 	low_pfn = cc->migrate_pfn;
+	block_start_pfn = cc->migrate_pfn & ~(pageblock_nr_pages - 1);
+	if (block_start_pfn < zone->zone_start_pfn)
+		block_start_pfn = zone->zone_start_pfn;
 
 	/* Only scan within a pageblock boundary */
-	end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
+	block_end_pfn = ALIGN(low_pfn + 1, pageblock_nr_pages);
 
 	/*
 	 * Iterate over whole pageblocks until we find the first suitable.
 	 * Do not cross the free scanner.
 	 */
-	for (; end_pfn <= cc->free_pfn;
-			low_pfn = end_pfn, end_pfn += pageblock_nr_pages) {
+	for (; block_end_pfn <= cc->free_pfn;
+			low_pfn = block_end_pfn,
+			block_start_pfn = block_end_pfn,
+			block_end_pfn += pageblock_nr_pages) {
 
 		/*
 		 * This can potentially iterate a massively long zone with
@@ -1136,7 +1154,8 @@ static isolate_migrate_t isolate_migrate
 						&& compact_should_abort(cc))
 			break;
 
-		page = pageblock_pfn_to_page(low_pfn, end_pfn, zone);
+		page = pageblock_pfn_to_page(block_start_pfn, block_end_pfn,
+									zone);
 		if (!page)
 			continue;
 
@@ -1155,8 +1174,8 @@ static isolate_migrate_t isolate_migrate
 
 		/* Perform the isolation */
 		isolate_start_pfn = low_pfn;
-		low_pfn = isolate_migratepages_block(cc, low_pfn, end_pfn,
-								isolate_mode);
+		low_pfn = isolate_migratepages_block(cc, low_pfn,
+						block_end_pfn, isolate_mode);
 
 		if (!low_pfn || cc->contended) {
 			acct_isolated(zone, cc);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

