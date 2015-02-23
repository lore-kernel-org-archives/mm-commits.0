From: akpm@linux-foundation.org
Subject: +
 m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch added to
 -mm tree
Date: Mon, 23 Feb 2015 12:44:42 -0800
Message-ID: <54eb913a.56hRI+vxPGrNDfVF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44328 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbbBWUon (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 15:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, geert@linux-m68k.org, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: m68k: mark PMD folded and expose number of page table levels
has been added to the -mm tree.  Its filename is
     m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch

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
Subject: m68k: mark PMD folded and expose number of page table levels

We would want to use number of page table level to define mm_struct.
Let's expose it as CONFIG_PGTABLE_LEVELS.

Core mm expects __PAGETABLE_{PUD,PMD}_FOLDED to be defined if these page
table levels folded.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/Kconfig                  |    4 ++++
 arch/m68k/include/asm/pgtable_mm.h |    2 ++
 2 files changed, 6 insertions(+)

diff -puN arch/m68k/Kconfig~m68k-mark-pmd-folded-and-expose-number-of-page-table-levels arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~m68k-mark-pmd-folded-and-expose-number-of-page-table-levels
+++ a/arch/m68k/Kconfig
@@ -67,6 +67,10 @@ config HZ
 	default 1000 if CLEOPATRA
 	default 100
 
+config PGTABLE_LEVELS
+	default 2 if SUN3 || COLDFIRE
+	default 3
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/m68k/include/asm/pgtable_mm.h~m68k-mark-pmd-folded-and-expose-number-of-page-table-levels arch/m68k/include/asm/pgtable_mm.h
--- a/arch/m68k/include/asm/pgtable_mm.h~m68k-mark-pmd-folded-and-expose-number-of-page-table-levels
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
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

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

