From: akpm@linux-foundation.org
Subject: +
 mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch added to -mm tree
Date: Thu, 11 Aug 2016 14:29:59 -0700
Message-ID: <57acee57.8leg/wlb+rrEqmRX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbcHKVaA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 17:30:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mhocko@suse.com, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: require only min watermarks for non-costly orders
has been added to the -mm tree.  Its filename is
     mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, compaction: require only min watermarks for non-costly orders

The __compaction_suitable() function checks the low watermark plus a
compact_gap() gap to decide if there's enough free memory to perform
compaction.  Then __isolate_free_page uses low watermark check to decide
if particular free page can be isolated.  In the latter case, using low
watermark is needlessly pessimistic, as the free page isolations are only
temporary.  For __compaction_suitable() the higher watermark makes sense
for high-order allocations where more freepages increase the chance of
success, and we can typically fail with some order-0 fallback when the
system is struggling to reach that watermark.  But for low-order
allocation, forming the page should not be that hard.  So using low
watermark here might just prevent compaction from even trying, and
eventually lead to OOM killer even if we are above min watermarks.

So after this patch, we use min watermark for non-costly orders in
__compaction_suitable(), and for all orders in __isolate_free_page().

Link: http://lkml.kernel.org/r/20160810091226.6709-11-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    6 +++++-
 mm/page_alloc.c |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN mm/compaction.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders mm/compaction.c
--- a/mm/compaction.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders
+++ a/mm/compaction.c
@@ -1399,10 +1399,14 @@ static enum compact_result __compaction_
 	 * isolation. We however do use the direct compactor's classzone_idx to
 	 * skip over zones where lowmem reserves would prevent allocation even
 	 * if compaction succeeds.
+	 * For costly orders, we require low watermark instead of min for
+	 * compaction to proceed to increase its chances.
 	 * ALLOC_CMA is used, as pages in CMA pageblocks are considered
 	 * suitable migration targets
 	 */
-	watermark = low_wmark_pages(zone) + compact_gap(order);
+	watermark = (order > PAGE_ALLOC_COSTLY_ORDER) ?
+				low_wmark_pages(zone) : min_wmark_pages(zone);
+	watermark += compact_gap(order);
 	if (!__zone_watermark_ok(zone, 0, watermark, classzone_idx,
 						ALLOC_CMA, wmark_target))
 		return COMPACT_SKIPPED;
diff -puN mm/page_alloc.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders
+++ a/mm/page_alloc.c
@@ -2490,7 +2490,7 @@ int __isolate_free_page(struct page *pag
 
 	if (!is_migrate_isolate(mt)) {
 		/* Obey watermarks as if the page was being allocated */
-		watermark = low_wmark_pages(zone) + (1 << order);
+		watermark = min_wmark_pages(zone) + (1UL << order);
 		if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
 			return 0;
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch

