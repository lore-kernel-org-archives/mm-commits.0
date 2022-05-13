Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B78FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383895AbiEMTY2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383818AbiEMTXC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E083152E
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C4646226C
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E2AC34113;
        Fri, 13 May 2022 19:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469722;
        bh=B6SJrTYvyfA8/CIQGHnQp+qtv0QJb4HzgYeiZdBd4iM=;
        h=Date:To:From:Subject:From;
        b=RuUDOxB+8LMBiwByUlscUfTxWh/KXtTXNur7BhGAajDQNbXb2dg+FmgtdjtFuvhdg
         XohwQg5wcCsztei62tjJGyMcHDN6yTA540YnPk6Rd9FrYZy2E/Eley8Yv4ig7a7jt4
         /6YZrImmtSzqfVzzyn+d28/54yere1G/L4STRREo=
Date:   Fri, 13 May 2022 12:22:02 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch removed from -mm tree
Message-Id: <20220513192202.A0E2AC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: convert shmem_getpage_gfp to use a folio
has been removed from the -mm tree.  Its filename was
     mm-shmem-convert-shmem_getpage_gfp-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

