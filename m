Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1812C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383808AbiEMTXn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383838AbiEMTWh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9723C739
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 387D062262
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF0FC34100;
        Fri, 13 May 2022 19:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469718;
        bh=BmzYbS47jcjjGxPCMSwNqbTVZWW4nLA2IuN6ZmG0Dco=;
        h=Date:To:From:Subject:From;
        b=phyYOC2SN+U+iIIdaAeWCpQ3jO+swImqx8PHgfNxi3Uz1z47IRr+jgoNS+w83O3wK
         ySZT2JzfOM2p7dQQLEqjunhTvZ6FgMf5RRT2pbgQ96bDVoZYWkv0qEpSeK7M0p78R7
         BHgpO20cm3z52Fz1BeoyHM+qa2kgIhlzYy4zATz8=
Date:   Fri, 13 May 2022 12:21:58 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch removed from -mm tree
Message-Id: <20220513192158.8EF0FC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: convert shmem_add_to_page_cache to take a folio
has been removed from the -mm tree.  Its filename was
     mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/shmem: convert shmem_add_to_page_cache to take a folio

Shrinks shmem_add_to_page_cache() by 16 bytes.  All the callers grow,
but this is temporary as they will all be converted to folios soon.

Link: https://lkml.kernel.org/r/20220504182857.4013401-19-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   59 +++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

--- a/mm/shmem.c~mm-shmem-convert-shmem_add_to_page_cache-to-take-a-folio
+++ a/mm/shmem.c
@@ -696,36 +696,35 @@ static unsigned long shmem_unused_huge_s
 /*
  * Like add_to_page_cache_locked, but error if expected item has gone.
  */
-static int shmem_add_to_page_cache(struct page *page,
+static int shmem_add_to_page_cache(struct folio *folio,
 				   struct address_space *mapping,
 				   pgoff_t index, void *expected, gfp_t gfp,
 				   struct mm_struct *charge_mm)
 {
-	XA_STATE_ORDER(xas, &mapping->i_pages, index, compound_order(page));
-	unsigned long nr = compound_nr(page);
+	XA_STATE_ORDER(xas, &mapping->i_pages, index, folio_order(folio));
+	long nr = folio_nr_pages(folio);
 	int error;
 
-	VM_BUG_ON_PAGE(PageTail(page), page);
-	VM_BUG_ON_PAGE(index != round_down(index, nr), page);
-	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
-	VM_BUG_ON(expected && PageTransHuge(page));
-
-	page_ref_add(page, nr);
-	page->mapping = mapping;
-	page->index = index;
+	VM_BUG_ON_FOLIO(index != round_down(index, nr), folio);
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_BUG_ON_FOLIO(!folio_test_swapbacked(folio), folio);
+	VM_BUG_ON(expected && folio_test_large(folio));
+
+	folio_ref_add(folio, nr);
+	folio->mapping = mapping;
+	folio->index = index;
 
-	if (!PageSwapCache(page)) {
-		error = mem_cgroup_charge(page_folio(page), charge_mm, gfp);
+	if (!folio_test_swapcache(folio)) {
+		error = mem_cgroup_charge(folio, charge_mm, gfp);
 		if (error) {
-			if (PageTransHuge(page)) {
+			if (folio_test_pmd_mappable(folio)) {
 				count_vm_event(THP_FILE_FALLBACK);
 				count_vm_event(THP_FILE_FALLBACK_CHARGE);
 			}
 			goto error;
 		}
 	}
-	cgroup_throttle_swaprate(page, gfp);
+	folio_throttle_swaprate(folio, gfp);
 
 	do {
 		xas_lock_irq(&xas);
@@ -737,16 +736,16 @@ static int shmem_add_to_page_cache(struc
 			xas_set_err(&xas, -EEXIST);
 			goto unlock;
 		}
-		xas_store(&xas, page);
+		xas_store(&xas, folio);
 		if (xas_error(&xas))
 			goto unlock;
-		if (PageTransHuge(page)) {
+		if (folio_test_pmd_mappable(folio)) {
 			count_vm_event(THP_FILE_ALLOC);
-			__mod_lruvec_page_state(page, NR_SHMEM_THPS, nr);
+			__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, nr);
 		}
 		mapping->nrpages += nr;
-		__mod_lruvec_page_state(page, NR_FILE_PAGES, nr);
-		__mod_lruvec_page_state(page, NR_SHMEM, nr);
+		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
+		__lruvec_stat_mod_folio(folio, NR_SHMEM, nr);
 unlock:
 		xas_unlock_irq(&xas);
 	} while (xas_nomem(&xas, gfp));
@@ -758,8 +757,8 @@ unlock:
 
 	return 0;
 error:
-	page->mapping = NULL;
-	page_ref_sub(page, nr);
+	folio->mapping = NULL;
+	folio_ref_sub(folio, nr);
 	return error;
 }
 
@@ -1691,7 +1690,8 @@ static int shmem_swapin_page(struct inod
 	struct address_space *mapping = inode->i_mapping;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct mm_struct *charge_mm = vma ? vma->vm_mm : NULL;
-	struct page *page;
+	struct page *page = NULL;
+	struct folio *folio;
 	swp_entry_t swap;
 	int error;
 
@@ -1741,7 +1741,8 @@ static int shmem_swapin_page(struct inod
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(page, mapping, index,
+	folio = page_folio(page);
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp,
 					charge_mm);
 	if (error)
@@ -1792,6 +1793,7 @@ static int shmem_getpage_gfp(struct inod
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	struct shmem_sb_info *sbinfo;
 	struct mm_struct *charge_mm;
+	struct folio *folio;
 	struct page *page;
 	pgoff_t hindex = index;
 	gfp_t huge_gfp;
@@ -1906,7 +1908,8 @@ alloc_nohuge:
 	if (sgp == SGP_WRITE)
 		__SetPageReferenced(page);
 
-	error = shmem_add_to_page_cache(page, mapping, hindex,
+	folio = page_folio(page);
+	error = shmem_add_to_page_cache(folio, mapping, hindex,
 					NULL, gfp & GFP_RECLAIM_MASK,
 					charge_mm);
 	if (error)
@@ -2328,6 +2331,7 @@ int shmem_mfill_atomic_pte(struct mm_str
 	gfp_t gfp = mapping_gfp_mask(mapping);
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
 	void *page_kaddr;
+	struct folio *folio;
 	struct page *page;
 	int ret;
 	pgoff_t max_off;
@@ -2386,7 +2390,8 @@ int shmem_mfill_atomic_pte(struct mm_str
 	if (unlikely(pgoff >= max_off))
 		goto out_release;
 
-	ret = shmem_add_to_page_cache(page, mapping, pgoff, NULL,
+	folio = page_folio(page);
+	ret = shmem_add_to_page_cache(folio, mapping, pgoff, NULL,
 				      gfp & GFP_RECLAIM_MASK, dst_mm);
 	if (ret)
 		goto out_release;
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

