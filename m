Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E178061B
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104121; cv=none; b=m3wfOc0FSPFTOJaH1/eZk/Bq/El+YEll6xjBzn2NBI4B466d1iitv2LOaN3QcArfHXAJ16t5LeHQ/tmSLsJygq13W+ESqta3fwSrWT+y9h1eXzLpkwnClFWNIquL3HA9ovWlPA04Cl+UZTU8Oa6BTAS7l/rUhQculWuCgZyxiwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104121; c=relaxed/simple;
	bh=Fybl+FMxTx2Ad5oLDnhbDOIcmzwI/WwUMneEm4FHQ2Y=;
	h=Date:To:From:Subject:Message-Id; b=Su/SEbGnpVyYS6FrkDuDKHTiVKGmotmdbFgz0npDVyAltoiBPEvwp3MX8SDaHVL7xBFQ3SfwOJhiJnC7pv8VtiofTdLiop+3azmG8L6nfigAj6MKbLchFAcHINIhbkBSs5TmmTfhOldsCpxlVaYrTnuO6vm6a/pjfeMaQUxbNS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EcSRiBxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EcSRiBxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A68C116B1;
	Fri, 26 Apr 2024 04:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104121;
	bh=Fybl+FMxTx2Ad5oLDnhbDOIcmzwI/WwUMneEm4FHQ2Y=;
	h=Date:To:From:Subject:From;
	b=EcSRiBxM2YXmYCIdSIL+zgjmng+/5Npj8yriQnu6ZD8/utPVGbBVN/YjLo80c9O7e
	 LRmnPDxpsNZ6i/momwTmWysocIYMftFPM06Tijt9Wpi6KdZwUnRV1OEt/9a6A49JJY
	 4UrStnHW2EJGQ3IJ1YJ/kBKmCYZBlEbN/DmzQri8=
Date: Thu, 25 Apr 2024 21:02:01 -0700
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch removed from -mm tree
Message-Id: <20240426040201.A7A68C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: pass a folio to __collapse_huge_page_copy()
has been removed from the -mm tree.  Its filename was
     khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: khugepaged: pass a folio to __collapse_huge_page_copy()
Date: Wed, 3 Apr 2024 18:18:33 +0100

Simplify the body of __collapse_huge_page_copy() while I'm looking at
it.

Link: https://lkml.kernel.org/r/20240403171838.1445826-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

--- a/mm/khugepaged.c~khugepaged-pass-a-folio-to-__collapse_huge_page_copy
+++ a/mm/khugepaged.c
@@ -767,7 +767,7 @@ static void __collapse_huge_page_copy_fa
  * Returns SCAN_SUCCEED if copying succeeds, otherwise returns SCAN_COPY_MC.
  *
  * @pte: starting of the PTEs to copy from
- * @page: the new hugepage to copy contents to
+ * @folio: the new hugepage to copy contents to
  * @pmd: pointer to the new hugepage's PMD
  * @orig_pmd: the original raw pages' PMD
  * @vma: the original raw pages' virtual memory area
@@ -775,33 +775,29 @@ static void __collapse_huge_page_copy_fa
  * @ptl: lock on raw pages' PTEs
  * @compound_pagelist: list that stores compound pages
  */
-static int __collapse_huge_page_copy(pte_t *pte,
-				     struct page *page,
-				     pmd_t *pmd,
-				     pmd_t orig_pmd,
-				     struct vm_area_struct *vma,
-				     unsigned long address,
-				     spinlock_t *ptl,
-				     struct list_head *compound_pagelist)
-{
-	struct page *src_page;
-	pte_t *_pte;
-	pte_t pteval;
-	unsigned long _address;
+static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
+		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
+		unsigned long address, spinlock_t *ptl,
+		struct list_head *compound_pagelist)
+{
+	unsigned int i;
 	int result = SCAN_SUCCEED;
 
 	/*
 	 * Copying pages' contents is subject to memory poison at any iteration.
 	 */
-	for (_pte = pte, _address = address; _pte < pte + HPAGE_PMD_NR;
-	     _pte++, page++, _address += PAGE_SIZE) {
-		pteval = ptep_get(_pte);
+	for (i = 0; i < HPAGE_PMD_NR; i++) {
+		pte_t pteval = ptep_get(pte + i);
+		struct page *page = folio_page(folio, i);
+		unsigned long src_addr = address + i * PAGE_SIZE;
+		struct page *src_page;
+
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			clear_user_highpage(page, _address);
+			clear_user_highpage(page, src_addr);
 			continue;
 		}
 		src_page = pte_page(pteval);
-		if (copy_mc_user_highpage(page, src_page, _address, vma) > 0) {
+		if (copy_mc_user_highpage(page, src_page, src_addr, vma) > 0) {
 			result = SCAN_COPY_MC;
 			break;
 		}
@@ -1196,7 +1192,7 @@ static int collapse_huge_page(struct mm_
 	 */
 	anon_vma_unlock_write(vma->anon_vma);
 
-	result = __collapse_huge_page_copy(pte, &folio->page, pmd, _pmd,
+	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
 					   vma, address, pte_ptl,
 					   &compound_pagelist);
 	pte_unmap(pte);
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

