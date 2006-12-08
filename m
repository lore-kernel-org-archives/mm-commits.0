From: akpm@osdl.org
Subject: - generic-ioremap_page_range-s390-conversion.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:06:16 -0800
Message-ID: <200612082006.kB8K6GQP002376@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57748 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426347AbWLHUGt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:06:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Generic ioremap_page_range: s390 conversion
has been removed from the -mm tree.  Its filename was
     generic-ioremap_page_range-s390-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Generic ioremap_page_range: s390 conversion
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

Convert S390 to use generic ioremap_page_range()

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/s390/mm/ioremap.c |   84 +--------------------------------------
 1 file changed, 3 insertions(+), 81 deletions(-)

diff -puN arch/s390/mm/ioremap.c~generic-ioremap_page_range-s390-conversion arch/s390/mm/ioremap.c
--- a/arch/s390/mm/ioremap.c~generic-ioremap_page_range-s390-conversion
+++ a/arch/s390/mm/ioremap.c
@@ -15,87 +15,8 @@
 
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
-#include <asm/io.h>
+#include <linux/io.h>
 #include <asm/pgalloc.h>
-#include <asm/cacheflush.h>
-#include <asm/tlbflush.h>
-
-static inline void remap_area_pte(pte_t * pte, unsigned long address, unsigned long size,
-        unsigned long phys_addr, unsigned long flags)
-{
-        unsigned long end;
-        unsigned long pfn;
-
-        address &= ~PMD_MASK;
-        end = address + size;
-        if (end > PMD_SIZE)
-                end = PMD_SIZE;
-	if (address >= end)
-		BUG();
-        pfn = phys_addr >> PAGE_SHIFT;
-        do {
-                if (!pte_none(*pte)) {
-                        printk("remap_area_pte: page already exists\n");
-			BUG();
-		}
-                set_pte(pte, pfn_pte(pfn, __pgprot(flags)));
-                address += PAGE_SIZE;
-                pfn++;
-                pte++;
-        } while (address && (address < end));
-}
-
-static inline int remap_area_pmd(pmd_t * pmd, unsigned long address, unsigned long size,
-        unsigned long phys_addr, unsigned long flags)
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
-static int remap_area_pages(unsigned long address, unsigned long phys_addr,
-				 unsigned long size, unsigned long flags)
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
-		pmd_t *pmd;
-		pmd = pmd_alloc(&init_mm, dir, address);
-		error = -ENOMEM;
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
-	return 0;
-}
 
 /*
  * Generic mapping function (not visible outside):
@@ -122,7 +43,8 @@ void * __ioremap(unsigned long phys_addr
 	if (!area)
 		return NULL;
 	addr = area->addr;
-	if (remap_area_pages((unsigned long) addr, phys_addr, size, flags)) {
+	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
+			       phys_addr, __pgprot(flags))) {
 		vfree(addr);
 		return NULL;
 	}
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
generic-ioremap_page_range-s390-conversion.patch
generic-ioremap_page_range-sh-conversion.patch
generic-ioremap_page_range-sh64-conversion.patch
git-mtd.patch

