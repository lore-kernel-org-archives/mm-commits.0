From: akpm@linux-foundation.org
Subject: [merged] thp-x86-introduce-have_arch_transparent_hugepage.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:08:17 -0700
Message-ID: <20121009180821.582D35C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:57539 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab2JISIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:08:24 -0400
Received: by mail-bk0-f74.google.com with SMTP id q16so362219bkw.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:08:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerald.schaefer@de.ibm.com, aarcange@redhat.com, ak@linux.intel.com, dhillf@gmail.com, heiko.carstens@de.ibm.com, hpa@zytor.com, hughd@google.com, mingo@kernel.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, x86: introduce HAVE_ARCH_TRANSPARENT_HUGEPAGE
has been removed from the -mm tree.  Its filename was
     thp-x86-introduce-have_arch_transparent_hugepage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -313,4 +313,7 @@ config HAVE_IRQ_TIME_ACCOUNTING
 	  Archs need to ensure they use a high enough resolution clock to
 	  support irq time accounting and then call enable_sched_clock_irqtime().
 
+config HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN arch/x86/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage arch/x86/Kconfig
--- a/arch/x86/Kconfig~thp-x86-introduce-have_arch_transparent_hugepage
+++ a/arch/x86/Kconfig
@@ -88,6 +88,7 @@ config X86
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

origin.patch
linux-next.patch

