From: akpm@linux-foundation.org
Subject: + sh-drop-_page_file-and-pte_file-related-helpers.patch added to
 -mm tree
Date: Tue, 06 Jan 2015 15:34:52 -0800
Message-ID: <54ac711c.OjDgRxj/7KVrT6Qe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sh: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     sh-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-drop-_page_file-and-pte_file-related-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: sh: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/pgtable_32.h |   30 +++--------------------------
 arch/sh/include/asm/pgtable_64.h |    9 --------
 2 files changed, 5 insertions(+), 34 deletions(-)

diff -puN arch/sh/include/asm/pgtable_32.h~sh-drop-_page_file-and-pte_file-related-helpers arch/sh/include/asm/pgtable_32.h
--- a/arch/sh/include/asm/pgtable_32.h~sh-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/sh/include/asm/pgtable_32.h
@@ -26,8 +26,6 @@
  *   and timing control which (together with bit 0) are moved into the
  *   old-style PTEA on the parts that support it.
  *
- * XXX: Leave the _PAGE_FILE and _PAGE_WT overhaul for a rainy day.
- *
  * SH-X2 MMUs and extended PTEs
  *
  * SH-X2 supports an extended mode TLB with split data arrays due to the
@@ -51,7 +49,6 @@
 #define _PAGE_PRESENT	0x100		/* V-bit   : page is valid */
 #define _PAGE_PROTNONE	0x200		/* software: if not present  */
 #define _PAGE_ACCESSED	0x400		/* software: page referenced */
-#define _PAGE_FILE	_PAGE_WT	/* software: pagecache or swap? */
 #define _PAGE_SPECIAL	0x800		/* software: special page */
 
 #define _PAGE_SZ_MASK	(_PAGE_SZ0 | _PAGE_SZ1)
@@ -105,14 +102,13 @@ static inline unsigned long copy_ptea_at
 /* Mask which drops unused bits from the PTEL value */
 #if defined(CONFIG_CPU_SH3)
 #define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED| \
-				 _PAGE_FILE	| _PAGE_SZ1	| \
-				 _PAGE_HW_SHARED)
+				  _PAGE_SZ1	| _PAGE_HW_SHARED)
 #elif defined(CONFIG_X2TLB)
 /* Get rid of the legacy PR/SZ bits when using extended mode */
 #define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED | \
-				 _PAGE_FILE | _PAGE_PR_MASK | _PAGE_SZ_MASK)
+				 _PAGE_PR_MASK | _PAGE_SZ_MASK)
 #else
-#define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED | _PAGE_FILE)
+#define _PAGE_CLEAR_FLAGS	(_PAGE_PROTNONE | _PAGE_ACCESSED)
 #endif
 
 #define _PAGE_FLAGS_HARDWARE_MASK	(phys_addr_mask() & ~(_PAGE_CLEAR_FLAGS))
@@ -343,7 +339,6 @@ static inline void set_pte(pte_t *ptep,
 #define pte_not_present(pte)	(!((pte).pte_low & _PAGE_PRESENT))
 #define pte_dirty(pte)		((pte).pte_low & _PAGE_DIRTY)
 #define pte_young(pte)		((pte).pte_low & _PAGE_ACCESSED)
-#define pte_file(pte)		((pte).pte_low & _PAGE_FILE)
 #define pte_special(pte)	((pte).pte_low & _PAGE_SPECIAL)
 
 #ifdef CONFIG_X2TLB
@@ -445,7 +440,6 @@ static inline pte_t pte_modify(pte_t pte
  * Encode and de-code a swap entry
  *
  * Constraints:
- *	_PAGE_FILE at bit 0
  *	_PAGE_PRESENT at bit 8
  *	_PAGE_PROTNONE at bit 9
  *
@@ -453,9 +447,7 @@ static inline pte_t pte_modify(pte_t pte
  * swap offset into bits 10:30. For the 64-bit PTE case, we keep the
  * preserved bits in the low 32-bits and use the upper 32 as the swap
  * offset (along with a 5-bit type), following the same approach as x86
- * PAE. This keeps the logic quite simple, and allows for a full 32
- * PTE_FILE_MAX_BITS, as opposed to the 29-bits we're constrained with
- * in the pte_low case.
+ * PAE. This keeps the logic quite simple.
  *
  * As is evident by the Alpha code, if we ever get a 64-bit unsigned
  * long (swp_entry_t) to match up with the 64-bit PTEs, this all becomes
@@ -471,13 +463,6 @@ static inline pte_t pte_modify(pte_t pte
 #define __pte_to_swp_entry(pte)		((swp_entry_t){ (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t){ 0, (x).val })
 
-/*
- * Encode and decode a nonlinear file mapping entry
- */
-#define pte_to_pgoff(pte)		((pte).pte_high)
-#define pgoff_to_pte(off)		((pte_t) { _PAGE_FILE, (off) })
-
-#define PTE_FILE_MAX_BITS		32
 #else
 #define __swp_type(x)			((x).val & 0xff)
 #define __swp_offset(x)			((x).val >> 10)
@@ -485,13 +470,6 @@ static inline pte_t pte_modify(pte_t pte
 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) >> 1 })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val << 1 })
-
-/*
- * Encode and decode a nonlinear file mapping entry
- */
-#define PTE_FILE_MAX_BITS	29
-#define pte_to_pgoff(pte)	(pte_val(pte) >> 1)
-#define pgoff_to_pte(off)	((pte_t) { ((off) << 1) | _PAGE_FILE })
 #endif
 
 #endif /* __ASSEMBLY__ */
diff -puN arch/sh/include/asm/pgtable_64.h~sh-drop-_page_file-and-pte_file-related-helpers arch/sh/include/asm/pgtable_64.h
--- a/arch/sh/include/asm/pgtable_64.h~sh-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/sh/include/asm/pgtable_64.h
@@ -107,7 +107,6 @@ static __inline__ void set_pte(pte_t *pt
 #define _PAGE_DEVICE	0x001  /* CB0: if uncacheable, 1->device (i.e. no write-combining or reordering at bus level) */
 #define _PAGE_CACHABLE	0x002  /* CB1: uncachable/cachable */
 #define _PAGE_PRESENT	0x004  /* software: page referenced */
-#define _PAGE_FILE	0x004  /* software: only when !present */
 #define _PAGE_SIZE0	0x008  /* SZ0-bit : size of page */
 #define _PAGE_SIZE1	0x010  /* SZ1-bit : size of page */
 #define _PAGE_SHARED	0x020  /* software: reflects PTEH's SH */
@@ -129,7 +128,7 @@ static __inline__ void set_pte(pte_t *pt
 #define _PAGE_WIRED	_PAGE_EXT(0x001) /* software: wire the tlb entry */
 #define _PAGE_SPECIAL	_PAGE_EXT(0x002)
 
-#define _PAGE_CLEAR_FLAGS	(_PAGE_PRESENT | _PAGE_FILE | _PAGE_SHARED | \
+#define _PAGE_CLEAR_FLAGS	(_PAGE_PRESENT | _PAGE_SHARED | \
 				 _PAGE_DIRTY | _PAGE_ACCESSED | _PAGE_WIRED)
 
 /* Mask which drops software flags */
@@ -260,7 +259,6 @@ static __inline__ void set_pte(pte_t *pt
  */
 static inline int pte_dirty(pte_t pte)  { return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)  { return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)   { return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_write(pte_t pte)  { return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_special(pte_t pte){ return pte_val(pte) & _PAGE_SPECIAL; }
 
@@ -304,11 +302,6 @@ static inline pte_t pte_modify(pte_t pte
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/* Encode and decode a nonlinear file mapping entry */
-#define PTE_FILE_MAX_BITS		29
-#define pte_to_pgoff(pte)		(pte_val(pte))
-#define pgoff_to_pte(off)		((pte_t) { (off) | _PAGE_FILE })
-
 #endif /* !__ASSEMBLY__ */
 
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch

