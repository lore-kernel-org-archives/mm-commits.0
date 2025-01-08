Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A165F1A2872
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317627; cv=none; b=hnFzxRSfw5rUmq71Ai59PemDmNVl70BdOeI8HOazbQxUSxbZvBjv7bPLS2G9bDoMfmR0PO2sQo3DT4YE63otFrUAuoeSSU6Skky54XH9dlayTozSUfMJPHveIJtLatW4LNan7enMgeSTx+FpwziGgdeV7N6Cfru57WovciMwIJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317627; c=relaxed/simple;
	bh=Pt7/FFl+cTCn1LtPwbo7zBaGeSSxxwyaHNtkuGW52lg=;
	h=Date:To:From:Subject:Message-Id; b=CsB6eTuYzYsftJ4CAyRqoY0Rtxt3hT2lErwDp5Af4ETG/e+zzFn3WLCr849P9QkaBQ20FvNzs563GzHu2QRqYXRrMYMoxLfqquxCYPNIhOqzgIHUZ5KVN7/QdvSdLdv1gtypbfo3CRSZe9A6RYjO6xvrNuwLs3NEV4pto9EKEXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qdQsQpUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qdQsQpUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39689C4CED0;
	Wed,  8 Jan 2025 06:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317627;
	bh=Pt7/FFl+cTCn1LtPwbo7zBaGeSSxxwyaHNtkuGW52lg=;
	h=Date:To:From:Subject:From;
	b=qdQsQpUCg4ib80gs8OimCGlXxBpzpXUS44sJr7Bb0MgU58+iXFpEjJEgWtyvNMmT2
	 lw4BojecZVhuadhdf2e9eSXmeJ62qGa0uzO5MWnemXahwYQIw0ruXdB65t9mRcwolp
	 IUPLxE6HJy1SJ6DM5t1zWdfSrYwv8zAtAB5lluTQ=
Date: Tue, 07 Jan 2025 22:27:06 -0800
To: mm-commits@vger.kernel.org,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + huge_memory-add-vmf_insert_folio_pmd.patch added to mm-unstable branch
Message-Id: <20250108062707.39689C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: huge_memory: add vmf_insert_folio_pmd()
has been added to the -mm mm-unstable branch.  Its filename is
     huge_memory-add-vmf_insert_folio_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/huge_memory-add-vmf_insert_folio_pmd.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: huge_memory: add vmf_insert_folio_pmd()
Date: Tue, 7 Jan 2025 14:42:32 +1100

Currently DAX folio/page reference counts are managed differently to
normal pages.  To allow these to be managed the same as normal pages
introduce vmf_insert_folio_pmd.  This will map the entire PMD-sized folio
and take references as it would for a normally mapped page.

This is distinct from the current mechanism, vmf_insert_pfn_pmd, which
simply inserts a special devmap PMD entry into the page table without
holding a reference to the page for the mapping.

Link: https://lkml.kernel.org/r/c18097d2e12146928ddf5cdc4eb8875063d00251.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    1 
 mm/huge_memory.c        |   54 ++++++++++++++++++++++++++++++--------
 2 files changed, 45 insertions(+), 10 deletions(-)

--- a/include/linux/huge_mm.h~huge_memory-add-vmf_insert_folio_pmd
+++ a/include/linux/huge_mm.h
@@ -39,6 +39,7 @@ int change_huge_pmd(struct mmu_gather *t
 
 vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, pfn_t pfn, bool write);
 vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, pfn_t pfn, bool write);
+vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio, bool write);
 vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio, bool write);
 
 enum transparent_hugepage_flag {
--- a/mm/huge_memory.c~huge_memory-add-vmf_insert_folio_pmd
+++ a/mm/huge_memory.c
@@ -1381,14 +1381,12 @@ static void insert_pfn_pmd(struct vm_are
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pmd_t entry;
-	spinlock_t *ptl;
 
-	ptl = pmd_lock(mm, pmd);
 	if (!pmd_none(*pmd)) {
 		if (write) {
 			if (pmd_pfn(*pmd) != pfn_t_to_pfn(pfn)) {
 				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
-				goto out_unlock;
+				return;
 			}
 			entry = pmd_mkyoung(*pmd);
 			entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
@@ -1396,7 +1394,7 @@ static void insert_pfn_pmd(struct vm_are
 				update_mmu_cache_pmd(vma, addr, pmd);
 		}
 
-		goto out_unlock;
+		return;
 	}
 
 	entry = pmd_mkhuge(pfn_t_pmd(pfn, prot));
@@ -1417,11 +1415,6 @@ static void insert_pfn_pmd(struct vm_are
 
 	set_pmd_at(mm, addr, pmd, entry);
 	update_mmu_cache_pmd(vma, addr, pmd);
-
-out_unlock:
-	spin_unlock(ptl);
-	if (pgtable)
-		pte_free(mm, pgtable);
 }
 
 /**
@@ -1440,6 +1433,7 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 	struct vm_area_struct *vma = vmf->vma;
 	pgprot_t pgprot = vma->vm_page_prot;
 	pgtable_t pgtable = NULL;
+	spinlock_t *ptl;
 
 	/*
 	 * If we had pmd_special, we could avoid all these restrictions,
@@ -1462,12 +1456,52 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_
 	}
 
 	track_pfn_insert(vma, &pgprot, pfn);
-
+	ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 	insert_pfn_pmd(vma, addr, vmf->pmd, pfn, pgprot, write, pgtable);
+	spin_unlock(ptl);
+	if (pgtable)
+		pte_free(vma->vm_mm, pgtable);
+
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(vmf_insert_pfn_pmd);
 
+vm_fault_t vmf_insert_folio_pmd(struct vm_fault *vmf, struct folio *folio, bool write)
+{
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address & PMD_MASK;
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *ptl;
+	pgtable_t pgtable = NULL;
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return VM_FAULT_SIGBUS;
+
+	if (WARN_ON_ONCE(folio_order(folio) != PMD_ORDER))
+		return VM_FAULT_SIGBUS;
+
+	if (arch_needs_pgtable_deposit()) {
+		pgtable = pte_alloc_one(vma->vm_mm);
+		if (!pgtable)
+			return VM_FAULT_OOM;
+	}
+
+	ptl = pmd_lock(mm, vmf->pmd);
+	if (pmd_none(*vmf->pmd)) {
+		folio_get(folio);
+		folio_add_file_rmap_pmd(folio, &folio->page, vma);
+		add_mm_counter(mm, mm_counter_file(folio), HPAGE_PMD_NR);
+	}
+	insert_pfn_pmd(vma, addr, vmf->pmd, pfn_to_pfn_t(folio_pfn(folio)),
+		       vma->vm_page_prot, write, pgtable);
+	spin_unlock(ptl);
+	if (pgtable)
+		pte_free(mm, pgtable);
+
+	return VM_FAULT_NOPAGE;
+}
+EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
+
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 {
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

