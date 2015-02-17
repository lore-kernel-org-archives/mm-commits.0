From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-drop-_page_file-and-pte_file-related-helpers.patch removed from -mm tree
Date: Tue, 17 Feb 2015 12:06:35 -0800
Message-ID: <54e39f4b.o+2LE7F3g7t6wzRs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35369 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbbBQUGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, benh@kernel.crashing.org, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: drop _PAGE_FILE and pte_file()-related helpers
has been removed from the -mm tree.  Its filename was
     powerpc-drop-_page_file-and-pte_file-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A.  Shutemov" <kirill.shutemov@linux.intel.com>
Subject: powerpc: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/pgtable-ppc32.h |    9 ++-------
 arch/powerpc/include/asm/pgtable-ppc64.h |    5 +----
 arch/powerpc/include/asm/pgtable.h       |    1 -
 arch/powerpc/include/asm/pte-40x.h       |    1 -
 arch/powerpc/include/asm/pte-44x.h       |    5 -----
 arch/powerpc/include/asm/pte-8xx.h       |    1 -
 arch/powerpc/include/asm/pte-book3e.h    |    1 -
 arch/powerpc/include/asm/pte-fsl-booke.h |    3 ---
 arch/powerpc/include/asm/pte-hash32.h    |    1 -
 arch/powerpc/include/asm/pte-hash64.h    |    1 -
 arch/powerpc/mm/pgtable_64.c             |    2 +-
 11 files changed, 4 insertions(+), 26 deletions(-)

diff -puN arch/powerpc/include/asm/pgtable-ppc32.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pgtable-ppc32.h
--- a/arch/powerpc/include/asm/pgtable-ppc32.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pgtable-ppc32.h
@@ -333,8 +333,8 @@ static inline void __ptep_set_access_fla
 /*
  * Encode and decode a swap entry.
  * Note that the bits we use in a PTE for representing a swap entry
- * must not include the _PAGE_PRESENT bit, the _PAGE_FILE bit, or the
- *_PAGE_HASHPTE bit (if used).  -- paulus
+ * must not include the _PAGE_PRESENT bit or the _PAGE_HASHPTE bit (if used).
+ *   -- paulus
  */
 #define __swp_type(entry)		((entry).val & 0x1f)
 #define __swp_offset(entry)		((entry).val >> 5)
@@ -342,11 +342,6 @@ static inline void __ptep_set_access_fla
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) >> 3 })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val << 3 })
 
-/* Encode and decode a nonlinear file mapping entry */
-#define PTE_FILE_MAX_BITS	29
-#define pte_to_pgoff(pte)	(pte_val(pte) >> 3)
-#define pgoff_to_pte(off)	((pte_t) { ((off) << 3) | _PAGE_FILE })
-
 #ifndef CONFIG_PPC_4K_PAGES
 void pgtable_cache_init(void);
 #else
diff -puN arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pgtable-ppc64.h
--- a/arch/powerpc/include/asm/pgtable-ppc64.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pgtable-ppc64.h
@@ -352,9 +352,6 @@ static inline void __ptep_set_access_fla
 #define __swp_entry(type, offset) ((swp_entry_t){((type)<< 1)|((offset)<<8)})
 #define __pte_to_swp_entry(pte)	((swp_entry_t){pte_val(pte) >> PTE_RPN_SHIFT})
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val << PTE_RPN_SHIFT })
-#define pte_to_pgoff(pte)	(pte_val(pte) >> PTE_RPN_SHIFT)
-#define pgoff_to_pte(off)	((pte_t) {((off) << PTE_RPN_SHIFT)|_PAGE_FILE})
-#define PTE_FILE_MAX_BITS	(BITS_PER_LONG - PTE_RPN_SHIFT)
 
 void pgtable_cache_add(unsigned shift, void (*ctor)(void *));
 void pgtable_cache_init(void);
@@ -389,7 +386,7 @@ void pgtable_cache_init(void);
  * The last three bits are intentionally left to zero. This memory location
  * are also used as normal page PTE pointers. So if we have any pointers
  * left around while we collapse a hugepage, we need to make sure
- * _PAGE_PRESENT and _PAGE_FILE bits of that are zero when we look at them
+ * _PAGE_PRESENT bit of that is zero when we look at them
  */
 static inline unsigned int hpte_valid(unsigned char *hpte_slot_array, int index)
 {
diff -puN arch/powerpc/include/asm/pgtable.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pgtable.h
--- a/arch/powerpc/include/asm/pgtable.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pgtable.h
@@ -34,7 +34,6 @@ static inline int pte_write(pte_t pte)
 {	return (pte_val(pte) & (_PAGE_RW | _PAGE_RO)) != _PAGE_RO; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return pte_val(pte) & _PAGE_SPECIAL; }
 static inline int pte_none(pte_t pte)		{ return (pte_val(pte) & ~_PTE_NONE_MASK) == 0; }
 static inline pgprot_t pte_pgprot(pte_t pte)	{ return __pgprot(pte_val(pte) & PAGE_PROT_BITS); }
diff -puN arch/powerpc/include/asm/pte-40x.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pte-40x.h
--- a/arch/powerpc/include/asm/pte-40x.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pte-40x.h
@@ -38,7 +38,6 @@
  */
 
 #define	_PAGE_GUARDED	0x001	/* G: page is guarded from prefetch */
-#define _PAGE_FILE	0x001	/* when !present: nonlinear file mapping */
 #define _PAGE_PRESENT	0x002	/* software: PTE contains a translation */
 #define	_PAGE_NO_CACHE	0x004	/* I: caching is inhibited */
 #define	_PAGE_WRITETHRU	0x008	/* W: caching is write-through */
diff -puN arch/powerpc/include/asm/pte-44x.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pte-44x.h
--- a/arch/powerpc/include/asm/pte-44x.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pte-44x.h
@@ -44,9 +44,6 @@
  *   - PRESENT *must* be in the bottom three bits because swap cache
  *     entries use the top 29 bits for TLB2.
  *
- *   - FILE *must* be in the bottom three bits because swap cache
- *     entries use the top 29 bits for TLB2.
- *
  *   - CACHE COHERENT bit (M) has no effect on original PPC440 cores,
  *     because it doesn't support SMP. However, some later 460 variants
  *     have -some- form of SMP support and so I keep the bit there for
@@ -68,7 +65,6 @@
  *
  * There are three protection bits available for SWAP entry:
  *	_PAGE_PRESENT
- *	_PAGE_FILE
  *	_PAGE_HASHPTE (if HW has)
  *
  * So those three bits have to be inside of 0-2nd LSB of PTE.
@@ -77,7 +73,6 @@
 
 #define _PAGE_PRESENT	0x00000001		/* S: PTE valid */
 #define _PAGE_RW	0x00000002		/* S: Write permission */
-#define _PAGE_FILE	0x00000004		/* S: nonlinear file mapping */
 #define _PAGE_EXEC	0x00000004		/* H: Execute permission */
 #define _PAGE_ACCESSED	0x00000008		/* S: Page referenced */
 #define _PAGE_DIRTY	0x00000010		/* S: Page dirty */
diff -puN arch/powerpc/include/asm/pte-8xx.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pte-8xx.h
--- a/arch/powerpc/include/asm/pte-8xx.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pte-8xx.h
@@ -29,7 +29,6 @@
 
 /* Definitions for 8xx embedded chips. */
 #define _PAGE_PRESENT	0x0001	/* Page is valid */
-#define _PAGE_FILE	0x0002	/* when !present: nonlinear file mapping */
 #define _PAGE_NO_CACHE	0x0002	/* I: cache inhibit */
 #define _PAGE_SHARED	0x0004	/* No ASID (context) compare */
 #define _PAGE_SPECIAL	0x0008	/* SW entry, forced to 0 by the TLB miss */
diff -puN arch/powerpc/include/asm/pte-book3e.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pte-book3e.h
--- a/arch/powerpc/include/asm/pte-book3e.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pte-book3e.h
@@ -10,7 +10,6 @@
 
 /* Architected bits */
 #define _PAGE_PRESENT	0x000001 /* software: pte contains a translation */
-#define _PAGE_FILE	0x000002 /* (!present only) software: pte holds file offset */
 #define _PAGE_SW1	0x000002
 #define _PAGE_BAP_SR	0x000004
 #define _PAGE_BAP_UR	0x000008
diff -puN arch/powerpc/include/asm/pte-fsl-booke.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pte-fsl-booke.h
--- a/arch/powerpc/include/asm/pte-fsl-booke.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pte-fsl-booke.h
@@ -13,14 +13,11 @@
    - PRESENT *must* be in the bottom three bits because swap cache
      entries use the top 29 bits.
 
-   - FILE *must* be in the bottom three bits because swap cache
-     entries use the top 29 bits.
 */
 
 /* Definitions for FSL Book-E Cores */
 #define _PAGE_PRESENT	0x00001	/* S: PTE contains a translation */
 #define _PAGE_USER	0x00002	/* S: User page (maps to UR) */
-#define _PAGE_FILE	0x00002	/* S: when !present: nonlinear file mapping */
 #define _PAGE_RW	0x00004	/* S: Write permission (SW) */
 #define _PAGE_DIRTY	0x00008	/* S: Page dirty */
 #define _PAGE_EXEC	0x00010	/* H: SX permission */
diff -puN arch/powerpc/include/asm/pte-hash32.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pte-hash32.h
--- a/arch/powerpc/include/asm/pte-hash32.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pte-hash32.h
@@ -18,7 +18,6 @@
 
 #define _PAGE_PRESENT	0x001	/* software: pte contains a translation */
 #define _PAGE_HASHPTE	0x002	/* hash_page has made an HPTE for this pte */
-#define _PAGE_FILE	0x004	/* when !present: nonlinear file mapping */
 #define _PAGE_USER	0x004	/* usermode access allowed */
 #define _PAGE_GUARDED	0x008	/* G: prohibit speculative access */
 #define _PAGE_COHERENT	0x010	/* M: enforce memory coherence (SMP systems) */
diff -puN arch/powerpc/include/asm/pte-hash64.h~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/include/asm/pte-hash64.h
--- a/arch/powerpc/include/asm/pte-hash64.h~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/include/asm/pte-hash64.h
@@ -16,7 +16,6 @@
  */
 #define _PAGE_PRESENT		0x0001 /* software: pte contains a translation */
 #define _PAGE_USER		0x0002 /* matches one of the PP bits */
-#define _PAGE_FILE		0x0002 /* (!present only) software: pte holds file offset */
 #define _PAGE_EXEC		0x0004 /* No execute on POWER4 and newer (we invert) */
 #define _PAGE_GUARDED		0x0008
 /* We can derive Memory coherence from _PAGE_NO_CACHE */
diff -puN arch/powerpc/mm/pgtable_64.c~powerpc-drop-_page_file-and-pte_file-related-helpers arch/powerpc/mm/pgtable_64.c
--- a/arch/powerpc/mm/pgtable_64.c~powerpc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/powerpc/mm/pgtable_64.c
@@ -782,7 +782,7 @@ pmd_t pfn_pmd(unsigned long pfn, pgprot_
 {
 	pmd_t pmd;
 	/*
-	 * For a valid pte, we would have _PAGE_PRESENT or _PAGE_FILE always
+	 * For a valid pte, we would have _PAGE_PRESENT always
 	 * set. We use this to check THP page at pmd level.
 	 * leaf pte for huge page, bottom two bits != 00
 	 */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch

