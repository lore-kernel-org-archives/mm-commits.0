Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84306C07E95
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 623B261374
	for <mm-commits@archiver.kernel.org>; Wed, 14 Jul 2021 01:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbhGNBU4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237232AbhGNBU4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Jul 2021 21:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F41FB61370;
        Wed, 14 Jul 2021 01:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626225485;
        bh=8he41gLTTy1QhCp/vbisCdC5Q7IyUznKMTBMZAy7ANs=;
        h=Date:From:To:Subject:From;
        b=nYSnFYAOEfoF9ctn+hXMcNwgVp4YMW0GcTpaQA+wJgB/52wJgTa71RUht5ztJxp2W
         yilpdJoWJaEVvqDc2awwLDIc6FC+IFeTrOPI/fW24/xc3r3++/mLVBwcRLP1NKhfAJ
         iewY0DPTcSEn3o0fGDQA5exaY3E/rIKJ4/WBW130=
Date:   Tue, 13 Jul 2021 18:18:04 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mm-commits@vger.kernel.org, rppt@linux.ibm.com
Subject:  +
 mm-remove-pfn_valid_within-and-config_holes_in_zone.patch added to -mm tree
Message-ID: <20210714011804.51ui1EIQx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove pfn_valid_within() and CONFIG_HOLES_IN_ZONE
has been added to the -mm tree.  Its filename is
     mm-remove-pfn_valid_within-and-config_holes_in_zone.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-pfn_valid_within-and-config_holes_in_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -1524,18 +1524,6 @@ void sparse_init(void);
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
 
@@ -1022,16 +1020,12 @@ buddy_merge_likely(unsigned long pfn, un
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
@@ -1092,8 +1086,6 @@ continue_merging:
 		buddy_pfn = __find_buddy_pfn(pfn, order);
 		buddy = page + (buddy_pfn - pfn);
 
-		if (!pfn_valid_within(buddy_pfn))
-			goto done_merging;
 		if (!page_is_buddy(page, buddy, order))
 			goto done_merging;
 		/*
@@ -1751,9 +1743,7 @@ void __init memblock_free_pages(struct p
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
@@ -1869,8 +1859,6 @@ static inline void __init pgdat_init_rep
  */
 static inline bool __init deferred_pfn_valid(unsigned long pfn)
 {
-	if (!pfn_valid_within(pfn))
-		return false;
 	if (!(pfn & (pageblock_nr_pages - 1)) && !pfn_valid(pfn))
 		return false;
 	return true;
@@ -2517,11 +2505,6 @@ static int move_freepages(struct zone *z
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
@@ -8812,9 +8795,6 @@ struct page *has_unmovable_pages(struct
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

Patches currently in -mm which might be from rppt@linux.ibm.com are

mm-remove-pfn_valid_within-and-config_holes_in_zone.patch
mm-memory_hotplug-cleanup-after-removal-of-pfn_valid_within.patch

