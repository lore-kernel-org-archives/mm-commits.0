From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch removed from -mm tree
Date: Fri, 20 May 2016 14:06:22 -0700
Message-ID: <573f7c4e.bmQ0ZuyhZBZr8HQF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47311 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbcETVGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: avoid unnecessary zone lookups during pageblock operations
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: avoid unnecessary zone lookups during pageblock operations

Pageblocks have an associated bitmap to store migrate types and whether
the pageblock should be skipped during compaction.  The bitmap may be
associated with a memory section or a zone but the zone is looked up
unconditionally.  The compiler should optimise this away automatically so
this is a cosmetic patch only in many cases.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations
+++ a/mm/page_alloc.c
@@ -6767,23 +6767,23 @@ void *__init alloc_large_system_hash(con
 }
 
 /* Return a pointer to the bitmap storing bits affecting a block of pages */
-static inline unsigned long *get_pageblock_bitmap(struct zone *zone,
+static inline unsigned long *get_pageblock_bitmap(struct page *page,
 							unsigned long pfn)
 {
 #ifdef CONFIG_SPARSEMEM
 	return __pfn_to_section(pfn)->pageblock_flags;
 #else
-	return zone->pageblock_flags;
+	return page_zone(page)->pageblock_flags;
 #endif /* CONFIG_SPARSEMEM */
 }
 
-static inline int pfn_to_bitidx(struct zone *zone, unsigned long pfn)
+static inline int pfn_to_bitidx(struct page *page, unsigned long pfn)
 {
 #ifdef CONFIG_SPARSEMEM
 	pfn &= (PAGES_PER_SECTION-1);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #else
-	pfn = pfn - round_down(zone->zone_start_pfn, pageblock_nr_pages);
+	pfn = pfn - round_down(page_zone(page)->zone_start_pfn, pageblock_nr_pages);
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 #endif /* CONFIG_SPARSEMEM */
 }
@@ -6801,14 +6801,12 @@ unsigned long get_pfnblock_flags_mask(st
 					unsigned long end_bitidx,
 					unsigned long mask)
 {
-	struct zone *zone;
 	unsigned long *bitmap;
 	unsigned long bitidx, word_bitidx;
 	unsigned long word;
 
-	zone = page_zone(page);
-	bitmap = get_pageblock_bitmap(zone, pfn);
-	bitidx = pfn_to_bitidx(zone, pfn);
+	bitmap = get_pageblock_bitmap(page, pfn);
+	bitidx = pfn_to_bitidx(page, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
 	bitidx &= (BITS_PER_LONG-1);
 
@@ -6830,20 +6828,18 @@ void set_pfnblock_flags_mask(struct page
 					unsigned long end_bitidx,
 					unsigned long mask)
 {
-	struct zone *zone;
 	unsigned long *bitmap;
 	unsigned long bitidx, word_bitidx;
 	unsigned long old_word, word;
 
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 
-	zone = page_zone(page);
-	bitmap = get_pageblock_bitmap(zone, pfn);
-	bitidx = pfn_to_bitidx(zone, pfn);
+	bitmap = get_pageblock_bitmap(page, pfn);
+	bitidx = pfn_to_bitidx(page, pfn);
 	word_bitidx = bitidx / BITS_PER_LONG;
 	bitidx &= (BITS_PER_LONG-1);
 
-	VM_BUG_ON_PAGE(!zone_spans_pfn(zone, pfn), page);
+	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitidx += end_bitidx;
 	mask <<= (BITS_PER_LONG - bitidx - 1);
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


