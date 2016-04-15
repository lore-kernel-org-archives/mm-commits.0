From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch added to -mm tree
Date: Fri, 15 Apr 2016 16:11:59 -0700
Message-ID: <5711753f.xh5d877Dh/pSjqro%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbcDOXMA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: avoid unnecessary zone lookups during pageblock operations
has been added to the -mm tree.  Its filename is
     mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: avoid unnecessary zone lookups during pageblock operations

Pageblocks have an associated bitmap to store migrate types and whether
the pageblock should be skipped during compaction.  The bitmap may be
associated with a memory section or a zone but the zone is looked up
unconditionally.  The compiler should optimise this away automatically so
this is a cosmetic patch only in many cases.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations
+++ a/mm/page_alloc.c
@@ -6773,23 +6773,23 @@ void *__init alloc_large_system_hash(con
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
@@ -6807,14 +6807,12 @@ unsigned long get_pfnblock_flags_mask(st
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
 
@@ -6836,20 +6834,18 @@ void set_pfnblock_flags_mask(struct page
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

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

