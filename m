From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:49:03 -0800
Message-ID: <201101142251.p0EMprvT005553@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449Ab1ANWv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:51:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pullip.cho@samsung.com, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: simplify calculation of combined index of adjacent buddy lists
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: simplify calculation of combined index of adjacent buddy lists
From: KyongHo Cho <pullip.cho@samsung.com>

The previous approach of calucation of combined index was

	page_idx & ~(1 << order))

but we have same result with

	page_idx & buddy_idx

This reduces instructions slightly as well as enhances readability.

[akpm@linux-foundation.org: coding-style fixes]
[akpm@linux-foundation.org: fix used-unintialised warning]
Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists
+++ a/mm/page_alloc.c
@@ -427,18 +427,10 @@ static inline void rmv_page_order(struct
  *
  * Assumption: *_mem_map is contiguous at least up to MAX_ORDER
  */
-static inline struct page *
-__page_find_buddy(struct page *page, unsigned long page_idx, unsigned int order)
-{
-	unsigned long buddy_idx = page_idx ^ (1 << order);
-
-	return page + (buddy_idx - page_idx);
-}
-
 static inline unsigned long
-__find_combined_index(unsigned long page_idx, unsigned int order)
+__find_buddy_index(unsigned long page_idx, unsigned int order)
 {
-	return (page_idx & ~(1 << order));
+	return page_idx ^ (1 << order);
 }
 
 /*
@@ -500,6 +492,7 @@ static inline void __free_one_page(struc
 {
 	unsigned long page_idx;
 	unsigned long combined_idx;
+	unsigned long uninitialized_var(buddy_idx);
 	struct page *buddy;
 
 	if (unlikely(PageCompound(page)))
@@ -514,7 +507,8 @@ static inline void __free_one_page(struc
 	VM_BUG_ON(bad_range(zone, page));
 
 	while (order < MAX_ORDER-1) {
-		buddy = __page_find_buddy(page, page_idx, order);
+		buddy_idx = __find_buddy_index(page_idx, order);
+		buddy = page + (buddy_idx - page_idx);
 		if (!page_is_buddy(page, buddy, order))
 			break;
 
@@ -522,7 +516,7 @@ static inline void __free_one_page(struc
 		list_del(&buddy->lru);
 		zone->free_area[order].nr_free--;
 		rmv_page_order(buddy);
-		combined_idx = __find_combined_index(page_idx, order);
+		combined_idx = buddy_idx & page_idx;
 		page = page + (combined_idx - page_idx);
 		page_idx = combined_idx;
 		order++;
@@ -539,9 +533,10 @@ static inline void __free_one_page(struc
 	 */
 	if ((order < MAX_ORDER-2) && pfn_valid_within(page_to_pfn(buddy))) {
 		struct page *higher_page, *higher_buddy;
-		combined_idx = __find_combined_index(page_idx, order);
-		higher_page = page + combined_idx - page_idx;
-		higher_buddy = __page_find_buddy(higher_page, combined_idx, order + 1);
+		combined_idx = buddy_idx & page_idx;
+		higher_page = page + (combined_idx - page_idx);
+		buddy_idx = __find_buddy_index(combined_idx, order + 1);
+		higher_buddy = page + (buddy_idx - combined_idx);
 		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);
_

Patches currently in -mm which might be from pullip.cho@samsung.com are

origin.patch

