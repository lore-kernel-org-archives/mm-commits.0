From: akpm@linux-foundation.org
Subject: [merged] page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:37 -0700
Message-ID: <200909222040.n8MKebV7005931@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbZIVUlm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, apw@shadowen.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     page-allocator: change migratetype for all pageblocks within a high-order page during __rmqueue_fallback
has been removed from the -mm tree.  Its filename was
     page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback mm/page_alloc.c
--- a/mm/page_alloc.c~page-allocator-change-migratetype-for-all-pageblocks-within-a-high-order-page-during-__rmqueue_fallback
+++ a/mm/page_alloc.c
@@ -783,6 +783,17 @@ static int move_freepages_block(struct z
 	return move_freepages(zone, start_page, end_page, migratetype);
 }
 
+static void change_pageblock_range(struct page *pageblock_page,
+					int start_order, int migratetype)
+{
+	int nr_pageblocks = 1 << (start_order - pageblock_order);
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
@@ -836,8 +847,9 @@ __rmqueue_fallback(struct zone *zone, in
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

origin.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch
add-debugging-aid-for-memory-initialisation-problems.patch

