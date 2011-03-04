From: akpm@linux-foundation.org
Subject: [alternative-merged] llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg.patch removed from -mm tree
Date: Fri, 04 Mar 2011 15:14:25 -0800
Message-ID: <201103042314.p24NEa7C009429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52724 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932707Ab1CDXRA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2011 18:17:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, andy.grover@oracle.com, benh@kernel.crashing.org, chris@zankel.net, cmetcalf@tilera.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, hans-chr


The patch titled
     llist: add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
has been removed from the -mm tree.  Its filename was
     llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: llist: add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
From: Huang Ying <ying.huang@intel.com>

cmpxchg() is widely used by lockless code, including NMI-safe lockless
code.  But on some architectures, the cmpxchg() implementation is not
NMI-safe, on these architectures the lockless code may need to a
spin_trylock_irqsave() based implementation.

This patch adds a Kconfig option: ARCH_HAVE_NMI_SAFE_CMPXCHG, so that
NMI-safe lockless code can depend on it or provide different
implementation according to it.

On many architectures, cmpxchg is only NMI-safe for several specific
operand sizes.  So, ARCH_HAVE_NMI_SAFE_CMPXCHG define in this patch only
guarantees cmpxchg is NMI-safe for sizeof(unsigned long).

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mikael Starvik <starvik@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chris Zankel <chris@zankel.net>
Cc: Andy Grover <andy.grover@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig         |    3 +++
 arch/alpha/Kconfig   |    1 +
 arch/avr32/Kconfig   |    1 +
 arch/frv/Kconfig     |    1 +
 arch/ia64/Kconfig    |    1 +
 arch/m68k/Kconfig    |    1 +
 arch/parisc/Kconfig  |    1 +
 arch/powerpc/Kconfig |    1 +
 arch/s390/Kconfig    |    1 +
 arch/sh/Kconfig      |    1 +
 arch/sparc/Kconfig   |    1 +
 arch/tile/Kconfig    |    1 +
 arch/x86/Kconfig     |    1 +
 13 files changed, 15 insertions(+)

diff -puN arch/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/Kconfig
--- a/arch/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/Kconfig
@@ -181,4 +181,7 @@ config HAVE_ARCH_JUMP_LABEL
 config HAVE_ARCH_MUTEX_CPU_RELAX
 	bool
 
+config ARCH_HAVE_NMI_SAFE_CMPXCHG
+	bool
+
 source "kernel/gcov/Kconfig"
diff -puN arch/alpha/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/alpha/Kconfig
@@ -7,6 +7,7 @@ config ALPHA
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
diff -puN arch/avr32/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/avr32/Kconfig
@@ -6,6 +6,7 @@ config AVR32
 	select HAVE_CLK
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
diff -puN arch/frv/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/frv/Kconfig
--- a/arch/frv/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/frv/Kconfig
@@ -5,6 +5,7 @@ config FRV
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_GENERIC_HARDIRQS
 
 config ZONE_DMA
diff -puN arch/ia64/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/ia64/Kconfig
@@ -17,6 +17,7 @@ config IA64
 	select HAVE_KRETPROBES
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE if (!ITANIUM)
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_FUNCTION_TRACER
 	select HAVE_DMA_ATTRS
 	select HAVE_KVM
diff -puN arch/m68k/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/m68k/Kconfig
@@ -4,6 +4,7 @@ config M68K
 	select HAVE_AOUT
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 
 config MMU
 	bool
diff -puN arch/parisc/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/parisc/Kconfig
@@ -11,6 +11,7 @@ config PARISC
 	select BUG
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_ATOMIC64 if !64BIT
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
diff -puN arch/powerpc/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/powerpc/Kconfig
@@ -129,6 +129,7 @@ config PPC
 	select GENERIC_ATOMIC64 if PPC32
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
diff -puN arch/s390/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/s390/Kconfig
--- a/arch/s390/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/s390/Kconfig
@@ -81,6 +81,7 @@ config S390
 	select INIT_ALL_POSSIBLE
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
diff -puN arch/sh/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/sh/Kconfig
--- a/arch/sh/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/sh/Kconfig
@@ -11,6 +11,7 @@ config SUPERH
 	select HAVE_DMA_ATTRS
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if (GUSA_RB || CPU_SH4A)
 	select PERF_USE_VMALLOC
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
diff -puN arch/sparc/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/sparc/Kconfig
@@ -38,6 +38,7 @@ config SPARC64
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select HAVE_MEMBLOCK
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
diff -puN arch/tile/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/tile/Kconfig
--- a/arch/tile/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/tile/Kconfig
@@ -6,6 +6,7 @@ config TILE
 	select HAVE_KVM if !TILEGX
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_FIND_NEXT_BIT
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select USE_GENERIC_SMP_HELPERS
 	select CC_OPTIMIZE_FOR_SIZE
 	select HAVE_GENERIC_HARDIRQS
diff -puN arch/x86/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg arch/x86/Kconfig
--- a/arch/x86/Kconfig~llist-add-kconfig-option-arch_have_nmi_safe_cmpxchg
+++ a/arch/x86/Kconfig
@@ -23,6 +23,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_PERF_EVENTS
 	select HAVE_IRQ_WORK
+	select ARCH_HAVE_NMI_SAFE_CMPXCHG if !M386
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
 	select HAVE_MEMBLOCK
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
llist-lib-add-lock-less-null-terminated-single-list.patch
llist-irq_work-use-llist-in-irq_work.patch
llist-net-rds-replace-xlist-in-net-rds-xlisth-with-llist.patch

