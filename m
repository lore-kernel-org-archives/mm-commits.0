From: akpm@linux-foundation.org
Subject: [alternative-merged] mn10300-mark-pud-and-pmd-folded.patch
 removed from -mm tree
Date: Thu, 26 Feb 2015 12:32:00 -0800
Message-ID: <54ef82c0.F12A+TI57R7GOiup%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58497 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbbBZUcB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Feb 2015 15:32:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, dhowells@redhat.com, linux@roeck-us.net, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mn10300: mark PUD and PMD folded
has been removed from the -mm tree.  Its filename was
     mn10300-mark-pud-and-pmd-folded.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mn10300: mark PUD and PMD folded

Core mm expects __PAGETABLE_{PUD,PMD}_FOLDED to be defined if these page
table levels folded.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mn10300/include/asm/pgtable.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/mn10300/include/asm/pgtable.h~mn10300-mark-pud-and-pmd-folded arch/mn10300/include/asm/pgtable.h
--- a/arch/mn10300/include/asm/pgtable.h~mn10300-mark-pud-and-pmd-folded
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
ia64-expose-number-of-page-table-levels-on-kconfig-level.patch
m68k-mark-pmd-folded-and-expose-number-of-page-table-levels.patch
mips-expose-number-of-page-table-levels-on-kconfig-level.patch
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

