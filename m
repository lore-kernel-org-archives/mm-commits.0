From: akpm@linux-foundation.org
Subject: + mm-implement-remap_pfn_range-with-apply_to_page_range.patch added to -mm tree
Date: Fri, 14 Nov 2008 16:25:54 -0800
Message-ID: <200811150025.mAF0PspB018901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbYKOA0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 19:26:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, hannes@cmpxchg.org, hugh@veritas.com, jeremy.fitzhardinge@citrix.com, nickpiggin@yahoo.com.au, venkatesh.pallipadi@intel.com


The patch titled
     mm: implement remap_pfn_range with apply_to_page_range
has been added to the -mm tree.  Its filename is
     mm-implement-remap_pfn_range-with-apply_to_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: implement remap_pfn_range with apply_to_page_range
From: Jeremy Fitzhardinge <jeremy@goop.org>

remap_pte_range() just wants to apply a function over a range of ptes
corresponding to a virtual address range.  That's exactly what
apply_to_page_range() does, so use it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   90 ++++++++++----------------------------------------
 1 file changed, 19 insertions(+), 71 deletions(-)

diff -puN mm/memory.c~mm-implement-remap_pfn_range-with-apply_to_page_range mm/memory.c
--- a/mm/memory.c~mm-implement-remap_pfn_range-with-apply_to_page_range
+++ a/mm/memory.c
@@ -1473,69 +1473,20 @@ int vm_insert_mixed(struct vm_area_struc
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 
-/*
- * maps a range of physical memory into the requested pages. the old
- * mappings are removed. any references to nonexistent pages results
- * in null mappings (currently treated as "copy-on-access")
- */
-static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
-			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
-{
-	pte_t *pte;
-	spinlock_t *ptl;
-
-	pte = pte_alloc_map_lock(mm, pmd, addr, &ptl);
-	if (!pte)
-		return -ENOMEM;
-	arch_enter_lazy_mmu_mode();
-	do {
-		BUG_ON(!pte_none(*pte));
-		set_pte_at(mm, addr, pte, pte_mkspecial(pfn_pte(pfn, prot)));
-		pfn++;
-	} while (pte++, addr += PAGE_SIZE, addr != end);
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(pte - 1, ptl);
-	return 0;
-}
+struct remap_data {
+	struct mm_struct *mm;
+	unsigned long pfn;
+	pgprot_t prot;
+};
 
-static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
-			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
+static int remap_area_pte_fn(pte_t *ptep, pgtable_t token,
+			     unsigned long addr, void *data)
 {
-	pmd_t *pmd;
-	unsigned long next;
-
-	pfn -= addr >> PAGE_SHIFT;
-	pmd = pmd_alloc(mm, pud, addr);
-	if (!pmd)
-		return -ENOMEM;
-	do {
-		next = pmd_addr_end(addr, end);
-		if (remap_pte_range(mm, pmd, addr, next,
-				pfn + (addr >> PAGE_SHIFT), prot))
-			return -ENOMEM;
-	} while (pmd++, addr = next, addr != end);
-	return 0;
-}
+	struct remap_data *rmd = data;
+	pte_t pte = pte_mkspecial(pfn_pte(rmd->pfn++, rmd->prot));
 
-static inline int remap_pud_range(struct mm_struct *mm, pgd_t *pgd,
-			unsigned long addr, unsigned long end,
-			unsigned long pfn, pgprot_t prot)
-{
-	pud_t *pud;
-	unsigned long next;
+	set_pte_at(rmd->mm, addr, ptep, pte);
 
-	pfn -= addr >> PAGE_SHIFT;
-	pud = pud_alloc(mm, pgd, addr);
-	if (!pud)
-		return -ENOMEM;
-	do {
-		next = pud_addr_end(addr, end);
-		if (remap_pmd_range(mm, pud, addr, next,
-				pfn + (addr >> PAGE_SHIFT), prot))
-			return -ENOMEM;
-	} while (pud++, addr = next, addr != end);
 	return 0;
 }
 
@@ -1552,10 +1503,9 @@ static inline int remap_pud_range(struct
 int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		    unsigned long pfn, unsigned long size, pgprot_t prot)
 {
-	pgd_t *pgd;
-	unsigned long next;
 	unsigned long end = addr + PAGE_ALIGN(size);
 	struct mm_struct *mm = vma->vm_mm;
+	struct remap_data rmd;
 	int err;
 
 	/*
@@ -1585,16 +1535,14 @@ int remap_pfn_range(struct vm_area_struc
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
 
 	BUG_ON(addr >= end);
-	pfn -= addr >> PAGE_SHIFT;
-	pgd = pgd_offset(mm, addr);
-	flush_cache_range(vma, addr, end);
-	do {
-		next = pgd_addr_end(addr, end);
-		err = remap_pud_range(mm, pgd, addr, next,
-				pfn + (addr >> PAGE_SHIFT), prot);
-		if (err)
-			break;
-	} while (pgd++, addr = next, addr != end);
+
+	rmd.mm = mm;
+	rmd.pfn = pfn;
+	rmd.prot = prot;
+
+	err = apply_to_page_range(mm, addr, end - addr,
+				  remap_area_pte_fn, &rmd);
+
 	return err;
 }
 EXPORT_SYMBOL(remap_pfn_range);
_

Patches currently in -mm which might be from jeremy@goop.org are

linux-next.patch
mm-implement-remap_pfn_range-with-apply_to_page_range.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remap_pfn_range-restore-missing-flush.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch

