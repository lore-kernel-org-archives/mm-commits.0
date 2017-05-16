From: akpm@linux-foundation.org
Subject: +
 mm-follow_page_mask-split-follow_page_mask-to-smaller-functions.patch added to -mm tree
Date: Tue, 16 May 2017 13:12:12 -0700
Message-ID: <591b5d1c.1nEUY3rnCckCGkkk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43872 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbdEPUMN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:12:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/follow_page_mask: split follow_page_mask to smaller functions.
has been added to the -mm tree.  Its filename is
     mm-follow_page_mask-split-follow_page_mask-to-smaller-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-follow_page_mask-split-follow_page_mask-to-smaller-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-follow_page_mask-split-follow_page_mask-to-smaller-functions.patch

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
Subject: mm/follow_page_mask: split follow_page_mask to smaller functions.

Makes code reading easy.  No functional changes in this patch.  In a
followup patch, we will be updating the follow_page_mask to handle hugetlb
hugepd format so that archs like ppc64 can switch to the generic version. 
This split helps in doing that nicely.

Link: http://lkml.kernel.org/r/1494926612-23928-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  148 ++++++++++++++++++++++++++++++++---------------------
 1 file changed, 91 insertions(+), 57 deletions(-)

diff -puN mm/gup.c~mm-follow_page_mask-split-follow_page_mask-to-smaller-functions mm/gup.c
--- a/mm/gup.c~mm-follow_page_mask-split-follow_page_mask-to-smaller-functions
+++ a/mm/gup.c
@@ -208,68 +208,16 @@ no_page:
 	return no_page_table(vma, flags);
 }
 
-/**
- * follow_page_mask - look up a page descriptor from a user-virtual address
- * @vma: vm_area_struct mapping @address
- * @address: virtual address to look up
- * @flags: flags modifying lookup behaviour
- * @page_mask: on output, *page_mask is set according to the size of the page
- *
- * @flags can have FOLL_ flags set, defined in <linux/mm.h>
- *
- * Returns the mapped (struct page *), %NULL if no mapping exists, or
- * an error pointer if there is a mapping to something not represented
- * by a page descriptor (see also vm_normal_page()).
- */
-struct page *follow_page_mask(struct vm_area_struct *vma,
-			      unsigned long address, unsigned int flags,
-			      unsigned int *page_mask)
+static struct page *follow_pmd_mask(struct vm_area_struct *vma,
+				    unsigned long address, pud_t *pudp,
+				    unsigned int flags, unsigned int *page_mask)
 {
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
 	pmd_t *pmd;
 	spinlock_t *ptl;
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 
-	*page_mask = 0;
-
-	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
-	if (!IS_ERR(page)) {
-		BUG_ON(flags & FOLL_GET);
-		return page;
-	}
-
-	pgd = pgd_offset(mm, address);
-	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
-		return no_page_table(vma, flags);
-	p4d = p4d_offset(pgd, address);
-	if (p4d_none(*p4d))
-		return no_page_table(vma, flags);
-	BUILD_BUG_ON(p4d_huge(*p4d));
-	if (unlikely(p4d_bad(*p4d)))
-		return no_page_table(vma, flags);
-	pud = pud_offset(p4d, address);
-	if (pud_none(*pud))
-		return no_page_table(vma, flags);
-	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
-		page = follow_huge_pud(mm, address, pud, flags);
-		if (page)
-			return page;
-		return no_page_table(vma, flags);
-	}
-	if (pud_devmap(*pud)) {
-		ptl = pud_lock(mm, pud);
-		page = follow_devmap_pud(vma, address, pud, flags);
-		spin_unlock(ptl);
-		if (page)
-			return page;
-	}
-	if (unlikely(pud_bad(*pud)))
-		return no_page_table(vma, flags);
-
-	pmd = pmd_offset(pud, address);
+	pmd = pmd_offset(pudp, address);
 	if (pmd_none(*pmd))
 		return no_page_table(vma, flags);
 	if (pmd_huge(*pmd) && vma->vm_flags & VM_HUGETLB) {
@@ -319,13 +267,99 @@ struct page *follow_page_mask(struct vm_
 		return ret ? ERR_PTR(ret) :
 			follow_page_pte(vma, address, pmd, flags);
 	}
-
 	page = follow_trans_huge_pmd(vma, address, pmd, flags);
 	spin_unlock(ptl);
 	*page_mask = HPAGE_PMD_NR - 1;
 	return page;
 }
 
+
+static struct page *follow_pud_mask(struct vm_area_struct *vma,
+				    unsigned long address, p4d_t *p4dp,
+				    unsigned int flags, unsigned int *page_mask)
+{
+	pud_t *pud;
+	spinlock_t *ptl;
+	struct page *page;
+	struct mm_struct *mm = vma->vm_mm;
+
+	pud = pud_offset(p4dp, address);
+	if (pud_none(*pud))
+		return no_page_table(vma, flags);
+	if (pud_huge(*pud) && vma->vm_flags & VM_HUGETLB) {
+		page = follow_huge_pud(mm, address, pud, flags);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
+	if (pud_devmap(*pud)) {
+		ptl = pud_lock(mm, pud);
+		page = follow_devmap_pud(vma, address, pud, flags);
+		spin_unlock(ptl);
+		if (page)
+			return page;
+	}
+	if (unlikely(pud_bad(*pud)))
+		return no_page_table(vma, flags);
+
+	return follow_pmd_mask(vma, address, pud, flags, page_mask);
+}
+
+
+static struct page *follow_p4d_mask(struct vm_area_struct *vma,
+				    unsigned long address, pgd_t *pgdp,
+				    unsigned int flags, unsigned int *page_mask)
+{
+	p4d_t *p4d;
+
+	p4d = p4d_offset(pgdp, address);
+	if (p4d_none(*p4d))
+		return no_page_table(vma, flags);
+	BUILD_BUG_ON(p4d_huge(*p4d));
+	if (unlikely(p4d_bad(*p4d)))
+		return no_page_table(vma, flags);
+
+	return follow_pud_mask(vma, address, p4d, flags, page_mask);
+}
+
+/**
+ * follow_page_mask - look up a page descriptor from a user-virtual address
+ * @vma: vm_area_struct mapping @address
+ * @address: virtual address to look up
+ * @flags: flags modifying lookup behaviour
+ * @page_mask: on output, *page_mask is set according to the size of the page
+ *
+ * @flags can have FOLL_ flags set, defined in <linux/mm.h>
+ *
+ * Returns the mapped (struct page *), %NULL if no mapping exists, or
+ * an error pointer if there is a mapping to something not represented
+ * by a page descriptor (see also vm_normal_page()).
+ */
+struct page *follow_page_mask(struct vm_area_struct *vma,
+			      unsigned long address, unsigned int flags,
+			      unsigned int *page_mask)
+{
+	pgd_t *pgd;
+	struct page *page;
+	struct mm_struct *mm = vma->vm_mm;
+
+	*page_mask = 0;
+
+	/* make this handle hugepd */
+	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
+	if (!IS_ERR(page)) {
+		BUG_ON(flags & FOLL_GET);
+		return page;
+	}
+
+	pgd = pgd_offset(mm, address);
+
+	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
+		return no_page_table(vma, flags);
+
+	return follow_p4d_mask(vma, address, pgd, flags, page_mask);
+}
+
 static int get_gate_page(struct mm_struct *mm, unsigned long address,
 		unsigned int gup_flags, struct vm_area_struct **vma,
 		struct page **page)
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

