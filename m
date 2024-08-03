Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C068413E02B
	for <mm-commits@vger.kernel.org>; Sat,  3 Aug 2024 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722663232; cv=none; b=rc64SQB7e1YhGTiYKqyyYbs5XkS5MdfZHjD7AfvfxtQ9F8SBRhMKa9i8wksWHRLx2gUR6WkhCObcVvJ6DTzf9vVE/zq9xyGO3N0x5n02UYKrMbsIz19n+2hja3CP1dxXFh3sfc4hm/yxN/8Gfahyzzmg2sj/C977gIChrV9MlvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722663232; c=relaxed/simple;
	bh=LE6sFFm9OjG6qTB8i8nfY69b9SLM7KukejVRZzoJLWI=;
	h=Date:To:From:Subject:Message-Id; b=EtiLfyalLwYDwCQrvVYbD1bgOoJjy/vW1J7VubO9+Mf72Y31A7VsR4BR4Mu+PyeAQ+bX3n0P1evmffc5rBxsFDJlbjzq+cD/w7bYTkCArvGjeQHKt+RGvYyZ+IUEbNf2StBejHVHf+dJZ8B6Q2J6Ikth2OCbhkW7shieT1OLU5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g1GvwGNw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g1GvwGNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835ADC116B1;
	Sat,  3 Aug 2024 05:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722663232;
	bh=LE6sFFm9OjG6qTB8i8nfY69b9SLM7KukejVRZzoJLWI=;
	h=Date:To:From:Subject:From;
	b=g1GvwGNw2fKbm9+1Ey3u223enKGzkOkKuaEVXgZSWtEdTcD4zmy64Xjp8E/F9k6LR
	 0toSqYQ7umulIeaTaTe707bbpHGQtNHqYeKtBnu/A2BTsSYJnIVVnzBNoQqQt/vij7
	 qwFwU47jOAk3VBUhHtg8Rf78pnToIOwHLOFDksI4=
Date: Fri, 02 Aug 2024 22:33:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,svens@linux.ibm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch added to mm-unstable branch
Message-Id: <20240803053352.835ADC116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk
has been added to the -mm mm-unstable branch.  Its filename is
     mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk
Date: Fri, 2 Aug 2024 17:55:24 +0200

Let's simplify by reusing folio_walk.  Keep the existing behavior by
handling migration entries and zeropages.

Link: https://lkml.kernel.org/r/20240802155524.517137-12-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   63 +++++++++++++----------------------------------------
 1 file changed, 16 insertions(+), 47 deletions(-)

--- a/mm/ksm.c~mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk
+++ a/mm/ksm.c
@@ -608,47 +608,6 @@ static inline bool ksm_test_exit(struct
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
-			struct mm_walk *walk)
-{
-	struct page *page = NULL;
-	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int ret;
-
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte)
-		return 0;
-	ptent = ptep_get(pte);
-	if (pte_present(ptent)) {
-		page = vm_normal_page(walk->vma, addr, ptent);
-	} else if (!pte_none(ptent)) {
-		swp_entry_t entry = pte_to_swp_entry(ptent);
-
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			page = pfn_swap_entry_to_page(entry);
-	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	ret = (page && PageKsm(page)) || is_ksm_zero_pte(ptent);
-	pte_unmap_unlock(pte, ptl);
-	return ret;
-}
-
-static const struct mm_walk_ops break_ksm_ops = {
-	.pmd_entry = break_ksm_pmd_entry,
-	.walk_lock = PGWALK_RDLOCK,
-};
-
-static const struct mm_walk_ops break_ksm_lock_vma_ops = {
-	.pmd_entry = break_ksm_pmd_entry,
-	.walk_lock = PGWALK_WRLOCK,
-};
-
 /*
  * We use break_ksm to break COW on a ksm page by triggering unsharing,
  * such that the ksm page will get replaced by an exclusive anonymous page.
@@ -665,16 +624,26 @@ static const struct mm_walk_ops break_ks
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
 {
 	vm_fault_t ret = 0;
-	const struct mm_walk_ops *ops = lock_vma ?
-				&break_ksm_lock_vma_ops : &break_ksm_ops;
+
+	if (lock_vma)
+		vma_start_write(vma);
 
 	do {
-		int ksm_page;
+		bool ksm_page = false;
+		struct folio_walk fw;
+		struct folio *folio;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
-		if (WARN_ON_ONCE(ksm_page < 0))
-			return ksm_page;
+		folio = folio_walk_start(&fw, vma, addr,
+					 FW_MIGRATION | FW_ZEROPAGE);
+		if (folio) {
+			/* Small folio implies FW_LEVEL_PTE. */
+			if (!folio_test_large(folio) &&
+			    (folio_test_ksm(folio) || is_ksm_zero_pte(fw.pte)))
+				ksm_page = true;
+			folio_walk_end(&fw, vma);
+		}
+
 		if (!ksm_page)
 			return 0;
 		ret = handle_mm_fault(vma, addr,
_

Patches currently in -mm which might be from david@redhat.com are

mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch
mm-hugetlb-remove-hugetlb_follow_page_mask-leftover.patch
mm-rmap-cleanup-partially-mapped-handling-in-__folio_remove_rmap.patch
mm-clarify-folio_likely_mapped_shared-documentation-for-ksm-folios.patch
mm-provide-vm_normal_pagefolio_pmd-with-config_pgtable_has_huge_leaves.patch
mm-pagewalk-introduce-folio_walk_start-folio_walk_end.patch
mm-migrate-convert-do_pages_stat_array-from-follow_page-to-folio_walk.patch
mm-migrate-convert-add_page_for_migration-from-follow_page-to-folio_walk.patch
mm-ksm-convert-get_mergeable_page-from-follow_page-to-folio_walk.patch
mm-ksm-convert-scan_get_next_rmap_item-from-follow_page-to-folio_walk.patch
mm-huge_memory-convert-split_huge_pages_pid-from-follow_page-to-folio_walk.patch
s390-uv-convert-gmap_destroy_page-from-follow_page-to-folio_walk.patch
s390-mm-fault-convert-do_secure_storage_access-from-follow_page-to-folio_walk.patch
mm-remove-follow_page.patch
mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

