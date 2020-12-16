Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9CCC2BBCF
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D241A2342C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgLPRMY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:12:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbgLPRMY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:12:24 -0500
Date:   Wed, 16 Dec 2020 09:12:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138728;
        bh=oQkAZjBPceXUafkIY/V7dpdOu7TzhWIvjyVSZsRjt4g=;
        h=From:To:Subject:From;
        b=kcNBiplj0H8IL/kpx4fY4jdZ3sUL9WfCYg/qo1i1UDvGBfU55D35WJeH5Z8YEdSK+
         YZOfZTjUJ+NG89XwojW2FzExBK3A2W74TLEEylojpQXgFWIuQGQLWaukuQ8aCzFQ3o
         nrgNst38v/hPGCTJHUamIIKo1p5+T6th6VzJkgYM=
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, daniel@ffwll.ch, hch@lst.de,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        willy@infradead.org
Subject:  [merged] mm-simplify-follow_ptepmd.patch removed from -mm
 tree
Message-ID: <20201216171208.N8wAADS9p%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify follow_pte{,pmd}
has been removed from the -mm tree.  Its filename was
     mm-simplify-follow_ptepmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: simplify follow_pte{,pmd}

Merge __follow_pte_pmd, follow_pte_pmd and follow_pte into a single
follow_pte function and just pass two additional NULL arguments for the
two previous follow_pte callers.

[sfr@canb.auug.org.au: merge fix for "s390/pci: remove races against pte updates"]
  Link: https://lkml.kernel.org/r/20201111221254.7f6a3658@canb.auug.org.au
Link: https://lkml.kernel.org/r/20201029101432.47011-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/pci/pci_mmio.c |    4 ++--
 fs/dax.c                 |    9 ++++-----
 include/linux/mm.h       |    6 +++---
 mm/memory.c              |   35 +++++------------------------------
 4 files changed, 14 insertions(+), 40 deletions(-)

--- a/arch/s390/pci/pci_mmio.c~mm-simplify-follow_ptepmd
+++ a/arch/s390/pci/pci_mmio.c
@@ -170,7 +170,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, uns
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
@@ -311,7 +311,7 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsi
 	if (!(vma->vm_flags & VM_WRITE))
 		goto out_unlock_mmap;
 
-	ret = follow_pte_pmd(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
+	ret = follow_pte(vma->vm_mm, mmio_addr, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		goto out_unlock_mmap;
 
--- a/fs/dax.c~mm-simplify-follow_ptepmd
+++ a/fs/dax.c
@@ -810,12 +810,11 @@ static void dax_entry_mkclean(struct add
 		address = pgoff_address(index, vma);
 
 		/*
-		 * Note because we provide range to follow_pte_pmd it will
-		 * call mmu_notifier_invalidate_range_start() on our behalf
-		 * before taking any lock.
+		 * Note because we provide range to follow_pte it will call
+		 * mmu_notifier_invalidate_range_start() on our behalf before
+		 * taking any lock.
 		 */
-		if (follow_pte_pmd(vma->vm_mm, address, &range,
-				   &ptep, &pmdp, &ptl))
+		if (follow_pte(vma->vm_mm, address, &range, &ptep, &pmdp, &ptl))
 			continue;
 
 		/*
--- a/include/linux/mm.h~mm-simplify-follow_ptepmd
+++ a/include/linux/mm.h
@@ -1641,9 +1641,9 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-		   struct mmu_notifier_range *range,
-		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
+int follow_pte(struct mm_struct *mm, unsigned long address,
+		struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
+		spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
 	unsigned long *pfn);
 int follow_phys(struct vm_area_struct *vma, unsigned long address,
--- a/mm/memory.c~mm-simplify-follow_ptepmd
+++ a/mm/memory.c
@@ -4707,9 +4707,9 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-			    struct mmu_notifier_range *range,
-			    pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
+int follow_pte(struct mm_struct *mm, unsigned long address,
+	       struct mmu_notifier_range *range, pte_t **ptepp, pmd_t **pmdpp,
+	       spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -4774,31 +4774,6 @@ out:
 	return -EINVAL;
 }
 
-static inline int follow_pte(struct mm_struct *mm, unsigned long address,
-			     pte_t **ptepp, spinlock_t **ptlp)
-{
-	int res;
-
-	/* (void) is needed to make gcc happy */
-	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte_pmd(mm, address, NULL,
-						    ptepp, NULL, ptlp)));
-	return res;
-}
-
-int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-		   struct mmu_notifier_range *range,
-		   pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
-{
-	int res;
-
-	/* (void) is needed to make gcc happy */
-	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte_pmd(mm, address, range,
-						    ptepp, pmdpp, ptlp)));
-	return res;
-}
-
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
@@ -4819,7 +4794,7 @@ int follow_pfn(struct vm_area_struct *vm
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		return ret;
 
-	ret = follow_pte(vma->vm_mm, address, &ptep, &ptl);
+	ret = follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl);
 	if (ret)
 		return ret;
 	*pfn = pte_pfn(*ptep);
@@ -4840,7 +4815,7 @@ int follow_phys(struct vm_area_struct *v
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
 		goto out;
 
-	if (follow_pte(vma->vm_mm, address, &ptep, &ptl))
+	if (follow_pte(vma->vm_mm, address, NULL, &ptep, NULL, &ptl))
 		goto out;
 	pte = *ptep;
 
_

Patches currently in -mm which might be from hch@lst.de are


