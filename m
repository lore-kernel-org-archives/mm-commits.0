Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FE9C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiJCVLH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJCVJH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBABD4F6BC
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 034026118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5770DC433C1;
        Mon,  3 Oct 2022 21:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831195;
        bh=hp/CEycZnnCPSXdFbIMu9mIy+swAgByeroyQklFoo3c=;
        h=Date:To:From:Subject:From;
        b=cm2AA/bzzMoZ8VNzrQbacdKKsz/A95xL6W8Mmmdfv0xrE/VTAbUOA6Tg6vQZgLpHr
         dCZJ/jQw6wKc9DwHHBp22ehPi1vYFzBd/eZx4sGWerSwHl3kqwFLoFp67D9eDl7oWr
         UBB0DurjhOUyRRhEo7sTKpTmHMq6idm1jcJNK11k=
Date:   Mon, 03 Oct 2022 14:06:34 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        osalvador@suse.de, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-reuse-pageblock_start-end_pfn-macro.patch removed from -mm tree
Message-Id: <20221003210635.5770DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: reuse pageblock_start/end_pfn() macro
has been removed from the -mm tree.  Its filename was
     mm-reuse-pageblock_start-end_pfn-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: reuse pageblock_start/end_pfn() macro
Date: Wed, 7 Sep 2022 14:08:42 +0800

Move pageblock_start_pfn/pageblock_end_pfn() into pageblock-flags.h, then
they could be used somewhere else, not only in compaction, also use
ALIGN_DOWN() instead of round_down() to be pair with ALIGN(), which should
be same for pageblock usage.

Link: https://lkml.kernel.org/r/20220907060844.126891-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageblock-flags.h |    2 ++
 mm/compaction.c                 |    2 --
 mm/memblock.c                   |    2 +-
 mm/page_alloc.c                 |   13 ++++++-------
 mm/page_isolation.c             |   11 +++++------
 mm/page_owner.c                 |    4 ++--
 6 files changed, 16 insertions(+), 18 deletions(-)

--- a/include/linux/pageblock-flags.h~mm-reuse-pageblock_start-end_pfn-macro
+++ a/include/linux/pageblock-flags.h
@@ -53,6 +53,8 @@ extern unsigned int pageblock_order;
 #endif /* CONFIG_HUGETLB_PAGE */
 
 #define pageblock_nr_pages	(1UL << pageblock_order)
+#define pageblock_start_pfn(pfn)	ALIGN_DOWN((pfn), pageblock_nr_pages)
+#define pageblock_end_pfn(pfn)		ALIGN((pfn) + 1, pageblock_nr_pages)
 
 /* Forward declaration */
 struct page;
--- a/mm/compaction.c~mm-reuse-pageblock_start-end_pfn-macro
+++ a/mm/compaction.c
@@ -52,8 +52,6 @@ static inline void count_compact_events(
 
 #define block_start_pfn(pfn, order)	round_down(pfn, 1UL << (order))
 #define block_end_pfn(pfn, order)	ALIGN((pfn) + 1, 1UL << (order))
-#define pageblock_start_pfn(pfn)	block_start_pfn(pfn, pageblock_order)
-#define pageblock_end_pfn(pfn)		block_end_pfn(pfn, pageblock_order)
 
 /*
  * Page order with-respect-to which proactive compaction
--- a/mm/memblock.c~mm-reuse-pageblock_start-end_pfn-macro
+++ a/mm/memblock.c
@@ -2000,7 +2000,7 @@ static void __init free_unused_memmap(vo
 		 * presume that there are no holes in the memory map inside
 		 * a pageblock
 		 */
-		start = round_down(start, pageblock_nr_pages);
+		start = pageblock_start_pfn(start);
 
 		/*
 		 * If we had a previous bank, and there is a space
--- a/mm/page_alloc.c~mm-reuse-pageblock_start-end_pfn-macro
+++ a/mm/page_alloc.c
@@ -544,7 +544,7 @@ static inline int pfn_to_bitidx(const st
 #ifdef CONFIG_SPARSEMEM
 	pfn &= (PAGES_PER_SECTION-1);
 #else
-	pfn = pfn - round_down(page_zone(page)->zone_start_pfn, pageblock_nr_pages);
+	pfn = pfn - pageblock_start_pfn(page_zone(page)->zone_start_pfn);
 #endif /* CONFIG_SPARSEMEM */
 	return (pfn >> pageblock_order) * NR_PAGEBLOCK_BITS;
 }
@@ -1857,7 +1857,7 @@ void set_zone_contiguous(struct zone *zo
 	unsigned long block_start_pfn = zone->zone_start_pfn;
 	unsigned long block_end_pfn;
 
-	block_end_pfn = ALIGN(block_start_pfn + 1, pageblock_nr_pages);
+	block_end_pfn = pageblock_end_pfn(block_start_pfn);
 	for (; block_start_pfn < zone_end_pfn(zone);
 			block_start_pfn = block_end_pfn,
 			 block_end_pfn += pageblock_nr_pages) {
@@ -2653,8 +2653,8 @@ int move_freepages_block(struct zone *zo
 		*num_movable = 0;
 
 	pfn = page_to_pfn(page);
-	start_pfn = pfn & ~(pageblock_nr_pages - 1);
-	end_pfn = start_pfn + pageblock_nr_pages - 1;
+	start_pfn = pageblock_start_pfn(pfn);
+	end_pfn = pageblock_end_pfn(pfn) - 1;
 
 	/* Do not cross zone boundaries */
 	if (!zone_spans_pfn(zone, start_pfn))
@@ -6934,9 +6934,8 @@ static void __init init_unavailable_rang
 	u64 pgcnt = 0;
 
 	for (pfn = spfn; pfn < epfn; pfn++) {
-		if (!pfn_valid(ALIGN_DOWN(pfn, pageblock_nr_pages))) {
-			pfn = ALIGN_DOWN(pfn, pageblock_nr_pages)
-				+ pageblock_nr_pages - 1;
+		if (!pfn_valid(pageblock_start_pfn(pfn))) {
+			pfn = pageblock_end_pfn(pfn) - 1;
 			continue;
 		}
 		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
--- a/mm/page_isolation.c~mm-reuse-pageblock_start-end_pfn-macro
+++ a/mm/page_isolation.c
@@ -37,8 +37,8 @@ static struct page *has_unmovable_pages(
 	struct zone *zone = page_zone(page);
 	unsigned long pfn;
 
-	VM_BUG_ON(ALIGN_DOWN(start_pfn, pageblock_nr_pages) !=
-		  ALIGN_DOWN(end_pfn - 1, pageblock_nr_pages));
+	VM_BUG_ON(pageblock_start_pfn(start_pfn) !=
+		  pageblock_start_pfn(end_pfn - 1));
 
 	if (is_migrate_cma_page(page)) {
 		/*
@@ -172,7 +172,7 @@ static int set_migratetype_isolate(struc
 	 * to avoid redundant checks.
 	 */
 	check_unmovable_start = max(page_to_pfn(page), start_pfn);
-	check_unmovable_end = min(ALIGN(page_to_pfn(page) + 1, pageblock_nr_pages),
+	check_unmovable_end = min(pageblock_end_pfn(page_to_pfn(page)),
 				  end_pfn);
 
 	unmovable = has_unmovable_pages(check_unmovable_start, check_unmovable_end,
@@ -532,7 +532,7 @@ int start_isolate_page_range(unsigned lo
 	unsigned long pfn;
 	struct page *page;
 	/* isolation is done at page block granularity */
-	unsigned long isolate_start = ALIGN_DOWN(start_pfn, pageblock_nr_pages);
+	unsigned long isolate_start = pageblock_start_pfn(start_pfn);
 	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
 	int ret;
 	bool skip_isolation = false;
@@ -579,10 +579,9 @@ void undo_isolate_page_range(unsigned lo
 {
 	unsigned long pfn;
 	struct page *page;
-	unsigned long isolate_start = ALIGN_DOWN(start_pfn, pageblock_nr_pages);
+	unsigned long isolate_start = pageblock_start_pfn(start_pfn);
 	unsigned long isolate_end = ALIGN(end_pfn, pageblock_nr_pages);
 
-
 	for (pfn = isolate_start;
 	     pfn < isolate_end;
 	     pfn += pageblock_nr_pages) {
--- a/mm/page_owner.c~mm-reuse-pageblock_start-end_pfn-macro
+++ a/mm/page_owner.c
@@ -297,7 +297,7 @@ void pagetypeinfo_showmixedcount_print(s
 			continue;
 		}
 
-		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+		block_end_pfn = pageblock_end_pfn(pfn);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
 		pageblock_mt = get_pageblock_migratetype(page);
@@ -635,7 +635,7 @@ static void init_pages_in_zone(pg_data_t
 			continue;
 		}
 
-		block_end_pfn = ALIGN(pfn + 1, pageblock_nr_pages);
+		block_end_pfn = pageblock_end_pfn(pfn);
 		block_end_pfn = min(block_end_pfn, end_pfn);
 
 		for (; pfn < block_end_pfn; pfn++) {
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


