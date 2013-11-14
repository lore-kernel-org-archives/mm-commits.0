From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
 removed from -mm tree
Date: Thu, 14 Nov 2013 14:21:17 -0800
Message-ID: <52854cdd.AB8SYuB2mR3RbRRP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab3KNWVS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Nov 2013 17:21:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 14 Nov 2013 14:21:17 -0800


The patch titled
     Subject: mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes

ERROR: code indent should use tabs where possible
#65: FILE: include/linux/hugetlb.h:396:
+               struct mm_struct *mm, pte_t *pte)$

WARNING: please, no spaces at the start of a line
#65: FILE: include/linux/hugetlb.h:396:
+               struct mm_struct *mm, pte_t *pte)$

WARNING: please, no spaces at the start of a line
#67: FILE: include/linux/hugetlb.h:398:
+       if (huge_page_size(h) == PMD_SIZE)$

WARNING: suspect code indent for conditional statements (7, 15)
#67: FILE: include/linux/hugetlb.h:398:
+       if (huge_page_size(h) == PMD_SIZE)
+               return pmd_lockptr(mm, (pmd_t *) pte);

ERROR: code indent should use tabs where possible
#68: FILE: include/linux/hugetlb.h:399:
+               return pmd_lockptr(mm, (pmd_t *) pte);$

WARNING: please, no spaces at the start of a line
#68: FILE: include/linux/hugetlb.h:399:
+               return pmd_lockptr(mm, (pmd_t *) pte);$

WARNING: please, no spaces at the start of a line
#69: FILE: include/linux/hugetlb.h:400:
+       VM_BUG_ON(huge_page_size(h) == PAGE_SIZE);$

WARNING: please, no spaces at the start of a line
#70: FILE: include/linux/hugetlb.h:401:
+       return &mm->page_table_lock;$

ERROR: code indent should use tabs where possible
#90: FILE: include/linux/hugetlb.h:436:
+               struct mm_struct *mm, pte_t *pte)$

WARNING: please, no spaces at the start of a line
#90: FILE: include/linux/hugetlb.h:436:
+               struct mm_struct *mm, pte_t *pte)$

WARNING: please, no spaces at the start of a line
#92: FILE: include/linux/hugetlb.h:438:
+       return &mm->page_table_lock;$

ERROR: code indent should use tabs where possible
#97: FILE: include/linux/hugetlb.h:443:
+               struct mm_struct *mm, pte_t *pte)$

WARNING: please, no spaces at the start of a line
#97: FILE: include/linux/hugetlb.h:443:
+               struct mm_struct *mm, pte_t *pte)$

WARNING: please, no spaces at the start of a line
#99: FILE: include/linux/hugetlb.h:445:
+       spinlock_t *ptl;$

WARNING: please, no spaces at the start of a line
#100: FILE: include/linux/hugetlb.h:446:
+       ptl = huge_pte_lockptr(h, mm, pte);$

WARNING: please, no spaces at the start of a line
#101: FILE: include/linux/hugetlb.h:447:
+       spin_lock(ptl);$

WARNING: please, no spaces at the start of a line
#102: FILE: include/linux/hugetlb.h:448:
+       return ptl;$

WARNING: line over 80 characters
#264: FILE: mm/hugetlb.c:2668:
+				 * race occurs while re-acquiring page table lock, and

total: 4 errors, 14 warnings, 474 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   25 +++++++++++++------------
 mm/hugetlb.c            |    4 ++--
 2 files changed, 15 insertions(+), 14 deletions(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes
+++ a/include/linux/hugetlb.h
@@ -393,12 +393,12 @@ static inline int hugepage_migration_sup
 }
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
-               struct mm_struct *mm, pte_t *pte)
+					   struct mm_struct *mm, pte_t *pte)
 {
-       if (huge_page_size(h) == PMD_SIZE)
-               return pmd_lockptr(mm, (pmd_t *) pte);
-       VM_BUG_ON(huge_page_size(h) == PAGE_SIZE);
-       return &mm->page_table_lock;
+	if (huge_page_size(h) == PMD_SIZE)
+		return pmd_lockptr(mm, (pmd_t *) pte);
+	VM_BUG_ON(huge_page_size(h) == PAGE_SIZE);
+	return &mm->page_table_lock;
 }
 
 #else	/* CONFIG_HUGETLB_PAGE */
@@ -433,19 +433,20 @@ static inline pgoff_t basepage_index(str
 #define hugepage_migration_support(h)	0
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
-               struct mm_struct *mm, pte_t *pte)
+					   struct mm_struct *mm, pte_t *pte)
 {
-       return &mm->page_table_lock;
+	return &mm->page_table_lock;
 }
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
-               struct mm_struct *mm, pte_t *pte)
+					struct mm_struct *mm, pte_t *pte)
 {
-       spinlock_t *ptl;
-       ptl = huge_pte_lockptr(h, mm, pte);
-       spin_lock(ptl);
-       return ptl;
+	spinlock_t *ptl;
+
+	ptl = huge_pte_lockptr(h, mm, pte);
+	spin_lock(ptl);
+	return ptl;
 }
 
 #endif /* _LINUX_HUGETLB_H */
diff -puN mm/hugetlb.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -2679,8 +2679,8 @@ retry_avoidcopy:
 				if (likely(pte_same(huge_ptep_get(ptep), pte)))
 					goto retry_avoidcopy;
 				/*
-				 * race occurs while re-acquiring page table lock, and
-				 * our job is done.
+				 * race occurs while re-acquiring page table
+				 * lock, and our job is done.
 				 */
 				return 0;
 			}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-memstick-core-ms_blockc-fix-spelling-in-msb_rp_recive_status_reg.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
kfifo-api-type-safety-checkpatch-fixes.patch

