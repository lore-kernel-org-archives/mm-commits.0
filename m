From: akpm@linux-foundation.org
Subject: +
 mm-follow_page_mask-add-support-for-hugepage-directory-entry.patch added to -mm tree
Date: Tue, 16 May 2017 13:12:20 -0700
Message-ID: <591b5d24.57WEXTDjE5UGPRPp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43920 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdEPUMV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:12:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, khandual@linux.vnet.ibm.com, kravetz@us.ibm.com, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/follow_page_mask: add support for hugepage directory entry
has been added to the -mm tree.  Its filename is
     mm-follow_page_mask-add-support-for-hugepage-directory-entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-follow_page_mask-add-support-for-hugepage-directory-entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-follow_page_mask-add-support-for-hugepage-directory-entry.patch

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
Subject: mm/follow_page_mask: add support for hugepage directory entry

Architectures like ppc64 supports hugepage size that is not mapped to any
of of the page table levels.  Instead they add an alternate page table
entry format called hugepage directory (hugepd).  hugepd indicates that
the page table entry maps to a set of hugetlb pages.  Add support for this
in generic follow_page_mask code.  We already support this format in the
generic gup code.

The default implementation prints warning and returns NULL.  We will add
ppc64 support in later patches

Link: http://lkml.kernel.org/r/1494926612-23928-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++++
 mm/gup.c                |   33 +++++++++++++++++++++++++++++++++
 mm/hugetlb.c            |    8 ++++++++
 3 files changed, 45 insertions(+)

diff -puN include/linux/hugetlb.h~mm-follow_page_mask-add-support-for-hugepage-directory-entry include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-follow_page_mask-add-support-for-hugepage-directory-entry
+++ a/include/linux/hugetlb.h
@@ -141,6 +141,9 @@ pte_t *huge_pte_offset(struct mm_struct
 int huge_pmd_unshare(struct mm_struct *mm, unsigned long *addr, pte_t *ptep);
 struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
 			      int write);
+struct page *follow_huge_pd(struct vm_area_struct *vma,
+			    unsigned long address, hugepd_t hpd,
+			    int flags, int pdshift);
 struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 				pmd_t *pmd, int flags);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
@@ -175,6 +178,7 @@ static inline void hugetlb_report_meminf
 static inline void hugetlb_show_meminfo(void)
 {
 }
+#define follow_huge_pd(vma, addr, hpd, flags, pdshift) NULL
 #define follow_huge_pmd(mm, addr, pmd, flags)	NULL
 #define follow_huge_pud(mm, addr, pud, flags)	NULL
 #define follow_huge_pgd(mm, addr, pgd, flags)	NULL
diff -puN mm/gup.c~mm-follow_page_mask-add-support-for-hugepage-directory-entry mm/gup.c
--- a/mm/gup.c~mm-follow_page_mask-add-support-for-hugepage-directory-entry
+++ a/mm/gup.c
@@ -226,6 +226,14 @@ static struct page *follow_pmd_mask(stru
 			return page;
 		return no_page_table(vma, flags);
 	}
+	if (is_hugepd(__hugepd(pmd_val(*pmd)))) {
+		page = follow_huge_pd(vma, address,
+				      __hugepd(pmd_val(*pmd)), flags,
+				      PMD_SHIFT);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
 	if (pmd_devmap(*pmd)) {
 		ptl = pmd_lock(mm, pmd);
 		page = follow_devmap_pmd(vma, address, pmd, flags);
@@ -292,6 +300,14 @@ static struct page *follow_pud_mask(stru
 			return page;
 		return no_page_table(vma, flags);
 	}
+	if (is_hugepd(__hugepd(pud_val(*pud)))) {
+		page = follow_huge_pd(vma, address,
+				      __hugepd(pud_val(*pud)), flags,
+				      PUD_SHIFT);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
 	if (pud_devmap(*pud)) {
 		ptl = pud_lock(mm, pud);
 		page = follow_devmap_pud(vma, address, pud, flags);
@@ -311,6 +327,7 @@ static struct page *follow_p4d_mask(stru
 				    unsigned int flags, unsigned int *page_mask)
 {
 	p4d_t *p4d;
+	struct page *page;
 
 	p4d = p4d_offset(pgdp, address);
 	if (p4d_none(*p4d))
@@ -319,6 +336,14 @@ static struct page *follow_p4d_mask(stru
 	if (unlikely(p4d_bad(*p4d)))
 		return no_page_table(vma, flags);
 
+	if (is_hugepd(__hugepd(p4d_val(*p4d)))) {
+		page = follow_huge_pd(vma, address,
+				      __hugepd(p4d_val(*p4d)), flags,
+				      P4D_SHIFT);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
 	return follow_pud_mask(vma, address, p4d, flags, page_mask);
 }
 
@@ -362,6 +387,14 @@ struct page *follow_page_mask(struct vm_
 		if (page)
 			return page;
 		return no_page_table(vma, flags);
+	}
+	if (is_hugepd(__hugepd(pgd_val(*pgd)))) {
+		page = follow_huge_pd(vma, address,
+				      __hugepd(pgd_val(*pgd)), flags,
+				      PGDIR_SHIFT);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
 	}
 
 	return follow_p4d_mask(vma, address, pgd, flags, page_mask);
diff -puN mm/hugetlb.c~mm-follow_page_mask-add-support-for-hugepage-directory-entry mm/hugetlb.c
--- a/mm/hugetlb.c~mm-follow_page_mask-add-support-for-hugepage-directory-entry
+++ a/mm/hugetlb.c
@@ -4664,6 +4664,14 @@ follow_huge_addr(struct mm_struct *mm, u
 }
 
 struct page * __weak
+follow_huge_pd(struct vm_area_struct *vma,
+	       unsigned long address, hugepd_t hpd, int flags, int pdshift)
+{
+	WARN(1, "hugepd follow called with no support for hugepage directory format\n");
+	return NULL;
+}
+
+struct page * __weak
 follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		pmd_t *pmd, int flags)
 {
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

