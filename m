From: akpm@linux-foundation.org
Subject: +
 mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch added to -mm tree
Date: Thu, 04 Feb 2016 12:51:05 -0800
Message-ID: <56b3b9b9.YKExnXfx7S8yVaU/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbcBDUvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Feb 2016 15:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, aaron.lu@intel.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, riel@redhat.com, rientjes@google.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: pass only pageblock aligned range to pageblock_pfn_to_page
has been added to the -mm tree.  Its filename is
     mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
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
Cc: Vlastimil Babka <vbabka@suse.cz>
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

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch
mm-compaction-fix-invalid-free_pfn-and-compact_cached_free_pfn.patch
mm-compaction-pass-only-pageblock-aligned-range-to-pageblock_pfn_to_page.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous.patch

