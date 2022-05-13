Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39736C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383818AbiEMTY3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383819AbiEMTXD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF88F3D1CD
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57E0462220
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF62C34100;
        Fri, 13 May 2022 19:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469723;
        bh=nvB5uPuFCHd/rN1O0+U5WeLhSybs1ZdU9XoJ6lFidmo=;
        h=Date:To:From:Subject:From;
        b=dHKUOAIxrkKOFQThS1QpbpMxKelgTHaet+L5eKUO0VkA1Wb63FJ2UfJ98lev+Q5Xj
         S9ciCxHYyUTAax0fRuyy5IGI+MwfTkvv1z+o6z88nQxnP6/ylfK77QR9SqVEXSMN60
         DyHvCxx2vBQXwWebiBAMaq62pWPqWZ/jdxwrVn78=
Date:   Fri, 13 May 2022 12:22:03 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch removed from -mm tree
Message-Id: <20220513192203.AAF62C34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()
has been removed from the -mm tree.  Its filename was
     mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()

shmem_swapin_page() only brings in order-0 pages, which are folios
by definition.

Link: https://lkml.kernel.org/r/20220504182857.4013401-24-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    6 -
 include/linux/pgtable.h          |    2 
 mm/shmem.c                       |  110 +++++++++++++----------------
 3 files changed, 55 insertions(+), 63 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio
+++ a/arch/arm64/include/asm/pgtable.h
@@ -981,10 +981,10 @@ static inline void arch_swap_invalidate_
 }
 
 #define __HAVE_ARCH_SWAP_RESTORE
-static inline void arch_swap_restore(swp_entry_t entry, struct page *page)
+static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
-	if (system_supports_mte() && mte_restore_tags(entry, page))
-		set_bit(PG_mte_tagged, &page->flags);
+	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
+		set_bit(PG_mte_tagged, &folio->flags);
 }
 
 #endif /* CONFIG_ARM64_MTE */
--- a/include/linux/pgtable.h~mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio
+++ a/include/linux/pgtable.h
@@ -758,7 +758,7 @@ static inline void arch_swap_invalidate_
 #endif
 
 #ifndef __HAVE_ARCH_SWAP_RESTORE
-static inline void arch_swap_restore(swp_entry_t entry, struct page *page)
+static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
 }
 #endif
--- a/mm/shmem.c~mm-shmem-convert-shmem_swapin_page-to-shmem_swapin_folio
+++ a/mm/shmem.c
@@ -135,8 +135,8 @@ static unsigned long shmem_default_max_i
 }
 #endif
 
-static int shmem_swapin_page(struct inode *inode, pgoff_t index,
-			     struct page **pagep, enum sgp_type sgp,
+static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
+			     struct folio **foliop, enum sgp_type sgp,
 			     gfp_t gfp, struct vm_area_struct *vma,
 			     vm_fault_t *fault_type);
 static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
@@ -1159,69 +1159,64 @@ static void shmem_evict_inode(struct ino
 }
 
 static int shmem_find_swap_entries(struct address_space *mapping,
-				   pgoff_t start, unsigned int nr_entries,
-				   struct page **entries, pgoff_t *indices,
-				   unsigned int type)
+				   pgoff_t start, struct folio_batch *fbatch,
+				   pgoff_t *indices, unsigned int type)
 {
 	XA_STATE(xas, &mapping->i_pages, start);
-	struct page *page;
+	struct folio *folio;
 	swp_entry_t entry;
 	unsigned int ret = 0;
 
-	if (!nr_entries)
-		return 0;
-
 	rcu_read_lock();
-	xas_for_each(&xas, page, ULONG_MAX) {
-		if (xas_retry(&xas, page))
+	xas_for_each(&xas, folio, ULONG_MAX) {
+		if (xas_retry(&xas, folio))
 			continue;
 
-		if (!xa_is_value(page))
+		if (!xa_is_value(folio))
 			continue;
 
-		entry = radix_to_swp_entry(page);
+		entry = radix_to_swp_entry(folio);
 		if (swp_type(entry) != type)
 			continue;
 
 		indices[ret] = xas.xa_index;
-		entries[ret] = page;
+		if (!folio_batch_add(fbatch, folio))
+			break;
 
 		if (need_resched()) {
 			xas_pause(&xas);
 			cond_resched_rcu();
 		}
-		if (++ret == nr_entries)
-			break;
 	}
 	rcu_read_unlock();
 
-	return ret;
+	return xas.xa_index;
 }
 
 /*
  * Move the swapped pages for an inode to page cache. Returns the count
  * of pages swapped in, or the error in case of failure.
  */
-static int shmem_unuse_swap_entries(struct inode *inode, struct pagevec pvec,
-				    pgoff_t *indices)
+static int shmem_unuse_swap_entries(struct inode *inode,
+		struct folio_batch *fbatch, pgoff_t *indices)
 {
 	int i = 0;
 	int ret = 0;
 	int error = 0;
 	struct address_space *mapping = inode->i_mapping;
 
-	for (i = 0; i < pvec.nr; i++) {
-		struct page *page = pvec.pages[i];
+	for (i = 0; i < folio_batch_count(fbatch); i++) {
+		struct folio *folio = fbatch->folios[i];
 
-		if (!xa_is_value(page))
+		if (!xa_is_value(folio))
 			continue;
-		error = shmem_swapin_page(inode, indices[i],
-					  &page, SGP_CACHE,
+		error = shmem_swapin_folio(inode, indices[i],
+					  &folio, SGP_CACHE,
 					  mapping_gfp_mask(mapping),
 					  NULL, NULL);
 		if (error == 0) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			ret++;
 		}
 		if (error == -ENOMEM)
@@ -1238,26 +1233,23 @@ static int shmem_unuse_inode(struct inod
 {
 	struct address_space *mapping = inode->i_mapping;
 	pgoff_t start = 0;
-	struct pagevec pvec;
+	struct folio_batch fbatch;
 	pgoff_t indices[PAGEVEC_SIZE];
 	int ret = 0;
 
-	pagevec_init(&pvec);
 	do {
-		unsigned int nr_entries = PAGEVEC_SIZE;
-
-		pvec.nr = shmem_find_swap_entries(mapping, start, nr_entries,
-						  pvec.pages, indices, type);
-		if (pvec.nr == 0) {
+		folio_batch_init(&fbatch);
+		shmem_find_swap_entries(mapping, start, &fbatch, indices, type);
+		if (folio_batch_count(&fbatch) == 0) {
 			ret = 0;
 			break;
 		}
 
-		ret = shmem_unuse_swap_entries(inode, pvec, indices);
+		ret = shmem_unuse_swap_entries(inode, &fbatch, indices);
 		if (ret < 0)
 			break;
 
-		start = indices[pvec.nr - 1];
+		start = indices[folio_batch_count(&fbatch) - 1];
 	} while (true);
 
 	return ret;
@@ -1687,22 +1679,22 @@ static int shmem_replace_page(struct pag
  * Returns 0 and the page in pagep if success. On failure, returns the
  * error code and NULL in *pagep.
  */
-static int shmem_swapin_page(struct inode *inode, pgoff_t index,
-			     struct page **pagep, enum sgp_type sgp,
+static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
+			     struct folio **foliop, enum sgp_type sgp,
 			     gfp_t gfp, struct vm_area_struct *vma,
 			     vm_fault_t *fault_type)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
-	struct page *page = NULL;
-	struct folio *folio;
+	struct page *page;
+	struct folio *folio = NULL;
 	swp_entry_t swap;
 	int error;
 
-	VM_BUG_ON(!*pagep || !xa_is_value(*pagep));
-	swap = radix_to_swp_entry(*pagep);
-	*pagep = NULL;
+	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
+	swap = radix_to_swp_entry(*foliop);
+	*foliop = NULL;
 
 	/* Look it up and read it in.. */
 	page = lookup_swap_cache(swap, NULL, 0);
@@ -1720,27 +1712,28 @@ static int shmem_swapin_page(struct inod
 			goto failed;
 		}
 	}
+	folio = page_folio(page);
 
 	/* We have to do this with page locked to prevent races */
-	lock_page(page);
-	if (!PageSwapCache(page) || page_private(page) != swap.val ||
+	folio_lock(folio);
+	if (!folio_test_swapcache(folio) ||
+	    folio_swap_entry(folio).val != swap.val ||
 	    !shmem_confirm_swap(mapping, index, swap)) {
 		error = -EEXIST;
 		goto unlock;
 	}
-	if (!PageUptodate(page)) {
+	if (!folio_test_uptodate(folio)) {
 		error = -EIO;
 		goto failed;
 	}
-	wait_on_page_writeback(page);
+	folio_wait_writeback(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
-	 * physical page after reading from swap.
+	 * folio after reading from swap.
 	 */
-	arch_swap_restore(swap, page);
+	arch_swap_restore(swap, folio);
 
-	folio = page_folio(page);
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_page(&page, gfp, info, index);
 		if (error)
@@ -1759,21 +1752,21 @@ static int shmem_swapin_page(struct inod
 	spin_unlock_irq(&info->lock);
 
 	if (sgp == SGP_WRITE)
-		mark_page_accessed(page);
+		folio_mark_accessed(folio);
 
-	delete_from_swap_cache(page);
-	set_page_dirty(page);
+	delete_from_swap_cache(&folio->page);
+	folio_mark_dirty(folio);
 	swap_free(swap);
 
-	*pagep = page;
+	*foliop = folio;
 	return 0;
 failed:
 	if (!shmem_confirm_swap(mapping, index, swap))
 		error = -EEXIST;
 unlock:
-	if (page) {
-		unlock_page(page);
-		put_page(page);
+	if (folio) {
+		folio_unlock(folio);
+		folio_put(folio);
 	}
 
 	return error;
@@ -1827,13 +1820,12 @@ repeat:
 	}
 
 	if (xa_is_value(folio)) {
-		struct page *page = &folio->page;
-		error = shmem_swapin_page(inode, index, &page,
+		error = shmem_swapin_folio(inode, index, &folio,
 					  sgp, gfp, vma, fault_type);
 		if (error == -EEXIST)
 			goto repeat;
 
-		*pagep = page;
+		*pagep = &folio->page;
 		return error;
 	}
 
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

