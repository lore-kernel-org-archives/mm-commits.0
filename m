From: akpm@linux-foundation.org
Subject: + m32r-drop-_page_file-and-pte_file-related-helpers.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 15:34:28 -0800
Message-ID: <54ac7104.hDjpam48WyvXyIBG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbbAFXe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: m32r: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     m32r-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m32r-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m32r-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: m32r: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m32r/include/asm/pgtable-2level.h |    4 ----
 arch/m32r/include/asm/pgtable.h        |   11 -----------
 2 files changed, 15 deletions(-)

diff -puN arch/m32r/include/asm/pgtable-2level.h~m32r-drop-_page_file-and-pte_file-related-helpers arch/m32r/include/asm/pgtable-2level.h
--- a/arch/m32r/include/asm/pgtable-2level.h~m32r-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/m32r/include/asm/pgtable-2level.h
@@ -70,9 +70,5 @@ static inline pmd_t *pmd_offset(pgd_t *
 #define pfn_pte(pfn, prot)	__pte(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 #define pfn_pmd(pfn, prot)	__pmd(((pfn) << PAGE_SHIFT) | pgprot_val(prot))
 
-#define PTE_FILE_MAX_BITS	29
-#define pte_to_pgoff(pte)	(((pte_val(pte) >> 2) & 0x7f) | (((pte_val(pte) >> 10)) << 7))
-#define pgoff_to_pte(off)	((pte_t) { (((off) & 0x7f) << 2) | (((off) >> 7) << 10) | _PAGE_FILE })
-
 #endif /* __KERNEL__ */
 #endif /* _ASM_M32R_PGTABLE_2LEVEL_H */
diff -puN arch/m32r/include/asm/pgtable.h~m32r-drop-_page_file-and-pte_file-related-helpers arch/m32r/include/asm/pgtable.h
--- a/arch/m32r/include/asm/pgtable.h~m32r-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/m32r/include/asm/pgtable.h
@@ -80,8 +80,6 @@ extern unsigned long empty_zero_page[102
  */
 
 #define _PAGE_BIT_DIRTY		0	/* software: page changed */
-#define _PAGE_BIT_FILE		0	/* when !present: nonlinear file
-					   mapping */
 #define _PAGE_BIT_PRESENT	1	/* Valid: page is valid */
 #define _PAGE_BIT_GLOBAL	2	/* Global */
 #define _PAGE_BIT_LARGE		3	/* Large */
@@ -93,7 +91,6 @@ extern unsigned long empty_zero_page[102
 #define _PAGE_BIT_PROTNONE	9	/* software: if not present */
 
 #define _PAGE_DIRTY		(1UL << _PAGE_BIT_DIRTY)
-#define _PAGE_FILE		(1UL << _PAGE_BIT_FILE)
 #define _PAGE_PRESENT		(1UL << _PAGE_BIT_PRESENT)
 #define _PAGE_GLOBAL		(1UL << _PAGE_BIT_GLOBAL)
 #define _PAGE_LARGE		(1UL << _PAGE_BIT_LARGE)
@@ -206,14 +203,6 @@ static inline int pte_write(pte_t pte)
 	return pte_val(pte) & _PAGE_WRITE;
 }
 
-/*
- * The following only works if pte_present() is not true.
- */
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_FILE;
-}
-
 static inline int pte_special(pte_t pte)
 {
 	return 0;
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

