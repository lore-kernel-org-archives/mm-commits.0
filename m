From: akpm@osdl.org
Subject: + consolidate-default-sched_clock.patch added to -mm tree
Date: Wed, 27 Dec 2006 00:51:23 -0800
Message-ID: <200612270851.kBR8pNUo006091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:41316 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbWL0Ivf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 03:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, mingo@elte.hu


The patch titled
     Consolidate default sched_clock()
has been added to the -mm tree.  Its filename is
     consolidate-default-sched_clock.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Consolidate default sched_clock()
From: Alexey Dobriyan <adobriyan@openvz.org>

Use attribute(weak).

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/alpha/kernel/time.c     |   11 -----------
 arch/arm/kernel/time.c       |   10 ----------
 arch/arm26/kernel/time.c     |    8 --------
 arch/avr32/kernel/time.c     |    9 ---------
 arch/cris/kernel/time.c      |    8 --------
 arch/h8300/kernel/time.c     |    6 ------
 arch/m32r/kernel/time.c      |    8 --------
 arch/m68k/kernel/time.c      |    9 ---------
 arch/m68knommu/kernel/time.c |    9 ---------
 arch/mips/kernel/time.c      |    5 -----
 arch/parisc/kernel/time.c    |   11 -----------
 arch/sh/kernel/time.c        |    8 --------
 arch/sh64/kernel/time.c      |    9 ---------
 arch/sparc/kernel/time.c     |    9 ---------
 arch/v850/kernel/time.c      |    8 --------
 arch/xtensa/kernel/time.c    |    9 ---------
 kernel/sched.c               |   10 ++++++++++
 17 files changed, 10 insertions(+), 137 deletions(-)

diff -puN arch/alpha/kernel/time.c~consolidate-default-sched_clock arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/alpha/kernel/time.c
@@ -91,17 +91,6 @@ static inline __u32 rpcc(void)
 }
 
 /*
- * Scheduler clock - returns current time in nanosec units.
- *
- * Copied from ARM code for expediency... ;-}
- */
-unsigned long long sched_clock(void)
-{
-        return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
-
-/*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
diff -puN arch/arm26/kernel/time.c~consolidate-default-sched_clock arch/arm26/kernel/time.c
--- a/arch/arm26/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/arm26/kernel/time.c
@@ -89,14 +89,6 @@ static unsigned long gettimeoffset(void)
         return (offset + LATCH/2) / LATCH;
 }
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 static unsigned long next_rtc_update;
 
 /*
diff -puN arch/arm/kernel/time.c~consolidate-default-sched_clock arch/arm/kernel/time.c
--- a/arch/arm/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/arm/kernel/time.c
@@ -75,16 +75,6 @@ static unsigned long dummy_gettimeoffset
 }
 #endif
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- * This is the default implementation.  Sub-architecture
- * implementations can override this.
- */
-unsigned long long __attribute__((weak)) sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 static unsigned long next_rtc_update;
 
 /*
diff -puN arch/avr32/kernel/time.c~consolidate-default-sched_clock arch/avr32/kernel/time.c
--- a/arch/avr32/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/avr32/kernel/time.c
@@ -110,15 +110,6 @@ static void avr32_hpt_init(unsigned int 
 }
 
 /*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	/* There must be better ways...? */
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
-/*
  * local_timer_interrupt() does profiling and process accounting on a
  * per-CPU basis.
  *
diff -puN arch/cris/kernel/time.c~consolidate-default-sched_clock arch/cris/kernel/time.c
--- a/arch/cris/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/cris/kernel/time.c
@@ -217,14 +217,6 @@ cris_do_profile(struct pt_regs* regs)
 #endif
 }
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 static int
 __init init_udelay(void)
 {
diff -puN arch/h8300/kernel/time.c~consolidate-default-sched_clock arch/h8300/kernel/time.c
--- a/arch/h8300/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/h8300/kernel/time.c
@@ -118,9 +118,3 @@ int do_settimeofday(struct timespec *tv)
 }
 
 EXPORT_SYMBOL(do_settimeofday);
-
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-
-}
diff -puN arch/m32r/kernel/time.c~consolidate-default-sched_clock arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/m32r/kernel/time.c
@@ -286,11 +286,3 @@ void __init time_init(void)
 #error no chip configuration
 #endif
 }
-
-/*
- *  Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
diff -puN arch/m68k/kernel/time.c~consolidate-default-sched_clock arch/m68k/kernel/time.c
--- a/arch/m68k/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/m68k/kernel/time.c
@@ -159,12 +159,3 @@ int do_settimeofday(struct timespec *tv)
 }
 
 EXPORT_SYMBOL(do_settimeofday);
-
-/*
- * Scheduler clock - returns current time in ns units.
- */
-unsigned long long sched_clock(void)
-{
-       return (unsigned long long)jiffies*(1000000000/HZ);
-}
-
diff -puN arch/m68knommu/kernel/time.c~consolidate-default-sched_clock arch/m68knommu/kernel/time.c
--- a/arch/m68knommu/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/m68knommu/kernel/time.c
@@ -173,13 +173,4 @@ int do_settimeofday(struct timespec *tv)
 	clock_was_set();
 	return 0;
 }
-
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 EXPORT_SYMBOL(do_settimeofday);
diff -puN arch/mips/kernel/time.c~consolidate-default-sched_clock arch/mips/kernel/time.c
--- a/arch/mips/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/mips/kernel/time.c
@@ -457,8 +457,3 @@ EXPORT_SYMBOL(rtc_lock);
 EXPORT_SYMBOL(to_tm);
 EXPORT_SYMBOL(rtc_mips_set_time);
 EXPORT_SYMBOL(rtc_mips_get_time);
-
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies*(1000000000/HZ);
-}
diff -puN arch/parisc/kernel/time.c~consolidate-default-sched_clock arch/parisc/kernel/time.c
--- a/arch/parisc/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/parisc/kernel/time.c
@@ -288,17 +288,6 @@ do_settimeofday (struct timespec *tv)
 }
 EXPORT_SYMBOL(do_settimeofday);
 
-/*
- * XXX: We can do better than this.
- * Returns nanoseconds
- */
-
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
-
 void __init start_cpu_itimer(void)
 {
 	unsigned int cpu = smp_processor_id();
diff -puN arch/sh64/kernel/time.c~consolidate-default-sched_clock arch/sh64/kernel/time.c
--- a/arch/sh64/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/sh64/kernel/time.c
@@ -579,12 +579,3 @@ void enter_deep_standby(void)
 	asm __volatile__ ("nop");
 	panic("Unexpected wakeup!\n");
 }
-
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
diff -puN arch/sh/kernel/time.c~consolidate-default-sched_clock arch/sh/kernel/time.c
--- a/arch/sh/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/sh/kernel/time.c
@@ -41,14 +41,6 @@ static int null_rtc_set_time(const time_
 void (*rtc_sh_get_time)(struct timespec *) = null_rtc_get_time;
 int (*rtc_sh_set_time)(const time_t) = null_rtc_set_time;
 
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long __attribute__ ((weak)) sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 #ifndef CONFIG_GENERIC_TIME
 void do_gettimeofday(struct timeval *tv)
 {
diff -puN arch/sparc/kernel/time.c~consolidate-default-sched_clock arch/sparc/kernel/time.c
--- a/arch/sparc/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/sparc/kernel/time.c
@@ -436,15 +436,6 @@ static inline unsigned long do_gettimeof
 	return (*master_l10_counter >> 10) & 0x1fffff;
 }
 
-/*
- * Returns nanoseconds
- * XXX This is a suboptimal implementation.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 /* Ok, my cute asm atomicity trick doesn't work anymore.
  * There are just too many variables that need to be protected
  * now (both members of xtime, et al.)
diff -puN arch/v850/kernel/time.c~consolidate-default-sched_clock arch/v850/kernel/time.c
--- a/arch/v850/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/v850/kernel/time.c
@@ -28,14 +28,6 @@
 #define TICK_SIZE	(tick_nsec / 1000)
 
 /*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
-/*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
diff -puN arch/xtensa/kernel/time.c~consolidate-default-sched_clock arch/xtensa/kernel/time.c
--- a/arch/xtensa/kernel/time.c~consolidate-default-sched_clock
+++ a/arch/xtensa/kernel/time.c
@@ -38,15 +38,6 @@ unsigned long ccount_nsec;		/* nsec per 
 unsigned int last_ccount_stamp;
 static long last_rtc_update = 0;
 
-/*
- * Scheduler clock - returns current tim in nanosec units.
- */
-
-unsigned long long sched_clock(void)
-{
-	return (unsigned long long)jiffies * (1000000000 / HZ);
-}
-
 static irqreturn_t timer_interrupt(int irq, void *dev_id);
 static struct irqaction timer_irqaction = {
 	.handler =	timer_interrupt,
diff -puN kernel/sched.c~consolidate-default-sched_clock kernel/sched.c
--- a/kernel/sched.c~consolidate-default-sched_clock
+++ a/kernel/sched.c
@@ -57,6 +57,16 @@
 #include <asm/unistd.h>
 
 /*
+ * Scheduler clock - returns current time in nanosec units.
+ * This is default implementation.
+ * Architectures and sub-architectures can override this.
+ */
+unsigned long long __attribute__((weak)) sched_clock(void)
+{
+	return (unsigned long long)jiffies * (1000000000 / HZ);
+}
+
+/*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
  * and back.
_

Patches currently in -mm which might be from adobriyan@openvz.org are

sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch

