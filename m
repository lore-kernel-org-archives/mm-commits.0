From: akpm@linux-foundation.org
Subject: + arm-drop-l_pte_file-and-pte_file-related-helpers.patch added to -mm tree
Date: Tue, 06 Jan 2015 15:34:12 -0800
Message-ID: <54ac70f4.pTXUtVMBKYxIaJVV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbbAFXeN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 18:34:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: arm: drop L_PTE_FILE and pte_file()-related helpers
has been added to the -mm tree.  Its filename is
     arm-drop-l_pte_file-and-pte_file-related-helpers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-drop-l_pte_file-and-pte_file-related-helpers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-drop-l_pte_file-and-pte_file-related-helpers.patch

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
Subject: arm: drop L_PTE_FILE and pte_file()-related helpers

We've replaced remap_file_pages(2) implementation with emulation.  Nobody
creates non-linear mapping anymore.

This patch also adjust __SWP_TYPE_SHIFT, effectively increase size of
possible swap file to 128G.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-2level.h |    1 -
 arch/arm/include/asm/pgtable-3level.h |    1 -
 arch/arm/include/asm/pgtable-nommu.h  |    2 --
 arch/arm/include/asm/pgtable.h        |   20 +++-----------------
 arch/arm/mm/proc-macros.S             |    2 +-
 5 files changed, 4 insertions(+), 22 deletions(-)

diff -puN arch/arm/include/asm/pgtable-2level.h~arm-drop-l_pte_file-and-pte_file-related-helpers arch/arm/include/asm/pgtable-2level.h
--- a/arch/arm/include/asm/pgtable-2level.h~arm-drop-l_pte_file-and-pte_file-related-helpers
+++ a/arch/arm/include/asm/pgtable-2level.h
@@ -118,7 +118,6 @@
 #define L_PTE_VALID		(_AT(pteval_t, 1) << 0)		/* Valid */
 #define L_PTE_PRESENT		(_AT(pteval_t, 1) << 0)
 #define L_PTE_YOUNG		(_AT(pteval_t, 1) << 1)
-#define L_PTE_FILE		(_AT(pteval_t, 1) << 2)	/* only when !PRESENT */
 #define L_PTE_DIRTY		(_AT(pteval_t, 1) << 6)
 #define L_PTE_RDONLY		(_AT(pteval_t, 1) << 7)
 #define L_PTE_USER		(_AT(pteval_t, 1) << 8)
diff -puN arch/arm/include/asm/pgtable-3level.h~arm-drop-l_pte_file-and-pte_file-related-helpers arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-drop-l_pte_file-and-pte_file-related-helpers
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -77,7 +77,6 @@
  */
 #define L_PTE_VALID		(_AT(pteval_t, 1) << 0)		/* Valid */
 #define L_PTE_PRESENT		(_AT(pteval_t, 3) << 0)		/* Present */
-#define L_PTE_FILE		(_AT(pteval_t, 1) << 2)		/* only when !PRESENT */
 #define L_PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
 #define L_PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
 #define L_PTE_YOUNG		(_AT(pteval_t, 1) << 10)	/* AF */
diff -puN arch/arm/include/asm/pgtable-nommu.h~arm-drop-l_pte_file-and-pte_file-related-helpers arch/arm/include/asm/pgtable-nommu.h
--- a/arch/arm/include/asm/pgtable-nommu.h~arm-drop-l_pte_file-and-pte_file-related-helpers
+++ a/arch/arm/include/asm/pgtable-nommu.h
@@ -54,8 +54,6 @@
 
 typedef pte_t *pte_addr_t;
 
-static inline int pte_file(pte_t pte) { return 0; }
-
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
diff -puN arch/arm/include/asm/pgtable.h~arm-drop-l_pte_file-and-pte_file-related-helpers arch/arm/include/asm/pgtable.h
--- a/arch/arm/include/asm/pgtable.h~arm-drop-l_pte_file-and-pte_file-related-helpers
+++ a/arch/arm/include/asm/pgtable.h
@@ -318,12 +318,12 @@ static inline pte_t pte_modify(pte_t pte
  *
  *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
  *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
- *   <--------------- offset ----------------------> < type -> 0 0 0
+ *   <--------------- offset ------------------------> < type -> 0 0
  *
- * This gives us up to 31 swap files and 64GB per swap file.  Note that
+ * This gives us up to 31 swap files and 128GB per swap file.  Note that
  * the offset field is always non-zero.
  */
-#define __SWP_TYPE_SHIFT	3
+#define __SWP_TYPE_SHIFT	2
 #define __SWP_TYPE_BITS		5
 #define __SWP_TYPE_MASK		((1 << __SWP_TYPE_BITS) - 1)
 #define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
@@ -342,20 +342,6 @@ static inline pte_t pte_modify(pte_t pte
  */
 #define MAX_SWAPFILES_CHECK() BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
 
-/*
- * Encode and decode a file entry.  File entries are stored in the Linux
- * page tables as follows:
- *
- *   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
- *   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
- *   <----------------------- offset ------------------------> 1 0 0
- */
-#define pte_file(pte)		(pte_val(pte) & L_PTE_FILE)
-#define pte_to_pgoff(x)		(pte_val(x) >> 3)
-#define pgoff_to_pte(x)		__pte(((x) << 3) | L_PTE_FILE)
-
-#define PTE_FILE_MAX_BITS	29
-
 /* Needs to be defined here and not in linux/mm.h, as it is arch dependent */
 /* FIXME: this is not correct */
 #define kern_addr_valid(addr)	(1)
diff -puN arch/arm/mm/proc-macros.S~arm-drop-l_pte_file-and-pte_file-related-helpers arch/arm/mm/proc-macros.S
--- a/arch/arm/mm/proc-macros.S~arm-drop-l_pte_file-and-pte_file-related-helpers
+++ a/arch/arm/mm/proc-macros.S
@@ -98,7 +98,7 @@
 #endif
 #if !defined (CONFIG_ARM_LPAE) && \
 	(L_PTE_XN+L_PTE_USER+L_PTE_RDONLY+L_PTE_DIRTY+L_PTE_YOUNG+\
-	 L_PTE_FILE+L_PTE_PRESENT) > L_PTE_SHARED
+	 L_PTE_PRESENT) > L_PTE_SHARED
 #error Invalid Linux PTE bit settings
 #endif
 #endif	/* CONFIG_MMU */
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

