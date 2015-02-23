From: akpm@linux-foundation.org
Subject: + sparc-expose-number-of-page-table-levels.patch added to -mm
 tree
Date: Mon, 23 Feb 2015 12:44:56 -0800
Message-ID: <54eb9148.7+cTxk7rd5lTfwMv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbbBWUo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 15:44:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, davem@davemloft.net, linux@roeck-us.net, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc: expose number of page table levels
has been added to the -mm tree.  Its filename is
     sparc-expose-number-of-page-table-levels.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc-expose-number-of-page-table-levels.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc-expose-number-of-page-table-levels.patch

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
Subject: sparc: expose number of page table levels

We would want to use number of page table level to define mm_struct.
Let's expose it as CONFIG_PGTABLE_LEVELS.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/sparc/Kconfig~sparc-expose-number-of-page-table-levels arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~sparc-expose-number-of-page-table-levels
+++ a/arch/sparc/Kconfig
@@ -143,6 +143,10 @@ config GENERIC_ISA_DMA
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y if SPARC64
 
+config PGTABLE_LEVELS
+	default 4 if 64BIT
+	default 3
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
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

