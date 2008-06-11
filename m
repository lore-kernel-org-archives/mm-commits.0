From: akpm@linux-foundation.org
Subject: + pagemap-fix-large-pages-in-pagemap.patch added to -mm tree
Date: Wed, 11 Jun 2008 13:29:44 -0700
Message-ID: <200806112029.m5BKTj1V016503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54597 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbYFKUkN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jun 2008 16:40:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave@linux.vnet.ibm.com, mpm@selenic.com


The patch titled
     pagemap: fix large pages in pagemap
has been added to the -mm tree.  Its filename is
     pagemap-fix-large-pages-in-pagemap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

pagemap-pass-mm-into-pagewalkers.patch
pagemap-fix-large-pages-in-pagemap.patch

