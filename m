From: akpm@linux-foundation.org
Subject: [merged] lib-consolidate-debug_per_cpu_maps.patch removed from -mm tree
Date: Wed, 25 May 2011 13:32:13 -0700
Message-ID: <201105252030.p4PKUaHq014979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289Ab1EYUu4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:50:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, benh@kernel.crashing.org, hpa@zytor.com, linux-arch@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     lib: consolidate DEBUG_PER_CPU_MAPS
has been removed from the -mm tree.  Its filename was
     lib-consolidate-debug_per_cpu_maps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: consolidate DEBUG_PER_CPU_MAPS
From: Stephen Boyd <sboyd@codeaurora.org>

DEBUG_PER_CPU_MAPS is used in lib/cpumask.c as well as in
inlcude/linux/cpumask.h and thus it has outgrown its use within x86 and
powerpc alone.  Any arch with SMP support may want to get some more
debugging, so make this option generic.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: <linux-arch@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig.debug |   12 ------------
 arch/x86/Kconfig.debug     |   11 -----------
 lib/Kconfig.debug          |   11 +++++++++++
 3 files changed, 11 insertions(+), 23 deletions(-)

diff -puN arch/powerpc/Kconfig.debug~lib-consolidate-debug_per_cpu_maps arch/powerpc/Kconfig.debug
--- a/arch/powerpc/Kconfig.debug~lib-consolidate-debug_per_cpu_maps
+++ a/arch/powerpc/Kconfig.debug
@@ -44,18 +44,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PER_CPU_MAPS
-	bool "Debug access to per_cpu maps"
-	depends on DEBUG_KERNEL
-	depends on SMP
-	default n
-	---help---
-	  Say Y to verify that the per_cpu map being accessed has
-	  been setup.  Adds a fair amount of code to kernel memory
-	  and decreases performance.
-
-	  Say N if unsure.
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS && TRACEPOINTS
diff -puN arch/x86/Kconfig.debug~lib-consolidate-debug_per_cpu_maps arch/x86/Kconfig.debug
--- a/arch/x86/Kconfig.debug~lib-consolidate-debug_per_cpu_maps
+++ a/arch/x86/Kconfig.debug
@@ -75,17 +75,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PER_CPU_MAPS
-	bool "Debug access to per_cpu maps"
-	depends on DEBUG_KERNEL
-	depends on SMP
-	---help---
-	  Say Y to verify that the per_cpu map being accessed has
-	  been setup.  Adds a fair amount of code to kernel memory
-	  and decreases performance.
-
-	  Say N if unsure.
-
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff -puN lib/Kconfig.debug~lib-consolidate-debug_per_cpu_maps lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-consolidate-debug_per_cpu_maps
+++ a/lib/Kconfig.debug
@@ -983,6 +983,17 @@ config DEBUG_FORCE_WEAK_PER_CPU
 	  To ensure that generic code follows the above rules, this
 	  option forces all percpu variables to be defined as weak.
 
+config DEBUG_PER_CPU_MAPS
+	bool "Debug access to per_cpu maps"
+	depends on DEBUG_KERNEL
+	depends on SMP
+	help
+	  Say Y to verify that the per_cpu map being accessed has
+	  been set up. This adds a fair amount of code to kernel memory
+	  and decreases performance.
+
+	  Say N if unsure.
+
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_FS
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

origin.patch
linux-next.patch

