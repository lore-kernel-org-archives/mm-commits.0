From: akpm@osdl.org
Subject: - generic-ioremap_page_range-sh-conversion.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:18 -0800
Message-ID: <200612082006.kB8K6IWl002379@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57685 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426338AbWLHUG0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Generic ioremap_page_range: sh conversion
has been removed from the -mm tree.  Its filename was
     generic-ioremap_page_range-sh-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic ioremap_page_range: sh conversion
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Convert SH to use generic ioremap_page_range()

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sh/mm/ioremap.c |   90 +----------------------------------------
 1 file changed, 4 insertions(+), 86 deletions(-)

diff -puN arch/sh/mm/ioremap.c~generic-ioremap_page_range-sh-conversion arch/sh/mm/ioremap.c
--- a/arch/sh/mm/ioremap.c~generic-ioremap_page_range-sh-conversion
+++ a/arch/sh/mm/ioremap.c
@@ -16,97 +16,13 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pci.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/addrspace.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 
-static inline void remap_area_pte(pte_t * pte, unsigned long address,
-	unsigned long size, unsigned long phys_addr, unsigned long flags)
-{
-	unsigned long end;
-	unsigned long pfn;
-	pgprot_t pgprot = __pgprot(pgprot_val(PAGE_KERNEL_NOCACHE) | flags);
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
-	unsigned long size, unsigned long phys_addr, unsigned long flags)
-{
-	unsigned long end;
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
-int remap_area_pages(unsigned long address, unsigned long phys_addr,
-		     unsigned long size, unsigned long flags)
-{
-	int error;
-	pgd_t * dir;
-	unsigned long end = address + size;
-
-	phys_addr -= address;
-	dir = pgd_offset_k(address);
-	flush_cache_all();
-	if (address >= end)
-		BUG();
-	do {
-		pud_t *pud;
-		pmd_t *pmd;
-
-		error = -ENOMEM;
-
-		pud = pud_alloc(&init_mm, dir, address);
-		if (!pud)
-			break;
-		pmd = pmd_alloc(&init_mm, pud, address);
-		if (!pmd)
-			break;
-		if (remap_area_pmd(pmd, address, end - address,
-					phys_addr + address, flags))
-			break;
-		error = 0;
-		address = (address + PGDIR_SIZE) & PGDIR_MASK;
-		dir++;
-	} while (address && (address < end));
-	flush_tlb_all();
-	return error;
-}
-
 /*
  * Remap an arbitrary physical address space into the kernel virtual
  * address space. Needed when the kernel wants to access high addresses
@@ -121,6 +37,7 @@ void __iomem *__ioremap(unsigned long ph
 {
 	struct vm_struct * area;
 	unsigned long offset, last_addr, addr, orig_addr;
+	pgprot_t pgprot;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
@@ -190,8 +107,9 @@ void __iomem *__ioremap(unsigned long ph
 	}
 #endif
 
+	pgprot = __pgprot(pgprot_val(PAGE_KERNEL_NOCACHE) | flags);
 	if (likely(size))
-		if (remap_area_pages(addr, phys_addr, size, flags)) {
+		if (ioremap_page_range(addr, addr + size, phys_addr, pgprot)) {
 			vunmap((void *)orig_addr);
 			return NULL;
 		}
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
generic-ioremap_page_range-sh-conversion.patch
generic-ioremap_page_range-sh64-conversion.patch
git-mtd.patch

