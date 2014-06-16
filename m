From: akpm@linux-foundation.org
Subject: [nacked]
 pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch removed from
 -mm tree
Date: Mon, 16 Jun 2014 16:32:16 -0700
Message-ID: <539f7e80.juyJcdudHZmjcrzU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbaFPXcQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:32:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fengguang.wu@intel.com, n-horiguchi@ah.jp.nec.com


The patch titled
     Subject: fs/proc/task_mmu.c: assume non-NULL vma in pagemap_hugetlb()
has been removed from the -mm tree.  Its filename was
     pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: fs/proc/task_mmu.c: assume non-NULL vma in pagemap_hugetlb()

Fengguang reported smatch error about potential NULL pointer access.

In updated page table walker, we never run ->hugetlb_entry() callback
on the address without vma. This is because __walk_page_range() checks
it in advance. So we can assume non-NULL vma in pagemap_hugetlb().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagewalk-remove-argument-hmask-from-hugetlb_entry-fix
+++ a/fs/proc/task_mmu.c
@@ -1042,9 +1042,9 @@ static int pagemap_hugetlb(pte_t *pte, u
 	pagemap_entry_t pme;
 	unsigned long hmask;
 
-	WARN_ON_ONCE(!vma);
+	BUG_ON(!vma);
 
-	if (vma && (vma->vm_flags & VM_SOFTDIRTY))
+	if (vma->vm_flags & VM_SOFTDIRTY)
 		flags2 = __PM_SOFT_DIRTY;
 	else
 		flags2 = 0;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

hwpoison-fix-the-handling-path-of-the-victimized-page-frame-that-belong-to-non-lur.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-pagewalkc-move-pte-null-check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control.patch
mm-pagewalk-replace-mm_walk-skip-with-more-general-mm_walk-control-fix.patch
madvise-cleanup-swapin_walk_pmd_entry.patch
madvise-cleanup-swapin_walk_pmd_entry-fix.patch
memcg-separate-mem_cgroup_move_charge_pte_range.patch
memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes.patch
arch-powerpc-mm-subpage-protc-cleanup-subpage_walk_pmd_entry.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code.patch
mm-pagewalk-move-pmd_trans_huge_lock-from-callbacks-to-common-code-checkpatch-fixes.patch
mincore-apply-page-table-walker-on-do_mincore.patch
mincore-apply-page-table-walker-on-do_mincore-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

