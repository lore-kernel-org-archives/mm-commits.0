From: akpm@linux-foundation.org
Subject: + mm-remove-pte_map_nested.patch added to -mm tree
Date: Tue, 21 Sep 2010 16:03:42 -0700
Message-ID: <201009212303.o8LN3gIR008075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab0IUXFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 19:05:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, rostedt@goodmis.org, tglx@linutronix.de


The patch titled
     mm: remove pte_*map_nested()
has been added to the -mm tree.  Its filename is
     mm-remove-pte_map_nested.patch

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
Subject: mm: remove pte_*map_nested()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Since we no longer need to provide KM_type, the whole pte_*map_nested()
API is now redundant, remove it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/pgtable.h         |    2 --
 arch/arm/include/asm/pgtable.h           |   14 ++++++--------
 arch/arm/mm/fault-armv.c                 |    4 ++--
 arch/arm/mm/pgd.c                        |    4 ++--
 arch/avr32/include/asm/pgtable.h         |    2 --
 arch/cris/include/asm/pgtable.h          |    2 --
 arch/frv/include/asm/pgtable.h           |    9 ++-------
 arch/ia64/include/asm/pgtable.h          |    2 --
 arch/m32r/include/asm/pgtable.h          |    2 --
 arch/m68k/include/asm/motorola_pgtable.h |    2 --
 arch/m68k/include/asm/sun3_pgtable.h     |    2 --
 arch/microblaze/include/asm/pgtable.h    |    7 ++-----
 arch/mips/include/asm/pgtable-32.h       |    3 ---
 arch/mips/include/asm/pgtable-64.h       |    3 ---
 arch/mn10300/include/asm/pgtable.h       |    2 --
 arch/parisc/include/asm/pgtable.h        |    2 --
 arch/powerpc/include/asm/pgtable-ppc32.h |    8 ++------
 arch/powerpc/include/asm/pgtable-ppc64.h |    2 --
 arch/s390/include/asm/pgtable.h          |    2 --
 arch/score/include/asm/pgtable.h         |    3 ---
 arch/sh/include/asm/pgtable_32.h         |    3 ---
 arch/sh/include/asm/pgtable_64.h         |    2 --
 arch/sparc/include/asm/pgtable_32.h      |    3 ---
 arch/sparc/include/asm/pgtable_64.h      |    2 --
 arch/tile/include/asm/pgtable.h          |    5 -----
 arch/um/include/asm/pgtable.h            |    2 --
 arch/x86/include/asm/pgtable_32.h        |   14 ++------------
 arch/x86/include/asm/pgtable_64.h        |    2 --
 arch/xtensa/include/asm/pgtable.h        |    3 ---
 mm/memory.c                              |    4 ++--
 mm/mremap.c                              |    4 ++--
 31 files changed, 22 insertions(+), 99 deletions(-)

diff -puN arch/alpha/include/asm/pgtable.h~mm-remove-pte_map_nested arch/alpha/include/asm/pgtable.h
--- a/arch/alpha/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/alpha/include/asm/pgtable.h
@@ -318,9 +318,7 @@ extern inline pte_t * pte_offset_kernel(
 }
 
 #define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
 #define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
 
 extern pgd_t swapper_pg_dir[1024];
 
diff -puN arch/arm/include/asm/pgtable.h~mm-remove-pte_map_nested arch/arm/include/asm/pgtable.h
--- a/arch/arm/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/arm/include/asm/pgtable.h
@@ -263,17 +263,15 @@ extern struct page *empty_zero_page;
 #define pte_page(pte)		(pfn_to_page(pte_pfn(pte)))
 #define pte_offset_kernel(dir,addr)	(pmd_page_vaddr(*(dir)) + __pte_index(addr))
 
-#define pte_offset_map(dir,addr)	(__pte_map(dir, KM_PTE0) + __pte_index(addr))
-#define pte_offset_map_nested(dir,addr)	(__pte_map(dir, KM_PTE1) + __pte_index(addr))
-#define pte_unmap(pte)			__pte_unmap(pte, KM_PTE0)
-#define pte_unmap_nested(pte)		__pte_unmap(pte, KM_PTE1)
+#define pte_offset_map(dir,addr)	(__pte_map(dir) + __pte_index(addr))
+#define pte_unmap(pte)			__pte_unmap(pte)
 
 #ifndef CONFIG_HIGHPTE
-#define __pte_map(dir,km)	pmd_page_vaddr(*(dir))
-#define __pte_unmap(pte,km)	do { } while (0)
+#define __pte_map(dir)		pmd_page_vaddr(*(dir))
+#define __pte_unmap(pte)	do { } while (0)
 #else
-#define __pte_map(dir,km)	((pte_t *)kmap_atomic(pmd_page(*(dir)), km) + PTRS_PER_PTE)
-#define __pte_unmap(pte,km)	kunmap_atomic((pte - PTRS_PER_PTE), km)
+#define __pte_map(dir)		((pte_t *)kmap_atomic(pmd_page(*(dir))) + PTRS_PER_PTE)
+#define __pte_unmap(pte)	kunmap_atomic((pte - PTRS_PER_PTE))
 #endif
 
 #define set_pte_ext(ptep,pte,ext) cpu_set_pte_ext(ptep,pte,ext)
diff -puN arch/arm/mm/fault-armv.c~mm-remove-pte_map_nested arch/arm/mm/fault-armv.c
--- a/arch/arm/mm/fault-armv.c~mm-remove-pte_map_nested
+++ a/arch/arm/mm/fault-armv.c
@@ -89,13 +89,13 @@ static int adjust_pte(struct vm_area_str
 	 * open-code the spin-locking.
 	 */
 	ptl = pte_lockptr(vma->vm_mm, pmd);
-	pte = pte_offset_map_nested(pmd, address);
+	pte = pte_offset_map(pmd, address);
 	spin_lock(ptl);
 
 	ret = do_adjust_pte(vma, address, pfn, pte);
 
 	spin_unlock(ptl);
-	pte_unmap_nested(pte);
+	pte_unmap(pte);
 
 	return ret;
 }
diff -puN arch/arm/mm/pgd.c~mm-remove-pte_map_nested arch/arm/mm/pgd.c
--- a/arch/arm/mm/pgd.c~mm-remove-pte_map_nested
+++ a/arch/arm/mm/pgd.c
@@ -57,9 +57,9 @@ pgd_t *get_pgd_slow(struct mm_struct *mm
 			goto no_pte;
 
 		init_pmd = pmd_offset(init_pgd, 0);
-		init_pte = pte_offset_map_nested(init_pmd, 0);
+		init_pte = pte_offset_map(init_pmd, 0);
 		set_pte_ext(new_pte, *init_pte, 0);
-		pte_unmap_nested(init_pte);
+		pte_unmap(init_pte);
 		pte_unmap(new_pte);
 	}
 
diff -puN arch/avr32/include/asm/pgtable.h~mm-remove-pte_map_nested arch/avr32/include/asm/pgtable.h
--- a/arch/avr32/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/avr32/include/asm/pgtable.h
@@ -319,9 +319,7 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_offset_kernel(dir, address)					\
 	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(address))
 #define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address) pte_offset_kernel(dir, address)
 #define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
 
 struct vm_area_struct;
 extern void update_mmu_cache(struct vm_area_struct * vma,
diff -puN arch/cris/include/asm/pgtable.h~mm-remove-pte_map_nested arch/cris/include/asm/pgtable.h
--- a/arch/cris/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/cris/include/asm/pgtable.h
@@ -248,10 +248,8 @@ static inline pgd_t * pgd_offset(const s
 	((pte_t *) pmd_page_vaddr(*(dir)) +  __pte_offset(address))
 #define pte_offset_map(dir, address) \
 	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
 
 #define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 #define pte_pfn(x)		((unsigned long)(__va((x).pte)) >> PAGE_SHIFT)
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
diff -puN arch/frv/include/asm/pgtable.h~mm-remove-pte_map_nested arch/frv/include/asm/pgtable.h
--- a/arch/frv/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/frv/include/asm/pgtable.h
@@ -451,17 +451,12 @@ static inline pte_t pte_modify(pte_t pte
 
 #if defined(CONFIG_HIGHPTE)
 #define pte_offset_map(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE0) + pte_index(address))
-#define pte_offset_map_nested(dir, address) \
-	((pte_t *)kmap_atomic(pmd_page(*(dir)),KM_PTE1) + pte_index(address))
-#define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+	((pte_t *)kmap_atomic(pmd_page(*(dir))) + pte_index(address))
+#define pte_unmap(pte) kunmap_atomic(pte)
 #else
 #define pte_offset_map(dir, address) \
 	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
 #define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 #endif
 
 /*
diff -puN arch/ia64/include/asm/pgtable.h~mm-remove-pte_map_nested arch/ia64/include/asm/pgtable.h
--- a/arch/ia64/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/ia64/include/asm/pgtable.h
@@ -406,9 +406,7 @@ pgd_offset (const struct mm_struct *mm, 
 #define pte_index(addr)	 	(((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1))
 #define pte_offset_kernel(dir,addr)	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
 #define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_offset_map_nested(dir,addr)	pte_offset_map(dir, addr)
 #define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
 
 /* atomic versions of the some PTE manipulations: */
 
diff -puN arch/m32r/include/asm/pgtable.h~mm-remove-pte_map_nested arch/m32r/include/asm/pgtable.h
--- a/arch/m32r/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/m32r/include/asm/pgtable.h
@@ -332,9 +332,7 @@ static inline void pmd_set(pmd_t * pmdp,
 	((pte_t *)pmd_page_vaddr(*(dir)) + pte_index(address))
 #define pte_offset_map(dir, address)	\
 	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address)	pte_offset_map(dir, address)
 #define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 2) & 0x1f)
diff -puN arch/m68k/include/asm/motorola_pgtable.h~mm-remove-pte_map_nested arch/m68k/include/asm/motorola_pgtable.h
--- a/arch/m68k/include/asm/motorola_pgtable.h~mm-remove-pte_map_nested
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -221,9 +221,7 @@ static inline pte_t *pte_offset_kernel(p
 }
 
 #define pte_offset_map(pmdp,address) ((pte_t *)__pmd_page(*pmdp) + (((address) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
-#define pte_offset_map_nested(pmdp, address) pte_offset_map(pmdp, address)
 #define pte_unmap(pte)		((void)0)
-#define pte_unmap_nested(pte)	((void)0)
 
 /*
  * Allocate and free page tables. The xxx_kernel() versions are
diff -puN arch/m68k/include/asm/sun3_pgtable.h~mm-remove-pte_map_nested arch/m68k/include/asm/sun3_pgtable.h
--- a/arch/m68k/include/asm/sun3_pgtable.h~mm-remove-pte_map_nested
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -219,9 +219,7 @@ static inline pte_t pgoff_to_pte(unsigne
 #define pte_offset_kernel(pmd, address) ((pte_t *) __pmd_page(*pmd) + pte_index(address))
 /* FIXME: should we bother with kmap() here? */
 #define pte_offset_map(pmd, address) ((pte_t *)kmap(pmd_page(*pmd)) + pte_index(address))
-#define pte_offset_map_nested(pmd, address) pte_offset_map(pmd, address)
 #define pte_unmap(pte) kunmap(pte)
-#define pte_unmap_nested(pte) kunmap(pte)
 
 /* Macros to (de)construct the fake PTEs representing swap pages. */
 #define __swp_type(x)		((x).val & 0x7F)
diff -puN arch/microblaze/include/asm/pgtable.h~mm-remove-pte_map_nested arch/microblaze/include/asm/pgtable.h
--- a/arch/microblaze/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/microblaze/include/asm/pgtable.h
@@ -504,12 +504,9 @@ static inline pmd_t *pmd_offset(pgd_t *d
 #define pte_offset_kernel(dir, addr)	\
 	((pte_t *) pmd_page_kernel(*(dir)) + pte_index(addr))
 #define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
-#define pte_offset_map_nested(dir, addr)	\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
+	((pte_t *) kmap_atomic(pmd_page(*(dir))) + pte_index(addr))
 
-#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
+#define pte_unmap(pte)		kunmap_atomic(pte)
 
 /* Encode and decode a nonlinear file mapping entry */
 #define PTE_FILE_MAX_BITS	29
diff -puN arch/mips/include/asm/pgtable-32.h~mm-remove-pte_map_nested arch/mips/include/asm/pgtable-32.h
--- a/arch/mips/include/asm/pgtable-32.h~mm-remove-pte_map_nested
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -154,10 +154,7 @@ pfn_pte(unsigned long pfn, pgprot_t prot
 
 #define pte_offset_map(dir, address)                                    \
 	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)                             \
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
 #define pte_unmap(pte) ((void)(pte))
-#define pte_unmap_nested(pte) ((void)(pte))
 
 #if defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX)
 
diff -puN arch/mips/include/asm/pgtable-64.h~mm-remove-pte_map_nested arch/mips/include/asm/pgtable-64.h
--- a/arch/mips/include/asm/pgtable-64.h~mm-remove-pte_map_nested
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -257,10 +257,7 @@ static inline pmd_t *pmd_offset(pud_t * 
 	((pte_t *) pmd_page_vaddr(*(dir)) + __pte_offset(address))
 #define pte_offset_map(dir, address)					\
 	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)				\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
 #define pte_unmap(pte) ((void)(pte))
-#define pte_unmap_nested(pte) ((void)(pte))
 
 /*
  * Initialize a new pgd / pmd table with invalid pointers.
diff -puN arch/mn10300/include/asm/pgtable.h~mm-remove-pte_map_nested arch/mn10300/include/asm/pgtable.h
--- a/arch/mn10300/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/mn10300/include/asm/pgtable.h
@@ -457,9 +457,7 @@ static inline int set_kernel_exec(unsign
 
 #define pte_offset_map(dir, address) \
 	((pte_t *) page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
 #define pte_unmap(pte)		do {} while (0)
-#define pte_unmap_nested(pte)	do {} while (0)
 
 /*
  * The MN10300 has external MMU info in the form of a TLB: this is adapted from
diff -puN arch/parisc/include/asm/pgtable.h~mm-remove-pte_map_nested arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/parisc/include/asm/pgtable.h
@@ -397,9 +397,7 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_offset_kernel(pmd, address) \
 	((pte_t *) pmd_page_vaddr(*(pmd)) + pte_index(address))
 #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
 #define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 
 #define pte_unmap(pte)			do { } while (0)
 #define pte_unmap_nested(pte)		do { } while (0)
diff -puN arch/powerpc/include/asm/pgtable-ppc32.h~mm-remove-pte_map_nested arch/powerpc/include/asm/pgtable-ppc32.h
--- a/arch/powerpc/include/asm/pgtable-ppc32.h~mm-remove-pte_map_nested
+++ a/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -308,12 +308,8 @@ static inline void __ptep_set_access_fla
 #define pte_offset_kernel(dir, addr)	\
 	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(addr))
 #define pte_offset_map(dir, addr)		\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE0) + pte_index(addr))
-#define pte_offset_map_nested(dir, addr)	\
-	((pte_t *) kmap_atomic(pmd_page(*(dir)), KM_PTE1) + pte_index(addr))
-
-#define pte_unmap(pte)		kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte)	kunmap_atomic(pte, KM_PTE1)
+	((pte_t *) kmap_atomic(pmd_page(*(dir))) + pte_index(addr))
+#define pte_unmap(pte)		kunmap_atomic(pte)
 
 /*
  * Encode and decode a swap entry.
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~mm-remove-pte_map_nested arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~mm-remove-pte_map_nested
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -193,9 +193,7 @@
   (((pte_t *) pmd_page_vaddr(*(dir))) + (((addr) >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 
 #define pte_offset_map(dir,addr)	pte_offset_kernel((dir), (addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir), (addr))
 #define pte_unmap(pte)			do { } while(0)
-#define pte_unmap_nested(pte)		do { } while(0)
 
 /* to find an entry in a kernel page-table-directory */
 /* This now only contains the vmalloc pages */
diff -puN arch/s390/include/asm/pgtable.h~mm-remove-pte_map_nested arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/s390/include/asm/pgtable.h
@@ -1066,9 +1066,7 @@ static inline pmd_t *pmd_offset(pud_t *p
 #define pte_offset(pmd, addr) ((pte_t *) pmd_deref(*(pmd)) + pte_index(addr))
 #define pte_offset_kernel(pmd, address) pte_offset(pmd,address)
 #define pte_offset_map(pmd, address) pte_offset_kernel(pmd, address)
-#define pte_offset_map_nested(pmd, address) pte_offset_kernel(pmd, address)
 #define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 
 /*
  * 31 bit swap entry format:
diff -puN arch/score/include/asm/pgtable.h~mm-remove-pte_map_nested arch/score/include/asm/pgtable.h
--- a/arch/score/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/score/include/asm/pgtable.h
@@ -88,10 +88,7 @@ static inline void pmd_clear(pmd_t *pmdp
 
 #define pte_offset_map(dir, address)	\
 	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
-#define pte_offset_map_nested(dir, address)	\
-	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
 #define pte_unmap(pte) ((void)(pte))
-#define pte_unmap_nested(pte) ((void)(pte))
 
 /*
  * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken,
diff -puN arch/sh/include/asm/pgtable_32.h~mm-remove-pte_map_nested arch/sh/include/asm/pgtable_32.h
--- a/arch/sh/include/asm/pgtable_32.h~mm-remove-pte_map_nested
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -429,10 +429,7 @@ static inline pte_t pte_modify(pte_t pte
 #define pte_offset_kernel(dir, address) \
 	((pte_t *) pmd_page_vaddr(*(dir)) + pte_index(address))
 #define pte_offset_map(dir, address)		pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address)	pte_offset_kernel(dir, address)
-
 #define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
 
 #ifdef CONFIG_X2TLB
 #define pte_ERROR(e) \
diff -puN arch/sh/include/asm/pgtable_64.h~mm-remove-pte_map_nested arch/sh/include/asm/pgtable_64.h
--- a/arch/sh/include/asm/pgtable_64.h~mm-remove-pte_map_nested
+++ a/arch/sh/include/asm/pgtable_64.h
@@ -84,9 +84,7 @@ static __inline__ void set_pte(pte_t *pt
 		((pte_t *) ((pmd_val(*(dir))) & PAGE_MASK) + pte_index((addr)))
 
 #define pte_offset_map(dir,addr)	pte_offset_kernel(dir, addr)
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel(dir, addr)
 #define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
 
 #ifndef __ASSEMBLY__
 #define IOBASE_VADDR	0xff000000
diff -puN arch/sparc/include/asm/pgtable_32.h~mm-remove-pte_map_nested arch/sparc/include/asm/pgtable_32.h
--- a/arch/sparc/include/asm/pgtable_32.h~mm-remove-pte_map_nested
+++ a/arch/sparc/include/asm/pgtable_32.h
@@ -304,10 +304,7 @@ BTFIXUPDEF_CALL(pte_t *, pte_offset_kern
  * and sun4c is guaranteed to have no highmem anyway.
  */
 #define pte_offset_map(d, a)		pte_offset_kernel(d,a)
-#define pte_offset_map_nested(d, a)	pte_offset_kernel(d,a)
-
 #define pte_unmap(pte)		do{}while(0)
-#define pte_unmap_nested(pte)	do{}while(0)
 
 /* Certain architectures need to do special things when pte's
  * within a page table are directly modified.  Thus, the following
diff -puN arch/sparc/include/asm/pgtable_64.h~mm-remove-pte_map_nested arch/sparc/include/asm/pgtable_64.h
--- a/arch/sparc/include/asm/pgtable_64.h~mm-remove-pte_map_nested
+++ a/arch/sparc/include/asm/pgtable_64.h
@@ -652,9 +652,7 @@ static inline int pte_special(pte_t pte)
 	 ((address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1)))
 #define pte_offset_kernel		pte_index
 #define pte_offset_map			pte_index
-#define pte_offset_map_nested		pte_index
 #define pte_unmap(pte)			do { } while (0)
-#define pte_unmap_nested(pte)		do { } while (0)
 
 /* Actual page table PTE updates.  */
 extern void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr, pte_t *ptep, pte_t orig);
diff -puN arch/tile/include/asm/pgtable.h~mm-remove-pte_map_nested arch/tile/include/asm/pgtable.h
--- a/arch/tile/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/tile/include/asm/pgtable.h
@@ -347,15 +347,10 @@ static inline pte_t pte_modify(pte_t pte
 extern pte_t *_pte_offset_map(pmd_t *, unsigned long address, enum km_type);
 #define pte_offset_map(dir, address) \
 	_pte_offset_map(dir, address, KM_PTE0)
-#define pte_offset_map_nested(dir, address) \
-	_pte_offset_map(dir, address, KM_PTE1)
 #define pte_unmap(pte) kunmap_atomic(pte, KM_PTE0)
-#define pte_unmap_nested(pte) kunmap_atomic(pte, KM_PTE1)
 #else
 #define pte_offset_map(dir, address) pte_offset_kernel(dir, address)
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
 #define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 #endif
 
 /* Clear a non-executable kernel PTE and flush it from the TLB. */
diff -puN arch/um/include/asm/pgtable.h~mm-remove-pte_map_nested arch/um/include/asm/pgtable.h
--- a/arch/um/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/um/include/asm/pgtable.h
@@ -338,9 +338,7 @@ static inline pte_t pte_modify(pte_t pte
 	((pte_t *) pmd_page_vaddr(*(dir)) +  pte_index(address))
 #define pte_offset_map(dir, address) \
 	((pte_t *)page_address(pmd_page(*(dir))) + pte_index(address))
-#define pte_offset_map_nested(dir, address) pte_offset_map(dir, address)
 #define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 
 struct mm_struct;
 extern pte_t *virt_to_pte(struct mm_struct *mm, unsigned long addr);
diff -puN arch/x86/include/asm/pgtable_32.h~mm-remove-pte_map_nested arch/x86/include/asm/pgtable_32.h
--- a/arch/x86/include/asm/pgtable_32.h~mm-remove-pte_map_nested
+++ a/arch/x86/include/asm/pgtable_32.h
@@ -49,24 +49,14 @@ extern void set_pmd_pfn(unsigned long, u
 #endif
 
 #if defined(CONFIG_HIGHPTE)
-#define __KM_PTE			\
-	(in_nmi() ? KM_NMI_PTE : 	\
-	 in_irq() ? KM_IRQ_PTE :	\
-	 KM_PTE0)
 #define pte_offset_map(dir, address)					\
-	((pte_t *)kmap_atomic(pmd_page(*(dir)), __KM_PTE) +		\
+	((pte_t *)kmap_atomic(pmd_page(*(dir))) +		\
 	 pte_index((address)))
-#define pte_offset_map_nested(dir, address)				\
-	((pte_t *)kmap_atomic(pmd_page(*(dir)), KM_PTE1) +		\
-	 pte_index((address)))
-#define pte_unmap(pte) kunmap_atomic((pte), __KM_PTE)
-#define pte_unmap_nested(pte) kunmap_atomic((pte), KM_PTE1)
+#define pte_unmap(pte) kunmap_atomic((pte))
 #else
 #define pte_offset_map(dir, address)					\
 	((pte_t *)page_address(pmd_page(*(dir))) + pte_index((address)))
-#define pte_offset_map_nested(dir, address) pte_offset_map((dir), (address))
 #define pte_unmap(pte) do { } while (0)
-#define pte_unmap_nested(pte) do { } while (0)
 #endif
 
 /* Clear a kernel PTE and flush it from the TLB */
diff -puN arch/x86/include/asm/pgtable_64.h~mm-remove-pte_map_nested arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~mm-remove-pte_map_nested
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -127,9 +127,7 @@ static inline int pgd_large(pgd_t pgd) {
 
 /* x86-64 always has all page tables mapped. */
 #define pte_offset_map(dir, address) pte_offset_kernel((dir), (address))
-#define pte_offset_map_nested(dir, address) pte_offset_kernel((dir), (address))
 #define pte_unmap(pte) ((void)(pte))/* NOP */
-#define pte_unmap_nested(pte) ((void)(pte)) /* NOP */
 
 #define update_mmu_cache(vma, address, ptep) do { } while (0)
 
diff -puN arch/xtensa/include/asm/pgtable.h~mm-remove-pte_map_nested arch/xtensa/include/asm/pgtable.h
--- a/arch/xtensa/include/asm/pgtable.h~mm-remove-pte_map_nested
+++ a/arch/xtensa/include/asm/pgtable.h
@@ -324,10 +324,7 @@ ptep_set_wrprotect(struct mm_struct *mm,
 #define pte_offset_kernel(dir,addr) 					\
 	((pte_t*) pmd_page_vaddr(*(dir)) + pte_index(addr))
 #define pte_offset_map(dir,addr)	pte_offset_kernel((dir),(addr))
-#define pte_offset_map_nested(dir,addr)	pte_offset_kernel((dir),(addr))
-
 #define pte_unmap(pte)		do { } while (0)
-#define pte_unmap_nested(pte)	do { } while (0)
 
 
 /*
diff -puN mm/memory.c~mm-remove-pte_map_nested mm/memory.c
--- a/mm/memory.c~mm-remove-pte_map_nested
+++ a/mm/memory.c
@@ -736,7 +736,7 @@ again:
 	dst_pte = pte_alloc_map_lock(dst_mm, dst_pmd, addr, &dst_ptl);
 	if (!dst_pte)
 		return -ENOMEM;
-	src_pte = pte_offset_map_nested(src_pmd, addr);
+	src_pte = pte_offset_map(src_pmd, addr);
 	src_ptl = pte_lockptr(src_mm, src_pmd);
 	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 	orig_src_pte = src_pte;
@@ -767,7 +767,7 @@ again:
 
 	arch_leave_lazy_mmu_mode();
 	spin_unlock(src_ptl);
-	pte_unmap_nested(orig_src_pte);
+	pte_unmap(orig_src_pte);
 	add_mm_rss_vec(dst_mm, rss);
 	pte_unmap_unlock(orig_dst_pte, dst_ptl);
 	cond_resched();
diff -puN mm/mremap.c~mm-remove-pte_map_nested mm/mremap.c
--- a/mm/mremap.c~mm-remove-pte_map_nested
+++ a/mm/mremap.c
@@ -101,7 +101,7 @@ static void move_ptes(struct vm_area_str
 	 * pte locks because exclusive mmap_sem prevents deadlock.
 	 */
 	old_pte = pte_offset_map_lock(mm, old_pmd, old_addr, &old_ptl);
- 	new_pte = pte_offset_map_nested(new_pmd, new_addr);
+	new_pte = pte_offset_map(new_pmd, new_addr);
 	new_ptl = pte_lockptr(mm, new_pmd);
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
@@ -119,7 +119,7 @@ static void move_ptes(struct vm_area_str
 	arch_leave_lazy_mmu_mode();
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
-	pte_unmap_nested(new_pte - 1);
+	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
 	if (mapping)
 		spin_unlock(&mapping->i_mmap_lock);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

linux-next.patch
gcc-46-perf-fix-set-but-unused-variables-in-perf.patch
mm-strictly-nested-kmap_atomic.patch
mm-stack-based-kmap_atomic.patch
mm-stack-based-kmap_atomic-checkpatch-fixes.patch
mm-remove-pte_map_nested.patch
perf-x86-fix-up-kmap_atomic-type.patch
mm-highmem-documentation.patch
kernel-remove-pf_flusher.patch

