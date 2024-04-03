Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725D11D54B
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171137; cv=none; b=VSeadI/8doKVx/m+8C387FLfGOMWV0/qSAsiKB6CexSs6H3uK3j0Vz7d4TBiXbjDfiHfYiQ6jBFchoImjSvpy0/Hpvf4wyPj2F+6agFvfguz8qHHTWELjqrbubMFDwYXszT8AhCbZIW+uD+uIMtDggL+w6sroYGls587oSyTGWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171137; c=relaxed/simple;
	bh=okK1U+Qhwo9BH3+8RwN5Ch40TVpWCwVoA+AolgZjc84=;
	h=Date:To:From:Subject:Message-Id; b=dYxe5q2C+TVCug5u992Y1u/IymNYdgBhkaIhyuYJ/I5Ebw6jVZVEo4ST14uUYDmAHp/Ft1pX0dHY0LfIFeK9g5SbZyzMy+0p6H1o/i8fzMPOjOkKEm/5JF85Pqy6pz2Q9quE3v9M3UZkpOJsSarUlL3q2H8zHNiHZ3F2+mCrbA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T/l1rsKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T/l1rsKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33827C433F1;
	Wed,  3 Apr 2024 19:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171137;
	bh=okK1U+Qhwo9BH3+8RwN5Ch40TVpWCwVoA+AolgZjc84=;
	h=Date:To:From:Subject:From;
	b=T/l1rsKLi99cBBAvWNv7cOoDyRwZgxmdBkaAVhqQMh2Mdn+Z6s7xt7Sud+vt0LUmy
	 nB8I+QAhSwLagqQ3/lNLRH8pf1zUsZkmARpO1tgTmFABv18pbFA0mPePVRTlaePCdw
	 E0K5iOjbEY+IM8/+ZcQAQBdytV7a7EmiRIxTl8jE=
Date: Wed, 03 Apr 2024 12:05:36 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-remove-hpage-from-collapse_huge_page.patch added to mm-unstable branch
Message-Id: <20240403190537.33827C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: remove hpage from collapse_huge_page()
has been added to the -mm mm-unstable branch.  Its filename is
     khugepaged-remove-hpage-from-collapse_huge_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-remove-hpage-from-collapse_huge_page.patch

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
Subject: khugepaged: remove hpage from collapse_huge_page()
Date: Wed, 3 Apr 2024 18:18:32 +0100

Work purely in terms of the folio.  Removes a call to compound_head()
in put_page().

Link: https://lkml.kernel.org/r/20240403171838.1445826-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/khugepaged.c~khugepaged-remove-hpage-from-collapse_huge_page
+++ a/mm/khugepaged.c
@@ -1082,7 +1082,6 @@ static int collapse_huge_page(struct mm_
 	pte_t *pte;
 	pgtable_t pgtable;
 	struct folio *folio;
-	struct page *hpage;
 	spinlock_t *pmd_ptl, *pte_ptl;
 	int result = SCAN_FAIL;
 	struct vm_area_struct *vma;
@@ -1099,7 +1098,6 @@ static int collapse_huge_page(struct mm_
 	mmap_read_unlock(mm);
 
 	result = alloc_charge_folio(&folio, mm, cc);
-	hpage = &folio->page;
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
 
@@ -1198,7 +1196,7 @@ static int collapse_huge_page(struct mm_
 	 */
 	anon_vma_unlock_write(vma->anon_vma);
 
-	result = __collapse_huge_page_copy(pte, hpage, pmd, _pmd,
+	result = __collapse_huge_page_copy(pte, &folio->page, pmd, _pmd,
 					   vma, address, pte_ptl,
 					   &compound_pagelist);
 	pte_unmap(pte);
@@ -1213,7 +1211,7 @@ static int collapse_huge_page(struct mm_
 	__folio_mark_uptodate(folio);
 	pgtable = pmd_pgtable(_pmd);
 
-	_pmd = mk_huge_pmd(hpage, vma->vm_page_prot);
+	_pmd = mk_huge_pmd(&folio->page, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
 	spin_lock(pmd_ptl);
@@ -1225,14 +1223,14 @@ static int collapse_huge_page(struct mm_
 	update_mmu_cache_pmd(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 
-	hpage = NULL;
+	folio = NULL;
 
 	result = SCAN_SUCCEED;
 out_up_write:
 	mmap_write_unlock(mm);
 out_nolock:
-	if (hpage)
-		put_page(hpage);
+	if (folio)
+		folio_put(folio);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
 	return result;
 }
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

