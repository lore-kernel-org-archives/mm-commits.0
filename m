From: akpm@linux-foundation.org
Subject: - mm-remove-ptep_establish.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:00:26 -0700
Message-ID: <200707172300.l6HN0QRx011296@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54543 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758957AbXGQXBJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:01:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwidefsky@de.ibm.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove ptep_establish()
has been removed from the -mm tree.  Its filename was
     mm-remove-ptep_establish.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: remove ptep_establish()
From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The last user of ptep_establish in mm/ is long gone.  Remove the architecture
primitive as well.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm/pgtable.h     |    6 ++--
 include/asm-generic/pgtable.h |   19 --------------
 include/asm-i386/pgtable.h    |   11 --------
 include/asm-ia64/pgtable.h    |    6 ++--
 include/asm-s390/pgtable.h    |   43 ++++++++++++++------------------
 5 files changed, 26 insertions(+), 59 deletions(-)

diff -puN include/asm-arm/pgtable.h~mm-remove-ptep_establish include/asm-arm/pgtable.h
--- a/include/asm-arm/pgtable.h~mm-remove-ptep_establish
+++ a/include/asm-arm/pgtable.h
@@ -83,14 +83,14 @@
  * means that a write to a clean page will cause a permission fault, and
  * the Linux MM layer will mark the page dirty via handle_pte_fault().
  * For the hardware to notice the permission change, the TLB entry must
- * be flushed, and ptep_establish() does that for us.
+ * be flushed, and ptep_set_access_flags() does that for us.
  *
  * The "accessed" or "young" bit is emulated by a similar method; we only
  * allow accesses to the page if the "young" bit is set.  Accesses to the
  * page will cause a fault, and handle_pte_fault() will set the young bit
  * for us as long as the page is marked present in the corresponding Linux
- * PTE entry.  Again, ptep_establish() will ensure that the TLB is up to
- * date.
+ * PTE entry.  Again, ptep_set_access_flags() will ensure that the TLB is
+ * up to date.
  *
  * However, when the "young" bit is cleared, we deny access to the page
  * by clearing the hardware PTE.  Currently Linux does not flush the TLB
diff -puN include/asm-generic/pgtable.h~mm-remove-ptep_establish include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-remove-ptep_establish
+++ a/include/asm-generic/pgtable.h
@@ -3,25 +3,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifndef __HAVE_ARCH_PTEP_ESTABLISH
-/*
- * Establish a new mapping:
- *  - flush the old one
- *  - update the page tables
- *  - inform the TLB about the new one
- *
- * We hold the mm semaphore for reading, and the pte lock.
- *
- * Note: the old pte is known to not be writable, so we don't need to
- * worry about dirty bits etc getting lost.
- */
-#define ptep_establish(__vma, __address, __ptep, __entry)		\
-do {				  					\
-	set_pte_at((__vma)->vm_mm, (__address), __ptep, __entry);	\
-	flush_tlb_page(__vma, __address);				\
-} while (0)
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 /*
  * Largely same as above, but only sets the access flags (dirty,
diff -puN include/asm-i386/pgtable.h~mm-remove-ptep_establish include/asm-i386/pgtable.h
--- a/include/asm-i386/pgtable.h~mm-remove-ptep_establish
+++ a/include/asm-i386/pgtable.h
@@ -311,17 +311,6 @@ static inline pte_t native_local_ptep_ge
 	__ret;								\
 })
 
-/*
- * Rules for using ptep_establish: the pte MUST be a user pte, and
- * must be a present->present transition.
- */
-#define __HAVE_ARCH_PTEP_ESTABLISH
-#define ptep_establish(vma, address, ptep, pteval)			\
-do {									\
-	set_pte_present((vma)->vm_mm, address, ptep, pteval);		\
-	flush_tlb_page(vma, address);					\
-} while (0)
-
 #define __HAVE_ARCH_PTEP_CLEAR_DIRTY_FLUSH
 #define ptep_clear_flush_dirty(vma, address, ptep)			\
 ({									\
diff -puN include/asm-ia64/pgtable.h~mm-remove-ptep_establish include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~mm-remove-ptep_establish
+++ a/include/asm-ia64/pgtable.h
@@ -543,8 +543,10 @@ extern void lazy_mmu_prot_update (pte_t 
 # define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __safely_writable) \
 ({									\
 	int __changed = !pte_same(*(__ptep), __entry);			\
-	if (__changed)							\
-		ptep_establish(__vma, __addr, __ptep, __entry);		\
+	if (__changed) {						\
+		set_pte_at((__vma)->vm_mm, (__addr), __ptep, __entry);	\
+		flush_tlb_page(__vma, __addr);				\
+	}								\
 	__changed;							\
 })
 #endif
diff -puN include/asm-s390/pgtable.h~mm-remove-ptep_establish include/asm-s390/pgtable.h
--- a/include/asm-s390/pgtable.h~mm-remove-ptep_establish
+++ a/include/asm-s390/pgtable.h
@@ -707,16 +707,19 @@ static inline void __ptep_ipte(unsigned 
 	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
 }
 
-static inline pte_t
-ptep_clear_flush(struct vm_area_struct *vma,
-		 unsigned long address, pte_t *ptep)
+static inline void ptep_invalidate(unsigned long address, pte_t *ptep)
 {
-	pte_t pte = *ptep;
-	pte_t *shadow_pte = get_shadow_pte(ptep);
-
 	__ptep_ipte(address, ptep);
-	if (shadow_pte)
-		__ptep_ipte(address, shadow_pte);
+	ptep = get_shadow_pte(ptep);
+	if (ptep)
+		__ptep_ipte(address, ptep);
+}
+
+static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
+				     unsigned long address, pte_t *ptep)
+{
+	pte_t pte = *ptep;
+	ptep_invalidate(address, ptep);
 	return pte;
 }
 
@@ -726,21 +729,14 @@ static inline void ptep_set_wrprotect(st
 	set_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
 }
 
-static inline void
-ptep_establish(struct vm_area_struct *vma, 
-	       unsigned long address, pte_t *ptep,
-	       pte_t entry)
-{
-	ptep_clear_flush(vma, address, ptep);
-	set_pte(ptep, entry);
-}
-
-#define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
-({									  \
-	int __changed = !pte_same(*(__ptep), __entry);			  \
-	if (__changed)							  \
-		ptep_establish(__vma, __address, __ptep, __entry);	  \
-	__changed;							  \
+#define ptep_set_access_flags(__vma, __addr, __ptep, __entry, __dirty)	\
+({									\
+	int __changed = !pte_same(*(__ptep), __entry);			\
+	if (__changed) {						\
+		ptep_invalidate(__addr, __ptep);			\
+		set_pte_at((__vma)->vm_mm, __addr, __ptep, __entry);	\
+	}								\
+	__changed;							\
 })
 
 /*
@@ -940,7 +936,6 @@ extern int remove_shared_memory(unsigned
 #define __HAVE_ARCH_MEMMAP_INIT
 extern void memmap_init(unsigned long, int, unsigned long, unsigned long);
 
-#define __HAVE_ARCH_PTEP_ESTABLISH
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
_

Patches currently in -mm which might be from schwidefsky@de.ibm.com are

origin.patch
git-s390.patch
i386-put-allocated-elf-notes-in-read-only-data-segment.patch
s390-put-allocated-elf-notes-in-read-only-data-segment.patch
add-sys-kernel-notes.patch
use-build-id-ld-option.patch
