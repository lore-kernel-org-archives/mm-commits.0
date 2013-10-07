From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
 added to -mm tree
Date: Mon, 07 Oct 2013 16:12:29 -0700
Message-ID: <52533fdd.OVeHaA2wd+fTanSN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3JGXMa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Oct 2013 19:12:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: + mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Mon, 07 Oct 2013 16:12:29 -0700


The patch titled
     Subject: mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2665,8 +2665,8 @@ retry_avoidcopy:
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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ipc-update-locking-scheme-comments-fix.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-git-rejects.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

