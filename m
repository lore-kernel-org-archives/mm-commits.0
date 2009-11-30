From: akpm@linux-foundation.org
Subject: [merged] block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages.patch removed from -mm tree
Date: Mon, 30 Nov 2009 12:34:21 -0800
Message-ID: <200911302034.nAUKYLbe023348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070AbZK3UfO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Nov 2009 15:35:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: isloginov@gmail.com, dwmw2@infradead.org, ecashin@coraid.com, jens.axboe@oracle.com, mingo@elte.hu, phorton@bitbox.co.uk, mm-commits@vger.kernel.org


The patch titled
     block: add helpers to run flush_dcache_page() against a bio and a request's pages
has been removed from the -mm tree.  Its filename was
     block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: add helpers to run flush_dcache_page() against a bio and a request's pages
From: Ilya Loginov <isloginov@gmail.com>

Mtdblock driver doesn't call flush_dcache_page for pages in request.  So,
this causes problems on architectures where the icache doesn't fill from
the dcache or with dcache aliases.  The patch fixes this.

The ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE symbol was introduced to avoid
pointless empty cache-thrashing loops on architectures for which
flush_dcache_page() is a no-op.  Every architecture was provided with this
#define.  New functions bio_flush_dcache_pages and rq_flush_dcache_pages
flush pages on architectires where ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE is
equal 1 or do nothing otherwise.

See "fix mtd_blkdevs problem with caches on some architectures" discussion
on LKML for more information.

Signed-off-by: Ilya Loginov <isloginov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Peter Horton <phorton@bitbox.co.uk>
Cc: "Ed L. Cashin" <ecashin@coraid.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/cacheflush.h      |    1 +
 arch/arm/include/asm/cacheflush.h        |    1 +
 arch/avr32/include/asm/cacheflush.h      |    1 +
 arch/blackfin/include/asm/cacheflush.h   |    2 ++
 arch/cris/include/asm/cacheflush.h       |    1 +
 arch/frv/include/asm/cacheflush.h        |    1 +
 arch/h8300/include/asm/cacheflush.h      |    1 +
 arch/ia64/include/asm/cacheflush.h       |    1 +
 arch/m32r/include/asm/cacheflush.h       |    3 +++
 arch/m68k/include/asm/cacheflush_mm.h    |    1 +
 arch/m68k/include/asm/cacheflush_no.h    |    1 +
 arch/microblaze/include/asm/cacheflush.h |    1 +
 arch/mips/include/asm/cacheflush.h       |    1 +
 arch/mn10300/include/asm/cacheflush.h    |    1 +
 arch/parisc/include/asm/cacheflush.h     |    1 +
 arch/powerpc/include/asm/cacheflush.h    |    1 +
 arch/s390/include/asm/cacheflush.h       |    1 +
 arch/score/include/asm/cacheflush.h      |    1 +
 arch/sh/include/asm/cacheflush.h         |    1 +
 arch/sparc/include/asm/cacheflush_32.h   |    1 +
 arch/sparc/include/asm/cacheflush_64.h   |    1 +
 arch/x86/include/asm/cacheflush.h        |    1 +
 arch/xtensa/include/asm/cacheflush.h     |    1 +
 block/blk-core.c                         |   19 +++++++++++++++++++
 drivers/mtd/mtd_blkdevs.c                |    2 ++
 fs/bio.c                                 |   12 ++++++++++++
 include/asm-generic/cacheflush.h         |    1 +
 include/linux/bio.h                      |   12 ++++++++++++
 include/linux/blkdev.h                   |   11 +++++++++++
 29 files changed, 83 insertions(+)

diff -puN arch/alpha/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/alpha/include/asm/cacheflush.h
--- a/arch/alpha/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/alpha/include/asm/cacheflush.h
@@ -9,6 +9,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/arm/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/arm/include/asm/cacheflush.h
--- a/arch/arm/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/arm/include/asm/cacheflush.h
@@ -418,6 +418,7 @@ extern void flush_ptrace_access(struct v
  * about to change to user space.  This is the same method as used on SPARC64.
  * See update_mmu_cache for the user space part.
  */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *);
 
 static inline void __flush_icache_all(void)
diff -puN arch/avr32/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/avr32/include/asm/cacheflush.h
--- a/arch/avr32/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/avr32/include/asm/cacheflush.h
@@ -107,6 +107,7 @@ extern void flush_icache_page(struct vm_
  * do something here, but only for certain configurations.  No such
  * configurations exist at this time.
  */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(page)		do { } while (0)
 #define flush_dcache_mmap_unlock(page)		do { } while (0)
diff -puN arch/blackfin/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/blackfin/include/asm/cacheflush.h
--- a/arch/blackfin/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/blackfin/include/asm/cacheflush.h
@@ -68,9 +68,11 @@ do { memcpy(dst, src, len);						\
 #endif
 #if defined(CONFIG_BFIN_EXTMEM_WRITEBACK) || defined(CONFIG_BFIN_L2_WRITEBACK)
 # define flush_dcache_range(start,end)		blackfin_dcache_flush_range((start), (end))
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 # define flush_dcache_page(page)		blackfin_dflush_page(page_address(page))
 #else
 # define flush_dcache_range(start,end)		do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 # define flush_dcache_page(page)		do { } while (0)
 #endif
 
diff -puN arch/cris/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/cris/include/asm/cacheflush.h
--- a/arch/cris/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/cris/include/asm/cacheflush.h
@@ -12,6 +12,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/frv/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/frv/include/asm/cacheflush.h
--- a/arch/frv/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/frv/include/asm/cacheflush.h
@@ -47,6 +47,7 @@ static inline void __flush_cache_all(voi
 }
 
 /* dcache/icache coherency... */
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #ifdef CONFIG_MMU
 extern void flush_dcache_page(struct page *page);
 #else
diff -puN arch/h8300/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/h8300/include/asm/cacheflush.h
--- a/arch/h8300/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/h8300/include/asm/cacheflush.h
@@ -15,6 +15,7 @@
 #define	flush_cache_dup_mm(mm)		do { } while (0)
 #define	flush_cache_range(vma,a,b)
 #define	flush_cache_page(vma,p,pfn)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define	flush_dcache_page(page)
 #define	flush_dcache_mmap_lock(mapping)
 #define	flush_dcache_mmap_unlock(mapping)
diff -puN arch/ia64/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/ia64/include/asm/cacheflush.h
--- a/arch/ia64/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/ia64/include/asm/cacheflush.h
@@ -25,6 +25,7 @@
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #define flush_dcache_page(page)			\
 do {						\
 	clear_bit(PG_arch_1, &(page)->flags);	\
diff -puN arch/m32r/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/m32r/include/asm/cacheflush.h
--- a/arch/m32r/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/m32r/include/asm/cacheflush.h
@@ -12,6 +12,7 @@ extern void _flush_cache_copyback_all(vo
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
@@ -33,6 +34,7 @@ extern void smp_flush_cache_all(void);
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
@@ -46,6 +48,7 @@ extern void smp_flush_cache_all(void);
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/m68k/include/asm/cacheflush_mm.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/m68k/include/asm/cacheflush_mm.h
--- a/arch/m68k/include/asm/cacheflush_mm.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/m68k/include/asm/cacheflush_mm.h
@@ -128,6 +128,7 @@ static inline void __flush_page_to_ram(v
 	}
 }
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #define flush_dcache_page(page)		__flush_page_to_ram(page_address(page))
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/m68k/include/asm/cacheflush_no.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/m68k/include/asm/cacheflush_no.h
--- a/arch/m68k/include/asm/cacheflush_no.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/m68k/include/asm/cacheflush_no.h
@@ -12,6 +12,7 @@
 #define flush_cache_range(vma, start, end)	__flush_cache_all()
 #define flush_cache_page(vma, vmaddr)		do { } while (0)
 #define flush_dcache_range(start,len)		__flush_cache_all()
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/microblaze/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/microblaze/include/asm/cacheflush.h
--- a/arch/microblaze/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/microblaze/include/asm/cacheflush.h
@@ -37,6 +37,7 @@
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 
 #define flush_dcache_range(start, end)	__invalidate_dcache_range(start, end)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/mips/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/mips/include/asm/cacheflush.h
--- a/arch/mips/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/mips/include/asm/cacheflush.h
@@ -38,6 +38,7 @@ extern void (*flush_cache_range)(struct 
 extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
 extern void __flush_dcache_page(struct page *page);
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_page(struct page *page)
 {
 	if (cpu_has_dc_aliases || !cpu_has_ic_fills_f_dc)
diff -puN arch/mn10300/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/mn10300/include/asm/cacheflush.h
--- a/arch/mn10300/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/mn10300/include/asm/cacheflush.h
@@ -26,6 +26,7 @@
 #define flush_cache_page(vma, vmaddr, pfn)	do {} while (0)
 #define flush_cache_vmap(start, end)		do {} while (0)
 #define flush_cache_vunmap(start, end)		do {} while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do {} while (0)
 #define flush_dcache_mmap_lock(mapping)		do {} while (0)
 #define flush_dcache_mmap_unlock(mapping)	do {} while (0)
diff -puN arch/parisc/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/parisc/include/asm/cacheflush.h
--- a/arch/parisc/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/parisc/include/asm/cacheflush.h
@@ -42,6 +42,7 @@ void flush_cache_mm(struct mm_struct *mm
 #define flush_cache_vmap(start, end)		flush_cache_all()
 #define flush_cache_vunmap(start, end)		flush_cache_all()
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 
 #define flush_dcache_mmap_lock(mapping) \
diff -puN arch/powerpc/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/powerpc/include/asm/cacheflush.h
--- a/arch/powerpc/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/powerpc/include/asm/cacheflush.h
@@ -25,6 +25,7 @@
 #define flush_cache_vmap(start, end)		do { } while (0)
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/s390/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/s390/include/asm/cacheflush.h
--- a/arch/s390/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/s390/include/asm/cacheflush.h
@@ -10,6 +10,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/score/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/score/include/asm/cacheflush.h
--- a/arch/score/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/score/include/asm/cacheflush.h
@@ -16,6 +16,7 @@ extern void flush_icache_range(unsigned 
 extern void flush_dcache_range(unsigned long start, unsigned long end);
 
 #define flush_cache_dup_mm(mm)			do {} while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do {} while (0)
 #define flush_dcache_mmap_lock(mapping)		do {} while (0)
 #define flush_dcache_mmap_unlock(mapping)	do {} while (0)
diff -puN arch/sh/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/sh/include/asm/cacheflush.h
--- a/arch/sh/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/sh/include/asm/cacheflush.h
@@ -42,6 +42,7 @@ extern void flush_cache_page(struct vm_a
 				unsigned long addr, unsigned long pfn);
 extern void flush_cache_range(struct vm_area_struct *vma,
 				 unsigned long start, unsigned long end);
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 extern void flush_icache_range(unsigned long start, unsigned long end);
 extern void flush_icache_page(struct vm_area_struct *vma,
diff -puN arch/sparc/include/asm/cacheflush_32.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/sparc/include/asm/cacheflush_32.h
--- a/arch/sparc/include/asm/cacheflush_32.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/sparc/include/asm/cacheflush_32.h
@@ -75,6 +75,7 @@ BTFIXUPDEF_CALL(void, flush_sig_insns, s
 
 extern void sparc_flush_page_to_ram(struct page *page);
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 #define flush_dcache_page(page)			sparc_flush_page_to_ram(page)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN arch/sparc/include/asm/cacheflush_64.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/sparc/include/asm/cacheflush_64.h
--- a/arch/sparc/include/asm/cacheflush_64.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/sparc/include/asm/cacheflush_64.h
@@ -37,6 +37,7 @@ extern void flush_dcache_page_all(struct
 #endif
 
 extern void __flush_dcache_range(unsigned long start, unsigned long end);
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page *page);
 
 #define flush_icache_page(vma, pg)	do { } while(0)
diff -puN arch/x86/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/x86/include/asm/cacheflush.h
--- a/arch/x86/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/x86/include/asm/cacheflush.h
@@ -12,6 +12,7 @@ static inline void flush_cache_range(str
 				     unsigned long start, unsigned long end) { }
 static inline void flush_cache_page(struct vm_area_struct *vma,
 				    unsigned long vmaddr, unsigned long pfn) { }
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 static inline void flush_dcache_page(struct page *page) { }
 static inline void flush_dcache_mmap_lock(struct address_space *mapping) { }
 static inline void flush_dcache_mmap_unlock(struct address_space *mapping) { }
diff -puN arch/xtensa/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages arch/xtensa/include/asm/cacheflush.h
--- a/arch/xtensa/include/asm/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/arch/xtensa/include/asm/cacheflush.h
@@ -101,6 +101,7 @@ static inline void __invalidate_icache_p
 #define flush_cache_vmap(start,end)	flush_cache_all()
 #define flush_cache_vunmap(start,end)	flush_cache_all()
 
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 extern void flush_dcache_page(struct page*);
 extern void flush_cache_range(struct vm_area_struct*, ulong, ulong);
 extern void flush_cache_page(struct vm_area_struct*, unsigned long, unsigned long);
diff -puN block/blk-core.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages block/blk-core.c
--- a/block/blk-core.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/block/blk-core.c
@@ -2358,6 +2358,25 @@ void blk_rq_bio_prep(struct request_queu
 		rq->rq_disk = bio->bi_bdev->bd_disk;
 }
 
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+/**
+ * rq_flush_dcache_pages - Helper function to flush all pages in a request
+ * @rq: the request to be flushed
+ *
+ * Description:
+ *     Flush all pages in @rq.
+ */
+void rq_flush_dcache_pages(struct request *rq)
+{
+	struct req_iterator iter;
+	struct bio_vec* bvec;
+
+	rq_for_each_segment(bvec, rq, iter)
+		flush_dcache_page(bvec->bv_page);
+}
+EXPORT_SYMBOL_GPL(rq_flush_dcache_pages);
+#endif
+
 /**
  * blk_lld_busy - Check if underlying low-level drivers of a device are busy
  * @q : the queue of the device being checked
diff -puN drivers/mtd/mtd_blkdevs.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -59,12 +59,14 @@ static int do_blktrans_request(struct mt
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->readsect(dev, block, buf))
 				return -EIO;
+		rq_flush_dcache_pages(req);
 		return 0;
 
 	case WRITE:
 		if (!tr->writesect)
 			return -EIO;
 
+		rq_flush_dcache_pages(req);
 		for (; nsect > 0; nsect--, block++, buf += tr->blksize)
 			if (tr->writesect(dev, block, buf))
 				return -EIO;
diff -puN fs/bio.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages fs/bio.c
--- a/fs/bio.c~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/fs/bio.c
@@ -1393,6 +1393,18 @@ void bio_check_pages_dirty(struct bio *b
 	}
 }
 
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+void bio_flush_dcache_pages(struct bio *bi)
+{
+	int i;
+	struct bio_vec* bvec;
+
+	bio_for_each_segment(bvec, bi, i)
+		flush_dcache_page(bvec->bv_page);
+}
+EXPORT_SYMBOL(bio_flush_dcache_pages);
+#endif
+
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
diff -puN include/asm-generic/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages include/asm-generic/cacheflush.h
--- a/include/asm-generic/cacheflush.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/include/asm-generic/cacheflush.h
@@ -13,6 +13,7 @@
 #define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
+#define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 0
 #define flush_dcache_page(page)			do { } while (0)
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
diff -puN include/linux/bio.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages include/linux/bio.h
--- a/include/linux/bio.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/include/linux/bio.h
@@ -391,6 +391,18 @@ extern struct bio *bio_copy_kern(struct 
 				 gfp_t, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
+
+#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
+#endif
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+extern void bio_flush_dcache_pages(struct bio *bi);
+#else
+static inline void bio_flush_dcache_pages(struct bio *bi)
+{
+}
+#endif
+
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *,
diff -puN include/linux/blkdev.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages include/linux/blkdev.h
--- a/include/linux/blkdev.h~block-add-helpers-to-run-flush_dcache_page-against-a-bio-and-a-requests-pages
+++ a/include/linux/blkdev.h
@@ -752,6 +752,17 @@ struct req_iterator {
 #define rq_iter_last(rq, _iter)					\
 		(_iter.bio->bi_next == NULL && _iter.i == _iter.bio->bi_vcnt-1)
 
+#ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+# error	"You should to define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE for your platform."
+#endif
+#if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
+extern void rq_flush_dcache_pages(struct request *rq);
+#else
+static inline void rq_flush_dcache_pages(struct request *rq)
+{
+}
+#endif
+
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 extern void register_disk(struct gendisk *dev);
_

Patches currently in -mm which might be from isloginov@gmail.com are

linux-next.patch
aoe-switch-to-the-new-bio_flush_dcache_pages-interface.patch

