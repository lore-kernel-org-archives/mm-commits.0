From: akpm@linux-foundation.org
Subject: [merged] kconfig-select-virt_to_bus-directly-where-needed.patch removed from -mm tree
Date: Wed, 13 Mar 2013 12:48:13 -0700
Message-ID: <20130313194813.70F5E31C37F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:58586 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236Ab3CMTsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Mar 2013 15:48:14 -0400
Received: by mail-qa0-f74.google.com with SMTP id o13so155850qaj.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Mar 2013 12:48:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: select VIRT_TO_BUS directly where needed
has been removed from the -mm tree.  Its filename was
     kconfig-select-virt_to_bus-directly-where-needed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Kconfig: select VIRT_TO_BUS directly where needed

In 887cbce0adea ("arch Kconfig: centralise CONFIG_ARCH_NO_VIRT_TO_BUS") I
introduced the config sybmol HAVE_VIRT_TO_BUS and selected that where
needed.  I am not sure what I was thinking.  Instead, just directly select
VIRT_TO_BUS where it is needed.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig            |    7 -------
 arch/alpha/Kconfig      |    2 +-
 arch/arm/Kconfig        |    2 +-
 arch/avr32/Kconfig      |    2 +-
 arch/blackfin/Kconfig   |    2 +-
 arch/cris/Kconfig       |    2 +-
 arch/frv/Kconfig        |    2 +-
 arch/h8300/Kconfig      |    2 +-
 arch/ia64/Kconfig       |    2 +-
 arch/m32r/Kconfig       |    2 +-
 arch/m68k/Kconfig       |    2 +-
 arch/microblaze/Kconfig |    2 +-
 arch/mips/Kconfig       |    2 +-
 arch/mn10300/Kconfig    |    2 +-
 arch/openrisc/Kconfig   |    2 +-
 arch/parisc/Kconfig     |    2 +-
 arch/powerpc/Kconfig    |    2 +-
 arch/s390/Kconfig       |    2 +-
 arch/score/Kconfig      |    2 +-
 arch/tile/Kconfig       |    2 +-
 arch/unicore32/Kconfig  |    2 +-
 arch/x86/Kconfig        |    2 +-
 arch/xtensa/Kconfig     |    2 +-
 mm/Kconfig              |    8 ++++++--
 24 files changed, 28 insertions(+), 31 deletions(-)

diff -puN arch/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/Kconfig
--- a/arch/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/Kconfig
@@ -316,13 +316,6 @@ config ARCH_WANT_OLD_COMPAT_IPC
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
 
-config HAVE_VIRT_TO_BUS
-	bool
-	help
-	  An architecture should select this if it implements the
-	  deprecated interface virt_to_bus().  All new architectures
-	  should probably not select this.
-
 config HAVE_ARCH_SECCOMP_FILTER
 	bool
 	help
diff -puN arch/alpha/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/alpha/Kconfig
@@ -8,7 +8,7 @@ config ALPHA
 	select HAVE_PERF_EVENTS
 	select HAVE_DMA_ATTRS
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
diff -puN arch/arm/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/arm/Kconfig
--- a/arch/arm/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/arm/Kconfig
@@ -49,7 +49,7 @@ config ARM
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select KTIME_SCALAR
 	select PERF_USE_VMALLOC
 	select RTC_LIB
diff -puN arch/avr32/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/avr32/Kconfig
@@ -7,7 +7,7 @@ config AVR32
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_ATOMIC64
 	select HARDIRQS_SW_RESEND
diff -puN arch/blackfin/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/blackfin/Kconfig
@@ -33,7 +33,7 @@ config BLACKFIN
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
diff -puN arch/cris/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/cris/Kconfig
--- a/arch/cris/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/cris/Kconfig
@@ -43,7 +43,7 @@ config CRIS
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
diff -puN arch/frv/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/frv/Kconfig
--- a/arch/frv/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/frv/Kconfig
@@ -6,7 +6,7 @@ config FRV
 	select HAVE_PERF_EVENTS
 	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/h8300/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/h8300/Kconfig
@@ -5,7 +5,7 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff -puN arch/ia64/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/ia64/Kconfig
@@ -26,7 +26,7 @@ config IA64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_DISCARD_MEMBLOCK
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
diff -puN arch/m32r/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/m32r/Kconfig
@@ -10,7 +10,7 @@ config M32R
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
diff -puN arch/m68k/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/m68k/Kconfig
@@ -8,7 +8,7 @@ config M68K
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select HAVE_UID16
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select GENERIC_STRNCPY_FROM_USER if MMU
diff -puN arch/microblaze/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/microblaze/Kconfig
@@ -19,7 +19,7 @@ config MICROBLAZE
 	select HAVE_DEBUG_KMEMLEAK
 	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_PCI_IOMAP
diff -puN arch/mips/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/mips/Kconfig
--- a/arch/mips/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/mips/Kconfig
@@ -38,7 +38,7 @@ config MIPS
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
 	select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if MODULES
 	select MODULES_USE_ELF_RELA if MODULES && 64BIT
 	select CLONE_BACKWARDS
diff -puN arch/mn10300/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/mn10300/Kconfig
@@ -8,7 +8,7 @@ config MN10300
 	select HAVE_ARCH_KGDB
 	select GENERIC_ATOMIC64
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_CLOCKEVENTS
 	select MODULES_USE_ELF_RELA
 	select OLD_SIGSUSPEND3
diff -puN arch/openrisc/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/openrisc/Kconfig
--- a/arch/openrisc/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/openrisc/Kconfig
@@ -12,7 +12,7 @@ config OPENRISC
 	select ARCH_REQUIRE_GPIOLIB
         select HAVE_ARCH_TRACEHOOK
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_CHIP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff -puN arch/parisc/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/parisc/Kconfig
--- a/arch/parisc/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/parisc/Kconfig
@@ -22,7 +22,7 @@ config PARISC
 	select GENERIC_STRNCPY_FROM_USER
 	select SYSCTL_ARCH_UNALIGN_ALLOW
 	select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_RELA
 	select CLONE_BACKWARDS
 	select TTY # Needed for pdc_cons.c
diff -puN arch/powerpc/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/powerpc/Kconfig
@@ -98,7 +98,7 @@ config PPC
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select SYSCTL_EXCEPTION_TRACE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
-	select HAVE_VIRT_TO_BUS if !PPC64
+	select VIRT_TO_BUS if !PPC64
 	select HAVE_IDE
 	select HAVE_IOREMAP_PROT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
diff -puN arch/s390/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/s390/Kconfig
@@ -134,7 +134,7 @@ config S390
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16 if 32BIT
 	select HAVE_VIRT_CPU_ACCOUNTING
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select INIT_ALL_POSSIBLE
 	select KTIME_SCALAR if 32BIT
 	select MODULES_USE_ELF_RELA
diff -puN arch/score/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/score/Kconfig
--- a/arch/score/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/score/Kconfig
@@ -12,7 +12,7 @@ config SCORE
        select GENERIC_CPU_DEVICES
        select GENERIC_CLOCKEVENTS
        select HAVE_MOD_ARCH_SPECIFIC
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL
 	select CLONE_BACKWARDS
 
diff -puN arch/tile/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/tile/Kconfig
--- a/arch/tile/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/tile/Kconfig
@@ -16,7 +16,7 @@ config TILE
 	select GENERIC_PENDING_IRQ if SMP
 	select GENERIC_IRQ_SHOW
 	select HAVE_DEBUG_BUGVERBOSE
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select SYS_HYPERVISOR
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/unicore32/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/unicore32/Kconfig
--- a/arch/unicore32/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/unicore32/Kconfig
@@ -9,7 +9,7 @@ config UNICORE32
 	select GENERIC_ATOMIC64
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_LZMA
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select GENERIC_FIND_FIRST_BIT
 	select GENERIC_IRQ_PROBE
diff -puN arch/x86/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/x86/Kconfig
@@ -113,7 +113,7 @@ config X86
 	select GENERIC_STRNLEN_USER
 	select HAVE_CONTEXT_TRACKING if X86_64
 	select HAVE_IRQ_TIME_ACCOUNTING
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select MODULES_USE_ELF_REL if X86_32
 	select MODULES_USE_ELF_RELA if X86_64
 	select CLONE_BACKWARDS if X86_32
diff -puN arch/xtensa/Kconfig~kconfig-select-virt_to_bus-directly-where-needed arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/arch/xtensa/Kconfig
@@ -9,7 +9,7 @@ config XTENSA
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
-	select HAVE_VIRT_TO_BUS
+	select VIRT_TO_BUS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select MODULES_USE_ELF_RELA
diff -puN mm/Kconfig~kconfig-select-virt_to_bus-directly-where-needed mm/Kconfig
--- a/mm/Kconfig~kconfig-select-virt_to_bus-directly-where-needed
+++ a/mm/Kconfig
@@ -286,8 +286,12 @@ config NR_QUICK
 	default "1"
 
 config VIRT_TO_BUS
-	def_bool y
-	depends on HAVE_VIRT_TO_BUS
+	bool
+	help
+	  An architecture should select this if it implements the
+	  deprecated interface virt_to_bus().  All new architectures
+	  should probably not select this.
+
 
 config MMU_NOTIFIER
 	bool
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
linux-next.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch
kernel-forkc-export-kernel_thread-to-modules.patch

