From: akpm@linux-foundation.org
Subject: [merged] page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch removed from -mm tree
Date: Thu, 30 Jul 2009 13:34:50 -0700
Message-ID: <200907302034.n6UKYo3R007198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbZG3UgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 16:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, kamezawa.hiroyu@jp.fujitsu.com, narayanan.g@samsung.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     page-allocator: preserve PFN ordering when __GFP_COLD is set
has been removed from the -mm tree.  Its filename was
     page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: preserve PFN ordering when __GFP_COLD is set
From: Mel Gorman <mel@csn.ul.ie>

Fix a post-2.6.24 performace regression caused by
3dfa5721f12c3d5a441448086bee156887daa961 ("page-allocator: preserve PFN
ordering when __GFP_COLD is set").

Narayanan reports "The regression is around 15%.  There is no disk controller
as our setup is based on Samsung OneNAND used as a memory mapped device on a
OMAP2430 based board."

The page allocator tries to preserve contiguous PFN ordering when returning
pages such that repeated callers to the allocator have a strong chance of
getting physically contiguous pages, particularly when external fragmentation
is low.  However, of the bulk of the allocations have __GFP_COLD set as they
are due to aio_read() for example, then the PFNs are in reverse PFN order. 
This can cause performance degration when used with IO controllers that could
have merged the requests.

This patch attempts to preserve the contiguous ordering of PFNs for users of
__GFP_COLD.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reported-by: Narayananu Gopalakrishnan <narayanan.g@samsung.com>
Tested-by: Narayanan Gopalakrishnan <narayanan.g@samsung.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set
+++ a/mm/page_alloc.c
@@ -882,7 +882,7 @@ retry_reserve:
  */
 static int rmqueue_bulk(struct zone *zone, unsigned int order, 
 			unsigned long count, struct list_head *list,
-			int migratetype)
+			int migratetype, int cold)
 {
 	int i;
 	
@@ -901,7 +901,10 @@ static int rmqueue_bulk(struct zone *zon
 		 * merge IO requests if the physical pages are ordered
 		 * properly.
 		 */
-		list_add(&page->lru, list);
+		if (likely(cold == 0))
+			list_add(&page->lru, list);
+		else
+			list_add_tail(&page->lru, list);
 		set_page_private(page, migratetype);
 		list = &page->lru;
 	}
@@ -1119,7 +1122,8 @@ again:
 		local_irq_save(flags);
 		if (!pcp->count) {
 			pcp->count = rmqueue_bulk(zone, 0,
-					pcp->batch, &pcp->list, migratetype);
+					pcp->batch, &pcp->list,
+					migratetype, cold);
 			if (unlikely(!pcp->count))
 				goto failed;
 		}
@@ -1138,7 +1142,8 @@ again:
 		/* Allocate more to the pcp list if necessary */
 		if (unlikely(&page->lru == &pcp->list)) {
 			pcp->count += rmqueue_bulk(zone, 0,
-					pcp->batch, &pcp->list, migratetype);
+					pcp->batch, &pcp->list,
+					migratetype, cold);
 			page = list_entry(pcp->list.next, struct page, lru);
 		}
 
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
memory-hotplug-update-zone-pcp-at-memory-online.patch
memory-hotplug-update-zone-pcp-at-memory-online-fix.patch
memory-hotplug-exclude-isolated-page-from-pco-page-alloc.patch
memory-hotplug-make-pages-from-movable-zone-always-isolatable.patch
memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
memory-hotplug-migrate-swap-cache-page.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch
mm-clean-up-page_remove_rmap.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch
add-debugging-aid-for-memory-initialisation-problems.patch

