From: akpm@linux-foundation.org
Subject: + um-drop-_page_file-and-pte_file-related-helpers.patch added to
 -mm tree
Date: Tue, 06 Jan 2015 15:34:58 -0800
Message-ID: <54ac7122.7qMF4laB5zTMIxUu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXe7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, jdike@addtoit.com, richard@nod.at, mm-commits@vger.kernel.org


The patch titled
     Subject: um: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     um-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/um-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/um-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: um: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/include/asm/pgtable-2level.h |    9 ---------
 arch/um/include/asm/pgtable-3level.h |   20 --------------------
 arch/um/include/asm/pgtable.h        |    9 ---------
 3 files changed, 38 deletions(-)

diff -puN arch/um/include/asm/pgtable-2level.h~um-drop-_page_file-and-pte_file-related-helpers arch/um/include/asm/pgtable-2level.h
--- a/arch/um/include/asm/pgtable-2level.h~um-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/um/include/asm/pgtable-2level.h
@@ -41,13 +41,4 @@ static inline void pgd_mkuptodate(pgd_t
 #define pfn_pte(pfn, prot) __pte(pfn_to_phys(pfn) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot) __pmd(pfn_to_phys(pfn) | pgprot_val(prot))
 
-/*
- * Bits 0 through 4 are taken
- */
-#define PTE_FILE_MAX_BITS	27
-
-#define pte_to_pgoff(pte) (pte_val(pte) >> 5)
-
-#define pgoff_to_pte(off) ((pte_t) { ((off) << 5) + _PAGE_FILE })
-
 #endif
diff -puN arch/um/include/asm/pgtable-3level.h~um-drop-_page_file-and-pte_file-related-helpers arch/um/include/asm/pgtable-3level.h
--- a/arch/um/include/asm/pgtable-3level.h~um-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/um/include/asm/pgtable-3level.h
@@ -112,25 +112,5 @@ static inline pmd_t pfn_pmd(pfn_t page_n
 	return __pmd((page_nr << PAGE_SHIFT) | pgprot_val(pgprot));
 }
 
-/*
- * Bits 0 through 3 are taken in the low part of the pte,
- * put the 32 bits of offset into the high part.
- */
-#define PTE_FILE_MAX_BITS	32
-
-#ifdef CONFIG_64BIT
-
-#define pte_to_pgoff(p) ((p).pte >> 32)
-
-#define pgoff_to_pte(off) ((pte_t) { ((off) << 32) | _PAGE_FILE })
-
-#else
-
-#define pte_to_pgoff(pte) ((pte).pte_high)
-
-#define pgoff_to_pte(off) ((pte_t) { _PAGE_FILE, (off) })
-
-#endif
-
 #endif
 
diff -puN arch/um/include/asm/pgtable.h~um-drop-_page_file-and-pte_file-related-helpers arch/um/include/asm/pgtable.h
--- a/arch/um/include/asm/pgtable.h~um-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/um/include/asm/pgtable.h
@@ -18,7 +18,6 @@
 #define _PAGE_ACCESSED	0x080
 #define _PAGE_DIRTY	0x100
 /* If _PAGE_PRESENT is clear, we use these: */
-#define _PAGE_FILE	0x008	/* nonlinear file mapping, saved PTE; unset:swap */
 #define _PAGE_PROTNONE	0x010	/* if the user mapped it with PROT_NONE;
 				   pte_present gives true */
 
@@ -151,14 +150,6 @@ static inline int pte_write(pte_t pte)
 	       !(pte_get_bits(pte, _PAGE_PROTNONE)));
 }
 
-/*
- * The following only works if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)
-{
-	return pte_get_bits(pte, _PAGE_FILE);
-}
-
 static inline int pte_dirty(pte_t pte)
 {
 	return pte_get_bits(pte, _PAGE_DIRTY);
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

