From: akpm@linux-foundation.org
Subject: + s390-drop-pte_file-related-helpers.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:34:48 -0800
Message-ID: <54ac7118.p30z7t2w2X5iD5dK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXet (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: drop pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     s390-drop-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-drop-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-drop-pte_file-related-helpers.patch

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
Subject: s390: drop pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/include/asm/pgtable.h |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~s390-drop-pte_file-related-helpers arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~s390-drop-pte_file-related-helpers
+++ a/arch/s390/include/asm/pgtable.h
@@ -249,10 +249,10 @@ static inline int is_module_addr(void *a
 				 _PAGE_YOUNG)
 
 /*
- * handle_pte_fault uses pte_present, pte_none and pte_file to find out the
- * pte type WITHOUT holding the page table lock. The _PAGE_PRESENT bit
- * is used to distinguish present from not-present ptes. It is changed only
- * with the page table lock held.
+ * handle_pte_fault uses pte_present and pte_none to find out the pte type
+ * WITHOUT holding the page table lock. The _PAGE_PRESENT bit is used to
+ * distinguish present from not-present ptes. It is changed only with the page
+ * table lock held.
  *
  * The following table gives the different possible bit combinations for
  * the pte hardware and software bits in the last 12 bits of a pte:
@@ -279,7 +279,6 @@ static inline int is_module_addr(void *a
  *
  * pte_present is true for the bit pattern .xx...xxxxx1, (pte & 0x001) == 0x001
  * pte_none    is true for the bit pattern .10...xxxx00, (pte & 0x603) == 0x400
- * pte_file    is true for the bit pattern .11...xxxxx0, (pte & 0x601) == 0x600
  * pte_swap    is true for the bit pattern .10...xxxx10, (pte & 0x603) == 0x402
  */
 
@@ -671,13 +670,6 @@ static inline int pte_swap(pte_t pte)
 		== (_PAGE_INVALID | _PAGE_TYPE);
 }
 
-static inline int pte_file(pte_t pte)
-{
-	/* Bit pattern: (pte & 0x601) == 0x600 */
-	return (pte_val(pte) & (_PAGE_INVALID | _PAGE_PROTECT | _PAGE_PRESENT))
-		== (_PAGE_INVALID | _PAGE_PROTECT);
-}
-
 static inline int pte_special(pte_t pte)
 {
 	return (pte_val(pte) & _PAGE_SPECIAL);
@@ -1756,19 +1748,6 @@ static inline pte_t mk_swap_pte(unsigned
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
 
-#ifndef CONFIG_64BIT
-# define PTE_FILE_MAX_BITS	26
-#else /* CONFIG_64BIT */
-# define PTE_FILE_MAX_BITS	59
-#endif /* CONFIG_64BIT */
-
-#define pte_to_pgoff(__pte) \
-	((((__pte).pte >> 12) << 7) + (((__pte).pte >> 1) & 0x7f))
-
-#define pgoff_to_pte(__off) \
-	((pte_t) { ((((__off) & 0x7f) << 1) + (((__off) >> 7) << 12)) \
-		   | _PAGE_INVALID | _PAGE_PROTECT })
-
 #endif /* !__ASSEMBLY__ */
 
 #define kern_addr_valid(addr)   (1)
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

