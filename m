Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF1077117
	for <mm-commits@vger.kernel.org>; Tue, 27 Aug 2024 23:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724802757; cv=none; b=tNsDPFq+eDgiEnCaOhtYdMSxR1x4YJgfnP7BVcN5NXAGAmp8Mn4lV3fZ0yH5wfVTfYprujvLMar5ZHwrteXy7DD0E8Asd4TtV3QaiuFi0FSq+TYcHE48v5pt9FQKs3ND/30pw0f0Ae5xK5/SZ3XZ14a84Q0C00a7n7UtOd3rolA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724802757; c=relaxed/simple;
	bh=RwJxDt8T0v6peTRNfQLOi6Ku3LP+muZ21P/KaSWFtD8=;
	h=Date:To:From:Subject:Message-Id; b=ElrBShvKvq0P3Q8df7OryW4HBV7Lg5XcNdHT75I4exQFAfGjuhznUM3qlGsnvH2WOMelreiXGcJQIK1SlFI3Ii5/J4PnLIGprRik/Ml99hA/hBkf+ORHxY3FRO+v7dTJd+wUUBp6xHdG+fayLyW0FMXCynsiv50QjTww2lq+OwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LScLCrxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LScLCrxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91066C32782;
	Tue, 27 Aug 2024 23:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724802757;
	bh=RwJxDt8T0v6peTRNfQLOi6Ku3LP+muZ21P/KaSWFtD8=;
	h=Date:To:From:Subject:From;
	b=LScLCrxMk+h6ZUrD8XzU4Ds3Eyl4wtQbQUe8CEI8vsb8lJXQfDbgEzrU0OfQnd4bc
	 SAw4V1JpMHZjP5W0PleUZcf4po5a4OqqoIkvB0rskZhhGyD1vslgEefsj2DmVUQ1uT
	 DzldYxJ1SbLbzsqPwV4TWCzksODV+VigFJGy/fbY=
Date: Tue, 27 Aug 2024 16:52:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-follow_pte.patch added to mm-unstable branch
Message-Id: <20240827235237.91066C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove follow_pte()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-remove-follow_pte.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-follow_pte.patch

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
From: Peter Xu <peterx@redhat.com>
Subject: mm: remove follow_pte()
Date: Mon, 26 Aug 2024 16:43:50 -0400

follow_pte() users have been converted to follow_pfnmap*().  Remove the
API.

Link: https://lkml.kernel.org/r/20240826204353.2228736-17-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 -
 mm/memory.c        |   73 -------------------------------------------
 2 files changed, 75 deletions(-)

--- a/include/linux/mm.h~mm-remove-follow_pte
+++ a/include/linux/mm.h
@@ -2368,8 +2368,6 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_pte(struct vm_area_struct *vma, unsigned long address,
-	       pte_t **ptepp, spinlock_t **ptlp);
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
--- a/mm/memory.c~mm-remove-follow_pte
+++ a/mm/memory.c
@@ -6296,79 +6296,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-/**
- * follow_pte - look up PTE at a user virtual address
- * @vma: the memory mapping
- * @address: user virtual address
- * @ptepp: location to store found PTE
- * @ptlp: location to store the lock for the PTE
- *
- * On a successful return, the pointer to the PTE is stored in @ptepp;
- * the corresponding lock is taken and its location is stored in @ptlp.
- *
- * The contents of the PTE are only stable until @ptlp is released using
- * pte_unmap_unlock(). This function will fail if the PTE is non-present.
- * Present PTEs may include PTEs that map refcounted pages, such as
- * anonymous folios in COW mappings.
- *
- * Callers must be careful when relying on PTE content after
- * pte_unmap_unlock(). Especially if the PTE maps a refcounted page,
- * callers must protect against invalidation with MMU notifiers; otherwise
- * access to the PFN at a later point in time can trigger use-after-free.
- *
- * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
- * should be taken for read.
- *
- * This function must not be used to modify PTE content.
- *
- * Return: zero on success, -ve otherwise.
- */
-int follow_pte(struct vm_area_struct *vma, unsigned long address,
-	       pte_t **ptepp, spinlock_t **ptlp)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *ptep;
-
-	mmap_assert_locked(mm);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		goto out;
-
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
-		goto out;
-
-	pgd = pgd_offset(mm, address);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		goto out;
-
-	p4d = p4d_offset(pgd, address);
-	if (p4d_none(*p4d) || unlikely(p4d_bad(*p4d)))
-		goto out;
-
-	pud = pud_offset(p4d, address);
-	if (pud_none(*pud) || unlikely(pud_bad(*pud)))
-		goto out;
-
-	pmd = pmd_offset(pud, address);
-	VM_BUG_ON(pmd_trans_huge(*pmd));
-
-	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
-	if (!ptep)
-		goto out;
-	if (!pte_present(ptep_get(ptep)))
-		goto unlock;
-	*ptepp = ptep;
-	return 0;
-unlock:
-	pte_unmap_unlock(ptep, *ptlp);
-out:
-	return -EINVAL;
-}
-EXPORT_SYMBOL_GPL(follow_pte);
-
 static inline void pfnmap_args_setup(struct follow_pfnmap_args *args,
 				     spinlock_t *lock, pte_t *ptep,
 				     pgprot_t pgprot, unsigned long pfn_base,
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-dax-dump-start-address-in-fault-handler.patch
mm-mprotect-push-mmu-notifier-to-puds.patch
mm-powerpc-add-missing-pud-helpers.patch
mm-x86-make-pud_leaf-only-care-about-pse-bit.patch
mm-x86-implement-arch_check_zapped_pud.patch
mm-x86-add-missing-pud-helpers.patch
mm-mprotect-fix-dax-pud-handlings.patch
mm-introduce-arch_supports_huge_pfnmap-and-special-bits-to-pmd-pud.patch
mm-drop-is_huge_zero_pud.patch
mm-mark-special-bits-for-huge-pfn-mappings-when-inject.patch
mm-allow-thp-orders-for-pfnmaps.patch
mm-gup-detect-huge-pfnmap-entries-in-gup-fast.patch
mm-pagewalk-check-pfnmap-for-folio_walk_start.patch
mm-fork-accept-huge-pfnmap-entries.patch
mm-always-define-pxx_pgprot.patch
mm-new-follow_pfnmap-api.patch
kvm-use-follow_pfnmap-api.patch
s390-pci_mmio-use-follow_pfnmap-api.patch
mm-x86-pat-use-the-new-follow_pfnmap-api.patch
vfio-use-the-new-follow_pfnmap-api.patch
acrn-use-the-new-follow_pfnmap-api.patch
mm-access_process_vm-use-the-new-follow_pfnmap-api.patch
mm-remove-follow_pte.patch
mm-x86-support-large-pfn-mappings.patch
mm-arm64-support-large-pfn-mappings.patch

