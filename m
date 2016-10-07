From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix.patch
 removed from -mm tree
Date: Fri, 07 Oct 2016 16:34:24 -0700
Message-ID: <57f83100.oxkZ6v+Axe/jrrxN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38287 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754345AbcJGXeZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:34:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, lstoakes@gmail.com, mgorman@techsingularity.net, mhocko@kernel.org, riel@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix.patch

This patch was dropped because it was folded into mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix
 orders-fix

Clarify why __isolate_free_page() does a order-0 watermark check with
apparent (1UL << order) gap, per Joonsoo.

Link: http://lkml.kernel.org/r/7ae4baec-4eca-e70b-2a69-94bea4fb19fa@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-require-only-min-watermarks-for-non-costly-orders-fix
+++ a/mm/page_alloc.c
@@ -2489,7 +2489,12 @@ int __isolate_free_page(struct page *pag
 	mt = get_pageblock_migratetype(page);
 
 	if (!is_migrate_isolate(mt)) {
-		/* Obey watermarks as if the page was being allocated */
+		/*
+		 * Obey watermarks as if the page was being allocated. We can
+		 * emulate a high-order watermark check with a raised order-0
+		 * watermark, because we already know our high-order page
+		 * exists.
+		 */
 		watermark = min_wmark_pages(zone) + (1UL << order);
 		if (!zone_watermark_ok(zone, 0, watermark, 0, ALLOC_CMA))
 			return 0;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions.patch
mm-compaction-cleanup-unused-functions.patch
mm-compaction-rename-compact_partial-to-compact_success.patch
mm-compaction-dont-recheck-watermarks-after-compact_success.patch
mm-compaction-add-the-ultimate-direct-compaction-priority.patch
mm-compaction-use-correct-watermark-when-checking-compaction-success.patch
mm-compaction-create-compact_gap-wrapper.patch
mm-compaction-use-proper-alloc_flags-in-__compaction_suitable.patch
mm-compaction-require-only-min-watermarks-for-non-costly-orders.patch
mm-vmscan-make-compaction_ready-more-accurate-and-readable.patch
revert-mm-oom-prevent-premature-oom-killer-invocation-for-high-order-request.patch
mm-compaction-more-reliably-increase-direct-compaction-priority.patch
mm-compaction-more-reliably-increase-direct-compaction-priority-fix.patch
mm-compaction-restrict-full-priority-to-non-costly-orders.patch
mm-compaction-make-full-priority-ignore-pageblock-suitability.patch
mm-page_alloc-pull-no_progress_loops-update-to-should_reclaim_retry.patch
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable.patch
mm-compaction-ignore-fragindex-from-compaction_zonelist_suitable-fix.patch
mm-compaction-restrict-fragindex-to-costly-orders.patch

