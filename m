Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B51EC2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B2FD2333E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:47:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgLPErk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:47:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgLPErj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:47:39 -0500
Date:   Tue, 15 Dec 2020 20:47:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608094044;
        bh=kd2LK3pQ04EK8Bzu4WUtKT4eBKRE3Sb9LDw1dfPxFHg=;
        h=From:To:Subject:In-Reply-To:From;
        b=hC3Ecvvwuh3XK3qpbMW6deAIbRavx9I9y7nKX50UKHT7etbmrAocUr+b8BWW+FHIi
         olLW/tj2xcMXZ9s1t+nkLp+IIcK83nHuD1KW/4AKudp2Ztik2xfxPaWiunhFKXzuEE
         a8VVeLM2tv7P7B135vpNiPX4JD4L8tErOWBF5mnI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        daniel@ffwll.ch, hch@lst.de, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 92/95] mm: simplify follow_pte{,pmd}
Message-ID: <20201216044723.QgY-Br2bw%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
