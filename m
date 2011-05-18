From: akpm@linux-foundation.org
Subject: [to-be-updated] vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch removed from -mm tree
Date: Wed, 18 May 2011 14:37:44 -0700
Message-ID: <201105182137.p4ILbiCF025459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36067 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab1ERVht (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     vmalloc: use apply_to_page_range_batch() for vunmap_page_range()
has been removed from the -mm tree.  Its filename was
     vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: use apply_to_page_range_batch() for vunmap_page_range()
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

There's no need to open-code it when there's helpful utility function to
do the job.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   53 ++++++++-----------------------------------------
 1 file changed, 9 insertions(+), 44 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range
+++ a/mm/vmalloc.c
@@ -33,59 +33,24 @@
 
 /*** Page table manipulation functions ***/
 
-static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end)
+static int vunmap_pte(pte_t *pte, unsigned count,
+		      unsigned long addr, void *data)
 {
-	pte_t *pte;
-
-	pte = pte_offset_kernel(pmd, addr);
-	do {
+	while (count--) {
 		pte_t ptent = *pte;
-		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
-		pte_clear(&init_mm, addr, pte);
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-}
-
-static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end)
-{
-	pmd_t *pmd;
-	unsigned long next;
 
-	pmd = pmd_offset(pud, addr);
-	do {
-		next = pmd_addr_end(addr, end);
-		if (pmd_none_or_clear_bad(pmd))
-			continue;
-		vunmap_pte_range(pmd, addr, next);
-	} while (pmd++, addr = next, addr != end);
-}
+		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
 
-static void vunmap_pud_range(pgd_t *pgd, unsigned long addr, unsigned long end)
-{
-	pud_t *pud;
-	unsigned long next;
+		pte_clear(&init_mm, addr, pte++);
+		addr += PAGE_SIZE;
+	}
 
-	pud = pud_offset(pgd, addr);
-	do {
-		next = pud_addr_end(addr, end);
-		if (pud_none_or_clear_bad(pud))
-			continue;
-		vunmap_pmd_range(pud, addr, next);
-	} while (pud++, addr = next, addr != end);
+	return 0;
 }
 
 static void vunmap_page_range(unsigned long addr, unsigned long end)
 {
-	pgd_t *pgd;
-	unsigned long next;
