From: akpm@linux-foundation.org
Subject: [folded] page-allocator-update-nr_free_pages-only-as-necessary-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 14:56:10 -0700
Message-ID: <200906162156.n5GLuANN025504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33049 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751895AbZFPV5Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 17:57:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, Lee.Schermerhorn@hp.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, dave@linux.vnet.ibm.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, nickpiggi


The patch titled
     Properly account for freed pages in free_pages_bulk() and when allocating high-order pages in buffered_rmqueue() V2
has been removed from the -mm tree.  Its filename was
     page-allocator-update-nr_free_pages-only-as-necessary-fix.patch

This patch was dropped because it was folded into page-allocator-update-nr_free_pages-only-as-necessary.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Properly account for freed pages in free_pages_bulk() and when allocating high-order pages in buffered_rmqueue() V2
From: Mel Gorman <mel@csn.ul.ie>

free_pages_bulk() updates the number of free pages in the zone but it
is assuming that the pages being freed are order-0.  While this is
currently always true, it's wrong to assume the order is 0.  This patch
fixes the problem.

buffered_rmqueue() is not updating NR_FREE_PAGES when allocating pages
with __rmqueue().  As a result, high-order allocation will appear to
increase the number of free pages leading to the situation where the
free page count exceeds available RAM.  This patch accounts for those
allocated pages properly.

This is a fix for page-allocator-update-nr_free_pages-only-as-necessary.patch.

Changelog since V1
  o Change 1UL to 1 as it's unnecessary in this case to be unsigned long

Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-update-nr_free_pages-only-as-necessary-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-update-nr_free_pages-only-as-necessary-fix
+++ a/mm/page_alloc.c
@@ -528,7 +528,7 @@ static void free_pages_bulk(struct zone 
 	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
 	zone->pages_scanned = 0;
 
-	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count << order);
 	while (count--) {
 		struct page *page;
 
@@ -1148,6 +1148,7 @@ again:
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
+		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
vmscan-low-order-lumpy-reclaim-also-should-use-pageout_io_sync.patch
mm-alloc_large_system_hash-check-order.patch
page-allocator-replace-__alloc_pages_internal-with-__alloc_pages_nodemask.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path.patch
page-allocator-do-not-check-numa-node-id-when-the-caller-knows-the-node-is-valid.patch
page-allocator-check-only-once-if-the-zonelist-is-suitable-for-the-allocation.patch
page-allocator-break-up-the-allocator-entry-point-into-fast-and-slow-paths.patch
page-allocator-move-check-for-disabled-anti-fragmentation-out-of-fastpath.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once.patch
page-allocator-calculate-the-migratetype-for-allocation-only-once.patch
page-allocator-calculate-the-alloc_flags-for-allocation-only-once.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
page-allocator-inline-__rmqueue_smallest.patch
page-allocator-inline-buffered_rmqueue.patch
page-allocator-inline-__rmqueue_fallback.patch
page-allocator-do-not-call-get_pageblock_migratetype-more-than-necessary.patch
page-allocator-do-not-disable-interrupts-in-free_page_mlock.patch
page-allocator-do-not-setup-zonelist-cache-when-there-is-only-one-node.patch
page-allocator-do-not-check-for-compound-pages-during-the-page-allocator-sanity-checks.patch
page-allocator-use-allocation-flags-as-an-index-to-the-zone-watermark.patch
page-allocator-update-nr_free_pages-only-as-necessary.patch
page-allocator-update-nr_free_pages-only-as-necessary-fix.patch
page-allocator-get-the-pageblock-migratetype-without-disabling-interrupts.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
page-allocator-slab-use-nr_online_nodes-to-check-for-a-numa-platform.patch
page-allocator-move-free_page_mlock-to-page_allocc.patch
page-allocator-sanity-check-order-in-the-page-allocator-slow-path.patch
mm-use-alloc_pages_exact-in-alloc_large_system_hash-to-avoid-duplicated-logic.patch
mm-introduce-pagehuge-for-testing-huge-gigantic-pages-update.patch
page-allocator-warn-if-__gfp_nofail-is-used-for-a-large-allocation.patch
mm-pm-freezer-disable-oom-killer-when-tasks-are-frozen.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator.patch
page-allocator-use-integer-fields-lookup-for-gfp_zone-and-check-for-errors-in-flags-passed-to-the-page-allocator-fix-gfp-zone-patch.patch
page-allocator-clean-up-functions-related-to-pages_min.patch
oom-move-oom_adj-value-from-task_struct-to-mm_struct.patch
oom-avoid-unnecessary-mm-locking-and-scanning-for-oom_disable.patch
oom-invoke-oom-killer-for-__gfp_nofail.patch
page-allocator-clear-n_high_memory-map-before-se-set-it-again.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports.patch
mm-add-a-gfp-translate-script-to-help-understand-page-allocation-failure-reports-fix.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-vmscan-fix-use-of-delta-in-zone_pagecache_reclaimable.patch
vmscan-properly-account-for-the-number-of-page-cache-pages-zone_reclaim-can-reclaim-mm-fix-documentation-of-min_unmapped_ratio.patch
vmscan-do-not-unconditionally-treat-zones-that-fail-zone_reclaim-as-full.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails.patch
vmscan-count-the-number-of-times-zone_reclaim-scans-and-fails-fix.patch
mm-fix-lumpy-reclaim-lru-handling-at-isolate_lru_pages.patch

