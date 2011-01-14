From: akpm@linux-foundation.org
Subject: [merged] thp-add-pmd-mangling-generic-functions.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:46:51 -0800
Message-ID: <201101142249.p0EMnfjP005314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753795Ab1ANWts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: add pmd mangling generic functions
has been removed from the -mm tree.  Its filename was
     thp-add-pmd-mangling-generic-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: add pmd mangling generic functions
From: Andrea Arcangeli <aarcange@redhat.com>

Some are needed to build but not actually used on archs not supporting
transparent hugepages.  Others like pmdp_clear_flush are used by x86 too.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |  214 +++++++++++++++++++++++---------
 mm/Makefile                   |    2 
 mm/pgtable-generic.c          |  123 ++++++++++++++++++
 3 files changed, 278 insertions(+), 61 deletions(-)

diff -puN include/asm-generic/pgtable.h~thp-add-pmd-mangling-generic-functions include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~thp-add-pmd-mangling-generic-functions
+++ a/include/asm-generic/pgtable.h
@@ -5,67 +5,108 @@
 #ifdef CONFIG_MMU
 
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
-/*
- * Largely same as above, but only sets the access flags (dirty,
- * accessed, and writable). Furthermore, we know it always gets set
- * to a "more permissive" setting, which allows most architectures
- * to optimize this. We return whether the PTE actually changed, which
- * in turn instructs the caller to do things like update__mmu_cache.
- * This used to be done in the caller, but sparc needs minor faults to
- * force that call on sun4c so we changed this macro slightly
- */
-#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-({									  \
-	int __changed = !pte_same(*(__ptep), __entry);			  \
-	if (__changed) {						  \
-		set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry); \
-		flush_tlb_page(__vma, __address);			  \
-	}								  \
-	__changed;							  \
-})
+extern int ptep_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pte_t *ptep,
+				 pte_t entry, int dirty);
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
+extern int pmdp_set_access_flags(struct vm_area_struct *vma,
+				 unsigned long address, pmd_t *pmdp,
+				 pmd_t entry, int dirty);
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
-#define ptep_test_and_clear_young(__vma, __address, __ptep)		\
-({									\
-	pte_t __pte = *(__ptep);					\
-	int r = 1;							\
-	if (!pte_young(__pte))						\
-		r = 0;							\
-	else								\
-		set_pte_at((__vma)->vm_mm, (__address),			\
-			   (__ptep), pte_mkold(__pte));			\
-	r;								\
-})
+static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	int r = 1;
+	if (!pte_young(pte))
+		r = 0;
+	else
+		set_pte_at(vma->vm_mm, address, ptep, pte_mkold(pte));
+	return r;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+	int r = 1;
+	if (!pmd_young(pmd))
+		r = 0;
+	else
+		set_pmd_at(vma->vm_mm, address, pmdp, pmd_mkold(pmd));
+	return r;
+}
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
+static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pmd_t *pmdp)
+{
+	BUG();
+	return 0;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-#define ptep_clear_flush_young(__vma, __address, __ptep)		\
-({									\
-	int __young;							\
-	__young = ptep_test_and_clear_young(__vma, __address, __ptep);	\
-	if (__young)							\
-		flush_tlb_page(__vma, __address);			\
-	__young;							\
-})
+int ptep_clear_flush_young(struct vm_area_struct *vma,
+			   unsigned long address, pte_t *ptep);
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
+int pmdp_clear_flush_young(struct vm_area_struct *vma,
+			   unsigned long address, pmd_t *pmdp);
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR
-#define ptep_get_and_clear(__mm, __address, __ptep)			\
-({									\
-	pte_t __pte = *(__ptep);					\
-	pte_clear((__mm), (__address), (__ptep));			\
-	__pte;								\
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
+				       unsigned long address,
+				       pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	pte_clear(mm, address, ptep);
+	return pte;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_GET_AND_CLEAR
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
+				       unsigned long address,
+				       pmd_t *pmdp)
+{
+	pmd_t pmd = *pmdp;
+	pmd_clear(mm, address, pmdp);
+	return pmd;
 })
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
+static inline pmd_t pmdp_get_and_clear(struct mm_struct *mm,
+				       unsigned long address,
+				       pmd_t *pmdp)
+{
+	BUG();
+	return __pmd(0);
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_GET_AND_CLEAR_FULL
-#define ptep_get_and_clear_full(__mm, __address, __ptep, __full)	\
-({									\
-	pte_t __pte;							\
-	__pte = ptep_get_and_clear((__mm), (__address), (__ptep));	\
-	__pte;								\
-})
+static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
+					    unsigned long address, pte_t *ptep,
+					    int full)
+{
+	pte_t pte;
+	pte = ptep_get_and_clear(mm, address, ptep);
+	return pte;
+}
 #endif
 
 /*
@@ -74,20 +115,25 @@
  * not present, or in the process of an address space destruction.
  */
 #ifndef __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-#define pte_clear_not_present_full(__mm, __address, __ptep, __full)	\
-do {									\
-	pte_clear((__mm), (__address), (__ptep));			\
-} while (0)
+static inline void pte_clear_not_present_full(struct mm_struct *mm,
+					      unsigned long address,
+					      pte_t *ptep,
+					      int full)
+{
+	pte_clear(mm, address, ptep);
+}
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
-#define ptep_clear_flush(__vma, __address, __ptep)			\
-({									\
-	pte_t __pte;							\
-	__pte = ptep_get_and_clear((__vma)->vm_mm, __address, __ptep);	\
-	flush_tlb_page(__vma, __address);				\
-	__pte;								\
-})
+extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pte_t *ptep);
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_CLEAR_FLUSH
+extern pmd_t pmdp_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pmd_t *pmdp);
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_SET_WRPROTECT
@@ -99,8 +145,49 @@ static inline void ptep_set_wrprotect(st
 }
 #endif
 
+#ifndef __HAVE_ARCH_PMDP_SET_WRPROTECT
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline void pmdp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pmd_t *pmdp)
+{
+	pmd_t old_pmd = *pmdp;
+	set_pmd_at(mm, address, pmdp, pmd_wrprotect(old_pmd));
+}
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
+static inline void pmdp_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pmd_t *pmdp)
+{
+	BUG();
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+extern pmd_t pmdp_clear_flush(struct vm_area_struct *vma,
+			      unsigned long address,
+			      pmd_t *pmdp);
+#endif
+
 #ifndef __HAVE_ARCH_PTE_SAME
-#define pte_same(A,B)	(pte_val(A) == pte_val(B))
+static inline int pte_same(pte_t pte_a, pte_t pte_b)
+{
+	return pte_val(pte_a) == pte_val(pte_b);
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMD_SAME
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
+{
+	return pmd_val(pmd_a) == pmd_val(pmd_b);
+}
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
+static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
+{
+	BUG();
+	return 0;
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
 #ifndef __HAVE_ARCH_PAGE_TEST_DIRTY
@@ -357,6 +444,13 @@ static inline int pmd_trans_splitting(pm
 {
 	return 0;
 }
+#ifndef __HAVE_ARCH_PMD_WRITE
+static inline int pmd_write(pmd_t pmd)
+{
+	BUG();
+	return 0;
+}
+#endif /* __HAVE_ARCH_PMD_WRITE */
 #endif
 
 #endif /* !__ASSEMBLY__ */
diff -puN mm/Makefile~thp-add-pmd-mangling-generic-functions mm/Makefile
--- a/mm/Makefile~thp-add-pmd-mangling-generic-functions
+++ a/mm/Makefile
@@ -5,7 +5,7 @@
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   mlock.o mmap.o mprotect.o mremap.o msync.o rmap.o \
-			   vmalloc.o pagewalk.o
+			   vmalloc.o pagewalk.o pgtable-generic.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
diff -puN /dev/null mm/pgtable-generic.c
--- /dev/null
+++ a/mm/pgtable-generic.c
@@ -0,0 +1,123 @@
+/*
+ *  mm/pgtable-generic.c
+ *
+ *  Generic pgtable methods declared in asm-generic/pgtable.h
+ *
+ *  Copyright (C) 2010  Linus Torvalds
+ */
+
+#include <asm/tlb.h>
+#include <asm-generic/pgtable.h>
+
+#ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+/*
+ * Only sets the access flags (dirty, accessed, and
+ * writable). Furthermore, we know it always gets set to a "more
+ * permissive" setting, which allows most architectures to optimize
+ * this. We return whether the PTE actually changed, which in turn
+ * instructs the caller to do things like update__mmu_cache.  This
+ * used to be done in the caller, but sparc needs minor faults to
+ * force that call on sun4c so we changed this macro slightly
+ */
+int ptep_set_access_flags(struct vm_area_struct *vma,
+			  unsigned long address, pte_t *ptep,
+			  pte_t entry, int dirty)
+{
+	int changed = !pte_same(*ptep, entry);
+	if (changed) {
+		set_pte_at(vma->vm_mm, address, ptep, entry);
+		flush_tlb_page(vma, address);
+	}
+	return changed;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
+int pmdp_set_access_flags(struct vm_area_struct *vma,
+			  unsigned long address, pmd_t *pmdp,
+			  pmd_t entry, int dirty)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	int changed = !pmd_same(*pmdp, entry);
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	if (changed) {
+		set_pmd_at(vma->vm_mm, address, pmdp, entry);
+		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	}
+	return changed;
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
+	BUG();
+	return 0;
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+}
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+int ptep_clear_flush_young(struct vm_area_struct *vma,
+			   unsigned long address, pte_t *ptep)
+{
+	int young;
+	young = ptep_test_and_clear_young(vma, address, ptep);
+	if (young)
+		flush_tlb_page(vma, address);
+	return young;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
+int pmdp_clear_flush_young(struct vm_area_struct *vma,
+			   unsigned long address, pmd_t *pmdp)
+{
+	int young;
+#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+	BUG();
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	young = pmdp_test_and_clear_young(vma, address, pmdp);
+	if (young)
+		flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	return young;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
+pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long address,
+		       pte_t *ptep)
+{
+	pte_t pte;
+	pte = ptep_get_and_clear((vma)->vm_mm, address, ptep);
+	flush_tlb_page(vma, address);
+	return pte;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_CLEAR_FLUSH
+pmd_t pmdp_clear_flush(struct vm_area_struct *vma, unsigned long address,
+		       pmd_t *pmdp)
+{
+	pmd_t pmd;
+#ifndef CONFIG_TRANSPARENT_HUGEPAGE
+	BUG();
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	pmd = pmdp_get_and_clear(vma->vm_mm, address, pmdp);
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+	return pmd;
+}
+#endif
+
+#ifndef __HAVE_ARCH_PMDP_SPLITTING_FLUSH
+pmd_t pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
+			   pmd_t *pmdp)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	pmd_t pmd = pmd_mksplitting(*pmdp);
+	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
+	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
+	/* tlb flush only to serialize against gup-fast */
+	flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
+#else /* CONFIG_TRANSPARENT_HUGEPAGE */
+	BUG();
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+}
+#endif
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

