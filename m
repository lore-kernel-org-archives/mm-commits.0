From: akpm@linux-foundation.org
Subject: [merged] arch-kconfig-centralise-config_arch_no_virt_to_bus.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:17:48 -0800
Message-ID: <20130228201748.D16E631C1F0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64756 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760166Ab3B1URu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:17:50 -0500
Received: by mail-gg0-f202.google.com with SMTP id l4so245297ggi.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:17:49 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, James.Bottomley@HansenPartnership.com, Vineet.Gupta1@synopsys.com, benh@kernel.crashing.org, bhelgaas@google.com, davem@davemloft.net, hartleys@visionengravers.com, james.hogan@imgtec.com, lethal@linux-sh.org, linux-arch@vger.kernel.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS
has been removed from the -mm tree.  Its filename was
     arch-kconfig-centralise-config_arch_no_virt_to_bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: arch Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS

Change it to CONFIG_HAVE_VIRT_TO_BUS and set it in all architecures
that already provide virt_to_bus().

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |    7 +++++++
 arch/alpha/Kconfig      |    1 +
 arch/arm/Kconfig        |    1 +
 arch/avr32/Kconfig      |    1 +
 arch/blackfin/Kconfig   |    1 +
 arch/cris/Kconfig       |    1 +
 arch/frv/Kconfig        |    1 +
 arch/h8300/Kconfig      |    1 +
 arch/ia64/Kconfig       |    1 +
 arch/m32r/Kconfig       |    1 +
 arch/m68k/Kconfig       |    1 +
 arch/microblaze/Kconfig |    1 +
 arch/mips/Kconfig       |    1 +
 arch/mn10300/Kconfig    |    1 +
 arch/openrisc/Kconfig   |    1 +
 arch/parisc/Kconfig     |    1 +
 arch/powerpc/Kconfig    |    4 +---
 arch/s390/Kconfig       |    1 +
 arch/score/Kconfig      |    1 +
 arch/sh/Kconfig         |    3 ---
 arch/sparc/Kconfig      |    3 ---
 arch/tile/Kconfig       |    1 +
 arch/unicore32/Kconfig  |    1 +
 arch/x86/Kconfig        |    1 +
 arch/xtensa/Kconfig     |    1 +
 mm/Kconfig              |    2 +-
 26 files changed, 30 insertions(+), 10 deletions(-)

diff -puN arch/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/Kconfig
--- a/arch/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/Kconfig
@@ -303,6 +303,13 @@ config ARCH_WANT_OLD_COMPAT_IPC
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
 
+config HAVE_VIRT_TO_BUS
+	bool
+	help
+	  An architecture should select this if it implements the
+	  deprecated interface virt_to_bus().  All new architectures
+	  should probably not select this.
+
 config HAVE_ARCH_SECCOMP_FILTER
 	bool
 	help
diff -puN arch/alpha/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/alpha/Kconfig
@@ -9,6 +9,7 @@ config ALPHA
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
diff -puN arch/arm/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/arm/Kconfig
--- a/arch/arm/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/arm/Kconfig
@@ -49,6 +49,7 @@ config ARM
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select KTIME_SCALAR
 	select PERF_USE_VMALLOC
 	select RTC_LIB
diff -puN arch/avr32/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/avr32/Kconfig
@@ -7,6 +7,7 @@ config AVR32
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
diff -puN arch/blackfin/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/blackfin/Kconfig
@@ -33,6 +33,7 @@ config BLACKFIN
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
diff -puN arch/cris/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/cris/Kconfig
--- a/arch/cris/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/cris/Kconfig
@@ -43,6 +43,7 @@ config CRIS
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
diff -puN arch/frv/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/frv/Kconfig
--- a/arch/frv/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/frv/Kconfig
@@ -6,6 +6,7 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/h8300/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/h8300/Kconfig
@@ -5,6 +5,7 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff -puN arch/ia64/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/ia64/Kconfig
@@ -26,6 +26,7 @@ config IA64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select HAVE_VIRT_TO_BUS
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
diff -puN arch/m32r/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/m32r/Kconfig
@@ -10,6 +10,7 @@ config M32R
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
diff -puN arch/m68k/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/m68k/Kconfig
@@ -8,6 +8,7 @@ config M68K
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
+	select HAVE_VIRT_TO_BUS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select GENERIC_STRNCPY_FROM_USER if MMU
diff -puN arch/microblaze/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/microblaze/Kconfig
@@ -19,6 +19,7 @@ config MICROBLAZE
 	select HAVE_DEBUG_KMEMLEAK
 	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
diff -puN arch/mips/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/mips/Kconfig
--- a/arch/mips/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/mips/Kconfig
@@ -38,6 +38,7 @@ config MIPS
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select CLONE_BACKWARDS
diff -puN arch/mn10300/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/mn10300/Kconfig
@@ -8,6 +8,7 @@ config MN10300
 	select HAVE_ARCH_KGDB
 	select GENERIC_ATOMIC64
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
diff -puN arch/openrisc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/openrisc/Kconfig
--- a/arch/openrisc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/openrisc/Kconfig
@@ -12,6 +12,7 @@ config OPENRISC
 	select ARCH_WANT_OPTIONAL_GPIOLIB
         select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff -puN arch/parisc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/parisc/Kconfig
@@ -19,6 +19,7 @@ config PARISC
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_STRNCPY_FROM_USER
 	select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
 	select TTY # Needed for pdc_cons.c
diff -puN arch/powerpc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/powerpc/Kconfig
@@ -87,9 +87,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool PPC64
-
 config PPC
 	bool
 	default y
@@ -101,6 +98,7 @@ config PPC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select HAVE_VIRT_TO_BUS if !PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff -puN arch/s390/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/s390/Kconfig
--- a/arch/s390/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/s390/Kconfig
@@ -134,6 +134,7 @@ config S390
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_UID16 if 32BIT
 	select HAVE_VIRT_CPU_ACCOUNTING
+	select HAVE_VIRT_TO_BUS
 	select INIT_ALL_POSSIBLE
 	select KTIME_SCALAR if 32BIT
 	select MODULES_USE_ELF_RELA
diff -puN arch/score/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/score/Kconfig
--- a/arch/score/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/score/Kconfig
@@ -12,6 +12,7 @@ config SCORE
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
        select HAVE_MOD_ARCH_SPECIFIC
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
 
diff -puN arch/sh/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/sh/Kconfig
--- a/arch/sh/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/sh/Kconfig
@@ -148,9 +148,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	def_bool n
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config ARCH_HAS_DEFAULT_IDLE
 	def_bool y
 
diff -puN arch/sparc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/sparc/Kconfig
@@ -146,9 +146,6 @@ config GENERIC_GPIO
 	help
 	  Generic GPIO API support
 
-config ARCH_NO_VIRT_TO_BUS
-	def_bool y
-
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y if SPARC64
 
diff -puN arch/tile/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/tile/Kconfig
--- a/arch/tile/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/tile/Kconfig
@@ -17,6 +17,7 @@ config TILE
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_SYSCALL_WRAPPERS if TILEGX
+	select HAVE_VIRT_TO_BUS
 	select SYS_HYPERVISOR
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
diff -puN arch/unicore32/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/unicore32/Kconfig
--- a/arch/unicore32/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/unicore32/Kconfig
@@ -9,6 +9,7 @@ config UNICORE32
 	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
+	select HAVE_VIRT_TO_BUS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
diff -puN arch/x86/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/x86/Kconfig
--- a/arch/x86/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/x86/Kconfig
@@ -112,6 +112,7 @@ config X86
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
+	select HAVE_VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
diff -puN arch/xtensa/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/arch/xtensa/Kconfig
@@ -9,6 +9,7 @@ config XTENSA
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
diff -puN mm/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus mm/Kconfig
--- a/mm/Kconfig~arch-kconfig-centralise-config_arch_no_virt_to_bus
+++ a/mm/Kconfig
@@ -287,7 +287,7 @@ config NR_QUICK
 
 config VIRT_TO_BUS
 	def_bool y
-	depends on !ARCH_NO_VIRT_TO_BUS
+	depends on HAVE_VIRT_TO_BUS
 
 config MMU_NOTIFIER
 	bool
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
kernel-forkc-export-kernel_thread-to-modules.patch

