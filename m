From: akpm@linux-foundation.org
Subject: [merged] xtensa-mm-remove-pgtablec.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:02 -0700
Message-ID: <201105252025.p4PKPPdX014392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755556Ab1EYU0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sebastian@breakpoint.cc, chris@zankel.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     xtensa/mm: remove pgtable.c
has been removed from the -mm tree.  Its filename was
     xtensa-mm-remove-pgtablec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xtensa/mm: remove pgtable.c
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

It is not referenced by any Makefile.  pte_alloc_one_kernel() and
pte_alloc_one() is implemented in arch/xtensa/include/asm/pgalloc.h.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Chris Zankel <chris@zankel.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/xtensa/mm/pgtable.c |   72 -------------------------------------
 1 file changed, 72 deletions(-)

diff -puN arch/xtensa/mm/pgtable.c~xtensa-mm-remove-pgtablec /dev/null
--- a/arch/xtensa/mm/pgtable.c
+++ /dev/null
@@ -1,72 +0,0 @@
-/*
- * arch/xtensa/mm/pgtable.c
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2001 - 2005 Tensilica Inc.
- *
- * Chris Zankel <chris@zankel.net>
- */
-
-#if (DCACHE_SIZE > PAGE_SIZE)
-
-pte_t* pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
-{
-	pte_t *pte = NULL, *p;
-	int color = ADDR_COLOR(address);
-	int i;
-
-	p = (pte_t*) __get_free_pages(GFP_KERNEL|__GFP_REPEAT, COLOR_ORDER);
-
-	if (likely(p)) {
-		split_page(virt_to_page(p), COLOR_ORDER);
-
-		for (i = 0; i < COLOR_SIZE; i++) {
-			if (ADDR_COLOR(p) == color)
-				pte = p;
-			else
-				free_page(p);
-			p += PTRS_PER_PTE;
-		}
-		clear_page(pte);
-	}
-	return pte;
-}
-
-#ifdef PROFILING
-
-int mask;
-int hit;
-int flush;
-
-#endif
-
-struct page* pte_alloc_one(struct mm_struct *mm, unsigned long address)
-{
-	struct page *page = NULL, *p;
-	int color = ADDR_COLOR(address);
-
-	p = alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
-
-	if (likely(p)) {
-		split_page(p, COLOR_ORDER);
-
-		for (i = 0; i < PAGE_ORDER; i++) {
-			if (PADDR_COLOR(page_address(p)) == color)
-				page = p;
-			else
-				__free_page(p);
-			p++;
-		}
-		clear_highpage(page);
-	}
-
-	return page;
-}
-
-#endif
-
-
