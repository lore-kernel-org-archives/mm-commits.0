From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch removed from -mm tree
Date: Fri, 15 Jan 2016 14:34:05 -0800
Message-ID: <569973dd.aabHakvKauAPUoIa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbcAOWeG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 17:34:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mgorman@techsingularity.net, mhocko@suse.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: use list_{first,last}_entry instead of list_entry
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/page_alloc.c: use list_{first,last}_entry instead of list_entry

To make the intention clearer, use list_{first,last}_entry instead of
list_entry.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry
+++ a/mm/page_alloc.c
@@ -805,7 +805,7 @@ static void free_pcppages_bulk(struct zo
 		do {
 			int mt;	/* migratetype of the to-be-freed page */
 
-			page = list_entry(list->prev, struct page, lru);
+			page = list_last_entry(list, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
 			list_del(&page->lru);
 
@@ -1410,11 +1410,10 @@ struct page *__rmqueue_smallest(struct z
 	/* Find a page of the appropriate size in the preferred list */
 	for (current_order = order; current_order < MAX_ORDER; ++current_order) {
 		area = &(zone->free_area[current_order]);
-		if (list_empty(&area->free_list[migratetype]))
-			continue;
-
-		page = list_entry(area->free_list[migratetype].next,
+		page = list_first_entry_or_null(&area->free_list[migratetype],
 							struct page, lru);
+		if (!page)
+			continue;
 		list_del(&page->lru);
 		rmv_page_order(page);
 		area->nr_free--;
@@ -1693,12 +1692,12 @@ static void unreserve_highatomic_pageblo
 		for (order = 0; order < MAX_ORDER; order++) {
 			struct free_area *area = &(zone->free_area[order]);
 
-			if (list_empty(&area->free_list[MIGRATE_HIGHATOMIC]))
+			page = list_first_entry_or_null(
+					&area->free_list[MIGRATE_HIGHATOMIC],
+					struct page, lru);
+			if (!page)
 				continue;
 
-			page = list_entry(area->free_list[MIGRATE_HIGHATOMIC].next,
-						struct page, lru);
-
 			/*
 			 * It should never happen but changes to locking could
 			 * inadvertently allow a per-cpu drain to add pages
@@ -1746,7 +1745,7 @@ __rmqueue_fallback(struct zone *zone, un
 		if (fallback_mt == -1)
 			continue;
 
-		page = list_entry(area->free_list[fallback_mt].next,
+		page = list_first_entry(&area->free_list[fallback_mt],
 						struct page, lru);
 		if (can_steal)
 			steal_suitable_fallback(zone, page, start_migratetype);
@@ -2205,9 +2204,9 @@ struct page *buffered_rmqueue(struct zon
 		}
 
 		if (cold)
-			page = list_entry(list->prev, struct page, lru);
+			page = list_last_entry(list, struct page, lru);
 		else
-			page = list_entry(list->next, struct page, lru);
+			page = list_first_entry(list, struct page, lru);
 
 		list_del(&page->lru);
 		pcp->count--;
_

Patches currently in -mm which might be from geliangtang@163.com are

mm-swapfilec-use-list_for_each_entry_safe-in-free_swap_count_continuations.patch
mm-move-lru_to_page-to-mm_inlineh.patch
mm-zbud-use-list_last_entry-instead-of-list_tail_entry.patch
hfs-use-list_for_each_entry-in-hfs_cat_delete.patch
kexec-use-list_for_each_entry_safe-in-kimage_free_page_list.patch
rapidio-use-kobj_to_dev.patch
dma-mapping-use-offset_in_page-macro.patch

