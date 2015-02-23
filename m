From: akpm@linux-foundation.org
Subject: + mm-define-default-pgtable_levels-to-two.patch added to -mm tree
Date: Mon, 23 Feb 2015 12:45:05 -0800
Message-ID: <54eb9151.036iaDmioK+TtjIn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbbBWUpG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Feb 2015 15:45:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, benh@kernel.crashing.org, catalin.marinas@arm.com, cmetcalf@ezchip.com, davem@davemloft.net, deller@gmx.de, dhowells@redhat.com, fenghua.yu@intel.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hpa@zytor.com, ink@jurassic.park.msu.ru, jdike@addtoit.com, jejb@parisc-linux.org, linux@arm.linux.org.uk, linux@roeck-us.net, mattst88@gmail.com, mingo@redhat.com, mpe@ellerman.id.au, paulus@samba.org, ralf@linux-mips.org, richard@nod.at, rth@twiddle.net, schwidefsky@de.ibm.com, tglx@linutronix.de, tony.luck@intel.com, will.deacon@arm.com, yasutake.koichi@jp.panasonic.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: define default PGTABLE_LEVELS to two
has been added to the -mm tree.  Its filename is
     mm-define-default-pgtable_levels-to-two.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-define-default-pgtable_levels-to-two.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-define-default-pgtable_levels-to-two.patch

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
Subject: mm: define default PGTABLE_LEVELS to two

By this time all architectures which support more than two page table
levels should be covered. This patch add default definiton of
PGTABLE_LEVELS equal 2.

We also add assert to detect inconsistence between CONFIG_PGTABLE_LEVELS
and __PAGETABLE_PMD_FOLDED/__PAGETABLE_PUD_FOLDED.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                  |    4 ++++
 include/asm-generic/pgtable.h |    5 +++++
 2 files changed, 9 insertions(+)

diff -puN arch/Kconfig~mm-define-default-pgtable_levels-to-two arch/Kconfig
--- a/arch/Kconfig~mm-define-default-pgtable_levels-to-two
+++ a/arch/Kconfig
@@ -484,6 +484,10 @@ config HAVE_IRQ_EXIT_ON_IRQ_STACK
 	  This spares a stack switch and improves cache usage on softirq
 	  processing.
 
+config PGTABLE_LEVELS
+	int
+	default 2
+
 #
 # ABI hall of shame
 #
diff -puN include/asm-generic/pgtable.h~mm-define-default-pgtable_levels-to-two include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-define-default-pgtable_levels-to-two
+++ a/include/asm-generic/pgtable.h
@@ -7,6 +7,11 @@
 #include <linux/mm_types.h>
 #include <linux/bug.h>
 
+#if 4 - defined(__PAGETABLE_PUD_FOLDED) - defined(__PAGETABLE_PMD_FOLDED) != \
+	CONFIG_PGTABLE_LEVELS
+#error CONFIG_PGTABLE_LEVELS is not consistent with __PAGETABLE_{PUD,PMD}_FOLDED
+#endif
+
 /*
  * On almost all architectures and configurations, 0 can be used as the
  * upper ceiling to free_pgtables(): on many architectures it has the same
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

