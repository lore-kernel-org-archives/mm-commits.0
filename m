Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEA21C3527E
	for <mm-commits@archiver.kernel.org>; Mon,  4 Apr 2022 21:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383105AbiDDVlZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380485AbiDDUQ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2022 16:16:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA53033EAD
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 13:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C1ACB819AC
        for <mm-commits@vger.kernel.org>; Mon,  4 Apr 2022 20:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9B5C2BBE4;
        Mon,  4 Apr 2022 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649103297;
        bh=KI1EsXt7W0B1S5KpN3HleVQbI4Cqf6csFWzh1aFkEHA=;
        h=Date:To:From:Subject:From;
        b=yjIdoRtdnM2EQ/8qYuZ2LclHXfD6BHrnjmDba2tlUfk+GGxPxGpRMzuf7X6B4OUV5
         NvV07h7d/ZX6Sj2VRvGc/UeiIKlGS2wfrizXdu4r4pjOCUjcpRzMW4ijA0DIY9uCyk
         647bFhyWJArPHhz5OBSJyDjd2wl1w3Nacxg9ddZI=
Date:   Mon, 04 Apr 2022 13:14:56 -0700
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        xiyuyang19@fudan.edu.cn, willy@infradead.org,
        viro@zeniv.linux.org.uk, shy828301@gmail.com, rcampbell@nvidia.com,
        kirill.shutemov@linux.intel.com, jack@suse.cz, hughd@google.com,
        hch@lst.de, duanxiongchun@bytedance.com, dan.j.williams@intel.com,
        apopple@nvidia.com, songmuchun@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-follow_invalidate_pte.patch added to -mm tree
Message-Id: <20220404201457.3D9B5C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify follow_invalidate_pte()
has been added to the -mm tree.  Its filename is
     mm-simplify-follow_invalidate_pte.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-follow_invalidate_pte.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-follow_invalidate_pte.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: simplify follow_invalidate_pte()

The only user (DAX) of range and pmdpp parameters of
follow_invalidate_pte() is gone, it is safe to remove them and make it
static to simlify the code.  This is revertant of the following commits:

  097963959594 ("mm: add follow_pte_pmd()")
  a4d1a8852513 ("dax: update to new mmu_notifier semantic")

There is only one caller of the follow_invalidate_pte().  So just fold it
into follow_pte() and remove it.

Link: https://lkml.kernel.org/r/20220403053957.10770-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 -
 mm/memory.c        |   81 ++++++++++++-------------------------------
 2 files changed, 23 insertions(+), 61 deletions(-)

--- a/include/linux/mm.h~mm-simplify-follow_invalidate_pte
+++ a/include/linux/mm.h
@@ -1846,9 +1846,6 @@ void free_pgd_range(struct mmu_gather *t
 		unsigned long end, unsigned long floor, unsigned long ceiling);
 int
 copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma);
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pte(struct mm_struct *mm, unsigned long address,
 	       pte_t **ptepp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
--- a/mm/memory.c~mm-simplify-follow_invalidate_pte
+++ a/mm/memory.c
@@ -5057,9 +5057,29 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int follow_invalidate_pte(struct mm_struct *mm, unsigned long address,
-			  struct mmu_notifier_range *range, pte_t **ptepp,
-			  pmd_t **pmdpp, spinlock_t **ptlp)
+/**
+ * follow_pte - look up PTE at a user virtual address
+ * @mm: the mm_struct of the target address space
+ * @address: user virtual address
+ * @ptepp: location to store found PTE
+ * @ptlp: location to store the lock for the PTE
+ *
+ * On a successful return, the pointer to the PTE is stored in @ptepp;
+ * the corresponding lock is taken and its location is stored in @ptlp.
+ * The contents of the PTE are only stable until @ptlp is released;
+ * any further use, if any, must be protected against invalidation
+ * with MMU notifiers.
+ *
+ * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
+ * should be taken for read.
+ *
+ * KVM uses this function.  While it is arguably less bad than ``follow_pfn``,
+ * it is not a good general-purpose API.
+ *
+ * Return: zero on success, -ve otherwise.
+ */
+int follow_pte(struct mm_struct *mm, unsigned long address,
+	       pte_t **ptepp, spinlock_t **ptlp)
 {
 	pgd_t *pgd;
 	p4d_t *p4d;
@@ -5082,35 +5102,9 @@ int follow_invalidate_pte(struct mm_stru
 	pmd = pmd_offset(pud, address);
 	VM_BUG_ON(pmd_trans_huge(*pmd));
 
-	if (pmd_huge(*pmd)) {
-		if (!pmdpp)
-			goto out;
-
-		if (range) {
-			mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0,
-						NULL, mm, address & PMD_MASK,
-						(address & PMD_MASK) + PMD_SIZE);
-			mmu_notifier_invalidate_range_start(range);
-		}
-		*ptlp = pmd_lock(mm, pmd);
-		if (pmd_huge(*pmd)) {
-			*pmdpp = pmd;
-			return 0;
-		}
-		spin_unlock(*ptlp);
-		if (range)
-			mmu_notifier_invalidate_range_end(range);
-	}
-
 	if (pmd_none(*pmd) || unlikely(pmd_bad(*pmd)))
 		goto out;
 
-	if (range) {
-		mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
-					address & PAGE_MASK,
-					(address & PAGE_MASK) + PAGE_SIZE);
-		mmu_notifier_invalidate_range_start(range);
-	}
 	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
 	if (!pte_present(*ptep))
 		goto unlock;
@@ -5118,38 +5112,9 @@ int follow_invalidate_pte(struct mm_stru
 	return 0;
 unlock:
 	pte_unmap_unlock(ptep, *ptlp);
-	if (range)
-		mmu_notifier_invalidate_range_end(range);
 out:
 	return -EINVAL;
 }
-
-/**
- * follow_pte - look up PTE at a user virtual address
- * @mm: the mm_struct of the target address space
- * @address: user virtual address
- * @ptepp: location to store found PTE
- * @ptlp: location to store the lock for the PTE
- *
- * On a successful return, the pointer to the PTE is stored in @ptepp;
- * the corresponding lock is taken and its location is stored in @ptlp.
- * The contents of the PTE are only stable until @ptlp is released;
- * any further use, if any, must be protected against invalidation
- * with MMU notifiers.
- *
- * Only IO mappings and raw PFN mappings are allowed.  The mmap semaphore
- * should be taken for read.
- *
- * KVM uses this function.  While it is arguably less bad than ``follow_pfn``,
- * it is not a good general-purpose API.
- *
- * Return: zero on success, -ve otherwise.
- */
-int follow_pte(struct mm_struct *mm, unsigned long address,
-	       pte_t **ptepp, spinlock_t **ptlp)
-{
-	return follow_invalidate_pte(mm, address, NULL, ptepp, NULL, ptlp);
-}
 EXPORT_SYMBOL_GPL(follow_pte);
 
 /**
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-hugetlb_vmemmap-introduce-arch_want_hugetlb_page_free_vmemmap.patch
arm64-mm-hugetlb-enable-hugetlb_page_free_vmemmap-for-arm64.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_vmemmap-related-functions.patch
mm-hugetlb_vmemmap-cleanup-hugetlb_free_vmemmap_enabled.patch
mm-hugetlb_vmemmap-cleanup-config_hugetlb_page_free_vmemmap.patch
mm-rmap-fix-cache-flush-on-thp-pages.patch
dax-fix-cache-flush-on-pmd-mapped-pages.patch
mm-rmap-introduce-pfn_mkclean_range-to-cleans-ptes.patch
mm-pvmw-add-support-for-walking-devmap-pages.patch
dax-fix-missing-writeprotect-the-pte-entry.patch
mm-simplify-follow_invalidate_pte.patch

