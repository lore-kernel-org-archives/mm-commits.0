From: akpm@osdl.org
Subject: - generic-ioremap_page_range-parisc-conversion.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:14 -0800
Message-ID: <200612082006.kB8K6Epn002373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426337AbWLHUGm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, kyle@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Generic ioremap_page_range: parisc conversion
has been removed from the -mm tree.  Its filename was
     generic-ioremap_page_range-parisc-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic ioremap_page_range: parisc conversion
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Convert parisc to use generic ioremap_page_range()

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Acked-by: Kyle McMartin <kyle@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/parisc/mm/ioremap.c |  111 ++-----------------------------------
 1 file changed, 7 insertions(+), 104 deletions(-)

diff -puN arch/parisc/mm/ioremap.c~generic-ioremap_page_range-parisc-conversion arch/parisc/mm/ioremap.c
--- a/arch/parisc/mm/ioremap.c~generic-ioremap_page_range-parisc-conversion
+++ a/arch/parisc/mm/ioremap.c
@@ -9,110 +9,8 @@
 #include <linux/vmalloc.h>
 #include <linux/errno.h>
 #include <linux/module.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/pgalloc.h>
-#include <asm/tlbflush.h>
-#include <asm/cacheflush.h>
-
-static inline void 
-remap_area_pte(pte_t *pte, unsigned long address, unsigned long size,
-	       unsigned long phys_addr, unsigned long flags)
-{
-	unsigned long end, pfn;
-	pgprot_t pgprot = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY |
-				   _PAGE_ACCESSED | flags);
-
-	address &= ~PMD_MASK;
-
-	end = address + size;
-	if (end > PMD_SIZE)
-		end = PMD_SIZE;
-
-	BUG_ON(address >= end);
-
-	pfn = phys_addr >> PAGE_SHIFT;
-	do {
-		BUG_ON(!pte_none(*pte));
-
-		set_pte(pte, pfn_pte(pfn, pgprot));
-
-		address += PAGE_SIZE;
-		pfn++;
-		pte++;
-	} while (address && (address < end));
-}
-
-static inline int 
-remap_area_pmd(pmd_t *pmd, unsigned long address, unsigned long size,
-	       unsigned long phys_addr, unsigned long flags)
-{
-	unsigned long end;
-
-	address &= ~PGDIR_MASK;
-
-	end = address + size;
-	if (end > PGDIR_SIZE)
-		end = PGDIR_SIZE;
-
-	BUG_ON(address >= end);
-
-	phys_addr -= address;
-	do {
-		pte_t *pte = pte_alloc_kernel(pmd, address);
-		if (!pte)
-			return -ENOMEM;
-
-		remap_area_pte(pte, address, end - address, 
-			       address + phys_addr, flags);
-
-		address = (address + PMD_SIZE) & PMD_MASK;
-		pmd++;
-	} while (address && (address < end));
-
-	return 0;
-}
-
-static int 
-remap_area_pages(unsigned long address, unsigned long phys_addr,
-		 unsigned long size, unsigned long flags)
-{
-	pgd_t *dir;
-	int error = 0;
-	unsigned long end = address + size;
-
-	BUG_ON(address >= end);
-
-	phys_addr -= address;
-	dir = pgd_offset_k(address);
-
-	flush_cache_all();
-
-	do {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		error = -ENOMEM;
-		pud = pud_alloc(&init_mm, dir, address);
-		if (!pud)
-			break;
-
-		pmd = pmd_alloc(&init_mm, pud, address);
-		if (!pmd)
-			break;
-
-		if (remap_area_pmd(pmd, address, end - address,
-				   phys_addr + address, flags))
-			break;
-
-		error = 0;
-		address = (address + PGDIR_SIZE) & PGDIR_MASK;
-		dir++;
-	} while (address && (address < end));
-
-	flush_tlb_all();
-
-	return error;
-}
 
 /*
  * Generic mapping function (not visible outside):
@@ -131,6 +29,7 @@ void __iomem * __ioremap(unsigned long p
 	void *addr;
 	struct vm_struct *area;
 	unsigned long offset, last_addr;
+	pgprot_t pgprot;
 
 #ifdef CONFIG_EISA
 	unsigned long end = phys_addr + size - 1;
@@ -164,6 +63,9 @@ void __iomem * __ioremap(unsigned long p
 		}
 	}
 
+	pgprot = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_DIRTY |
+			  _PAGE_ACCESSED | flags);
+
 	/*
 	 * Mappings have to be page-aligned
 	 */
@@ -179,7 +81,8 @@ void __iomem * __ioremap(unsigned long p
 		return NULL;
 
 	addr = area->addr;
-	if (remap_area_pages((unsigned long) addr, phys_addr, size, flags)) {
+	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
+			       phys_addr, pgprot)) {
 		vfree(addr);
 		return NULL;
 	}
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
generic-ioremap_page_range-parisc-conversion.patch
generic-ioremap_page_range-s390-conversion.patch
generic-ioremap_page_range-sh-conversion.patch
generic-ioremap_page_range-sh64-conversion.patch
git-mtd.patch

