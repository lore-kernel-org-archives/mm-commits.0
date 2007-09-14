From: akpm@linux-foundation.org
Subject: + remove-dma_cache_wbackinvwback_inv-functions.patch added to -mm tree
Date: Fri, 14 Sep 2007 03:34:21 -0700
Message-ID: <200709141034.l8EAYL8A000680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbXINKfB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 06:35:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, davem@davemloft.net, hskinnemoen@atmel.com, kyle@parisc-linux.org, lethal@linux-sh.org, linux-arch@vger.kernel.org, paulus@samba.org


The patch titled
     Remove dma_cache_(wback|inv|wback_inv) functions
has been added to the -mm tree.  Its filename is
     remove-dma_cache_wbackinvwback_inv-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove dma_cache_(wback|inv|wback_inv) functions
From: Ralf Baechle <ralf@linux-mips.org>

dma_cache_(wback|inv|wback_inv) were the earliest attempt on a generalized
cache managment API for I/O purposes.  Originally it was basically the raw
MIPS low level cache API exported to the entire world.  The API has
suffered from a lack of documentation, was not very widely used unlike it's
more modern brothers and can easily be replaced by dma_cache_sync.  So
remove it rsp.  turn the surviving bits back into an arch private API, as
discussed on linux-arch.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Paul Mackerras <paulus@samba.org>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Kyle McMartin <kyle@parisc-linux.org>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/mm/dma-coherent.c        |    6 +--
 arch/mips/mm/cache.c                |    2 -
 arch/sh/drivers/pci/dma-dreamcast.c |    2 -
 arch/sh/mm/consistent.c             |    8 ++--
 arch/sh64/kernel/pci-dma.c          |    3 +
 include/asm-alpha/io.h              |    6 ---
 include/asm-avr32/io.h              |    7 ---
 include/asm-blackfin/io.h           |    4 --
 include/asm-h8300/io.h              |    6 ---
 include/asm-i386/io.h               |   11 -----
 include/asm-ia64/io.h               |    4 --
 include/asm-m68k/io.h               |    6 ---
 include/asm-m68knommu/io.h          |    6 ---
 include/asm-mips/io.h               |    2 +
 include/asm-parisc/io.h             |    5 --
 include/asm-powerpc/io.h            |   17 ---------
 include/asm-ppc/io.h                |   17 ---------
 include/asm-sh/floppy.h             |    2 -
 include/asm-sh/io.h                 |   25 -------------
 include/asm-sh64/dma-mapping.h      |    6 ++-
 include/asm-sh64/io.h               |   48 --------------------------
 include/asm-sparc/io.h              |    7 ---
 include/asm-sparc64/io.h            |    6 ---
 include/asm-x86_64/io.h             |    6 ---
 24 files changed, 19 insertions(+), 193 deletions(-)

diff -puN arch/avr32/mm/dma-coherent.c~remove-dma_cache_wbackinvwback_inv-functions arch/avr32/mm/dma-coherent.c
--- a/arch/avr32/mm/dma-coherent.c~remove-dma_cache_wbackinvwback_inv-functions
+++ a/arch/avr32/mm/dma-coherent.c
@@ -21,13 +21,13 @@ void dma_cache_sync(struct device *dev, 
 
 	switch (direction) {
 	case DMA_FROM_DEVICE:		/* invalidate only */
-		dma_cache_inv(vaddr, size);
+		invalidate_dcache_region(vaddr, size);
 		break;
 	case DMA_TO_DEVICE:		/* writeback only */
-		dma_cache_wback(vaddr, size);
+		clean_dcache_region(vaddr, size);
 		break;
 	case DMA_BIDIRECTIONAL:		/* writeback and invalidate */
-		dma_cache_wback_inv(vaddr, size);
+		flush_dcache_region(vaddr, size);
 		break;
 	default:
 		BUG();
diff -puN arch/mips/mm/cache.c~remove-dma_cache_wbackinvwback_inv-functions arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~remove-dma_cache_wbackinvwback_inv-functions
+++ a/arch/mips/mm/cache.c
@@ -46,8 +46,6 @@ void (*_dma_cache_wback)(unsigned long s
 void (*_dma_cache_inv)(unsigned long start, unsigned long size);
 
 EXPORT_SYMBOL(_dma_cache_wback_inv);
-EXPORT_SYMBOL(_dma_cache_wback);
-EXPORT_SYMBOL(_dma_cache_inv);
 
 #endif /* CONFIG_DMA_NONCOHERENT */
 
diff -puN arch/sh64/kernel/pci-dma.c~remove-dma_cache_wbackinvwback_inv-functions arch/sh64/kernel/pci-dma.c
--- a/arch/sh64/kernel/pci-dma.c~remove-dma_cache_wbackinvwback_inv-functions
+++ a/arch/sh64/kernel/pci-dma.c
@@ -8,6 +8,7 @@
  * Dynamic DMA mapping support.
  */
 #include <linux/types.h>
+#include <linux/dma-mapping.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/pci.h>
@@ -31,7 +32,7 @@ void *consistent_alloc(struct pci_dev *h
 	if (vp != NULL) {
 		memset(vp, 0, size);
 		*dma_handle = virt_to_phys(ret);
-		dma_cache_wback_inv((unsigned long)ret, size);
+		dma_cache_sync(NULL, ret, size, DMA_BIDIRECTIONAL);
 	}
 
 	return vp;
diff -puN arch/sh/drivers/pci/dma-dreamcast.c~remove-dma_cache_wbackinvwback_inv-functions arch/sh/drivers/pci/dma-dreamcast.c
--- a/arch/sh/drivers/pci/dma-dreamcast.c~remove-dma_cache_wbackinvwback_inv-functions
+++ a/arch/sh/drivers/pci/dma-dreamcast.c
@@ -51,7 +51,7 @@ void *dreamcast_consistent_alloc(struct 
 	buf = P2SEGADDR(buf);
 
 	/* Flush the dcache before we hand off the buffer */
-	dma_cache_wback_inv((void *)buf, size);
+	__flush_purge_region((void *)buf, size);
 
 	return (void *)buf;
 }
diff -puN arch/sh/mm/consistent.c~remove-dma_cache_wbackinvwback_inv-functions arch/sh/mm/consistent.c
--- a/arch/sh/mm/consistent.c~remove-dma_cache_wbackinvwback_inv-functions
+++ a/arch/sh/mm/consistent.c
@@ -34,7 +34,7 @@ void *consistent_alloc(gfp_t gfp, size_t
 	/*
 	 * We must flush the cache before we pass it on to the device
 	 */
-	dma_cache_wback_inv(ret, size);
+	__flush_purge_region(ret, size);
 
 	page = virt_to_page(ret);
 	free = page + (size >> PAGE_SHIFT);
@@ -68,13 +68,13 @@ void consistent_sync(void *vaddr, size_t
 
 	switch (direction) {
 	case DMA_FROM_DEVICE:		/* invalidate only */
-		dma_cache_inv(p1addr, size);
+		__flush_invalidate_region(p1addr, size);
 		break;
 	case DMA_TO_DEVICE:		/* writeback only */
-		dma_cache_wback(p1addr, size);
+		__flush_wback_region(p1addr, size);
 		break;
 	case DMA_BIDIRECTIONAL:		/* writeback and invalidate */
-		dma_cache_wback_inv(p1addr, size);
+		__flush_purge_region(p1addr, size);
 		break;
 	default:
 		BUG();
diff -puN include/asm-alpha/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-alpha/io.h
--- a/include/asm-alpha/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-alpha/io.h
@@ -551,12 +551,6 @@ extern void outsl (unsigned long port, c
 #endif
 #define RTC_ALWAYS_BCD	0
 
-/* Nothing to do */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
 /*
  * Some mucking forons use if[n]def writeq to check if platform has it.
  * It's a bloody bad idea and we probably want ARCH_HAS_WRITEQ for them
diff -puN include/asm-avr32/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-avr32/io.h
--- a/include/asm-avr32/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-avr32/io.h
@@ -298,13 +298,6 @@ extern void __iounmap(void __iomem *addr
 #define ioport_map(port, nr)	ioremap(port, nr)
 #define ioport_unmap(port)	iounmap(port)
 
-#define dma_cache_wback_inv(_start, _size)	\
-	flush_dcache_region(_start, _size)
-#define dma_cache_inv(_start, _size)		\
-	invalidate_dcache_region(_start, _size)
-#define dma_cache_wback(_start, _size)		\
-	clean_dcache_region(_start, _size)
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
diff -puN include/asm-blackfin/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-blackfin/io.h
--- a/include/asm-blackfin/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-blackfin/io.h
@@ -183,10 +183,6 @@ extern void blkfin_inv_cache_all(void);
 #define	ioport_map(port, nr)		((void __iomem*)(port))
 #define	ioport_unmap(addr)
 
-#define dma_cache_inv(_start,_size) do { blkfin_inv_cache_all();} while (0)
-#define dma_cache_wback(_start,_size) do { } while (0)
-#define dma_cache_wback_inv(_start,_size) do { blkfin_inv_cache_all();} while (0)
-
 /* Pages to physical address... */
 #define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
 #define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
diff -puN include/asm-h8300/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-h8300/io.h
--- a/include/asm-h8300/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-h8300/io.h
@@ -264,12 +264,6 @@ static inline void *ioremap_fullcache(un
 
 extern void iounmap(void *addr);
 
-/* Nothing to do */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
 /* H8/300 internal I/O functions */
 static __inline__ unsigned char ctrl_inb(unsigned long addr)
 {
diff -puN include/asm-i386/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-i386/io.h
--- a/include/asm-i386/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-i386/io.h
@@ -237,18 +237,9 @@ static inline void flush_write_buffers(v
 	__asm__ __volatile__ ("lock; addl $0,0(%%esp)": : :"memory");
 }
 
-#define dma_cache_inv(_start,_size)		flush_write_buffers()
-#define dma_cache_wback(_start,_size)		flush_write_buffers()
-#define dma_cache_wback_inv(_start,_size)	flush_write_buffers()
-
 #else
 
-/* Nothing to do */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-#define flush_write_buffers()
+#define flush_write_buffers() do { } while (0)
 
 #endif
 
diff -puN include/asm-ia64/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-ia64/io.h
--- a/include/asm-ia64/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-ia64/io.h
@@ -435,10 +435,6 @@ extern void memcpy_fromio(void *dst, con
 extern void memcpy_toio(volatile void __iomem *dst, const void *src, long n);
 extern void memset_io(volatile void __iomem *s, int c, long n);
 
-#define dma_cache_inv(_start,_size)             do { } while (0)
-#define dma_cache_wback(_start,_size)           do { } while (0)
-#define dma_cache_wback_inv(_start,_size)       do { } while (0)
-
 # endif /* __KERNEL__ */
 
 /*
diff -puN include/asm-m68k/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-m68k/io.h
--- a/include/asm-m68k/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-m68k/io.h
@@ -384,12 +384,6 @@ static inline void __iomem *ioremap_full
 	return __ioremap(physaddr, size, IOMAP_FULL_CACHING);
 }
 
-
-/* m68k caches aren't DMA coherent */
-extern void dma_cache_wback_inv(unsigned long start, unsigned long size);
-extern void dma_cache_wback(unsigned long start, unsigned long size);
-extern void dma_cache_inv(unsigned long start, unsigned long size);
-
 static inline void memset_io(volatile void __iomem *addr, unsigned char val, int count)
 {
 	__builtin_memset((void __force *) addr, val, count);
diff -puN include/asm-m68knommu/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-m68knommu/io.h
--- a/include/asm-m68knommu/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-m68knommu/io.h
@@ -165,12 +165,6 @@ static inline void *ioremap_fullcache(un
 
 extern void iounmap(void *addr);
 
-/* Nothing to do */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
 /* Pages to physical address... */
 #define page_to_phys(page)      ((page - mem_map) << PAGE_SHIFT)
 #define page_to_bus(page)       ((page - mem_map) << PAGE_SHIFT)
diff -puN include/asm-mips/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-mips/io.h
--- a/include/asm-mips/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-mips/io.h
@@ -554,6 +554,8 @@ static inline void memcpy_toio(volatile 
  *    caches.  Dirty lines of the caches may be written back or simply
  *    be discarded.  This operation is necessary before dma operations
  *    to the memory.
+ *
+ * This API used to be exported; it now is for arch code internal use only.
  */
 #ifdef CONFIG_DMA_NONCOHERENT
 
diff -puN include/asm-parisc/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-parisc/io.h
--- a/include/asm-parisc/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-parisc/io.h
@@ -270,11 +270,6 @@ extern void outsl (unsigned long port, c
 /* IO Port space is :      BBiiii   where BB is HBA number. */
 #define IO_SPACE_LIMIT 0x00ffffff
 
-
-#define dma_cache_inv(_start,_size)		do { flush_kernel_dcache_range(_start,_size); } while (0)
-#define dma_cache_wback(_start,_size)		do { flush_kernel_dcache_range(_start,_size); } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { flush_kernel_dcache_range(_start,_size); } while (0)
-
 /* PA machines have an MM I/O space from 0xf0000000-0xffffffff in 32
  * bit mode and from 0xfffffffff0000000-0xfffffffffffffff in 64 bit
  * mode (essentially just sign extending.  This macro takes in a 32
diff -puN include/asm-powerpc/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-powerpc/io.h
--- a/include/asm-powerpc/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-powerpc/io.h
@@ -498,23 +498,6 @@ static inline void name at					\
 #define writeq	writeq
 #endif
 
-#ifdef CONFIG_NOT_COHERENT_CACHE
-
-#define dma_cache_inv(_start,_size) \
-	invalidate_dcache_range(_start, (_start + _size))
-#define dma_cache_wback(_start,_size) \
-	clean_dcache_range(_start, (_start + _size))
-#define dma_cache_wback_inv(_start,_size) \
-	flush_dcache_range(_start, (_start + _size))
-
-#else /* CONFIG_NOT_COHERENT_CACHE */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
-#endif /* !CONFIG_NOT_COHERENT_CACHE */
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
diff -puN include/asm-ppc/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-ppc/io.h
--- a/include/asm-ppc/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-ppc/io.h
@@ -478,23 +478,6 @@ extern void pci_iounmap(struct pci_dev *
 #include <asm/mpc8260_pci9.h>
 #endif
 
-#ifdef CONFIG_NOT_COHERENT_CACHE
-
-#define dma_cache_inv(_start,_size) \
-	invalidate_dcache_range(_start, (_start + _size))
-#define dma_cache_wback(_start,_size) \
-	clean_dcache_range(_start, (_start + _size))
-#define dma_cache_wback_inv(_start,_size) \
-	flush_dcache_range(_start, (_start + _size))
-
-#else
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
-#endif
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
diff -puN include/asm-sh64/dma-mapping.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-sh64/dma-mapping.h
--- a/include/asm-sh64/dma-mapping.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-sh64/dma-mapping.h
@@ -42,7 +42,11 @@ static inline void dma_free_coherent(str
 static inline void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
 				  enum dma_data_direction dir)
 {
-	dma_cache_wback_inv((unsigned long)vaddr, size);
+	unsigned long s = (unsigned long) vaddr & L1_CACHE_ALIGN_MASK;
+	unsigned long e = (vaddr + size) & L1_CACHE_ALIGN_MASK;
+
+	for (; s <= e; s += L1_CACHE_BYTES)
+		asm volatile ("ocbp	%0, 0" : : "r" (s));
 }
 
 static inline dma_addr_t dma_map_single(struct device *dev,
diff -puN include/asm-sh64/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-sh64/io.h
--- a/include/asm-sh64/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-sh64/io.h
@@ -175,54 +175,6 @@ unsigned long onchip_remap(unsigned long
 extern void onchip_unmap(unsigned long vaddr);
 
 /*
- * The caches on some architectures aren't dma-coherent and have need to
- * handle this in software.  There are three types of operations that
- * can be applied to dma buffers.
- *
- *  - dma_cache_wback_inv(start, size) makes caches and RAM coherent by
- *    writing the content of the caches back to memory, if necessary.
- *    The function also invalidates the affected part of the caches as
- *    necessary before DMA transfers from outside to memory.
- *  - dma_cache_inv(start, size) invalidates the affected parts of the
- *    caches.  Dirty lines of the caches may be written back or simply
- *    be discarded.  This operation is necessary before dma operations
- *    to the memory.
- *  - dma_cache_wback(start, size) writes back any dirty lines but does
- *    not invalidate the cache.  This can be used before DMA reads from
- *    memory,
- */
-
-static __inline__ void dma_cache_wback_inv (unsigned long start, unsigned long size)
-{
-	unsigned long s = start & L1_CACHE_ALIGN_MASK;
-	unsigned long e = (start + size) & L1_CACHE_ALIGN_MASK;
-
-	for (; s <= e; s += L1_CACHE_BYTES)
-		asm volatile ("ocbp	%0, 0" : : "r" (s));
-}
-
-static __inline__ void dma_cache_inv (unsigned long start, unsigned long size)
-{
-	// Note that caller has to be careful with overzealous
-	// invalidation should there be partial cache lines at the extremities
-	// of the specified range
-	unsigned long s = start & L1_CACHE_ALIGN_MASK;
-	unsigned long e = (start + size) & L1_CACHE_ALIGN_MASK;
-
-	for (; s <= e; s += L1_CACHE_BYTES)
-		asm volatile ("ocbi	%0, 0" : : "r" (s));
-}
-
-static __inline__ void dma_cache_wback (unsigned long start, unsigned long size)
-{
-	unsigned long s = start & L1_CACHE_ALIGN_MASK;
-	unsigned long e = (start + size) & L1_CACHE_ALIGN_MASK;
-
-	for (; s <= e; s += L1_CACHE_BYTES)
-		asm volatile ("ocbwb	%0, 0" : : "r" (s));
-}
-
-/*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
  */
diff -puN include/asm-sh/floppy.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-sh/floppy.h
--- a/include/asm-sh/floppy.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-sh/floppy.h
@@ -213,7 +213,7 @@ static int hard_dma_setup(char *addr, un
 	}
 #endif
 
-	dma_cache_wback_inv(addr, size);
+	__flush_purge_region(addr, size);
 
 	/* actual, physical DMA */
 	doing_pdma = 0;
diff -puN include/asm-sh/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-sh/io.h
--- a/include/asm-sh/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-sh/io.h
@@ -327,31 +327,6 @@ __ioremap_mode(unsigned long offset, uns
 	__iounmap((addr))
 
 /*
- * The caches on some architectures aren't dma-coherent and have need to
- * handle this in software.  There are three types of operations that
- * can be applied to dma buffers.
- *
- *  - dma_cache_wback_inv(start, size) makes caches and RAM coherent by
- *    writing the content of the caches back to memory, if necessary.
- *    The function also invalidates the affected part of the caches as
- *    necessary before DMA transfers from outside to memory.
- *  - dma_cache_inv(start, size) invalidates the affected parts of the
- *    caches.  Dirty lines of the caches may be written back or simply
- *    be discarded.  This operation is necessary before dma operations
- *    to the memory.
- *  - dma_cache_wback(start, size) writes back any dirty lines but does
- *    not invalidate the cache.  This can be used before DMA reads from
- *    memory,
- */
-
-#define dma_cache_wback_inv(_start,_size) \
-    __flush_purge_region(_start,_size)
-#define dma_cache_inv(_start,_size) \
-    __flush_invalidate_region(_start,_size)
-#define dma_cache_wback(_start,_size) \
-    __flush_wback_region(_start,_size)
-
-/*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
  */
diff -puN include/asm-sparc64/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-sparc64/io.h
--- a/include/asm-sparc64/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-sparc64/io.h
@@ -474,12 +474,6 @@ extern void pci_iounmap(struct pci_dev *
 #define sbus_iounmap(__addr, __size)	\
 	release_region((unsigned long)(__addr), (__size))
 
-/* Nothing to do */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
 /*
  * Convert a physical pointer to a virtual kernel pointer for /dev/mem
  * access
diff -puN include/asm-sparc/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-sparc/io.h
--- a/include/asm-sparc/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-sparc/io.h
@@ -310,13 +310,6 @@ extern void sbus_iounmap(volatile void _
 #define RTC_PORT(x)   (rtc_port + (x))
 #define RTC_ALWAYS_BCD  0
 
-/* Nothing to do */
-/* P3: Only IDE DMA may need these. XXX Verify that it still does... */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
 #endif
 
 #define __ARCH_HAS_NO_PAGE_ZERO_MAPPED		1
diff -puN include/asm-x86_64/io.h~remove-dma_cache_wbackinvwback_inv-functions include/asm-x86_64/io.h
--- a/include/asm-x86_64/io.h~remove-dma_cache_wbackinvwback_inv-functions
+++ a/include/asm-x86_64/io.h
@@ -249,12 +249,6 @@ void memset_io(volatile void __iomem *a,
  */
 #define __ISA_IO_base ((char __iomem *)(PAGE_OFFSET))
 
-/* Nothing to do */
-
-#define dma_cache_inv(_start,_size)		do { } while (0)
-#define dma_cache_wback(_start,_size)		do { } while (0)
-#define dma_cache_wback_inv(_start,_size)	do { } while (0)
-
 #define flush_write_buffers() 
 
 extern int iommu_bio_merge;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

bcm1480-serial-build-fix.patch
git-input.patch
git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-add-gpio-support-to-the-bcm947xx-platform-update.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
mips-move-platform-independent-cfe-code-into-arch-mips-cfe.patch
mips-add-cfe-support-to-bcm947xx-code.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-netdev-all.patch
remove-setup-of-platform-device-from-jazzsonicc.patch
sgiseeq-replace-use-of-dma_cache_wback_inv.patch
sb1250-macc-de-typedef-de-volatile-de-etc.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
