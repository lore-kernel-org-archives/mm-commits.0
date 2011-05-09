From: akpm@linux-foundation.org
Subject: + lib-consolidate-debug_stack_usage-option.patch added to -mm tree
Date: Mon, 09 May 2011 15:22:31 -0700
Message-ID: <201105092222.p49MMVX8022282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752455Ab1EIWYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 May 2011 18:24:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net, hpa@zytor.com, lennox.wu@gmail.com, liqin.chen@sunplusct.com, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.org, richard@nod.at, rmk@arm.linux.org.uk, takata@linux-m32r.org, tglx@linutronix.de, vapier@gentoo.org


The patch titled
     lib: consolidate DEBUG_STACK_USAGE option
has been added to the -mm tree.  Its filename is
     lib-consolidate-debug_stack_usage-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: consolidate DEBUG_STACK_USAGE option
From: Stephen Boyd <sboyd@codeaurora.org>

Most arches define CONFIG_DEBUG_STACK_USAGE exactly the same way.  Move it
to lib/Kconfig.debug so each arch doesn't have to define it.  This
obviously makes the option generic, but that's fine because the config is
already used in generic code.

It's not obvious to me that sysrq-P actually does anything caution by
keeping the most inclusive wording.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Richard Weinberger <richard@nod.at>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig.debug       |    7 -------
 arch/blackfin/Kconfig.debug  |    9 ---------
 arch/m32r/Kconfig.debug      |    9 ---------
 arch/mips/Kconfig.debug      |    9 ---------
 arch/powerpc/Kconfig.debug   |    9 ---------
 arch/score/Kconfig.debug     |    9 ---------
 arch/sh/Kconfig.debug        |    9 ---------
 arch/sparc/Kconfig.debug     |    9 ---------
 arch/tile/Kconfig.debug      |    9 ---------
 arch/um/Kconfig.debug        |    9 ---------
 arch/unicore32/Kconfig.debug |    7 -------
 arch/x86/Kconfig.debug       |    9 ---------
 lib/Kconfig.debug            |    9 +++++++++
 13 files changed, 9 insertions(+), 104 deletions(-)

diff -puN arch/arm/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/arm/Kconfig.debug
--- a/arch/arm/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/arm/Kconfig.debug
@@ -63,13 +63,6 @@ config DEBUG_USER
 	      8 - SIGSEGV faults
 	     16 - SIGBUS faults
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T output.
-
 # These options are only for real kernel hackers who want to get their hands dirty.
 config DEBUG_LL
 	bool "Kernel low-level debugging functions"
diff -puN arch/blackfin/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/blackfin/Kconfig.debug
--- a/arch/blackfin/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/blackfin/Kconfig.debug
@@ -9,15 +9,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_VERBOSE
 	bool "Verbose fault messages"
 	default y
diff -puN arch/m32r/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/m32r/Kconfig.debug
--- a/arch/m32r/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/m32r/Kconfig.debug
@@ -9,15 +9,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
 	depends on DEBUG_KERNEL && BROKEN
diff -puN arch/mips/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/mips/Kconfig.debug
--- a/arch/mips/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/mips/Kconfig.debug
@@ -76,15 +76,6 @@ config DEBUG_STACKOVERFLOW
 	  provides another way to check stack overflow happened on kernel mode
 	  stack usually caused by nested interruption.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config SMTC_IDLE_HOOK_DEBUG
 	bool "Enable additional debug checks before going into CPU idle loop"
 	depends on DEBUG_KERNEL && MIPS_MT_SMTC
diff -puN arch/powerpc/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/powerpc/Kconfig.debug
--- a/arch/powerpc/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/powerpc/Kconfig.debug
@@ -35,15 +35,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS && TRACEPOINTS
diff -puN arch/score/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/score/Kconfig.debug
--- a/arch/score/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/score/Kconfig.debug
@@ -16,15 +16,6 @@ config CMDLINE
 	  other cases you can specify kernel args so that you don't have
 	  to set them up in board prom initialization routines.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config RUNTIME_DEBUG
 	bool "Enable run-time debugging"
 	depends on DEBUG_KERNEL
diff -puN arch/sh/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/sh/Kconfig.debug
--- a/arch/sh/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/sh/Kconfig.debug
@@ -28,15 +28,6 @@ config STACK_DEBUG
 	  every function call and will therefore incur a major
 	  performance hit. Most users should say N.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config 4KSTACKS
 	bool "Use 4Kb for kernel stacks instead of 8Kb"
 	depends on DEBUG_KERNEL && (MMU || BROKEN) && !PAGE_SIZE_64KB
diff -puN arch/sparc/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/sparc/Kconfig.debug
--- a/arch/sparc/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/sparc/Kconfig.debug
@@ -6,15 +6,6 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_DCFLUSH
 	bool "D-cache flush debugging"
 	depends on SPARC64 && DEBUG_KERNEL
diff -puN arch/tile/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/tile/Kconfig.debug
--- a/arch/tile/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/tile/Kconfig.debug
@@ -21,15 +21,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config DEBUG_EXTRA_FLAGS
 	string "Additional compiler arguments when building with '-g'"
 	depends on DEBUG_INFO
diff -puN arch/um/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/um/Kconfig.debug
@@ -28,13 +28,4 @@ config GCOV
 	  If you're involved in UML kernel development and want to use gcov,
 	  say Y.  If you're unsure, say N.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	default N
-	help
-	  Track the maximum kernel stack usage - this will look at each
-	  kernel stack at process exit and log it if it's the deepest
-	  stack seen so far.
-
-	  This option will slow down process creation and destruction somewhat.
 endmenu
diff -puN arch/unicore32/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/unicore32/Kconfig.debug
--- a/arch/unicore32/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/unicore32/Kconfig.debug
@@ -27,13 +27,6 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
-config DEBUG_STACK_USAGE
-	bool "Enable stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	help
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T output.
-
 # These options are only for real kernel hackers who want to get their hands dirty.
 config DEBUG_LL
 	bool "Kernel low-level debugging functions"
diff -puN arch/x86/Kconfig.debug~lib-consolidate-debug_stack_usage-option arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/arch/x86/Kconfig.debug
@@ -66,15 +66,6 @@ config DEBUG_STACKOVERFLOW
 	  This option will cause messages to be printed if free stack space
 	  drops below a certain limit.
 
-config DEBUG_STACK_USAGE
-	bool "Stack utilization instrumentation"
-	depends on DEBUG_KERNEL
-	---help---
-	  Enables the display of the minimum amount of free stack which each
-	  task has ever had available in the sysrq-T and sysrq-P debug output.
-
-	  This option will slow down process creation somewhat.
-
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff -puN lib/Kconfig.debug~lib-consolidate-debug_stack_usage-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-consolidate-debug_stack_usage-option
+++ a/lib/Kconfig.debug
@@ -670,6 +670,15 @@ config STACKTRACE
 	bool
 	depends on STACKTRACE_SUPPORT
 
+config DEBUG_STACK_USAGE
+	bool "Stack utilization instrumentation"
+	depends on DEBUG_KERNEL
+	help
+	  Enables the display of the minimum amount of free stack which each
+	  task has ever had available in the sysrq-T and sysrq-P debug output.
+
+	  This option will slow down process creation somewhat.
+
 config DEBUG_KOBJECT
 	bool "kobject debugging"
 	depends on DEBUG_KERNEL
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

linux-next.patch
msm-timer-migrate-to-timer-based-__delay.patch
lib-consolidate-debug_per_cpu_maps.patch
lib-consolidate-debug_stack_usage-option.patch

