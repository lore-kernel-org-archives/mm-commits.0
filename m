From: akpm@linux-foundation.org
Subject: [merged] kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:05:14 -0700
Message-ID: <20121009180515.7DDB75C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56549 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:05:20 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so365010wey.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:05:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@redhat.com, monstr@monstr.eu, paulus@samba.org, ralf@linux-mips.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: clean up the long arch list for the DEBUG_KMEMLEAK config option
has been removed from the -mm tree.  Its filename was
     kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Kconfig: clean up the long arch list for the DEBUG_KMEMLEAK config option

Introduce HAVE_DEBUG_KMEMLEAK config option and select it in corresponding
architecture Kconfig files.  DEBUG_KMEMLEAK now only depends on
HAVE_DEBUG_KMEMLEAK.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig        |    1 +
 arch/arm64/Kconfig      |    1 +
 arch/microblaze/Kconfig |    1 +
 arch/mips/Kconfig       |    1 +
 arch/powerpc/Kconfig    |    1 +
 arch/s390/Kconfig       |    1 +
 arch/sh/Kconfig         |    1 +
 arch/sparc/Kconfig      |    1 +
 arch/tile/Kconfig       |    1 +
 arch/x86/Kconfig        |    1 +
 lib/Kconfig.debug       |    8 ++++----
 11 files changed, 14 insertions(+), 4 deletions(-)

diff -puN arch/arm/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/arm/Kconfig
--- a/arch/arm/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/arm/Kconfig
@@ -25,6 +25,7 @@ config ARM
 	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select HAVE_GENERIC_DMA_COHERENT
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
diff -puN arch/arm64/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/arm64/Kconfig
@@ -10,6 +10,7 @@ config ARM64
 	select GENERIC_TIME_VSYSCALL
 	select HARDIRQS_SW_RESEND
 	select HAVE_ARCH_TRACEHOOK
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DMA_API_DEBUG
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_DMA_COHERENT
diff -puN arch/microblaze/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/microblaze/Kconfig
@@ -16,6 +16,7 @@ config MICROBLAZE
 	select OF
 	select OF_EARLY_FLATTREE
 	select ARCH_WANT_IPC_PARSE_VERSION
+	select HAVE_DEBUG_KMEMLEAK
 	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
diff -puN arch/mips/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/mips/Kconfig
--- a/arch/mips/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/mips/Kconfig
@@ -17,6 +17,7 @@ config MIPS
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_DEBUG_KMEMLEAK
 	select ARCH_BINFMT_ELF_RANDOMIZE_PIE
 	select RTC_LIB if !MACH_LOONGSON
 	select GENERIC_ATOMIC64 if !64BIT
diff -puN arch/powerpc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/powerpc/Kconfig
@@ -113,6 +113,7 @@ config PPC
 	select HAVE_DMA_API_DEBUG
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_SYSCALL_WRAPPERS if PPC64
 	select GENERIC_ATOMIC64 if PPC32
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
diff -puN arch/s390/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/s390/Kconfig
@@ -80,6 +80,7 @@ config S390
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff -puN arch/sh/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/sh/Kconfig
@@ -16,6 +16,7 @@ config SUPERH
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff -puN arch/sparc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/sparc/Kconfig
@@ -60,6 +60,7 @@ config SPARC64
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_SYSCALL_TRACEPOINTS
+	select HAVE_DEBUG_KMEMLEAK
 	select RTC_DRV_CMOS
 	select RTC_DRV_BQ4802
 	select RTC_DRV_SUN4V
diff -puN arch/tile/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/tile/Kconfig
--- a/arch/tile/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/tile/Kconfig
@@ -9,6 +9,7 @@ config TILE
 	select GENERIC_FIND_FIRST_BIT
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
+	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
diff -puN arch/x86/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/arch/x86/Kconfig
@@ -66,6 +66,7 @@ config X86
 	select HAVE_PERF_EVENTS_NMI
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
+	select HAVE_DEBUG_KMEMLEAK
 	select ANON_INODES
 	select HAVE_ALIGNED_STRUCT_PAGE if SLUB && !M386
 	select HAVE_CMPXCHG_LOCAL if !M386
diff -puN lib/Kconfig.debug~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~kconfig-clean-up-the-long-arch-list-for-the-debug_kmemleak-config-option
+++ a/lib/Kconfig.debug
@@ -450,12 +450,12 @@ config SLUB_STATS
 	  out which slabs are relevant to a particular load.
 	  Try running: slabinfo -DA
 
+config HAVE_DEBUG_KMEMLEAK
+	bool
+
 config DEBUG_KMEMLEAK
 	bool "Kernel memory leak detector"
-	depends on DEBUG_KERNEL && EXPERIMENTAL && \
-		(X86 || ARM || PPC || MIPS || S390 || SPARC64 || SUPERH || \
-		 MICROBLAZE || TILE || ARM64)
