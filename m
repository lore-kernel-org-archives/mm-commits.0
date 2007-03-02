From: akpm@linux-foundation.org
Subject: + choose-pages-from-the-per-cpu-list-based-on-migration-type.patch added to -mm tree
Date: Fri, 02 Mar 2007 13:41:33 -0800
Message-ID: <200703022141.l22LfXw9019762@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbXCBVlh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 16:41:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie


The patch titled
     Choose pages from the per-cpu list based on migration type
has been added to the -mm tree.  Its filename is
     choose-pages-from-the-per-cpu-list-based-on-migration-type.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 24 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~choose-pages-from-the-per-cpu-list-based-on-migration-type mm/page_alloc.c
--- a/mm/page_alloc.c~choose-pages-from-the-per-cpu-list-based-on-migration-type
+++ a/mm/page_alloc.c
@@ -747,7 +747,8 @@ static int rmqueue_bulk(struct zone *zon
 		struct page *page = __rmqueue(zone, order, migratetype);
 		if (unlikely(page == NULL))
 			break;
-		list_add_tail(&page->lru, list);
+		list_add(&page->lru, list);
+		set_page_private(page, migratetype);
 	}
 	spin_unlock(&zone->lock);
 	return i;
@@ -912,6 +913,7 @@ static void fastcall free_hot_cold_page(
 	local_irq_save(flags);
 	__count_vm_event(PGFREE);
 	list_add(&page->lru, &pcp->list);
+	set_page_private(page, get_pageblock_migratetype(page));
 	pcp->count++;
 	if (pcp->count >= pcp->high) {
 		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
@@ -976,9 +978,27 @@ again:
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

add-a-bitmap-that-is-used-to-track-flags-affecting-a-block-of-pages.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-low-memory-that-may-be-migrated.patch
split-the-free-lists-for-movable-and-unmovable-allocations.patch
choose-pages-from-the-per-cpu-list-based-on-migration-type.patch
add-a-configure-option-to-group-pages-by-mobility.patch
drain-per-cpu-lists-when-high-order-allocations-fail.patch
move-free-pages-between-lists-on-steal.patch
group-short-lived-and-reclaimable-kernel-allocations.patch
group-high-order-atomic-allocations.patch
bias-the-placement-of-kernel-pages-at-lower-pfns.patch
be-more-agressive-about-stealing-when-migrate_reclaimable-allocations-fallback.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
x86-specify-amount-of-kernel-memory-at-boot-time.patch
ppc-and-powerpc-specify-amount-of-kernel-memory-at-boot-time.patch
x86_64-specify-amount-of-kernel-memory-at-boot-time.patch
ia64-specify-amount-of-kernel-memory-at-boot-time.patch
add-documentation-for-additional-boot-parameter-and-sysctl.patch
ext2-reservations.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-swap-prefetch.patch
add-debugging-aid-for-memory-initialisation-problems.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
