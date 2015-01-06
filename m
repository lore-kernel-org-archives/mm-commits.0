From: akpm@linux-foundation.org
Subject: + nios2-drop-_page_file-and-pte_file-related-helpers.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 15:34:40 -0800
Message-ID: <54ac7110.dsTkR6QGe2iojA2m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXel (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, lftan@altera.com, tklauser@distanz.ch, mm-commits@vger.kernel.org


The patch titled
     Subject: nios2: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     nios2-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nios2-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nios2-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: nios2: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Ley Foon Tan <lftan@altera.com>
Reviewed-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/nios2/include/asm/pgtable-bits.h |    1 -
 arch/nios2/include/asm/pgtable.h      |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/nios2/include/asm/pgtable-bits.h~nios2-drop-_page_file-and-pte_file-related-helpers arch/nios2/include/asm/pgtable-bits.h
--- a/arch/nios2/include/asm/pgtable-bits.h~nios2-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/nios2/include/asm/pgtable-bits.h
@@ -30,6 +30,5 @@
 #define _PAGE_PRESENT	(1<<25)	/* PTE contains a translation */
 #define _PAGE_ACCESSED	(1<<26)	/* page referenced */
 #define _PAGE_DIRTY	(1<<27)	/* dirty page */
-#define _PAGE_FILE	(1<<28)	/* PTE used for file mapping or swap */
 
 #endif /* _ASM_NIOS2_PGTABLE_BITS_H */
diff -puN arch/nios2/include/asm/pgtable.h~nios2-drop-_page_file-and-pte_file-related-helpers arch/nios2/include/asm/pgtable.h
--- a/arch/nios2/include/asm/pgtable.h~nios2-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/nios2/include/asm/pgtable.h
@@ -112,8 +112,6 @@ static inline int pte_dirty(pte_t pte)
 	{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		\
 	{ return pte_val(pte) & _PAGE_ACCESSED; }
-static inline int pte_file(pte_t pte)		\
-	{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return 0; }
 
 #define pgprot_noncached pgprot_noncached
@@ -272,8 +270,7 @@ static inline void pte_clear(struct mm_s
 		__FILE__, __LINE__, pgd_val(e))
 
 /*
- * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte)
- * && !pte_file(pte)):
+ * Encode and decode a swap entry (must be !pte_none(pte) && !pte_present(pte):
  *
  * 31 30 29 28 27 26 25 24 23 22 21 20 19 18 ...  1  0
  *  0  0  0  0 type.  0  0  0  0  0  0 offset.........
@@ -290,11 +287,6 @@ static inline void pte_clear(struct mm_s
 #define __swp_entry_to_pte(swp)	((pte_t) { (swp).val })
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 
-/* Encode and decode a nonlinear file mapping entry */
-#define PTE_FILE_MAX_BITS	25
-#define pte_to_pgoff(pte)	(pte_val(pte) & 0x1ffffff)
-#define pgoff_to_pte(off)	__pte(((off) & 0x1ffffff) | _PAGE_FILE)
-
 #define kern_addr_valid(addr)		(1)
 
 #include <asm-generic/pgtable.h>
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

