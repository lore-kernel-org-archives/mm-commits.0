From: akpm@osdl.org
Subject: - generic-ioremap_page_range-sh64-conversion.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:20 -0800
Message-ID: <200612082006.kB8K6KqC002384@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57688 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426339AbWLHUG1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Generic ioremap_page_range: sh64 conversion
has been removed from the -mm tree.  Its filename was
     generic-ioremap_page_range-sh64-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic ioremap_page_range: sh64 conversion
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Convert SH64 to use generic ioremap_page_range()

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/sh64/mm/ioremap.c |  100 +++------------------------------------
 1 file changed, 8 insertions(+), 92 deletions(-)

diff -puN arch/sh64/mm/ioremap.c~generic-ioremap_page_range-sh64-conversion arch/sh64/mm/ioremap.c
--- a/arch/sh64/mm/ioremap.c~generic-ioremap_page_range-sh64-conversion
+++ a/arch/sh64/mm/ioremap.c
@@ -18,7 +18,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sched.h>
 #include <linux/string.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <linux/ioport.h>
@@ -28,96 +28,6 @@
 static void shmedia_mapioaddr(unsigned long, unsigned long);
 static unsigned long shmedia_ioremap(struct resource *, u32, int);
 
-static inline void remap_area_pte(pte_t * pte, unsigned long address, unsigned long size,
-	unsigned long phys_addr, unsigned long flags)
-{
-	unsigned long end;
-	unsigned long pfn;
-	pgprot_t pgprot = __pgprot(_PAGE_PRESENT  | _PAGE_READ   |
-				   _PAGE_WRITE    | _PAGE_DIRTY  |
-				   _PAGE_ACCESSED | _PAGE_SHARED | flags);
-
-	address &= ~PMD_MASK;
-	end = address + size;
-	if (end > PMD_SIZE)
-		end = PMD_SIZE;
-	if (address >= end)
-		BUG();
-
-	pfn = phys_addr >> PAGE_SHIFT;
-
-	pr_debug("    %s: pte %p address %lx size %lx phys_addr %lx\n",
-		 __FUNCTION__,pte,address,size,phys_addr);
-
-	do {
-		if (!pte_none(*pte)) {
-			printk("remap_area_pte: page already exists\n");
-			BUG();
-		}
-
-		set_pte(pte, pfn_pte(pfn, pgprot));
-		address += PAGE_SIZE;
-		pfn++;
-		pte++;
-	} while (address && (address < end));
-}
-
-static inline int remap_area_pmd(pmd_t * pmd, unsigned long address, unsigned long size,
-	unsigned long phys_addr, unsigned long flags)
-{
-	unsigned long end;
-
-	address &= ~PGDIR_MASK;
-	end = address + size;
-
-	if (end > PGDIR_SIZE)
-		end = PGDIR_SIZE;
-
-	phys_addr -= address;
-
-	if (address >= end)
-		BUG();
-
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
-static int remap_area_pages(unsigned long address, unsigned long phys_addr,
-				 unsigned long size, unsigned long flags)
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
-		pmd_t *pmd = pmd_alloc(&init_mm, dir, address);
-		error = -ENOMEM;
-		if (!pmd)
-			break;
-		if (remap_area_pmd(pmd, address, end - address,
-				   phys_addr + address, flags)) {
-			 break;
-		}
-		error = 0;
-		address = (address + PGDIR_SIZE) & PGDIR_MASK;
-		dir++;
-	} while (address && (address < end));
-	flush_tlb_all();
-	return 0;
-}
-
 /*
  * Generic mapping function (not visible outside):
  */
@@ -136,12 +46,17 @@ void * __ioremap(unsigned long phys_addr
 	void * addr;
 	struct vm_struct * area;
 	unsigned long offset, last_addr;
+	pgprot_t pgprot;
 
 	/* Don't allow wraparound or zero size */
 	last_addr = phys_addr + size - 1;
 	if (!size || last_addr < phys_addr)
 		return NULL;
 
+	pgprot = __pgprot(_PAGE_PRESENT  | _PAGE_READ   |
+			  _PAGE_WRITE    | _PAGE_DIRTY  |
+			  _PAGE_ACCESSED | _PAGE_SHARED | flags);
+
 	/*
 	 * Mappings have to be page-aligned
 	 */
@@ -158,7 +73,8 @@ void * __ioremap(unsigned long phys_addr
 		return NULL;
 	area->phys_addr = phys_addr;
 	addr = area->addr;
-	if (remap_area_pages((unsigned long)addr, phys_addr, size, flags)) {
+	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
+			       phys_addr, pgprot)) {
 		vunmap(addr);
 		return NULL;
 	}
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
generic-ioremap_page_range-sh64-conversion.patch
git-mtd.patch

