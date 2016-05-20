From: akpm@linux-foundation.org
Subject: [patch 104/117] mm, page_alloc: shortcut watermark checks for
 order-0 pages
Date: Thu, 19 May 2016 17:14:07 -0700
Message-ID: <573e56cf.j4q728Ai5ElVxDYm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbcETAOI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:14:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-shortcut-watermark-checks-for-order-0-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-shortcut-watermark-checks-for-order-0-pages
+++ a/mm/page_alloc.c
@@ -2623,6 +2623,32 @@ bool zone_watermark_ok(struct zone *z, u
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
@@ -2744,7 +2770,7 @@ zonelist_scan:
 			continue;
 
 		mark = zone->watermark[alloc_flags & ALLOC_WMARK_MASK];
-		if (!zone_watermark_ok(zone, order, mark,
+		if (!zone_watermark_fast(zone, order, mark,
 				       ac->classzone_idx, alloc_flags)) {
 			int ret;
 
_
