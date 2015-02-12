From: akpm@linux-foundation.org
Subject: [merged]
 mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:38:40 -0800
Message-ID: <54dd0140.4Hn3iVklTL0+gDXG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbbBLTil (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, shashim@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: pagewalk: fix misbehavior of walk_page_range for vma(VM_PFNMAP)
has been removed from the -mm tree.  Its filename was
     mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm: pagewalk: fix misbehavior of walk_page_range for vma(VM_PFNMAP)

walk_page_range() silently skips vma having VM_PFNMAP set, which leads to
undesirable behaviour at client end (who called walk_page_range).  For
example for pagemap_read(), when no callbacks are called against VM_PFNMAP
vma, pagemap_read() may prepare pagemap data for next virtual address
range at wrong index.  That could confuse and/or break userspace
applications.

This patch avoid this misbehavior caused by vma(VM_PFNMAP) like follows:
- for pagemap_read() which has its own ->pte_hole(), call the ->pte_hole()
  over vma(VM_PFNMAP),
- for clear_refs and queue_pages which have their own ->tests_walk,
  just return 1 and skip vma(VM_PFNMAP). This is no problem because
  these are not interested in hole regions,
- for other callers, just skip the vma(VM_PFNMAP) as a default behavior.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Shiraz Hashim <shashim@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    3 +++
 mm/mempolicy.c     |    3 +++
 mm/pagewalk.c      |   21 +++++++++++++--------
 3 files changed, 19 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling
+++ a/fs/proc/task_mmu.c
@@ -806,6 +806,9 @@ static int clear_refs_test_walk(unsigned
 	struct clear_refs_private *cp = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 
+	if (vma->vm_flags & VM_PFNMAP)
+		return 1;
+
 	/*
 	 * Writing 1 to /proc/pid/clear_refs affects all pages.
 	 * Writing 2 to /proc/pid/clear_refs only affects anonymous pages.
diff -puN mm/mempolicy.c~mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling mm/mempolicy.c
--- a/mm/mempolicy.c~mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling
+++ a/mm/mempolicy.c
@@ -591,6 +591,9 @@ static int queue_pages_test_walk(unsigne
 	unsigned long endvma = vma->vm_end;
 	unsigned long flags = qp->flags;
 
+	if (vma->vm_flags & VM_PFNMAP)
+		return 1;
+
 	if (endvma > end)
 		endvma = end;
 	if (vma->vm_start > start)
diff -puN mm/pagewalk.c~mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling mm/pagewalk.c
--- a/mm/pagewalk.c~mm-pagewalk-fix-misbehavior-of-walk_page_range-for-vmavm_pfnmap-re-pagewalk-improve-vma-handling
+++ a/mm/pagewalk.c
@@ -35,7 +35,7 @@ static int walk_pmd_range(pud_t *pud, un
 	do {
 again:
 		next = pmd_addr_end(addr, end);
-		if (pmd_none(*pmd)) {
+		if (pmd_none(*pmd) || !walk->vma) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
 			if (err)
@@ -165,9 +165,6 @@ static int walk_hugetlb_range(unsigned l
  * or skip it via the returned value. Return 0 if we do walk over the
  * current vma, and return 1 if we skip the vma. Negative values means
  * error, where we abort the current walk.
- *
- * Default check (only VM_PFNMAP check for now) is used when the caller
- * doesn't define test_walk() callback.
  */
 static int walk_page_test(unsigned long start, unsigned long end,
 			struct mm_walk *walk)
@@ -178,11 +175,19 @@ static int walk_page_test(unsigned long
 		return walk->test_walk(start, end, walk);
 
 	/*
-	 * Do not walk over vma(VM_PFNMAP), because we have no valid struct
-	 * page backing a VM_PFNMAP range. See also commit a9ff785e4437.
+	 * vma(VM_PFNMAP) doesn't have any valid struct pages behind VM_PFNMAP
+	 * range, so we don't walk over it as we do for normal vmas. However,
+	 * Some callers are interested in handling hole range and they don't
+	 * want to just ignore any single address range. Such users certainly
+	 * define their ->pte_hole() callbacks, so let's delegate them to handle
+	 * vma(VM_PFNMAP).
 	 */
-	if (vma->vm_flags & VM_PFNMAP)
-		return 1;
+	if (vma->vm_flags & VM_PFNMAP) {
+		int err = 1;
+		if (walk->pte_hole)
+			err = walk->pte_hole(start, end, walk);
+		return err ? err : 1;
+	}
 	return 0;
 }
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

