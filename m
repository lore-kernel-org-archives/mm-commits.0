Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242C6C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiJCVFp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiJCVFL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:05:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF0A10077
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F434B815E2
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7375C433C1;
        Mon,  3 Oct 2022 21:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831089;
        bh=Gd8Nk/hXM+6ytFNZ4zoGEKNvd0sUkpxsJCgWmSTuqsk=;
        h=Date:To:From:Subject:From;
        b=sL7k5K0XW81Vd13PVc2i1aGAb/7UNStJlQI3MrCOj8gXQe2o3E4NalIJD9m9ZpSJ1
         eYYWdFZCZ14J7tK1Po8YtCZYnm/YHgqHJ5btxz33GU2WhZ0u6/mHMQ04OhP6n0nRJY
         PkiKppk2qKAPekIJiDaoEoFUjibIhdvPwjXLE3Us=
Date:   Mon, 03 Oct 2022 14:04:49 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch removed from -mm tree
Message-Id: <20221003210449.B7375C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: convert add_to_swap_cache() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-swap-convert-add_to_swap_cache-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/swap: convert add_to_swap_cache() to take a folio
Date: Fri, 2 Sep 2022 20:46:08 +0100

With all callers using folios, we can convert add_to_swap_cache() to take
a folio and use it throughout.

Link: https://lkml.kernel.org/r/20220902194653.1739778-13-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c      |    2 +-
 mm/swap.h       |    4 ++--
 mm/swap_state.c |   34 +++++++++++++++++-----------------
 3 files changed, 20 insertions(+), 20 deletions(-)

--- a/mm/shmem.c~mm-swap-convert-add_to_swap_cache-to-take-a-folio
+++ a/mm/shmem.c
@@ -1406,7 +1406,7 @@ static int shmem_writepage(struct page *
 	if (list_empty(&info->swaplist))
 		list_add(&info->swaplist, &shmem_swaplist);
 
-	if (add_to_swap_cache(&folio->page, swap,
+	if (add_to_swap_cache(folio, swap,
 			__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN,
 			NULL) == 0) {
 		spin_lock_irq(&info->lock);
--- a/mm/swap.h~mm-swap-convert-add_to_swap_cache-to-take-a-folio
+++ a/mm/swap.h
@@ -32,7 +32,7 @@ extern struct address_space *swapper_spa
 void show_swap_cache_info(void);
 bool add_to_swap(struct folio *folio);
 void *get_shadow_from_swap_cache(swp_entry_t entry);
-int add_to_swap_cache(struct page *page, swp_entry_t entry,
+int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 		      gfp_t gfp, void **shadowp);
 void __delete_from_swap_cache(struct folio *folio,
 			      swp_entry_t entry, void *shadow);
@@ -122,7 +122,7 @@ static inline void *get_shadow_from_swap
 	return NULL;
 }
 
-static inline int add_to_swap_cache(struct page *page, swp_entry_t entry,
+static inline int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 					gfp_t gfp_mask, void **shadowp)
 {
 	return -1;
--- a/mm/swap_state.c~mm-swap-convert-add_to_swap_cache-to-take-a-folio
+++ a/mm/swap_state.c
@@ -85,21 +85,21 @@ void *get_shadow_from_swap_cache(swp_ent
  * add_to_swap_cache resembles filemap_add_folio on swapper_space,
  * but sets SwapCache flag and private instead of mapping and index.
  */
-int add_to_swap_cache(struct page *page, swp_entry_t entry,
+int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
 			gfp_t gfp, void **shadowp)
 {
 	struct address_space *address_space = swap_address_space(entry);
 	pgoff_t idx = swp_offset(entry);
-	XA_STATE_ORDER(xas, &address_space->i_pages, idx, compound_order(page));
-	unsigned long i, nr = thp_nr_pages(page);
+	XA_STATE_ORDER(xas, &address_space->i_pages, idx, folio_order(folio));
+	unsigned long i, nr = folio_nr_pages(folio);
 	void *old;
 
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(PageSwapCache(page), page);
-	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(folio_test_swapcache(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
 
-	page_ref_add(page, nr);
-	SetPageSwapCache(page);
+	folio_ref_add(folio, nr);
+	folio_set_swapcache(folio);
 
 	do {
 		xas_lock_irq(&xas);
@@ -107,19 +107,19 @@ int add_to_swap_cache(struct page *page,
 		if (xas_error(&xas))
 			goto unlock;
 		for (i = 0; i < nr; i++) {
-			VM_BUG_ON_PAGE(xas.xa_index != idx + i, page);
+			VM_BUG_ON_FOLIO(xas.xa_index != idx + i, folio);
 			old = xas_load(&xas);
 			if (xa_is_value(old)) {
 				if (shadowp)
 					*shadowp = old;
 			}
-			set_page_private(page + i, entry.val + i);
-			xas_store(&xas, page);
+			set_page_private(folio_page(folio, i), entry.val + i);
+			xas_store(&xas, folio);
 			xas_next(&xas);
 		}
 		address_space->nrpages += nr;
-		__mod_node_page_state(page_pgdat(page), NR_FILE_PAGES, nr);
-		__mod_lruvec_page_state(page, NR_SWAPCACHE, nr);
+		__node_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+		__lruvec_stat_mod_folio(folio, NR_SWAPCACHE, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -127,8 +127,8 @@ unlock:
 	if (!xas_error(&xas))
 		return 0;
 
-	ClearPageSwapCache(page);
-	page_ref_sub(page, nr);
+	folio_clear_swapcache(folio);
+	folio_ref_sub(folio, nr);
 	return xas_error(&xas);
 }
 
@@ -194,7 +194,7 @@ bool add_to_swap(struct folio *folio)
 	/*
 	 * Add it to the swap cache.
 	 */
-	err = add_to_swap_cache(&folio->page, entry,
+	err = add_to_swap_cache(folio, entry,
 			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN, NULL);
 	if (err)
 		/*
@@ -484,7 +484,7 @@ struct page *__read_swap_cache_async(swp
 		goto fail_unlock;
 
 	/* May fail (-ENOMEM) if XArray node allocation failed. */
-	if (add_to_swap_cache(&folio->page, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
+	if (add_to_swap_cache(folio, entry, gfp_mask & GFP_RECLAIM_MASK, &shadow))
 		goto fail_unlock;
 
 	mem_cgroup_swapin_uncharge_swap(entry);
_

Patches currently in -mm which might be from willy@infradead.org are


