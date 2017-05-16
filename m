From: akpm@linux-foundation.org
Subject: +
 powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64.patch added to
 -mm tree
Date: Tue, 16 May 2017 13:12:23 -0700
Message-ID: <591b5d27.ezD6I2g4xJN6j0+k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdEPUMY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/hugetlb: add follow_huge_pd implementation for ppc64
has been added to the -mm tree.  Its filename is
     powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from aneesh.kumar@linux.vnet.ibm.com are

mm-hugetlb-migration-use-set_huge_pte_at-instead-of-set_pte_at.patch
mm-follow_page_mask-split-follow_page_mask-to-smaller-functions.patch
mm-hugetlb-export-hugetlb_entry_migration-helper.patch
mm-hugetlb-move-default-definition-of-hugepd_t-earlier-in-the-header.patch
mm-follow_page_mask-add-support-for-hugepage-directory-entry.patch
powerpc-hugetlb-add-follow_huge_pd-implementation-for-ppc64.patch
powerpc-mm-hugetlb-remove-follow_huge_addr-for-powerpc.patch
powerpc-hugetlb-enable-hugetlb-migration-for-ppc64.patch

