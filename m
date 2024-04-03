Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2568C1D54B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171139; cv=none; b=d6c/dZuT8xUbDHKogwmkAx/vEOOtv5IbGcWiX3prKKXJgkxFipNq0B3C41SxoGwjpVv79tomVsitq1IXRpNm7+v/EaVj2nUzTUmIupNReoaqAFVd5ptl/YI1Ox5a1+bYsnT5GgEM+n4oxiwq+QC7kQI7VVKcdyQrIdZ+z9vjhuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171139; c=relaxed/simple;
	bh=iSYug6sh77ltaLc3iPP5rC49LLWotdrgZnAuK6Pgr5M=;
	h=Date:To:From:Subject:Message-Id; b=PC+pT3+QgFjxivNUbzemy+OkZFhQgZDGGlhjZiKxEWGp2Ek9LKQXYNcFFNz7nAfbMIGAPHZrdxkxuA1aQDMxtio8ztUVWnXP91TjXR3hDoD2r0+sQc0WLmcrrWURucUYHLH3HJ//Dp+NN9x3mTI2NtFTX5K4t8CxxHSr2Rpfcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RPlFShNY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RPlFShNY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39A1C433F1;
	Wed,  3 Apr 2024 19:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171138;
	bh=iSYug6sh77ltaLc3iPP5rC49LLWotdrgZnAuK6Pgr5M=;
	h=Date:To:From:Subject:From;
	b=RPlFShNYYWsaMOVV/UPHn6GC4FOIBOoPNUyu3VKjEY8ExOVjbOdPz9ohIY8sXRS1v
	 6bZKJLQfbIz7r+D9kFcBIonbXDn2NpcAKQRRODUYCGcGFyK7XeKPYIzsVo00fncnVX
	 IdFXscKpMLsf+FPqUb6vpVekBr0yePgxPfcsdXbo=
Date: Wed, 03 Apr 2024 12:05:37 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch added to mm-unstable branch
Message-Id: <20240403190538.A39A1C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: pass a folio to __collapse_huge_page_copy()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch

This patch will later appear in the mm-unstable branch at
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
Subject: khugepaged: pass a folio to __collapse_huge_page_copy()
Date: Wed, 3 Apr 2024 18:18:33 +0100

Simplify the body of __collapse_huge_page_copy() while I'm looking at
it.

Link: https://lkml.kernel.org/r/20240403171838.1445826-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch

