From: akpm@linux-foundation.org
Subject: [patch 069/108] powerpc/mm/hugetlb: remove
 follow_huge_addr for powerpc
Date: Thu, 06 Jul 2017 15:39:02 -0700
Message-ID: <20170706223902.WwlyUOJLp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbdGFWjD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:39:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/mm/hugetlb: remove follow_huge_addr for powerpc

With generic code now handling hugetlb entries at pgd level and also
supporting hugepage directory format, we can now remove the powerpc
sepcific follow_huge_addr implementation.

Link: http://lkml.kernel.org/r/1494926612-23928-9-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |   64 --------------------------------
 1 file changed, 64 deletions(-)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-mm-hugetlb-remove-follow_huge_addr-for-powerpc arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-mm-hugetlb-remove-follow_huge_addr-for-powerpc
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -619,11 +619,6 @@ void hugetlb_free_pgd_range(struct mmu_g
 	} while (addr = next, addr != end);
 }
 
-/*
- * 64 bit book3s use generic follow_page_mask
- */
-#ifdef CONFIG_PPC_BOOK3S_64
-
 struct page *follow_huge_pd(struct vm_area_struct *vma,
 			    unsigned long address, hugepd_t hpd,
 			    int flags, int pdshift)
@@ -657,65 +652,6 @@ retry:
 	return page;
 }
 
-#else /* !CONFIG_PPC_BOOK3S_64 */
-
-/*
- * We are holding mmap_sem, so a parallel huge page collapse cannot run.
- * To prevent hugepage split, disable irq.
- */
-struct page *
-follow_huge_addr(struct mm_struct *mm, unsigned long address, int write)
-{
-	bool is_thp;
-	pte_t *ptep, pte;
-	unsigned shift;
-	unsigned long mask, flags;
-	struct page *page = ERR_PTR(-EINVAL);
-
-	local_irq_save(flags);
-	ptep = find_linux_pte_or_hugepte(mm->pgd, address, &is_thp, &shift);
-	if (!ptep)
-		goto no_page;
-	pte = READ_ONCE(*ptep);
-	/*
-	 * Verify it is a huge page else bail.
-	 * Transparent hugepages are handled by generic code. We can skip them
-	 * here.
-	 */
-	if (!shift || is_thp)
-		goto no_page;
-
-	if (!pte_present(pte)) {
-		page = NULL;
-		goto no_page;
-	}
-	mask = (1UL << shift) - 1;
-	page = pte_page(pte);
-	if (page)
-		page += (address & mask) / PAGE_SIZE;
-
-no_page:
-	local_irq_restore(flags);
-	return page;
-}
-
-struct page *
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int write)
-{
-	BUG();
-	return NULL;
-}
-
-struct page *
-follow_huge_pud(struct mm_struct *mm, unsigned long address,
-		pud_t *pud, int write)
-{
-	BUG();
-	return NULL;
-}
-#endif
