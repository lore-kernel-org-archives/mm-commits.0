Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8765728371
	for <mm-commits@vger.kernel.org>; Tue, 17 Sep 2024 08:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726560509; cv=none; b=gHjVYa6cU4Is3S3bolWXYRDRARHNQgEe1PsqCTmq8AWOH1U++J0UetY+hOXBbAsIP5nWl3l4GiOufyvBBZWfTTQMR6gn3aoAUsYbwT+fKEn42TK4qKDV1qNiXf2YtBrlqT7FK2mZXct2luDvLARr7WO5sIrAOEGzEU5sA8tL+/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726560509; c=relaxed/simple;
	bh=kDFl3nzl5MtGUaz82fCtyDOAe9hfL1XeaZL/PQmaW9k=;
	h=Date:To:From:Subject:Message-Id; b=mCPE9jcN9APFciFUPOV3HVmArWg9dKm+QknKB0RyWwos/aRUfU0VDn9php+kntIjKLbe1m4jTo6zYCYOTL6ZPo3EgI21AJnjRNTA6BK5O4Xds/HqltvhQMvQWKDGm4fUPtgp47RGDNYVVLoqq8jX5gkc40BlxqnaVpWtCynbWTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PCl3MUKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PCl3MUKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEF7C4CEC7;
	Tue, 17 Sep 2024 08:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1726560509;
	bh=kDFl3nzl5MtGUaz82fCtyDOAe9hfL1XeaZL/PQmaW9k=;
	h=Date:To:From:Subject:From;
	b=PCl3MUKFU7wyh/cXL2QsIFR5SSnBrVWnnP8XtdMatjaTEGQwLLgiE8IHuWMEu+J0D
	 hDk3QNFol1L/+AfRrn9C0g0HBYbjx6SFPuVrnyaBpy9nOtSdxtC+7NHuAm0ryepAwt
	 nt2Dko5vAcIIAAkSOw/C3i1/Pgo/wo8f7v4mByhA=
Date: Tue, 17 Sep 2024 01:08:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,svens@linux.ibm.com,seanjc@google.com,schnelle@linux.ibm.com,ryan.roberts@arm.com,pbonzini@redhat.com,mingo@redhat.com,jgg@nvidia.com,hca@linux.ibm.com,gshan@redhat.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,borntraeger@linux.ibm.com,aneesh.kumar@linux.ibm.com,alex.williamson@redhat.com,agordeev@linux.ibm.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-follow_pte.patch removed from -mm tree
Message-Id: <20240917080828.EEEF7C4CEC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove follow_pte()
has been removed from the -mm tree.  Its filename was
     mm-remove-follow_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -6099,79 +6099,6 @@ int __pmd_alloc(struct mm_struct *mm, pu
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


