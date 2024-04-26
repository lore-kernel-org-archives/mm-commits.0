Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C4380055
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104046; cv=none; b=BhNzObCozI32ZilEKx/gyA4tTFjDuBPfuDhvQj7lSzBK7JtaWrPEWp0pLDSjzzWiVwLzceMSKj4YyB7by3b1KGzNl3D9JTxaKW4xLkM1FNbvoDe9aDwzvzPnH6/uQMP3j+T9ZBq0NGheYUBZQERieB1PmoVoVN/iGxu2Yh5q8Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104046; c=relaxed/simple;
	bh=c2yhXjeoPK/3TarKcbDe1GBTqLHXjlW90GwPOfIFF7M=;
	h=Date:To:From:Subject:Message-Id; b=Ec221NZrmyMqrCOvlYIjkzmgigOhWDmo4t/u9L/OsrnQ0T0J1ZLlV3uH1PC38XdWbPBXdCvb/F6xZmsC5KfDOnsoUReQlorHnomCiAA3Je1ZaL5PO+O6t4eQ9ns60W/iVbjbIG1tvsz4nIu7HIc3zf+HXsRMRAZNyzQ9DCoF3s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CVP6hHpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CVP6hHpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8BAC116B1;
	Fri, 26 Apr 2024 04:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104046;
	bh=c2yhXjeoPK/3TarKcbDe1GBTqLHXjlW90GwPOfIFF7M=;
	h=Date:To:From:Subject:From;
	b=CVP6hHpYHnQhPmEYfxdiFz+B5BVL9ZvWZe8IUUZweEceZaRA1soAaF/DshQ4eKQd+
	 IN9KPkD3yCWqq2X/Ya8tvCULn2oHpOdeyNxLWYt57nZm2WLoW62ZP1l7ucd9AYdhTP
	 vPF/ucDiLpT85nvI5U7d9hCphXYLlJmGHDehThYQ=
Date: Thu, 25 Apr 2024 21:00:45 -0700
To: mm-commits@vger.kernel.org,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch removed from -mm tree
Message-Id: <20240426040045.EB8BAC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: convert do_huge_pmd_anonymous_page to huge_zero_folio
has been removed from the -mm tree.  Its filename was
     mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert do_huge_pmd_anonymous_page to huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:26 +0000

Use folios more widely.

Link: https://lkml.kernel.org/r/20240326202833.523759-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/huge_memory.c~mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio
+++ a/mm/huge_memory.c
@@ -971,14 +971,14 @@ gfp_t vma_thp_gfp_mask(struct vm_area_st
 }
 
 /* Caller must hold page table lock. */
-static void set_huge_zero_page(pgtable_t pgtable, struct mm_struct *mm,
+static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long haddr, pmd_t *pmd,
-		struct page *zero_page)
+		struct folio *zero_folio)
 {
 	pmd_t entry;
 	if (!pmd_none(*pmd))
 		return;
-	entry = mk_pmd(zero_page, vma->vm_page_prot);
+	entry = mk_pmd(&zero_folio->page, vma->vm_page_prot);
 	entry = pmd_mkhuge(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
@@ -1002,13 +1002,14 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 			!mm_forbids_zeropage(vma->vm_mm) &&
 			transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
-		struct page *zero_page;
+		struct folio *zero_folio;
 		vm_fault_t ret;
+
 		pgtable = pte_alloc_one(vma->vm_mm);
 		if (unlikely(!pgtable))
 			return VM_FAULT_OOM;
-		zero_page = mm_get_huge_zero_page(vma->vm_mm);
-		if (unlikely(!zero_page)) {
+		zero_folio = mm_get_huge_zero_folio(vma->vm_mm);
+		if (unlikely(!zero_folio)) {
 			pte_free(vma->vm_mm, pgtable);
 			count_vm_event(THP_FAULT_FALLBACK);
 			return VM_FAULT_FALLBACK;
@@ -1026,8 +1027,8 @@ vm_fault_t do_huge_pmd_anonymous_page(st
 				ret = handle_userfault(vmf, VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
-				set_huge_zero_page(pgtable, vma->vm_mm, vma,
-						   haddr, vmf->pmd, zero_page);
+				set_huge_zero_folio(pgtable, vma->vm_mm, vma,
+						   haddr, vmf->pmd, zero_folio);
 				update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 				spin_unlock(vmf->ptl);
 			}
@@ -1336,9 +1337,9 @@ int copy_huge_pmd(struct mm_struct *dst_
 	 */
 	if (is_huge_zero_pmd(pmd)) {
 		/*
-		 * get_huge_zero_page() will never allocate a new page here,
-		 * since we already have a zero page to copy. It just takes a
-		 * reference.
+		 * mm_get_huge_zero_folio() will never allocate a new
+		 * folio here, since we already have a zero page to
+		 * copy. It just takes a reference.
 		 */
 		mm_get_huge_zero_folio(dst_mm);
 		goto out_zero_page;
_

Patches currently in -mm which might be from willy@infradead.org are

doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch
doc-split-bufferrst-out-of-api-summaryrst-fix.patch
mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch
mm-memory-failure-pass-addr-to-__add_to_kill.patch
mm-return-the-address-from-page_mapped_in_vma.patch
mm-make-page_mapped_in_vma-conditional-on-config_memory_failure.patch
mm-memory-failure-convert-shake_page-to-shake_folio.patch
mm-convert-hugetlb_page_mapping_lock_write-to-folio.patch
mm-memory-failure-convert-memory_failure-to-use-a-folio.patch
mm-memory-failure-convert-hwpoison_user_mappings-to-take-a-folio.patch
mm-memory-failure-add-some-folio-conversions-to-unpoison_memory.patch
mm-memory-failure-use-folio-functions-throughout-collect_procs.patch
mm-memory-failure-pass-the-folio-to-collect_procs_ksm.patch
fscrypt-convert-bh_get_inode_and_lblk_num-to-use-a-folio.patch
f2fs-convert-f2fs_clear_page_cache_dirty_tag-to-use-a-folio.patch
memory-failure-remove-calls-to-page_mapping.patch
migrate-expand-the-use-of-folio-in-__migrate_device_pages.patch
userfault-expand-folio-use-in-mfill_atomic_install_pte.patch
mm-remove-page_mapping.patch
mm-remove-page_cache_alloc.patch
mm-remove-put_devmap_managed_page.patch
mm-convert-put_devmap_managed_page_refs-to-put_devmap_managed_folio_refs.patch
mm-remove-page_ref_sub_return.patch
gup-use-folios-for-gup_devmap.patch
mm-add-kernel-doc-for-folio_mark_accessed.patch
mm-remove-pagereferenced.patch
mm-simplify-thp_vma_allowable_order.patch

