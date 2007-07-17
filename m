From: akpm@linux-foundation.org
Subject: - mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:28 -0700
Message-ID: <200707172300.l6HN0S2U011301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37404 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936019AbXGQXBM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove ptep_test_and_clear_dirty and ptep_clear_flush_dirty
has been removed from the -mm tree.  Its filename was
     mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: remove ptep_test_and_clear_dirty and ptep_clear_flush_dirty
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Nobody is using ptep_test_and_clear_dirty and ptep_clear_flush_dirty.  Remove
the functions from all architectures.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/pgtable.h           |    8 ------
 include/asm-generic/pgtable.h       |   25 --------------------
 include/asm-i386/pgtable.h          |   21 -----------------
 include/asm-ia64/pgtable.h          |   17 --------------
 include/asm-m32r/pgtable.h          |    6 -----
 include/asm-parisc/pgtable.h        |   16 -------------
 include/asm-powerpc/pgtable-ppc32.h |    7 -----
 include/asm-powerpc/pgtable-ppc64.h |   31 --------------------------
 include/asm-ppc/pgtable.h           |    7 -----
 include/asm-s390/pgtable.h          |   15 ------------
 include/asm-x86_64/pgtable.h        |    8 ------
 include/asm-xtensa/pgtable.h        |   12 ----------
 12 files changed, 173 deletions(-)

diff -puN include/asm-frv/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-frv/pgtable.h
--- a/include/asm-frv/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-frv/pgtable.h
@@ -388,13 +388,6 @@ static inline pte_t pte_mkdirty(pte_t pt
 static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte &= ~_PAGE_WP; return pte; }
 
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	int i = test_and_clear_bit(_PAGE_BIT_DIRTY, ptep);
-	asm volatile("dcf %M0" :: "U"(*ptep));
-	return i;
-}
-
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
 	int i = test_and_clear_bit(_PAGE_BIT_ACCESSED, ptep);
@@ -504,7 +497,6 @@ static inline int pte_file(pte_t pte)
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
diff -puN include/asm-generic/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-generic/pgtable.h
@@ -49,31 +49,6 @@
 })
 #endif
 
-#ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-#define ptep_test_and_clear_dirty(__vma, __address, __ptep)		\
-({									\
-	pte_t __pte = *__ptep;						\
-	int r = 1;							\
-	if (!pte_dirty(__pte))						\
-		r = 0;							\
-	else								\
-		set_pte_at((__vma)->vm_mm, (__address), (__ptep),	\
-			   pte_mkclean(__pte));				\
-	r;								\
-})
-#endif
-
-#ifndef __HAVE_ARCH_PTEP_CLEAR_DIRTY_FLUSH
-#define ptep_clear_flush_dirty(__vma, __address, __ptep)		\
-({									\
-	int __dirty;							\
-	__dirty = ptep_test_and_clear_dirty(__vma, __address, __ptep);	\
-	if (__dirty)							\
-		flush_tlb_page(__vma, __address);			\
-	__dirty;							\
-})
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define ptep_get_and_clear(__mm, __address, __ptep)			\
 ({									\
diff -puN include/asm-i386/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-i386/pgtable.h
@@ -289,17 +289,6 @@ static inline pte_t native_local_ptep_ge
 	__changed;							\
 })
 
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-#define ptep_test_and_clear_dirty(vma, addr, ptep) ({			\
-	int __ret = 0;							\
-	if (pte_dirty(*(ptep)))						\
-		__ret = test_and_clear_bit(_PAGE_BIT_DIRTY,		\
-						&(ptep)->pte_low);	\
-	if (__ret)							\
-		pte_update((vma)->vm_mm, addr, ptep);			\
-	__ret;								\
-})
-
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define ptep_test_and_clear_young(vma, addr, ptep) ({			\
 	int __ret = 0;							\
@@ -311,16 +300,6 @@ static inline pte_t native_local_ptep_ge
 	__ret;								\
 })
 
-#define __HAVE_ARCH_PTEP_CLEAR_DIRTY_FLUSH
-#define ptep_clear_flush_dirty(vma, address, ptep)			\
-({									\
-	int __dirty;							\
-	__dirty = ptep_test_and_clear_dirty((vma), (address), (ptep));	\
-	if (__dirty)							\
-		flush_tlb_page(vma, address);				\
-	__dirty;							\
-})
-
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young(vma, address, ptep)			\
 ({									\
diff -puN include/asm-ia64/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-ia64/pgtable.h
@@ -395,22 +395,6 @@ ptep_test_and_clear_young (struct vm_are
 #endif
 }
 
-static inline int
-ptep_test_and_clear_dirty (struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-#ifdef CONFIG_SMP
-	if (!pte_dirty(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_D_BIT, ptep);
-#else
-	pte_t pte = *ptep;
-	if (!pte_dirty(pte))
-		return 0;
-	set_pte_at(vma->vm_mm, addr, ptep, pte_mkclean(pte));
-	return 1;
-#endif
-}
-
 static inline pte_t
 ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
@@ -590,7 +574,6 @@ extern void lazy_mmu_prot_update (pte_t 
 #endif
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
diff -puN include/asm-m32r/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-m32r/pgtable.h
--- a/include/asm-m32r/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-m32r/pgtable.h
@@ -250,11 +250,6 @@ static inline pte_t pte_mkwrite(pte_t pt
 	return pte;
 }
 
-static inline  int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	return test_and_clear_bit(_PAGE_BIT_DIRTY, ptep);
-}
-
 static inline  int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
 	return test_and_clear_bit(_PAGE_BIT_ACCESSED, ptep);
@@ -348,7 +343,6 @@ static inline void pmd_set(pmd_t * pmdp,
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
diff -puN include/asm-parisc/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-parisc/pgtable.h
--- a/include/asm-parisc/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-parisc/pgtable.h
@@ -447,21 +447,6 @@ static inline int ptep_test_and_clear_yo
 #endif
 }
 
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-#ifdef CONFIG_SMP
-	if (!pte_dirty(*ptep))
-		return 0;
-	return test_and_clear_bit(xlate_pabit(_PAGE_DIRTY_BIT), &pte_val(*ptep));
-#else
-	pte_t pte = *ptep;
-	if (!pte_dirty(pte))
-		return 0;
-	set_pte_at(vma->vm_mm, addr, ptep, pte_mkclean(pte));
-	return 1;
-#endif
-}
-
 extern spinlock_t pa_dbit_lock;
 
 struct mm_struct;
@@ -529,7 +514,6 @@ static inline void ptep_set_wrprotect(st
 #define HAVE_ARCH_UNMAPPED_AREA
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTE_SAME
diff -puN include/asm-powerpc/pgtable-ppc32.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-powerpc/pgtable-ppc32.h
--- a/include/asm-powerpc/pgtable-ppc32.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-powerpc/pgtable-ppc32.h
@@ -621,13 +621,6 @@ static inline int __ptep_test_and_clear_
 #define ptep_test_and_clear_young(__vma, __addr, __ptep) \
 	__ptep_test_and_clear_young((__vma)->vm_mm->context.id, __addr, __ptep)
 
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
-{
-	return (pte_update(ptep, (_PAGE_DIRTY | _PAGE_HWWRITE), 0) & _PAGE_DIRTY) != 0;
-}
-
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
diff -puN include/asm-powerpc/pgtable-ppc64.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -292,29 +292,6 @@ static inline int __ptep_test_and_clear_
 	__r;								   \
 })
 
-/*
- * On RW/DIRTY bit transitions we can avoid flushing the hpte. For the
- * moment we always flush but we need to fix hpte_update and test if the
- * optimisation is worth it.
- */
-static inline int __ptep_test_and_clear_dirty(struct mm_struct *mm,
-					      unsigned long addr, pte_t *ptep)
-{
-	unsigned long old;
-
-       	if ((pte_val(*ptep) & _PAGE_DIRTY) == 0)
-		return 0;
-	old = pte_update(mm, addr, ptep, _PAGE_DIRTY, 0);
-	return (old & _PAGE_DIRTY) != 0;
-}
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-#define ptep_test_and_clear_dirty(__vma, __addr, __ptep)		   \
-({									   \
-	int __r;							   \
-	__r = __ptep_test_and_clear_dirty((__vma)->vm_mm, __addr, __ptep); \
-	__r;								   \
-})
-
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 				      pte_t *ptep)
@@ -342,14 +319,6 @@ static inline void ptep_set_wrprotect(st
 	__young;							\
 })
 
-#define __HAVE_ARCH_PTEP_CLEAR_DIRTY_FLUSH
-#define ptep_clear_flush_dirty(__vma, __address, __ptep)		\
-({									\
-	int __dirty = __ptep_test_and_clear_dirty((__vma)->vm_mm, __address, \
-						  __ptep); 		\
-	__dirty;							\
-})
-
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pte_t *ptep)
diff -puN include/asm-ppc/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-ppc/pgtable.h
--- a/include/asm-ppc/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-ppc/pgtable.h
@@ -654,13 +654,6 @@ static inline int __ptep_test_and_clear_
 #define ptep_test_and_clear_young(__vma, __addr, __ptep) \
 	__ptep_test_and_clear_young((__vma)->vm_mm->context.id, __addr, __ptep)
 
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep)
-{
-	return (pte_update(ptep, (_PAGE_DIRTY | _PAGE_HWWRITE), 0) & _PAGE_DIRTY) != 0;
-}
-
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
diff -puN include/asm-s390/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-s390/pgtable.h
--- a/include/asm-s390/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-s390/pgtable.h
@@ -669,19 +669,6 @@ ptep_clear_flush_young(struct vm_area_st
 	return ptep_test_and_clear_young(vma, address, ptep);
 }
 
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	return 0;
-}
-
-static inline int
-ptep_clear_flush_dirty(struct vm_area_struct *vma,
-			unsigned long address, pte_t *ptep)
-{
-	/* No need to flush TLB; bits are in storage key */
-	return ptep_test_and_clear_dirty(vma, address, ptep);
-}
-
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	pte_t pte = *ptep;
@@ -939,8 +926,6 @@ extern void memmap_init(unsigned long, i
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
-#define __HAVE_ARCH_PTEP_CLEAR_DIRTY_FLUSH
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_CLEAR_FLUSH
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
diff -puN include/asm-x86_64/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-x86_64/pgtable.h
@@ -284,13 +284,6 @@ static inline pte_t pte_clrhuge(pte_t pt
 
 struct vm_area_struct;
 
-static inline int ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
-{
-	if (!pte_dirty(*ptep))
-		return 0;
-	return test_and_clear_bit(_PAGE_BIT_DIRTY, &ptep->pte);
-}
-
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
 {
 	if (!pte_young(*ptep))
@@ -427,7 +420,6 @@ extern int kern_addr_valid(unsigned long
    (((o) & (1UL << (__VIRTUAL_MASK_SHIFT-1))) ? ((o) | (~__VIRTUAL_MASK)) : (o))
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
diff -puN include/asm-xtensa/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty include/asm-xtensa/pgtable.h
--- a/include/asm-xtensa/pgtable.h~mm-remove-ptep_test_and_clear_dirty-and-ptep_clear_flush_dirty
+++ a/include/asm-xtensa/pgtable.h
@@ -267,17 +267,6 @@ ptep_test_and_clear_young(struct vm_area
 	return 1;
 }
 
-static inline int
-ptep_test_and_clear_dirty(struct vm_area_struct *vma, unsigned long addr,
-   			  pte_t *ptep)
-{
-	pte_t pte = *ptep;
-	if (!pte_dirty(pte))
-		return 0;
-	update_pte(ptep, pte_mkclean(pte));
-	return 1;
-}
-
 static inline pte_t
 ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
@@ -418,7 +407,6 @@ typedef pte_t *pte_addr_t;
 #endif /* !defined (__ASSEMBLY__) */
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define __HAVE_ARCH_PTEP_MKDIRTY
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

origin.patch
git-s390.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
