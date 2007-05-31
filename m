From: akpm@linux-foundation.org
Subject: + x86_64-change-early_ioremap-to-static.patch added to -mm tree
Date: Thu, 31 May 2007 16:24:07 -0700
Message-ID: <200705312324.l4VNO7YT030591@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbXEaXYk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 19:24:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Yinghai.Lu@Sun.COM, ak@suse.de, yinghai.lu@Sun.COM


The patch titled
     x86_64: change early_ioremap to static
has been added to the -mm tree.  Its filename is
     x86_64-change-early_ioremap-to-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: change early_ioremap to static
From: Yinghai Lu <Yinghai.Lu@Sun.COM>

Only dmi_scan_machine==>dmi_present==>dmi_table==>dmi_ioremap uses
early_ioremap outside of mm/init.c dmi_scan_machine is called after
init_memory_mappings, and could use ioremap instead.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/init.c    |   63 ++++++++++++++++++-------------------
 include/asm-x86_64/dmi.h |    9 +----
 include/asm-x86_64/io.h  |    3 -
 3 files changed, 34 insertions(+), 41 deletions(-)

diff -puN arch/x86_64/mm/init.c~x86_64-change-early_ioremap-to-static arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-change-early_ioremap-to-static
+++ a/arch/x86_64/mm/init.c
@@ -174,37 +174,7 @@ __set_fixmap (enum fixed_addresses idx, 
 
 unsigned long __meminitdata table_start, table_end;
 
-static __meminit void *alloc_low_page(unsigned long *phys)
-{ 
-	unsigned long pfn = table_end++;
-	void *adr;
-
-	if (after_bootmem) {
-		adr = (void *)get_zeroed_page(GFP_ATOMIC);
-		*phys = __pa(adr);
-		return adr;
-	}
-
-	if (pfn >= end_pfn) 
-		panic("alloc_low_page: ran out of memory"); 
-
-	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
-	memset(adr, 0, PAGE_SIZE);
-	*phys  = pfn * PAGE_SIZE;
-	return adr;
-}
-
-static __meminit void unmap_low_page(void *adr)
-{ 
-
-	if (after_bootmem)
-		return;
-
-	early_iounmap(adr, PAGE_SIZE);
-} 
-
-/* Must run before zap_low_mappings */
-__meminit void *early_ioremap(unsigned long addr, unsigned long size)
+static __meminit void *early_ioremap(unsigned long addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd, *last_pmd;
@@ -233,7 +203,7 @@ __meminit void *early_ioremap(unsigned l
 }
 
 /* To avoid virtual aliases later */
-__meminit void early_iounmap(void *addr, unsigned long size)
+static __meminit void early_iounmap(void *addr, unsigned long size)
 {
 	unsigned long vaddr;
 	pmd_t *pmd;
@@ -247,6 +217,35 @@ __meminit void early_iounmap(void *addr,
 	__flush_tlb();
 }
 
+static __meminit void *alloc_low_page(unsigned long *phys)
+{
+	unsigned long pfn = table_end++;
+	void *adr;
+
+	if (after_bootmem) {
+		adr = (void *)get_zeroed_page(GFP_ATOMIC);
+		*phys = __pa(adr);
+		return adr;
+	}
+
+	if (pfn >= end_pfn)
+		panic("alloc_low_page: ran out of memory");
+
+	adr = early_ioremap(pfn * PAGE_SIZE, PAGE_SIZE);
+	memset(adr, 0, PAGE_SIZE);
+	*phys  = pfn * PAGE_SIZE;
+	return adr;
+}
+
+static __meminit void unmap_low_page(void *adr)
+{
+
+	if (after_bootmem)
+		return;
+
+	early_iounmap(adr, PAGE_SIZE);
+}
+
 static void __meminit
 phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end)
 {
diff -puN include/asm-x86_64/dmi.h~x86_64-change-early_ioremap-to-static include/asm-x86_64/dmi.h
--- a/include/asm-x86_64/dmi.h~x86_64-change-early_ioremap-to-static
+++ a/include/asm-x86_64/dmi.h
@@ -3,15 +3,12 @@
 
 #include <asm/io.h>
 
-extern void *dmi_ioremap(unsigned long addr, unsigned long size);
-extern void dmi_iounmap(void *addr, unsigned long size);
-
 #define DMI_MAX_DATA 2048
 
 extern int dmi_alloc_index;
 extern char dmi_alloc_data[DMI_MAX_DATA];
 
-/* This is so early that there is no good way to allocate dynamic memory. 
+/* This is so early that there is no good way to allocate dynamic memory.
    Allocate data in an BSS array. */
 static inline void *dmi_alloc(unsigned len)
 {
@@ -21,7 +18,7 @@ static inline void *dmi_alloc(unsigned l
 	return dmi_alloc_data + idx;
 }
 
-#define dmi_ioremap early_ioremap
-#define dmi_iounmap early_iounmap
+#define dmi_ioremap ioremap
+#define dmi_iounmap(x,l) iounmap(x)
 
 #endif
diff -puN include/asm-x86_64/io.h~x86_64-change-early_ioremap-to-static include/asm-x86_64/io.h
--- a/include/asm-x86_64/io.h~x86_64-change-early_ioremap-to-static
+++ a/include/asm-x86_64/io.h
@@ -134,9 +134,6 @@ static inline void __iomem * ioremap (un
 	return __ioremap(offset, size, 0);
 }
 
-extern void *early_ioremap(unsigned long addr, unsigned long size);
-extern void early_iounmap(void *addr, unsigned long size);
-
 /*
  * This one maps high address device memory and turns off caching for that area.
  * it's useful if some control registers are in such an area and write combining
_

Patches currently in -mm which might be from Yinghai.Lu@Sun.COM are

x86_64-change-early_ioremap-to-static.patch
