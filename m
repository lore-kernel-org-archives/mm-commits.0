From: akpm@linux-foundation.org
Subject: [merged] numa_maps-remove-numa_maps-vma.patch removed from -mm
 tree
Date: Thu, 12 Feb 2015 11:38:28 -0800
Message-ID: <54dd0134.5RAT8Mug2fFSlLb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58455 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbbBLTi3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:38:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: numa_maps: remove numa_maps->vma
has been removed from the -mm tree.  Its filename was
     numa_maps-remove-numa_maps-vma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: numa_maps: remove numa_maps->vma

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private.  And show_numa_map() walks pages on vma basis, so using
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

 fs/proc/task_mmu.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN fs/proc/task_mmu.c~numa_maps-remove-numa_maps-vma fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~numa_maps-remove-numa_maps-vma
+++ a/fs/proc/task_mmu.c
@@ -1283,7 +1283,6 @@ const struct file_operations proc_pagema
 #ifdef CONFIG_NUMA
 
 struct numa_maps {
-	struct vm_area_struct *vma;
 	unsigned long pages;
 	unsigned long anon;
 	unsigned long active;
@@ -1352,18 +1351,17 @@ static struct page *can_gather_numa_stat
 static int gather_pte_stats(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
-	struct numa_maps *md;
+	struct numa_maps *md = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	spinlock_t *ptl;
 	pte_t *orig_pte;
 	pte_t *pte;
 
-	md = walk->private;
-
-	if (pmd_trans_huge_lock(pmd, md->vma, &ptl) == 1) {
+	if (pmd_trans_huge_lock(pmd, vma, &ptl) == 1) {
 		pte_t huge_pte = *(pte_t *)pmd;
 		struct page *page;
 
-		page = can_gather_numa_stats(huge_pte, md->vma, addr);
+		page = can_gather_numa_stats(huge_pte, vma, addr);
 		if (page)
 			gather_stats(page, md, pte_dirty(huge_pte),
 				     HPAGE_PMD_SIZE/PAGE_SIZE);
@@ -1375,7 +1373,7 @@ static int gather_pte_stats(pmd_t *pmd,
 		return 0;
 	orig_pte = pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	do {
-		struct page *page = can_gather_numa_stats(*pte, md->vma, addr);
+		struct page *page = can_gather_numa_stats(*pte, vma, addr);
 		if (!page)
 			continue;
 		gather_stats(page, md, pte_dirty(*pte), 1);
@@ -1422,7 +1420,12 @@ static int show_numa_map(struct seq_file
 	struct numa_maps *md = &numa_priv->md;
 	struct file *file = vma->vm_file;
 	struct mm_struct *mm = vma->vm_mm;
-	struct mm_walk walk = {};
+	struct mm_walk walk = {
+		.hugetlb_entry = gather_hugetlb_stats,
+		.pmd_entry = gather_pte_stats,
+		.private = md,
+		.mm = mm,
+	};
 	struct mempolicy *pol;
 	char buffer[64];
 	int nid;
@@ -1433,13 +1436,6 @@ static int show_numa_map(struct seq_file
 	/* Ensure we start with an empty set of numa_maps statistics. */
 	memset(md, 0, sizeof(*md));
 
-	md->vma = vma;
-
-	walk.hugetlb_entry = gather_hugetlb_stats;
-	walk.pmd_entry = gather_pte_stats;
-	walk.private = md;
-	walk.mm = mm;
