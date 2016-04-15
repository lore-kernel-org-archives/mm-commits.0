From: akpm@linux-foundation.org
Subject: + mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch added to -mm tree
Date: Fri, 15 Apr 2016 16:12:23 -0700
Message-ID: <57117557.96dd7NEeLYW8QP0Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbcDOXMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: shortcut watermark checks for order-0 pages
has been added to the -mm tree.  Its filename is
     mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch

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
Subject: mm, page_alloc: shortcut watermark checks for order-0 pages

Watermarks have to be checked on every allocation including the number of
pages being allocated and whether reserves can be accessed.  The reserves
only matter if memory is limited and the free_pages adjustment only
applies to high-order pages.  This patch adds a shortcut for order-0 pages
that avoids numerous calculations if there is plenty of free memory
yielding the following performance difference in a page allocator
microbenchmark;

                                           4.6.0-rc2                  4.6.0-rc2
                                       optfair-v1r20             fastmark-v1r20
Min      alloc-odr0-1               380.00 (  0.00%)           364.00 (  4.21%)
Min      alloc-odr0-2               273.00 (  0.00%)           262.00 (  4.03%)
Min      alloc-odr0-4               227.00 (  0.00%)           214.00 (  5.73%)
Min      alloc-odr0-8               196.00 (  0.00%)           186.00 (  5.10%)
Min      alloc-odr0-16              183.00 (  0.00%)           173.00 (  5.46%)
Min      alloc-odr0-32              173.00 (  0.00%)           165.00 (  4.62%)
Min      alloc-odr0-64              169.00 (  0.00%)           161.00 (  4.73%)
Min      alloc-odr0-128             169.00 (  0.00%)           159.00 (  5.92%)
Min      alloc-odr0-256             180.00 (  0.00%)           168.00 (  6.67%)
Min      alloc-odr0-512             190.00 (  0.00%)           180.00 (  5.26%)
Min      alloc-odr0-1024            198.00 (  0.00%)           190.00 (  4.04%)
Min      alloc-odr0-2048            204.00 (  0.00%)           196.00 (  3.92%)
Min      alloc-odr0-4096            209.00 (  0.00%)           202.00 (  3.35%)
Min      alloc-odr0-8192            213.00 (  0.00%)           206.00 (  3.29%)
Min      alloc-odr0-16384           214.00 (  0.00%)           206.00 (  3.74%)

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-shortcut-watermark-checks-for-order-0-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-shortcut-watermark-checks-for-order-0-pages
+++ a/mm/page_alloc.c
@@ -2649,6 +2649,32 @@ bool zone_watermark_ok(struct zone *z, u
 					zone_page_state(z, NR_FREE_PAGES));
 }
 
+static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
+		unsigned long mark, int classzone_idx, unsigned int alloc_flags)
+{
+	long free_pages = zone_page_state(z, NR_FREE_PAGES);
+	long cma_pages = 0;
+
+#ifdef CONFIG_CMA
+	/* If allocation can't use CMA areas don't use free CMA pages */
+	if (!(alloc_flags & ALLOC_CMA))
+		cma_pages = zone_page_state(z, NR_FREE_CMA_PAGES);
+#endif
+
+	/*
+	 * Fast check for order-0 only. If this fails then the reserves
+	 * need to be calculated. There is a corner case where the check
+	 * passes but only the high-order atomic reserve are free. If
+	 * the caller is !atomic then it'll uselessly search the free
+	 * list. That corner case is then slower but it is harmless.
+	 */
+	if (!order && (free_pages - cma_pages) > mark + z->lowmem_reserve[classzone_idx])
+		return true;
+
+	return __zone_watermark_ok(z, order, mark, classzone_idx, alloc_flags,
+					free_pages);
+}
+
 bool zone_watermark_ok_safe(struct zone *z, unsigned int order,
 			unsigned long mark, int classzone_idx)
 {
@@ -2770,7 +2796,7 @@ zonelist_scan:
 			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-		if (!zone_watermark_ok(zone, order, mark,
+		if (!zone_watermark_fast(zone, order, mark,
 				       ac->classzone_idx, alloc_flags)) {
 			int ret;
 
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

