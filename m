From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch removed
 from -mm tree
Date: Thu, 09 Oct 2014 13:40:13 -0700
Message-ID: <5436f2ad.pWqu7NTxd/5nw5j9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaJIUkO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Oct 2014 16:40:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pfeiner@google.com, gorcunov@openvz.org, hughd@google.com, jamieliu@google.com, kirill@shutemov.name, n-horiguchi@ah.jp.nec.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2
has been removed from the -mm tree.  Its filename was
     mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2.patch

This patch was dropped because it was folded into mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch

------------------------------------------------------
From: Peter Feiner <pfeiner@google.com>
Subject: mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2

Restructured patch to make logic more clear.

Signed-off-by: Peter Feiner <pfeiner@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2 fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2
+++ a/fs/proc/task_mmu.c
@@ -1057,27 +1057,15 @@ static int pagemap_pte_range(pmd_t *pmd,
 		return 0;
 
 	while (1) {
-		unsigned long vm_start = end;
-		unsigned long vm_end = end;
-		unsigned long vm_flags = 0;
-
-		if (vma) {
-			/*
-			 * We can't possibly be in a hugetlb VMA. In general,
-			 * for a mm_walk with a pmd_entry and a hugetlb_entry,
-			 * the pmd_entry can only be called on addresses in a
-			 * hugetlb if the walk starts in a non-hugetlb VMA and
-			 * spans a hugepage VMA. Since pagemap_read walks are
-			 * PMD-sized and PMD-aligned, this will never be true.
-			 */
-			BUG_ON(is_vm_hugetlb_page(vma));
-			vm_start = vma->vm_start;
-			vm_end = min(end, vma->vm_end);
-			vm_flags = vma->vm_flags;
-		}
+		/* End of address space hole, which we mark as non-present. */
+		unsigned long hole_end;
+
+		if (vma)
+			hole_end = min(end, vma->vm_start);
+		else
+			hole_end = end;
 
-		/* Addresses before the VMA. */
-		for (; addr < vm_start; addr += PAGE_SIZE) {
+		for (; addr < hole_end; addr += PAGE_SIZE) {
 			pagemap_entry_t pme = make_pme(PM_NOT_PRESENT(pm->v2));
 
 			err = add_to_pagemap(addr, &pme, pm);
@@ -1085,8 +1073,20 @@ static int pagemap_pte_range(pmd_t *pmd,
 				return err;
 		}
 
+		if (!vma)
+			break;
+		/*
+		 * We can't possibly be in a hugetlb VMA. In general,
+		 * for a mm_walk with a pmd_entry and a hugetlb_entry,
+		 * the pmd_entry can only be called on addresses in a
+		 * hugetlb if the walk starts in a non-hugetlb VMA and
+		 * spans a hugepage VMA. Since pagemap_read walks are
+		 * PMD-sized and PMD-aligned, this will never be true.
+		 */
+		BUG_ON(is_vm_hugetlb_page(vma));
+
 		/* Addresses in the VMA. */
-		for (; addr < vm_end; addr += PAGE_SIZE) {
+		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
 			pagemap_entry_t pme;
 			pte = pte_offset_map(pmd, addr);
 			pte_to_pagemap_entry(&pme, pm, vma, addr, *pte);
_

Patches currently in -mm which might be from pfeiner@google.com are

mm-softdirty-unmapped-addresses-between-vmas-are-clean.patch
mm-softdirty-unmapped-addresses-between-vmas-are-clean-v2-fix.patch

