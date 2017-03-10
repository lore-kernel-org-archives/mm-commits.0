From: akpm@linux-foundation.org
Subject: [merged] x86-mm-unify-exit-paths-in-gup_pte_range.patch removed
 from -mm tree
Date: Fri, 10 Mar 2017 13:42:49 -0800
Message-ID: <58c31dd9.+0khDltteiQQd1KG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37944 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933047AbdCJVmu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Mar 2017 16:42:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com, ross.zwisler@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86, mm: unify exit paths in gup_pte_range()
has been removed from the -mm tree.  Its filename was
     x86-mm-unify-exit-paths-in-gup_pte_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: x86, mm: unify exit paths in gup_pte_range()

All exit paths from gup_pte_range() require pte_unmap() of the original
pte page before returning.  Refactor the code to have a single exit point
to do the unmap.

This mirrors the flow of the generic gup_pte_range() in mm/gup.c.

Link: http://lkml.kernel.org/r/148804251828.36605.14910389618497006945.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |   41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff -puN arch/x86/mm/gup.c~x86-mm-unify-exit-paths-in-gup_pte_range arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~x86-mm-unify-exit-paths-in-gup_pte_range
+++ a/arch/x86/mm/gup.c
@@ -106,36 +106,35 @@ static noinline int gup_pte_range(pmd_t
 		unsigned long end, int write, struct page **pages, int *nr)
 {
 	struct dev_pagemap *pgmap = NULL;
-	int nr_start = *nr;
-	pte_t *ptep;
+	int nr_start = *nr, ret = 0;
+	pte_t *ptep, *ptem;
 
-	ptep = pte_offset_map(&pmd, addr);
+	/*
+	 * Keep the original mapped PTE value (ptem) around since we
+	 * might increment ptep off the end of the page when finishing
+	 * our loop iteration.
+	 */
+	ptem = ptep = pte_offset_map(&pmd, addr);
 	do {
 		pte_t pte = gup_get_pte(ptep);
 		struct page *page;
 
 		/* Similar to the PMD case, NUMA hinting must take slow path */
-		if (pte_protnone(pte)) {
-			pte_unmap(ptep);
-			return 0;
-		}
-
-		if (!pte_allows_gup(pte_val(pte), write)) {
-			pte_unmap(ptep);
-			return 0;
-		}
+		if (pte_protnone(pte))
+			break;
+
+		if (!pte_allows_gup(pte_val(pte), write))
+			break;
 
 		if (pte_devmap(pte)) {
 			pgmap = get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
 				undo_dev_pagemap(nr, nr_start, pages);
-				pte_unmap(ptep);
-				return 0;
+				break;
 			}
-		} else if (pte_special(pte)) {
-			pte_unmap(ptep);
-			return 0;
-		}
+		} else if (pte_special(pte))
+			break;
+
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 		get_page(page);
@@ -145,9 +144,11 @@ static noinline int gup_pte_range(pmd_t
 		(*nr)++;
 
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
-	pte_unmap(ptep - 1);
+	if (addr == end)
+		ret = 1;
+	pte_unmap(ptem);
 
-	return 1;
+	return ret;
 }
 
 static inline void get_head_page_multiple(struct page *page, int nr)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


