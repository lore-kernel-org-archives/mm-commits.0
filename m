From: akpm@linux-foundation.org
Subject: [merged] kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:05:25 -0700
Message-ID: <20121009180525.DCAC1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:40838 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISF1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:05:27 -0400
Received: by mail-yh0-f74.google.com with SMTP id 10so573446yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:05:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@redhat.com, paulus@samba.org, schwidefsky@de.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: clean up the "#if defined(arch)" list for exception-trace sysctl entry
has been removed from the -mm tree.  Its filename was
     kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Kconfig: clean up the "#if defined(arch)" list for exception-trace sysctl entry

Introduce SYSCTL_EXCEPTION_TRACE config option and selec it in the
architectures requiring support for the "exception-trace" debug_table
entry in kernel/sysctl.c.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig   |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/s390/Kconfig    |    1 +
 arch/sparc/Kconfig   |    1 +
 arch/tile/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 init/Kconfig         |    5 +++++
 kernel/sysctl.c      |    3 +--
 8 files changed, 12 insertions(+), 2 deletions(-)

diff -puN arch/arm64/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/arch/arm64/Kconfig
@@ -28,6 +28,7 @@ config ARM64
 	select PERF_USE_VMALLOC
 	select RTC_LIB
 	select SPARSE_IRQ
+	select SYSCTL_EXCEPTION_TRACE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
diff -puN arch/powerpc/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/arch/powerpc/Kconfig
@@ -99,6 +99,7 @@ config PPC
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
+	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
diff -puN arch/s390/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/arch/s390/Kconfig
@@ -68,6 +68,7 @@ config S390
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_SYSCALL_TRACEPOINTS
+	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff -puN arch/sparc/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/arch/sparc/Kconfig
@@ -18,6 +18,7 @@ config SPARC
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB if !SMP || SPARC64
 	select HAVE_ARCH_TRACEHOOK
+	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select RTC_CLASS
 	select RTC_DRV_M48T59
diff -puN arch/tile/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry arch/tile/Kconfig
--- a/arch/tile/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/arch/tile/Kconfig
@@ -7,6 +7,7 @@ config TILE
 	select HAVE_DMA_API_DEBUG
 	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
+	select SYSCTL_EXCEPTION_TRACE
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_DEBUG_KMEMLEAK
diff -puN arch/x86/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/arch/x86/Kconfig
@@ -47,6 +47,7 @@ config X86
 	select HAVE_FUNCTION_GRAPH_FP_TEST
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_SYSCALL_TRACEPOINTS
+	select SYSCTL_EXCEPTION_TRACE
 	select HAVE_KVM
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_TRACEHOOK
diff -puN init/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry init/Kconfig
--- a/init/Kconfig~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/init/Kconfig
@@ -1152,6 +1152,11 @@ config SYSCTL_SYSCALL
 
 	  If unsure say N here.
 
+config SYSCTL_EXCEPTION_TRACE
+	bool
+	help
+	  Enable support for /proc/sys/debug/exception-trace.
+
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
diff -puN kernel/sysctl.c~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry kernel/sysctl.c
--- a/kernel/sysctl.c~kconfig-clean-up-the-if-definedarch-list-for-exception-trace-sysctl-entry
+++ a/kernel/sysctl.c
@@ -1549,8 +1549,7 @@ static struct ctl_table fs_table[] = {
 };
 
 static struct ctl_table debug_table[] = {
-#if defined(CONFIG_X86) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) || \
-    defined(CONFIG_S390) || defined(CONFIG_TILE) || defined(CONFIG_ARM64)
+#ifdef CONFIG_SYSCTL_EXCEPTION_TRACE
 	{
 		.procname	= "exception-trace",
 		.data		= &show_unhandled_signals,
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

