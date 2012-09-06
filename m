From: akpm@linux-foundation.org
Subject: + thp-x86-introduce-have_arch_transparent_hugepage.patch added to -mm tree
Date: Thu, 06 Sep 2012 14:00:16 -0700
Message-ID: <20120906210017.B381D5C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:34599 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759932Ab2IFVAV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Sep 2012 17:00:21 -0400
Received: by fass10 with SMTP id s10so130685fas.1
        for <mm-commits@vger.kernel.org>; Thu, 06 Sep 2012 14:00:20 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hpa@zytor.com, hughd@google.com, mingo@kernel.org, schwidefsky@de.ibm.com, tglx@linutronix.de


The patch titled
     Subject: thp, x86: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
has been added to the -mm tree.  Its filename is
     thp-x86-introduce-have_arch_transparent_hugepage.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: thp, x86: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE

Cleanup patch in preparation for transparent hugepage support on s390. 
Adding new architectures to the TRANSPARENT_HUGEPAGE config option can
make the "depends" line rather ugly, like "depends on (X86 || (S390 &&
64BIT)) && MMU".

This patch adds a HAVE_ARCH_TRANSPARENT_HUGEPAGE instead.  x86 already has
MMU "def_bool y", so the MMU check is superfluous there and
HAVE_ARCH_TRANSPARENT_HUGEPAGE can be selected in arch/x86/Kconfig.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig     |    3 +++
 arch/x86/Kconfig |    1 +
 mm/Kconfig       |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage arch/Kconfig
--- a/arch/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage
+++ a/arch/Kconfig
@@ -326,4 +326,7 @@ config HAVE_RCU_USER_QS
 	  are already protected inside rcu_irq_enter/rcu_irq_exit() but
 	  preemption or signal handling on irq exit still need to be protected.
 
+config HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN arch/x86/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage arch/x86/Kconfig
--- a/arch/x86/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage
+++ a/arch/x86/Kconfig
@@ -83,6 +83,7 @@ config X86
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_BPF_JIT if X86_64
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select CLKEVT_I8253
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_IOMAP
diff -puN mm/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage mm/Kconfig
--- a/mm/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage
+++ a/mm/Kconfig
@@ -318,7 +318,7 @@ config NOMMU_INITIAL_TRIM_EXCESS
 
 config TRANSPARENT_HUGEPAGE
 	bool "Transparent Hugepage Support"
-	depends on X86 && MMU
+	depends on HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select COMPACTION
 	help
 	  Transparent Hugepages allows the kernel to use huge pages and
_

Patches currently in -mm which might be from gerald.schaefer@de.ibm.com are

linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

