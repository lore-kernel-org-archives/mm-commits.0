From: akpm@linux-foundation.org
Subject: + mm-add-missing-__pagetable_pudpmd_folded-defines.patch added to -mm tree
Date: Thu, 26 Feb 2015 12:24:59 -0800
Message-ID: <54ef811b.yCHR74sLtfcD+b2h%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58376 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbbBZUZA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 15:25:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aaro.koskinen@iki.fi, deller@gmx.de, dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, jejb@parisc-linux.org, schwidefsky@de.ibm.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add missing __PAGETABLE_{PUD,PMD}_FOLDED defines
has been added to the -mm tree.  Its filename is
     mm-add-missing-__pagetable_pudpmd_folded-defines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-missing-__pagetable_pudpmd_folded-defines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-missing-__pagetable_pudpmd_folded-defines.patch

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
Subject: mm: add missing __PAGETABLE_{PUD,PMD}_FOLDED defines

Core mm expects __PAGETABLE_{PUD,PMD}_FOLDED to be defined if these page
table levels folded.  Usually, these defines are provided by
<asm-generic/pgtable-nopmd.h> and <asm-generic/pgtable-nopud.h>.

But some architectures fold page table levels in a custom way.  They need
to define these macros themself.  This patch adds missing defines.

The patch fixes mm->nr_pmds underflow and eliminates dead __pmd_alloc()
and __pud_alloc() on architectures without these page table levels.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/include/asm/pgtable.h         |    2 ++
 arch/m32r/include/asm/pgtable-2level.h |    1 +
 arch/m68k/include/asm/pgtable_mm.h     |    2 ++
 arch/mn10300/include/asm/pgtable.h     |    2 ++
 arch/parisc/include/asm/pgtable.h      |    1 +
 arch/s390/include/asm/pgtable.h        |    2 ++
 6 files changed, 10 insertions(+)

diff -puN arch/frv/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines arch/frv/include/asm/pgtable.h
--- a/arch/frv/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines
+++ a/arch/frv/include/asm/pgtable.h
@@ -123,12 +123,14 @@ extern unsigned long empty_zero_page;
 #define PGDIR_MASK		(~(PGDIR_SIZE - 1))
 #define PTRS_PER_PGD		64
 
+#define __PAGETABLE_PUD_FOLDED
 #define PUD_SHIFT		26
 #define PTRS_PER_PUD		1
 #define PUD_SIZE		(1UL << PUD_SHIFT)
 #define PUD_MASK		(~(PUD_SIZE - 1))
 #define PUE_SIZE		256
 
+#define __PAGETABLE_PMD_FOLDED
 #define PMD_SHIFT		26
 #define PMD_SIZE		(1UL << PMD_SHIFT)
 #define PMD_MASK		(~(PMD_SIZE - 1))
diff -puN arch/m32r/include/asm/pgtable-2level.h~mm-add-missing-__pagetable_pudpmd_folded-defines arch/m32r/include/asm/pgtable-2level.h
--- a/arch/m32r/include/asm/pgtable-2level.h~mm-add-missing-__pagetable_pudpmd_folded-defines
+++ a/arch/m32r/include/asm/pgtable-2level.h
@@ -13,6 +13,7 @@
  * the M32R is two-level, so we don't really have any
  * PMD directory physically.
  */
+#define __PAGETABLE_PMD_FOLDED
 #define PMD_SHIFT	22
 #define PTRS_PER_PMD	1
 
diff -puN arch/m68k/include/asm/pgtable_mm.h~mm-add-missing-__pagetable_pudpmd_folded-defines arch/m68k/include/asm/pgtable_mm.h
--- a/arch/m68k/include/asm/pgtable_mm.h~mm-add-missing-__pagetable_pudpmd_folded-defines
+++ a/arch/m68k/include/asm/pgtable_mm.h
@@ -54,10 +54,12 @@
  */
 #ifdef CONFIG_SUN3
 #define PTRS_PER_PTE   16
+#define __PAGETABLE_PMD_FOLDED
 #define PTRS_PER_PMD   1
 #define PTRS_PER_PGD   2048
 #elif defined(CONFIG_COLDFIRE)
 #define PTRS_PER_PTE	512
+#define __PAGETABLE_PMD_FOLDED
 #define PTRS_PER_PMD	1
 #define PTRS_PER_PGD	1024
 #else
diff -puN arch/mn10300/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines arch/mn10300/include/asm/pgtable.h
--- a/arch/mn10300/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines
+++ a/arch/mn10300/include/asm/pgtable.h
@@ -56,7 +56,9 @@ extern void paging_init(void);
 #define PGDIR_SHIFT	22
 #define PTRS_PER_PGD	1024
 #define PTRS_PER_PUD	1	/* we don't really have any PUD physically */
+#define __PAGETABLE_PUD_FOLDED
 #define PTRS_PER_PMD	1	/* we don't really have any PMD physically */
+#define __PAGETABLE_PMD_FOLDED
 #define PTRS_PER_PTE	1024
 
 #define PGD_SIZE	PAGE_SIZE
diff -puN arch/parisc/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines arch/parisc/include/asm/pgtable.h
--- a/arch/parisc/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines
+++ a/arch/parisc/include/asm/pgtable.h
@@ -96,6 +96,7 @@ extern void purge_tlb_entries(struct mm_
 #if PT_NLEVELS == 3
 #define BITS_PER_PMD	(PAGE_SHIFT + PMD_ORDER - BITS_PER_PMD_ENTRY)
 #else
+#define __PAGETABLE_PMD_FOLDED
 #define BITS_PER_PMD	0
 #endif
 #define PTRS_PER_PMD    (1UL << BITS_PER_PMD)
diff -puN arch/s390/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~mm-add-missing-__pagetable_pudpmd_folded-defines
+++ a/arch/s390/include/asm/pgtable.h
@@ -91,7 +91,9 @@ extern unsigned long zero_page_mask;
  */
 #define PTRS_PER_PTE	256
 #ifndef CONFIG_64BIT
+#define __PAGETABLE_PUD_FOLDED
 #define PTRS_PER_PMD	1
+#define __PAGETABLE_PMD_FOLDED
 #define PTRS_PER_PUD	1
 #else /* CONFIG_64BIT */
 #define PTRS_PER_PMD	2048
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-add-missing-__pagetable_pudpmd_folded-defines.patch
mm-rename-foll_mlock-to-foll_populate.patch
mm-rename-__mlock_vma_pages_range-to-populate_vma_page_range.patch
mm-move-gup-posix-mlock-error-conversion-out-of-__mm_populate.patch
mm-move-mm_populate-related-code-to-mm-gupc.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch
mm-incorporate-zero-pages-into-transparent-huge-pages-fix.patch
alpha-expose-number-of-page-table-levels-on-kconfig-level.patch
arm64-expose-number-of-page-table-levels-on-kconfig-level.patch
arm-expose-number-of-page-table-levels-on-kconfig-level.patch
frv-mark-pud-and-pmd-folded.patch
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m32r-mark-pmd-folded.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
mn10300-mark-pud-and-pmd-folded.patch
parisc-expose-number-of-page-table-levels-on-kconfig-level.patch
powerpc-expose-number-of-page-table-levels-on-kconfig-level.patch
s390-expose-number-of-page-table-levels.patch
sh-expose-number-of-page-table-levels.patch
sparc-expose-number-of-page-table-levels.patch
tile-expose-number-of-page-table-levels.patch
um-expose-number-of-page-table-levels.patch
x86-expose-number-of-page-table-levels-on-kconfig-level.patch
mm-define-default-pgtable_levels-to-two.patch
mm-do-not-add-nr_pmds-into-mm_struct-if-pmd-is-folded.patch
mm-refactor-do_wp_page-extract-the-reuse-case.patch
mm-refactor-do_wp_page-rewrite-the-unlock-flow.patch
mm-refactor-do_wp_page-extract-the-page-copy-flow.patch
mm-refactor-do_wp_page-handling-of-shared-vma-into-a-function.patch

