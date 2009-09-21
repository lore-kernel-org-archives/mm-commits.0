From: akpm@linux-foundation.org
Subject: [folded] page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:22:36 -0700
Message-ID: <200909212122.n8LLMaRe006375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754002AbZIUVXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:23:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback fix
has been removed from the -mm tree.  Its filename was
     page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix.patch

This patch was dropped because it was folded into page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback fix
From: Mel Gorman <mel@csn.ul.ie>

Calculate the number of pageblocks within a range properly

Patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback
is meant to change the pageblock ownership of each pageblock within a
given range. This is necessary when the buddy to be split is of higher
order than the pageblock_order. However, the calculation was wrong
leading to crashes on ia-64 and slightly incorrect behaviour on x86.
This patch corrects the calculation.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix
+++ a/mm/page_alloc.c
@@ -809,7 +809,7 @@ static int move_freepages_block(struct z
 static void change_pageblock_range(struct page *pageblock_page,
 					int start_order, int migratetype)
 {
-	int nr_pageblocks = 1 << (MAX_ORDER - 1 - start_order);
+	int nr_pageblocks = 1 << (start_order - pageblock_order);
 
 	while (nr_pageblocks--) {
 		set_pageblock_migratetype(pageblock_page, migratetype);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
revert-hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback-fix.patch
page-allocator-remove-dead-function-free_cold_page.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-events-for-anti-fragmentation-falling-back-to-other-migratetypes.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists-fix.patch
tracing-page-allocator-add-a-postprocessing-script-for-page-allocator-related-ftrace-events.patch
tracing-documentation-add-a-document-describing-how-to-do-some-performance-analysis-with-tracepoints.patch
tracing-documentation-add-a-document-on-the-kmem-tracepoints.patch
mm-drop-unneeded-double-negations.patch
page-allocator-limit-the-number-of-migrate_reserve-pageblocks-per-zone.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch
page-allocator-split-per-cpu-list-into-one-list-per-migrate-type.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp.patch
page-allocator-maintain-rolling-count-of-pages-to-free-from-the-pcp-checkpatch-fixes.patch
mm-munlock-use-follow_page.patch
mm-remove-unused-gup-flags.patch
mm-add-get_dump_page.patch
mm-foll_dump-replace-foll_anon.patch
mm-follow_hugetlb_page-flags.patch
mm-fix-anonymous-dirtying.patch
mm-reinstate-zero_page.patch
mm-foll-flags-for-gup-flags.patch
mm-munlock-avoid-zero_page.patch
mm-hugetlbfs_pagecache_present.patch
mm-zero_page-without-pte_special.patch
mm-zero_page-without-pte_special-mips-fix.patch
mm-move-highest_memmap_pfn.patch
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions-fix.patch
hugetlb-add-map_hugetlb-example.patch
add-debugging-aid-for-memory-initialisation-problems.patch

