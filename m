Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70CE2045B1
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 23:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750374151; cv=none; b=YXUMiKQWpN0ngwSXvuNERzG3uioiizpA/ADhBqT2B/JgM2zIbzla1YodI9ME+VGmL3xz0q6l5wdR+mAeV5d15eUd7wCkJxSSt+gmo8u/HrPG3PWRjFAWxgTMEc4vk1pQ5e575Wqpl4wT6adClYneXbJ9XWvsJdSXNyRVV4DPgDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750374151; c=relaxed/simple;
	bh=7pXr9S1yezr8SEbl+O84C+uefK/68l+o+geejnk6iq0=;
	h=Date:To:From:Subject:Message-Id; b=V/+M+JZwI593L2rO7yZer2rzX6TJcDtgmDNUbC24TVRVVr/kbs6Y2sU+NYXdL7JV+PG0W0EcCfzktMr7Fith+VDek9qQ2mi/ZoMAx0C17YXcjIyArhRYlTOAngr1A5WSuVurUBYaLwgycxFxTf4MPBcmSjUQiTB6ZdTVs1HBueE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fBpfxfQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fBpfxfQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7CCC4CEEA;
	Thu, 19 Jun 2025 23:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750374151;
	bh=7pXr9S1yezr8SEbl+O84C+uefK/68l+o+geejnk6iq0=;
	h=Date:To:From:Subject:From;
	b=fBpfxfQZJvs4sKIkPJfTe6k4cqWg4DlJgd2pXWnSpVwcwL0F/ESU0TBNFddJoLwbG
	 VVKZFHajPXJD6d/u0FQPFd0WhnqM9IrCXe8UDfWYOjGOOH8E5WcGcLvX9tYN3oXcD/
	 1ReTwxJu0qSYWW7SGgqHDLMBsFHgkKWkV28LrdTM=
Date: Thu, 19 Jun 2025 16:02:30 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + powerpc-remove-checks-for-devmap-pages-and-pmds-puds.patch added to mm-new branch
Message-Id: <20250619230231.3F7CCC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: powerpc: remove checks for devmap pages and PMDs/PUDs
has been added to the -mm mm-new branch.  Its filename is
     powerpc-remove-checks-for-devmap-pages-and-pmds-puds.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/powerpc-remove-checks-for-devmap-pages-and-pmds-puds.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: powerpc: remove checks for devmap pages and PMDs/PUDs
Date: Thu, 19 Jun 2025 18:58:01 +1000

PFN_DEV no longer exists.  This means no devmap PMDs or PUDs will be
created, so checking for them is redundant.  Instead mappings of pages
that would have previously returned true for pXd_devmap() will return true
for pXd_trans_huge()

Link: https://lkml.kernel.org/r/31f63cc8dd518f9e2ec300681fe302eb4adf49b4.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/hash_hugepage.c |    2 +-
 arch/powerpc/mm/book3s64/hash_pgtable.c  |    3 +--
 arch/powerpc/mm/book3s64/hugetlbpage.c   |    2 +-
 arch/powerpc/mm/book3s64/pgtable.c       |   10 ++++------
 arch/powerpc/mm/book3s64/radix_pgtable.c |    5 ++---
 arch/powerpc/mm/pgtable.c                |    2 +-
 6 files changed, 10 insertions(+), 14 deletions(-)

--- a/arch/powerpc/mm/book3s64/hash_hugepage.c~powerpc-remove-checks-for-devmap-pages-and-pmds-puds
+++ a/arch/powerpc/mm/book3s64/hash_hugepage.c
@@ -54,7 +54,7 @@ int __hash_page_thp(unsigned long ea, un
 	/*
 	 * Make sure this is thp or devmap entry
 	 */
-	if (!(old_pmd & (H_PAGE_THP_HUGE | _PAGE_DEVMAP)))
+	if (!(old_pmd & H_PAGE_THP_HUGE))
 		return 0;
 
 	rflags = htab_convert_pte_flags(new_pmd, flags);
--- a/arch/powerpc/mm/book3s64/hash_pgtable.c~powerpc-remove-checks-for-devmap-pages-and-pmds-puds
+++ a/arch/powerpc/mm/book3s64/hash_pgtable.c
@@ -195,7 +195,7 @@ unsigned long hash__pmd_hugepage_update(
 	unsigned long old;
 
 #ifdef CONFIG_DEBUG_VM
-	WARN_ON(!hash__pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
+	WARN_ON(!hash__pmd_trans_huge(*pmdp));
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 #endif
 
@@ -227,7 +227,6 @@ pmd_t hash__pmdp_collapse_flush(struct v
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	VM_BUG_ON(pmd_trans_huge(*pmdp));
-	VM_BUG_ON(pmd_devmap(*pmdp));
 
 	pmd = *pmdp;
 	pmd_clear(pmdp);
--- a/arch/powerpc/mm/book3s64/hugetlbpage.c~powerpc-remove-checks-for-devmap-pages-and-pmds-puds
+++ a/arch/powerpc/mm/book3s64/hugetlbpage.c
@@ -74,7 +74,7 @@ int __hash_page_huge(unsigned long ea, u
 	} while(!pte_xchg(ptep, __pte(old_pte), __pte(new_pte)));
 
 	/* Make sure this is a hugetlb entry */
-	if (old_pte & (H_PAGE_THP_HUGE | _PAGE_DEVMAP))
+	if (old_pte & H_PAGE_THP_HUGE)
 		return 0;
 
 	rflags = htab_convert_pte_flags(new_pte, flags);
--- a/arch/powerpc/mm/book3s64/pgtable.c~powerpc-remove-checks-for-devmap-pages-and-pmds-puds
+++ a/arch/powerpc/mm/book3s64/pgtable.c
@@ -62,7 +62,7 @@ int pmdp_set_access_flags(struct vm_area
 {
 	int changed;
 #ifdef CONFIG_DEBUG_VM
-	WARN_ON(!pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
+	WARN_ON(!pmd_trans_huge(*pmdp));
 	assert_spin_locked(pmd_lockptr(vma->vm_mm, pmdp));
 #endif
 	changed = !pmd_same(*(pmdp), entry);
@@ -82,7 +82,6 @@ int pudp_set_access_flags(struct vm_area
 {
 	int changed;
 #ifdef CONFIG_DEBUG_VM
-	WARN_ON(!pud_devmap(*pudp));
 	assert_spin_locked(pud_lockptr(vma->vm_mm, pudp));
 #endif
 	changed = !pud_same(*(pudp), entry);
@@ -204,8 +203,8 @@ pmd_t pmdp_huge_get_and_clear_full(struc
 {
 	pmd_t pmd;
 	VM_BUG_ON(addr & ~HPAGE_PMD_MASK);
-	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
-		   !pmd_devmap(*pmdp)) || !pmd_present(*pmdp));
+	VM_BUG_ON((pmd_present(*pmdp) && !pmd_trans_huge(*pmdp)) ||
+		   !pmd_present(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, addr, pmdp);
 	/*
 	 * if it not a fullmm flush, then we can possibly end up converting
@@ -223,8 +222,7 @@ pud_t pudp_huge_get_and_clear_full(struc
 	pud_t pud;
 
 	VM_BUG_ON(addr & ~HPAGE_PMD_MASK);
-	VM_BUG_ON((pud_present(*pudp) && !pud_devmap(*pudp)) ||
-		  !pud_present(*pudp));
+	VM_BUG_ON(!pud_present(*pudp));
 	pud = pudp_huge_get_and_clear(vma->vm_mm, addr, pudp);
 	/*
 	 * if it not a fullmm flush, then we can possibly end up converting
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c~powerpc-remove-checks-for-devmap-pages-and-pmds-puds
+++ a/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1426,7 +1426,7 @@ unsigned long radix__pmd_hugepage_update
 	unsigned long old;
 
 #ifdef CONFIG_DEBUG_VM
-	WARN_ON(!radix__pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
+	WARN_ON(!radix__pmd_trans_huge(*pmdp));
 	assert_spin_locked(pmd_lockptr(mm, pmdp));
 #endif
 
@@ -1443,7 +1443,7 @@ unsigned long radix__pud_hugepage_update
 	unsigned long old;
 
 #ifdef CONFIG_DEBUG_VM
-	WARN_ON(!pud_devmap(*pudp));
+	WARN_ON(!pud_trans_huge(*pudp));
 	assert_spin_locked(pud_lockptr(mm, pudp));
 #endif
 
@@ -1461,7 +1461,6 @@ pmd_t radix__pmdp_collapse_flush(struct
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 	VM_BUG_ON(radix__pmd_trans_huge(*pmdp));
-	VM_BUG_ON(pmd_devmap(*pmdp));
 	/*
 	 * khugepaged calls this for normal pmd
 	 */
--- a/arch/powerpc/mm/pgtable.c~powerpc-remove-checks-for-devmap-pages-and-pmds-puds
+++ a/arch/powerpc/mm/pgtable.c
@@ -509,7 +509,7 @@ pte_t *__find_linux_pte(pgd_t *pgdir, un
 		return NULL;
 #endif
 
-	if (pmd_trans_huge(pmd) || pmd_devmap(pmd)) {
+	if (pmd_trans_huge(pmd)) {
 		if (is_thp)
 			*is_thp = true;
 		ret_pte = (pte_t *)pmdp;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-convert-pxd_devmap-checks-to-vma_is_dax.patch
mm-filter-zone-device-pages-returned-from-folio_walk_start.patch
mm-remove-remaining-uses-of-pfn_dev.patch
mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special.patch
mm-gup-remove-pxx_devmap-usage-from-get_user_pages.patch
mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch
mm-remove-redundant-pxd_devmap-calls.patch
mm-khugepaged-remove-redundant-pmd_devmap-check.patch
powerpc-remove-checks-for-devmap-pages-and-pmds-puds.patch
fs-dax-remove-fs_dax_limited-config-option.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
mm-remove-pfn_dev-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch
mm-remove-callers-of-pfn_t-functionality.patch
mm-memremap-remove-unused-devmap_managed_key.patch

