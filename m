From: akpm@linux-foundation.org
Subject: + avoid-overflows-in-kernel-timec.patch added to -mm tree
Date: Sat, 22 Dec 2007 01:46:54 -0800
Message-ID: <200712220946.lBM9ksvu027086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXLVJs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 04:48:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hpa@zytor.com, davem@davemloft.net, dhowells@redhat.com, geert@linux-m68k.org, ink@jurassic.park.msu.ru, jesper.nilsson@axis.com, johnstul@us.ibm.com, lethal@linux-sh.org, mingo@elte.hu, rth@twiddle.net, sam@ravnborg.org, tglx@linutronix.de, zippel@linux-m68k.org


The patch titled
     Avoid overflows in kernel/time.c
has been added to the -mm tree.  Its filename is
     avoid-overflows-in-kernel-timec.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Avoid overflows in kernel/time.c
From: "H. Peter Anvin" <hpa@zytor.com>

When the conversion factor between jiffies and milli- or microseconds is
not a single multiply or divide, as for the case of HZ == 300, we currently
do a multiply followed by a divide.  The intervening result, however, is
subject to overflows, especially since the fraction is not simplified (for
HZ == 300, we multiply by 300 and divide by 1000).

This is exposed to the user when passing a large timeout to poll(), for
example.

This patch replaces the multiply-divide with a reciprocal multiplication on
32-bit platforms.  When the input is an unsigned long, there is no portable
way to do this on 64-bit platforms there is no portable way to do this
since it requires a 128-bit intermediate result (which gcc does support on
64-bit platforms but may generate libgcc calls, e.g.  on 64-bit s390), but
since the output is a 32-bit integer in the cases affected, just simplify
the multiply-divide (*3/10 instead of *300/1000).

The reciprocal multiply used can have off-by-one errors in the upper half
of the valid output range.  This could be avoided at the expense of having
to deal with a potential 65-bit intermediate result.  Since the intent is
to avoid overflow problems and most of the other time conversions are only
semiexact, the off-by-one errors were considered an acceptable tradeoff.

At Ralf Baechle's suggestion, this version uses a Perl script to compute
the necessary constants.  We already have dependencies on Perl for kernel
compiles.  This does, however, require the Perl module Math::BigInt, which
is included in the standard Perl distribution starting with version 5.8.0. 
In order to support older versions of Perl, include a table of canned
constants in the script itself, and structure the script so that
Math::BigInt isn't required if pulling values from said table.

Running the script requires that the HZ value is available from the
Makefile.  Thus, this patch also adds the Kconfig variable CONFIG_HZ to the
architectures which didn't already have it (alpha, cris, frv, h8300, m32r,
m68k, m68knommu, sh64, sparc, v850, and xtensa.) It does *not* resolve a
weird case in the sh architecture, where HZ != CONFIG_HZ if CONFIG_SH_WDT
is set.  Paul Mundt has been contacted about that, and has agreed to fix it
up.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig            |    5 
 arch/cris/Kconfig             |    4 
 arch/frv/Kconfig              |    4 
 arch/h8300/Kconfig            |    4 
 arch/m32r/Kconfig             |    4 
 arch/m68k/Kconfig             |    4 
 arch/m68knommu/Kconfig        |    5 
 arch/sh64/Kconfig             |    6 
 arch/sparc/Kconfig            |    4 
 arch/v850/Kconfig             |    7 
 arch/xtensa/Kconfig           |    4 
 include/asm-alpha/param.h     |   10 
 include/asm-cris/param.h      |    2 
 include/asm-frv/param.h       |    2 
 include/asm-h8300/param.h     |    2 
 include/asm-m32r/param.h      |    2 
 include/asm-m68k/param.h      |    2 
 include/asm-m68knommu/param.h |    8 
 include/asm-sparc/param.h     |    2 
 include/asm-v850/anna.h       |    6 
 include/asm-v850/as85ep1.h    |    6 
 include/asm-v850/fpga85e2c.h  |    6 
 include/asm-v850/param.h      |    3 
 include/asm-v850/rte_cb.h     |    6 
 include/asm-v850/sim.h        |    5 
 include/asm-v850/sim85e2.h    |    6 
 include/asm-xtensa/param.h    |    2 
 kernel/Makefile               |    8 
 kernel/time.c                 |   29 +-
 kernel/timeconst.pl           |  340 ++++++++++++++++++++++++++++++++
 30 files changed, 430 insertions(+), 68 deletions(-)

diff -puN arch/alpha/Kconfig~avoid-overflows-in-kernel-timec arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/alpha/Kconfig
@@ -611,6 +611,11 @@ config VERBOSE_MCHECK_ON
 
 	  Take the default (1) unless you want more control or more info.
 
+config HZ
+	int
+	default 1200 if ALPHA_RAWHIDE
+	default 1024
+
 source "drivers/pci/Kconfig"
 source "drivers/eisa/Kconfig"
 
diff -puN arch/cris/Kconfig~avoid-overflows-in-kernel-timec arch/cris/Kconfig
--- a/arch/cris/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/cris/Kconfig
@@ -55,6 +55,10 @@ config CRIS
 	bool
 	default y
 
+config HZ
+	int
+	default 100
+
 source "init/Kconfig"
 
 menu "General setup"
diff -puN arch/frv/Kconfig~avoid-overflows-in-kernel-timec arch/frv/Kconfig
--- a/arch/frv/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/frv/Kconfig
@@ -57,6 +57,10 @@ config ARCH_HAS_ILOG2_U64
 	bool
 	default y
 
+config HZ
+	int
+	default 1000
+
 mainmenu "Fujitsu FR-V Kernel Configuration"
 
 source "init/Kconfig"
diff -puN arch/h8300/Kconfig~avoid-overflows-in-kernel-timec arch/h8300/Kconfig
--- a/arch/h8300/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/h8300/Kconfig
@@ -79,6 +79,10 @@ config PCI
 	bool
 	default n
 
+config HZ
+	int
+	default 100
+
 source "init/Kconfig"
 
 source "arch/h8300/Kconfig.cpu"
diff -puN arch/m32r/Kconfig~avoid-overflows-in-kernel-timec arch/m32r/Kconfig
--- a/arch/m32r/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/m32r/Kconfig
@@ -34,6 +34,10 @@ config NO_IOPORT
 config NO_DMA
 	def_bool y
 
+config HZ
+	int
+	default 100
+
 source "init/Kconfig"
 
 
diff -puN arch/m68k/Kconfig~avoid-overflows-in-kernel-timec arch/m68k/Kconfig
--- a/arch/m68k/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/m68k/Kconfig
@@ -52,6 +52,10 @@ config NO_IOPORT
 config NO_DMA
 	def_bool SUN3
 
+config HZ
+	int
+	default 100
+
 mainmenu "Linux/68k Kernel Configuration"
 
 source "init/Kconfig"
diff -puN arch/m68knommu/Kconfig~avoid-overflows-in-kernel-timec arch/m68knommu/Kconfig
--- a/arch/m68knommu/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/m68knommu/Kconfig
@@ -518,6 +518,11 @@ config 4KSTACKS
 	  running more threads on a system and also reduces the pressure
 	  on the VM subsystem for higher order allocations.
 
+config HZ
+	int
+	default 1000 if CLEOPATRA
+	default 100
+
 comment "RAM configuration"
 
 config RAMBASE
diff -puN arch/sh64/Kconfig~avoid-overflows-in-kernel-timec arch/sh64/Kconfig
--- a/arch/sh64/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/sh64/Kconfig
@@ -288,3 +288,9 @@ source "security/Kconfig"
 source "crypto/Kconfig"
 
 source "lib/Kconfig"
+
+# Higher frequency needed for high-res WOVF
+config HZ
+	int
+	default 1000	if SH_WDT
+	default 100
diff -puN arch/sparc/Kconfig~avoid-overflows-in-kernel-timec arch/sparc/Kconfig
--- a/arch/sparc/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/sparc/Kconfig
@@ -27,6 +27,10 @@ config ARCH_NO_VIRT_TO_BUS
 config OF
 	def_bool y
 
+config HZ
+	int
+	default 100
+
 source "init/Kconfig"
 
 menu "General machine setup"
diff -puN arch/v850/Kconfig~avoid-overflows-in-kernel-timec arch/v850/Kconfig
--- a/arch/v850/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/v850/Kconfig
@@ -212,6 +212,13 @@ menu "Processor type and features"
    	  bool
 	  default !V850E_CACHE && !V850E2_CACHE
 
+   # HZ depends on the platform
+   config HZ
+	  int
+	  default 24  if V850E_SIM || V850E2_SIM85E2
+	  default 122 if V850E2_FPGA85E2C
+	  default 100
+
    #### Misc config
 
    config ROM_KERNEL
diff -puN arch/xtensa/Kconfig~avoid-overflows-in-kernel-timec arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~avoid-overflows-in-kernel-timec
+++ a/arch/xtensa/Kconfig
@@ -49,6 +49,10 @@ config ARCH_HAS_ILOG2_U64
 config NO_IOPORT
 	def_bool y
 
+config HZ
+	int
+	default 100
+
 source "init/Kconfig"
 
 menu "Processor type and features"
diff -puN include/asm-alpha/param.h~avoid-overflows-in-kernel-timec include/asm-alpha/param.h
--- a/include/asm-alpha/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-alpha/param.h
@@ -5,15 +5,7 @@
    hardware ignores reprogramming.  We also need userland buy-in to the 
    change in HZ, since this is visible in the wait4 resources etc.  */
 
-
-#ifndef HZ
-# ifndef CONFIG_ALPHA_RAWHIDE
-#  define HZ	1024
-# else
-#  define HZ	1200
-# endif
-#endif
-
+#define HZ		CONFIG_HZ
 #define USER_HZ		HZ
 
 #define EXEC_PAGESIZE	8192
diff -puN include/asm-cris/param.h~avoid-overflows-in-kernel-timec include/asm-cris/param.h
--- a/include/asm-cris/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-cris/param.h
@@ -3,7 +3,7 @@
 
 /* Currently we assume that HZ=100 is good for CRIS. */
 #ifdef __KERNEL__
-# define HZ		100		/* Internal kernel timer frequency */
+# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 # define USER_HZ	100		/* .. some user interfaces are in "ticks" */
 # define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
 #endif
diff -puN include/asm-frv/param.h~avoid-overflows-in-kernel-timec include/asm-frv/param.h
--- a/include/asm-frv/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-frv/param.h
@@ -2,7 +2,7 @@
 #define _ASM_PARAM_H
 
 #ifdef __KERNEL__
-#define HZ		1000		/* Internal kernel timer frequency */
+#define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 #define USER_HZ		100		/* .. some user interfaces are in "ticks" */
 #define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
 #endif
diff -puN include/asm-h8300/param.h~avoid-overflows-in-kernel-timec include/asm-h8300/param.h
--- a/include/asm-h8300/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-h8300/param.h
@@ -3,7 +3,7 @@
 
 
 #ifndef HZ
-#define HZ 100
+#define HZ CONFIG_HZ
 #endif
 
 #ifdef __KERNEL__
diff -puN include/asm-m32r/param.h~avoid-overflows-in-kernel-timec include/asm-m32r/param.h
--- a/include/asm-m32r/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-m32r/param.h
@@ -2,7 +2,7 @@
 #define _ASM_M32R_PARAM_H
 
 #ifdef __KERNEL__
-# define HZ		100		/* Internal kernel timer frequency */
+# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 # define USER_HZ	100		/* .. some user interfaces are in "ticks" */
 # define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
 #endif
diff -puN include/asm-m68k/param.h~avoid-overflows-in-kernel-timec include/asm-m68k/param.h
--- a/include/asm-m68k/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-m68k/param.h
@@ -2,7 +2,7 @@
 #define _M68K_PARAM_H
 
 #ifdef __KERNEL__
-# define HZ		100		/* Internal kernel timer frequency */
+# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 # define USER_HZ	100		/* .. some user interfaces are in "ticks" */
 # define CLOCKS_PER_SEC	(USER_HZ)	/* like times() */
 #endif
diff -puN include/asm-m68knommu/param.h~avoid-overflows-in-kernel-timec include/asm-m68knommu/param.h
--- a/include/asm-m68knommu/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-m68knommu/param.h
@@ -1,13 +1,7 @@
 #ifndef _M68KNOMMU_PARAM_H
 #define _M68KNOMMU_PARAM_H
 
-
-#if defined(CONFIG_CLEOPATRA)
-#define	HZ 1000
-#endif
-#ifndef HZ
-#define	HZ 100
-#endif
+#define HZ CONFIG_HZ
 
 #ifdef __KERNEL__
 #define	USER_HZ		HZ
diff -puN include/asm-sparc/param.h~avoid-overflows-in-kernel-timec include/asm-sparc/param.h
--- a/include/asm-sparc/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-sparc/param.h
@@ -3,7 +3,7 @@
 #define _ASMSPARC_PARAM_H
 
 #ifdef __KERNEL__
-# define HZ		100	/* Internal kernel timer frequency */
+# define HZ		CONFIG_HZ	/* Internal kernel timer frequency */
 # define USER_HZ	100	/* .. some user interfaces are in "ticks" */
 # define CLOCKS_PER_SEC (USER_HZ)
 #endif
diff -puN include/asm-v850/anna.h~avoid-overflows-in-kernel-timec include/asm-v850/anna.h
--- a/include/asm-v850/anna.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-v850/anna.h
@@ -134,10 +134,4 @@ extern void anna_uart_pre_configure (uns
 #define V850E_TIMER_D_TMCD_CS_MIN	1 /* min 2^1 divider */
 
 
-/* For <asm/param.h> */
-#ifndef HZ
-#define HZ	100
-#endif
-
-
 #endif /* __V850_ANNA_H__ */
diff -puN include/asm-v850/as85ep1.h~avoid-overflows-in-kernel-timec include/asm-v850/as85ep1.h
--- a/include/asm-v850/as85ep1.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-v850/as85ep1.h
@@ -149,10 +149,4 @@ extern void as85ep1_uart_pre_configure (
 #define V850E_TIMER_D_TMCD_CS_MIN	2 /* min 2^2 divider */
 
 
-/* For <asm/param.h> */
-#ifndef HZ
-#define HZ	100
-#endif
-
-
 #endif /* __V850_AS85EP1_H__ */
diff -puN include/asm-v850/fpga85e2c.h~avoid-overflows-in-kernel-timec include/asm-v850/fpga85e2c.h
--- a/include/asm-v850/fpga85e2c.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-v850/fpga85e2c.h
@@ -79,10 +79,4 @@ extern char _r0_ram;
 #endif
 
 
-/* For <asm/param.h> */
-#ifndef HZ
-#define HZ			122 /* actually, 8.192ms ticks =~ 122.07 */
-#endif
-
-
 #endif /* __V850_FPGA85E2C_H__ */
diff -puN include/asm-v850/param.h~avoid-overflows-in-kernel-timec include/asm-v850/param.h
--- a/include/asm-v850/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-v850/param.h
@@ -23,8 +23,7 @@
 #define MAXHOSTNAMELEN	64	/* max length of hostname */
 
 #ifdef __KERNEL__
-#include <asm/machdep.h>	/* For HZ */
-
+# define HZ		CONFIG_HZ
 # define USER_HZ	100
 # define CLOCKS_PER_SEC	USER_HZ
 #endif
diff -puN include/asm-v850/rte_cb.h~avoid-overflows-in-kernel-timec include/asm-v850/rte_cb.h
--- a/include/asm-v850/rte_cb.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-v850/rte_cb.h
@@ -69,12 +69,6 @@
 #endif /* CONFIG_RTE_MB_A_PCI */
 
 
-/* For <asm/param.h> */
-#ifndef HZ
-#define HZ	100
-#endif
-
-
 #ifndef __ASSEMBLY__
 extern void rte_cb_early_init (void);
 extern void rte_cb_init_irqs (void);
diff -puN include/asm-v850/sim.h~avoid-overflows-in-kernel-timec include/asm-v850/sim.h
--- a/include/asm-v850/sim.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-v850/sim.h
@@ -40,11 +40,6 @@
 #define R0_RAM_ADDR		0xFFFFF000
 
 
-/* For <asm/param.h> */
-#ifndef HZ
-#define HZ			24	/* Minimum supported frequency.  */
-#endif
-
 /* For <asm/irq.h> */
 #define NUM_CPU_IRQS		6
 
diff -puN include/asm-v850/sim85e2.h~avoid-overflows-in-kernel-timec include/asm-v850/sim85e2.h
--- a/include/asm-v850/sim85e2.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-v850/sim85e2.h
@@ -66,10 +66,4 @@
 #define R0_RAM_ADDR		0xFFFFE000
 
 
-/* For <asm/param.h> */
-#ifndef HZ
-#define HZ			24	/* Minimum supported frequency.  */
-#endif
-
-
 #endif /* __V850_SIM85E2_H__ */
diff -puN include/asm-xtensa/param.h~avoid-overflows-in-kernel-timec include/asm-xtensa/param.h
--- a/include/asm-xtensa/param.h~avoid-overflows-in-kernel-timec
+++ a/include/asm-xtensa/param.h
@@ -12,7 +12,7 @@
 #define _XTENSA_PARAM_H
 
 #ifdef __KERNEL__
-# define HZ		100		/* internal timer frequency */
+# define HZ		CONFIG_HZ	/* internal timer frequency */
 # define USER_HZ	100		/* for user interfaces in "ticks" */
 # define CLOCKS_PER_SEC (USER_HZ)	/* frequnzy at which times() counts */
 #endif
diff -puN kernel/Makefile~avoid-overflows-in-kernel-timec kernel/Makefile
--- a/kernel/Makefile~avoid-overflows-in-kernel-timec
+++ a/kernel/Makefile
@@ -85,3 +85,11 @@ quiet_cmd_ikconfiggz = IKCFG   $@
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call if_changed,ikconfiggz)
+
+$(obj)/time.o: $(obj)/timeconst.h
+
+quiet_cmd_timeconst  = TIMEC   $@
+      cmd_timeconst  = $(PERL) $< $(CONFIG_HZ) > $@
+targets += timeconst.h
+$(obj)/timeconst.h: $(src)/timeconst.pl FORCE
+	$(call if_changed,timeconst)
diff -puN kernel/time.c~avoid-overflows-in-kernel-timec kernel/time.c
--- a/kernel/time.c~avoid-overflows-in-kernel-timec
+++ a/kernel/time.c
@@ -39,6 +39,8 @@
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
+#include "timeconst.h"
+
 /*
  * The timezone where the local system is located.  Used as a default by some
  * programs who obtain this value by using gettimeofday.
@@ -93,7 +95,8 @@ asmlinkage long sys_stime(time_t __user 
 
 #endif /* __ARCH_WANT_SYS_TIME */
 
-asmlinkage long sys_gettimeofday(struct timeval __user *tv, struct timezone __user *tz)
+asmlinkage long sys_gettimeofday(struct timeval __user *tv,
+				 struct timezone __user *tz)
 {
 	if (likely(tv != NULL)) {
 		struct timeval ktv;
@@ -118,7 +121,7 @@ asmlinkage long sys_gettimeofday(struct 
  * hard to make the program warp the clock precisely n hours)  or
  * compile in the timezone information into the kernel.  Bad, bad....
  *
- *              				- TYT, 1992-01-01
+ *						- TYT, 1992-01-01
  *
  * The best thing to do is to keep the CMOS clock in universal time (UTC)
  * as real UNIX machines always do it. This avoids all headaches about
@@ -239,7 +242,11 @@ unsigned int inline jiffies_to_msecs(con
 #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
 	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
 #else
-	return (j * MSEC_PER_SEC) / HZ;
+# if BITS_PER_LONG == 32
+	return ((u64)HZ_TO_MSEC_MUL32 * j) >> HZ_TO_MSEC_SHR32;
+# else
+	return (j * HZ_TO_MSEC_NUM) / HZ_TO_MSEC_DEN;
+# endif
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_msecs);
@@ -251,7 +258,11 @@ unsigned int inline jiffies_to_usecs(con
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
 #else
-	return (j * USEC_PER_SEC) / HZ;
+# if BITS_PER_LONG == 32
+	return ((u64)HZ_TO_USEC_MUL32 * j) >> HZ_TO_USEC_SHR32;
+# else
+	return (j * HZ_TO_USEC_NUM) / HZ_TO_USEC_DEN;
+# endif
 #endif
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
@@ -351,7 +362,7 @@ EXPORT_SYMBOL(mktime);
  * normalize to the timespec storage format
  *
  * Note: The tv_nsec part is always in the range of
- * 	0 <= tv_nsec < NSEC_PER_SEC
+ *	0 <= tv_nsec < NSEC_PER_SEC
  * For negative values only the tv_sec field is negative !
  */
 void set_normalized_timespec(struct timespec *ts, time_t sec, long nsec)
@@ -452,12 +463,13 @@ unsigned long msecs_to_jiffies(const uns
 	/*
 	 * Generic case - multiply, round and divide. But first
 	 * check that if we are doing a net multiplication, that
-	 * we wouldnt overflow:
+	 * we wouldn't overflow:
 	 */
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return (m * HZ + MSEC_PER_SEC - 1) / MSEC_PER_SEC;
+	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+		>> MSEC_TO_HZ_SHR32;
 #endif
 }
 EXPORT_SYMBOL(msecs_to_jiffies);
@@ -471,7 +483,8 @@ unsigned long usecs_to_jiffies(const uns
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return (u * HZ + USEC_PER_SEC - 1) / USEC_PER_SEC;
+	return ((u64)USEC_TO_HZ_MUL32 * m + USEC_TO_HZ_ADJ32)
+		>> USEC_TO_HZ_SHR32;
 #endif
 }
 EXPORT_SYMBOL(usecs_to_jiffies);
diff -puN /dev/null kernel/timeconst.pl
--- /dev/null
+++ a/kernel/timeconst.pl
@@ -0,0 +1,340 @@
+#!/usr/bin/perl
+# -----------------------------------------------------------------------
+#
+#   Copyright 2007 rPath, Inc. - All Rights Reserved
+#
+#   This file is part of the Linux kernel, and is made available under
+#   the terms of the GNU General Public License version 2 or (at your
+#   option) any later version; incorporated herein by reference.
+#
+# -----------------------------------------------------------------------
+#
+
+#
+# Usage: timeconst.pl HZ > timeconst.h
+#
+
+# Precomputed values for systems without Math::BigInt
+# Generated by:
+# timeconst.pl --can 24 32 48 64 100 122 128 200 250 256 300 512 \
+# 1000 1024 1200
+%canned_values = (
+	24 => [
+		'0xa6aaaaab','0x2aaaaaa',26,
+		'0xa6aaaaaaaaaaaaab','0x2aaaaaaaaaaaaaa',58,
+		'0xc49ba5e4','0x1fbe76c8b4',37,
+		'0xc49ba5e353f7ceda','0x1fbe76c8b439581062',69,
+		'0xa2c2aaab','0xaaaa',16,
+		'0xa2c2aaaaaaaaaaab','0xaaaaaaaaaaaa',48,
+		'0xc9539b89','0x7fffbce4217d',47,
+		'0xc9539b8887229e91','0x7fffbce4217d2849cb25',79,
+	], 32 => [
+		'0xfa000000','0x6000000',27,
+		'0xfa00000000000000','0x600000000000000',59,
+		'0x83126e98','0xfdf3b645a',36,
+		'0x83126e978d4fdf3c','0xfdf3b645a1cac0831',68,
+		'0xf4240000','0x0',17,
+		'0xf424000000000000','0x0',49,
+		'0x8637bd06','0x3fff79c842fa',46,
+		'0x8637bd05af6c69b6','0x3fff79c842fa5093964a',78,
+	], 48 => [
+		'0xa6aaaaab','0x6aaaaaa',27,
+		'0xa6aaaaaaaaaaaaab','0x6aaaaaaaaaaaaaa',59,
+		'0xc49ba5e4','0xfdf3b645a',36,
+		'0xc49ba5e353f7ceda','0xfdf3b645a1cac0831',68,
+		'0xa2c2aaab','0x15555',17,
+		'0xa2c2aaaaaaaaaaab','0x1555555555555',49,
+		'0xc9539b89','0x3fffbce4217d',46,
+		'0xc9539b8887229e91','0x3fffbce4217d2849cb25',78,
+	], 64 => [
+		'0xfa000000','0xe000000',28,
+		'0xfa00000000000000','0xe00000000000000',60,
+		'0x83126e98','0x7ef9db22d',35,
+		'0x83126e978d4fdf3c','0x7ef9db22d0e560418',67,
+		'0xf4240000','0x0',18,
+		'0xf424000000000000','0x0',50,
+		'0x8637bd06','0x1fff79c842fa',45,
+		'0x8637bd05af6c69b6','0x1fff79c842fa5093964a',77,
+	], 100 => [
+		'0xa0000000','0x0',28,
+		'0xa000000000000000','0x0',60,
+		'0xcccccccd','0x733333333',35,
+		'0xcccccccccccccccd','0x73333333333333333',67,
+		'0x9c400000','0x0',18,
+		'0x9c40000000000000','0x0',50,
+		'0xd1b71759','0x1fff2e48e8a7',45,
+		'0xd1b71758e219652c','0x1fff2e48e8a71de69ad4',77,
+	], 122 => [
+		'0x8325c53f','0xfbcda3a',28,
+		'0x8325c53ef368eb05','0xfbcda3ac10c9714',60,
+		'0xf9db22d1','0x7fbe76c8b',35,
+		'0xf9db22d0e560418a','0x7fbe76c8b43958106',67,
+		'0x8012e2a0','0x3ef36',18,
+		'0x8012e29f79b47583','0x3ef368eb04325',50,
+		'0xffda4053','0x1ffffbce4217',45,
+		'0xffda4052d666a983','0x1ffffbce4217d2849cb2',77,
+	], 128 => [
+		'0xfa000000','0x1e000000',29,
+		'0xfa00000000000000','0x1e00000000000000',61,
+		'0x83126e98','0x3f7ced916',34,
+		'0x83126e978d4fdf3c','0x3f7ced916872b020c',66,
+		'0xf4240000','0x40000',19,
+		'0xf424000000000000','0x4000000000000',51,
+		'0x8637bd06','0xfffbce4217d',44,
+		'0x8637bd05af6c69b6','0xfffbce4217d2849cb25',76,
+	], 200 => [
+		'0xa0000000','0x0',29,
+		'0xa000000000000000','0x0',61,
+		'0xcccccccd','0x333333333',34,
+		'0xcccccccccccccccd','0x33333333333333333',66,
+		'0x9c400000','0x0',19,
+		'0x9c40000000000000','0x0',51,
+		'0xd1b71759','0xfff2e48e8a7',44,
+		'0xd1b71758e219652c','0xfff2e48e8a71de69ad4',76,
+	], 250 => [
+		'0x80000000','0x0',29,
+		'0x8000000000000000','0x0',61,
+		'0x80000000','0x180000000',33,
+		'0x8000000000000000','0x18000000000000000',65,
+		'0xfa000000','0x0',20,
+		'0xfa00000000000000','0x0',52,
+		'0x83126e98','0x7ff7ced9168',43,
+		'0x83126e978d4fdf3c','0x7ff7ced916872b020c4',75,
+	], 256 => [
+		'0xfa000000','0x3e000000',30,
+		'0xfa00000000000000','0x3e00000000000000',62,
+		'0x83126e98','0x1fbe76c8b',33,
+		'0x83126e978d4fdf3c','0x1fbe76c8b43958106',65,
+		'0xf4240000','0xc0000',20,
+		'0xf424000000000000','0xc000000000000',52,
+		'0x8637bd06','0x7ffde7210be',43,
+		'0x8637bd05af6c69b6','0x7ffde7210be9424e592',75,
+	], 300 => [
+		'0xd5555556','0x2aaaaaaa',30,
+		'0xd555555555555556','0x2aaaaaaaaaaaaaaa',62,
+		'0x9999999a','0x1cccccccc',33,
+		'0x999999999999999a','0x1cccccccccccccccc',65,
+		'0xd0555556','0xaaaaa',20,
+		'0xd055555555555556','0xaaaaaaaaaaaaa',52,
+		'0x9d495183','0x7ffcb923a29',43,
+		'0x9d495182a9930be1','0x7ffcb923a29c779a6b5',75,
+	], 512 => [
+		'0xfa000000','0x7e000000',31,
+		'0xfa00000000000000','0x7e00000000000000',63,
+		'0x83126e98','0xfdf3b645',32,
+		'0x83126e978d4fdf3c','0xfdf3b645a1cac083',64,
+		'0xf4240000','0x1c0000',21,
+		'0xf424000000000000','0x1c000000000000',53,
+		'0x8637bd06','0x3ffef39085f',42,
+		'0x8637bd05af6c69b6','0x3ffef39085f4a1272c9',74,
+	], 1000 => [
+		'0x80000000','0x0',31,
+		'0x8000000000000000','0x0',63,
+		'0x80000000','0x0',31,
+		'0x8000000000000000','0x0',63,
+		'0xfa000000','0x0',22,
+		'0xfa00000000000000','0x0',54,
+		'0x83126e98','0x1ff7ced9168',41,
+		'0x83126e978d4fdf3c','0x1ff7ced916872b020c4',73,
+	], 1024 => [
+		'0xfa000000','0xfe000000',32,
+		'0xfa00000000000000','0xfe00000000000000',64,
+		'0x83126e98','0x7ef9db22',31,
+		'0x83126e978d4fdf3c','0x7ef9db22d0e56041',63,
+		'0xf4240000','0x3c0000',22,
+		'0xf424000000000000','0x3c000000000000',54,
+		'0x8637bd06','0x1fff79c842f',41,
+		'0x8637bd05af6c69b6','0x1fff79c842fa5093964',73,
+	], 1200 => [
+		'0xd5555556','0xd5555555',32,
+		'0xd555555555555556','0xd555555555555555',64,
+		'0x9999999a','0x66666666',31,
+		'0x999999999999999a','0x6666666666666666',63,
+		'0xd0555556','0x2aaaaa',22,
+		'0xd055555555555556','0x2aaaaaaaaaaaaa',54,
+		'0x9d495183','0x1ffcb923a29',41,
+		'0x9d495182a9930be1','0x1ffcb923a29c779a6b5',73,
+	]
+);
+
+$has_bigint = eval 'use Math::BigInt qw(bgcd); 1;';
+
+sub bint($)
+{
+	my($x) = @_;
+	return Math::BigInt->new($x);
+}
+
+#
+# Constants for division by reciprocal multiplication.
+# (bits, numerator, denominator)
+#
+sub fmul($$$)
+{
+	my ($b,$n,$d) = @_;
+
+	$n = bint($n);
+	$d = bint($d);
+
+	return scalar (($n << $b)+$d-bint(1))/$d;
+}
+
+sub fadj($$$)
+{
+	my($b,$n,$d) = @_;
+
+	$n = bint($n);
+	$d = bint($d);
+
+	$d = $d/bgcd($n, $d);
+	return scalar (($d-bint(1)) << $b)/$d;
+}
+
+sub fmuls($$$) {
+	my($b,$n,$d) = @_;
+	my($s,$m);
+	my($thres) = bint(1) << ($b-1);
+
+	$n = bint($n);
+	$d = bint($d);
+
+	for ($s = 0; 1; $s++) {
+		$m = fmul($s,$n,$d);
+		return $s if ($m >= $thres);
+	}
+	return 0;
+}
+
+sub compute_values($) {
+	my($hz) = @_;
+	my @val = ();
+	my $s, $m, $a;
+
+	if (!$has_bigint) {
+		die "$0: HZ == $hz not canned and ".
+		    "Math::BigInt not available\n";
+	}
+
+	# HZ_TO_MSEC_*32
+	$s = fmuls(32, 1000, $hz);
+	$m = fmul($s, 1000, $hz);
+	$a = fadj($s, 1000, $hz);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	# HZ_TO_MSEC_*64
+	$s = fmuls(64, 1000, $hz);
+	$m = fmul($s, 1000, $hz);
+	$a = fadj($s, 1000, $hz);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	# MSEC_TO_HZ_*32
+	$s = fmuls(32, $hz, 1000);
+	$m = fmul($s, $hz, 1000);
+	$a = fadj($s, $hz, 1000);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	# MSEC_TO_HZ_*64
+	$s = fmuls(64, $hz, 1000);
+	$m = fmul($s, $hz, 1000);
+	$a = fadj($s, $hz, 1000);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	# HZ_TO_USEC_*32
+	$s = fmuls(32, 1000000, $hz);
+	$m = fmul($s, 1000000, $hz);
+	$a = fadj($s, 1000000, $hz);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	# HZ_TO_USEC_*64
+	$s = fmuls(64, 1000000, $hz);
+	$m = fmul($s, 1000000, $hz);
+	$a = fadj($s, 1000000, $hz);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	# USEC_TO_HZ_*32
+	$s = fmuls(32, $hz, 1000000);
+	$m = fmul($s, $hz, 1000000);
+	$a = fadj($s, $hz, 1000000);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	# USEC_TO_HZ_*64
+	$s = fmuls(64, $hz, 1000000);
+	$m = fmul($s, $hz, 1000000);
+	$a = fadj($s, $hz, 1000000);
+	push(@val, $m->as_hex(), $a->as_hex(), $s);
+
+	return @val;
+}
+
+sub output($@)
+{
+	my($hz, @val) = @_;
+	my $pfx, $bit, $suf, $s, $m, $a;
+
+	print "/* Automatically generated by kernel/timeconst.pl */\n";
+	print "/* Conversion constants for HZ == $hz */\n";
+	print "\n";
+	print "#ifndef KERNEL_TIMECONST_H\n";
+	print "#define KERNEL_TIMECONST_H\n";
+	print "\n";
+
+	print "#include <linux/param.h>\n";
+
+	print "\n";
+	print "#if HZ != $hz\n";
+	print "#error \"kernel/timeconst.h has the wrong HZ value!\"\n";
+	print "#endif\n";
+	print "\n";
+
+	foreach $pfx ('HZ_TO_MSEC','MSEC_TO_HZ',
+		      'USEC_TO_HZ','HZ_TO_USEC') {
+		foreach $bit (32, 64) {
+			foreach $suf ('MUL', 'ADJ', 'SHR') {
+				printf "#define %-23s %s\n",
+				"${pfx}_$suf$bit", shift(@val);
+			}
+		}
+	}
+
+	print "\n";
+	print "#endif /* KERNEL_TIMECONST_H */\n";
+}
+
+($hz) = @ARGV;
+
+# Use this to generate the %canned_values structure
+if ($hz eq '--can') {
+	shift(@ARGV);
+	@hzlist = sort {$a <=> $b} (@ARGV);
+
+	print "# Precomputed values for systems without Math::BigInt\n";
+	print "# Generated by:\n";
+	print "# timeconst.pl --can ", join(' ', @hzlist), "\n";
+	print "\%canned_values = (\n";
+	my $pf = "\t";
+	foreach $hz (@hzlist) {
+		my @values = compute_values($hz);
+		print "$pf$hz => [\n";
+		while (scalar(@values)) {
+			my $m = shift(@values);
+			my $a = shift(@values);
+			my $s = shift(@values);
+			print "\t\t\'",$m,"\',\'",$a,"\',",$s,",\n";
+		}
+		print "\t]";
+		$pf = ', ';
+	}
+	print "\n);\n";
+} else {
+	$hz += 0;			# Force to number
+	if ($hz < 1) {
+		die "Usage: $0 HZ\n";
+	}
+
+	@val = @{$canned_values{$hz}};
+	if (!defined(@val)) {
+		@val = compute_values($hz);
+	}
+	output($hz, @val);
+}
+exit 0;
_

Patches currently in -mm which might be from hpa@zytor.com are

git-kvm.patch
git-sh.patch
git-x86.patch
drivers-char-tty_ioc-remove-pty_sem.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
avoid-overflows-in-kernel-timec.patch
coding-style-cleanups-for-drivers-md-mktablesc.patch
md-raid6-fix-mktablec.patch
md-raid6-clean-up-the-style-of-raid6test-testc.patch
unexport-asm-userh-and-linux-userh.patch
unexport-asm-pageh.patch
sanitize-the-type-of-struct-useru_ar0.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
