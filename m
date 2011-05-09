From: akpm@linux-foundation.org
Subject: [to-be-updated] mm-remove-check_huge_range.patch removed from -mm tree
Date: Mon, 09 May 2011 13:07:41 -0700
Message-ID: <201105092007.p49K7fZW014935@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab1EIUHu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 16:07:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wilsons@start.ca, adobriyan@gmail.com, cl@linux-foundation.org, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove check_huge_range()
has been removed from the -mm tree.  Its filename was
     mm-remove-check_huge_range.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove check_huge_range()
From: Stephen Wilson <wilsons@start.ca>

This function has been superseded by gather_hugetbl_stats() and is no
longer needed.

Signed-off-by: Stephen Wilson <wilsons@start.ca>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   35 -----------------------------------
 1 file changed, 35 deletions(-)

diff -puN mm/mempolicy.c~mm-remove-check_huge_range mm/mempolicy.c
--- a/mm/mempolicy.c~mm-remove-check_huge_range
+++ a/mm/mempolicy.c
@@ -2587,35 +2587,6 @@ static int gather_pte_stats(pte_t *pte, 
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-static void check_huge_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end,
-		struct numa_maps *md)
-{
-	unsigned long addr;
-	struct page *page;
-	struct hstate *h = hstate_vma(vma);
-	unsigned long sz = huge_page_size(h);
-
-	for (addr = start; addr < end; addr += sz) {
-		pte_t *ptep = huge_pte_offset(vma->vm_mm,
-						addr & huge_page_mask(h));
-		pte_t pte;
-
-		if (!ptep)
-			continue;
-
-		pte = *ptep;
-		if (pte_none(pte))
-			continue;
-
-		page = pte_page(pte);
-		if (!page)
-			continue;
-
-		gather_stats(page, md, pte_dirty(*ptep));
-	}
-}
-
 static int gather_hugetbl_stats(pte_t *pte, unsigned long hmask,
 		unsigned long addr, unsigned long end, struct mm_walk *walk)
 {
@@ -2635,12 +2606,6 @@ static int gather_hugetbl_stats(pte_t *p
 }
 
 #else
-static inline void check_huge_range(struct vm_area_struct *vma,
-		unsigned long start, unsigned long end,
-		struct numa_maps *md)
-{
-}
