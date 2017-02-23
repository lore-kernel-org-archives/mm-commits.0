From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch removed from -mm tree
Date: Thu, 23 Feb 2017 13:12:57 -0800
Message-ID: <58af5059.9tBjQARJhqkg/8AY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdBWVM6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:12:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: don't convert pfn to idx when merging
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-dont-convert-pfn-to-idx-when-merging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_alloc: don't convert pfn to idx when merging

In __free_one_page() we do the buddy merging arithmetics on "page/buddy
index", which is just the lower MAX_ORDER bits of pfn.  The operations we
do that affect the higher bits are bitwise AND and subtraction (in that
order), where the final result will be the same with the higher bits left
unmasked, as long as these bits are equal for both buddies - which must be
true by the definition of a buddy.

We can therefore use pfn's directly instead of "index" and skip the
zeroing of >MAX_ORDER bits.  This can help a bit by itself, although
compiler might be smart enough already.  It also helps the next patch to
avoid page_to_pfn() for memory hole checks.

Link: http://lkml.kernel.org/r/20161216120009.20064-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |    4 ++--
 mm/page_alloc.c     |   31 ++++++++++++++-----------------
 mm/page_isolation.c |    8 ++++----
 3 files changed, 20 insertions(+), 23 deletions(-)

diff -puN mm/internal.h~mm-page_alloc-dont-convert-pfn-to-idx-when-merging mm/internal.h
--- a/mm/internal.h~mm-page_alloc-dont-convert-pfn-to-idx-when-merging
+++ a/mm/internal.h
@@ -133,9 +133,9 @@ struct alloc_context {
  * Assumption: *_mem_map is contiguous at least up to MAX_ORDER
  */
 static inline unsigned long
-__find_buddy_index(unsigned long page_idx, unsigned int order)
+__find_buddy_pfn(unsigned long page_pfn, unsigned int order)
 {
-	return page_idx ^ (1 << order);
+	return page_pfn ^ (1 << order);
 }
 
 extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
diff -puN mm/page_alloc.c~mm-page_alloc-dont-convert-pfn-to-idx-when-merging mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-dont-convert-pfn-to-idx-when-merging
+++ a/mm/page_alloc.c
@@ -787,9 +787,8 @@ static inline void __free_one_page(struc
 		struct zone *zone, unsigned int order,
 		int migratetype)
 {
-	unsigned long page_idx;
-	unsigned long combined_idx;
-	unsigned long uninitialized_var(buddy_idx);
+	unsigned long combined_pfn;
+	unsigned long uninitialized_var(buddy_pfn);
 	struct page *buddy;
 	unsigned int max_order;
 
@@ -802,15 +801,13 @@ static inline void __free_one_page(struc
 	if (likely(!is_migrate_isolate(migratetype)))
 		__mod_zone_freepage_state(zone, 1 << order, migratetype);
 
-	page_idx = pfn & ((1 << MAX_ORDER) - 1);
-
-	VM_BUG_ON_PAGE(page_idx & ((1 << order) - 1), page);
+	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
 	VM_BUG_ON_PAGE(bad_range(zone, page), page);
 
 continue_merging:
 	while (order < max_order - 1) {
-		buddy_idx = __find_buddy_index(page_idx, order);
-		buddy = page + (buddy_idx - page_idx);
+		buddy_pfn = __find_buddy_pfn(pfn, order);
+		buddy = page + (buddy_pfn - pfn);
 		if (!page_is_buddy(page, buddy, order))
 			goto done_merging;
 		/*
@@ -824,9 +821,9 @@ continue_merging:
 			zone->free_area[order].nr_free--;
 			rmv_page_order(buddy);
 		}
-		combined_idx = buddy_idx & page_idx;
-		page = page + (combined_idx - page_idx);
-		page_idx = combined_idx;
+		combined_pfn = buddy_pfn & pfn;
+		page = page + (combined_pfn - pfn);
+		pfn = combined_pfn;
 		order++;
 	}
 	if (max_order < MAX_ORDER) {
@@ -841,8 +838,8 @@ continue_merging:
 		if (unlikely(has_isolate_pageblock(zone))) {
 			int buddy_mt;
 
-			buddy_idx = __find_buddy_index(page_idx, order);
-			buddy = page + (buddy_idx - page_idx);
+			buddy_pfn = __find_buddy_pfn(pfn, order);
+			buddy = page + (buddy_pfn - pfn);
 			buddy_mt = get_pageblock_migratetype(buddy);
 
 			if (migratetype != buddy_mt
@@ -867,10 +864,10 @@ done_merging:
 	 */
 	if ((order < MAX_ORDER-2) && pfn_valid_within(page_to_pfn(buddy))) {
 		struct page *higher_page, *higher_buddy;
-		combined_idx = buddy_idx & page_idx;
-		higher_page = page + (combined_idx - page_idx);
-		buddy_idx = __find_buddy_index(combined_idx, order + 1);
-		higher_buddy = higher_page + (buddy_idx - combined_idx);
+		combined_pfn = buddy_pfn & pfn;
+		higher_page = page + (combined_pfn - pfn);
+		buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
+		higher_buddy = higher_page + (buddy_pfn - combined_pfn);
 		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);
diff -puN mm/page_isolation.c~mm-page_alloc-dont-convert-pfn-to-idx-when-merging mm/page_isolation.c
--- a/mm/page_isolation.c~mm-page_alloc-dont-convert-pfn-to-idx-when-merging
+++ a/mm/page_isolation.c
@@ -83,7 +83,7 @@ static void unset_migratetype_isolate(st
 	unsigned long flags, nr_pages;
 	bool isolated_page = false;
 	unsigned int order;
-	unsigned long page_idx, buddy_idx;
+	unsigned long pfn, buddy_pfn;
 	struct page *buddy;
 
 	zone = page_zone(page);
@@ -102,9 +102,9 @@ static void unset_migratetype_isolate(st
 	if (PageBuddy(page)) {
 		order = page_order(page);
 		if (order >= pageblock_order) {
-			page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
-			buddy_idx = __find_buddy_index(page_idx, order);
-			buddy = page + (buddy_idx - page_idx);
+			pfn = page_to_pfn(page);
+			buddy_pfn = __find_buddy_pfn(pfn, order);
+			buddy = page + (buddy_pfn - pfn);
 
 			if (pfn_valid_within(page_to_pfn(buddy)) &&
 			    !is_migrate_isolate_page(buddy)) {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-page_alloc-remove-redundant-checks-from-alloc-fastpath.patch
mm-page_alloc-dont-check-cpuset-allowed-twice-in-fast-path.patch

