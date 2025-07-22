Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E03A95C
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 20:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753217327; cv=none; b=jAMSkSStLxUYUHGf7MgdmGgQJKavlilS0A5bAH1WSaWPxJZ/42oQ7loqjdekleHqiD84ptnzLy1EN2OMVlt4kpS/bnMSooS7cFNG74t3HeOH+50kYxtOBuq83HWlltT42i0Az5VkOsJlmpN8mgO7gemh/RwD7S9O8SxqxBsuauo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753217327; c=relaxed/simple;
	bh=NIJgvyEiWeGAnfJrCAV2/hXX5PlbDG5uMzd1t8cKPc0=;
	h=Date:To:From:Subject:Message-Id; b=G1FA9wc1jpIyy/5HsWowLoP2T0HLvQ2sAc6Wny1YTxRYEpx6wnGpj30+LpakdmSwBi32XCtfxK8d8J5JVNJoiiZrvQn4HY5OIDiEPW2J8hJ4p2dVPE5s+LEnrALMArC1lpg8IT8GXYxgmPJXwVif0iqm2dBbkruD8hgVJOKNSew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=T02fdsI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="T02fdsI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F60DC4CEEB;
	Tue, 22 Jul 2025 20:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753217326;
	bh=NIJgvyEiWeGAnfJrCAV2/hXX5PlbDG5uMzd1t8cKPc0=;
	h=Date:To:From:Subject:From;
	b=T02fdsI/q/PTeaf9fJW/kq/9Q5Ul2QCxxWIVMwGHL0HvGGFj8OQdC0fk7dc+d8zG/
	 rU9NtC3+4XSMNPfcXIear68T/QJOmGVmJekerLSmdF0j2bUX5ppv9LZXZiDT5+ULpw
	 0CaQkLL7M+9AXom+lpalX9Clg1n+wP4eKghBNTxg=
Date: Tue, 22 Jul 2025 13:48:45 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch added to mm-new branch
Message-Id: <20250722204846.5F60DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: optimize collapse_pte_mapped_thp() by PTE batching
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Dev Jain <dev.jain@arm.com>
Subject: khugepaged: optimize collapse_pte_mapped_thp() by PTE batching
Date: Tue, 22 Jul 2025 20:35:59 +0530

Use PTE batching to optimize collapse_pte_mapped_thp().

On arm64, suppose khugepaged is scanning a pte-mapped 2MB THP for
collapse.  Then, calling ptep_clear() for every pte will cause a TLB flush
for every contpte block.  Instead, clear_ptes() does a
contpte_try_unfold_partial() which will flush the TLB only for the (if
any) starting and ending contpte block, if they partially overlap with the
range khugepaged is looking at.

For all arches, there should be a benefit due to batching atomic
operations on mapcounts due to folio_remove_rmap_ptes() and saving some
calls.

Note that we do not need to make a change to the check "if
(folio_page(folio, i) != page)"; if i'th page of the folio is equal to the
first page of our batch, then i + 1, ....  i + nr_batch_ptes - 1 pages of
the folio will be equal to the corresponding pages of our batch mapping
consecutive pages.

Link: https://lkml.kernel.org/r/20250722150559.96465-4-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/mm/khugepaged.c~khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching
+++ a/mm/khugepaged.c
@@ -1503,15 +1503,16 @@ static int set_huge_pmd(struct vm_area_s
 int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 			    bool install_pmd)
 {
+	int nr_mapped_ptes = 0, nr_batch_ptes, result = SCAN_FAIL;
 	struct mmu_notifier_range range;
 	bool notified = false;
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	unsigned long end = haddr + HPAGE_PMD_SIZE;
 	struct vm_area_struct *vma = vma_lookup(mm, haddr);
 	struct folio *folio;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
 	spinlock_t *pml = NULL, *ptl;
-	int nr_ptes = 0, result = SCAN_FAIL;
 	int i;
 
 	mmap_assert_locked(mm);
@@ -1625,11 +1626,15 @@ int collapse_pte_mapped_thp(struct mm_st
 		goto abort;
 
 	/* step 2: clear page table and adjust rmap */
-	for (i = 0, addr = haddr, pte = start_pte;
-	     i < HPAGE_PMD_NR; i++, addr += PAGE_SIZE, pte++) {
+	for (i = 0, addr = haddr, pte = start_pte; i < HPAGE_PMD_NR;
+	     i += nr_batch_ptes, addr += nr_batch_ptes * PAGE_SIZE,
+	     pte += nr_batch_ptes) {
+		int max_nr_batch_ptes = (end - addr) >> PAGE_SHIFT;
 		struct page *page;
 		pte_t ptent = ptep_get(pte);
 
+		nr_batch_ptes = 1;
+
 		if (pte_none(ptent))
 			continue;
 		/*
@@ -1643,26 +1648,29 @@ int collapse_pte_mapped_thp(struct mm_st
 			goto abort;
 		}
 		page = vm_normal_page(vma, addr, ptent);
+
 		if (folio_page(folio, i) != page)
 			goto abort;
 
+		nr_batch_ptes = folio_pte_batch(folio, pte, ptent, max_nr_batch_ptes);
+
 		/*
 		 * Must clear entry, or a racing truncate may re-remove it.
 		 * TLB flush can be left until pmdp_collapse_flush() does it.
 		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
-		ptep_clear(mm, addr, pte);
-		folio_remove_rmap_pte(folio, page, vma);
-		nr_ptes++;
+		clear_ptes(mm, addr, pte, nr_batch_ptes);
+		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
+		nr_mapped_ptes += nr_batch_ptes;
 	}
 
 	if (!pml)
 		spin_unlock(ptl);
 
 	/* step 3: set proper refcount and mm_counters. */
-	if (nr_ptes) {
-		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
+	if (nr_mapped_ptes) {
+		folio_ref_sub(folio, nr_mapped_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}
 
 	/* step 4: remove empty page table */
@@ -1695,10 +1703,10 @@ maybe_install_pmd:
 			: SCAN_SUCCEED;
 	goto drop_folio;
 abort:
-	if (nr_ptes) {
+	if (nr_mapped_ptes) {
 		flush_tlb_mm(mm);
-		folio_ref_sub(folio, nr_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_ptes);
+		folio_ref_sub(folio, nr_mapped_ptes);
+		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}
 unlock:
 	if (start_pte)
_

Patches currently in -mm which might be from dev.jain@arm.com are

mm-refactor-mm_cp_prot_numa-skipping-case-into-new-function.patch
mm-optimize-mprotect-for-mm_cp_prot_numa-by-batch-skipping-ptes.patch
mm-add-batched-versions-of-ptep_modify_prot_start-commit.patch
mm-introduce-fpb_respect_write-for-pte-batching-infrastructure.patch
mm-split-can_change_pte_writable-into-private-and-shared-parts.patch
mm-optimize-mprotect-by-pte-batching.patch
arm64-add-batched-versions-of-ptep_modify_prot_start-commit.patch
khugepaged-optimize-__collapse_huge_page_copy_succeeded-by-pte-batching.patch
khugepaged-optimize-collapse_pte_mapped_thp-by-pte-batching.patch

