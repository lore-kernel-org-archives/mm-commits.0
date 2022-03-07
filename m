Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9137BC433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 00:58:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234100AbiCGA6w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 6 Mar 2022 19:58:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233485AbiCGA6w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 6 Mar 2022 19:58:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E68DE98
        for <mm-commits@vger.kernel.org>; Sun,  6 Mar 2022 16:57:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04843B80F93
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 00:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCBFC340EC;
        Mon,  7 Mar 2022 00:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646614674;
        bh=HoELyg/2J13f4BM/x+UA6sZ6CGocj5dWKqutk+PIIqM=;
        h=Date:To:From:Subject:From;
        b=h2xYWMjLAm78OGH/SVk0WVlRwlWc9wGaSwFXaVFF6NaYMIDdSlp9A0rL1oWfzZuMl
         M0m9N1vhTf8uVk7n48AIJghTY2gPwN0o0yKrElMjYgJnW7miTxW4+cA19tx09Gabzi
         64RSXM82ei1lVAeJt0dKVp7U9kwIwoOSP0zTSP+k=
Date:   Sun, 06 Mar 2022 16:57:53 -0800
To:     mm-commits@vger.kernel.org, rientjes@google.com, alexs@kernel.org,
        alexander.duyck@gmail.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch added to -mm tree
Message-Id: <20220307005754.8CCBFC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: __isolate_lru_page_prepare() in isolate_migratepages_block()
has been added to the -mm tree.  Its filename is
     mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: __isolate_lru_page_prepare() in isolate_migratepages_block()

__isolate_lru_page_prepare() conflates two unrelated functions, with the
flags to one disjoint from the flags to the other; and hides some of the
important checks outside of isolate_migratepages_block(), where the
sequence is better to be visible.  It comes from the days of lumpy
reclaim, before compaction, when the combination made more sense.

Move what's needed by mm/compaction.c isolate_migratepages_block() inline
there, and what's needed by mm/vmscan.c isolate_lru_pages() inline there.

Shorten "isolate_mode" to "mode", so the sequence of conditions is easier
to read.  Declare a "mapping" variable, to save one call to page_mapping()
(but not another: calling again after page is locked is necessary). 
Simplify isolate_lru_pages() with a "move_to" list pointer.

Link: https://lkml.kernel.org/r/879d62a8-91cc-d3c6-fb3b-69768236df68@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/compaction.c      |   51 +++++++++++++++++---
 mm/vmscan.c          |  101 +++++++----------------------------------
 3 files changed, 62 insertions(+), 91 deletions(-)

--- a/include/linux/swap.h~mm-__isolate_lru_page_prepare-in-isolate_migratepages_block
+++ a/include/linux/swap.h
@@ -384,7 +384,6 @@ extern void lru_cache_add_inactive_or_un
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
--- a/mm/compaction.c~mm-__isolate_lru_page_prepare-in-isolate_migratepages_block
+++ a/mm/compaction.c
@@ -785,7 +785,7 @@ static bool too_many_isolated(pg_data_t
  * @cc:		Compaction control structure.
  * @low_pfn:	The first PFN to isolate
  * @end_pfn:	The one-past-the-last PFN to isolate, within same pageblock
- * @isolate_mode: Isolation mode to be used.
+ * @mode:	Isolation mode to be used.
  *
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn). The range is expected to be within same pageblock.
@@ -798,7 +798,7 @@ static bool too_many_isolated(pg_data_t
  */
 static int
 isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
-			unsigned long end_pfn, isolate_mode_t isolate_mode)
+			unsigned long end_pfn, isolate_mode_t mode)
 {
 	pg_data_t *pgdat = cc->zone->zone_pgdat;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
@@ -806,6 +806,7 @@ isolate_migratepages_block(struct compac
 	unsigned long flags = 0;
 	struct lruvec *locked = NULL;
 	struct page *page = NULL, *valid_page = NULL;
+	struct address_space *mapping;
 	unsigned long start_pfn = low_pfn;
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
@@ -990,7 +991,7 @@ isolate_migratepages_block(struct compac
 					locked = NULL;
 				}
 
-				if (!isolate_movable_page(page, isolate_mode))
+				if (!isolate_movable_page(page, mode))
 					goto isolate_success;
 			}
 
@@ -1002,15 +1003,15 @@ isolate_migratepages_block(struct compac
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
 		 * admittedly racy check.
 		 */
-		if (!page_mapping(page) &&
-		    page_count(page) > page_mapcount(page))
+		mapping = page_mapping(page);
+		if (!mapping && page_count(page) > page_mapcount(page))
 			goto isolate_fail;
 
 		/*
 		 * Only allow to migrate anonymous pages in GFP_NOFS context
 		 * because those do not depend on fs locks.
 		 */
-		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
+		if (!(cc->gfp_mask & __GFP_FS) && mapping)
 			goto isolate_fail;
 
 		/*
@@ -1021,9 +1022,45 @@ isolate_migratepages_block(struct compac
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
-		if (!__isolate_lru_page_prepare(page, isolate_mode))
+		/* Only take pages on LRU: a check now makes later tests safe */
+		if (!PageLRU(page))
 			goto isolate_fail_put;
 
+		/* Compaction might skip unevictable pages but CMA takes them */
+		if (!(mode & ISOLATE_UNEVICTABLE) && PageUnevictable(page))
+			goto isolate_fail_put;
+
+		/*
+		 * To minimise LRU disruption, the caller can indicate with
+		 * ISOLATE_ASYNC_MIGRATE that it only wants to isolate pages
+		 * it will be able to migrate without blocking - clean pages
+		 * for the most part.  PageWriteback would require blocking.
+		 */
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageWriteback(page))
+			goto isolate_fail_put;
+
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageDirty(page)) {
+			bool migrate_dirty;
+
+			/*
+			 * Only pages without mappings or that have a
+			 * ->migratepage callback are possible to migrate
+			 * without blocking. However, we can be racing with
+			 * truncation so it's necessary to lock the page
+			 * to stabilise the mapping as truncation holds
+			 * the page lock until after the page is removed
+			 * from the page cache.
+			 */
+			if (!trylock_page(page))
+				goto isolate_fail_put;
+
+			mapping = page_mapping(page);
+			migrate_dirty = !mapping || mapping->a_ops->migratepage;
+			unlock_page(page);
+			if (!migrate_dirty)
+				goto isolate_fail_put;
+		}
+
 		/* Try isolate the page */
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
--- a/mm/vmscan.c~mm-__isolate_lru_page_prepare-in-isolate_migratepages_block
+++ a/mm/vmscan.c
@@ -1999,69 +1999,6 @@ unsigned int reclaim_clean_pages_from_li
 }
 
 /*
- * Attempt to remove the specified page from its LRU.  Only take this page
- * if it is of the appropriate PageActive status.  Pages which are being
- * freed elsewhere are also ignored.
- *
- * page:	page to consider
- * mode:	one of the LRU isolation modes defined above
- *
- * returns true on success, false on failure.
- */
-bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
-{
-	/* Only take pages on the LRU. */
-	if (!PageLRU(page))
-		return false;
-
-	/* Compaction should not handle unevictable pages but CMA can do so */
-	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
-		return false;
-
-	/*
-	 * To minimise LRU disruption, the caller can indicate that it only
-	 * wants to isolate pages it will be able to operate on without
-	 * blocking - clean pages for the most part.
-	 *
-	 * ISOLATE_ASYNC_MIGRATE is used to indicate that it only wants to pages
-	 * that it is possible to migrate without blocking
-	 */
-	if (mode & ISOLATE_ASYNC_MIGRATE) {
-		/* All the caller can do on PageWriteback is block */
-		if (PageWriteback(page))
-			return false;
-
-		if (PageDirty(page)) {
-			struct address_space *mapping;
-			bool migrate_dirty;
-
-			/*
-			 * Only pages without mappings or that have a
-			 * ->migratepage callback are possible to migrate
-			 * without blocking. However, we can be racing with
-			 * truncation so it's necessary to lock the page
-			 * to stabilise the mapping as truncation holds
-			 * the page lock until after the page is removed
-			 * from the page cache.
-			 */
-			if (!trylock_page(page))
-				return false;
-
-			mapping = page_mapping(page);
-			migrate_dirty = !mapping || mapping->a_ops->migratepage;
-			unlock_page(page);
-			if (!migrate_dirty)
-				return false;
-		}
-	}
-
-	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
-		return false;
-
-	return true;
-}
-
-/*
  * Update LRU sizes after isolating pages. The LRU size updates must
  * be complete before mem_cgroup_update_lru_size due to a sanity check.
  */
@@ -2112,11 +2049,11 @@ static unsigned long isolate_lru_pages(u
 	unsigned long skipped = 0;
 	unsigned long scan, total_scan, nr_pages;
 	LIST_HEAD(pages_skipped);
-	isolate_mode_t mode = (sc->may_unmap ? 0 : ISOLATE_UNMAPPED);
 
 	total_scan = 0;
 	scan = 0;
 	while (scan < nr_to_scan && !list_empty(src)) {
+		struct list_head *move_to = src;
 		struct page *page;
 
 		page = lru_to_page(src);
@@ -2126,9 +2063,9 @@ static unsigned long isolate_lru_pages(u
 		total_scan += nr_pages;
 
 		if (page_zonenum(page) > sc->reclaim_idx) {
-			list_move(&page->lru, &pages_skipped);
 			nr_skipped[page_zonenum(page)] += nr_pages;
-			continue;
+			move_to = &pages_skipped;
+			goto move;
 		}
 
 		/*
@@ -2136,37 +2073,34 @@ static unsigned long isolate_lru_pages(u
 		 * return with no isolated pages if the LRU mostly contains
 		 * ineligible pages.  This causes the VM to not reclaim any
 		 * pages, triggering a premature OOM.
-		 *
-		 * Account all tail pages of THP.  This would not cause
-		 * premature OOM since __isolate_lru_page() returns -EBUSY
-		 * only when the page is being freed somewhere else.
+		 * Account all tail pages of THP.
 		 */
 		scan += nr_pages;
-		if (!__isolate_lru_page_prepare(page, mode)) {
-			/* It is being freed elsewhere */
-			list_move(&page->lru, src);
-			continue;
-		}
+
+		if (!PageLRU(page))
+			goto move;
+		if (!sc->may_unmap && page_mapped(page))
+			goto move;
+
 		/*
 		 * Be careful not to clear PageLRU until after we're
 		 * sure the page is not being freed elsewhere -- the
 		 * page release code relies on it.
 		 */
-		if (unlikely(!get_page_unless_zero(page))) {
-			list_move(&page->lru, src);
-			continue;
-		}
+		if (unlikely(!get_page_unless_zero(page)))
+			goto move;
 
 		if (!TestClearPageLRU(page)) {
 			/* Another thread is already isolating this page */
 			put_page(page);
-			list_move(&page->lru, src);
-			continue;
+			goto move;
 		}
 
 		nr_taken += nr_pages;
 		nr_zone_taken[page_zonenum(page)] += nr_pages;
-		list_move(&page->lru, dst);
+		move_to = dst;
+move:
+		list_move(&page->lru, move_to);
 	}
 
 	/*
@@ -2190,7 +2124,8 @@ static unsigned long isolate_lru_pages(u
 	}
 	*nr_scanned = total_scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				    total_scan, skipped, nr_taken, mode, lru);
+				    total_scan, skipped, nr_taken,
+				    sc->may_unmap ? 0 : ISOLATE_UNMAPPED, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
 }
_

Patches currently in -mm which might be from hughd@google.com are

mm-fs-delete-pf_swapwrite.patch
mm-__isolate_lru_page_prepare-in-isolate_migratepages_block.patch
tmpfs-support-for-file-creation-time-fix.patch
shmem-mapping_set_exiting-to-help-mapped-resilience.patch
mm-_install_special_mapping-apply-vm_locked_clear_mask.patch
mempolicy-mbind_range-set_policy-after-vma_merge.patch
mm-thp-refix-__split_huge_pmd_locked-for-migration-pmd.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
mm-delete-__clearpagewaiters.patch
mm-filemap_unaccount_folio-large-skip-mapcount-fixup.patch
mm-thp-fix-nr_file_mapped-accounting-in-page__file_rmap.patch
mm-warn-on-deleting-redirtied-only-if-accounted.patch
mm-unmap_mapping_range_tree-with-i_mmap_rwsem-shared.patch

