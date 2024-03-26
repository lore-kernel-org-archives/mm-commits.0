Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A18B126F15
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 20:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711486008; cv=none; b=XwAe7BzKiWdGyubLLo027OnG4vxcJMXFW9nWnZvMNRli9CNJ8H8g4swiqP/6o85IZRtMETpLu1+/3wpYdPfRGVCMEireZNYtvzG3vVSMypj4CNsBn5dboyKpNiz92kb57Hc2/mK99sXQoEFI0qSXFgMyvZJR5XVVYFXf2SjvyDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711486008; c=relaxed/simple;
	bh=886poKgGqorApAHA3FYPJ74NYAbRJGndUgJoczjgrmg=;
	h=Date:To:From:Subject:Message-Id; b=X9sYDWnmSCDB93gPwSrllieHVs0vZ61xBOoOD/kn2fzO9KE/dUTtDTTx3u96+WqWGYRsYQKBYZpHvex8kMiy2/S3Z4Nc9L5Ct114BWKRmU0ejDqj1lANtw3e3ZDIVmjB3sF8xKihST6frhZSlBglDoaXobkdaXVjz+azFJ7+xHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gkZGpGK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gkZGpGK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221A8C433F1;
	Tue, 26 Mar 2024 20:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711486008;
	bh=886poKgGqorApAHA3FYPJ74NYAbRJGndUgJoczjgrmg=;
	h=Date:To:From:Subject:From;
	b=gkZGpGK5geSRa8VQ57Mtqf2kG2dP2cx5ym9h68eHPN7G4LnvpKlvSsrKETiaMFxIA
	 AQxN9hAv1q2S8F7ISVJsu4/LlCDKZxDfo70lNrmtPERoi+uMr0h7m7QTdXAfsKuBev
	 VOGFQq4Y15jcdSv950tLu7V0rq8ptukAruntbKPU=
Date: Tue, 26 Mar 2024 13:46:47 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch added to mm-unstable branch
Message-Id: <20240326204648.221A8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: convert do_huge_pmd_anonymous_page to huge_zero_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch

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
Subject: mm: convert do_huge_pmd_anonymous_page to huge_zero_folio
Date: Tue, 26 Mar 2024 20:28:26 +0000

Use folios more widely.

Link: https://lkml.kernel.org/r/20240326202833.523759-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
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
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch

