From: akpm@linux-foundation.org
Subject: + page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch added to -mm tree
Date: Mon, 30 Jun 2008 15:33:47 -0700
Message-ID: <200806302233.m5UMXliA029045@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761471AbYF3WeU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jun 2008 18:34:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: righi.andrea@gmail.com, linux-arch@vger.kernel.org


The patch titled
     PAGE_ALIGN(): correctly handle 64-bit values on 32-bit architectures
has been added to the -mm tree.  Its filename is
     page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: PAGE_ALIGN(): correctly handle 64-bit values on 32-bit architectures
From: Andrea Righi <righi.andrea@gmail.com>

On 32-bit architectures PAGE_ALIGN() truncates 64-bit values to the 32-bit
boundary. For example:

	u64 val = PAGE_ALIGN(size);

always returns a value < 4GB even if size is greater than 4GB.

The problem resides in PAGE_MASK definition (from include/asm-x86/page.h for
example):

#define PAGE_SHIFT      12
#define PAGE_SIZE       (_AC(1,UL) << PAGE_SHIFT)
#define PAGE_MASK       (~(PAGE_SIZE-1))
...
#define PAGE_ALIGN(addr)       (((addr)+PAGE_SIZE-1)&PAGE_MASK)

The "~" is performed on a 32-bit value, so everything in "and" with
PAGE_MASK greater than 4GB will be truncated to the 32-bit boundary. 
Using the ALIGN() macro seems to be the right way, because it uses
typeof(addr) for the mask.

Also move the PAGE_ALIGN() definitions out of include/asm-*/page.h in
include/linux/mm.h.

See also lkml discussion: http://lkml.org/lkml/2008/6/11/237

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/boot/page.h                     |    3 ---
 arch/sparc64/kernel/iommu_common.h           |    2 +-
 drivers/char/random.c                        |    1 +
 drivers/media/video/pvrusb2/pvrusb2-ioread.c |    1 +
 drivers/media/video/videobuf-core.c          |    1 +
 drivers/pci/intel-iommu.h                    |    2 +-
 include/asm-alpha/page.h                     |    3 ---
 include/asm-arm/page-nommu.h                 |    4 +---
 include/asm-arm/page.h                       |    3 ---
 include/asm-avr32/page.h                     |    3 ---
 include/asm-blackfin/page.h                  |    3 ---
 include/asm-cris/page.h                      |    3 ---
 include/asm-frv/page.h                       |    3 ---
 include/asm-h8300/page.h                     |    3 ---
 include/asm-ia64/page.h                      |    1 -
 include/asm-m32r/page.h                      |    3 ---
 include/asm-m68k/dvma.h                      |    2 +-
 include/asm-m68k/page.h                      |    3 ---
 include/asm-m68knommu/page.h                 |    3 ---
 include/asm-mips/page.h                      |    3 ---
 include/asm-mn10300/page.h                   |    3 ---
 include/asm-parisc/page.h                    |    4 ----
 include/asm-powerpc/page.h                   |    3 ---
 include/asm-s390/page.h                      |    3 ---
 include/asm-sh/page.h                        |    3 ---
 include/asm-sparc/page.h                     |    3 ---
 include/asm-sparc64/page.h                   |    3 ---
 include/asm-um/page.h                        |    3 ---
 include/asm-x86/page.h                       |    3 ---
 include/asm-xtensa/page.h                    |    2 --
 include/linux/mm.h                           |    3 +++
 sound/core/info.c                            |    1 +
 32 files changed, 11 insertions(+), 73 deletions(-)

diff -puN arch/powerpc/boot/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures arch/powerpc/boot/page.h
--- a/arch/powerpc/boot/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/arch/powerpc/boot/page.h
@@ -28,7 +28,4 @@
 /* align addr on a size boundary - adjust address up if needed */
 #define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	_ALIGN(addr, PAGE_SIZE)
-
 #endif				/* _PPC_BOOT_PAGE_H */
diff -puN arch/sparc64/kernel/iommu_common.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures arch/sparc64/kernel/iommu_common.h
--- a/arch/sparc64/kernel/iommu_common.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/arch/sparc64/kernel/iommu_common.h
@@ -23,7 +23,7 @@
 #define IO_PAGE_SHIFT			13
 #define IO_PAGE_SIZE			(1UL << IO_PAGE_SHIFT)
 #define IO_PAGE_MASK			(~(IO_PAGE_SIZE-1))
-#define IO_PAGE_ALIGN(addr)		(((addr)+IO_PAGE_SIZE-1)&IO_PAGE_MASK)
+#define IO_PAGE_ALIGN(addr)		ALIGN(addr, IO_PAGE_SIZE)
 
 #define IO_TSB_ENTRIES			(128*1024)
 #define IO_TSB_SIZE			(IO_TSB_ENTRIES * 8)
diff -puN drivers/char/random.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures drivers/char/random.c
--- a/drivers/char/random.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/drivers/char/random.c
@@ -236,6 +236,7 @@
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/interrupt.h>
+#include <linux/mm.h>
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
 #include <linux/cryptohash.h>
diff -puN drivers/media/video/pvrusb2/pvrusb2-ioread.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures drivers/media/video/pvrusb2/pvrusb2-ioread.c
--- a/drivers/media/video/pvrusb2/pvrusb2-ioread.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/drivers/media/video/pvrusb2/pvrusb2-ioread.c
@@ -22,6 +22,7 @@
 #include "pvrusb2-debug.h"
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
diff -puN drivers/media/video/videobuf-core.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures drivers/media/video/videobuf-core.c
--- a/drivers/media/video/videobuf-core.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/drivers/media/video/videobuf-core.c
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 
diff -puN drivers/pci/intel-iommu.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures drivers/pci/intel-iommu.h
--- a/drivers/pci/intel-iommu.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/drivers/pci/intel-iommu.h
@@ -35,7 +35,7 @@
 #define PAGE_SHIFT_4K		(12)
 #define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
 #define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
-#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
+#define PAGE_ALIGN_4K(addr)	ALIGN(addr, PAGE_SIZE_4K)
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
 #define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
diff -puN include/asm-alpha/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-alpha/page.h
--- a/include/asm-alpha/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-alpha/page.h
@@ -80,9 +80,6 @@ typedef struct page *pgtable_t;
 
 #endif /* !__ASSEMBLY__ */
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #define __pa(x)			((unsigned long) (x) - PAGE_OFFSET)
 #define __va(x)			((void *)((unsigned long) (x) + PAGE_OFFSET))
 #ifndef CONFIG_DISCONTIGMEM
diff -puN include/asm-arm/page-nommu.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-arm/page-nommu.h
--- a/include/asm-arm/page-nommu.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-arm/page-nommu.h
@@ -7,6 +7,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
 #ifndef _ASMARM_PAGE_NOMMU_H
 #define _ASMARM_PAGE_NOMMU_H
 
@@ -42,9 +43,6 @@ typedef unsigned long pgprot_t;
 #define __pmd(x)        (x)
 #define __pgprot(x)     (x)
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
diff -puN include/asm-arm/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-arm/page.h
--- a/include/asm-arm/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-arm/page.h
@@ -15,9 +15,6 @@
 #define PAGE_SIZE		(1UL << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #ifndef __ASSEMBLY__
 
 #ifndef CONFIG_MMU
diff -puN include/asm-avr32/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-avr32/page.h
--- a/include/asm-avr32/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-avr32/page.h
@@ -57,9 +57,6 @@ static inline int get_order(unsigned lon
 
 #endif /* !__ASSEMBLY__ */
 
-/* Align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
-
 /*
  * The hardware maps the virtual addresses 0x80000000 -> 0x9fffffff
  * permanently to the physical addresses 0x00000000 -> 0x1fffffff when
diff -puN include/asm-blackfin/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-blackfin/page.h
--- a/include/asm-blackfin/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-blackfin/page.h
@@ -51,9 +51,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x)	((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
diff -puN include/asm-cris/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-cris/page.h
--- a/include/asm-cris/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-cris/page.h
@@ -60,9 +60,6 @@ typedef struct page *pgtable_t;
 
 #define page_to_phys(page)     __pa((((page) - mem_map) << PAGE_SHIFT) + PAGE_OFFSET)
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #ifndef __ASSEMBLY__
 
 #endif /* __ASSEMBLY__ */
diff -puN include/asm-frv/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-frv/page.h
--- a/include/asm-frv/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-frv/page.h
@@ -40,9 +40,6 @@ typedef struct page *pgtable_t;
 #define __pgprot(x)	((pgprot_t) { (x) } )
 #define PTE_MASK	PAGE_MASK
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
-
 #define devmem_is_allowed(pfn)	1
 
 #define __pa(vaddr)		virt_to_phys((void *) (unsigned long) (vaddr))
diff -puN include/asm-h8300/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-h8300/page.h
--- a/include/asm-h8300/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-h8300/page.h
@@ -43,9 +43,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x)	((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
diff -puN include/asm-ia64/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-ia64/page.h
--- a/include/asm-ia64/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-ia64/page.h
@@ -40,7 +40,6 @@
 
 #define PAGE_SIZE		(__IA64_UL_CONST(1) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE - 1))
-#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
 
 #define PERCPU_PAGE_SHIFT	16	/* log2() of max. size of per-CPU area */
 #define PERCPU_PAGE_SIZE	(__IA64_UL_CONST(1) << PERCPU_PAGE_SHIFT)
diff -puN include/asm-m32r/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-m32r/page.h
--- a/include/asm-m32r/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-m32r/page.h
@@ -41,9 +41,6 @@ typedef struct page *pgtable_t;
 
 #endif /* !__ASSEMBLY__ */
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
-
 /*
  * This handles the memory map.. We could make this a config
  * option, but too many people screw it up, and too few need
diff -puN include/asm-m68k/dvma.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-m68k/dvma.h
--- a/include/asm-m68k/dvma.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-m68k/dvma.h
@@ -13,7 +13,7 @@
 #define DVMA_PAGE_SHIFT	13
 #define DVMA_PAGE_SIZE	(1UL << DVMA_PAGE_SHIFT)
 #define DVMA_PAGE_MASK	(~(DVMA_PAGE_SIZE-1))
-#define DVMA_PAGE_ALIGN(addr)	(((addr)+DVMA_PAGE_SIZE-1)&DVMA_PAGE_MASK)
+#define DVMA_PAGE_ALIGN(addr)	ALIGN(addr, DVMA_PAGE_SIZE)
 
 extern void dvma_init(void);
 extern int dvma_map_iommu(unsigned long kaddr, unsigned long baddr,
diff -puN include/asm-m68k/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-m68k/page.h
--- a/include/asm-m68k/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-m68k/page.h
@@ -103,9 +103,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x)	((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #endif /* !__ASSEMBLY__ */
 
 #include <asm/page_offset.h>
diff -puN include/asm-m68knommu/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-m68knommu/page.h
--- a/include/asm-m68knommu/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-m68knommu/page.h
@@ -43,9 +43,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x)	((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 extern unsigned long memory_start;
 extern unsigned long memory_end;
 
diff -puN include/asm-mips/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-mips/page.h
--- a/include/asm-mips/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-mips/page.h
@@ -134,9 +134,6 @@ typedef struct { unsigned long pgprot; }
 
 #endif /* !__ASSEMBLY__ */
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
-
 /*
  * __pa()/__va() should be used only during mem init.
  */
diff -puN include/asm-mn10300/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-mn10300/page.h
--- a/include/asm-mn10300/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-mn10300/page.h
@@ -61,9 +61,6 @@ typedef struct page *pgtable_t;
 
 #endif /* !__ASSEMBLY__ */
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr) + PAGE_SIZE - 1) & PAGE_MASK)
-
 /*
  * This handles the memory map.. We could make this a config
  * option, but too many people screw it up, and too few need
diff -puN include/asm-parisc/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-parisc/page.h
--- a/include/asm-parisc/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-parisc/page.h
@@ -119,10 +119,6 @@ extern int npmem_ranges;
 #define PMD_ENTRY_SIZE	(1UL << BITS_PER_PMD_ENTRY)
 #define PTE_ENTRY_SIZE	(1UL << BITS_PER_PTE_ENTRY)
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
-
 #define LINUX_GATEWAY_SPACE     0
 
 /* This governs the relationship between virtual and physical addresses.
diff -puN include/asm-powerpc/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-powerpc/page.h
--- a/include/asm-powerpc/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-powerpc/page.h
@@ -119,9 +119,6 @@ extern phys_addr_t kernstart_addr;
 /* align addr on a size boundary - adjust address up if needed */
 #define _ALIGN(addr,size)     _ALIGN_UP(addr,size)
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	_ALIGN(addr, PAGE_SIZE)
-
 /*
  * Don't compare things with KERNELBASE or PAGE_OFFSET to test for
  * "kernelness", use is_kernel_addr() - it should do what you want.
diff -puN include/asm-s390/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-s390/page.h
--- a/include/asm-s390/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-s390/page.h
@@ -138,9 +138,6 @@ void arch_alloc_page(struct page *page, 
 
 #endif /* !__ASSEMBLY__ */
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)        (((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #define __PAGE_OFFSET           0x0UL
 #define PAGE_OFFSET             0x0UL
 #define __pa(x)                 (unsigned long)(x)
diff -puN include/asm-sh/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-sh/page.h
--- a/include/asm-sh/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-sh/page.h
@@ -24,9 +24,6 @@
 #define PAGE_MASK	(~(PAGE_SIZE-1))
 #define PTE_MASK	PAGE_MASK
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #if defined(CONFIG_HUGETLB_PAGE_SIZE_64K)
 #define HPAGE_SHIFT	16
 #elif defined(CONFIG_HUGETLB_PAGE_SIZE_256K)
diff -puN include/asm-sparc/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-sparc/page.h
--- a/include/asm-sparc/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-sparc/page.h
@@ -131,9 +131,6 @@ BTFIXUPDEF_SETHI(sparc_unmapped_base)
 
 #endif /* !(__ASSEMBLY__) */
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)  (((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #define PAGE_OFFSET	0xf0000000
 #ifndef __ASSEMBLY__
 extern unsigned long phys_base;
diff -puN include/asm-sparc64/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-sparc64/page.h
--- a/include/asm-sparc64/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-sparc64/page.h
@@ -106,9 +106,6 @@ typedef struct page *pgtable_t;
 
 #endif /* !(__ASSEMBLY__) */
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 /* We used to stick this into a hard-coded global register (%g4)
  * but that does not make sense anymore.
  */
diff -puN include/asm-um/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-um/page.h
--- a/include/asm-um/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-um/page.h
@@ -92,9 +92,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x) ((pgd_t) { (x) } )
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 extern unsigned long uml_physmem;
 
 #define PAGE_OFFSET (uml_physmem)
diff -puN include/asm-x86/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-x86/page.h
--- a/include/asm-x86/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-x86/page.h
@@ -31,9 +31,6 @@
 
 #define HUGE_MAX_HSTATE 2
 
-/* to align the pointer to the (next) page boundary */
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE-1)&PAGE_MASK)
-
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #endif
diff -puN include/asm-xtensa/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/asm-xtensa/page.h
--- a/include/asm-xtensa/page.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/asm-xtensa/page.h
@@ -26,13 +26,11 @@
 
 /*
  * PAGE_SHIFT determines the page size
- * PAGE_ALIGN(x) aligns the pointer to the (next) page boundary
  */
 
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(__XTENSA_UL_CONST(1) << PAGE_SHIFT)
 #define PAGE_MASK		(~(PAGE_SIZE-1))
-#define PAGE_ALIGN(addr)	(((addr)+PAGE_SIZE - 1) & PAGE_MASK)
 
 #define PAGE_OFFSET		XCHAL_KSEG_CACHED_VADDR
 #define MAX_MEM_PFN		XCHAL_KSEG_SIZE
diff -puN include/linux/mm.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures include/linux/mm.h
--- a/include/linux/mm.h~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/include/linux/mm.h
@@ -41,6 +41,9 @@ extern unsigned long mmap_min_addr;
 
 #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
 
+/* to align the pointer to the (next) page boundary */
+#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)
+
 /*
  * Linux kernel virtual memory manager primitives.
  * The idea being to have a "virtual" mm in the same way
diff -puN sound/core/info.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures sound/core/info.c
--- a/sound/core/info.c~page_align-correctly-handle-64-bit-values-on-32-bit-architectures
+++ a/sound/core/info.c
@@ -21,6 +21,7 @@
 
 #include <linux/init.h>
 #include <linux/time.h>
+#include <linux/mm.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <sound/core.h>
_

Patches currently in -mm which might be from righi.andrea@gmail.com are

page_align-correctly-handle-64-bit-values-on-32-bit-architectures.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-v850-fix.patch
page_align-correctly-handle-64-bit-values-on-32-bit-architectures-x86_64-fix.patch
distinct-tgid-tid-i-o-statistics.patch

