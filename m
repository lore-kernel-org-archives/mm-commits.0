Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BABC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34B812087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816433;
	bh=drNY0VRZAvMUZnvLT8T8l+ZzTT/1HAb7N/uoI2tCHXk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=l/B4/mRlnr8GhTEfxrS4vk4/6H08xq1+jUElrKaW8SUgjVeK4H9rvL95BvWmpD4b+
	 9DihRczBW388sRbs9zlTschvfBGfGzoYxtswtB6MOaagzSdENlZSavPQrjk7TIfFu5
	 2XSGzDAbxcrmwQF+LhmOK6XJCaE/AAnJj/Mcz4hE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404342AbgJPCrM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404339AbgJPCrM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F7ED208C7;
        Fri, 16 Oct 2020 02:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816430;
        bh=drNY0VRZAvMUZnvLT8T8l+ZzTT/1HAb7N/uoI2tCHXk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=K5yU/bW9n6ABdQgsQrSq+/uX8dlg4dGkxzo+PdsSr7dhPbhW0dDw1eOdUfeOYm/bl
         CA6GRzt+I+f3m4J96G/EdVEu2Rn0G9l0RwysamZ/mMImVD+GIM2lVsUP2y/gKp5oNM
         hB9jTleoKg6NGVBCOQjTvqkG6bwUZ8HicX5hZaG0=
Date:   Thu, 15 Oct 2020 19:47:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 094/156] mm: rename page_order() to buddy_order()
Message-ID: <20201016024709.oW_ZbNg0n%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: rename page_order() to buddy_order()

The current page_order() can only be called on pages in the buddy
allocator.  For compound pages, you have to use compound_order().  This is
confusing and led to a bug, so rename page_order() to buddy_order().

Link: https://lkml.kernel.org/r/20201001152259.14932-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c     |    6 +++---
 mm/internal.h       |    8 ++++----
 mm/page_alloc.c     |   30 +++++++++++++++---------------
 mm/page_isolation.c |    4 ++--
 mm/page_owner.c     |    6 +++---
 mm/page_reporting.c |    2 +-
 mm/shuffle.c        |    2 +-
 7 files changed, 29 insertions(+), 29 deletions(-)

--- a/mm/compaction.c~mm-rename-page_order-to-buddy_order
+++ a/mm/compaction.c
@@ -625,7 +625,7 @@ static unsigned long isolate_freepages_b
 		}
 
 		/* Found a free page, will break it into order-0 pages */
-		order = page_order(page);
+		order = buddy_order(page);
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
@@ -898,7 +898,7 @@ isolate_migratepages_block(struct compac
 		 * potential isolation targets.
 		 */
 		if (PageBuddy(page)) {
-			unsigned long freepage_order = page_order_unsafe(page);
+			unsigned long freepage_order = buddy_order_unsafe(page);
 
 			/*
 			 * Without lock, we cannot be sure that what we got is
@@ -1172,7 +1172,7 @@ static bool suitable_migration_target(st
 		 * the only small danger is that we skip a potentially suitable
 		 * pageblock, so it's not worth to check order for valid range.
 		 */
-		if (page_order_unsafe(page) >= pageblock_order)
+		if (buddy_order_unsafe(page) >= pageblock_order)
 			return false;
 	}
 
--- a/mm/internal.h~mm-rename-page_order-to-buddy_order
+++ a/mm/internal.h
@@ -270,16 +270,16 @@ int find_suitable_fallback(struct free_a
  * page from being allocated in parallel and returning garbage as the order.
  * If a caller does not hold page_zone(page)->lock, it must guarantee that the
  * page cannot be allocated or merged in parallel. Alternatively, it must
- * handle invalid values gracefully, and use page_order_unsafe() below.
+ * handle invalid values gracefully, and use buddy_order_unsafe() below.
  */
-static inline unsigned int page_order(struct page *page)
+static inline unsigned int buddy_order(struct page *page)
 {
 	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
 }
 
 /*
- * Like page_order(), but for callers who cannot afford to hold the zone lock.
+ * Like buddy_order(), but for callers who cannot afford to hold the zone lock.
  * PageBuddy() should be checked first by the caller to minimize race window,
  * and invalid values must be handled gracefully.
  *
@@ -289,7 +289,7 @@ static inline unsigned int page_order(st
  * times, potentially observing different values in the tests and the actual
  * use of the result.
  */
-#define page_order_unsafe(page)		READ_ONCE(page_private(page))
+#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
 
 static inline bool is_cow_mapping(vm_flags_t flags)
 {
--- a/mm/page_alloc.c~mm-rename-page_order-to-buddy_order
+++ a/mm/page_alloc.c
@@ -792,7 +792,7 @@ static inline void clear_page_guard(stru
 				unsigned int order, int migratetype) {}
 #endif
 
-static inline void set_page_order(struct page *page, unsigned int order)
+static inline void set_buddy_order(struct page *page, unsigned int order)
 {
 	set_page_private(page, order);
 	__SetPageBuddy(page);
@@ -817,7 +817,7 @@ static inline bool page_is_buddy(struct
 	if (!page_is_guard(buddy) && !PageBuddy(buddy))
 		return false;
 
-	if (page_order(buddy) != order)
+	if (buddy_order(buddy) != order)
 		return false;
 
 	/*
@@ -1059,7 +1059,7 @@ continue_merging:
 	}
 
 done_merging:
-	set_page_order(page, order);
+	set_buddy_order(page, order);
 
 	if (fpi_flags & FPI_TO_TAIL)
 		to_tail = true;
@@ -2178,7 +2178,7 @@ static inline void expand(struct zone *z
 			continue;
 
 		add_to_free_list(&page[size], zone, high, migratetype);
-		set_page_order(&page[size], high);
+		set_buddy_order(&page[size], high);
 	}
 }
 
@@ -2392,7 +2392,7 @@ static int move_freepages(struct zone *z
 		VM_BUG_ON_PAGE(page_to_nid(page) != zone_to_nid(zone), page);
 		VM_BUG_ON_PAGE(page_zone(page) != zone, page);
 
-		order = page_order(page);
+		order = buddy_order(page);
 		move_to_free_list(page, zone, order, migratetype);
 		page += 1 << order;
 		pages_moved += 1 << order;
@@ -2516,7 +2516,7 @@ static inline void boost_watermark(struc
 static void steal_suitable_fallback(struct zone *zone, struct page *page,
 		unsigned int alloc_flags, int start_type, bool whole_block)
 {
-	unsigned int current_order = page_order(page);
+	unsigned int current_order = buddy_order(page);
 	int free_pages, movable_pages, alike_pages;
 	int old_block_type;
 
@@ -8344,7 +8344,7 @@ struct page *has_unmovable_pages(struct
 		 */
 		if (!page_ref_count(page)) {
 			if (PageBuddy(page))
-				iter += (1 << page_order(page)) - 1;
+				iter += (1 << buddy_order(page)) - 1;
 			continue;
 		}
 
@@ -8557,7 +8557,7 @@ int alloc_contig_range(unsigned long sta
 	}
 
 	if (outer_start != start) {
-		order = page_order(pfn_to_page(outer_start));
+		order = buddy_order(pfn_to_page(outer_start));
 
 		/*
 		 * outer_start page could be small order buddy page and
@@ -8782,7 +8782,7 @@ void __offline_isolated_pages(unsigned l
 
 		BUG_ON(page_count(page));
 		BUG_ON(!PageBuddy(page));
-		order = page_order(page);
+		order = buddy_order(page);
 		del_page_from_free_list(page, zone, order);
 		pfn += (1 << order);
 	}
@@ -8801,7 +8801,7 @@ bool is_free_buddy_page(struct page *pag
 	for (order = 0; order < MAX_ORDER; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
 
-		if (PageBuddy(page_head) && page_order(page_head) >= order)
+		if (PageBuddy(page_head) && buddy_order(page_head) >= order)
 			break;
 	}
 	spin_unlock_irqrestore(&zone->lock, flags);
@@ -8838,7 +8838,7 @@ static void break_down_buddy_pages(struc
 
 		if (current_buddy != target) {
 			add_to_free_list(current_buddy, zone, high, migratetype);
-			set_page_order(current_buddy, high);
+			set_buddy_order(current_buddy, high);
 			page = next_page;
 		}
 	}
@@ -8858,16 +8858,16 @@ bool take_page_off_buddy(struct page *pa
 	spin_lock_irqsave(&zone->lock, flags);
 	for (order = 0; order < MAX_ORDER; order++) {
 		struct page *page_head = page - (pfn & ((1 << order) - 1));
-		int buddy_order = page_order(page_head);
+		int page_order = buddy_order(page_head);
 
-		if (PageBuddy(page_head) && buddy_order >= order) {
+		if (PageBuddy(page_head) && page_order >= order) {
 			unsigned long pfn_head = page_to_pfn(page_head);
 			int migratetype = get_pfnblock_migratetype(page_head,
 								   pfn_head);
 
-			del_page_from_free_list(page_head, zone, buddy_order);
+			del_page_from_free_list(page_head, zone, page_order);
 			break_down_buddy_pages(zone, page_head, page, 0,
-						buddy_order, migratetype);
+						page_order, migratetype);
 			ret = true;
 			break;
 		}
--- a/mm/page_isolation.c~mm-rename-page_order-to-buddy_order
+++ a/mm/page_isolation.c
@@ -88,7 +88,7 @@ static void unset_migratetype_isolate(st
 	 * these pages to be merged.
 	 */
 	if (PageBuddy(page)) {
-		order = page_order(page);
+		order = buddy_order(page);
 		if (order >= pageblock_order) {
 			pfn = page_to_pfn(page);
 			buddy_pfn = __find_buddy_pfn(pfn, order);
@@ -261,7 +261,7 @@ __test_page_isolated_in_pageblock(unsign
 			 * the correct MIGRATE_ISOLATE freelist. There is no
 			 * simple way to verify that as VM_BUG_ON(), though.
 			 */
-			pfn += 1 << page_order(page);
+			pfn += 1 << buddy_order(page);
 		else if ((flags & MEMORY_OFFLINE) && PageHWPoison(page))
 			/* A HWPoisoned page cannot be also PageBuddy */
 			pfn++;
--- a/mm/page_owner.c~mm-rename-page_order-to-buddy_order
+++ a/mm/page_owner.c
@@ -295,7 +295,7 @@ void pagetypeinfo_showmixedcount_print(s
 			if (PageBuddy(page)) {
 				unsigned long freepage_order;
 
-				freepage_order = page_order_unsafe(page);
+				freepage_order = buddy_order_unsafe(page);
 				if (freepage_order < MAX_ORDER)
 					pfn += (1UL << freepage_order) - 1;
 				continue;
@@ -490,7 +490,7 @@ read_page_owner(struct file *file, char
 
 		page = pfn_to_page(pfn);
 		if (PageBuddy(page)) {
-			unsigned long freepage_order = page_order_unsafe(page);
+			unsigned long freepage_order = buddy_order_unsafe(page);
 
 			if (freepage_order < MAX_ORDER)
 				pfn += (1UL << freepage_order) - 1;
@@ -584,7 +584,7 @@ static void init_pages_in_zone(pg_data_t
 			 * heavy lock contention.
 			 */
 			if (PageBuddy(page)) {
-				unsigned long order = page_order_unsafe(page);
+				unsigned long order = buddy_order_unsafe(page);
 
 				if (order > 0 && order < MAX_ORDER)
 					pfn += (1UL << order) - 1;
--- a/mm/page_reporting.c~mm-rename-page_order-to-buddy_order
+++ a/mm/page_reporting.c
@@ -92,7 +92,7 @@ page_reporting_drain(struct page_reporti
 		 * report on the new larger page when we make our way
 		 * up to that higher order.
 		 */
-		if (PageBuddy(page) && page_order(page) == order)
+		if (PageBuddy(page) && buddy_order(page) == order)
 			__SetPageReported(page);
 	} while ((sg = sg_next(sg)));
 
--- a/mm/shuffle.c~mm-rename-page_order-to-buddy_order
+++ a/mm/shuffle.c
@@ -60,7 +60,7 @@ static struct page * __meminit shuffle_v
 	 * ...is the page on the same list as the page we will
 	 * shuffle it with?
 	 */
-	if (page_order(page) != order)
+	if (buddy_order(page) != order)
 		return NULL;
 
 	return page;
_
