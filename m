From: akpm@linux-foundation.org
Subject: + remove-unused-flush_tlb_pgtables.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:50:44 -0700
Message-ID: <200710172150.l9HLoiXA010046@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753766AbXJQVuy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:50:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, linux-arch@vger.kernel.org


The patch titled
     remove unused flush_tlb_pgtables
has been added to the -mm tree.  Its filename is
     remove-unused-flush_tlb_pgtables.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: remove unused flush_tlb_pgtables
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Nobody uses flush_tlb_pgtables anymore, this patch removes all remaining
traces of it from all archs.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cachetlb.txt       |   27 ++-------------------------
 include/asm-alpha/tlbflush.h     |   11 -----------
 include/asm-arm/tlbflush.h       |    5 -----
 include/asm-avr32/tlbflush.h     |    7 -------
 include/asm-blackfin/tlbflush.h  |    6 ------
 include/asm-cris/tlbflush.h      |    7 -------
 include/asm-frv/tlbflush.h       |    2 --
 include/asm-h8300/tlbflush.h     |    6 ------
 include/asm-ia64/tlbflush.h      |   13 -------------
 include/asm-m32r/tlbflush.h      |    3 ---
 include/asm-m68k/tlbflush.h      |   10 ----------
 include/asm-m68knommu/tlbflush.h |    6 ------
 include/asm-mips/tlbflush.h      |    7 -------
 include/asm-parisc/tlbflush.h    |    4 ----
 include/asm-powerpc/tlbflush.h   |   11 -----------
 include/asm-s390/tlbflush.h      |    7 -------
 include/asm-sh/tlbflush.h        |    6 ------
 include/asm-sh64/tlbflush.h      |    4 ----
 include/asm-sparc/tlbflush.h     |    6 ------
 include/asm-sparc64/tlbflush.h   |    7 -------
 include/asm-um/tlbflush.h        |    6 ------
 include/asm-v850/tlbflush.h      |    6 ------
 include/asm-x86/tlbflush_32.h    |    7 -------
 include/asm-x86/tlbflush_64.h    |    9 ---------
 include/asm-xtensa/tlbflush.h    |   11 -----------
 mm/memory.c                      |    3 ---
 26 files changed, 2 insertions(+), 195 deletions(-)

diff -puN Documentation/cachetlb.txt~remove-unused-flush_tlb_pgtables Documentation/cachetlb.txt
--- a/Documentation/cachetlb.txt~remove-unused-flush_tlb_pgtables
+++ a/Documentation/cachetlb.txt
@@ -87,30 +87,7 @@ changes occur:
 
 	This is used primarily during fault processing.
 
-5) void flush_tlb_pgtables(struct mm_struct *mm,
-			   unsigned long start, unsigned long end)
-
-   The software page tables for address space 'mm' for virtual
-   addresses in the range 'start' to 'end-1' are being torn down.
-
-   Some platforms cache the lowest level of the software page tables
-   in a linear virtually mapped array, to make TLB miss processing
-   more efficient.  On such platforms, since the TLB is caching the
-   software page table structure, it needs to be flushed when parts
-   of the software page table tree are unlinked/freed.
-
-   Sparc64 is one example of a platform which does this.
-
-   Usually, when munmap()'ing an area of user virtual address
-   space, the kernel leaves the page table parts around and just
-   marks the individual pte's as invalid.  However, if very large
-   portions of the address space are unmapped, the kernel frees up
-   those portions of the software page tables to prevent potential
-   excessive kernel memory usage caused by erratic mmap/mmunmap
-   sequences.  It is at these times that flush_tlb_pgtables will
-   be invoked.
-
-6) void update_mmu_cache(struct vm_area_struct *vma,
+5) void update_mmu_cache(struct vm_area_struct *vma,
 			 unsigned long address, pte_t pte)
 
 	At the end of every page fault, this routine is invoked to
@@ -123,7 +100,7 @@ changes occur:
 	translations for software managed TLB configurations.
 	The sparc64 port currently does this.
 
-7) void tlb_migrate_finish(struct mm_struct *mm)
+6) void tlb_migrate_finish(struct mm_struct *mm)
 
 	This interface is called at the end of an explicit
 	process migration. This interface provides a hook
diff -puN include/asm-alpha/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-alpha/tlbflush.h
--- a/include/asm-alpha/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-alpha/tlbflush.h
@@ -92,17 +92,6 @@ flush_tlb_other(struct mm_struct *mm)
 	if (*mmc) *mmc = 0;
 }
 
-/* Flush a specified range of user mapping page tables from TLB.
-   Although Alpha uses VPTE caches, this can be a nop, as Alpha does
-   not have finegrained tlb flushing, so it will flush VPTE stuff
-   during next flush_tlb_range.  */
-
-static inline void
-flush_tlb_pgtables(struct mm_struct *mm, unsigned long start,
-		   unsigned long end)
-{
-}
-
 #ifndef CONFIG_SMP
 /* Flush everything (kernel mapping may also have changed
    due to vmalloc/vfree).  */
diff -puN include/asm-arm/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-arm/tlbflush.h
--- a/include/asm-arm/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-arm/tlbflush.h
@@ -463,11 +463,6 @@ extern void flush_tlb_kernel_range(unsig
  */
 extern void update_mmu_cache(struct vm_area_struct *vma, unsigned long addr, pte_t pte);
 
-/*
- * ARM processors do not cache TLB tables in RAM.
- */
-#define flush_tlb_pgtables(mm,start,end)	do { } while (0)
-
 #endif
 
 #endif /* CONFIG_MMU */
diff -puN include/asm-avr32/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-avr32/tlbflush.h
--- a/include/asm-avr32/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-avr32/tlbflush.h
@@ -19,7 +19,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
 extern void flush_tlb(void);
 extern void flush_tlb_all(void);
@@ -29,12 +28,6 @@ extern void flush_tlb_range(struct vm_ar
 extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long page);
 extern void __flush_tlb_page(unsigned long asid, unsigned long page);
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	/* Nothing to do */
-}
-
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
 #endif /* __ASM_AVR32_TLBFLUSH_H */
diff -puN include/asm-blackfin/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-blackfin/tlbflush.h
--- a/include/asm-blackfin/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-blackfin/tlbflush.h
@@ -53,10 +53,4 @@ static inline void flush_tlb_kernel_page
 	BUG();
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	BUG();
-}
-
 #endif
diff -puN include/asm-cris/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-cris/tlbflush.h
--- a/include/asm-cris/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-cris/tlbflush.h
@@ -38,13 +38,6 @@ static inline void flush_tlb_range(struc
 	flush_tlb_mm(vma->vm_mm);
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-                                      unsigned long start, unsigned long end)
-{
-        /* CRIS does not keep any page table caches in TLB */
-}
-
-
 static inline void flush_tlb(void)
 {
 	flush_tlb_mm(current->mm);
diff -puN include/asm-frv/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-frv/tlbflush.h
--- a/include/asm-frv/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-frv/tlbflush.h
@@ -57,7 +57,6 @@ do {								\
 #define __flush_tlb_global()			flush_tlb_all()
 #define flush_tlb()				flush_tlb_all()
 #define flush_tlb_kernel_range(start, end)	flush_tlb_all()
-#define flush_tlb_pgtables(mm,start,end)	do { } while(0)
 
 #else
 
@@ -66,7 +65,6 @@ do {								\
 #define flush_tlb_mm(mm)			BUG()
 #define flush_tlb_page(vma,addr)		BUG()
 #define flush_tlb_range(mm,start,end)		BUG()
-#define flush_tlb_pgtables(mm,start,end)	BUG()
 #define flush_tlb_kernel_range(start, end)	BUG()
 
 #endif
diff -puN include/asm-h8300/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-h8300/tlbflush.h
--- a/include/asm-h8300/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-h8300/tlbflush.h
@@ -52,10 +52,4 @@ static inline void flush_tlb_kernel_page
 	BUG();
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	BUG();
-}
-
 #endif /* _H8300_TLBFLUSH_H */
diff -puN include/asm-ia64/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-ia64/tlbflush.h
--- a/include/asm-ia64/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-ia64/tlbflush.h
@@ -84,19 +84,6 @@ flush_tlb_page (struct vm_area_struct *v
 }
 
 /*
- * Flush the TLB entries mapping the virtually mapped linear page
- * table corresponding to address range [START-END).
- */
-static inline void
-flush_tlb_pgtables (struct mm_struct *mm, unsigned long start, unsigned long end)
-{
-	/*
-	 * Deprecated.  The virtual page table is now flushed via the normal gather/flush
-	 * interface (see tlb.h).
-	 */
-}
-
-/*
  * Flush the local TLB. Invoked from another cpu using an IPI.
  */
 #ifdef CONFIG_SMP
diff -puN include/asm-m32r/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-m32r/tlbflush.h
--- a/include/asm-m32r/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-m32r/tlbflush.h
@@ -12,7 +12,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
 
 extern void local_flush_tlb_all(void);
@@ -93,8 +92,6 @@ static __inline__ void __flush_tlb_all(v
 	);
 }
 
-#define flush_tlb_pgtables(mm, start, end)	do { } while (0)
-
 extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t);
 
 #endif	/* _ASM_M32R_TLBFLUSH_H */
diff -puN include/asm-m68k/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-m68k/tlbflush.h
--- a/include/asm-m68k/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-m68k/tlbflush.h
@@ -92,11 +92,6 @@ static inline void flush_tlb_kernel_rang
 	flush_tlb_all();
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-}
-
 #else
 
 
@@ -219,11 +214,6 @@ static inline void flush_tlb_kernel_page
 	sun3_put_segmap (addr & ~(SUN3_PMEG_SIZE - 1), SUN3_INVALID_PMEG);
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-}
-
 #endif
 
 #endif /* _M68K_TLBFLUSH_H */
diff -puN include/asm-m68knommu/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-m68knommu/tlbflush.h
--- a/include/asm-m68knommu/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-m68knommu/tlbflush.h
@@ -52,10 +52,4 @@ static inline void flush_tlb_kernel_page
 	BUG();
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	BUG();
-}
-
 #endif /* _M68KNOMMU_TLBFLUSH_H */
diff -puN include/asm-mips/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-mips/tlbflush.h
--- a/include/asm-mips/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-mips/tlbflush.h
@@ -11,7 +11,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
 extern void local_flush_tlb_all(void);
 extern void local_flush_tlb_mm(struct mm_struct *mm);
@@ -45,10 +44,4 @@ extern void flush_tlb_one(unsigned long 
 
 #endif /* CONFIG_SMP */
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-	unsigned long start, unsigned long end)
-{
-	/* Nothing to do on MIPS.  */
-}
-
 #endif /* __ASM_TLBFLUSH_H */
diff -puN include/asm-parisc/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-parisc/tlbflush.h
--- a/include/asm-parisc/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-parisc/tlbflush.h
@@ -57,10 +57,6 @@ static inline void flush_tlb_mm(struct m
 #endif
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm, unsigned long start, unsigned long end)
-{
-}
- 
 static inline void flush_tlb_page(struct vm_area_struct *vma,
 	unsigned long addr)
 {
diff -puN include/asm-powerpc/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-powerpc/tlbflush.h
--- a/include/asm-powerpc/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-powerpc/tlbflush.h
@@ -8,7 +8,6 @@
  *  - flush_tlb_page_nohash(vma, vmaddr) flushes one page if SW loaded TLB
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -174,15 +173,5 @@ extern void __flush_hash_table_range(str
  */
 extern void update_mmu_cache(struct vm_area_struct *, unsigned long, pte_t);
 
-/*
- * This is called in munmap when we have freed up some page-table
- * pages.  We don't need to do anything here, there's nothing special
- * about our page-table pages.  -- paulus
- */
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-}
-
 #endif /*__KERNEL__ */
 #endif /* _ASM_POWERPC_TLBFLUSH_H */
diff -puN include/asm-s390/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-s390/tlbflush.h
--- a/include/asm-s390/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-s390/tlbflush.h
@@ -14,7 +14,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
 
 /*
@@ -152,10 +151,4 @@ static inline void flush_tlb_range(struc
 
 #endif
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-                                      unsigned long start, unsigned long end)
-{
-        /* S/390 does not keep any page table caches in TLB */
-}
-
 #endif /* _S390_TLBFLUSH_H */
diff -puN include/asm-sh/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-sh/tlbflush.h
--- a/include/asm-sh/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-sh/tlbflush.h
@@ -9,7 +9,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
 extern void local_flush_tlb_all(void);
 extern void local_flush_tlb_mm(struct mm_struct *mm);
@@ -47,9 +46,4 @@ extern void flush_tlb_one(unsigned long 
 
 #endif /* CONFIG_SMP */
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	/* Nothing to do */
-}
 #endif /* __ASM_SH_TLBFLUSH_H */
diff -puN include/asm-sh64/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-sh64/tlbflush.h
--- a/include/asm-sh64/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-sh64/tlbflush.h
@@ -20,10 +20,6 @@ extern void flush_tlb_mm(struct mm_struc
 extern void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end);
 extern void flush_tlb_page(struct vm_area_struct *vma, unsigned long page);
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-}
 
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 
diff -puN include/asm-sparc/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-sparc/tlbflush.h
--- a/include/asm-sparc/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-sparc/tlbflush.h
@@ -13,7 +13,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
 
 #ifdef CONFIG_SMP
@@ -42,11 +41,6 @@ BTFIXUPDEF_CALL(void, flush_tlb_mm, stru
 BTFIXUPDEF_CALL(void, flush_tlb_range, struct vm_area_struct *, unsigned long, unsigned long)
 BTFIXUPDEF_CALL(void, flush_tlb_page, struct vm_area_struct *, unsigned long)
 
-// Thanks to Anton Blanchard, our pagetables became uncached in 2.4. Wee!
-// extern void flush_tlb_pgtables(struct mm_struct *mm,
-//     unsigned long start, unsigned long end);
-#define flush_tlb_pgtables(mm, start, end)	do{ }while(0)
-
 #define flush_tlb_all() BTFIXUP_CALL(flush_tlb_all)()
 #define flush_tlb_mm(mm) BTFIXUP_CALL(flush_tlb_mm)(mm)
 #define flush_tlb_range(vma,start,end) BTFIXUP_CALL(flush_tlb_range)(vma,start,end)
diff -puN include/asm-sparc64/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-sparc64/tlbflush.h
--- a/include/asm-sparc64/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-sparc64/tlbflush.h
@@ -41,11 +41,4 @@ do {	flush_tsb_kernel_range(start,end); 
 
 #endif /* ! CONFIG_SMP */
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm, unsigned long start, unsigned long end)
-{
-	/* We don't use virtual page tables for TLB miss processing
-	 * any more.  Nowadays we use the TSB.
-	 */
-}
-
 #endif /* _SPARC64_TLBFLUSH_H */
diff -puN include/asm-um/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-um/tlbflush.h
--- a/include/asm-um/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-um/tlbflush.h
@@ -17,7 +17,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_kernel_vm() flushes the kernel vm area
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  */
 
 extern void flush_tlb_all(void);
@@ -29,9 +28,4 @@ extern void flush_tlb_kernel_vm(void);
 extern void flush_tlb_kernel_range(unsigned long start, unsigned long end);
 extern void __flush_tlb_one(unsigned long addr);
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-}
-
 #endif
diff -puN include/asm-v850/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-v850/tlbflush.h
--- a/include/asm-v850/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-v850/tlbflush.h
@@ -61,10 +61,4 @@ static inline void flush_tlb_kernel_page
 	BUG ();
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	BUG ();
-}
-
 #endif /* __V850_TLBFLUSH_H__ */
diff -puN include/asm-x86/tlbflush_32.h~remove-unused-flush_tlb_pgtables include/asm-x86/tlbflush_32.h
--- a/include/asm-x86/tlbflush_32.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-x86/tlbflush_32.h
@@ -78,7 +78,6 @@
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  *  - flush_tlb_others(cpumask, mm, va) flushes a TLBs on other cpus
  *
  * ..but the i386 has somewhat limited tlb flushing capabilities,
@@ -166,10 +165,4 @@ static inline void flush_tlb_kernel_rang
 	flush_tlb_all();
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	/* i386 does not keep any page table caches in TLB */
-}
-
 #endif /* _I386_TLBFLUSH_H */
diff -puN include/asm-x86/tlbflush_64.h~remove-unused-flush_tlb_pgtables include/asm-x86/tlbflush_64.h
--- a/include/asm-x86/tlbflush_64.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-x86/tlbflush_64.h
@@ -31,7 +31,6 @@ static inline void __flush_tlb_all(void)
  *  - flush_tlb_page(vma, vmaddr) flushes one page
  *  - flush_tlb_range(vma, start, end) flushes a range of pages
  *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
- *  - flush_tlb_pgtables(mm, start, end) flushes a range of page tables
  *
  * x86-64 can only flush individual pages or full VMs. For a range flush
  * we always do the full VM. Might be worth trying if for a small
@@ -98,12 +97,4 @@ static inline void flush_tlb_kernel_rang
 	flush_tlb_all();
 }
 
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-				      unsigned long start, unsigned long end)
-{
-	/* x86_64 does not keep any page table caches in a software TLB.
-	   The CPUs do in their hardware TLBs, but they are handled
-	   by the normal TLB flushing algorithms. */
-}
-
 #endif /* _X8664_TLBFLUSH_H */
diff -puN include/asm-xtensa/tlbflush.h~remove-unused-flush_tlb_pgtables include/asm-xtensa/tlbflush.h
--- a/include/asm-xtensa/tlbflush.h~remove-unused-flush_tlb_pgtables
+++ a/include/asm-xtensa/tlbflush.h
@@ -41,17 +41,6 @@ extern void flush_tlb_range(struct vm_ar
 
 #define flush_tlb_kernel_range(start,end) flush_tlb_all()
 
-
-/* This is calld in munmap when we have freed up some page-table pages.
- * We don't need to do anything here, there's nothing special about our
- * page-table pages.
- */
-
-static inline void flush_tlb_pgtables(struct mm_struct *mm,
-                                      unsigned long start, unsigned long end)
-{
-}
-
 /* TLB operations. */
 
 static inline unsigned long itlb_probe(unsigned long addr)
diff -puN mm/memory.c~remove-unused-flush_tlb_pgtables mm/memory.c
--- a/mm/memory.c~remove-unused-flush_tlb_pgtables
+++ a/mm/memory.c
@@ -259,9 +259,6 @@ void free_pgd_range(struct mmu_gather **
 			continue;
 		free_pud_range(*tlb, pgd, addr, next, floor, ceiling);
 	} while (pgd++, addr = next, addr != end);
-
-	if (!(*tlb)->fullmm)
-		flush_tlb_pgtables((*tlb)->mm, start, end);
 }
 
 void free_pgtables(struct mmu_gather **tlb, struct vm_area_struct *vma,
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
report-the-per-irq-statistics-on-allarches.patch
add-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
delay-creation-of-khcvd-thread.patch
remove-unused-flush_tlb_pgtables.patch
x86_64-use-linux-elfcore-compath.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
intel-iommu-fix-for-iommu-early-crash-2.patch
add-scaled-time-to-taskstats-based-process-accounting.patch
add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch
powerpc-add-scaled-time-accounting.patch
powerpc-add-scaled-time-accounting-speedup.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-ppc64.patch
add-documentation-for-extended-crashkernel-syntax.patch
replace-__attribute_pure__-with-__pure.patch
