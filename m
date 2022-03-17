Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D0FFC4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Mar 2022 23:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiCQXaB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Mar 2022 19:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiCQX3w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Mar 2022 19:29:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0683D3738
        for <mm-commits@vger.kernel.org>; Thu, 17 Mar 2022 16:28:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39F51B820D5
        for <mm-commits@vger.kernel.org>; Thu, 17 Mar 2022 23:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED09CC340EC;
        Thu, 17 Mar 2022 23:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647559710;
        bh=IbnFLfKQOAjWfkE8e6GEeK1pHD8TJr2GGx0kMZEnmfY=;
        h=Date:To:From:Subject:From;
        b=MNGRygfbCyFvlk6VxWCoUkzbZJxnoMxN378d5J7UKVyM/c0mXBSgnvHH6/+w8tSDm
         iSSMWJeZjjlIAa6qPxgoP5mORjVGUpHsD2Gy/7LqpOlKuaAtH5TGuZ3LopbtdkP673
         ICvDsFJde0nUowVHdvdOoF2dWaIfwX9IqHrEPBB4=
Date:   Thu, 17 Mar 2022 16:28:29 -0700
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        xiyuyang19@fudan.edu.cn, willy@infradead.org,
        viro@zeniv.linux.org.uk, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jack@suse.cz, hughd@google.com,
        hch@infradead.org, duanxiongchun@bytedance.com,
        dan.j.williams@intel.com, apopple@nvidia.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch removed from -mm tree
Message-Id: <20220317232829.ED09CC340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: rmap: introduce pfn_mkclean_range() to cleans PTEs
has been removed from the -mm tree.  Its filename was
     mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: rmap: introduce pfn_mkclean_range() to cleans PTEs

The page_mkclean_one() is supposed to be used with the pfn that has a
associated struct page, but not all the pfns (e.g.  DAX) have a struct
page.  Introduce a new function pfn_mkclean_range() to cleans the PTEs
(including PMDs) mapped with range of pfns which has no struct page
associated with them.  This helper will be used by DAX device in the next
patch to make pfns clean.

Link: https://lkml.kernel.org/r/20220302082718.32268-4-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    3 +
 mm/internal.h        |   26 ++++++++++------
 mm/rmap.c            |   65 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 74 insertions(+), 20 deletions(-)

--- a/include/linux/rmap.h~mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes
+++ a/include/linux/rmap.h
@@ -263,6 +263,9 @@ unsigned long page_address_in_vma(struct
  */
 int folio_mkclean(struct folio *);
 
+int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
+		      struct vm_area_struct *vma);
+
 void remove_migration_ptes(struct folio *src, struct folio *dst, bool locked);
 
 /*
--- a/mm/internal.h~mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes
+++ a/mm/internal.h
@@ -461,26 +461,22 @@ void mlock_page_drain(int cpu);
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
- * At what user virtual address is page expected in vma?
- * Returns -EFAULT if all of the page is outside the range of vma.
- * If page is a compound head, the entire compound page is considered.
+ * * Return the start of user virtual address at the specific offset within
+ * a vma.
  */
 static inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
+vma_pgoff_address(pgoff_t pgoff, unsigned long nr_pages,
+		  struct vm_area_struct *vma)
 {
-	pgoff_t pgoff;
 	unsigned long address;
 
-	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
-	pgoff = page_to_pgoff(page);
 	if (pgoff >= vma->vm_pgoff) {
 		address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		/* Check for address beyond vma (or wrapped through 0?) */
 		if (address < vma->vm_start || address >= vma->vm_end)
 			address = -EFAULT;
-	} else if (PageHead(page) &&
-		   pgoff + compound_nr(page) - 1 >= vma->vm_pgoff) {
+	} else if (pgoff + nr_pages - 1 >= vma->vm_pgoff) {
 		/* Test above avoids possibility of wrap to 0 on 32-bit */
 		address = vma->vm_start;
 	} else {
@@ -490,6 +486,18 @@ vma_address(struct page *page, struct vm
 }
 
 /*
+ * Return the start of user virtual address of a page within a vma.
+ * Returns -EFAULT if all of the page is outside the range of vma.
+ * If page is a compound head, the entire compound page is considered.
+ */
+static inline unsigned long
+vma_address(struct page *page, struct vm_area_struct *vma)
+{
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	return vma_pgoff_address(page_to_pgoff(page), compound_nr(page), vma);
+}
+
+/*
  * Then at what user virtual address will none of the range be found in vma?
  * Assumes that vma_address() already returned a good starting address.
  */
--- a/mm/rmap.c~mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes
+++ a/mm/rmap.c
@@ -927,12 +927,12 @@ int folio_referenced(struct folio *folio
 	return pra.referenced;
 }
 
-static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
-			    unsigned long address, void *arg)
+static int page_vma_mkclean_one(struct page_vma_mapped_walk *pvmw)
 {
-	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
+	int cleaned = 0;
+	struct vm_area_struct *vma = pvmw->vma;
 	struct mmu_notifier_range range;
-	int *cleaned = arg;
+	unsigned long address = pvmw->address;
 
 	/*
 	 * We have to assume the worse case ie pmd for invalidation. Note that
@@ -940,16 +940,16 @@ static bool page_mkclean_one(struct foli
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
 				0, vma, vma->vm_mm, address,
-				vma_address_end(&pvmw));
+				vma_address_end(pvmw));
 	mmu_notifier_invalidate_range_start(&range);
 
-	while (page_vma_mapped_walk(&pvmw)) {
+	while (page_vma_mapped_walk(pvmw)) {
 		int ret = 0;
 
-		address = pvmw.address;
-		if (pvmw.pte) {
+		address = pvmw->address;
+		if (pvmw->pte) {
 			pte_t entry;
-			pte_t *pte = pvmw.pte;
+			pte_t *pte = pvmw->pte;
 
 			if (!pte_dirty(*pte) && !pte_write(*pte))
 				continue;
@@ -962,7 +962,7 @@ static bool page_mkclean_one(struct foli
 			ret = 1;
 		} else {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-			pmd_t *pmd = pvmw.pmd;
+			pmd_t *pmd = pvmw->pmd;
 			pmd_t entry;
 
 			if (!pmd_dirty(*pmd) && !pmd_write(*pmd))
@@ -989,11 +989,22 @@ static bool page_mkclean_one(struct foli
 		 * See Documentation/vm/mmu_notifier.rst
 		 */
 		if (ret)
-			(*cleaned)++;
+			cleaned++;
 	}
 
 	mmu_notifier_invalidate_range_end(&range);
 
+	return cleaned;
+}
+
+static bool page_mkclean_one(struct folio *folio, struct vm_area_struct *vma,
+			     unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
+	int *cleaned = arg;
+
+	*cleaned += page_vma_mkclean_one(&pvmw);
+
 	return true;
 }
 
@@ -1031,6 +1042,38 @@ int folio_mkclean(struct folio *folio)
 EXPORT_SYMBOL_GPL(folio_mkclean);
 
 /**
+ * pfn_mkclean_range - Cleans the PTEs (including PMDs) mapped with range of
+ *                     [@pfn, @pfn + @nr_pages) at the specific offset (@pgoff)
+ *                     within the @vma of shared mappings. And since clean PTEs
+ *                     should also be readonly, write protects them too.
+ * @pfn: start pfn.
+ * @nr_pages: number of physically contiguous pages srarting with @pfn.
+ * @pgoff: page offset that the @pfn mapped with.
+ * @vma: vma that @pfn mapped within.
+ *
+ * Returns the number of cleaned PTEs (including PMDs).
+ */
+int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
+		      struct vm_area_struct *vma)
+{
+	struct page_vma_mapped_walk pvmw = {
+		.pfn		= pfn,
+		.nr_pages	= nr_pages,
+		.pgoff		= pgoff,
+		.vma		= vma,
+		.flags		= PVMW_SYNC,
+	};
+
+	if (invalid_mkclean_vma(vma, NULL))
+		return 0;
+
+	pvmw.address = vma_pgoff_address(pgoff, nr_pages, vma);
+	VM_BUG_ON_VMA(pvmw.address == -EFAULT, vma);
+
+	return page_vma_mkclean_one(&pvmw);
+}
+
+/**
  * page_move_anon_rmap - move a page to our anon_vma
  * @page:	the page to move to our anon_vma
  * @vma:	the vma the page belongs to
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-list_lru-transpose-the-array-of-per-node-per-memcg-lru-lists.patch
mm-introduce-kmem_cache_alloc_lru.patch
fs-introduce-alloc_inode_sb-to-allocate-filesystems-specific-inode.patch
fs-allocate-inode-by-using-alloc_inode_sb.patch
f2fs-allocate-inode-by-using-alloc_inode_sb.patch
mm-dcache-use-kmem_cache_alloc_lru-to-allocate-dentry.patch
xarray-use-kmem_cache_alloc_lru-to-allocate-xa_node.patch
mm-memcontrol-move-memcg_online_kmem-to-mem_cgroup_css_online.patch
mm-list_lru-allocate-list_lru_one-only-when-needed.patch
mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus.patch
mm-list_lru-replace-linear-array-with-xarray.patch
mm-memcontrol-reuse-memory-cgroup-id-for-kmem-id.patch
mm-memcontrol-fix-cannot-alloc-the-maximum-memcg-id.patch
mm-list_lru-rename-list_lru_per_memcg-to-list_lru_memcg.patch
mm-memcontrol-rename-memcg_cache_id-to-memcg_kmem_id.patch
mm-thp-fix-wrong-cache-flush-in-remove_migration_pmd.patch
mm-fix-missing-cache-flush-for-all-tail-pages-of-compound-page.patch
mm-hugetlb-fix-missing-cache-flush-in-copy_huge_page_from_user.patch
mm-hugetlb-fix-missing-cache-flush-in-hugetlb_mcopy_atomic_pte.patch
mm-shmem-fix-missing-cache-flush-in-shmem_mfill_atomic_pte.patch
mm-userfaultfd-fix-missing-cache-flush-in-mcopy_atomic_pte-and-__mcopy_atomic.patch
mm-replace-multiple-dcache-flush-with-flush_dcache_folio.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page.patch
mm-hugetlb-free-the-2nd-vmemmap-page-associated-with-each-hugetlb-page-fix.patch
mm-hugetlb-replace-hugetlb_free_vmemmap_enabled-with-a-static_key.patch
mm-sparsemem-use-page-table-lock-to-protect-kernel-pmd-operations.patch
selftests-vm-add-a-hugetlb-test-case.patch
mm-sparsemem-move-vmemmap-related-to-hugetlb-to-config_hugetlb_page_free_vmemmap.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
mm-remove-range-parameter-from-follow_invalidate_pte.patch

