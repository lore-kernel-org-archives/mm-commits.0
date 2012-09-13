From: akpm@linux-foundation.org
Subject: + mm-introduce-have_arch_transparent_hugepage.patch added to -mm tree
Date: Thu, 13 Sep 2012 12:07:03 -0700
Message-ID: <20120913190704.7F371200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:39098 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab2IMTHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Sep 2012 15:07:07 -0400
Received: by wibhr14 with SMTP id hr14so214791wib.1
        for <mm-commits@vger.kernel.org>; Thu, 13 Sep 2012 12:07:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steve.capper@arm.com, aarcange@redhat.com, arnd@arndb.de, catalin.marinas@arm.com, cmetcalf@tilera.com, gerald.schaefer@de.ibm.com, kirill@shutemov.name, mhocko@suse.cz, will.deacon@arm.com


The patch titled
     Subject: mm: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
has been added to the -mm tree.  Its filename is
     mm-introduce-have_arch_transparent_hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steve Capper <steve.capper@arm.com>
Subject: mm: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE

Different architectures have slightly different pre-requisites for
supporting Transparent Huge Pages.  To simplify the layout of mm/Kconfig,
a new option HAVE_ARCH_TRANSPARENT_HUGEPAGE is introduced and set in each
architecture's Kconfig file (at the moment x86, with ARM being set in a
future patch).

Signed-off-by: Steve Capper <steve.capper@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/x86/Kconfig~mm-introduce-have_arch_transparent_hugepage arch/x86/Kconfig
--- a/arch/x86/Kconfig~mm-introduce-have_arch_transparent_hugepage
+++ a/arch/x86/Kconfig
@@ -83,7 +83,6 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if X86_64
-	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
@@ -1330,6 +1329,10 @@ config ILLEGAL_POINTER_VALUE
        default 0 if X86_32
        default 0xdead000000000000 if X86_64
 
+config HAVE_ARCH_TRANSPARENT_HUGEPAGE
+       def_bool y
+       depends on MMU
+
 source "mm/Kconfig"
 
 config HIGHPTE
_

Patches currently in -mm which might be from steve.capper@arm.com are

mm-thp-fix-the-pmd_clear-arguments-in-pmdp_get_and_clear.patch
mm-thp-fix-the-update_mmu_cache-last-argument-passing-in-mm-huge_memoryc.patch
mm-introduce-have_arch_transparent_hugepage.patch

