From: akpm@linux-foundation.org
Subject: [merged] mm-remove-misleading-arch_uses_numa_prot_none.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:19:03 -0700
Message-ID: <543c1797.cvn0lrlp0gxn2wBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaJMSTD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:19:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aneesh.kumar@linux.vnet.ibm.com, gorcunov@gmail.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove misleading ARCH_USES_NUMA_PROT_NONE
has been removed from the -mm tree.  Its filename was
     mm-remove-misleading-arch_uses_numa_prot_none.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: remove misleading ARCH_USES_NUMA_PROT_NONE

ARCH_USES_NUMA_PROT_NONE was defined for architectures that implemented
_PAGE_NUMA using _PROT_NONE.  This saved using an additional PTE bit and
relied on the fact that PROT_NONE vmas were skipped by the NUMA hinting
fault scanner.  This was found to be conceptually confusing with a lot of
implicit assumptions and it was asked that an alternative be found.

Commit c46a7c81 "x86: define _PAGE_NUMA by reusing software bits on the
PMD and PTE levels" redefined _PAGE_NUMA on x86 to be one of the swap PTE
bits and shrunk the maximum possible swap size but it did not go far
enough.  There are no architectures that reuse _PROT_NONE as _PROT_NUMA
but the relics still exist.

This patch removes ARCH_USES_NUMA_PROT_NONE and removes some unnecessary
duplication in powerpc vs the generic implementation by defining the types
the core NUMA helpers expected to exist from x86 with their ppc64
equivalent.  This necessitated that a PTE bit mask be created that
identified the bits that distinguish present from NUMA pte entries but it
is expected this will only differ between arches based on _PAGE_PROTNONE. 
The naming for the generic helpers was taken from x86 originally but ppc64
has types that are equivalent for the purposes of the helper so they are
mapped instead of duplicating code.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable.h    |   57 +++++-------------------
 arch/powerpc/include/asm/pte-common.h |    5 ++
 arch/x86/Kconfig                      |    1 
 arch/x86/include/asm/pgtable_types.h  |   14 +++++
 include/asm-generic/pgtable.h         |   27 +++--------
 init/Kconfig                          |   11 ----
 6 files changed, 40 insertions(+), 75 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable.h~mm-remove-misleading-arch_uses_numa_prot_none arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~mm-remove-misleading-arch_uses_numa_prot_none
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -38,10 +38,9 @@ static inline int pte_none(pte_t pte)		{
 static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PAGE_PROT_BITS); }
 
 #ifdef CONFIG_NUMA_BALANCING
-
 static inline int pte_present(pte_t pte)
 {
-	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
+	return pte_val(pte) & _PAGE_NUMA_MASK;
 }
 
 #define pte_present_nonuma pte_present_nonuma
@@ -50,37 +49,6 @@ static inline int pte_present_nonuma(pte
 	return pte_val(pte) & (_PAGE_PRESENT);
 }
 
-#define pte_numa pte_numa
-static inline int pte_numa(pte_t pte)
-{
-	return (pte_val(pte) &
-		(_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
-}
-
-#define pte_mknonnuma pte_mknonnuma
-static inline pte_t pte_mknonnuma(pte_t pte)
-{
-	pte_val(pte) &= ~_PAGE_NUMA;
-	pte_val(pte) |=  _PAGE_PRESENT | _PAGE_ACCESSED;
-	return pte;
-}
-
-#define pte_mknuma pte_mknuma
-static inline pte_t pte_mknuma(pte_t pte)
-{
-	/*
-	 * We should not set _PAGE_NUMA on non present ptes. Also clear the
-	 * present bit so that hash_page will return 1 and we collect this
-	 * as numa fault.
-	 */
-	if (pte_present(pte)) {
-		pte_val(pte) |= _PAGE_NUMA;
-		pte_val(pte) &= ~_PAGE_PRESENT;
-	} else
-		VM_BUG_ON(1);
-	return pte;
-}
-
 #define ptep_set_numa ptep_set_numa
 static inline void ptep_set_numa(struct mm_struct *mm, unsigned long addr,
 				 pte_t *ptep)
@@ -92,12 +60,6 @@ static inline void ptep_set_numa(struct
 	return;
 }
 
-#define pmd_numa pmd_numa
-static inline int pmd_numa(pmd_t pmd)
-{
-	return pte_numa(pmd_pte(pmd));
-}
-
 #define pmdp_set_numa pmdp_set_numa
 static inline void pmdp_set_numa(struct mm_struct *mm, unsigned long addr,
 				 pmd_t *pmdp)
@@ -109,16 +71,21 @@ static inline void pmdp_set_numa(struct
 	return;
 }
 
-#define pmd_mknonnuma pmd_mknonnuma
-static inline pmd_t pmd_mknonnuma(pmd_t pmd)
+/*
+ * Generic NUMA pte helpers expect pteval_t and pmdval_t types to exist
+ * which was inherited from x86. For the purposes of powerpc pte_basic_t and
+ * pmd_t are equivalent
+ */
+#define pteval_t pte_basic_t
+#define pmdval_t pmd_t
+static inline pteval_t ptenuma_flags(pte_t pte)
 {
-	return pte_pmd(pte_mknonnuma(pmd_pte(pmd)));
+	return pte_val(pte) & _PAGE_NUMA_MASK;
 }
 
-#define pmd_mknuma pmd_mknuma
-static inline pmd_t pmd_mknuma(pmd_t pmd)
+static inline pmdval_t pmdnuma_flags(pmd_t pmd)
 {
-	return pte_pmd(pte_mknuma(pmd_pte(pmd)));
+	return pmd_val(pmd) & _PAGE_NUMA_MASK;
 }
 
 # else
diff -puN arch/powerpc/include/asm/pte-common.h~mm-remove-misleading-arch_uses_numa_prot_none arch/powerpc/include/asm/pte-common.h
--- a/arch/powerpc/include/asm/pte-common.h~mm-remove-misleading-arch_uses_numa_prot_none
+++ a/arch/powerpc/include/asm/pte-common.h
@@ -98,6 +98,11 @@ extern unsigned long bad_call_to_PMD_PAG
 			 _PAGE_USER | _PAGE_ACCESSED | \
 			 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | _PAGE_EXEC)
 
+#ifdef CONFIG_NUMA_BALANCING
+/* Mask of bits that distinguish present and numa ptes */
+#define _PAGE_NUMA_MASK (_PAGE_NUMA|_PAGE_PRESENT)
+#endif
+
 /*
  * We define 2 sets of base prot bits, one for basic pages (ie,
  * cacheable kernel and user pages) and one for non cacheable
diff -puN arch/x86/Kconfig~mm-remove-misleading-arch_uses_numa_prot_none arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-remove-misleading-arch_uses_numa_prot_none
+++ a/arch/x86/Kconfig
@@ -30,7 +30,6 @@ config X86
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select ARCH_SUPPORTS_NUMA_BALANCING if X86_64
 	select ARCH_SUPPORTS_INT128 if X86_64
-	select ARCH_WANTS_PROT_NUMA_PROT_NONE
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_PCSPKR_PLATFORM
diff -puN arch/x86/include/asm/pgtable_types.h~mm-remove-misleading-arch_uses_numa_prot_none arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~mm-remove-misleading-arch_uses_numa_prot_none
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -325,6 +325,20 @@ static inline pteval_t pte_flags(pte_t p
 	return native_pte_val(pte) & PTE_FLAGS_MASK;
 }
 
+#ifdef CONFIG_NUMA_BALANCING
+/* Set of bits that distinguishes present, prot_none and numa ptes */
+#define _PAGE_NUMA_MASK (_PAGE_NUMA|_PAGE_PROTNONE|_PAGE_PRESENT)
+static inline pteval_t ptenuma_flags(pte_t pte)
+{
+	return pte_flags(pte) & _PAGE_NUMA_MASK;
+}
+
+static inline pmdval_t pmdnuma_flags(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_NUMA_MASK;
+}
+#endif /* CONFIG_NUMA_BALANCING */
+
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
diff -puN include/asm-generic/pgtable.h~mm-remove-misleading-arch_uses_numa_prot_none include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-remove-misleading-arch_uses_numa_prot_none
+++ a/include/asm-generic/pgtable.h
@@ -660,11 +660,12 @@ static inline int pmd_trans_unstable(pmd
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-#ifdef CONFIG_ARCH_USES_NUMA_PROT_NONE
 /*
- * _PAGE_NUMA works identical to _PAGE_PROTNONE (it's actually the
- * same bit too). It's set only when _PAGE_PRESET is not set and it's
- * never set if _PAGE_PRESENT is set.
+ * _PAGE_NUMA distinguishes between an unmapped page table entry, an entry that
+ * is protected for PROT_NONE and a NUMA hinting fault entry. If the
+ * architecture defines __PAGE_PROTNONE then it should take that into account
+ * but those that do not can rely on the fact that the NUMA hinting scanner
+ * skips inaccessible VMAs.
  *
  * pte/pmd_present() returns true if pte/pmd_numa returns true. Page
  * fault triggers on those regions if pte/pmd_numa returns true
@@ -673,16 +674,14 @@ static inline int pmd_trans_unstable(pmd
 #ifndef pte_numa
 static inline int pte_numa(pte_t pte)
 {
-	return (pte_flags(pte) &
-		(_PAGE_NUMA|_PAGE_PROTNONE|_PAGE_PRESENT)) == _PAGE_NUMA;
+	return ptenuma_flags(pte) == _PAGE_NUMA;
 }
 #endif
 
 #ifndef pmd_numa
 static inline int pmd_numa(pmd_t pmd)
 {
-	return (pmd_flags(pmd) &
-		(_PAGE_NUMA|_PAGE_PROTNONE|_PAGE_PRESENT)) == _PAGE_NUMA;
+	return pmdnuma_flags(pmd) == _PAGE_NUMA;
 }
 #endif
 
@@ -722,6 +721,8 @@ static inline pte_t pte_mknuma(pte_t pte
 {
 	pteval_t val = pte_val(pte);
 
+	VM_BUG_ON(!(val & _PAGE_PRESENT));
+
 	val &= ~_PAGE_PRESENT;
 	val |= _PAGE_NUMA;
 
@@ -765,16 +766,6 @@ static inline void pmdp_set_numa(struct
 }
 #endif
 #else
-extern int pte_numa(pte_t pte);
-extern int pmd_numa(pmd_t pmd);
-extern pte_t pte_mknonnuma(pte_t pte);
-extern pmd_t pmd_mknonnuma(pmd_t pmd);
-extern pte_t pte_mknuma(pte_t pte);
-extern pmd_t pmd_mknuma(pmd_t pmd);
-extern void ptep_set_numa(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-extern void pmdp_set_numa(struct mm_struct *mm, unsigned long addr, pmd_t *pmdp);
-#endif /* CONFIG_ARCH_USES_NUMA_PROT_NONE */
-#else
 static inline int pmd_numa(pmd_t pmd)
 {
 	return 0;
diff -puN init/Kconfig~mm-remove-misleading-arch_uses_numa_prot_none init/Kconfig
--- a/init/Kconfig~mm-remove-misleading-arch_uses_numa_prot_none
+++ a/init/Kconfig
@@ -889,17 +889,6 @@ config ARCH_SUPPORTS_INT128
 config ARCH_WANT_NUMA_VARIABLE_LOCALITY
 	bool
 
-#
-# For architectures that are willing to define _PAGE_NUMA as _PAGE_PROTNONE
-config ARCH_WANTS_PROT_NUMA_PROT_NONE
-	bool
-
-config ARCH_USES_NUMA_PROT_NONE
-	bool
-	default y
-	depends on ARCH_WANTS_PROT_NUMA_PROT_NONE
-	depends on NUMA_BALANCING
