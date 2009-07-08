From: akpm@linux-foundation.org
Subject: + page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch added to -mm tree
Date: Wed, 08 Jul 2009 14:20:14 -0700
Message-ID: <200907082120.n68LKEKk030084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754584AbZGHVWB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2009 17:22:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, kamezawa.hiroyu@jp.fujitsu.com, narayanan.g@samsung.com, stable@kernel.org


The patch titled
     page-allocator: preserve PFN ordering when __GFP_COLD is set
has been added to the -mm tree.  Its filename is
     page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: page-allocator: preserve PFN ordering when __GFP_COLD is set
From: Mel Gorman <mel@csn.ul.ie>

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
Reported-by: NARAYANAN GOPALAKRISHNAN <narayanan.g@samsung.com>
Tested-by: NARAYANAN GOPALAKRISHNAN <narayanan.g@samsung.com>
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

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
page-allocator-ensure-that-processes-that-have-been-oom-killed-exit-the-page-allocator.patch
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
mm-clean-up-page_remove_rmap.patch
add-debugging-aid-for-memory-initialisation-problems.patch

