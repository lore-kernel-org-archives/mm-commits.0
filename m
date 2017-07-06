From: akpm@linux-foundation.org
Subject: [patch 068/108] powerpc/hugetlb: add follow_huge_pd
 implementation for ppc64
Date: Thu, 06 Jul 2017 15:38:59 -0700
Message-ID: <20170706223859.FZ8wCsuyc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbdGFWjA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mm-commits@vger.kernel.org, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: powerpc/hugetlb: add follow_huge_pd implementation for ppc64

Link: http://lkml.kernel.org/r/1494926612-23928-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/hugetlbpage.c |   43 ++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff -puN arch/powerpc/mm/hugetlbpage.c~powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64 arch/powerpc/mm/hugetlbpage.c
--- a/arch/powerpc/mm/hugetlbpage.c~powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64
+++ a/arch/powerpc/mm/hugetlbpage.c
@@ -17,6 +17,8 @@
 #include <linux/memblock.h>
 #include <linux/bootmem.h>
 #include <linux/moduleparam.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
@@ -618,6 +620,46 @@ void hugetlb_free_pgd_range(struct mmu_g
 }
 
 /*
+ * 64 bit book3s use generic follow_page_mask
+ */
+#ifdef CONFIG_PPC_BOOK3S_64
+
+struct page *follow_huge_pd(struct vm_area_struct *vma,
+			    unsigned long address, hugepd_t hpd,
+			    int flags, int pdshift)
+{
+	pte_t *ptep;
+	spinlock_t *ptl;
+	struct page *page = NULL;
+	unsigned long mask;
+	int shift = hugepd_shift(hpd);
+	struct mm_struct *mm = vma->vm_mm;
+
+retry:
+	ptl = &mm->page_table_lock;
+	spin_lock(ptl);
+
+	ptep = hugepte_offset(hpd, address, pdshift);
+	if (pte_present(*ptep)) {
+		mask = (1UL << shift) - 1;
+		page = pte_page(*ptep);
+		page += ((address & mask) >> PAGE_SHIFT);
+		if (flags & FOLL_GET)
+			get_page(page);
+	} else {
+		if (is_hugetlb_entry_migration(*ptep)) {
+			spin_unlock(ptl);
+			__migration_entry_wait(mm, ptep, ptl);
+			goto retry;
+		}
+	}
+	spin_unlock(ptl);
+	return page;
+}
+
+#else /* !CONFIG_PPC_BOOK3S_64 */
+
+/*
  * We are holding mmap_sem, so a parallel huge page collapse cannot run.
  * To prevent hugepage split, disable irq.
  */
@@ -672,6 +714,7 @@ follow_huge_pud(struct mm_struct *mm, un
 	BUG();
 	return NULL;
 }
+#endif
 
 static unsigned long hugepte_addr_end(unsigned long addr, unsigned long end,
 				      unsigned long sz)
_
