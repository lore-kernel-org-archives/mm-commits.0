From: akpm@linux-foundation.org
Subject: [merged] mips-drop-_page_file-and-pte_file-related-helpers.patch
 removed from -mm tree
Date: Wed, 11 Feb 2015 12:22:35 -0800
Message-ID: <54dbba0b.GktidK+ueT+BrsF0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbbBKUWg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:22:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, kirill.shutemov@linux.intel.com, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mips: drop _PAGE_FILE and pte_file()-related helpers
has been removed from the -mm tree.  Its filename was
     mips-drop-_page_file-and-pte_file-related-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: mips: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/pgtable-32.h   |   36 -------------------------
 arch/mips/include/asm/pgtable-64.h   |    9 ------
 arch/mips/include/asm/pgtable-bits.h |    9 ------
 arch/mips/include/asm/pgtable.h      |    2 -
 4 files changed, 56 deletions(-)

diff -puN arch/mips/include/asm/pgtable-32.h~mips-drop-_page_file-and-pte_file-related-helpers arch/mips/include/asm/pgtable-32.h
--- a/arch/mips/include/asm/pgtable-32.h~mips-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/mips/include/asm/pgtable-32.h
@@ -161,22 +161,6 @@ pfn_pte(unsigned long pfn, pgprot_t prot
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/*
- * Encode and decode a nonlinear file mapping entry
- */
-#define pte_to_pgoff(_pte)		((((_pte).pte >> 1 ) & 0x07) | \
-					 (((_pte).pte >> 2 ) & 0x38) | \
-					 (((_pte).pte >> 10) <<	 6 ))
-
-#define pgoff_to_pte(off)		((pte_t) { (((off) & 0x07) << 1 ) | \
-						   (((off) & 0x38) << 2 ) | \
-						   (((off) >>  6 ) << 10) | \
-						   _PAGE_FILE })
-
-/*
- * Bits 0, 4, 8, and 9 are taken, split up 28 bits of offset into this range:
- */
-#define PTE_FILE_MAX_BITS		28
 #else
 
 #if defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
@@ -188,13 +172,6 @@ pfn_pte(unsigned long pfn, pgprot_t prot
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { (pte).pte_high })
 #define __swp_entry_to_pte(x)		((pte_t) { 0, (x).val })
 
-/*
- * Bits 0 and 1 of pte_high are taken, use the rest for the page offset...
- */
-#define pte_to_pgoff(_pte)		((_pte).pte_high >> 2)
-#define pgoff_to_pte(off)		((pte_t) { _PAGE_FILE, (off) << 2 })
-
-#define PTE_FILE_MAX_BITS		30
 #else
 /*
  * Constraints:
@@ -209,19 +186,6 @@ pfn_pte(unsigned long pfn, pgprot_t prot
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
-/*
- * Encode and decode a nonlinear file mapping entry
- */
-#define pte_to_pgoff(_pte)		((((_pte).pte >> 1) & 0x7) | \
-					 (((_pte).pte >> 2) & 0x8) | \
-					 (((_pte).pte >> 8) <<	4))
-
-#define pgoff_to_pte(off)		((pte_t) { (((off) & 0x7) << 1) | \
-						   (((off) & 0x8) << 2) | \
-						   (((off) >>  4) << 8) | \
-						   _PAGE_FILE })
-
-#define PTE_FILE_MAX_BITS		28
 #endif /* defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32) */
 
 #endif /* defined(CONFIG_CPU_R3000) || defined(CONFIG_CPU_TX39XX) */
diff -puN arch/mips/include/asm/pgtable-64.h~mips-drop-_page_file-and-pte_file-related-helpers arch/mips/include/asm/pgtable-64.h
--- a/arch/mips/include/asm/pgtable-64.h~mips-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/mips/include/asm/pgtable-64.h
@@ -291,13 +291,4 @@ static inline pte_t mk_swap_pte(unsigned
 #define __pte_to_swp_entry(pte) ((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-/*
- * Bits 0, 4, 6, and 7 are taken. Let's leave bits 1, 2, 3, and 5 alone to
- * make things easier, and only use the upper 56 bits for the page offset...
- */
-#define PTE_FILE_MAX_BITS	56
-
-#define pte_to_pgoff(_pte)	((_pte).pte >> 8)
-#define pgoff_to_pte(off)	((pte_t) { ((off) << 8) | _PAGE_FILE })
-
 #endif /* _ASM_PGTABLE_64_H */
diff -puN arch/mips/include/asm/pgtable-bits.h~mips-drop-_page_file-and-pte_file-related-helpers arch/mips/include/asm/pgtable-bits.h
--- a/arch/mips/include/asm/pgtable-bits.h~mips-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/mips/include/asm/pgtable-bits.h
@@ -48,8 +48,6 @@
 
 /*
  * The following bits are implemented in software
- *
- * _PAGE_FILE semantics: set:pagecache unset:swap
  */
 #define _PAGE_PRESENT_SHIFT	(_CACHE_SHIFT + 3)
 #define _PAGE_PRESENT		(1 << _PAGE_PRESENT_SHIFT)
@@ -64,7 +62,6 @@
 
 #define _PAGE_SILENT_READ	_PAGE_VALID
 #define _PAGE_SILENT_WRITE	_PAGE_DIRTY
-#define _PAGE_FILE		_PAGE_MODIFIED
 
 #define _PFN_SHIFT		(PAGE_SHIFT - 12 + _CACHE_SHIFT + 3)
 
@@ -72,8 +69,6 @@
 
 /*
  * The following are implemented by software
- *
- * _PAGE_FILE semantics: set:pagecache unset:swap
  */
 #define _PAGE_PRESENT_SHIFT	0
 #define _PAGE_PRESENT		(1 <<  _PAGE_PRESENT_SHIFT)
@@ -85,8 +80,6 @@
 #define _PAGE_ACCESSED		(1 <<  _PAGE_ACCESSED_SHIFT)
 #define _PAGE_MODIFIED_SHIFT	4
 #define _PAGE_MODIFIED		(1 <<  _PAGE_MODIFIED_SHIFT)
-#define _PAGE_FILE_SHIFT	4
-#define _PAGE_FILE		(1 <<  _PAGE_FILE_SHIFT)
 
 /*
  * And these are the hardware TLB bits
@@ -116,7 +109,6 @@
  * The following bits are implemented in software
  *
  * _PAGE_READ / _PAGE_READ_SHIFT should be unused if cpu_has_rixi.
- * _PAGE_FILE semantics: set:pagecache unset:swap
  */
 #define _PAGE_PRESENT_SHIFT	(0)
 #define _PAGE_PRESENT		(1 << _PAGE_PRESENT_SHIFT)
@@ -128,7 +120,6 @@
 #define _PAGE_ACCESSED		(1 << _PAGE_ACCESSED_SHIFT)
 #define _PAGE_MODIFIED_SHIFT	(_PAGE_ACCESSED_SHIFT + 1)
 #define _PAGE_MODIFIED		(1 << _PAGE_MODIFIED_SHIFT)
-#define _PAGE_FILE		(_PAGE_MODIFIED)
 
 #ifdef CONFIG_MIPS_HUGE_TLB_SUPPORT
 /* huge tlb page */
diff -puN arch/mips/include/asm/pgtable.h~mips-drop-_page_file-and-pte_file-related-helpers arch/mips/include/asm/pgtable.h
--- a/arch/mips/include/asm/pgtable.h~mips-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/mips/include/asm/pgtable.h
@@ -231,7 +231,6 @@ extern pgd_t swapper_pg_dir[];
 static inline int pte_write(pte_t pte)	{ return pte.pte_low & _PAGE_WRITE; }
 static inline int pte_dirty(pte_t pte)	{ return pte.pte_low & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)	{ return pte.pte_low & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)	{ return pte.pte_low & _PAGE_FILE; }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
@@ -287,7 +286,6 @@ static inline pte_t pte_mkyoung(pte_t pt
 static inline int pte_write(pte_t pte)	{ return pte_val(pte) & _PAGE_WRITE; }
 static inline int pte_dirty(pte_t pte)	{ return pte_val(pte) & _PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)	{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)	{ return pte_val(pte) & _PAGE_FILE; }
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
_

Patches currently in -mm which might be from kirill@shutemov.name are

origin.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix-2.patch
mm-fix-false-positive-warning-on-exit-due-mm_nr_pmdsmm-fix.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
docs-procs-describe-proc-pid-map_files-entry.patch
docs-procs-describe-proc-pid-map_files-entry-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

