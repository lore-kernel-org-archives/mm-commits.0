Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19490C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 29 Apr 2022 20:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380562AbiD2UON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Apr 2022 16:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380570AbiD2UOD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2022 16:14:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAC915A2A
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 13:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AABA5B83794
        for <mm-commits@vger.kernel.org>; Fri, 29 Apr 2022 20:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E78C385AD;
        Fri, 29 Apr 2022 20:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651263034;
        bh=4l3ucPmAKOXK9VEtShp2OZWkz1fKeimoujOHa7dxTck=;
        h=Date:To:From:Subject:From;
        b=aJTAdefL4YFEm/nS7jc1mOFpseDFrJQKZY1kd7awdZZ3KCRC1TTeh8jNCeOIO698S
         VA9RFFmA692aebi+b25QvoZuW1PamXSDWq2ss6FcsJrgJgPvLG3NRlYnR99u3r/EA0
         jXKHZk0d7CIx4UUibELhNCL+ox7QLhk/XsluEnNw=
Date:   Fri, 29 Apr 2022 13:10:33 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch added to mm-unstable branch
Message-Id: <20220429201034.60E78C385AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmscan: remove remaining uses of page in shrink_page_list
has been added to the -mm mm-unstable branch.  Its filename is
     vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch

This patch should soon appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: vmscan: remove remaining uses of page in shrink_page_list

These are all straightforward conversions to the folio API.

Link: https://lkml.kernel.org/r/20220429192329.3034378-14-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |  124 ++++++++++++++++++++++++--------------------------
 1 file changed, 61 insertions(+), 63 deletions(-)

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
@@ -1643,7 +1641,7 @@ retry:
 		if (folio_test_writeback(folio)) {
 			/* Case 1 above */
 			if (current_is_kswapd() &&
-			    PageReclaim(page) &&
+			    folio_test_reclaim(folio) &&
 			    test_bit(PGDAT_WRITEBACK, &pgdat->flags)) {
 				stat->nr_immediate += nr_pages;
 				goto activate_locked;
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

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
mm-remove-alloc_pages_vma.patch
vmscan-use-folio_mapped-in-shrink_page_list.patch
vmscan-convert-the-writeback-handling-in-shrink_page_list-to-folios.patch
swap-turn-get_swap_page-into-folio_alloc_swap.patch
swap-convert-add_to_swap-to-take-a-folio.patch
vmscan-convert-dirty-page-handling-to-folios.patch
vmscan-convert-page-buffer-handling-to-use-folios.patch
vmscan-convert-lazy-freeing-to-folios.patch
vmscan-move-initialisation-of-mapping-down.patch
vmscan-convert-the-activate_locked-portion-of-shrink_page_list-to-folios.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-turn-shmem_alloc_page-into-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
vmcore-convert-copy_oldmem_page-to-take-an-iov_iter.patch
vmcore-convert-__read_vmcore-to-use-an-iov_iter.patch
vmcore-convert-read_from_oldmem-to-take-an-iov_iter.patch

