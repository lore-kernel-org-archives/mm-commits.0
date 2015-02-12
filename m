From: akpm@linux-foundation.org
Subject: [merged]
 smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch removed from
 -mm tree
Date: Thu, 12 Feb 2015 11:38:16 -0800
Message-ID: <54dd0128.k5TdQsja+wnA2BdU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbbBLTiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: smaps: remove mem_size_stats->vma and use walk_page_vma()
has been removed from the -mm tree.  Its filename was
     smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: smaps: remove mem_size_stats->vma and use walk_page_vma()

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private.  And show_smap() walks pages on vma basis, so using
walk_page_vma() is preferable.

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

 fs/proc/task_mmu.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN fs/proc/task_mmu.c~smaps-remove-mem_size_stats-vma-and-use-walk_page_vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~smaps-remove-mem_size_stats-vma-and-use-walk_page_vma
+++ a/fs/proc/task_mmu.c
@@ -436,7 +436,6 @@ const struct file_operations proc_tid_ma
 
 #ifdef CONFIG_PROC_PAGE_MONITOR
 struct mem_size_stats {
-	struct vm_area_struct *vma;
 	unsigned long resident;
 	unsigned long shared_clean;
 	unsigned long shared_dirty;
@@ -485,7 +484,7 @@ static void smaps_pte_entry(pte_t *pte,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct page *page = NULL;
 
 	if (pte_present(*pte)) {
@@ -509,7 +508,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 		struct mm_walk *walk)
 {
 	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	struct page *page;
 
 	/* FOLL_DUMP will return -EFAULT on huge zero page */
@@ -530,8 +529,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 static int smaps_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			   struct mm_walk *walk)
 {
-	struct mem_size_stats *mss = walk->private;
-	struct vm_area_struct *vma = mss->vma;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 
@@ -623,10 +621,8 @@ static int show_smap(struct seq_file *m,
 	};
 
 	memset(&mss, 0, sizeof mss);
-	mss.vma = vma;
 	/* mmap_sem is held in m_start */
-	if (vma->vm_mm && !is_vm_hugetlb_page(vma))
-		walk_page_range(vma->vm_start, vma->vm_end, &smaps_walk);
+	walk_page_vma(vma, &smaps_walk);
 
 	show_map_vma(m, vma, is_pid);
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch
mm-hwpoison-drop-lru_add_drain_all-in-__soft_offline_page.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

