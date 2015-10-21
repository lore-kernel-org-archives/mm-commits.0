From: akpm@linux-foundation.org
Subject: [to-be-updated] powerpc-mm-add-page-soft-dirty-tracking.patch
 removed from -mm tree
Date: Wed, 21 Oct 2015 12:49:44 -0700
Message-ID: <5627ec58.ru5a+nL9DJOxF78h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500AbbJUTtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 15:49:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ldufour@linux.vnet.ibm.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc/mm: add page soft dirty tracking
has been removed from the -mm tree.  Its filename was
     powerpc-mm-add-page-soft-dirty-tracking.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Subject: powerpc/mm: add page soft dirty tracking

User space checkpoint and restart tool (CRIU) needs the page's change to
be soft tracked.  This allows to do a pre checkpoint and then dump only
touched pages.

This is done by using a newly assigned PTE bit (_PAGE_SOFT_DIRTY) when the
page is backed in memory, and a new _PAGE_SWP_SOFT_DIRTY bit when the page
is swapped out.

The _PAGE_SWP_SOFT_DIRTY bit is dynamically put after the swap type in the
swap pte.  A check is added to ensure that the bit is not overwritten by
_PAGE_HPTEFLAGS.

Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig                     |    2 +
 arch/powerpc/include/asm/pgtable-ppc64.h |   13 +++++-
 arch/powerpc/include/asm/pgtable.h       |   40 ++++++++++++++++++++-
 arch/powerpc/include/asm/pte-book3e.h    |    1 
 arch/powerpc/include/asm/pte-common.h    |    5 +-
 arch/powerpc/include/asm/pte-hash64.h    |    1 
 6 files changed, 57 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-mm-add-page-soft-dirty-tracking arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-mm-add-page-soft-dirty-tracking
+++ a/arch/powerpc/Kconfig
@@ -559,6 +559,7 @@ choice
 
 config PPC_4K_PAGES
 	bool "4k page size"
+	select HAVE_ARCH_SOFT_DIRTY if CHECKPOINT_RESTORE && PPC_BOOK3S
 
 config PPC_16K_PAGES
 	bool "16k page size"
@@ -567,6 +568,7 @@ config PPC_16K_PAGES
 config PPC_64K_PAGES
 	bool "64k page size"
 	depends on !PPC_FSL_BOOK3E && (44x || PPC_STD_MMU_64 || PPC_BOOK3E_64)
+	select HAVE_ARCH_SOFT_DIRTY if CHECKPOINT_RESTORE && PPC_BOOK3S
 
 config PPC_256K_PAGES
 	bool "256k page size"
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-mm-add-page-soft-dirty-tracking arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-mm-add-page-soft-dirty-tracking
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -315,7 +315,8 @@ static inline void pte_clear(struct mm_s
 static inline void __ptep_set_access_flags(pte_t *ptep, pte_t entry)
 {
 	unsigned long bits = pte_val(entry) &
-		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC);
+		(_PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_RW | _PAGE_EXEC |
+		 _PAGE_SOFT_DIRTY);
 
 #ifdef PTE_ATOMIC_UPDATES
 	unsigned long old, tmp;
@@ -354,6 +355,7 @@ static inline void __ptep_set_access_fla
 	 * We filter HPTEFLAGS on set_pte.			\
 	 */							\
 	BUILD_BUG_ON(_PAGE_HPTEFLAGS & (0x1f << _PAGE_BIT_SWAP_TYPE)); \
+	BUILD_BUG_ON(_PAGE_HPTEFLAGS & _PAGE_SWP_SOFT_DIRTY);	\
 	} while (0)
 /*
  * on pte we don't need handle RADIX_TREE_EXCEPTIONAL_SHIFT;
@@ -371,6 +373,8 @@ static inline void __ptep_set_access_fla
 
 void pgtable_cache_add(unsigned shift, void (*ctor)(void *));
 void pgtable_cache_init(void);
+
+#define _PAGE_SWP_SOFT_DIRTY	(1UL << (SWP_TYPE_BITS + _PAGE_BIT_SWAP_TYPE))
 #endif /* __ASSEMBLY__ */
 
 /*
@@ -389,7 +393,7 @@ void pgtable_cache_init(void);
  */
 #define _HPAGE_CHG_MASK (PTE_RPN_MASK | _PAGE_HPTEFLAGS |		\
 			 _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_SPLITTING | \
-			 _PAGE_THP_HUGE)
+			 _PAGE_THP_HUGE | _PAGE_SOFT_DIRTY)
 
 #ifndef __ASSEMBLY__
 /*
@@ -513,6 +517,11 @@ static inline pte_t *pmdp_ptep(pmd_t *pm
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
 #define pmd_mkwrite(pmd)	pte_pmd(pte_mkwrite(pmd_pte(pmd)))
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+#define pmd_soft_dirty(pmd)	pte_soft_dirty(pmd_pte(pmd))
+#define pmd_mksoft_dirty(pmd)	pte_pmd(pte_mksoft_dirty(pmd_pte(pmd)))
+#endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
+
 #define __HAVE_ARCH_PMD_WRITE
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
diff -puN arch/powerpc/include/asm/pgtable.h~powerpc-mm-add-page-soft-dirty-tracking arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~powerpc-mm-add-page-soft-dirty-tracking
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -38,6 +38,44 @@ static inline int pte_special(pte_t pte)
 static inline int pte_none(pte_t pte)		{ return (pte_val(pte) & ~_PTE_NONE_MASK) == 0; }
 static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PAGE_PROT_BITS); }
 
+#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
+static inline int pte_soft_dirty(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SOFT_DIRTY;
+}
+static inline pte_t pte_mksoft_dirty(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_SOFT_DIRTY;
+	return pte;
+}
+
+static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
+{
+	pte_val(pte) |= _PAGE_SWP_SOFT_DIRTY;
+	return pte;
+}
+static inline int pte_swp_soft_dirty(pte_t pte)
+{
+	return pte_val(pte) & _PAGE_SWP_SOFT_DIRTY;
+}
+static inline pte_t pte_swp_clear_soft_dirty(pte_t pte)
+{
+	pte_val(pte) &= ~_PAGE_SWP_SOFT_DIRTY;
+	return pte;
+}
+
+static inline pte_t pte_clear_flags(pte_t pte, pte_basic_t clear)
+{
+	pte_val(pte) &= ~clear;
+	return pte;
+}
+static inline pmd_t pmd_clear_flags(pmd_t pmd, unsigned long clear)
+{
+	pmd_val(pmd) &= ~clear;
+	return pmd;
+}
+#endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
+
 #ifdef CONFIG_NUMA_BALANCING
 /*
  * These work without NUMA balancing but the kernel does not care. See the
@@ -89,7 +127,7 @@ static inline pte_t pte_mkwrite(pte_t pt
 	pte_val(pte) &= ~_PAGE_RO;
 	pte_val(pte) |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkdirty(pte_t pte) {
-	pte_val(pte) |= _PAGE_DIRTY; return pte; }
+	pte_val(pte) |= _PAGE_DIRTY | _PAGE_SOFT_DIRTY; return pte; }
 static inline pte_t pte_mkyoung(pte_t pte) {
 	pte_val(pte) |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkspecial(pte_t pte) {
diff -puN arch/powerpc/include/asm/pte-book3e.h~powerpc-mm-add-page-soft-dirty-tracking arch/powerpc/include/asm/pte-book3e.h
--- a/arch/powerpc/include/asm/pte-book3e.h~powerpc-mm-add-page-soft-dirty-tracking
+++ a/arch/powerpc/include/asm/pte-book3e.h
@@ -57,6 +57,7 @@
 
 #define _PAGE_HASHPTE	0
 #define _PAGE_BUSY	0
+#define _PAGE_SOFT_DIRTY	0
 
 #define _PAGE_SPECIAL	_PAGE_SW0
 
diff -puN arch/powerpc/include/asm/pte-common.h~powerpc-mm-add-page-soft-dirty-tracking arch/powerpc/include/asm/pte-common.h
--- a/arch/powerpc/include/asm/pte-common.h~powerpc-mm-add-page-soft-dirty-tracking
+++ a/arch/powerpc/include/asm/pte-common.h
@@ -94,13 +94,14 @@ extern unsigned long bad_call_to_PMD_PAG
  * pgprot changes
  */
 #define _PAGE_CHG_MASK	(PTE_RPN_MASK | _PAGE_HPTEFLAGS | _PAGE_DIRTY | \
-                         _PAGE_ACCESSED | _PAGE_SPECIAL)
+			 _PAGE_ACCESSED | _PAGE_SPECIAL | _PAGE_SOFT_DIRTY)
 
 /* Mask of bits returned by pte_pgprot() */
 #define PAGE_PROT_BITS	(_PAGE_GUARDED | _PAGE_COHERENT | _PAGE_NO_CACHE | \
 			 _PAGE_WRITETHRU | _PAGE_ENDIAN | _PAGE_4K_PFN | \
 			 _PAGE_USER | _PAGE_ACCESSED | _PAGE_RO | \
-			 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | _PAGE_EXEC)
+			 _PAGE_RW | _PAGE_HWWRITE | _PAGE_DIRTY | \
+			 _PAGE_EXEC | _PAGE_SOFT_DIRTY)
 
 /*
  * We define 2 sets of base prot bits, one for basic pages (ie,
diff -puN arch/powerpc/include/asm/pte-hash64.h~powerpc-mm-add-page-soft-dirty-tracking arch/powerpc/include/asm/pte-hash64.h
--- a/arch/powerpc/include/asm/pte-hash64.h~powerpc-mm-add-page-soft-dirty-tracking
+++ a/arch/powerpc/include/asm/pte-hash64.h
@@ -19,6 +19,7 @@
 #define _PAGE_BIT_SWAP_TYPE	2
 #define _PAGE_EXEC		0x0004 /* No execute on POWER4 and newer (we invert) */
 #define _PAGE_GUARDED		0x0008
+#define _PAGE_SOFT_DIRTY	0x0010 /* software dirty tracking */
 /* We can derive Memory coherence from _PAGE_NO_CACHE */
 #define _PAGE_NO_CACHE		0x0020 /* I: cache inhibit */
 #define _PAGE_WRITETHRU		0x0040 /* W: cache write-through */
_

Patches currently in -mm which might be from ldufour@linux.vnet.ibm.com are

mm-clearing-pte-in-clear_soft_dirty.patch
mm-clear_soft_dirty_pmd-requires-thp.patch

