From: akpm@linux-foundation.org
Subject: + iommu-helper-use-bitmap-library.patch added to -mm tree
Date: Wed, 28 Oct 2009 13:14:26 -0700
Message-ID: <200910282014.n9SKEQ5U012718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbZJ1UOt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 16:14:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, benh@kernel.crashing.org, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, hpa@zytor.com, joerg.roedel@amd.com, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de


The patch titled
     iommu-helper: use bitmap library
has been added to the -mm tree.  Its filename is
     iommu-helper-use-bitmap-library.patch

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
Subject: iommu-helper: use bitmap library
From: Akinobu Mita <akinobu.mita@gmail.com>

Use bitmap library and kill some unused iommu helper functions.

1. s/iommu_area_free/bitmap_clear/

2. s/iommu_area_reserve/bitmap_set/

3. Use bitmap_find_next_zero_area instead of find_next_zero_area

  This cannot be simple substitution because find_next_zero_area
  doesn't check the last bit of the limit in bitmap

4. Remove iommu_area_free, iommu_area_reserve, and find_next_zero_area

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN arch/powerpc/kernel/iommu.c~iommu-helper-use-bitmap-library arch/powerpc/kernel/iommu.c
--- a/arch/powerpc/kernel/iommu.c~iommu-helper-use-bitmap-library
+++ a/arch/powerpc/kernel/iommu.c
@@ -30,7 +30,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/dma-mapping.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/iommu-helper.h>
 #include <linux/crash_dump.h>
 #include <asm/io.h>
@@ -251,7 +251,7 @@ static void __iommu_free(struct iommu_ta
 	}
 
 	ppc_md.tce_free(tbl, entry, npages);
-	iommu_area_free(tbl->it_map, free_entry, npages);
+	bitmap_clear(tbl->it_map, free_entry, npages);
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
diff -puN arch/sparc/kernel/iommu.c~iommu-helper-use-bitmap-library arch/sparc/kernel/iommu.c
--- a/arch/sparc/kernel/iommu.c~iommu-helper-use-bitmap-library
+++ a/arch/sparc/kernel/iommu.c
@@ -11,6 +11,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/iommu-helper.h>
+#include <linux/bitmap.h>
 
 #ifdef CONFIG_PCI
 #include <linux/pci.h>
@@ -169,7 +170,7 @@ void iommu_range_free(struct iommu *iomm
 
 	entry = (dma_addr - iommu->page_table_map_base) >> IO_PAGE_SHIFT;
 
-	iommu_area_free(arena->map, entry, npages);
+	bitmap_clear(arena->map, entry, npages);
 }
 
 int iommu_table_init(struct iommu *iommu, int tsbsize,
diff -puN arch/x86/kernel/amd_iommu.c~iommu-helper-use-bitmap-library arch/x86/kernel/amd_iommu.c
--- a/arch/x86/kernel/amd_iommu.c~iommu-helper-use-bitmap-library
+++ a/arch/x86/kernel/amd_iommu.c
@@ -19,7 +19,7 @@
 
 #include <linux/pci.h>
 #include <linux/gfp.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/debugfs.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
@@ -959,7 +959,7 @@ static void dma_ops_free_addresses(struc
 
 	address = (address % APERTURE_RANGE_SIZE) >> PAGE_SHIFT;
 
-	iommu_area_free(range->bitmap, address, pages);
+	bitmap_clear(range->bitmap, address, pages);
 
 }
 
diff -puN arch/x86/kernel/pci-calgary_64.c~iommu-helper-use-bitmap-library arch/x86/kernel/pci-calgary_64.c
--- a/arch/x86/kernel/pci-calgary_64.c~iommu-helper-use-bitmap-library
+++ a/arch/x86/kernel/pci-calgary_64.c
@@ -31,7 +31,7 @@
 #include <linux/string.h>
 #include <linux/crash_dump.h>
 #include <linux/dma-mapping.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/pci_ids.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
@@ -211,7 +211,7 @@ static void iommu_range_reserve(struct i
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	iommu_area_reserve(tbl->it_map, index, npages);
+	bitmap_set(tbl->it_map, index, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
@@ -305,7 +305,7 @@ static void iommu_free(struct iommu_tabl
 
 	spin_lock_irqsave(&tbl->it_lock, flags);
 
-	iommu_area_free(tbl->it_map, entry, npages);
+	bitmap_clear(tbl->it_map, entry, npages);
 
 	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
diff -puN arch/x86/kernel/pci-gart_64.c~iommu-helper-use-bitmap-library arch/x86/kernel/pci-gart_64.c
--- a/arch/x86/kernel/pci-gart_64.c~iommu-helper-use-bitmap-library
+++ a/arch/x86/kernel/pci-gart_64.c
@@ -23,7 +23,7 @@
 #include <linux/module.h>
 #include <linux/topology.h>
 #include <linux/interrupt.h>
-#include <linux/bitops.h>
+#include <linux/bitmap.h>
 #include <linux/kdebug.h>
 #include <linux/scatterlist.h>
 #include <linux/iommu-helper.h>
@@ -123,7 +123,7 @@ static void free_iommu(unsigned long off
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
-	iommu_area_free(iommu_gart_bitmap, offset, size);
+	bitmap_clear(iommu_gart_bitmap, offset, size);
 	if (offset >= next_bit)
 		next_bit = offset + size;
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
@@ -782,7 +782,7 @@ void __init gart_iommu_init(void)
 	 * Out of IOMMU space handling.
 	 * Reserve some invalid pages at the beginning of the GART.
 	 */
-	iommu_area_reserve(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
+	bitmap_set(iommu_gart_bitmap, 0, EMERGENCY_PAGES);
 
 	agp_memory_reserved = iommu_size;
 	printk(KERN_INFO
diff -puN include/linux/iommu-helper.h~iommu-helper-use-bitmap-library include/linux/iommu-helper.h
--- a/include/linux/iommu-helper.h~iommu-helper-use-bitmap-library
+++ a/include/linux/iommu-helper.h
@@ -14,14 +14,11 @@ static inline unsigned long iommu_device
 extern int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 				  unsigned long shift,
 				  unsigned long boundary_size);
-extern void iommu_area_reserve(unsigned long *map, unsigned long i, int len);
 extern unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 				      unsigned long start, unsigned int nr,
 				      unsigned long shift,
 				      unsigned long boundary_size,
 				      unsigned long align_mask);
-extern void iommu_area_free(unsigned long *map, unsigned long start,
-			    unsigned int nr);
 
 extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
 				     unsigned long io_page_size);
diff -puN lib/iommu-helper.c~iommu-helper-use-bitmap-library lib/iommu-helper.c
--- a/lib/iommu-helper.c~iommu-helper-use-bitmap-library
+++ a/lib/iommu-helper.c
@@ -3,41 +3,7 @@
  */
 
 #include <linux/module.h>
-#include <linux/bitops.h>
-
-static unsigned long find_next_zero_area(unsigned long *map,
-					 unsigned long size,
-					 unsigned long start,
-					 unsigned int nr,
-					 unsigned long align_mask)
-{
-	unsigned long index, end, i;
-again:
-	index = find_next_zero_bit(map, size, start);
-
-	/* Align allocation */
-	index = (index + align_mask) & ~align_mask;
-
-	end = index + nr;
-	if (end >= size)
-		return -1;
-	for (i = index; i < end; i++) {
-		if (test_bit(i, map)) {
-			start = i+1;
-			goto again;
-		}
-	}
-	return index;
-}
-
-void iommu_area_reserve(unsigned long *map, unsigned long i, int len)
-{
-	unsigned long end = i + len;
-	while (i < end) {
-		__set_bit(i, map);
-		i++;
-	}
-}
+#include <linux/bitmap.h>
 
 int iommu_is_span_boundary(unsigned int index, unsigned int nr,
 			   unsigned long shift,
@@ -55,31 +21,24 @@ unsigned long iommu_area_alloc(unsigned 
 			       unsigned long align_mask)
 {
 	unsigned long index;
+
+	/* We don't want the last of the limit */
+	size -= 1;
 again:
-	index = find_next_zero_area(map, size, start, nr, align_mask);
-	if (index != -1) {
+	index = bitmap_find_next_zero_area(map, size, start, nr, align_mask);
+	if (index < size) {
 		if (iommu_is_span_boundary(index, nr, shift, boundary_size)) {
 			/* we could do more effectively */
 			start = index + 1;
 			goto again;
 		}
-		iommu_area_reserve(map, index, nr);
+		bitmap_set(map, index, nr);
+		return index;
 	}
-	return index;
+	return -1;
 }
 EXPORT_SYMBOL(iommu_area_alloc);
 
-void iommu_area_free(unsigned long *map, unsigned long start, unsigned int nr)
-{
-	unsigned long end = start + nr;
-
-	while (start < end) {
-		__clear_bit(start, map);
-		start++;
-	}
-}
-EXPORT_SYMBOL(iommu_area_free);
