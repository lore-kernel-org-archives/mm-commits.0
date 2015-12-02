From: akpm@linux-foundation.org
Subject: +
 mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch added
 to -mm tree
Date: Wed, 02 Dec 2015 14:53:37 -0800
Message-ID: <565f7671.PaAz/HKPGnspYols%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbbLBWxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 17:53:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@163.com, mgorman@techsingularity.net, mhocko@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: use list_{first,last}_entry instead of list_entry
has been added to the -mm tree.  Its filename is
     mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Geliang Tang <geliangtang@163.com>
Subject: mm/page_alloc.c: use list_{first,last}_entry instead of list_entry

To make the intention clearer, use list_{first,last}_entry instead of
list_entry.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
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

fsnotify-use-list_next_entry-in-fsnotify_unmount_inodes.patch
mm-vmalloc-use-list_nextfirst_entry.patch
mm-thp-use-list_first_entry_or_null.patch
mm-page_allocc-use-list_firstlast_entry-instead-of-list_entry.patch
mm-page_allocc-use-list_for_each_entry-in-mark_free_pages.patch
dma-mapping-use-offset_in_page-macro.patch

