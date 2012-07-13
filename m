From: akpm@linux-foundation.org
Subject: + ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch added to -mm tree
Date: Fri, 13 Jul 2012 13:59:46 -0700
Message-ID: <20120713205947.2D7475C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:34896 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab2GMU7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 16:59:50 -0400
Received: by lbbgp10 with SMTP id gp10so221841lbb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 13:59:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, akpm@linux-foundation.org, arnd@arndb.de, catalin.marinas@arm.com, cmetcalf@tilera.com


The patch titled
     Subject: ipc: use Kconfig options for __ARCH_WANT_[COMPAT_]IPC_PARSE_VERSION
has been added to the -mm tree.  Its filename is
     ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
 arch/sh/Kconfig                      |    1 +
 arch/sh/include/asm/unistd.h         |    1 -
 arch/sparc/Kconfig                   |    1 +
 arch/sparc/include/asm/unistd.h      |    1 -
 arch/x86/Kconfig                     |    1 +
 arch/x86/include/asm/unistd.h        |    1 -
 include/linux/compat.h               |    1 -
 ipc/compat.c                         |    2 +-
 ipc/util.c                           |    4 ++--
 ipc/util.h                           |    2 +-
 39 files changed, 28 insertions(+), 22 deletions(-)

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
@@ -17,6 +17,7 @@ config ALPHA
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_SMP_IDLE_THREAD
 	select GENERIC_CMOS_UPDATE
+	select ARCH_WANT_IPC_PARSE_VERSION
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
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
@@ -38,6 +38,7 @@ config ARM
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
@@ -14,6 +14,7 @@ config AVR32
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
 	select GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 	help
 	  AVR32 is a high-performance 32-bit RISC microprocessor core,
 	  designed for cost-sensitive embedded applications, with particular
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
@@ -40,6 +40,7 @@ config BLACKFIN
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
 	select GENERIC_SMP_IDLE_THREAD
 	select ARCH_USES_GETTIMEOFFSET if !GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config GENERIC_CSUM
 	def_bool y
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
@@ -46,6 +46,7 @@ config CRIS
 	select GENERIC_IOMAP
 	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
 	select GENERIC_CMOS_UPDATE
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config HZ
 	int
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
@@ -5,6 +5,7 @@ config H8300
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_CPU_DEVICES
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SYMBOL_PREFIX
 	string
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
@@ -12,6 +12,7 @@ config M32R
 	select GENERIC_IRQ_SHOW
 	select GENERIC_ATOMIC64
 	select ARCH_USES_GETTIMEOFFSET
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SBUS
 	bool
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
@@ -11,6 +11,7 @@ config M68K
 	select GENERIC_STRNLEN_USER if MMU
 	select FPU if MMU
 	select ARCH_USES_GETTIMEOFFSET if MMU && !COLDFIRE
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config RWSEM_GENERIC_SPINLOCK
 	bool
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
@@ -23,6 +23,7 @@ config MICROBLAZE
 	select GENERIC_CPU_DEVICES
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SWAP
 	def_bool n
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
@@ -34,6 +34,7 @@ config MIPS
 	select BUILDTIME_EXTABLE_SORT
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_CMOS_UPDATE
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 menu "Machine selection"
 
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
@@ -7,6 +7,7 @@ config MN10300
 	select HAVE_ARCH_KGDB
 	select HAVE_NMI_WATCHDOG if MN10300_WD_TIMER
 	select GENERIC_CLOCKEVENTS
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config AM33_2
 	def_bool n
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
@@ -137,6 +137,7 @@ config PPC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config EARLY_PRINTK
 	bool
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
@@ -121,6 +121,7 @@ config S390
 	select GENERIC_TIME_VSYSCALL
 	select GENERIC_CLOCKEVENTS
 	select KTIME_SCALAR if 32BIT
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff -puN arch/s390/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/s390/include/asm/unistd.h
--- a/arch/s390/include/asm/unistd.h~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/s390/include/asm/unistd.h
@@ -390,7 +390,6 @@
 #define __IGNORE_recvmmsg
 #define __IGNORE_sendmmsg
 
-#define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_SYS_ALARM
 #define __ARCH_WANT_SYS_GETHOSTNAME
diff -puN arch/sh/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version arch/sh/Kconfig
--- a/arch/sh/Kconfig~ipc-use-kconfig-options-for-__arch_want_ipc_parse_version
+++ a/arch/sh/Kconfig
@@ -34,6 +34,7 @@ config SUPERH
 	select GENERIC_CMOS_UPDATE if SH_SH03 || SH_DREAMCAST
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
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
@@ -36,6 +36,7 @@ config SPARC
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION
 
 config SPARC32
 	def_bool !64BIT
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
@@ -95,6 +95,7 @@ config X86
 	select KTIME_SCALAR if X86_32
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
+	select ARCH_WANT_IPC_PARSE_VERSION if X86_32
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS || UPROBES)
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
Subject: Subject: ipc: use Kconfig options for __ARCH_WANT_[COMPAT_]IPC_PARSE_VERSION

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
ipc-add-compat_shmlba-support.patch
ipc-allow-compat-ipc-version-field-parsing-if-arch_want_old_compat_ipc.patch
ipc-compat-use-signed-size_t-types-for-msgsnd-and-msgrcv.patch
ipc-use-kconfig-options-for-__arch_want_ipc_parse_version.patch

