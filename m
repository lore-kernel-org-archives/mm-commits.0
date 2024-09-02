Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4B57603F
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725247754; cv=none; b=ZaajILZaWrhHKzI1ydmedfnTp1fVK9PkuvyIEcJw2kbGwfitR70r9Qm6l/r2tjMiZSwi+ehVxFmuBxx1STxMeutmGOnYzeRigxuJVwUR8NNJpCADNOTiNsn8LMyvfESnnZqSods1JZGvAmXsZ2IjbvXSXRP/zYMHUypePfmOVCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725247754; c=relaxed/simple;
	bh=hbj6bftqzFHIZCcxLQXYZi2cz8aIDDH/AhRaXmBo2JM=;
	h=Date:To:From:Subject:Message-Id; b=Ue6H9MC4i5C+7qSTSzLnKUZFTQnJRFbn/3rRxaNZLRRSD5RRFB+7VnoVduC8JKV9V4q7hLH0GHQ/HdcstG9a9ZbPG8Q4/AFxhb84pRpcTXAvfHHMGleip6NUVztfeN1AiKi0kffDggg21cHtD5lKO7uYXsL8qoQIku8BdC/ksDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bplRnnef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bplRnnef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2D8C4CEC2;
	Mon,  2 Sep 2024 03:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725247754;
	bh=hbj6bftqzFHIZCcxLQXYZi2cz8aIDDH/AhRaXmBo2JM=;
	h=Date:To:From:Subject:From;
	b=bplRnnefuy4lCRTNQtQFC/AJdhfiKmeJryWcx0rXF/xRne73sfnupI1ght/OkmyT6
	 WSsGiLa3++MqW5/4uob+r4UokWo42AMYZgH/QBaG7QGrigSM+wWglzMl+gPtxGFiLo
	 dmiuWXVE/GoN4WVEgbqSxYtZBDOQMch+4yvyF11w=
Date: Sun, 01 Sep 2024 20:29:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,svens@linux.ibm.com,ryan.roberts@arm.com,imbrenda@linux.ibm.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,corbet@lwn.net,borntraeger@linux.ibm.com,agordeev@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch removed from -mm tree
Message-Id: <20240902032914.9C2D8C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/ksm: convert break_ksm() from walk_page_range_vma() to folio_walk
has been removed from the -mm tree.  Its filename was
     mm-ksm-convert-break_ksm-from-walk_page_range_vma-to-folio_walk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
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

mm-rmap-use-folio-_mapcount-for-small-folios.patch
mm-always-inline-_compound_head-with-config_hugetlb_page_optimize_vmemmap=y.patch
selftests-mm-fix-charge_reserved_hugetlbsh-test.patch

