From: akpm@linux-foundation.org
Subject: + mm-follow_page_mask-add-support-for-hugetlb-pgd-entries.patch
 added to -mm tree
Date: Tue, 16 May 2017 13:12:16 -0700
Message-ID: <591b5d20.KpUye4O4XO+cupBS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43896 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752502AbdEPUMR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 May 2017 16:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khandual@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, kravetz@us.ibm.com, mpe@ellerman.id.au, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/follow_page_mask: add support for hugetlb pgd entries
has been added to the -mm tree.  Its filename is
     mm-follow_page_mask-add-support-for-hugetlb-pgd-entries.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-follow_page_mask-add-support-for-hugetlb-pgd-entries.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-follow_page_mask-add-support-for-hugetlb-pgd-entries.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: mm/follow_page_mask: add support for hugetlb pgd entries

ppc64 supports pgd hugetlb entries.  Add code to handle hugetlb pgd
entries to follow_page_mask so that ppc64 can switch to it to handle
hugetlbe entries.

Link: http://lkml.kernel.org/r/1494926612-23928-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com
Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mike Kravetz <kravetz@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++++
 mm/gup.c                |    7 +++++++
 mm/hugetlb.c            |    9 +++++++++
 3 files changed, 20 insertions(+)

diff -puN include/linux/hugetlb.h~mm-follow_page_mask-add-support-for-hugetlb-pgd-entries include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-follow_page_mask-add-support-for-hugetlb-pgd-entries
+++ a/include/linux/hugetlb.h
@@ -121,6 +121,9 @@ struct page *follow_huge_pmd(struct mm_s
 				pmd_t *pmd, int flags);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
 				pud_t *pud, int flags);
+struct page *follow_huge_pgd(struct mm_struct *mm, unsigned long address,
+			     pgd_t *pgd, int flags);
+
 int pmd_huge(pmd_t pmd);
 int pud_huge(pud_t pud);
 unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
@@ -150,6 +153,7 @@ static inline void hugetlb_show_meminfo(
 }
 #define follow_huge_pmd(mm, addr, pmd, flags)	NULL
 #define follow_huge_pud(mm, addr, pud, flags)	NULL
+#define follow_huge_pgd(mm, addr, pgd, flags)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
 #define pmd_huge(x)	0
 #define pud_huge(x)	0
diff -puN mm/gup.c~mm-follow_page_mask-add-support-for-hugetlb-pgd-entries mm/gup.c
--- a/mm/gup.c~mm-follow_page_mask-add-support-for-hugetlb-pgd-entries
+++ a/mm/gup.c
@@ -357,6 +357,13 @@ struct page *follow_page_mask(struct vm_
 	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
 		return no_page_table(vma, flags);
 
+	if (pgd_huge(*pgd)) {
+		page = follow_huge_pgd(mm, address, pgd, flags);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
+
 	return follow_p4d_mask(vma, address, pgd, flags, page_mask);
 }
 
diff -puN mm/hugetlb.c~mm-follow_page_mask-add-support-for-hugetlb-pgd-entries mm/hugetlb.c
--- a/mm/hugetlb.c~mm-follow_page_mask-add-support-for-hugetlb-pgd-entries
+++ a/mm/hugetlb.c
@@ -4710,6 +4710,15 @@ follow_huge_pud(struct mm_struct *mm, un
 	return pte_page(*(pte_t *)pud) + ((address & ~PUD_MASK) >> PAGE_SHIFT);
 }
 
+struct page * __weak
+follow_huge_pgd(struct mm_struct *mm, unsigned long address, pgd_t *pgd, int flags)
+{
+	if (flags & FOLL_GET)
+		return NULL;
+
+	return pte_page(*(pte_t *)pgd) + ((address & ~PGDIR_MASK) >> PAGE_SHIFT);
+}
+
 #ifdef CONFIG_MEMORY_FAILURE
 
 /*
_

Patches currently in -mm which might be from khandual@linux.vnet.ibm.com are

mm-vmstat-standardize-file-operations-variable-names.patch
mm-madvise-enable-softhard-offline-of-hugetlb-pages-at-pgd-level.patch
mm-follow_page_mask-add-support-for-hugetlb-pgd-entries.patch

