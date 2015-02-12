From: akpm@linux-foundation.org
Subject: [merged]
 clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch removed from -mm tree
Date: Thu, 12 Feb 2015 11:38:19 -0800
Message-ID: <54dd012b.zAFXNQ9fHtw3AtkI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58430 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbbBLTiU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: clear_refs: remove clear_refs_private->vma and introduce clear_refs_test_walk()
has been removed from the -mm tree.  Its filename was
     clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: clear_refs: remove clear_refs_private->vma and introduce clear_refs_test_walk()

clear_refs_write() has some prechecks to determine if we really walk over
a given vma.  Now we have a test_walk() callback to filter vmas, so let's
utilize it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   46 ++++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff -puN fs/proc/task_mmu.c~clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk
+++ a/fs/proc/task_mmu.c
@@ -736,7 +736,6 @@ enum clear_refs_types {
 };
 
 struct clear_refs_private {
-	struct vm_area_struct *vma;
 	enum clear_refs_types type;
 };
 
@@ -767,7 +766,7 @@ static int clear_refs_pte_range(pmd_t *p
 				unsigned long end, struct mm_walk *walk)
 {
 	struct clear_refs_private *cp = walk->private;
-	struct vm_area_struct *vma = cp->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte, ptent;
 	spinlock_t *ptl;
 	struct page *page;
@@ -801,6 +800,25 @@ static int clear_refs_pte_range(pmd_t *p
 	return 0;
 }
 
+static int clear_refs_test_walk(unsigned long start, unsigned long end,
+				struct mm_walk *walk)
+{
+	struct clear_refs_private *cp = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+
+	/*
+	 * Writing 1 to /proc/pid/clear_refs affects all pages.
+	 * Writing 2 to /proc/pid/clear_refs only affects anonymous pages.
+	 * Writing 3 to /proc/pid/clear_refs only affects file mapped pages.
+	 * Writing 4 to /proc/pid/clear_refs affects all pages.
+	 */
+	if (cp->type == CLEAR_REFS_ANON && vma->vm_file)
+		return 1;
+	if (cp->type == CLEAR_REFS_MAPPED && !vma->vm_file)
+		return 1;
+	return 0;
+}
+
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -841,6 +859,7 @@ static ssize_t clear_refs_write(struct f
 		};
 		struct mm_walk clear_refs_walk = {
 			.pmd_entry = clear_refs_pte_range,
+			.test_walk = clear_refs_test_walk,
 			.mm = mm,
 			.private = &cp,
 		};
@@ -860,28 +879,7 @@ static ssize_t clear_refs_write(struct f
 			}
 			mmu_notifier_invalidate_range_start(mm, 0, -1);
 		}
-		for (vma = mm->mmap; vma; vma = vma->vm_next) {
-			cp.vma = vma;
-			if (is_vm_hugetlb_page(vma))
-				continue;
-			/*
-			 * Writing 1 to /proc/pid/clear_refs affects all pages.
-			 *
-			 * Writing 2 to /proc/pid/clear_refs only affects
-			 * Anonymous pages.
-			 *
-			 * Writing 3 to /proc/pid/clear_refs only affects file
-			 * mapped pages.
-			 *
-			 * Writing 4 to /proc/pid/clear_refs affects all pages.
-			 */
-			if (type == CLEAR_REFS_ANON && vma->vm_file)
-				continue;
-			if (type == CLEAR_REFS_MAPPED && !vma->vm_file)
-				continue;
-			walk_page_range(vma->vm_start, vma->vm_end,
-					&clear_refs_walk);
-		}
+		walk_page_range(0, ~0UL, &clear_refs_walk);
 		if (type == CLEAR_REFS_SOFT_DIRTY)
 			mmu_notifier_invalidate_range_end(mm, 0, -1);
 		flush_tlb_mm(mm);
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

