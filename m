From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-add-hugepage-support-to-pagemap-update.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:05:31 -0800
Message-ID: <200912150105.nBF15Vx3007357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758143AbZLOBFq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:05:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, mm-c


The patch titled
     mm-hugetlb-add-hugepage-support-to-pagemap-update
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-hugepage-support-to-pagemap-update.patch

This patch was dropped because it was folded into mm-hugetlb-add-hugepage-support-to-pagemap.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-hugetlb-add-hugepage-support-to-pagemap-update
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

- NULL check of vma

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    6 ++++--
 mm/pagewalk.c      |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/proc/task_mmu.c~mm-hugetlb-add-hugepage-support-to-pagemap-update fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~mm-hugetlb-add-hugepage-support-to-pagemap-update
+++ a/fs/proc/task_mmu.c
@@ -668,13 +668,15 @@ static int pagemap_hugetlb_range(pte_t *
 	int err = 0;
 
 	vma = find_vma(walk->mm, addr);
-	hs = hstate_vma(vma);
+	if (vma)
+		hs = hstate_vma(vma);
 	for (; addr != end; addr += PAGE_SIZE) {
 		u64 pfn = PM_NOT_PRESENT;
 
 		if (vma && (addr >= vma->vm_end)) {
 			vma = find_vma(walk->mm, addr);
-			hs = hstate_vma(vma);
+			if (vma)
+				hs = hstate_vma(vma);
 		}
 
 		if (vma && (vma->vm_start <= addr) && is_vm_hugetlb_page(vma)) {
diff -puN mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap-update mm/pagewalk.c
--- a/mm/pagewalk.c~mm-hugetlb-add-hugepage-support-to-pagemap-update
+++ a/mm/pagewalk.c
@@ -123,7 +123,7 @@ int walk_page_range(unsigned long addr, 
 		next = pgd_addr_end(addr, end);
 
 		/*
-		 * Handle hugetlb vma individually because pagetable walk for
+		 * handle hugetlb vma individually because pagetable walk for
 		 * the hugetlb page is dependent on the architecture and
 		 * we can't handled it in the same manner as non-huge pages.
 		 */
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

