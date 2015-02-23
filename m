From: akpm@linux-foundation.org
Subject: + s390-expose-number-of-page-table-levels.patch added to -mm tree
Date: Mon, 23 Feb 2015 12:44:52 -0800
Message-ID: <54eb9144.D+/UksVJhngTW24A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbbBWUox (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 15:44:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, heiko.carstens@de.ibm.com, linux@roeck-us.net, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: s390: expose number of page table levels
has been added to the -mm tree.  Its filename is
     s390-expose-number-of-page-table-levels.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-expose-number-of-page-table-levels.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-expose-number-of-page-table-levels.patch

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
Subject: s390: expose number of page table levels

We would want to use number of page table level to define mm_struct.
Let's expose it as CONFIG_PGTABLE_LEVELS.

Core mm expects __PAGETABLE_{PUD,PMD}_FOLDED to be defined if these page
table levels folded.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig               |    5 +++++
 arch/s390/include/asm/pgtable.h |    2 ++
 2 files changed, 7 insertions(+)

diff -puN arch/s390/Kconfig~s390-expose-number-of-page-table-levels arch/s390/Kconfig
--- a/arch/s390/Kconfig~s390-expose-number-of-page-table-levels
+++ a/arch/s390/Kconfig
@@ -155,6 +155,11 @@ config S390
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
 
+config PGTABLE_LEVELS
+	int
+	default 4 if 64BIT
+	default 2
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff -puN arch/s390/include/asm/pgtable.h~s390-expose-number-of-page-table-levels arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~s390-expose-number-of-page-table-levels
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

