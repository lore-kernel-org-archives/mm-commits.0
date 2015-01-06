From: akpm@linux-foundation.org
Subject: + score-drop-_page_file-and-pte_file-related-helpers.patch added
 to -mm tree
Date: Tue, 06 Jan 2015 15:34:50 -0800
Message-ID: <54ac711a.u+w3peF1ldIJh0O7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbbAFXev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, lennox.wu@gmail.com, liqin.linux@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: score: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     score-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/score-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/score-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: score: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.
Nobody creates non-linear mapping anymore.

This patch also increase number of bits availble for swap offset.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Chen Liqin <liqin.linux@gmail.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/score/include/asm/pgtable-bits.h |    1 -
 arch/score/include/asm/pgtable.h      |   18 ++----------------
 2 files changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/score/include/asm/pgtable-bits.h~score-drop-_page_file-and-pte_file-related-helpers arch/score/include/asm/pgtable-bits.h
--- a/arch/score/include/asm/pgtable-bits.h~score-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/score/include/asm/pgtable-bits.h
@@ -6,7 +6,6 @@
 #define _PAGE_WRITE			(1<<7)	/* implemented in software */
 #define _PAGE_PRESENT			(1<<9)	/* implemented in software */
 #define _PAGE_MODIFIED			(1<<10)	/* implemented in software */
-#define _PAGE_FILE			(1<<10)
 
 #define _PAGE_GLOBAL			(1<<0)
 #define _PAGE_VALID			(1<<1)
diff -puN arch/score/include/asm/pgtable.h~score-drop-_page_file-and-pte_file-related-helpers arch/score/include/asm/pgtable.h
--- a/arch/score/include/asm/pgtable.h~score-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/score/include/asm/pgtable.h
@@ -90,15 +90,6 @@ static inline void pmd_clear(pmd_t *pmdp
 	((pte_t *)page_address(pmd_page(*(dir))) + __pte_offset(address))
 #define pte_unmap(pte) ((void)(pte))
 
-/*
- * Bits 9(_PAGE_PRESENT) and 10(_PAGE_FILE)are taken,
- * split up 30 bits of offset into this range:
- */
-#define PTE_FILE_MAX_BITS	30
-#define pte_to_pgoff(_pte)		\
-	(((_pte).pte & 0x1ff) | (((_pte).pte >> 11) << 9))
-#define pgoff_to_pte(off)		\
-	((pte_t) {((off) & 0x1ff) | (((off) >> 9) << 11) | _PAGE_FILE})
 #define __pte_to_swp_entry(pte)		\
 	((swp_entry_t) { pte_val(pte)})
 #define __swp_entry_to_pte(x)	((pte_t) {(x).val})
@@ -169,8 +160,8 @@ static inline pgprot_t pgprot_noncached(
 }
 
 #define __swp_type(x)		((x).val & 0x1f)
-#define __swp_offset(x) 	((x).val >> 11)
-#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 11)})
+#define __swp_offset(x) 	((x).val >> 10)
+#define __swp_entry(type, offset) ((swp_entry_t){(type) | ((offset) << 10)})
 
 extern unsigned long empty_zero_page;
 extern unsigned long zero_page_mask;
@@ -198,11 +189,6 @@ static inline int pte_young(pte_t pte)
 	return pte_val(pte) & _PAGE_ACCESSED;
 }
 
-static inline int pte_file(pte_t pte)
-{
-	return pte_val(pte) & _PAGE_FILE;
-}
-
 #define pte_special(pte)	(0)
 
 static inline pte_t pte_wrprotect(pte_t pte)
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

