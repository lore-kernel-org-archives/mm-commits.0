From: akpm@linux-foundation.org
Subject: - pagemap-fix-large-pages-in-pagemap.patch removed from -mm tree
Date: Sun, 15 Jun 2008 23:03:57 -0700
Message-ID: <200806160603.m5G63v7p010635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52682 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbYFPGTV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jun 2008 02:19:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@linux.vnet.ibm.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     pagemap: fix large pages in pagemap
has been removed from the -mm tree.  Its filename was
     pagemap-fix-large-pages-in-pagemap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pagemap: fix large pages in pagemap
From: Dave Hansen <dave@linux.vnet.ibm.com>

We were walking right into huge page areas in the pagemap walker, and
calling the pmds pmd_bad() and clearing them.

That leaked huge pages.  Bad.

This patch at least works around that for now.  It ignores huge pages in
the pagemap walker for the time being, and won't leak those pages.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-fix-large-pages-in-pagemap fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~pagemap-fix-large-pages-in-pagemap
+++ a/fs/proc/task_mmu.c
@@ -553,24 +553,45 @@ static u64 swap_pte_to_pagemap_entry(pte
 	return swp_type(e) | (swp_offset(e) << MAX_SWAPFILES_SHIFT);
 }
 
+static unsigned long pte_to_pagemap_entry(pte_t pte)
+{
+	unsigned long pme = 0;
+	if (is_swap_pte(pte))
+		pme = PM_PFRAME(swap_pte_to_pagemap_entry(pte))
+			| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP;
+	else if (pte_present(pte))
+		pme = PM_PFRAME(pte_pfn(pte))
+			| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
+	return pme;
+}
+
 static int pagemap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			     struct mm_walk *walk)
 {
+	struct vm_area_struct *vma;
 	struct pagemapread *pm = walk->private;
 	pte_t *pte;
 	int err = 0;
 
+	/* find the first VMA at or above 'addr' */
+	vma = find_vma(walk->mm, addr);
 	for (; addr != end; addr += PAGE_SIZE) {
 		u64 pfn = PM_NOT_PRESENT;
-		pte = pte_offset_map(pmd, addr);
-		if (is_swap_pte(*pte))
-			pfn = PM_PFRAME(swap_pte_to_pagemap_entry(*pte))
-				| PM_PSHIFT(PAGE_SHIFT) | PM_SWAP;
-		else if (pte_present(*pte))
-			pfn = PM_PFRAME(pte_pfn(*pte))
-				| PM_PSHIFT(PAGE_SHIFT) | PM_PRESENT;
-		/* unmap so we're not in atomic when we copy to userspace */
-		pte_unmap(pte);
+
+		/* check to see if we've left 'vma' behind
+		 * and need a new, higher one */
+		if (vma && (addr >= vma->vm_end))
+			vma = find_vma(walk->mm, addr);
+
+		/* check that 'vma' actually covers this address,
+		 * and that it isn't a huge page vma */
+		if (vma && (vma->vm_start <= addr) &&
+		    !is_vm_hugetlb_page(vma)) {
+			pte = pte_offset_map(pmd, addr);
+			pfn = pte_to_pagemap_entry(*pte);
+			/* unmap before userspace copy */
+			pte_unmap(pte);
+		}
 		err = add_to_pagemap(addr, pfn, pm);
 		if (err)
 			return err;
_

Patches currently in -mm which might be from dave@linux.vnet.ibm.com are

origin.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch

