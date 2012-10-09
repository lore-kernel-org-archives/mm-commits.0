From: akpm@linux-foundation.org
Subject: [merged] kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:05:10 -0700
Message-ID: <20121009180511.2B9B1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:63533 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:05:13 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so660044ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:05:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: catalin.marinas@arm.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, heiko.carstens@de.ibm.com, hpa@zytor.com, jdike@addtoit.com, jesper.nilsson@axis.com, lethal@linux-sh.org, linux@arm.linux.org.uk, mingo@redhat.com, richard@nod.at, schwidefsky@de.ibm.com, starvik@axis.com, tglx@linutronix.de, vapier@gentoo.org, ysato@users.sourceforge.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: Kconfig: clean up the long arch list for the UID16 config option
has been removed from the -mm tree.  Its filename was
     kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Kconfig: clean up the long arch list for the UID16 config option

Introduce HAVE_UID16 config option and select it in corresponding
architecture Kconfig files.  UID16 now only depends on HAVE_UID16.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig       |    1 +
 arch/arm64/Kconfig     |    1 +
 arch/blackfin/Kconfig  |    1 +
 arch/cris/Kconfig      |    1 +
 arch/frv/Kconfig       |    1 +
 arch/h8300/Kconfig     |    1 +
 arch/m68k/Kconfig      |    1 +
 arch/s390/Kconfig      |    1 +
 arch/sh/Kconfig        |    1 +
 arch/sparc/Kconfig     |    2 ++
 arch/um/Kconfig.common |    1 +
 arch/x86/Kconfig       |    2 ++
 init/Kconfig           |    6 ++++--
 13 files changed, 18 insertions(+), 2 deletions(-)

diff -puN arch/arm/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/arm/Kconfig
--- a/arch/arm/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/arm/Kconfig
@@ -39,6 +39,7 @@ config ARM
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HARDIRQS_SW_RESEND
 	select CPU_PM if (SUSPEND || CPU_IDLE)
diff -puN arch/arm64/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/arm64/Kconfig
--- a/arch/arm64/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/arm64/Kconfig
@@ -193,6 +193,7 @@ config COMPAT
 	bool "Kernel support for 32-bit EL0"
 	depends on !ARM64_64K_PAGES
 	select COMPAT_BINFMT_ELF
+	select HAVE_UID16
 	help
 	  This option enables support for a 32-bit EL0 running under a 64-bit
 	  kernel at EL1. AArch32-specific components such as system calls,
diff -puN arch/blackfin/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/blackfin/Kconfig
@@ -33,6 +33,7 @@ config BLACKFIN
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
diff -puN arch/cris/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/cris/Kconfig
--- a/arch/cris/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/cris/Kconfig
@@ -42,6 +42,7 @@ config CRIS
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
diff -puN arch/frv/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/frv/Kconfig
--- a/arch/frv/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/frv/Kconfig
@@ -5,6 +5,7 @@ config FRV
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
+	select HAVE_UID16
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN arch/h8300/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/h8300/Kconfig
@@ -3,6 +3,7 @@ config H8300
 	default y
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
diff -puN arch/m68k/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/m68k/Kconfig
@@ -6,6 +6,7 @@ config M68K
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
+	select HAVE_UID16
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG if RMW_INSNS
 	select GENERIC_CPU_DEVICES
 	select GENERIC_STRNCPY_FROM_USER if MMU
diff -puN arch/s390/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/s390/Kconfig
--- a/arch/s390/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/s390/Kconfig
@@ -126,6 +126,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select HAVE_UID16 if 32BIT
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
diff -puN arch/sh/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/sh/Kconfig
--- a/arch/sh/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/sh/Kconfig
@@ -21,6 +21,7 @@ config SUPERH
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
+	select HAVE_UID16
 	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
diff -puN arch/sparc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/sparc/Kconfig
@@ -42,6 +42,7 @@ config SPARC32
 	def_bool !64BIT
 	select GENERIC_ATOMIC64
 	select CLZ_TAB
+	select HAVE_UID16
 
 config SPARC64
 	def_bool 64BIT
@@ -571,6 +572,7 @@ config COMPAT
 	depends on SPARC64
 	default y
 	select COMPAT_BINFMT_ELF
+	select HAVE_UID16
 	select ARCH_WANT_OLD_COMPAT_IPC
 
 config SYSVIPC_COMPAT
diff -puN arch/um/Kconfig.common~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/um/Kconfig.common
--- a/arch/um/Kconfig.common~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/um/Kconfig.common
@@ -7,6 +7,7 @@ config UML
 	bool
 	default y
 	select HAVE_GENERIC_HARDIRQS
+	select HAVE_UID16
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 	select GENERIC_IO
diff -puN arch/x86/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option arch/x86/Kconfig
--- a/arch/x86/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/arch/x86/Kconfig
@@ -10,6 +10,7 @@ config X86_32
 	def_bool y
 	depends on !64BIT
 	select CLKSRC_I8253
+	select HAVE_UID16
 
 config X86_64
 	def_bool y
@@ -2168,6 +2169,7 @@ config IA32_EMULATION
 	bool "IA32 Emulation"
 	depends on X86_64
 	select COMPAT_BINFMT_ELF
+	select HAVE_UID16
 	---help---
 	  Include code to run legacy 32-bit programs under a
 	  64-bit kernel. You should likely turn this on, unless you're
diff -puN init/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option init/Kconfig
--- a/init/Kconfig~kconfig-clean-up-the-long-arch-list-for-the-uid16-config-option
+++ a/init/Kconfig
@@ -1125,10 +1125,12 @@ menuconfig EXPERT
           environments which can tolerate a "non-standard" kernel.
           Only use this if you really know what you are doing.
 
+config HAVE_UID16
+	bool
+
 config UID16
 	bool "Enable 16-bit UID system calls" if EXPERT
-	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && COMPAT) || UML || (X86_64 && IA32_EMULATION) \
-		|| AARCH32_EMULATION
+	depends on HAVE_UID16
 	default y
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
_

Patches currently in -mm which might be from catalin.marinas@arm.com are

origin.patch
linux-next.patch
compat-generic-compat_sys_sched_rr_get_interval-implementation.patch

