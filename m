Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8377154458
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 19:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712171556; cv=none; b=CLw2GBLYlKJJI8t6nWBgiAAgF+7Lp3TajnrxO2NiujxIgTNZEPlxdnKJTyDjpPdPx98q1wzI/nE3IYdAD1kUVBDApO4R3hgYT22wCMWkcIv+SHWq8TIDc7rNiIf4n3UgFpzyRPASR4uoCGNj2KlDzuZIO16zLuQRRNfC5tmM0jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712171556; c=relaxed/simple;
	bh=K9Q8+bIvPfwFJ6GVcDwZ/B6Z14utP2JKtr7z5x+Gr1c=;
	h=Date:To:From:Subject:Message-Id; b=kn9+/Z5Qy5kl6HpIED+Db+/NohwCdVGBLNh5V/KdbtZc16uBHKjusjMBUJop5YhkeIQKDfGGvFj7QAPH4LVD4X5JYI26nSSAFMCAm50ZzKPFezvMOPHo3FpzguTNPgGt03xLzONnvdDPoSySZna+fi1777jqtP6uzF/faLsx8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t+EOc3Q0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t+EOc3Q0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534B6C43390;
	Wed,  3 Apr 2024 19:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712171555;
	bh=K9Q8+bIvPfwFJ6GVcDwZ/B6Z14utP2JKtr7z5x+Gr1c=;
	h=Date:To:From:Subject:From;
	b=t+EOc3Q0rM1JCQnEMr7yQdB9AfBd2Gv1v6yq510DeDzrZjKt0KBpSPwMemKn0XZ6U
	 9cBH5b1vcMNLK79TOS6SaQpJPVgcB9jl1ScdP5qdi2LzaNPpTKUdUC3f1v25yiq3K4
	 Cx7NZcg/YJqCWCLoRFrvwHXS72LgvzMN1ygGfAtA=
Date: Wed, 03 Apr 2024 12:12:34 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-convert-clear_refs_pte_range-to-use-a-folio.patch added to mm-unstable branch
Message-Id: <20240403191235.534B6C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: convert clear_refs_pte_range to use a folio
has been added to the -mm mm-unstable branch.  Its filename is
     proc-convert-clear_refs_pte_range-to-use-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-convert-clear_refs_pte_range-to-use-a-folio.patch

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
Subject: proc: convert clear_refs_pte_range to use a folio
Date: Tue, 2 Apr 2024 21:12:48 +0100

Patch series "Remove page_idle and page_young wrappers".

There are only a couple of places left using the page wrappers for idle &
young tracking.  Convert the two users in proc and then we can remove the
wrappers.  That enables the further simplification of autogenerating the
definitions when CONFIG_PAGE_IDLE_FLAG is disabled.  


This patch (of 4):

Replaces four calls to compound_head() with two.

Link: https://lkml.kernel.org/r/20240402201252.917342-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240402201252.917342-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/proc/task_mmu.c~proc-convert-clear_refs_pte_range-to-use-a-folio
+++ a/fs/proc/task_mmu.c
@@ -1161,7 +1161,7 @@ static int clear_refs_pte_range(pmd_t *p
 	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
-	struct page *page;
+	struct folio *folio;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
@@ -1173,12 +1173,12 @@ static int clear_refs_pte_range(pmd_t *p
 		if (!pmd_present(*pmd))
 			goto out;
 
-		page = pmd_page(*pmd);
+		folio = pmd_folio(*pmd);
 
 		/* Clear accessed and referenced bits. */
 		pmdp_test_and_clear_young(vma, addr, pmd);
-		test_and_clear_page_young(page);
-		ClearPageReferenced(page);
+		folio_test_clear_young(folio);
+		folio_clear_referenced(folio);
 out:
 		spin_unlock(ptl);
 		return 0;
@@ -1200,14 +1200,14 @@ out:
 		if (!pte_present(ptent))
 			continue;
 
-		page = vm_normal_page(vma, addr, ptent);
-		if (!page)
+		folio = vm_normal_folio(vma, addr, ptent);
+		if (!folio)
 			continue;
 
 		/* Clear accessed and referenced bits. */
 		ptep_test_and_clear_young(vma, addr, pte);
-		test_and_clear_page_young(page);
-		ClearPageReferenced(page);
+		folio_test_clear_young(folio);
+		folio_clear_referenced(folio);
 	}
 	pte_unmap_unlock(pte - 1, ptl);
 	cond_resched();
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
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch

