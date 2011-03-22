From: akpm@linux-foundation.org
Subject: [folded] pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 22 Mar 2011 15:59:31 -0700
Message-ID: <201103222259.p2MMxV5t032722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754393Ab1CVXAC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:00:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch

This patch was dropped because it was folded into pagewalk-only-split-huge-pages-when-necessary.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: please, no space before tabs
#76: FILE: include/linux/mm.h:910:
+ * ^I       this handler is required to be able to handle$

WARNING: please, no space before tabs
#77: FILE: include/linux/mm.h:911:
+ * ^I       pmd_trans_huge() pmds.  They may simply choose to$

WARNING: please, no space before tabs
#78: FILE: include/linux/mm.h:912:
+ * ^I       split_huge_page() instead of handling it explicitly.$

WARNING: labels should not be indented
#112: FILE: mm/pagewalk.c:36:
+	again:

total: 0 errors, 4 warnings, 90 lines checked

./patches/pagewalk-only-split-huge-pages-when-necessary.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    6 +++---
 mm/pagewalk.c      |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/mm.h~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -907,9 +907,9 @@ unsigned long unmap_vmas(struct mmu_gath
  * @pgd_entry: if set, called for each non-empty PGD (top-level) entry
  * @pud_entry: if set, called for each non-empty PUD (2nd-level) entry
  * @pmd_entry: if set, called for each non-empty PMD (3rd-level) entry
- * 	       this handler is required to be able to handle
- * 	       pmd_trans_huge() pmds.  They may simply choose to
- * 	       split_huge_page() instead of handling it explicitly.
+ *	       this handler is required to be able to handle
+ *	       pmd_trans_huge() pmds.  They may simply choose to
+ *	       split_huge_page() instead of handling it explicitly.
  * @pte_entry: if set, called for each non-empty PTE (4th-level) entry
  * @pte_hole: if set, called for each hole at all levels
  * @hugetlb_entry: if set, called for each hugetlb entry
diff -puN mm/pagewalk.c~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes mm/pagewalk.c
--- a/mm/pagewalk.c~pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes
+++ a/mm/pagewalk.c
@@ -33,7 +33,7 @@ static int walk_pmd_range(pud_t *pud, un
 
 	pmd = pmd_offset(pud, addr);
 	do {
-	again:
+again:
 		next = pmd_addr_end(addr, end);
 		if (pmd_none(*pmd)) {
 			if (walk->pte_hole)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
pagewalk-only-split-huge-pages-when-necessary.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

