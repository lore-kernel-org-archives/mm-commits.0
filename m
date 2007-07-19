From: akpm@linux-foundation.org
Subject: + m68knommu-remove-is_in_rom-function.patch added to -mm tree
Date: Wed, 18 Jul 2007 17:08:31 -0700
Message-ID: <200707190008.l6J08VFW004171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762758AbXGSAJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: remove is_in_rom() function
has been added to the -mm tree.  Its filename is
     m68knommu-remove-is_in_rom-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: remove is_in_rom() function
From: Greg Ungerer <gerg@snapgear.com>

Remove is_in_rom() function.  It doesn't actually serve the purpose it was
intended to.  If you look at the use of it _access_ok() (which is the only use
of it) then it is obvious that most of memory is marked as access_ok.  No
point having is_in_rom() then, so remove it.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/m68k_ksyms.c |    2 --
 arch/m68knommu/mm/memory.c         |   20 --------------------
 include/asm-m68knommu/pgtable.h    |    1 -
 include/asm-m68knommu/uaccess.h    |   11 +++++++----
 4 files changed, 7 insertions(+), 27 deletions(-)

diff -puN arch/m68knommu/kernel/m68k_ksyms.c~m68knommu-remove-is_in_rom-function arch/m68knommu/kernel/m68k_ksyms.c
--- a/arch/m68knommu/kernel/m68k_ksyms.c~m68knommu-remove-is_in_rom-function
+++ a/arch/m68knommu/kernel/m68k_ksyms.c
@@ -81,8 +81,6 @@ EXPORT_SYMBOL(__mulsi3);
 EXPORT_SYMBOL(__udivsi3);
 EXPORT_SYMBOL(__umodsi3);
 
-EXPORT_SYMBOL(is_in_rom);
-
 #ifdef CONFIG_COLDFIRE
 extern unsigned int *dma_device_address;
 extern unsigned long dma_base_addr, _ramend;
diff -puN arch/m68knommu/mm/memory.c~m68knommu-remove-is_in_rom-function arch/m68knommu/mm/memory.c
--- a/arch/m68knommu/mm/memory.c~m68knommu-remove-is_in_rom-function
+++ a/arch/m68knommu/mm/memory.c
@@ -33,23 +33,3 @@ unsigned long kernel_map(unsigned long p
 	return paddr;
 }
 
-
-int is_in_rom(unsigned long addr)
-{
-	extern unsigned long _ramstart, _ramend;
-
-	/*
-	 *	What we are really trying to do is determine if addr is
-	 *	in an allocated kernel memory region. If not then assume
-	 *	we cannot free it or otherwise de-allocate it. Ideally
-	 *	we could restrict this to really being in a ROM or flash,
-	 *	but that would need to be done on a board by board basis,
-	 *	not globally.
-	 */
-	if ((addr < _ramstart) || (addr >= _ramend))
-		return(1);
-
-	/* Default case, not in ROM */
-	return(0);
-}
-
diff -puN include/asm-m68knommu/pgtable.h~m68knommu-remove-is_in_rom-function include/asm-m68knommu/pgtable.h
--- a/include/asm-m68knommu/pgtable.h~m68knommu-remove-is_in_rom-function
+++ a/include/asm-m68knommu/pgtable.h
@@ -49,7 +49,6 @@ static inline int pte_file(pte_t pte) { 
  * These would be in other places but having them here reduces the diffs.
  */
 extern unsigned int kobjsize(const void *objp);
-extern int is_in_rom(unsigned long);
 
 /*
  * No page table caches to initialise.
diff -puN include/asm-m68knommu/uaccess.h~m68knommu-remove-is_in_rom-function include/asm-m68knommu/uaccess.h
--- a/include/asm-m68knommu/uaccess.h~m68knommu-remove-is_in_rom-function
+++ a/include/asm-m68knommu/uaccess.h
@@ -15,12 +15,15 @@
 
 #define access_ok(type,addr,size)	_access_ok((unsigned long)(addr),(size))
 
+/*
+ * It is not enough to just have access_ok check for a real RAM address.
+ * This would disallow the case of code/ro-data running XIP in flash/rom.
+ * Ideally we would check the possible flash ranges too, but that is
+ * currently not so easy.
+ */
 static inline int _access_ok(unsigned long addr, unsigned long size)
 {
-	extern unsigned long memory_start, memory_end;
-
-	return (((addr >= memory_start) && (addr+size < memory_end)) ||
-		(is_in_rom(addr) && is_in_rom(addr+size)));
+	return 1;
 }
 
 /*
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
git-mtd.patch
m68knommu-generic-irq-handling.patch
m68knommu-start-dump-from-exception-stack.patch
m68knommu-remove-is_in_rom-function.patch
