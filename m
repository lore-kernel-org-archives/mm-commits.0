Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43CEC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383749AbiEMTXT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383798AbiEMTWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF363BFAD
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCCF6225F
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779EBC34113;
        Fri, 13 May 2022 19:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469715;
        bh=zIJKTdQF8UX19qFWzt+SHKFwrBNVPYWi0HyWLd5JXuA=;
        h=Date:To:From:Subject:From;
        b=nh+K1D1o81FeJqJRA9KO3PoWaVC5nZkDefFPpCrie1luZxDgb+9mpubZq8z3C3jaT
         2YFhzhtF1rQGVAnIfj2OCOanjR2YUyR9D5Yner341QArh9D4T237lQZrzg8zSEaZUY
         /5VADOl5TpbFw1BMArI5yEOC6g5OKlIwlo5uebGw=
Date:   Fri, 13 May 2022 12:21:54 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch removed from -mm tree
Message-Id: <20220513192155.779EBC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: vmscan: remove remaining uses of page in shrink_page_list
has been removed from the -mm tree.  Its filename was
     vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: remove remaining uses of page in shrink_page_list

These are all straightforward conversions to the folio API.

Link: https://lkml.kernel.org/r/20220504182857.4013401-16-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  122 ++++++++++++++++++++++++--------------------------
 1 file changed, 60 insertions(+), 62 deletions(-)

--- a/mm/vmscan.c~vmscan-remove-remaining-uses-of-page-in-shrink_page_list
+++ a/mm/vmscan.c
@@ -1507,11 +1507,11 @@ static unsigned int demote_page_list(str
 	return nr_succeeded;
 }
 
-static bool may_enter_fs(struct page *page, gfp_t gfp_mask)
+static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 {
 	if (gfp_mask & __GFP_FS)
 		return true;
-	if (!PageSwapCache(page) || !(gfp_mask & __GFP_IO))
+	if (!folio_test_swapcache(folio) || !(gfp_mask & __GFP_IO))
 		return false;
 	/*
 	 * We can "enter_fs" for swap-cache with only __GFP_IO
@@ -1520,7 +1520,7 @@ static bool may_enter_fs(struct page *pa
 	 * but that will never affect SWP_FS_OPS, so the data_race
 	 * is safe.
 	 */
-	return !data_race(page_swap_flags(page) & SWP_FS_OPS);
+	return !data_race(page_swap_flags(&folio->page) & SWP_FS_OPS);
 }
 
 /*
@@ -1547,7 +1547,6 @@ static unsigned int shrink_page_list(str
 retry:
 	while (!list_empty(page_list)) {
 		struct address_space *mapping;
-		struct page *page;
 		struct folio *folio;
 		enum page_references references = PAGEREF_RECLAIM;
 		bool dirty, writeback;
@@ -1557,19 +1556,18 @@ retry:
 
 		folio = lru_to_folio(page_list);
 		list_del(&folio->lru);
-		page = &folio->page;
 
-		if (!trylock_page(page))
+		if (!folio_trylock(folio))
 			goto keep;
 
-		VM_BUG_ON_PAGE(PageActive(page), page);
+		VM_BUG_ON_FOLIO(folio_test_active(folio), folio);
 
-		nr_pages = compound_nr(page);
+		nr_pages = folio_nr_pages(folio);
 
-		/* Account the number of base pages even though THP */
+		/* Account the number of base pages */
 		sc->nr_scanned += nr_pages;
 
-		if (unlikely(!page_evictable(page)))
+		if (unlikely(!folio_evictable(folio)))
 			goto activate_locked;
 
 		if (!sc->may_unmap && folio_mapped(folio))
@@ -1578,7 +1576,7 @@ retry:
 		/*
 		 * The number of dirty pages determines if a node is marked
 		 * reclaim_congested. kswapd will stall and start writing
-		 * pages if the tail of the LRU is all dirty unqueued pages.
+		 * folios if the tail of the LRU is all dirty unqueued folios.
 		 */
 		folio_check_dirty_writeback(folio, &dirty, &writeback);
 		if (dirty || writeback)
@@ -1588,21 +1586,21 @@ retry:
 			stat->nr_unqueued_dirty += nr_pages;
 
 		/*
-		 * Treat this page as congested if
-		 * pages are cycling through the LRU so quickly that the
-		 * pages marked for immediate reclaim are making it to the
-		 * end of the LRU a second time.
+		 * Treat this folio as congested if folios are cycling
+		 * through the LRU so quickly that the folios marked
+		 * for immediate reclaim are making it to the end of
+		 * the LRU a second time.
 		 */
-		if (writeback && PageReclaim(page))
+		if (writeback && folio_test_reclaim(folio))
 			stat->nr_congested += nr_pages;
 
 		/*
 		 * If a folio at the tail of the LRU is under writeback, there
 		 * are three cases to consider.
 		 *
-		 * 1) If reclaim is encountering an excessive number of folios
-		 *    under writeback and this folio is both under
-		 *    writeback and has the reclaim flag set then it
+		 * 1) If reclaim is encountering an excessive number
+		 *    of folios under writeback and this folio has both
+		 *    the writeback and reclaim flags set, then it
 		 *    indicates that folios are being queued for I/O but
 		 *    are being recycled through the LRU before the I/O
 		 *    can complete. Waiting on the folio itself risks an
@@ -1651,19 +1649,19 @@ retry:
 			/* Case 2 above */
 			} else if (writeback_throttling_sane(sc) ||
 			    !folio_test_reclaim(folio) ||
-			    !may_enter_fs(page, sc->gfp_mask)) {
+			    !may_enter_fs(folio, sc->gfp_mask)) {
 				/*
 				 * This is slightly racy -
-				 * folio_end_writeback() might have just
-				 * cleared the reclaim flag, then setting
-				 * reclaim here ends up interpreted as
-				 * the readahead flag - but that does
-				 * not matter enough to care.  What we
-				 * do want is for this folio to have
-				 * the reclaim flag set next time memcg
-				 * reclaim reaches the tests above, so
-				 * it will then folio_wait_writeback()
-				 * to avoid OOM; and it's also appropriate
+				 * folio_end_writeback() might have
+				 * just cleared the reclaim flag, then
+				 * setting the reclaim flag here ends up
+				 * interpreted as the readahead flag - but
+				 * that does not matter enough to care.
+				 * What we do want is for this folio to
+				 * have the reclaim flag set next time
+				 * memcg reclaim reaches the tests above,
+				 * so it will then wait for writeback to
+				 * avoid OOM; and it's also appropriate
 				 * in global reclaim.
 				 */
 				folio_set_reclaim(folio);
@@ -1691,37 +1689,37 @@ retry:
 			goto keep_locked;
 		case PAGEREF_RECLAIM:
 		case PAGEREF_RECLAIM_CLEAN:
-			; /* try to reclaim the page below */
+			; /* try to reclaim the folio below */
 		}
 
 		/*
-		 * Before reclaiming the page, try to relocate
+		 * Before reclaiming the folio, try to relocate
 		 * its contents to another node.
 		 */
 		if (do_demote_pass &&
-		    (thp_migration_supported() || !PageTransHuge(page))) {
-			list_add(&page->lru, &demote_pages);
-			unlock_page(page);
+		    (thp_migration_supported() || !folio_test_large(folio))) {
+			list_add(&folio->lru, &demote_pages);
+			folio_unlock(folio);
 			continue;
 		}
 
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
-		 * Lazyfree page could be freed directly
+		 * Lazyfree folio could be freed directly
 		 */
-		if (PageAnon(page) && PageSwapBacked(page)) {
-			if (!PageSwapCache(page)) {
+		if (folio_test_anon(folio) && folio_test_swapbacked(folio)) {
+			if (!folio_test_swapcache(folio)) {
 				if (!(sc->gfp_mask & __GFP_IO))
 					goto keep_locked;
 				if (folio_maybe_dma_pinned(folio))
 					goto keep_locked;
-				if (PageTransHuge(page)) {
-					/* cannot split THP, skip it */
+				if (folio_test_large(folio)) {
+					/* cannot split folio, skip it */
 					if (!can_split_folio(folio, NULL))
 						goto activate_locked;
 					/*
-					 * Split pages without a PMD map right
+					 * Split folios without a PMD map right
 					 * away. Chances are some or all of the
 					 * tail pages can be freed without IO.
 					 */
@@ -1744,20 +1742,19 @@ retry:
 						goto activate_locked_split;
 				}
 			}
-		} else if (PageSwapBacked(page) && PageTransHuge(page)) {
-			/* Split shmem THP */
+		} else if (folio_test_swapbacked(folio) &&
+			   folio_test_large(folio)) {
+			/* Split shmem folio */
 			if (split_folio_to_list(folio, page_list))
 				goto keep_locked;
 		}
 
 		/*
-		 * THP may get split above, need minus tail pages and update
-		 * nr_pages to avoid accounting tail pages twice.
-		 *
-		 * The tail pages that are added into swap cache successfully
-		 * reach here.
+		 * If the folio was split above, the tail pages will make
+		 * their own pass through this function and be accounted
+		 * then.
 		 */
-		if ((nr_pages > 1) && !PageTransHuge(page)) {
+		if ((nr_pages > 1) && !folio_test_large(folio)) {
 			sc->nr_scanned -= (nr_pages - 1);
 			nr_pages = 1;
 		}
@@ -1815,7 +1812,7 @@ retry:
 
 			if (references == PAGEREF_RECLAIM_CLEAN)
 				goto keep_locked;
-			if (!may_enter_fs(page, sc->gfp_mask))
+			if (!may_enter_fs(folio, sc->gfp_mask))
 				goto keep_locked;
 			if (!sc->may_writepage)
 				goto keep_locked;
@@ -1917,11 +1914,11 @@ retry:
 							 sc->target_mem_cgroup))
 			goto keep_locked;
 
-		unlock_page(page);
+		folio_unlock(folio);
 free_it:
 		/*
-		 * THP may get swapped out in a whole, need account
-		 * all base pages.
+		 * Folio may get swapped out as a whole, need to account
+		 * all pages in it.
 		 */
 		nr_reclaimed += nr_pages;
 
@@ -1929,10 +1926,10 @@ free_it:
 		 * Is there need to periodically free_page_list? It would
 		 * appear not as the counts should be low
 		 */
-		if (unlikely(PageTransHuge(page)))
-			destroy_compound_page(page);
+		if (unlikely(folio_test_large(folio)))
+			destroy_compound_page(&folio->page);
 		else
-			list_add(&page->lru, &free_pages);
+			list_add(&folio->lru, &free_pages);
 		continue;
 
 activate_locked_split:
@@ -1958,18 +1955,19 @@ activate_locked:
 			count_memcg_folio_events(folio, PGACTIVATE, nr_pages);
 		}
 keep_locked:
-		unlock_page(page);
+		folio_unlock(folio);
 keep:
-		list_add(&page->lru, &ret_pages);
-		VM_BUG_ON_PAGE(PageLRU(page) || PageUnevictable(page), page);
+		list_add(&folio->lru, &ret_pages);
+		VM_BUG_ON_FOLIO(folio_test_lru(folio) ||
+				folio_test_unevictable(folio), folio);
 	}
 	/* 'page_list' is always empty here */
 
-	/* Migrate pages selected for demotion */
+	/* Migrate folios selected for demotion */
 	nr_reclaimed += demote_page_list(&demote_pages, pgdat);
-	/* Pages that could not be demoted are still in @demote_pages */
+	/* Folios that could not be demoted are still in @demote_pages */
 	if (!list_empty(&demote_pages)) {
-		/* Pages which failed to demoted go back on @page_list for retry: */
+		/* Folios which weren't demoted go back on @page_list for retry: */
 		list_splice_init(&demote_pages, page_list);
 		do_demote_pass = false;
 		goto retry;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-vma-iterator.patch
mmap-use-the-vma-iterator-in-count_vma_pages_range.patch
proc-remove-vma-rbtree-use-from-nommu.patch
arm64-remove-mmap-linked-list-from-vdso.patch
parisc-remove-mmap-linked-list-from-cache-handling.patch
powerpc-remove-mmap-linked-list-walks.patch
s390-remove-vma-linked-list-walks.patch
x86-remove-vma-linked-list-walks.patch
xtensa-remove-vma-linked-list-walks.patch
cxl-remove-vma-linked-list-walk.patch
optee-remove-vma-linked-list-walk.patch
um-remove-vma-linked-list-walk.patch
coredump-remove-vma-linked-list-walk.patch
exec-use-vma-iterator-instead-of-linked-list.patch
fs-proc-task_mmu-stop-using-linked-list-and-highest_vm_end.patch
acct-use-vma-iterator-instead-of-linked-list.patch
perf-use-vma-iterator.patch
sched-use-maple-tree-iterator-to-walk-vmas.patch
fork-use-vma-iterator.patch
mm-khugepaged-stop-using-vma-linked-list.patch
mm-ksm-use-vma-iterators-instead-of-vma-linked-list.patch
mm-mlock-use-vma-iterator-and-maple-state-instead-of-vma-linked-list.patch
mm-pagewalk-use-vma_find-instead-of-vma-linked-list.patch
i915-use-the-vma-iterator.patch
nommu-remove-uses-of-vma-linked-list.patch

