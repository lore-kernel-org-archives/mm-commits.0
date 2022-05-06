Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05051C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  6 May 2022 01:33:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387975AbiEFBhR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 May 2022 21:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387980AbiEFBhG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 May 2022 21:37:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0F662121
        for <mm-commits@vger.kernel.org>; Thu,  5 May 2022 18:33:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC8F2B83200
        for <mm-commits@vger.kernel.org>; Fri,  6 May 2022 01:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964F8C385A8;
        Fri,  6 May 2022 01:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651800802;
        bh=07EjHV0TIfUefSoyzSi/vEKv/RwKs8LFa3+ORESztzE=;
        h=Date:To:From:Subject:From;
        b=p/LamjbxNjV5oig4FZU5xNc4sIhAi4yprlVMzlDKtE+JkCXoJ5NGpvEf+gClyK1oL
         aqMHg8kcQBxsZNCumUuSpRYxN2KCPS5NYJ7qMF4QAaJr5dkGrPILTtlD46wjg3cN6V
         EyshYWGTIPeA/lyxg5ctVzYDMsl9/p5rHa6jxd+4=
Date:   Thu, 05 May 2022 18:33:21 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20220506013322.964F8C385A8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: convert shmem_getpage_gfp to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch

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
Subject: mm/shmem: convert shmem_getpage_gfp to use a folio

Rename shmem_alloc_and_acct_page() to shmem_alloc_and_acct_folio() and
have it return a folio, then use a folio throuughout shmem_getpage_gfp(). 
It continues to return a struct page.

Link: https://lkml.kernel.org/r/20220504182857.4013401-23-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   95 +++++++++++++++++++++++----------------------------
 1 file changed, 43 insertions(+), 52 deletions(-)

--- a/mm/shmem.c~mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio
+++ a/mm/shmem.c
@@ -1563,8 +1563,7 @@ static struct page *shmem_alloc_page(gfp
 	return &shmem_alloc_folio(gfp, info, index)->page;
 }
 
-static struct page *shmem_alloc_and_acct_page(gfp_t gfp,
-		struct inode *inode,
+static struct folio *shmem_alloc_and_acct_folio(gfp_t gfp, struct inode *inode,
 		pgoff_t index, bool huge)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -1586,7 +1585,7 @@ static struct page *shmem_alloc_and_acct
 	if (folio) {
 		__folio_set_locked(folio);
 		__folio_set_swapbacked(folio);
-		return &folio->page;
+		return folio;
 	}
 
 	err = -ENOMEM;
@@ -1800,7 +1799,6 @@ static int shmem_getpage_gfp(struct inod
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
 	struct folio *folio;
-	struct page *page;
 	pgoff_t hindex = index;
 	gfp_t huge_gfp;
 	int error;
@@ -1818,19 +1816,18 @@ repeat:
 	sbinfo = SHMEM_SB(inode->i_sb);
 	charge_mm = vma ? vma->vm_mm : NULL;
 
-	page = pagecache_get_page(mapping, index,
-					FGP_ENTRY | FGP_HEAD | FGP_LOCK, 0);
-
-	if (page && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(page)) {
-			unlock_page(page);
-			put_page(page);
+	folio = __filemap_get_folio(mapping, index, FGP_ENTRY | FGP_LOCK, 0);
+	if (folio && vma && userfaultfd_minor(vma)) {
+		if (!xa_is_value(folio)) {
+			folio_unlock(folio);
+			folio_put(folio);
 		}
 		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
 		return 0;
 	}
 
-	if (xa_is_value(page)) {
+	if (xa_is_value(folio)) {
+		struct page *page = &folio->page;
 		error = shmem_swapin_page(inode, index, &page,
 					  sgp, gfp, vma, fault_type);
 		if (error == -EEXIST)
@@ -1840,17 +1837,17 @@ repeat:
 		return error;
 	}
 
-	if (page) {
-		hindex = page->index;
+	if (folio) {
+		hindex = folio->index;
 		if (sgp == SGP_WRITE)
-			mark_page_accessed(page);
-		if (PageUptodate(page))
+			folio_mark_accessed(folio);
+		if (folio_test_uptodate(folio))
 			goto out;
 		/* fallocated page */
 		if (sgp != SGP_READ)
 			goto clear;
-		unlock_page(page);
-		put_page(page);
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 
 	/*
@@ -1877,17 +1874,16 @@ repeat:
 
 	huge_gfp = vma_thp_gfp_mask(vma);
 	huge_gfp = limit_gfp_mask(huge_gfp, gfp);
-	page = shmem_alloc_and_acct_page(huge_gfp, inode, index, true);
-	if (IS_ERR(page)) {
+	folio = shmem_alloc_and_acct_folio(huge_gfp, inode, index, true);
+	if (IS_ERR(folio)) {
 alloc_nohuge:
-		page = shmem_alloc_and_acct_page(gfp, inode,
-						 index, false);
+		folio = shmem_alloc_and_acct_folio(gfp, inode, index, false);
 	}
-	if (IS_ERR(page)) {
+	if (IS_ERR(folio)) {
 		int retry = 5;
 
-		error = PTR_ERR(page);
-		page = NULL;
+		error = PTR_ERR(folio);
+		folio = NULL;
 		if (error != -ENOSPC)
 			goto unlock;
 		/*
@@ -1906,30 +1902,26 @@ alloc_nohuge:
 		goto unlock;
 	}
 
-	if (PageTransHuge(page))
-		hindex = round_down(index, HPAGE_PMD_NR);
-	else
-		hindex = index;
+	hindex = round_down(index, folio_nr_pages(folio));
 
 	if (sgp == SGP_WRITE)
-		__SetPageReferenced(page);
+		__folio_set_referenced(folio);
 
-	folio = page_folio(page);
 	error = shmem_add_to_page_cache(folio, mapping, hindex,
 					NULL, gfp & GFP_RECLAIM_MASK,
 					charge_mm);
 	if (error)
 		goto unacct;
-	lru_cache_add(page);
+	folio_add_lru(folio);
 
 	spin_lock_irq(&info->lock);
-	info->alloced += compound_nr(page);
-	inode->i_blocks += BLOCKS_PER_PAGE << compound_order(page);
+	info->alloced += folio_nr_pages(folio);
+	inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
 	shmem_recalc_inode(inode);
 	spin_unlock_irq(&info->lock);
 	alloced = true;
 
-	if (PageTransHuge(page) &&
+	if (folio_test_pmd_mappable(folio) &&
 	    DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
 			hindex + HPAGE_PMD_NR - 1) {
 		/*
@@ -1960,22 +1952,21 @@ clear:
 	 * but SGP_FALLOC on a page fallocated earlier must initialize
 	 * it now, lest undo on failure cancel our earlier guarantee.
 	 */
-	if (sgp != SGP_WRITE && !PageUptodate(page)) {
-		int i;
+	if (sgp != SGP_WRITE && !folio_test_uptodate(folio)) {
+		long i, n = folio_nr_pages(folio);
 
-		for (i = 0; i < compound_nr(page); i++) {
-			clear_highpage(page + i);
-			flush_dcache_page(page + i);
-		}
-		SetPageUptodate(page);
+		for (i = 0; i < n; i++)
+			clear_highpage(folio_page(folio, i));
+		flush_dcache_folio(folio);
+		folio_mark_uptodate(folio);
 	}
 
 	/* Perhaps the file has been truncated since we checked */
 	if (sgp <= SGP_CACHE &&
 	    ((loff_t)index << PAGE_SHIFT) >= i_size_read(inode)) {
 		if (alloced) {
-			ClearPageDirty(page);
-			delete_from_page_cache(page);
+			folio_clear_dirty(folio);
+			filemap_remove_folio(folio);
 			spin_lock_irq(&info->lock);
 			shmem_recalc_inode(inode);
 			spin_unlock_irq(&info->lock);
@@ -1984,24 +1975,24 @@ clear:
 		goto unlock;
 	}
 out:
-	*pagep = page + index - hindex;
+	*pagep = folio_page(folio, index - hindex);
 	return 0;
 
 	/*
 	 * Error recovery.
 	 */
 unacct:
-	shmem_inode_unacct_blocks(inode, compound_nr(page));
+	shmem_inode_unacct_blocks(inode, folio_nr_pages(folio));
 
-	if (PageTransHuge(page)) {
-		unlock_page(page);
-		put_page(page);
+	if (folio_test_large(folio)) {
+		folio_unlock(folio);
+		folio_put(folio);
 		goto alloc_nohuge;
 	}
 unlock:
-	if (page) {
-		unlock_page(page);
-		put_page(page);
+	if (folio) {
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 	if (error == -ENOSPC && !once++) {
 		spin_lock_irq(&info->lock);
_

Patches currently in -mm which might be from willy@infradead.org are

shmem-convert-shmem_alloc_hugepage-to-use-vma_alloc_folio.patch
mm-huge_memory-convert-do_huge_pmd_anonymous_page-to-use-vma_alloc_folio.patch
alpha-fix-alloc_zeroed_user_highpage_movable.patch
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
mm-allow-can_split_folio-to-be-called-when-thp-are-disabled.patch
vmscan-remove-remaining-uses-of-page-in-shrink_page_list.patch
mm-shmem-use-a-folio-in-shmem_unused_huge_shrink.patch
mm-swap-add-folio_throttle_swaprate.patch
mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch
mm-shmem-turn-shmem_should_replace_page-into-shmem_should_replace_folio.patch
mm-shmem-add-shmem_alloc_folio.patch
mm-shmem-convert-shmem_alloc_and_acct_page-to-use-a-folio.patch
mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch
mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch
mm-add-folio_mapping_flags.patch
mm-add-folio_test_movable.patch
mm-migrate-convert-move_to_new_page-into-move_to_new_folio.patch

