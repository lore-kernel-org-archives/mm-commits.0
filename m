From: akpm@linux-foundation.org
Subject: - choose-pages-from-the-per-cpu-list-based-on-migration-type.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:34:32 -0700
Message-ID: <200710162034.l9GKYW5r014948@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936101AbXJPVjQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:39:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Choose pages from the per-cpu list based on migration type
has been removed from the -mm tree.  Its filename was
     choose-pages-from-the-per-cpu-list-based-on-migration-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Choose pages from the per-cpu list based on migration type
From: Mel Gorman <mel@csn.ul.ie>

The freelists for each migrate type can slowly become polluted due to the
per-cpu list.  Consider what happens when the following happens

1. A 2^(MAX_ORDER-1) list is reserved for __GFP_MOVABLE pages
2. An order-0 page is allocated from the newly reserved block
3. The page is freed and placed on the per-cpu list
4. alloc_page() is called with GFP_KERNEL as the gfp_mask
5. The per-cpu list is used to satisfy the allocation

This results in a kernel page is in the middle of a migratable region. This
patch prevents this leak occuring by storing the MIGRATE_ type of the page in
page->private. On allocate, a page will only be returned of the desired type,
else more pages will be allocated. This may temporarily allow a per-cpu list
to go over the pcp->high limit but it'll be corrected on the next free. Care
is taken to preserve the hotness of pages recently freed.

The additional code is not measurably slower for the workloads we've tested.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~choose-pages-from-the-per-cpu-list-based-on-migration-type mm/page_alloc.c
--- a/mm/page_alloc.c~choose-pages-from-the-per-cpu-list-based-on-migration-type
+++ a/mm/page_alloc.c
@@ -760,7 +760,8 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
-		list_add_tail(&page->lru, list);
+		list_add(&page->lru, list);
+		set_page_private(page, migratetype);
 	}
 	spin_unlock(&zone->lock);
 	return i;
@@ -887,6 +888,7 @@ static void fastcall free_hot_cold_page(
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
 	list_add(&page->lru, &pcp->list);
+	set_page_private(page, get_pageblock_migratetype(page));
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
@@ -951,9 +953,27 @@ again:
 			if (unlikely(!pcp->count))
 				goto failed;
 		}
-		page = list_entry(pcp->list.next, struct page, lru);
-		list_del(&page->lru);
-		pcp->count--;
+		/* Find a page of the appropriate migrate type */
+		list_for_each_entry(page, &pcp->list, lru) {
+			if (page_private(page) == migratetype) {
+				list_del(&page->lru);
+				pcp->count--;
+				break;
+			}
+		}
+
+		/*
+		 * Check if a page of the appropriate migrate type
+		 * was found. If not, allocate more to the pcp list
+		 */
+		if (&page->lru == &pcp->list) {
+			pcp->count += rmqueue_bulk(zone, 0,
+					pcp->batch, &pcp->list, migratetype);
+			page = list_entry(pcp->list.next, struct page, lru);
+			VM_BUG_ON(page_private(page) != migratetype);
+			list_del(&page->lru);
+			pcp->count--;
+		}
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
 		page = __rmqueue(zone, order, migratetype);
_

Patches currently in -mm which might be from mel@csn.ul.ie are

origin.patch
ext2-reservations.patch
page-owner-tracking-leak-detector.patch
add-debugging-aid-for-memory-initialisation-problems.patch
