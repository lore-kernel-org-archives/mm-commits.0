From: akpm@linux-foundation.org
Subject: + m68k-drop-_page_file-and-pte_file-related-helpers.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 15:34:30 -0800
Message-ID: <54ac7106.N0+fFRnDBA938khL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbbAFXeb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, geert@linux-m68k.org, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     m68k-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-drop-_page_file-and-pte_file-related-helpers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: m68k: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/include/asm/mcf_pgtable.h      |   23 +--------------------
 arch/m68k/include/asm/motorola_pgtable.h |   15 -------------
 arch/m68k/include/asm/pgtable_no.h       |    2 -
 arch/m68k/include/asm/sun3_pgtable.h     |   15 -------------
 4 files changed, 2 insertions(+), 53 deletions(-)

diff -puN arch/m68k/include/asm/mcf_pgtable.h~m68k-drop-_page_file-and-pte_file-related-helpers arch/m68k/include/asm/mcf_pgtable.h
--- a/arch/m68k/include/asm/mcf_pgtable.h~m68k-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/m68k/include/asm/mcf_pgtable.h
@@ -35,7 +35,6 @@
  * hitting hardware.
  */
 #define CF_PAGE_DIRTY		0x00000001
-#define CF_PAGE_FILE		0x00000200
 #define CF_PAGE_ACCESSED	0x00001000
 
 #define _PAGE_CACHE040		0x020   /* 68040 cache mode, cachable, copyback */
@@ -243,11 +242,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & CF_PAGE_ACCESSED;
 }
 
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & CF_PAGE_FILE;
-}
-
 static inline int pte_special(pte_t pte)
 {
 	return 0;
@@ -391,26 +385,13 @@ static inline void cache_page(void *vadd
 	*ptep = pte_mkcache(*ptep);
 }
 
-#define PTE_FILE_MAX_BITS	21
-#define PTE_FILE_SHIFT		11
-
-static inline unsigned long pte_to_pgoff(pte_t pte)
-{
-	return pte_val(pte) >> PTE_FILE_SHIFT;
-}
-
-static inline pte_t pgoff_to_pte(unsigned pgoff)
-{
-	return __pte((pgoff << PTE_FILE_SHIFT) + CF_PAGE_FILE);
-}
-
 /*
  * Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e))
  */
 #define __swp_type(x)		((x).val & 0xFF)
-#define __swp_offset(x)		((x).val >> PTE_FILE_SHIFT)
+#define __swp_offset(x)		((x).val >> 11)
 #define __swp_entry(typ, off)	((swp_entry_t) { (typ) | \
-					(off << PTE_FILE_SHIFT) })
+					(off << 11) })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	(__pte((x).val))
 
diff -puN arch/m68k/include/asm/motorola_pgtable.h~m68k-drop-_page_file-and-pte_file-related-helpers arch/m68k/include/asm/motorola_pgtable.h
--- a/arch/m68k/include/asm/motorola_pgtable.h~m68k-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/m68k/include/asm/motorola_pgtable.h
@@ -28,7 +28,6 @@
 #define _PAGE_CHG_MASK  (PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_NOCACHE)
 
 #define _PAGE_PROTNONE	0x004
-#define _PAGE_FILE	0x008	/* pagecache or swap? */
 
 #ifndef __ASSEMBLY__
 
@@ -168,7 +167,6 @@ static inline void pgd_set(pgd_t *pgdp,
 static inline int pte_write(pte_t pte)		{ return !(pte_val(pte) & _PAGE_RONLY); }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) |= _PAGE_RONLY; return pte; }
@@ -266,19 +264,6 @@ static inline void cache_page(void *vadd
 	}
 }
 
-#define PTE_FILE_MAX_BITS	28
-
-static inline unsigned long pte_to_pgoff(pte_t pte)
-{
-	return pte.pte >> 4;
-}
-
-static inline pte_t pgoff_to_pte(unsigned off)
-{
-	pte_t pte = { (off << 4) + _PAGE_FILE };
-	return pte;
-}
-
 /* Encode and de-code a swap entry (must be !pte_none(e) && !pte_present(e)) */
 #define __swp_type(x)		(((x).val >> 4) & 0xff)
 #define __swp_offset(x)		((x).val >> 12)
diff -puN arch/m68k/include/asm/pgtable_no.h~m68k-drop-_page_file-and-pte_file-related-helpers arch/m68k/include/asm/pgtable_no.h
--- a/arch/m68k/include/asm/pgtable_no.h~m68k-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/m68k/include/asm/pgtable_no.h
@@ -37,8 +37,6 @@ extern void paging_init(void);
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-static inline int pte_file(pte_t pte) { return 0; }
-
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
diff -puN arch/m68k/include/asm/sun3_pgtable.h~m68k-drop-_page_file-and-pte_file-related-helpers arch/m68k/include/asm/sun3_pgtable.h
--- a/arch/m68k/include/asm/sun3_pgtable.h~m68k-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/m68k/include/asm/sun3_pgtable.h
@@ -38,8 +38,6 @@
 #define _PAGE_PRESENT	(SUN3_PAGE_VALID)
 #define _PAGE_ACCESSED	(SUN3_PAGE_ACCESSED)
 
-#define PTE_FILE_MAX_BITS 28
-
 /* Compound page protection values. */
 //todo: work out which ones *should* have SUN3_PAGE_NOCACHE and fix...
 // is it just PAGE_KERNEL and PAGE_SHARED?
@@ -168,7 +166,6 @@ static inline void pgd_clear (pgd_t *pgd
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_WRITEABLE; }
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_MODIFIED; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & SUN3_PAGE_ACCESSED; }
 static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_wrprotect(pte_t pte)	{ pte_val(pte) &= ~SUN3_PAGE_WRITEABLE; return pte; }
@@ -202,18 +199,6 @@ static inline pmd_t *pmd_offset (pgd_t *
 	return (pmd_t *) pgd;
 }
 
-static inline unsigned long pte_to_pgoff(pte_t pte)
-{
-	return pte.pte & SUN3_PAGE_PGNUM_MASK;
-}
-
-static inline pte_t pgoff_to_pte(unsigned off)
-{
-	pte_t pte = { off + SUN3_PAGE_ACCESSED };
-	return pte;
-}
-
