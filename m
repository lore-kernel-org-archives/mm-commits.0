Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F14DC433F5
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B87861100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:55:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347323AbhIHC4E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:56:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347384AbhIHC4A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29E7D61100;
        Wed,  8 Sep 2021 02:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069693;
        bh=HS4dHXx9c1Z/5+ETrS4U6aOhoRGbWMpLLwP0r9y6aPc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xcm8GW52N0aqcbcXEwaGqCK2+D3ERirajwqv1PxW9BjbmkpoL2JVSSR7AiWu249Kl
         MMbbKI2xufn0uNLxf2luCu0XxpbFsFbKZWXLUqXIachvG0riWjAN5nlPzJZDHioBYU
         IfJRW4xeYyTQg6kdgGSVw30cTTevNlnTc5848PeI=
Date:   Tue, 07 Sep 2021 19:54:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        gregkh@linuxfoundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rafael@kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 036/147] mm: remove pfn_valid_within() and
 CONFIG_HOLES_IN_ZONE
Message-ID: <20210908025452.SQQ0i3M0D%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE

Patch series "mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE".

After recent updates to freeing unused parts of the memory map, no
architecture can have holes in the memory map within a pageblock.  This
makes pfn_valid_within() check and CONFIG_HOLES_IN_ZONE configuration
option redundant.

The first patch removes them both in a mechanical way and the second patch
simplifies memory_hotplug::test_pages_in_a_zone() that had
pfn_valid_within() surrounded by more logic than simple if.


This patch (of 2):

After recent changes in freeing of the unused parts of the memory map and
rework of pfn_valid() in arm and arm64 there are no architectures that can
have holes in the memory map within a pageblock and so nothing can enable
CONFIG_HOLES_IN_ZONE which guards non trivial implementation of
pfn_valid_within().

With that, pfn_valid_within() is always hardwired to 1 and can be
completely removed.

Remove calls to pfn_valid_within() and CONFIG_HOLES_IN_ZONE.

Link: https://lkml.kernel.org/r/20210713080035.7464-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210713080035.7464-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c    |    2 --
 include/linux/mmzone.h |   12 ------------
 mm/Kconfig             |    3 ---
 mm/compaction.c        |   20 +++++++-------------
 mm/memory_hotplug.c    |    4 ----
 mm/page_alloc.c        |   24 ++----------------------
 mm/page_isolation.c    |    7 +------
 mm/page_owner.c        |   14 +-------------
 8 files changed, 11 insertions(+), 75 deletions(-)

--- a/drivers/base/node.c~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/drivers/base/node.c
@@ -768,8 +768,6 @@ int unregister_cpu_under_node(unsigned i
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
 static int __ref get_nid_for_pfn(unsigned long pfn)
 {
-	if (!pfn_valid_within(pfn))
-		return -1;
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 	if (system_state < SYSTEM_RUNNING)
 		return early_pfn_to_nid(pfn);
--- a/include/linux/mmzone.h~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/include/linux/mmzone.h
@@ -1525,18 +1525,6 @@ void sparse_init(void);
 #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
-/*
- * If it is possible to have holes within a MAX_ORDER_NR_PAGES, then we
- * need to check pfn validity within that MAX_ORDER_NR_PAGES block.
- * pfn_valid_within() should be used in this case; we optimise this away
- * when we have no holes within a MAX_ORDER_NR_PAGES block.
- */
-#ifdef CONFIG_HOLES_IN_ZONE
-#define pfn_valid_within(pfn) pfn_valid(pfn)
-#else
-#define pfn_valid_within(pfn) (1)
-#endif
-
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
--- a/mm/compaction.c~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/mm/compaction.c
@@ -306,16 +306,14 @@ __reset_isolation_pfn(struct zone *zone,
 	 * is necessary for the block to be a migration source/target.
 	 */
 	do {
-		if (pfn_valid_within(pfn)) {
-			if (check_source && PageLRU(page)) {
-				clear_pageblock_skip(page);
-				return true;
-			}
+		if (check_source && PageLRU(page)) {
+			clear_pageblock_skip(page);
+			return true;
+		}
 
-			if (check_target && PageBuddy(page)) {
-				clear_pageblock_skip(page);
-				return true;
-			}
+		if (check_target && PageBuddy(page)) {
+			clear_pageblock_skip(page);
+			return true;
 		}
 
 		page += (1 << PAGE_ALLOC_COSTLY_ORDER);
@@ -585,8 +583,6 @@ static unsigned long isolate_freepages_b
 			break;
 
 		nr_scanned++;
-		if (!pfn_valid_within(blockpfn))
-			goto isolate_fail;
 
 		/*
 		 * For compound pages such as THP and hugetlbfs, we can save
@@ -885,8 +881,6 @@ isolate_migratepages_block(struct compac
 			cond_resched();
 		}
 
-		if (!pfn_valid_within(low_pfn))
-			goto isolate_fail;
 		nr_scanned++;
 
 		page = pfn_to_page(low_pfn);
--- a/mm/Kconfig~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/mm/Kconfig
@@ -96,9 +96,6 @@ config HAVE_FAST_GUP
 	depends on MMU
 	bool
 
-config HOLES_IN_ZONE
-	bool
-
 # Don't discard allocated memory used to track "memory" and "reserved" memblocks
 # after early boot, so it can still be used to test for validity of memory.
 # Also, memblocks are updated with memory hot(un)plug.
--- a/mm/memory_hotplug.c~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/mm/memory_hotplug.c
@@ -1308,10 +1308,6 @@ struct zone *test_pages_in_a_zone(unsign
 		for (; pfn < sec_end_pfn && pfn < end_pfn;
 		     pfn += MAX_ORDER_NR_PAGES) {
 			i = 0;
-			/* This is just a CONFIG_HOLES_IN_ZONE check.*/
-			while ((i < MAX_ORDER_NR_PAGES) &&
-				!pfn_valid_within(pfn + i))
-				i++;
 			if (i == MAX_ORDER_NR_PAGES || pfn + i >= end_pfn)
 				continue;
 			/* Check if we got outside of the zone */
--- a/mm/page_alloc.c~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/mm/page_alloc.c
@@ -594,8 +594,6 @@ static int page_outside_zone_boundaries(
 
 static int page_is_consistent(struct zone *zone, struct page *page)
 {
-	if (!pfn_valid_within(page_to_pfn(page)))
-		return 0;
 	if (zone != page_zone(page))
 		return 0;
 
@@ -1025,16 +1023,12 @@ buddy_merge_likely(unsigned long pfn, un
 	if (order >= MAX_ORDER - 2)
 		return false;
 
-	if (!pfn_valid_within(buddy_pfn))
-		return false;
-
 	combined_pfn = buddy_pfn & pfn;
 	higher_page = page + (combined_pfn - pfn);
 	buddy_pfn = __find_buddy_pfn(combined_pfn, order + 1);
 	higher_buddy = higher_page + (buddy_pfn - combined_pfn);
 
-	return pfn_valid_within(buddy_pfn) &&
-	       page_is_buddy(higher_page, higher_buddy, order + 1);
+	return page_is_buddy(higher_page, higher_buddy, order + 1);
 }
 
 /*
@@ -1095,8 +1089,6 @@ continue_merging:
 		buddy_pfn = __find_buddy_pfn(pfn, order);
 		buddy = page + (buddy_pfn - pfn);
 
-		if (!pfn_valid_within(buddy_pfn))
-			goto done_merging;
 		if (!page_is_buddy(page, buddy, order))
 			goto done_merging;
 		/*
@@ -1754,9 +1746,7 @@ void __init memblock_free_pages(struct p
 /*
  * Check that the whole (or subset of) a pageblock given by the interval of
  * [start_pfn, end_pfn) is valid and within the same zone, before scanning it
- * with the migration of free compaction scanner. The scanners then need to
- * use only pfn_valid_within() check for arches that allow holes within
- * pageblocks.
+ * with the migration of free compaction scanner.
  *
  * Return struct page pointer of start_pfn, or NULL if checks were not passed.
  *
@@ -1872,8 +1862,6 @@ static inline void __init pgdat_init_rep
  */
 static inline bool __init deferred_pfn_valid(unsigned long pfn)
 {
-	if (!pfn_valid_within(pfn))
-		return false;
 	if (!(pfn & (pageblock_nr_pages - 1)) && !pfn_valid(pfn))
 		return false;
 	return true;
@@ -2520,11 +2508,6 @@ static int move_freepages(struct zone *z
 	int pages_moved = 0;
 
 	for (pfn = start_pfn; pfn <= end_pfn;) {
-		if (!pfn_valid_within(pfn)) {
-			pfn++;
-			continue;
-		}
-
 		page = pfn_to_page(pfn);
 		if (!PageBuddy(page)) {
 			/*
@@ -8828,9 +8811,6 @@ struct page *has_unmovable_pages(struct
 	}
 
 	for (; iter < pageblock_nr_pages - offset; iter++) {
-		if (!pfn_valid_within(pfn + iter))
-			continue;
-
 		page = pfn_to_page(pfn + iter);
 
 		/*
--- a/mm/page_isolation.c~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/mm/page_isolation.c
@@ -93,8 +93,7 @@ static void unset_migratetype_isolate(st
 			buddy_pfn = __find_buddy_pfn(pfn, order);
 			buddy = page + (buddy_pfn - pfn);
 
-			if (pfn_valid_within(buddy_pfn) &&
-			    !is_migrate_isolate_page(buddy)) {
+			if (!is_migrate_isolate_page(buddy)) {
 				__isolate_free_page(page, order);
 				isolated_page = true;
 			}
@@ -250,10 +249,6 @@ __test_page_isolated_in_pageblock(unsign
 	struct page *page;
 
 	while (pfn < end_pfn) {
-		if (!pfn_valid_within(pfn)) {
-			pfn++;
-			continue;
-		}
 		page = pfn_to_page(pfn);
 		if (PageBuddy(page))
 			/*
--- a/mm/page_owner.c~mm-remove-pfn_valid_within-and-config_holes_in_zone
+++ a/mm/page_owner.c
@@ -276,9 +276,6 @@ void pagetypeinfo_showmixedcount_print(s
 		pageblock_mt = get_pageblock_migratetype(page);
 
 		for (; pfn < block_end_pfn; pfn++) {
-			if (!pfn_valid_within(pfn))
-				continue;
-
 			/* The pageblock is online, no need to recheck. */
 			page = pfn_to_page(pfn);
 
@@ -479,10 +476,6 @@ read_page_owner(struct file *file, char
 			continue;
 		}
 
-		/* Check for holes within a MAX_ORDER area */
-		if (!pfn_valid_within(pfn))
-			continue;
-
 		page = pfn_to_page(pfn);
 		if (PageBuddy(page)) {
 			unsigned long freepage_order = buddy_order_unsafe(page);
@@ -560,14 +553,9 @@ static void init_pages_in_zone(pg_data_t
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
 		for (; pfn < block_end_pfn; pfn++) {
-			struct page *page;
+			struct page *page = pfn_to_page(pfn);
 			struct page_ext *page_ext;
 
-			if (!pfn_valid_within(pfn))
-				continue;
-
-			page = pfn_to_page(pfn);
-
 			if (page_zone(page) != zone)
 				continue;
 
_
