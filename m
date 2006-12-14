From: akpm@osdl.org
Subject: - optimize-d-cache-alias-handling-on-fork.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:21:13 -0800
Message-ID: <200612140621.kBE6LCqJ002421@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52931 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbWLNGVg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:21:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Optimize D-cache alias handling on fork
has been removed from the -mm tree.  Its filename was
     optimize-d-cache-alias-handling-on-fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Optimize D-cache alias handling on fork
From: Ralf Baechle <ralf@linux-mips.org>

Virtually index, physically tagged cache architectures can get away without
cache flushing when forking.  This patch adds a new cache flushing function
flush_cache_dup_mm(struct mm_struct *) which for the moment I've implemented
to do the same thing on all architectures except on MIPS where it's a no-op.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 Documentation/cachetlb.txt          |   23 +++++++++++++++++------
 include/asm-alpha/cacheflush.h      |    1 +
 include/asm-arm/cacheflush.h        |    2 ++
 include/asm-arm26/cacheflush.h      |    1 +
 include/asm-avr32/cacheflush.h      |    1 +
 include/asm-cris/cacheflush.h       |    1 +
 include/asm-frv/cacheflush.h        |    1 +
 include/asm-h8300/cacheflush.h      |    1 +
 include/asm-i386/cacheflush.h       |    1 +
 include/asm-ia64/cacheflush.h       |    1 +
 include/asm-m32r/cacheflush.h       |    3 +++
 include/asm-m68k/cacheflush.h       |    2 ++
 include/asm-m68knommu/cacheflush.h  |    1 +
 include/asm-mips/cacheflush.h       |    2 ++
 include/asm-parisc/cacheflush.h     |    2 ++
 include/asm-powerpc/cacheflush.h    |    1 +
 include/asm-s390/cacheflush.h       |    1 +
 include/asm-sh/cpu-sh2/cacheflush.h |    2 ++
 include/asm-sh/cpu-sh3/cacheflush.h |    3 +++
 include/asm-sh/cpu-sh4/cacheflush.h |    1 +
 include/asm-sh64/cacheflush.h       |    2 ++
 include/asm-sparc/cacheflush.h      |    1 +
 include/asm-sparc64/cacheflush.h    |    1 +
 include/asm-v850/cacheflush.h       |    1 +
 include/asm-x86_64/cacheflush.h     |    1 +
 include/asm-xtensa/cacheflush.h     |    2 ++
 kernel/fork.c                       |    2 +-
 27 files changed, 54 insertions(+), 7 deletions(-)

diff -puN Documentation/cachetlb.txt~optimize-d-cache-alias-handling-on-fork Documentation/cachetlb.txt
--- a/Documentation/cachetlb.txt~optimize-d-cache-alias-handling-on-fork
+++ a/Documentation/cachetlb.txt
@@ -179,10 +179,21 @@ Here are the routines, one by one:
 	lines associated with 'mm'.
 
 	This interface is used to handle whole address space
-	page table operations such as what happens during
-	fork, exit, and exec.
+	page table operations such as what happens during exit and exec.
 
-2) void flush_cache_range(struct vm_area_struct *vma,
+2) void flush_cache_dup_mm(struct mm_struct *mm)
+
+	This interface flushes an entire user address space from
+	the caches.  That is, after running, there will be no cache
+	lines associated with 'mm'.
+
+	This interface is used to handle whole address space
+	page table operations such as what happens during fork.
+
+	This option is separate from flush_cache_mm to allow some
+	optimizations for VIPT caches.
+
+3) void flush_cache_range(struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end)
 
 	Here we are flushing a specific range of (user) virtual
@@ -199,7 +210,7 @@ Here are the routines, one by one:
 	call flush_cache_page (see below) for each entry which may be
 	modified.
 
-3) void flush_cache_page(struct vm_area_struct *vma, unsigned long addr, unsigned long pfn)
+4) void flush_cache_page(struct vm_area_struct *vma, unsigned long addr, unsigned long pfn)
 
 	This time we need to remove a PAGE_SIZE sized range
 	from the cache.  The 'vma' is the backing structure used by
@@ -220,7 +231,7 @@ Here are the routines, one by one:
 
 	This is used primarily during fault processing.
 
-4) void flush_cache_kmaps(void)
+5) void flush_cache_kmaps(void)
 
 	This routine need only be implemented if the platform utilizes
 	highmem.  It will be called right before all of the kmaps
@@ -232,7 +243,7 @@ Here are the routines, one by one:
 
 	This routing should be implemented in asm/highmem.h
 
-5) void flush_cache_vmap(unsigned long start, unsigned long end)
+6) void flush_cache_vmap(unsigned long start, unsigned long end)
    void flush_cache_vunmap(unsigned long start, unsigned long end)
 
 	Here in these two interfaces we are flushing a specific range
diff -puN include/asm-alpha/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-alpha/cacheflush.h
--- a/include/asm-alpha/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-alpha/cacheflush.h
@@ -6,6 +6,7 @@
 /* Caches aren't brain-dead on the Alpha. */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-arm/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-arm/cacheflush.h
--- a/include/asm-arm/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-arm/cacheflush.h
@@ -319,6 +319,8 @@ extern void flush_ptrace_access(struct v
 				unsigned long len, int write);
 #endif
 
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
+
 /*
  * flush_cache_user_range is used when we want to ensure that the
  * Harvard caches are synchronised for the user space address range.
diff -puN include/asm-arm26/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-arm26/cacheflush.h
--- a/include/asm-arm26/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-arm26/cacheflush.h
@@ -22,6 +22,7 @@
 
 #define flush_cache_all()                       do { } while (0)
 #define flush_cache_mm(mm)                      do { } while (0)
+#define flush_cache_dup_mm(mm)                  do { } while (0)
 #define flush_cache_range(vma,start,end)        do { } while (0)
 #define flush_cache_page(vma,vmaddr,pfn)        do { } while (0)
 #define flush_cache_vmap(start, end)		do { } while (0)
diff -puN include/asm-avr32/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-avr32/cacheflush.h
--- a/include/asm-avr32/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-avr32/cacheflush.h
@@ -87,6 +87,7 @@ void invalidate_icache_region(void *star
  */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_cache_vmap(start, end)		do { } while (0)
diff -puN include/asm-cris/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-cris/cacheflush.h
--- a/include/asm-cris/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-cris/cacheflush.h
@@ -9,6 +9,7 @@
  */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-frv/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-frv/cacheflush.h
--- a/include/asm-frv/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-frv/cacheflush.h
@@ -20,6 +20,7 @@
  */
 #define flush_cache_all()			do {} while(0)
 #define flush_cache_mm(mm)			do {} while(0)
+#define flush_cache_dup_mm(mm)			do {} while(0)
 #define flush_cache_range(mm, start, end)	do {} while(0)
 #define flush_cache_page(vma, vmaddr, pfn)	do {} while(0)
 #define flush_cache_vmap(start, end)		do {} while(0)
diff -puN include/asm-h8300/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-h8300/cacheflush.h
--- a/include/asm-h8300/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-h8300/cacheflush.h
@@ -12,6 +12,7 @@
 
 #define flush_cache_all()
 #define	flush_cache_mm(mm)
+#define	flush_cache_dup_mm(mm)		do { } while (0)
 #define	flush_cache_range(vma,a,b)
 #define	flush_cache_page(vma,p,pfn)
 #define	flush_dcache_page(page)
diff -puN include/asm-i386/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-i386/cacheflush.h
--- a/include/asm-i386/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-i386/cacheflush.h
@@ -7,6 +7,7 @@
 /* Caches aren't brain-dead on the intel. */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-ia64/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-ia64/cacheflush.h
--- a/include/asm-ia64/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-ia64/cacheflush.h
@@ -18,6 +18,7 @@
 
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_icache_page(vma,page)		do { } while (0)
diff -puN include/asm-m32r/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-m32r/cacheflush.h
--- a/include/asm-m32r/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-m32r/cacheflush.h
@@ -9,6 +9,7 @@ extern void _flush_cache_copyback_all(vo
 #if defined(CONFIG_CHIP_M32700) || defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
@@ -29,6 +30,7 @@ extern void smp_flush_cache_all(void);
 #elif defined(CONFIG_CHIP_M32102)
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
@@ -41,6 +43,7 @@ extern void smp_flush_cache_all(void);
 #else
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-m68k/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-m68k/cacheflush.h
--- a/include/asm-m68k/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-m68k/cacheflush.h
@@ -89,6 +89,8 @@ static inline void flush_cache_mm(struct
 		__flush_cache_030();
 }
 
+#define flush_cache_dup_mm(mm)			flush_cache_mm(mm)
+
 /* flush_cache_range/flush_cache_page must be macros to avoid
    a dependency on linux/mm.h, which includes this file... */
 static inline void flush_cache_range(struct vm_area_struct *vma,
diff -puN include/asm-m68knommu/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-m68knommu/cacheflush.h
--- a/include/asm-m68knommu/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-m68knommu/cacheflush.h
@@ -8,6 +8,7 @@
 
 #define flush_cache_all()			__flush_cache_all()
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	__flush_cache_all()
 #define flush_cache_page(vma, vmaddr)		do { } while (0)
 #define flush_dcache_range(start,len)		__flush_cache_all()
diff -puN include/asm-mips/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-mips/cacheflush.h
--- a/include/asm-mips/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-mips/cacheflush.h
@@ -17,6 +17,7 @@
  *
  *  - flush_cache_all() flushes entire cache
  *  - flush_cache_mm(mm) flushes the specified mm context's cache lines
+ *  - flush_cache_dup mm(mm) handles cache flushing when forking
  *  - flush_cache_page(mm, vmaddr, pfn) flushes a single page
  *  - flush_cache_range(vma, start, end) flushes a range of pages
  *  - flush_icache_range(start, end) flush a range of instructions
@@ -31,6 +32,7 @@
 extern void (*flush_cache_all)(void);
 extern void (*__flush_cache_all)(void);
 extern void (*flush_cache_mm)(struct mm_struct *mm);
+#define flush_cache_dup_mm(mm)	do { (void) (mm); } while (0)
 extern void (*flush_cache_range)(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end);
 extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
diff -puN include/asm-parisc/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-parisc/cacheflush.h
--- a/include/asm-parisc/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-parisc/cacheflush.h
@@ -15,6 +15,8 @@
 #define flush_cache_mm(mm) flush_cache_all_local()
 #endif
 
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
+
 #define flush_kernel_dcache_range(start,size) \
 	flush_kernel_dcache_range_asm((start), (start)+(size));
 
diff -puN include/asm-powerpc/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-powerpc/cacheflush.h
--- a/include/asm-powerpc/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-powerpc/cacheflush.h
@@ -18,6 +18,7 @@
  */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_icache_page(vma, page)		do { } while (0)
diff -puN include/asm-s390/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-s390/cacheflush.h
--- a/include/asm-s390/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-s390/cacheflush.h
@@ -7,6 +7,7 @@
 /* Caches aren't brain-dead on the s390. */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-sh/cpu-sh2/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-sh/cpu-sh2/cacheflush.h
--- a/include/asm-sh/cpu-sh2/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-sh/cpu-sh2/cacheflush.h
@@ -15,6 +15,7 @@
  *
  *  - flush_cache_all() flushes entire cache
  *  - flush_cache_mm(mm) flushes the specified mm context's cache lines
+ *  - flush_cache_dup mm(mm) handles cache flushing when forking
  *  - flush_cache_page(mm, vmaddr, pfn) flushes a single page
  *  - flush_cache_range(vma, start, end) flushes a range of pages
  *
@@ -27,6 +28,7 @@
  */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-sh/cpu-sh3/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-sh/cpu-sh3/cacheflush.h
--- a/include/asm-sh/cpu-sh3/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-sh/cpu-sh3/cacheflush.h
@@ -15,6 +15,7 @@
  *
  *  - flush_cache_all() flushes entire cache
  *  - flush_cache_mm(mm) flushes the specified mm context's cache lines
+ *  - flush_cache_dup mm(mm) handles cache flushing when forking
  *  - flush_cache_page(mm, vmaddr, pfn) flushes a single page
  *  - flush_cache_range(vma, start, end) flushes a range of pages
  *
@@ -39,6 +40,7 @@
 
 void flush_cache_all(void);
 void flush_cache_mm(struct mm_struct *mm);
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
 void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
                               unsigned long end);
 void flush_cache_page(struct vm_area_struct *vma, unsigned long addr, unsigned long pfn);
@@ -48,6 +50,7 @@ void flush_icache_page(struct vm_area_st
 #else
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-sh/cpu-sh4/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-sh/cpu-sh4/cacheflush.h
--- a/include/asm-sh/cpu-sh4/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-sh/cpu-sh4/cacheflush.h
@@ -18,6 +18,7 @@
  */
 void flush_cache_all(void);
 void flush_cache_mm(struct mm_struct *mm);
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
 void flush_cache_range(struct vm_area_struct *vma, unsigned long start,
 		       unsigned long end);
 void flush_cache_page(struct vm_area_struct *vma, unsigned long addr,
diff -puN include/asm-sh64/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-sh64/cacheflush.h
--- a/include/asm-sh64/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-sh64/cacheflush.h
@@ -21,6 +21,8 @@ extern void flush_icache_user_range(stru
 				    struct page *page, unsigned long addr,
 				    int len);
 
+#define flush_cache_dup_mm(mm)	flush_cache_mm(mm)
+
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
 #define flush_dcache_mmap_unlock(mapping)	do { } while (0)
 
diff -puN include/asm-sparc/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-sparc/cacheflush.h
--- a/include/asm-sparc/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-sparc/cacheflush.h
@@ -48,6 +48,7 @@ BTFIXUPDEF_CALL(void, flush_cache_page, 
 
 #define flush_cache_all() BTFIXUP_CALL(flush_cache_all)()
 #define flush_cache_mm(mm) BTFIXUP_CALL(flush_cache_mm)(mm)
+#define flush_cache_dup_mm(mm) BTFIXUP_CALL(flush_cache_mm)(mm)
 #define flush_cache_range(vma,start,end) BTFIXUP_CALL(flush_cache_range)(vma,start,end)
 #define flush_cache_page(vma,addr,pfn) BTFIXUP_CALL(flush_cache_page)(vma,addr)
 #define flush_icache_range(start, end)		do { } while (0)
diff -puN include/asm-sparc64/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-sparc64/cacheflush.h
--- a/include/asm-sparc64/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-sparc64/cacheflush.h
@@ -12,6 +12,7 @@
 /* These are the same regardless of whether this is an SMP kernel or not. */
 #define flush_cache_mm(__mm) \
 	do { if ((__mm) == current->mm) flushw_user(); } while(0)
+#define flush_cache_dup_mm(mm) flush_cache_mm(mm)
 #define flush_cache_range(vma, start, end) \
 	flush_cache_mm((vma)->vm_mm)
 #define flush_cache_page(vma, page, pfn) \
diff -puN include/asm-v850/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-v850/cacheflush.h
--- a/include/asm-v850/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-v850/cacheflush.h
@@ -24,6 +24,7 @@
    systems with MMUs, so we don't need them.  */
 #define flush_cache_all()			((void)0)
 #define flush_cache_mm(mm)			((void)0)
+#define flush_cache_dup_mm(mm)			((void)0)
 #define flush_cache_range(vma, start, end)	((void)0)
 #define flush_cache_page(vma, vmaddr, pfn)	((void)0)
 #define flush_dcache_page(page)			((void)0)
diff -puN include/asm-x86_64/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-x86_64/cacheflush.h
--- a/include/asm-x86_64/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-x86_64/cacheflush.h
@@ -7,6 +7,7 @@
 /* Caches aren't brain-dead on the intel. */
 #define flush_cache_all()			do { } while (0)
 #define flush_cache_mm(mm)			do { } while (0)
+#define flush_cache_dup_mm(mm)			do { } while (0)
 #define flush_cache_range(vma, start, end)	do { } while (0)
 #define flush_cache_page(vma, vmaddr, pfn)	do { } while (0)
 #define flush_dcache_page(page)			do { } while (0)
diff -puN include/asm-xtensa/cacheflush.h~optimize-d-cache-alias-handling-on-fork include/asm-xtensa/cacheflush.h
--- a/include/asm-xtensa/cacheflush.h~optimize-d-cache-alias-handling-on-fork
+++ a/include/asm-xtensa/cacheflush.h
@@ -75,6 +75,7 @@ extern void __flush_invalidate_dcache_ra
 
 #define flush_cache_all()		__flush_invalidate_cache_all();
 #define flush_cache_mm(mm)		__flush_invalidate_cache_all();
+#define flush_cache_dup_mm(mm)		__flush_invalidate_cache_all();
 
 #define flush_cache_vmap(start,end)	__flush_invalidate_cache_all();
 #define flush_cache_vunmap(start,end)	__flush_invalidate_cache_all();
@@ -88,6 +89,7 @@ extern void flush_cache_page(struct vm_a
 
 #define flush_cache_all()				do { } while (0)
 #define flush_cache_mm(mm)				do { } while (0)
+#define flush_cache_dup_mm(mm)				do { } while (0)
 
 #define flush_cache_vmap(start,end)			do { } while (0)
 #define flush_cache_vunmap(start,end)			do { } while (0)
diff -puN kernel/fork.c~optimize-d-cache-alias-handling-on-fork kernel/fork.c
--- a/kernel/fork.c~optimize-d-cache-alias-handling-on-fork
+++ a/kernel/fork.c
@@ -203,7 +203,7 @@ static inline int dup_mmap(struct mm_str
 	struct mempolicy *pol;
 
 	down_write(&oldmm->mmap_sem);
-	flush_cache_mm(oldmm);
+	flush_cache_dup_mm(oldmm);
 	/*
 	 * Not linked in yet - no deadlock potential:
 	 */
_

Patches currently in -mm which might be from ralf@linux-mips.org are

fix-namespace-conflict-between-w9968cfc-on-mips.patch
make-lm70_remove-a-__devexit-function.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch

