From: akpm@linux-foundation.org
Subject: [merged] ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch removed from -mm tree
Date: Tue, 31 Jul 2012 11:54:15 -0700
Message-ID: <20120731185415.C3CE010004A@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:51513 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2GaSyS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jul 2012 14:54:18 -0400
Received: by yhl10 with SMTP id 10so761118yhl.1
        for <mm-commits@vger.kernel.org>; Tue, 31 Jul 2012 11:54:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, akpm@linux-foundation.org, arnd@arndb.de, catalin.marinas@arm.com, cmetcalf@tilera.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: use Kconfig options for __ARCH_WANT_[COMPAT_]IPC_PARSE_VERSION
has been removed from the -mm tree.  Its filename was
     ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: ipc: use Kconfig options for __ARCH_WANT_[COMPAT_]IPC_PARSE_VERSION

Rather than #define the options manually in the architecture code, add
Kconfig options for them and select them there instead.  This also allows
us to select the compat IPC version parsing automatically for platforms
using the old compat IPC interface.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/Kconfig                         |    7 +++++++
 arch/alpha/Kconfig                   |    1 +
 arch/alpha/include/asm/unistd.h      |    1 -
 arch/arm/Kconfig                     |    1 +
 arch/arm/include/asm/unistd.h        |    1 -
 arch/avr32/Kconfig                   |    1 +
 arch/avr32/include/asm/unistd.h      |    1 -
 arch/blackfin/Kconfig                |    1 +
 arch/blackfin/include/asm/unistd.h   |    1 -
 arch/cris/Kconfig                    |    1 +
 arch/cris/include/asm/unistd.h       |    1 -
 arch/frv/Kconfig                     |    1 +
 arch/frv/include/asm/unistd.h        |    1 -
 arch/h8300/Kconfig                   |    1 +
 arch/h8300/include/asm/unistd.h      |    1 -
 arch/m32r/Kconfig                    |    1 +
 arch/m32r/include/asm/unistd.h       |    1 -
 arch/m68k/Kconfig                    |    1 +
 arch/m68k/include/asm/unistd.h       |    1 -
 arch/microblaze/Kconfig              |    1 +
 arch/microblaze/include/asm/unistd.h |    1 -
 arch/mips/Kconfig                    |    1 +
 arch/mips/include/asm/unistd.h       |    1 -
 arch/mn10300/Kconfig                 |    1 +
 arch/mn10300/include/asm/unistd.h    |    1 -
 arch/powerpc/Kconfig                 |    1 +
 arch/powerpc/include/asm/unistd.h    |    1 -
 arch/s390/Kconfig                    |    1 +
 arch/s390/include/asm/unistd.h       |    1 -
 arch/sh/Kconfig                      |    2 ++
 arch/sh/include/asm/unistd.h         |    1 -
 arch/sparc/Kconfig                   |    1 +
 arch/sparc/include/asm/unistd.h      |    1 -
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/unistd.h        |    1 -
 include/linux/compat.h               |    1 -
 ipc/compat.c                         |    2 +-
 ipc/util.c                           |    4 ++--
 ipc/util.h                           |    2 +-
 39 files changed, 29 insertions(+), 22 deletions(-)

diff -puN arch/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/Kconfig
--- a/arch/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/Kconfig
@@ -248,7 +248,14 @@ config HAVE_CMPXCHG_LOCAL
 config HAVE_CMPXCHG_DOUBLE
 	bool
 
+config ARCH_WANT_IPC_PARSE_VERSION
+	bool
+
+config ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+	bool
+
 config ARCH_WANT_OLD_COMPAT_IPC
+	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	bool
 
 config HAVE_ARCH_SECCOMP_FILTER
diff -puN arch/alpha/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/alpha/Kconfig
@@ -14,6 +14,7 @@ config ALPHA
 	select AUTO_IRQ_AFFINITY if SMP
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
diff -puN arch/alpha/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/alpha/include/asm/unistd.h
--- a/arch/alpha/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/alpha/include/asm/unistd.h
@@ -470,7 +470,6 @@
 
 #define NR_SYSCALLS			504
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/arm/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/arm/Kconfig
--- a/arch/arm/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/arm/Kconfig
@@ -39,6 +39,7 @@ config ARM
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IRQ_PROBE
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select HARDIRQS_SW_RESEND
 	select CPU_PM if (SUSPEND || CPU_IDLE)
 	select GENERIC_PCI_IOMAP
diff -puN arch/arm/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/arm/include/asm/unistd.h
--- a/arch/arm/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/arm/include/asm/unistd.h
@@ -446,7 +446,6 @@
 
 #ifdef __KERNEL__
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_GETHOSTNAME
 #define __ARCH_WANT_SYS_PAUSE
diff -puN arch/avr32/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/avr32/Kconfig
--- a/arch/avr32/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/avr32/Kconfig
@@ -12,6 +12,7 @@ config AVR32
 	select HARDIRQS_SW_RESEND
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_CUSTOM_GPIO_H
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
 	help
diff -puN arch/avr32/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/avr32/include/asm/unistd.h
--- a/arch/avr32/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/avr32/include/asm/unistd.h
@@ -318,7 +318,6 @@
 /* SMP stuff */
 #define __IGNORE_getcpu
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/blackfin/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/blackfin/Kconfig
--- a/arch/blackfin/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/blackfin/Kconfig
@@ -33,6 +33,7 @@ config BLACKFIN
 	select HAVE_PERF_EVENTS
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_WANT_OPTIONAL_GPIOLIB
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_PROBE
diff -puN arch/blackfin/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/blackfin/include/asm/unistd.h
--- a/arch/blackfin/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/blackfin/include/asm/unistd.h
@@ -434,7 +434,6 @@
 #define __IGNORE_getcpu
 
 #ifdef __KERNEL__
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/cris/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/cris/Kconfig
--- a/arch/cris/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/cris/Kconfig
@@ -42,6 +42,7 @@ config CRIS
 	select HAVE_IDE
 	select GENERIC_ATOMIC64
 	select HAVE_GENERIC_HARDIRQS
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
diff -puN arch/cris/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/cris/include/asm/unistd.h
--- a/arch/cris/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/cris/include/asm/unistd.h
@@ -347,7 +347,6 @@
 
 #include <arch/unistd.h>
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff -puN arch/frv/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/frv/Kconfig
--- a/arch/frv/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/frv/Kconfig
@@ -9,6 +9,7 @@ config FRV
 	select GENERIC_IRQ_SHOW
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CPU_DEVICES
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config ZONE_DMA
 	bool
diff -puN arch/frv/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/frv/include/asm/unistd.h
--- a/arch/frv/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/frv/include/asm/unistd.h
@@ -349,7 +349,6 @@
 
 #define NR_syscalls 338
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff -puN arch/h8300/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/h8300/Kconfig
@@ -3,6 +3,7 @@ config H8300
 	default y
 	select HAVE_IDE
 	select HAVE_GENERIC_HARDIRQS
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
 
diff -puN arch/h8300/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/h8300/include/asm/unistd.h
--- a/arch/h8300/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/h8300/include/asm/unistd.h
@@ -331,7 +331,6 @@
 
 #define NR_syscalls 321
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff -puN arch/m32r/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/m32r/Kconfig
@@ -7,6 +7,7 @@ config M32R
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_LZMA
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
diff -puN arch/m32r/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/m32r/include/asm/unistd.h
--- a/arch/m32r/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/m32r/include/asm/unistd.h
@@ -336,7 +336,6 @@
 
 #define NR_syscalls 326
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/m68k/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/m68k/Kconfig
@@ -10,6 +10,7 @@ config M68K
 	select GENERIC_STRNCPY_FROM_USER if MMU
 	select GENERIC_STRNLEN_USER if MMU
 	select FPU if MMU
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
 
 config RWSEM_GENERIC_SPINLOCK
diff -puN arch/m68k/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/m68k/include/asm/unistd.h
--- a/arch/m68k/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/m68k/include/asm/unistd.h
@@ -357,7 +357,6 @@
 
 #define NR_syscalls		347
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff -puN arch/microblaze/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/microblaze/Kconfig
--- a/arch/microblaze/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/microblaze/Kconfig
@@ -15,6 +15,7 @@ config MICROBLAZE
 	select TRACING_SUPPORT
 	select OF
 	select OF_EARLY_FLATTREE
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select IRQ_DOMAIN
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_PROBE
diff -puN arch/microblaze/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/microblaze/include/asm/unistd.h
--- a/arch/microblaze/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/microblaze/include/asm/unistd.h
@@ -400,7 +400,6 @@
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 /* #define __ARCH_WANT_OLD_READDIR */
 /* #define __ARCH_WANT_OLD_STAT */
 #define __ARCH_WANT_STAT64
diff -puN arch/mips/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/mips/Kconfig
--- a/arch/mips/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/mips/Kconfig
@@ -27,6 +27,7 @@ config MIPS
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
 	select HAVE_ARCH_JUMP_LABEL
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select IRQ_FORCED_THREADING
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
diff -puN arch/mips/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/mips/include/asm/unistd.h
--- a/arch/mips/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/mips/include/asm/unistd.h
@@ -1034,7 +1034,6 @@
 #ifndef __ASSEMBLY__
 
 #define __ARCH_OMIT_COMPAT_SYS_GETDENTS64
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/mn10300/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/mn10300/Kconfig
--- a/arch/mn10300/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/mn10300/Kconfig
@@ -3,6 +3,7 @@ config MN10300
 	select HAVE_OPROFILE
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
diff -puN arch/mn10300/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/mn10300/include/asm/unistd.h
--- a/arch/mn10300/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/mn10300/include/asm/unistd.h
@@ -358,7 +358,6 @@
 /*
  * specify the deprecated syscalls we want to support on this arch
  */
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
 #define __ARCH_WANT_STAT64
diff -puN arch/powerpc/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/powerpc/Kconfig
@@ -121,6 +121,7 @@ config PPC
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select SPARSE_IRQ
 	select IRQ_PER_CPU
 	select IRQ_DOMAIN
diff -puN arch/powerpc/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/powerpc/include/asm/unistd.h
--- a/arch/powerpc/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/powerpc/include/asm/unistd.h
@@ -389,7 +389,6 @@
 #include <linux/compiler.h>
 #include <linux/linkage.h>
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
diff -puN arch/s390/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/s390/Kconfig
--- a/arch/s390/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/s390/Kconfig
@@ -118,6 +118,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_CLOCKEVENTS
diff -puN arch/s390/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/s390/include/asm/unistd.h
--- a/arch/s390/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/s390/include/asm/unistd.h
@@ -388,7 +388,6 @@
 #define __IGNORE_recvmmsg
 #define __IGNORE_sendmmsg
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/sh/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/sh/Kconfig
--- a/arch/sh/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/sh/Kconfig
@@ -21,6 +21,7 @@ config SUPERH
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_XZ
 	select HAVE_KERNEL_LZO
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_GENERIC_HARDIRQS
@@ -50,6 +51,7 @@ config SUPERH32
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_FTRACE_NMI_ENTER if DYNAMIC_FTRACE
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_ARCH_KGDB
 	select HAVE_HW_BREAKPOINT
diff -puN arch/sh/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/sh/include/asm/unistd.h
--- a/arch/sh/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/sh/include/asm/unistd.h
@@ -6,7 +6,6 @@
 # endif
 
 # define __ARCH_WANT_SYS_RT_SIGSUSPEND
-# define __ARCH_WANT_IPC_PARSE_VERSION
 # define __ARCH_WANT_OLD_READDIR
 # define __ARCH_WANT_OLD_STAT
 # define __ARCH_WANT_STAT64
diff -puN arch/sparc/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/sparc/Kconfig
@@ -27,6 +27,7 @@ config SPARC
 	select HAVE_ARCH_JUMP_LABEL
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
+	select ARCH_WANT_IPC_PARSE_VERSION
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select GENERIC_PCI_IOMAP
 	select HAVE_NMI_WATCHDOG if SPARC64
diff -puN arch/sparc/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/sparc/include/asm/unistd.h
--- a/arch/sparc/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/sparc/include/asm/unistd.h
@@ -423,7 +423,6 @@
 #endif
 
 #ifdef __KERNEL__
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_STAT64
 #define __ARCH_WANT_SYS_ALARM
diff -puN arch/x86/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/x86/Kconfig
--- a/arch/x86/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/x86/Kconfig
@@ -85,6 +85,7 @@ config X86
 	select GENERIC_IOMAP
 	select DCACHE_WORD_ACCESS
 	select GENERIC_SMP_IDLE_THREAD
+	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
 	select HAVE_ARCH_SECCOMP_FILTER
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CMOS_UPDATE
diff -puN arch/x86/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/x86/include/asm/unistd.h
--- a/arch/x86/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/x86/include/asm/unistd.h
@@ -15,7 +15,6 @@
 # ifdef CONFIG_X86_32
 
 #  include <asm/unistd_32.h>
-#  define __ARCH_WANT_IPC_PARSE_VERSION
 #  define __ARCH_WANT_STAT64
 #  define __ARCH_WANT_SYS_IPC
 #  define __ARCH_WANT_SYS_OLD_MMAP
diff -puN include/linux/compat.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version include/linux/compat.h
--- a/include/linux/compat.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/include/linux/compat.h
@@ -256,7 +256,6 @@ compat_sys_get_robust_list(int pid, comp
 			   compat_size_t __user *len_ptr);
 
 #ifdef CONFIG_ARCH_WANT_OLD_COMPAT_IPC
-#define __ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 long compat_sys_semctl(int first, int second, int third, void __user *uptr);
 long compat_sys_msgsnd(int first, int second, int third, void __user *uptr);
 long compat_sys_msgrcv(int first, int second, int msgtyp, int third,
diff -puN ipc/compat.c~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version ipc/compat.c
--- a/ipc/compat.c~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/ipc/compat.c
@@ -118,7 +118,7 @@ extern int sem_ctls[];
 
 static inline int compat_ipc_parse_version(int *cmd)
 {
-#ifdef	__ARCH_WANT_COMPAT_IPC_PARSE_VERSION
+#ifdef	CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	int version = *cmd & IPC_64;
 
 	/* this is tricky: architectures that have support for the old
diff -puN ipc/util.c~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version ipc/util.c
--- a/ipc/util.c~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/ipc/util.c
@@ -804,7 +804,7 @@ out_up:
 	return ERR_PTR(err);
 }
 
-#ifdef __ARCH_WANT_IPC_PARSE_VERSION
+#ifdef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
 
 
 /**
@@ -826,7 +826,7 @@ int ipc_parse_version (int *cmd)
 	}
 }
 
-#endif /* __ARCH_WANT_IPC_PARSE_VERSION */
+#endif /* CONFIG_ARCH_WANT_IPC_PARSE_VERSION */
 
 #ifdef CONFIG_PROC_FS
 struct ipc_proc_iter {
diff -puN ipc/util.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version ipc/util.h
--- a/ipc/util.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/ipc/util.h
@@ -130,7 +130,7 @@ struct kern_ipc_perm *ipcctl_pre_down(st
 				      struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
 
-#ifndef __ARCH_WANT_IPC_PARSE_VERSION
+#ifndef CONFIG_ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
 # define ipc_parse_version(cmd)	IPC_64
 #else
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch

