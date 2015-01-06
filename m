From: akpm@linux-foundation.org
Subject: + x86-drop-_page_file-and-pte_file-related-helpers.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:35:02 -0800
Message-ID: <54ac7126.GAbMWTpB/QaF50SF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44796 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbbAFXfD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:35:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: drop _PAGE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     x86-drop-_page_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-drop-_page_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-drop-_page_file-and-pte_file-related-helpers.patch

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
Subject: x86: drop _PAGE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable-2level.h |   38 ------------------------
 arch/x86/include/asm/pgtable-3level.h |   12 -------
 arch/x86/include/asm/pgtable.h        |   20 ------------
 arch/x86/include/asm/pgtable_64.h     |    6 ---
 arch/x86/include/asm/pgtable_types.h  |    3 -
 5 files changed, 2 insertions(+), 77 deletions(-)

diff -puN arch/x86/include/asm/pgtable-2level.h~x86-drop-_page_file-and-pte_file-related-helpers arch/x86/include/asm/pgtable-2level.h
--- a/arch/x86/include/asm/pgtable-2level.h~x86-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/x86/include/asm/pgtable-2level.h
@@ -62,44 +62,8 @@ static inline unsigned long pte_bitop(un
 	return ((value >> rightshift) & mask) << leftshift;
 }
 
-/*
- * Bits _PAGE_BIT_PRESENT, _PAGE_BIT_FILE and _PAGE_BIT_PROTNONE are taken,
- * split up the 29 bits of offset into this range.
- */
-#define PTE_FILE_MAX_BITS	29
-#define PTE_FILE_SHIFT1		(_PAGE_BIT_PRESENT + 1)
-#define PTE_FILE_SHIFT2		(_PAGE_BIT_FILE + 1)
-#define PTE_FILE_SHIFT3		(_PAGE_BIT_PROTNONE + 1)
-#define PTE_FILE_BITS1		(PTE_FILE_SHIFT2 - PTE_FILE_SHIFT1 - 1)
-#define PTE_FILE_BITS2		(PTE_FILE_SHIFT3 - PTE_FILE_SHIFT2 - 1)
-
-#define PTE_FILE_MASK1		((1U << PTE_FILE_BITS1) - 1)
-#define PTE_FILE_MASK2		((1U << PTE_FILE_BITS2) - 1)
-
-#define PTE_FILE_LSHIFT2	(PTE_FILE_BITS1)
-#define PTE_FILE_LSHIFT3	(PTE_FILE_BITS1 + PTE_FILE_BITS2)
-
-static __always_inline pgoff_t pte_to_pgoff(pte_t pte)
-{
-	return (pgoff_t)
-		(pte_bitop(pte.pte_low, PTE_FILE_SHIFT1, PTE_FILE_MASK1,  0)		    +
-		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT2, PTE_FILE_MASK2,  PTE_FILE_LSHIFT2) +
-		 pte_bitop(pte.pte_low, PTE_FILE_SHIFT3,           -1UL,  PTE_FILE_LSHIFT3));
-}
-
-static __always_inline pte_t pgoff_to_pte(pgoff_t off)
-{
-	return (pte_t){
-		.pte_low =
-			pte_bitop(off,                0, PTE_FILE_MASK1,  PTE_FILE_SHIFT1) +
-			pte_bitop(off, PTE_FILE_LSHIFT2, PTE_FILE_MASK2,  PTE_FILE_SHIFT2) +
-			pte_bitop(off, PTE_FILE_LSHIFT3,           -1UL,  PTE_FILE_SHIFT3) +
-			_PAGE_FILE,
-	};
-}
-
 /* Encode and de-code a swap entry */
-#define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
+#define SWP_TYPE_BITS 5
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 1)
 
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > SWP_TYPE_BITS)
diff -puN arch/x86/include/asm/pgtable-3level.h~x86-drop-_page_file-and-pte_file-related-helpers arch/x86/include/asm/pgtable-3level.h
--- a/arch/x86/include/asm/pgtable-3level.h~x86-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/x86/include/asm/pgtable-3level.h
@@ -176,18 +176,6 @@ static inline pmd_t native_pmdp_get_and_
 #define native_pmdp_get_and_clear(xp) native_local_pmdp_get_and_clear(xp)
 #endif
 
-/*
- * Bits 0, 6 and 7 are taken in the low part of the pte,
- * put the 32 bits of offset into the high part.
- *
- * For soft-dirty tracking 11 bit is taken from
- * the low part of pte as well.
- */
-#define pte_to_pgoff(pte) ((pte).pte_high)
-#define pgoff_to_pte(off)						\
-	((pte_t) { { .pte_low = _PAGE_FILE, .pte_high = (off) } })
-#define PTE_FILE_MAX_BITS       32
-
 /* Encode and de-code a swap entry */
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > 5)
 #define __swp_type(x)			(((x).val) & 0x1f)
diff -puN arch/x86/include/asm/pgtable.h~x86-drop-_page_file-and-pte_file-related-helpers arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~x86-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/x86/include/asm/pgtable.h
@@ -115,11 +115,6 @@ static inline int pte_write(pte_t pte)
 	return pte_flags(pte) & _PAGE_RW;
 }
 
-static inline int pte_file(pte_t pte)
-{
-	return pte_flags(pte) & _PAGE_FILE;
-}
-
 static inline int pte_huge(pte_t pte)
 {
 	return pte_flags(pte) & _PAGE_PSE;
@@ -329,21 +324,6 @@ static inline pmd_t pmd_mksoft_dirty(pmd
 	return pmd_set_flags(pmd, _PAGE_SOFT_DIRTY);
 }
 
-static inline pte_t pte_file_clear_soft_dirty(pte_t pte)
-{
-	return pte_clear_flags(pte, _PAGE_SOFT_DIRTY);
-}
-
-static inline pte_t pte_file_mksoft_dirty(pte_t pte)
-{
-	return pte_set_flags(pte, _PAGE_SOFT_DIRTY);
-}
-
-static inline int pte_file_soft_dirty(pte_t pte)
-{
-	return pte_flags(pte) & _PAGE_SOFT_DIRTY;
-}
-
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 /*
diff -puN arch/x86/include/asm/pgtable_64.h~x86-drop-_page_file-and-pte_file-related-helpers arch/x86/include/asm/pgtable_64.h
--- a/arch/x86/include/asm/pgtable_64.h~x86-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/x86/include/asm/pgtable_64.h
@@ -133,10 +133,6 @@ static inline int pgd_large(pgd_t pgd) {
 /* PUD - Level3 access */
 
 /* PMD  - Level 2 access */
-#define pte_to_pgoff(pte) ((pte_val((pte)) & PHYSICAL_PAGE_MASK) >> PAGE_SHIFT)
-#define pgoff_to_pte(off) ((pte_t) { .pte = ((off) << PAGE_SHIFT) |	\
-					    _PAGE_FILE })
-#define PTE_FILE_MAX_BITS __PHYSICAL_MASK_SHIFT
 
 /* PTE - Level 1 access. */
 
@@ -145,7 +141,7 @@ static inline int pgd_large(pgd_t pgd) {
 #define pte_unmap(pte) ((void)(pte))/* NOP */
 
 /* Encode and de-code a swap entry */
-#define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
+#define SWP_TYPE_BITS 5
 #ifdef CONFIG_NUMA_BALANCING
 /* Automatic NUMA balancing needs to be distinguishable from swap entries */
 #define SWP_OFFSET_SHIFT (_PAGE_BIT_PROTNONE + 2)
diff -puN arch/x86/include/asm/pgtable_types.h~x86-drop-_page_file-and-pte_file-related-helpers arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~x86-drop-_page_file-and-pte_file-related-helpers
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -38,8 +38,6 @@
 /* If _PAGE_BIT_PRESENT is clear, we use these: */
 /* - if the user mapped it with PROT_NONE; pte_present gives true */
 #define _PAGE_BIT_PROTNONE	_PAGE_BIT_GLOBAL
-/* - set: nonlinear file mapping, saved PTE; unset:swap */
-#define _PAGE_BIT_FILE		_PAGE_BIT_DIRTY
 
 #define _PAGE_PRESENT	(_AT(pteval_t, 1) << _PAGE_BIT_PRESENT)
 #define _PAGE_RW	(_AT(pteval_t, 1) << _PAGE_BIT_RW)
@@ -114,7 +112,6 @@
 #define _PAGE_NX	(_AT(pteval_t, 0))
 #endif
 
-#define _PAGE_FILE	(_AT(pteval_t, 1) << _PAGE_BIT_FILE)
 #define _PAGE_PROTNONE	(_AT(pteval_t, 1) << _PAGE_BIT_PROTNONE)
 
 #define _PAGE_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |	\
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

