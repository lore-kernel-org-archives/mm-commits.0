Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923E6C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383812AbiEMTWT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383754AbiEMTVa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D36E37A9F
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06BACB83132
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C25C34100;
        Fri, 13 May 2022 19:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469684;
        bh=KqJUgMtkHf+gcVWXRYHKZnRNRtyLckZFnx0ATgdcYDk=;
        h=Date:To:From:Subject:From;
        b=EiT5Y3FhIJI55YaXPw5ybAn7LcjBbZpM236CE4BPb+GkxSFhRS4eyzWjXBNTOv5ih
         OTNfl7kYv4n83+ScDzwuB0YBhPjWFWiKFHJIgqo3NDMMWYeH6uGO/htHl+p9OkiXe0
         BPnb61XBCt2ZoPN4GnVACTVgvcERokHIJXlj3ODw=
Date:   Fri, 13 May 2022 12:21:24 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rppt@linux.ibm.com,
        renzhengeek@gmail.com, osalvador@suse.de, minchan@kernel.org,
        mgorman@techsingularity.net, lkp@intel.com, david@redhat.com,
        christophe.leroy@csgroup.eu, ziy@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-alloc_contig_range-work-at-pageblock-granularity.patch removed from -mm tree
Message-Id: <20220513192124.A7C25C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: make alloc_contig_range work at pageblock granularity
has been removed from the -mm tree.  Its filename was
     mm-make-alloc_contig_range-work-at-pageblock-granularity.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm: make alloc_contig_range work at pageblock granularity

alloc_contig_range() worked at MAX_ORDER_NR_PAGES granularity to avoid
merging pageblocks with different migratetypes.  It might unnecessarily
convert extra pageblocks at the beginning and at the end of the range. 
Change alloc_contig_range() to work at pageblock granularity.

Special handling is needed for free pages and in-use pages across the
boundaries of the range specified by alloc_contig_range().  Because these=

Partially isolated pages causes free page accounting issues.  The free
pages will be split and freed into separate migratetype lists; the in-use=

Pages will be migrated then the freed pages will be handled in the
aforementioned way.

[ziy@nvidia.com: fix deadlock/crash]
  Link: https://lkml.kernel.org/r/23A7297E-6C84-4138-A9FE-3598234004E6@nvidia.com
Link: https://lkml.kernel.org/r/20220425143118.2850746-4-zi.yan@sent.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: Eric Ren <renzhengeek@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-isolation.h |    4 
 mm/internal.h                  |    6 
 mm/memory_hotplug.c            |    3 
 mm/page_alloc.c                |   54 +++++++-
 mm/page_isolation.c            |  193 ++++++++++++++++++++++++++++++-
 5 files changed, 242 insertions(+), 18 deletions(-)

--- a/include/linux/page-isolation.h~mm-make-alloc_contig_range-work-at-pageblock-granularity
+++ a/include/linux/page-isolation.h
@@ -42,7 +42,7 @@ int move_freepages_block(struct zone *zo
  */
 int
 start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			 unsigned migratetype, int flags);
+			 int migratetype, int flags, gfp_t gfp_flags);
 
 /*
  * Changes MIGRATE_ISOLATE to MIGRATE_MOVABLE.
@@ -50,7 +50,7 @@ start_isolate_page_range(unsigned long s
  */
 void
 undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			unsigned migratetype);
+			int migratetype);
 
 /*
  * Test all pages in [start_pfn, end_pfn) are isolated or not.
--- a/mm/internal.h~mm-make-alloc_contig_range-work-at-pageblock-granularity
+++ a/mm/internal.h
@@ -359,6 +359,9 @@ extern void *memmap_alloc(phys_addr_t si
 			  phys_addr_t min_addr,
 			  int nid, bool exact_nid);
 
+void split_free_page(struct page *free_page,
+				int order, unsigned long split_pfn_offset);
+
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
@@ -422,6 +425,9 @@ isolate_freepages_range(struct compact_c
 int
 isolate_migratepages_range(struct compact_control *cc,
 			   unsigned long low_pfn, unsigned long end_pfn);
+
+int __alloc_contig_migrate_range(struct compact_control *cc,
+					unsigned long start, unsigned long end);
 #endif
 int find_suitable_fallback(struct free_area *area, unsigned int order,
 			int migratetype, bool only_stealable, bool *can_steal);
--- a/mm/memory_hotplug.c~mm-make-alloc_contig_range-work-at-pageblock-granularity
+++ a/mm/memory_hotplug.c
@@ -1837,7 +1837,8 @@ int __ref offline_pages(unsigned long st
 	/* set above range as isolated */
 	ret = start_isolate_page_range(start_pfn, end_pfn,
 				       MIGRATE_MOVABLE,
-				       MEMORY_OFFLINE | REPORT_FAILURE);
+				       MEMORY_OFFLINE | REPORT_FAILURE,
+				       GFP_USER | __GFP_MOVABLE | __GFP_RETRY_MAYFAIL);
 	if (ret) {
 		reason = "failure to isolate range";
 		goto failed_removal_pcplists_disabled;
--- a/mm/page_alloc.c~mm-make-alloc_contig_range-work-at-pageblock-granularity
+++ a/mm/page_alloc.c
@@ -1094,6 +1094,43 @@ done_merging:
 		page_reporting_notify_free(order);
 }
 
+/**
+ * split_free_page() -- split a free page at split_pfn_offset
+ * @free_page:		the original free page
+ * @order:		the order of the page
+ * @split_pfn_offset:	split offset within the page
+ *
+ * It is used when the free page crosses two pageblocks with different migratetypes
+ * at split_pfn_offset within the page. The split free page will be put into
+ * separate migratetype lists afterwards. Otherwise, the function achieves
+ * nothing.
+ */
+void split_free_page(struct page *free_page,
+				int order, unsigned long split_pfn_offset)
+{
+	struct zone *zone = page_zone(free_page);
+	unsigned long free_page_pfn = page_to_pfn(free_page);
+	unsigned long pfn;
+	unsigned long flags;
+	int free_page_order;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	del_page_from_free_list(free_page, zone, order);
+	for (pfn = free_page_pfn;
+	     pfn < free_page_pfn + (1UL << order);) {
+		int mt = get_pfnblock_migratetype(pfn_to_page(pfn), pfn);
+
+		free_page_order = ffs(split_pfn_offset) - 1;
+		__free_one_page(pfn_to_page(pfn), pfn, zone, free_page_order,
+				mt, FPI_NONE);
+		pfn += 1UL << free_page_order;
+		split_pfn_offset -= (1UL << free_page_order);
+		/* we have done the first part, now switch to second part */
+		if (split_pfn_offset == 0)
+			split_pfn_offset = (1UL << order) - (pfn - free_page_pfn);
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
 /*
  * A bad page could be due to a number of fields. Instead of multiple branches,
  * try and check multiple fields with one check. The caller must do a detailed
@@ -8951,7 +8988,7 @@ static inline void alloc_contig_dump_pag
 #endif
 
 /* [start, end) must belong to a single zone. */
-static int __alloc_contig_migrate_range(struct compact_control *cc,
+int __alloc_contig_migrate_range(struct compact_control *cc,
 					unsigned long start, unsigned long end)
 {
 	/* This function is based on compact_zone() from compaction.c. */
@@ -9034,7 +9071,7 @@ int alloc_contig_range(unsigned long sta
 		       unsigned migratetype, gfp_t gfp_mask)
 {
 	unsigned long outer_start, outer_end;
-	unsigned int order;
+	int order;
 	int ret = 0;
 
 	struct compact_control cc = {
@@ -9053,14 +9090,11 @@ int alloc_contig_range(unsigned long sta
 	 * What we do here is we mark all pageblocks in range as
 	 * MIGRATE_ISOLATE.  Because pageblock and max order pages may
 	 * have different sizes, and due to the way page allocator
-	 * work, we align the range to biggest of the two pages so
-	 * that page allocator won't try to merge buddies from
-	 * different pageblocks and change MIGRATE_ISOLATE to some
-	 * other migration type.
+	 * work, start_isolate_page_range() has special handlings for this.
 	 *
 	 * Once the pageblocks are marked as MIGRATE_ISOLATE, we
 	 * migrate the pages from an unaligned range (ie. pages that
-	 * we are interested in).  This will put all the pages in
+	 * we are interested in). This will put all the pages in
 	 * range back to page allocator as MIGRATE_ISOLATE.
 	 *
 	 * When this is done, we take the pages in range from page
@@ -9074,9 +9108,9 @@ int alloc_contig_range(unsigned long sta
 	 */
 
 	ret = start_isolate_page_range(pfn_max_align_down(start),
-				       pfn_max_align_up(end), migratetype, 0);
+				pfn_max_align_up(end), migratetype, 0, gfp_mask);
 	if (ret)
-		return ret;
+		goto done;
 
 	drain_all_pages(cc.zone);
 
@@ -9096,7 +9130,7 @@ int alloc_contig_range(unsigned long sta
 	ret = 0;
 
 	/*
-	 * Pages from [start, end) are within a MAX_ORDER_NR_PAGES
+	 * Pages from [start, end) are within a pageblock_nr_pages
 	 * aligned blocks that are marked as MIGRATE_ISOLATE.  What's
 	 * more, all pages in [start, end) are free in page allocator.
 	 * What we are going to do is to allocate all pages from
--- a/mm/page_isolation.c~mm-make-alloc_contig_range-work-at-pageblock-granularity
+++ a/mm/page_isolation.c
@@ -203,7 +203,7 @@ static int set_migratetype_isolate(struc
 	return -EBUSY;
 }
 
-static void unset_migratetype_isolate(struct page *page, unsigned migratetype)
+static void unset_migratetype_isolate(struct page *page, int migratetype)
 {
 	struct zone *zone;
 	unsigned long flags, nr_pages;
@@ -280,6 +280,166 @@ __first_valid_page(unsigned long pfn, un
 }
 
 /**
+ * isolate_single_pageblock() -- tries to isolate a pageblock that might be
+ * within a free or in-use page.
+ * @boundary_pfn:		pageblock-aligned pfn that a page might cross
+ * @gfp_flags:			GFP flags used for migrating pages
+ * @isolate_before:	isolate the pageblock before the boundary_pfn
+ *
+ * Free and in-use pages can be as big as MAX_ORDER-1 and contain more than one
+ * pageblock. When not all pageblocks within a page are isolated at the same
+ * time, free page accounting can go wrong. For example, in the case of
+ * MAX_ORDER-1 = pageblock_order + 1, a MAX_ORDER-1 page has two pagelbocks.
+ * [         MAX_ORDER-1         ]
+ * [  pageblock0  |  pageblock1  ]
+ * When either pageblock is isolated, if it is a free page, the page is not
+ * split into separate migratetype lists, which is supposed to; if it is an
+ * in-use page and freed later, __free_one_page() does not split the free page
+ * either. The function handles this by splitting the free page or migrating
+ * the in-use page then splitting the free page.
+ */
+static int isolate_single_pageblock(unsigned long boundary_pfn, gfp_t gfp_flags,
+			bool isolate_before)
+{
+	unsigned char saved_mt;
+	unsigned long start_pfn;
+	unsigned long isolate_pageblock;
+	unsigned long pfn;
+	struct zone *zone;
+
+	VM_BUG_ON(!IS_ALIGNED(boundary_pfn, pageblock_nr_pages));
+
+	if (isolate_before)
+		isolate_pageblock = boundary_pfn - pageblock_nr_pages;
+	else
+		isolate_pageblock = boundary_pfn;
+
+	/*
+	 * scan at the beginning of MAX_ORDER_NR_PAGES aligned range to avoid
+	 * only isolating a subset of pageblocks from a bigger than pageblock
+	 * free or in-use page. Also make sure all to-be-isolated pageblocks
+	 * are within the same zone.
+	 */
+	zone  = page_zone(pfn_to_page(isolate_pageblock));
+	start_pfn  = max(ALIGN_DOWN(isolate_pageblock, MAX_ORDER_NR_PAGES),
+				      zone->zone_start_pfn);
+
+	saved_mt = get_pageblock_migratetype(pfn_to_page(isolate_pageblock));
+	set_pageblock_migratetype(pfn_to_page(isolate_pageblock), MIGRATE_ISOLATE);
+
+	/*
+	 * Bail out early when the to-be-isolated pageblock does not form
+	 * a free or in-use page across boundary_pfn:
+	 *
+	 * 1. isolate before boundary_pfn: the page after is not online
+	 * 2. isolate after boundary_pfn: the page before is not online
+	 *
+	 * This also ensures correctness. Without it, when isolate after
+	 * boundary_pfn and [start_pfn, boundary_pfn) are not online,
+	 * __first_valid_page() will return unexpected NULL in the for loop
+	 * below.
+	 */
+	if (isolate_before) {
+		if (!pfn_to_online_page(boundary_pfn))
+			return 0;
+	} else {
+		if (!pfn_to_online_page(boundary_pfn - 1))
+			return 0;
+	}
+
+	for (pfn = start_pfn; pfn < boundary_pfn;) {
+		struct page *page = __first_valid_page(pfn, boundary_pfn - pfn);
+
+		VM_BUG_ON(!page);
+		pfn = page_to_pfn(page);
+		/*
+		 * start_pfn is MAX_ORDER_NR_PAGES aligned, if there is any
+		 * free pages in [start_pfn, boundary_pfn), its head page will
+		 * always be in the range.
+		 */
+		if (PageBuddy(page)) {
+			int order = buddy_order(page);
+
+			if (pfn + (1UL << order) > boundary_pfn)
+				split_free_page(page, order, boundary_pfn - pfn);
+			pfn += (1UL << order);
+			continue;
+		}
+		/*
+		 * migrate compound pages then let the free page handling code
+		 * above do the rest. If migration is not possible, just fail.
+		 */
+		if (PageCompound(page)) {
+			unsigned long nr_pages = compound_nr(page);
+			struct page *head = compound_head(page);
+			unsigned long head_pfn = page_to_pfn(head);
+
+			if (head_pfn + nr_pages < boundary_pfn) {
+				pfn = head_pfn + nr_pages;
+				continue;
+			}
+#if defined CONFIG_COMPACTION || defined CONFIG_CMA
+			/*
+			 * hugetlb, lru compound (THP), and movable compound pages
+			 * can be migrated. Otherwise, fail the isolation.
+			 */
+			if (PageHuge(page) || PageLRU(page) || __PageMovable(page)) {
+				int order;
+				unsigned long outer_pfn;
+				int ret;
+				struct compact_control cc = {
+					.nr_migratepages = 0,
+					.order = -1,
+					.zone = page_zone(pfn_to_page(head_pfn)),
+					.mode = MIGRATE_SYNC,
+					.ignore_skip_hint = true,
+					.no_set_skip_hint = true,
+					.gfp_mask = gfp_flags,
+					.alloc_contig = true,
+				};
+				INIT_LIST_HEAD(&cc.migratepages);
+
+				ret = __alloc_contig_migrate_range(&cc, head_pfn,
+							head_pfn + nr_pages);
+
+				if (ret)
+					goto failed;
+				/*
+				 * reset pfn to the head of the free page, so
+				 * that the free page handling code above can split
+				 * the free page to the right migratetype list.
+				 *
+				 * head_pfn is not used here as a hugetlb page order
+				 * can be bigger than MAX_ORDER-1, but after it is
+				 * freed, the free page order is not. Use pfn within
+				 * the range to find the head of the free page.
+				 */
+				order = 0;
+				outer_pfn = pfn;
+				while (!PageBuddy(pfn_to_page(outer_pfn))) {
+					if (++order >= MAX_ORDER) {
+						outer_pfn = pfn;
+						break;
+					}
+					outer_pfn &= ~0UL << order;
+				}
+				pfn = outer_pfn;
+				continue;
+			} else
+#endif
+				goto failed;
+		}
+
+		pfn++;
+	}
+	return 0;
+failed:
+	/* restore the original migratetype */
+	set_pageblock_migratetype(pfn_to_page(isolate_pageblock), saved_mt);
+	return -EBUSY;
+}
+
+/**
  * start_isolate_page_range() - make page-allocation-type of range of pages to
  * be MIGRATE_ISOLATE.
  * @start_pfn:		The lower PFN of the range to be isolated.
@@ -293,6 +453,8 @@ __first_valid_page(unsigned long pfn, un
  *					 and PageOffline() pages.
  *			REPORT_FAILURE - report details about the failure to
  *			isolate the range
+ * @gfp_flags:		GFP flags used for migrating pages that sit across the
+ *			range boundaries.
  *
  * Making page-allocation-type to be MIGRATE_ISOLATE means free pages in
  * the range will never be allocated. Any free pages and pages freed in the
@@ -301,6 +463,10 @@ __first_valid_page(unsigned long pfn, un
  * pages in the range finally, the caller have to free all pages in the range.
  * test_page_isolated() can be used for test it.
  *
+ * The function first tries to isolate the pageblocks at the beginning and end
+ * of the range, since there might be pages across the range boundaries.
+ * Afterwards, it isolates the rest of the range.
+ *
  * There is no high level synchronization mechanism that prevents two threads
  * from trying to isolate overlapping ranges. If this happens, one thread
  * will notice pageblocks in the overlapping range already set to isolate.
@@ -321,21 +487,38 @@ __first_valid_page(unsigned long pfn, un
  * Return: 0 on success and -EBUSY if any part of range cannot be isolated.
  */
 int start_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			     unsigned migratetype, int flags)
+			     int migratetype, int flags, gfp_t gfp_flags)
 {
 	unsigned long pfn;
 	struct page *page;
+	int ret;
 
 	BUG_ON(!IS_ALIGNED(start_pfn, pageblock_nr_pages));
 	BUG_ON(!IS_ALIGNED(end_pfn, pageblock_nr_pages));
 
-	for (pfn = start_pfn;
-	     pfn < end_pfn;
+	/* isolate [start_pfn, start_pfn + pageblock_nr_pages) pageblock */
+	ret = isolate_single_pageblock(start_pfn, gfp_flags, false);
+	if (ret)
+		return ret;
+
+	/* isolate [end_pfn - pageblock_nr_pages, end_pfn) pageblock */
+	ret = isolate_single_pageblock(end_pfn, gfp_flags, true);
+	if (ret) {
+		unset_migratetype_isolate(pfn_to_page(start_pfn), migratetype);
+		return ret;
+	}
+
+	/* skip isolated pageblocks at the beginning and end */
+	for (pfn = start_pfn + pageblock_nr_pages;
+	     pfn < end_pfn - pageblock_nr_pages;
 	     pfn += pageblock_nr_pages) {
 		page = __first_valid_page(pfn, pageblock_nr_pages);
 		if (page && set_migratetype_isolate(page, migratetype, flags,
 					start_pfn, end_pfn)) {
 			undo_isolate_page_range(start_pfn, pfn, migratetype);
+			unset_migratetype_isolate(
+				pfn_to_page(end_pfn - pageblock_nr_pages),
+				migratetype);
 			return -EBUSY;
 		}
 	}
@@ -346,7 +529,7 @@ int start_isolate_page_range(unsigned lo
  * Make isolated pages available again.
  */
 void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn,
-			    unsigned migratetype)
+			    int migratetype)
 {
 	unsigned long pfn;
 	struct page *page;
_

Patches currently in -mm which might be from ziy@nvidia.com are


