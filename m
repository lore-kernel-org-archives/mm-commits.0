Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96420C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 22:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234107AbiDDW2K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 18:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbiDDW1K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 18:27:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903B032071
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 14:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E322614EA
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 21:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A9AC2BBE4;
        Mon,  4 Apr 2022 21:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649109048;
        bh=W+/ysKZDvvnwI+kXnd5MZrebMyXN5Xg8yIdDD0vrw5g=;
        h=Date:To:From:Subject:From;
        b=YubZdk5nuPn9IOV80hSvbnFNbgK1NTFN65uazXKeW61k/6plnKqtiT6QnfoGStig0
         MHD9E/f9LDkHUUXZKhSvmBCA69gbXGjDI6k6P5ZyOBIHv1pHgIKziBg0lTSzwOOKFJ
         DGsnPFUHvZbZfjBxzDz8EspI47gZWxRDh+Zj6Jqg=
Date:   Mon, 04 Apr 2022 14:50:47 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz,
        torvalds@linux-foundation.org, rppt@kernel.org,
        rostedt@goodmis.org, osalvador@suse.de,
        mgorman@techsingularity.net, david@redhat.com, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch added to -mm tree
Message-Id: <20220404215048.01A9AC2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: wrap __find_buddy_pfn() with a necessary buddy page validation
has been added to the -mm tree.  Its filename is
     mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: wrap __find_buddy_pfn() with a necessary buddy page validation

Whenever the buddy of a page is found from __find_buddy_pfn(),
page_is_buddy() should be used to check its validity. Add a helper
function find_buddy_page_pfn() to find the buddy page and do the check
together.

Link: https://lkml.kernel.org/r/20220401230804.1658207-2-zi.yan@sent.com
Link: https://lore.kernel.org/linux-mm/CAHk-=wji_AmYygZMTsPMdJ7XksMt7kOur8oDfDdniBRMjm4VkQ@mail.gmail.com/
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h       |  117 ++++++++++++++++++++++++++++++++----------
 mm/page_alloc.c     |   52 ++----------------
 mm/page_isolation.c |    9 +--
 3 files changed, 101 insertions(+), 77 deletions(-)

--- a/mm/internal.h~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation
+++ a/mm/internal.h
@@ -212,6 +212,67 @@ struct alloc_context {
 };
 
 /*
+ * This function returns the order of a free page in the buddy system. In
+ * general, page_zone(page)->lock must be held by the caller to prevent the
+ * page from being allocated in parallel and returning garbage as the order.
+ * If a caller does not hold page_zone(page)->lock, it must guarantee that the
+ * page cannot be allocated or merged in parallel. Alternatively, it must
+ * handle invalid values gracefully, and use buddy_order_unsafe() below.
+ */
+static inline unsigned int buddy_order(struct page *page)
+{
+	/* PageBuddy() must be checked by the caller */
+	return page_private(page);
+}
+
+/*
+ * Like buddy_order(), but for callers who cannot afford to hold the zone lock.
+ * PageBuddy() should be checked first by the caller to minimize race window,
+ * and invalid values must be handled gracefully.
+ *
+ * READ_ONCE is used so that if the caller assigns the result into a local
+ * variable and e.g. tests it for valid range before using, the compiler cannot
+ * decide to remove the variable and inline the page_private(page) multiple
+ * times, potentially observing different values in the tests and the actual
+ * use of the result.
+ */
+#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
+
+/*
+ * This function checks whether a page is free && is the buddy
+ * we can coalesce a page and its buddy if
+ * (a) the buddy is not in a hole (check before calling!) &&
+ * (b) the buddy is in the buddy system &&
+ * (c) a page and its buddy have the same order &&
+ * (d) a page and its buddy are in the same zone.
+ *
+ * For recording whether a page is in the buddy system, we set PageBuddy.
+ * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
+ *
+ * For recording page's order, we use page_private(page).
+ */
+static inline bool page_is_buddy(struct page *page, struct page *buddy,
+							unsigned int order)
+{
+	if (!page_is_guard(buddy) && !PageBuddy(buddy))
+		return false;
+
+	if (buddy_order(buddy) != order)
+		return false;
+
+	/*
+	 * zone check is done late to avoid uselessly calculating
+	 * zone/node ids for pages that could never merge.
+	 */
+	if (page_zone_id(page) != page_zone_id(buddy))
+		return false;
+
+	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
+
+	return true;
+}
+
+/*
  * Locate the struct page for both the matching buddy in our
  * pair (buddy1) and the combined O(n+1) page they form (page).
  *
@@ -234,6 +295,35 @@ __find_buddy_pfn(unsigned long page_pfn,
 	return page_pfn ^ (1 << order);
 }
 
+/*
+ * Find the buddy of @page and validate it.
+ * @page: The input page
+ * @pfn: The pfn of the page, it saves a call to page_to_pfn() when the
+ *       function is used in the performance-critical __free_one_page().
+ * @order: The order of the page
+ * @buddy_pfn: The output pointer to the buddy pfn, it also saves a call to
+ *             page_to_pfn().
+ *
+ * The found buddy can be a non PageBuddy, out of @page's zone, or its order is
+ * not the same as @page. The validation is necessary before use it.
+ *
+ * Return: the found buddy page or NULL if not found.
+ */
+static inline struct page *find_buddy_page_pfn(struct page *page,
+			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
+{
+	struct page *buddy;
+	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
+
+	buddy = page + (__buddy_pfn - pfn);
+	if (buddy_pfn)
+		*buddy_pfn = __buddy_pfn;
+
+	if (page_is_buddy(page, buddy, order))
+		return buddy;
+	return NULL;
+}
+
 extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone);
 
@@ -337,33 +427,6 @@ int find_suitable_fallback(struct free_a
 			int migratetype, bool only_stealable, bool *can_steal);
 
 /*
- * This function returns the order of a free page in the buddy system. In
- * general, page_zone(page)->lock must be held by the caller to prevent the
- * page from being allocated in parallel and returning garbage as the order.
- * If a caller does not hold page_zone(page)->lock, it must guarantee that the
- * page cannot be allocated or merged in parallel. Alternatively, it must
- * handle invalid values gracefully, and use buddy_order_unsafe() below.
- */
-static inline unsigned int buddy_order(struct page *page)
-{
-	/* PageBuddy() must be checked by the caller */
-	return page_private(page);
-}
-
-/*
- * Like buddy_order(), but for callers who cannot afford to hold the zone lock.
- * PageBuddy() should be checked first by the caller to minimize race window,
- * and invalid values must be handled gracefully.
- *
- * READ_ONCE is used so that if the caller assigns the result into a local
- * variable and e.g. tests it for valid range before using, the compiler cannot
- * decide to remove the variable and inline the page_private(page) multiple
- * times, potentially observing different values in the tests and the actual
- * use of the result.
- */
-#define buddy_order_unsafe(page)	READ_ONCE(page_private(page))
-
-/*
  * These three helpers classifies VMAs for virtual memory accounting.
  */
 
--- a/mm/page_alloc.c~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation
+++ a/mm/page_alloc.c
@@ -868,40 +868,6 @@ static inline void set_buddy_order(struc
 	__SetPageBuddy(page);
 }
 
-/*
- * This function checks whether a page is free && is the buddy
- * we can coalesce a page and its buddy if
- * (a) the buddy is not in a hole (check before calling!) &&
- * (b) the buddy is in the buddy system &&
- * (c) a page and its buddy have the same order &&
- * (d) a page and its buddy are in the same zone.
- *
- * For recording whether a page is in the buddy system, we set PageBuddy.
- * Setting, clearing, and testing PageBuddy is serialized by zone->lock.
- *
- * For recording page's order, we use page_private(page).
- */
-static inline bool page_is_buddy(struct page *page, struct page *buddy,
-							unsigned int order)
-{
-	if (!page_is_guard(buddy) && !PageBuddy(buddy))
-		return false;
-
-	if (buddy_order(buddy) != order)
-		return false;
-
-	/*
-	 * zone check is done late to avoid uselessly calculating
-	 * zone/node ids for pages that could never merge.
-	 */
-	if (page_zone_id(page) != page_zone_id(buddy))
-		return false;
-
-	VM_BUG_ON_PAGE(page_count(buddy) != 0, buddy);
-
-	return true;
-}
-
 #ifdef CONFIG_COMPACTION
 static inline struct capture_control *task_capc(struct zone *zone)
 {
@@ -1010,18 +976,17 @@ static inline bool
 buddy_merge_likely(unsigned long pfn, unsigned long buddy_pfn,
 		   struct page *page, unsigned int order)
 {
-	struct page *higher_page, *higher_buddy;
-	unsigned long combined_pfn;
+	struct page *higher_page;
+	unsigned long higher_page_pfn;
 
 	if (order >= MAX_ORDER - 2)
 		return false;
 
-	combined_pfn = buddy_pfn & pfn;
-	higher_page = page + (combined_pfn - pfn);
-	buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
-	higher_buddy = higher_page + (buddy_pfn - combined_pfn);
+	higher_page_pfn = buddy_pfn & pfn;
+	higher_page = page + (higher_page_pfn - pfn);
 
-	return page_is_buddy(higher_page, higher_buddy, order + 1);
+	return find_buddy_page_pfn(higher_page, higher_page_pfn, order + 1,
+			NULL) != NULL;
 }
 
 /*
@@ -1075,10 +1040,9 @@ static inline void __free_one_page(struc
 								migratetype);
 			return;
 		}
-		buddy_pfn = __find_buddy_pfn(pfn, order);
-		buddy = page + (buddy_pfn - pfn);
 
-		if (!page_is_buddy(page, buddy, order))
+		buddy = find_buddy_page_pfn(page, pfn, order, &buddy_pfn);
+		if (!buddy)
 			goto done_merging;
 
 		if (unlikely(order >= pageblock_order)) {
--- a/mm/page_isolation.c~mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation
+++ a/mm/page_isolation.c
@@ -70,7 +70,6 @@ static void unset_migratetype_isolate(st
 	unsigned long flags, nr_pages;
 	bool isolated_page = false;
 	unsigned int order;
-	unsigned long pfn, buddy_pfn;
 	struct page *buddy;
 
 	zone = page_zone(page);
@@ -89,11 +88,9 @@ static void unset_migratetype_isolate(st
 	if (PageBuddy(page)) {
 		order = buddy_order(page);
 		if (order >= pageblock_order && order < MAX_ORDER - 1) {
-			pfn = page_to_pfn(page);
-			buddy_pfn = __find_buddy_pfn(pfn, order);
-			buddy = page + (buddy_pfn - pfn);
-
-			if (!is_migrate_isolate_page(buddy)) {
+			buddy = find_buddy_page_pfn(page, page_to_pfn(page),
+						    order, NULL);
+			if (buddy && !is_migrate_isolate_page(buddy)) {
 				isolated_page = !!__isolate_free_page(page, order);
 				/*
 				 * Isolating a free page in an isolated pageblock
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-migrate-use-thp_order-instead-of-hpage_pmd_order-for-new-page-allocation.patch
mm-page_alloc-simplify-pageblock-migratetype-check-in-__free_one_page.patch
mm-wrap-__find_buddy_pfn-with-a-necessary-buddy-page-validation.patch

