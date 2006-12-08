From: akpm@osdl.org
Subject: - generic-ioremap_page_range-mips-conversion.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:12 -0800
Message-ID: <200612082006.kB8K6Cok002370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57656 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426336AbWLHUGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Generic ioremap_page_range: mips conversion
has been removed from the -mm tree.  Its filename was
     generic-ioremap_page_range-mips-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic ioremap_page_range: mips conversion
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Convert MIPS to use generic ioremap_page_range()

[yoichi_yuasa@tripeaks.co.jp: build fix]
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/mm/ioremap.c |   96 +++------------------------------------
 1 file changed, 8 insertions(+), 88 deletions(-)

diff -puN arch/mips/mm/ioremap.c~generic-ioremap_page_range-mips-conversion arch/mips/mm/ioremap.c
--- a/arch/mips/mm/ioremap.c~generic-ioremap_page_range-mips-conversion
+++ a/arch/mips/mm/ioremap.c
@@ -6,98 +6,13 @@
  * (C) Copyright 1995 1996 Linus Torvalds
  * (C) Copyright 2001, 2002 Ralf Baechle
  */
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <asm/addrspace.h>
 #include <asm/byteorder.h>
 
 #include <linux/vmalloc.h>
-#include <asm/cacheflush.h>
-#include <asm/io.h>
-#include <asm/tlbflush.h>
-
-static inline void remap_area_pte(pte_t * pte, unsigned long address,
-	phys_t size, phys_t phys_addr, unsigned long flags)
-{
-	phys_t end;
-	unsigned long pfn;
-	pgprot_t pgprot = __pgprot(_PAGE_GLOBAL | _PAGE_PRESENT | __READABLE
-	                           | __WRITEABLE | flags);
-
-	address &= ~PMD_MASK;
-	end = address + size;
-	if (end > PMD_SIZE)
-		end = PMD_SIZE;
-	if (address >= end)
-		BUG();
-	pfn = phys_addr >> PAGE_SHIFT;
-	do {
-		if (!pte_none(*pte)) {
-			printk("remap_area_pte: page already exists\n");
-			BUG();
-		}
-		set_pte(pte, pfn_pte(pfn, pgprot));
-		address += PAGE_SIZE;
-		pfn++;
-		pte++;
-	} while (address && (address < end));
-}
-
-static inline int remap_area_pmd(pmd_t * pmd, unsigned long address,
-	phys_t size, phys_t phys_addr, unsigned long flags)
-{
-	phys_t end;
-
-	address &= ~PGDIR_MASK;
-	end = address + size;
-	if (end > PGDIR_SIZE)
-		end = PGDIR_SIZE;
-	phys_addr -= address;
-	if (address >= end)
-		BUG();
-	do {
-		pte_t * pte = pte_alloc_kernel(pmd, address);
-		if (!pte)
-			return -ENOMEM;
-		remap_area_pte(pte, address, end - address, address + phys_addr, flags);
-		address = (address + PMD_SIZE) & PMD_MASK;
-		pmd++;
-	} while (address && (address < end));
-	return 0;
-}
-
-static int remap_area_pages(unsigned long address, phys_t phys_addr,
-	phys_t size, unsigned long flags)
-{
-	int error;
-	pgd_t * dir;
-	unsigned long end = address + size;
-
-	phys_addr -= address;
-	dir = pgd_offset(&init_mm, address);
-	flush_cache_all();
-	if (address >= end)
-		BUG();
-	do {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		error = -ENOMEM;
-		pud = pud_alloc(&init_mm, dir, address);
-		if (!pud)
-			break;
-		pmd = pmd_alloc(&init_mm, pud, address);
-		if (!pmd)
-			break;
-		if (remap_area_pmd(pmd, address, end - address,
-					 phys_addr + address, flags))
-			break;
-		error = 0;
-		address = (address + PGDIR_SIZE) & PGDIR_MASK;
-		dir++;
-	} while (address && (address < end));
-	flush_tlb_all();
-	return error;
-}
+#include <linux/io.h>
 
 /*
  * Generic mapping function (not visible outside):
@@ -121,6 +36,7 @@ void __iomem * __ioremap(phys_t phys_add
 	unsigned long offset;
 	phys_t last_addr;
 	void * addr;
+	pgprot_t pgprot;
 
 	phys_addr = fixup_bigphys_addr(phys_addr, size);
 
@@ -152,6 +68,9 @@ void __iomem * __ioremap(phys_t phys_add
 				return NULL;
 	}
 
+	pgprot = __pgprot(_PAGE_GLOBAL | _PAGE_PRESENT | __READABLE
+			  | __WRITEABLE | flags);
+
 	/*
 	 * Mappings have to be page-aligned
 	 */
@@ -166,7 +85,8 @@ void __iomem * __ioremap(phys_t phys_add
 	if (!area)
 		return NULL;
 	addr = area->addr;
-	if (remap_area_pages((unsigned long) addr, phys_addr, size, flags)) {
+	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
+			       phys_addr, pgprot)) {
 		vunmap(addr);
 		return NULL;
 	}
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
generic-ioremap_page_range-mips-conversion.patch
generic-ioremap_page_range-parisc-conversion.patch
generic-ioremap_page_range-s390-conversion.patch
generic-ioremap_page_range-sh-conversion.patch
generic-ioremap_page_range-sh64-conversion.patch
git-mtd.patch

