From: akpm@linux-foundation.org
Subject: + parisc-drop-_page_file-and-pte_file-related-helpers.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:34:44 -0800
Message-ID: <54ac7114.E0G/EdDFciPYgqbC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44704 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, deller@gmx.de, jejb@parisc-linux.org, mm-commits@vger.kernel.org


The patch titled
     Subject: parisc: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     parisc-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/parisc-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/parisc-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: parisc: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgtable.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN arch/parisc/include/asm/pgtable.h~parisc-drop-_page_file-and-pte_file-related-helpers arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~parisc-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/parisc/include/asm/pgtable.h
@@ -146,7 +146,6 @@ extern void purge_tlb_entries(struct mm_
 #define _PAGE_GATEWAY_BIT  28   /* (0x008) privilege promotion allowed */
 #define _PAGE_DMB_BIT      27   /* (0x010) Data Memory Break enable (B bit) */
 #define _PAGE_DIRTY_BIT    26   /* (0x020) Page Dirty (D bit) */
-#define _PAGE_FILE_BIT	_PAGE_DIRTY_BIT	/* overload this bit */
 #define _PAGE_REFTRAP_BIT  25   /* (0x040) Page Ref. Trap enable (T bit) */
 #define _PAGE_NO_CACHE_BIT 24   /* (0x080) Uncached Page (U bit) */
 #define _PAGE_ACCESSED_BIT 23   /* (0x100) Software: Page Accessed */
@@ -167,13 +166,6 @@ extern void purge_tlb_entries(struct mm_
 /* PFN_PTE_SHIFT defines the shift of a PTE value to access the PFN field */
 #define PFN_PTE_SHIFT		12
 
-
-/* this is how many bits may be used by the file functions */
-#define PTE_FILE_MAX_BITS	(BITS_PER_LONG - PTE_SHIFT)
-
-#define pte_to_pgoff(pte) (pte_val(pte) >> PTE_SHIFT)
-#define pgoff_to_pte(off) ((pte_t) { ((off) << PTE_SHIFT) | _PAGE_FILE })
-
 #define _PAGE_READ     (1 << xlate_pabit(_PAGE_READ_BIT))
 #define _PAGE_WRITE    (1 << xlate_pabit(_PAGE_WRITE_BIT))
 #define _PAGE_RW       (_PAGE_READ | _PAGE_WRITE)
@@ -186,7 +178,6 @@ extern void purge_tlb_entries(struct mm_
 #define _PAGE_ACCESSED (1 << xlate_pabit(_PAGE_ACCESSED_BIT))
 #define _PAGE_PRESENT  (1 << xlate_pabit(_PAGE_PRESENT_BIT))
 #define _PAGE_USER     (1 << xlate_pabit(_PAGE_USER_BIT))
-#define _PAGE_FILE     (1 << xlate_pabit(_PAGE_FILE_BIT))
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_READ | _PAGE_WRITE |  _PAGE_DIRTY | _PAGE_ACCESSED)
 #define _PAGE_CHG_MASK	(PAGE_MASK | _PAGE_ACCESSED | _PAGE_DIRTY)
@@ -344,7 +335,6 @@ static inline void pgd_clear(pgd_t * pgd
 static inline int pte_dirty(pte_t pte)		{ return pte_val(pte) & _PAGE_DIRTY; }
 static inline int pte_young(pte_t pte)		{ return pte_val(pte) & _PAGE_ACCESSED; }
 static inline int pte_write(pte_t pte)		{ return pte_val(pte) & _PAGE_WRITE; }
-static inline int pte_file(pte_t pte)		{ return pte_val(pte) & _PAGE_FILE; }
 static inline int pte_special(pte_t pte)	{ return 0; }
 
 static inline pte_t pte_mkclean(pte_t pte)	{ pte_val(pte) &= ~_PAGE_DIRTY; return pte; }
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

