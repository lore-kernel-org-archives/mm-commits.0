From: akpm@linux-foundation.org
Subject: - rework-ptep_set_access_flags-and-fix-sun4c.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:39 -0700
Message-ID: <200706231927.l5NJRdhg022075@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37750 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752926AbXFWTcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: benh@kernel.crashing.org, davem@davemloft.net, hugh@veritas.com, mark@mtfhpc.demon.co.uk, tony.luck@intel.com, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     Rework ptep_set_access_flags and fix sun4c
has been removed from the -mm tree.  Its filename was
     rework-ptep_set_access_flags-and-fix-sun4c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Rework ptep_set_access_flags and fix sun4c
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Some changes done a while ago to avoid pounding on ptep_set_access_flags and
update_mmu_cache in some race situations break sun4c which requires
update_mmu_cache() to always be called on minor faults.

This patch reworks ptep_set_access_flags() semantics, implementations and
callers so that it's now responsible for returning whether an update is
necessary or not (basically whether the PTE actually changed).  This allow
fixing the sparc implementation to always return 1 on sun4c.

[akpm@linux-foundation.org: fixes, cleanups]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: David Miller <davem@davemloft.net>
Cc: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Acked-by: William Lee Irwin III <wli@holomorphy.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h       |   17 ++++++++++++-----
 include/asm-i386/pgtable.h          |    8 +++++---
 include/asm-ia64/pgtable.h          |   25 ++++++++++++++++---------
 include/asm-powerpc/pgtable-ppc32.h |   12 ++++++++----
 include/asm-powerpc/pgtable-ppc64.h |   12 ++++++++----
 include/asm-ppc/pgtable.h           |   12 ++++++++----
 include/asm-s390/pgtable.h          |    7 ++++++-
 include/asm-sparc/pgtable.h         |   11 +++++++++++
 include/asm-x86_64/pgtable.h        |   14 ++++++++------
 mm/hugetlb.c                        |    7 ++++---
 mm/memory.c                         |   13 ++++++-------
 11 files changed, 92 insertions(+), 46 deletions(-)

diff -puN include/asm-generic/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-generic/pgtable.h
@@ -27,13 +27,20 @@ do {				  					\
  * Largely same as above, but only sets the access flags (dirty,
  * accessed, and writable). Furthermore, we know it always gets set
  * to a "more permissive" setting, which allows most architectures
- * to optimize this.
+ * to optimize this. We return whether the PTE actually changed, which
+ * in turn instructs the caller to do things like update__mmu_cache.
+ * This used to be done in the caller, but sparc needs minor faults to
+ * force that call on sun4c so we changed this macro slightly
  */
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-do {				  					  \
-	set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry);	  \
-	flush_tlb_page(__vma, __address);				  \
-} while (0)
+({									  \
+	int __changed = !pte_same(*(__ptep), __entry);			  \
+	if (__changed) {						  \
+		set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry); \
+		flush_tlb_page(__vma, __address);			  \
+	}								  \
+	__changed;							  \
+})
 #endif
 
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
diff -puN include/asm-i386/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-i386/pgtable.h
@@ -285,13 +285,15 @@ static inline pte_t native_local_ptep_ge
  */
 #define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags(vma, address, ptep, entry, dirty)		\
-do {									\
-	if (dirty) {							\
+({									\
+	int __changed = !pte_same(*(ptep), entry);			\
+	if (__changed && dirty) {					\
 		(ptep)->pte_low = (entry).pte_low;			\
 		pte_update_defer((vma)->vm_mm, (address), (ptep));	\
 		flush_tlb_page(vma, address);				\
 	}								\
-} while (0)
+	__changed;							\
+})
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_DIRTY
 #define ptep_test_and_clear_dirty(vma, addr, ptep) ({			\
diff -puN include/asm-ia64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-ia64/pgtable.h
@@ -533,16 +533,23 @@ extern void lazy_mmu_prot_update (pte_t 
  * daccess_bit in ivt.S).
  */
 #ifdef CONFIG_SMP
-# define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable)	\
-do {											\
-	if (__safely_writable) {							\
-		set_pte(__ptep, __entry);						\
-		flush_tlb_page(__vma, __addr);						\
-	}										\
-} while (0)
+# define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
+({									\
+	int __changed = !pte_same(*(__ptep), __entry);			\
+	if (__changed && __safely_writable) {				\
+		set_pte(__ptep, __entry);				\
+		flush_tlb_page(__vma, __addr);				\
+	}								\
+	__changed;							\
+})
 #else
-# define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable)	\
-	ptep_establish(__vma, __addr, __ptep, __entry)
+# define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
+({									\
+	int __changed = !pte_same(*(__ptep), __entry);			\
+	if (__changed)							\
+		ptep_establish(__vma, __addr, __ptep, __entry);		\
+	__changed;							\
+})
 #endif
 
 #  ifdef CONFIG_VIRTUAL_MEM_MAP
diff -puN include/asm-powerpc/pgtable-ppc32.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-powerpc/pgtable-ppc32.h
--- a/include/asm-powerpc/pgtable-ppc32.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-powerpc/pgtable-ppc32.h
@@ -673,10 +673,14 @@ static inline void __ptep_set_access_fla
 }
 
 #define  ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-	do {								   \
-		__ptep_set_access_flags(__ptep, __entry, __dirty);	   \
-		flush_tlb_page_nohash(__vma, __address);	       	   \
-	} while(0)
+({									   \
+	int __changed = !pte_same(*(__ptep), __entry);			   \
+	if (__changed) {						   \
+		__ptep_set_access_flags(__ptep, __entry, __dirty);    	   \
+		flush_tlb_page_nohash(__vma, __address);		   \
+	}								   \
+	__changed;							   \
+})
 
 /*
  * Macro to mark a page protection value as "uncacheable".
diff -puN include/asm-powerpc/pgtable-ppc64.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-powerpc/pgtable-ppc64.h
--- a/include/asm-powerpc/pgtable-ppc64.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-powerpc/pgtable-ppc64.h
@@ -413,10 +413,14 @@ static inline void __ptep_set_access_fla
 	:"cc");
 }
 #define  ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-	do {								   \
-		__ptep_set_access_flags(__ptep, __entry, __dirty);	   \
-		flush_tlb_page_nohash(__vma, __address);	       	   \
-	} while(0)
+({									   \
+	int __changed = !pte_same(*(__ptep), __entry);			   \
+	if (__changed) {						   \
+		__ptep_set_access_flags(__ptep, __entry, __dirty);    	   \
+		flush_tlb_page_nohash(__vma, __address);		   \
+	}								   \
+	__changed;							   \
+})
 
 /*
  * Macro to mark a page protection value as "uncacheable".
diff -puN include/asm-ppc/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-ppc/pgtable.h
--- a/include/asm-ppc/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-ppc/pgtable.h
@@ -694,10 +694,14 @@ static inline void __ptep_set_access_fla
 }
 
 #define  ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-	do {								   \
-		__ptep_set_access_flags(__ptep, __entry, __dirty);	   \
-		flush_tlb_page_nohash(__vma, __address);	       	   \
-	} while(0)
+({									   \
+	int __changed = !pte_same(*(__ptep), __entry);			   \
+	if (__changed) {						   \
+		__ptep_set_access_flags(__ptep, __entry, __dirty);    	   \
+		flush_tlb_page_nohash(__vma, __address);		   \
+	}								   \
+	__changed;							   \
+})
 
 /*
  * Macro to mark a page protection value as "uncacheable".
diff -puN include/asm-s390/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-s390/pgtable.h
--- a/include/asm-s390/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-s390/pgtable.h
@@ -744,7 +744,12 @@ ptep_establish(struct vm_area_struct *vm
 }
 
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-	ptep_establish(__vma, __address, __ptep, __entry)
+({									  \
+	int __changed = !pte_same(*(__ptep), __entry);			  \
+	if (__changed)							  \
+		ptep_establish(__vma, __address, __ptep, __entry);	  \
+	__changed;							  \
+})
 
 /*
  * Test and clear dirty bit in storage key.
diff -puN include/asm-sparc/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-sparc/pgtable.h
--- a/include/asm-sparc/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-sparc/pgtable.h
@@ -446,6 +446,17 @@ extern int io_remap_pfn_range(struct vm_
 #define GET_IOSPACE(pfn)		(pfn >> (BITS_PER_LONG - 4))
 #define GET_PFN(pfn)			(pfn & 0x0fffffffUL)
 
+#define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
+#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
+({									  \
+	int __changed = !pte_same(*(__ptep), __entry);			  \
+	if (__changed) {						  \
+		set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry); \
+		flush_tlb_page(__vma, __address);			  \
+	}								  \
+	(sparc_cpu_model == sun4c) || __changed;			  \
+})
+
 #include <asm-generic/pgtable.h>
 
 #endif /* !(__ASSEMBLY__) */
diff -puN include/asm-x86_64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/include/asm-x86_64/pgtable.h
@@ -395,12 +395,14 @@ static inline pte_t pte_modify(pte_t pte
  * bit at the same time. */
 #define  __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-	do {								  \
-		if (__dirty) {						  \
-			set_pte(__ptep, __entry);			  \
-			flush_tlb_page(__vma, __address);		  \
-		}							  \
-	} while (0)
+({									  \
+	int __changed = !pte_same(*(__ptep), __entry);			  \
+	if (__changed && __dirty) {					  \
+		set_pte(__ptep, __entry);			  	  \
+		flush_tlb_page(__vma, __address);		  	  \
+	}								  \
+	__changed;							  \
+})
 
 /* Encode and de-code a swap entry */
 #define __swp_type(x)			(((x).val >> 1) & 0x3f)
diff -puN mm/hugetlb.c~rework-ptep_set_access_flags-and-fix-sun4c mm/hugetlb.c
--- a/mm/hugetlb.c~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/mm/hugetlb.c
@@ -326,9 +326,10 @@ static void set_huge_ptep_writable(struc
 	pte_t entry;
 
 	entry = pte_mkwrite(pte_mkdirty(*ptep));
-	ptep_set_access_flags(vma, address, ptep, entry, 1);
-	update_mmu_cache(vma, address, entry);
-	lazy_mmu_prot_update(entry);
+	if (ptep_set_access_flags(vma, address, ptep, entry, 1)) {
+		update_mmu_cache(vma, address, entry);
+		lazy_mmu_prot_update(entry);
+	}
 }
 
 
diff -puN mm/memory.c~rework-ptep_set_access_flags-and-fix-sun4c mm/memory.c
--- a/mm/memory.c~rework-ptep_set_access_flags-and-fix-sun4c
+++ a/mm/memory.c
@@ -1691,9 +1691,10 @@ static int do_wp_page(struct mm_struct *
 		flush_cache_page(vma, address, pte_pfn(orig_pte));
 		entry = pte_mkyoung(orig_pte);
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
-		ptep_set_access_flags(vma, address, page_table, entry, 1);
-		update_mmu_cache(vma, address, entry);
-		lazy_mmu_prot_update(entry);
+		if (ptep_set_access_flags(vma, address, page_table, entry,1)) {
+			update_mmu_cache(vma, address, entry);
+			lazy_mmu_prot_update(entry);
+		}
 		ret |= VM_FAULT_WRITE;
 		goto unlock;
 	}
@@ -2525,10 +2526,9 @@ static inline int handle_pte_fault(struc
 		pte_t *pte, pmd_t *pmd, int write_access)
 {
 	pte_t entry;
-	pte_t old_entry;
 	spinlock_t *ptl;
 
-	old_entry = entry = *pte;
+	entry = *pte;
 	if (!pte_present(entry)) {
 		if (pte_none(entry)) {
 			if (vma->vm_ops) {
@@ -2561,8 +2561,7 @@ static inline int handle_pte_fault(struc
 		entry = pte_mkdirty(entry);
 	}
 	entry = pte_mkyoung(entry);
-	if (!pte_same(old_entry, entry)) {
-		ptep_set_access_flags(vma, address, pte, entry, write_access);
+	if (ptep_set_access_flags(vma, address, pte, entry, write_access)) {
 		update_mmu_cache(vma, address, entry);
 		lazy_mmu_prot_update(entry);
 	} else {
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

origin.patch
git-powerpc.patch
8xx-mpc885ads-pcmcia-support.patch
dts-kill-hardcoded-phandles.patch
git-libata-all.patch
i386-flush_tlb_kernel_range-add-reference-to-the-arguments.patch
8xx-fix-whitespace-and-indentation.patch
introduce-compat_u64-and-compat_s64-types.patch
radeonfb-add-support-for-radeon-xpress-200m-rs485.patch
controlfb-the-pseudo_palette-is-only-16-elements-long.patch
fallocate-implementation-on-i86-x86_64-and-powerpc.patch
