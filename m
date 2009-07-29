From: akpm@linux-foundation.org
Subject: + page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch added to -mm tree
Date: Wed, 29 Jul 2009 16:47:45 -0700
Message-ID: <200907292347.n6TNljjR025233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755192AbZG2XsQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jul 2009 19:48:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, apw@shadowen.org


The patch titled
     page-allocator: change migratetype for all pageblocks within a high-order page during __rmqueue_fallback
has been added to the -mm tree.  Its filename is
     page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch

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
Subject: page-allocator: change migratetype for all pageblocks within a high-order page during __rmqueue_fallback
From: Mel Gorman <mel@csn.ul.ie>

When there are no pages of a target migratetype free, the page allocator
selects a high-order block of another migratetype to allocate from.  When
the order of the page taken is greater than pageblock_order, all
pageblocks within that high-order page should change migratetype so that
pages are later freed to the correct free-lists.

The current behaviour is that pageblocks change migratetype if the order
being split matches the pageblock_order.  When pageblock_order <
MAX_ORDER-1, ownership is not changing correct and pages are being later
freed to the incorrect list and this impacts fragmentation avoidance.

This patch changes all pageblocks within the high-order page being split
to the correct migratetype.  Without the patch, allocation success rates
for hugepages under stress were about 59% of physical memory on x86-64. 
With the patch applied, this goes up to 65%.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback
+++ a/mm/page_alloc.c
@@ -788,6 +788,17 @@ static int move_freepages_block(struct z
 	return move_freepages(zone, start_page, end_page, migratetype);
 }
 
+static void change_pageblock_range(struct page *pageblock_page,
+					int start_order, int migratetype)
+{
+	int nr_pageblocks = 1 << (MAX_ORDER - 1 - start_order);
+
+	while (nr_pageblocks--) {
+		set_pageblock_migratetype(pageblock_page, migratetype);
+		pageblock_page += pageblock_nr_pages;
+	}
+}
+
 /* Remove an element from the buddy allocator from the fallback list */
 static inline struct page *
 __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
@@ -839,8 +850,9 @@ __rmqueue_fallback(struct zone *zone, in
 			list_del(&page->lru);
 			rmv_page_order(page);
 
-			if (current_order == pageblock_order)
-				set_pageblock_migratetype(page,
+			/* Take ownership for orders >= pageblock_order */
+			if (current_order >= pageblock_order)
+				change_pageblock_range(page, current_order,
 							start_migratetype);
 
 			expand(zone, page, order, current_order, area, migratetype);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-preserve-pfn-ordering-when-__gfp_cold-is-set.patch
mm-avoid-endless-looping-for-oom-killed-tasks.patch
page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
profile-suppress-warning-about-large-allocations-when-profile=1-is-specified.patch
net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
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

