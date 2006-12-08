From: akpm@osdl.org
Subject: - clocksource-add-generic-sched_clock.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:46 -0800
Message-ID: <200612081105.kB8B5kAU018669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50223 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938042AbWLHLUf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:20:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     clocksource: add generic sched_clock()
has been removed from the -mm tree.  Its filename was
     clocksource-add-generic-sched_clock.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: clocksource: add generic sched_clock()
From: Daniel Walker <dwalker@mvista.com>

Adds a generic sched_clock, along with a boot time override for the scheduler
clocksource (sched_clocksource).  Hopefully the config option would eventually
be removed.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig      |    4 ++
 arch/i386/kernel/tsc.c |   61 --------------------------------------
 kernel/sched.c         |   62 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 66 insertions(+), 61 deletions(-)

diff -puN arch/i386/Kconfig~clocksource-add-generic-sched_clock arch/i386/Kconfig
--- a/arch/i386/Kconfig~clocksource-add-generic-sched_clock
+++ a/arch/i386/Kconfig
@@ -22,6 +22,10 @@ config GENERIC_CLOCKEVENTS
 	bool
 	default y
 
+config GENERIC_SCHED_CLOCK
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
diff -puN arch/i386/kernel/tsc.c~clocksource-add-generic-sched_clock arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~clocksource-add-generic-sched_clock
+++ a/arch/i386/kernel/tsc.c
@@ -59,65 +59,6 @@ static inline int check_tsc_unstable(voi
 	return tsc_unstable;
 }
 
-/* Accellerators for sched_clock()
- * convert from cycles(64bits) => nanoseconds (64bits)
- *  basic equation:
- *		ns = cycles / (freq / ns_per_sec)
- *		ns = cycles * (ns_per_sec / freq)
- *		ns = cycles * (10^9 / (cpu_khz * 10^3))
- *		ns = cycles * (10^6 / cpu_khz)
- *
- *	Then we use scaling math (suggested by george@mvista.com) to get:
- *		ns = cycles * (10^6 * SC / cpu_khz) / SC
- *		ns = cycles * cyc2ns_scale / SC
- *
- *	And since SC is a constant power of two, we can convert the div
- *  into a shift.
- *
- *  We can use khz divisor instead of mhz to keep a better percision, since
- *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
- *  (mathieu.desnoyers@polymtl.ca)
- *
- *			-johnstul@us.ibm.com "math is hard, lets go shopping!"
- */
-static unsigned long cyc2ns_scale __read_mostly;
-
-#define CYC2NS_SCALE_FACTOR 10 /* 2^10, carefully chosen */
-
-static inline void set_cyc2ns_scale(unsigned long cpu_khz)
-{
-	cyc2ns_scale = (1000000 << CYC2NS_SCALE_FACTOR)/cpu_khz;
-}
-
-static inline unsigned long long cycles_2_ns(unsigned long long cyc)
-{
-	return (cyc * cyc2ns_scale) >> CYC2NS_SCALE_FACTOR;
-}
-
-/*
- * Scheduler clock - returns current time in nanosec units.
- */
-unsigned long long sched_clock(void)
-{
-	unsigned long long this_offset;
-
-	/*
-	 * in the NUMA case we dont use the TSC as they are not
-	 * synchronized across all CPUs.
-	 */
-#ifndef CONFIG_NUMA
-	if (!cpu_khz || check_tsc_unstable())
-#endif
-		/* no locking but a rare wrong value is not a big deal */
-		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
-
-	/* read the Time Stamp Counter: */
-	rdtscll(this_offset);
-
-	/* return the value in ns */
-	return cycles_2_ns(this_offset);
-}
-
 static unsigned long calculate_cpu_khz(void)
 {
 	unsigned long long start, end;
@@ -216,7 +157,6 @@ void __init tsc_init(void)
 				(unsigned long)cpu_khz / 1000,
 				(unsigned long)cpu_khz % 1000);
 
-	set_cyc2ns_scale(cpu_khz);
 	use_tsc_delay();
 }
 
@@ -292,7 +232,6 @@ time_cpufreq_notifier(struct notifier_bl
 			if (!(freq->flags & CPUFREQ_CONST_LOOPS)) {
 				tsc_khz = cpu_khz;
 				tsc_update_khz();
-				set_cyc2ns_scale(cpu_khz);
 				/*
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
diff -puN kernel/sched.c~clocksource-add-generic-sched_clock kernel/sched.c
--- a/kernel/sched.c~clocksource-add-generic-sched_clock
+++ a/kernel/sched.c
@@ -16,6 +16,7 @@
  *		by Davide Libenzi, preemptible kernel bits by Robert Love.
  *  2003-09-03	Interactivity tuning by Con Kolivas.
  *  2004-04-02	Scheduler domains code by Nick Piggin
+ *  2006-08-03	Generic sched_clock() implementation by Daniel Walker
  */
 
 #include <linux/mm.h>
@@ -53,6 +54,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/kprobes.h>
 #include <linux/delayacct.h>
+#include <linux/clocksource.h>
 #include <asm/tlb.h>
 
 #include <asm/unistd.h>
@@ -6909,6 +6911,66 @@ int in_sched_functions(unsigned long add
 		&& addr < (unsigned long)__sched_text_end);
 }
 
+#ifdef CONFIG_GENERIC_SCHED_CLOCK
+static struct clocksource *sched_clocksource = &clocksource_jiffies;
+static char __initdata sched_clock_override[32];
+
+unsigned long long sched_clock(void)
+{
+	return cyc2ns(sched_clocksource, clocksource_read(sched_clocksource));
+}
+
+static int __init boot_override_sched_clocksource(char* str)
+{
+	if (str)
+		strlcpy(sched_clock_override, str,
+			sizeof(sched_clock_override));
+
+	return 1;
+}
+__setup("sched_clocksource=", boot_override_sched_clocksource);
+
+static int
+sched_clock_callback(struct notifier_block *nb, unsigned long op, void *c)
+{
+	/*
+	 * If our clock just became unstable switch to the safe,
+	 * slow, fast jiffies clock.
+	 *
+	 * XXX : We could just switch to the next best clock.
+	 */
+	if (op == CLOCKSOURCE_NOTIFY_RATING && sched_clocksource == c)
+		sched_clocksource = &clocksource_jiffies;
+	return 0;
+}
+
+static struct notifier_block sched_clock_nb = {
+	.notifier_call = sched_clock_callback,
+};
+
+static int __init sched_clock_init(void)
+{
+	clocksource_notifier_register(&sched_clock_nb);
+
+	if (*sched_clock_override != 0) {
+		sched_clocksource = clocksource_get_clock(sched_clock_override);
+		if (unlikely(sched_clocksource == NULL)) {
+			sched_clocksource = clocksource_get_best_clock();
+			printk(KERN_ERR "Warning: "
+			       "Invalid scheduler clock override.\n");
+			return 1;
+		}
+
+		printk(KERN_INFO "Scheduler: %s clocksource has been "
+		       "installed.\n", sched_clocksource->name);
+	} else
+		sched_clocksource = clocksource_get_best_clock();
+
+	return 0;
+}
+__initcall(sched_clock_init);
+#endif /* CONFIG_GENERIC_SCHED_CLOCK */
+
 void __init sched_init(void)
 {
 	int i, j, k;
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-add-usage-of-config_sysfs.patch
clocksource-small-cleanup-2.patch
clocksource-small-cleanup-2-fix.patch
clocksource-small-acpi_pm-cleanup.patch
profile-likely-unlikely-macros.patch
profile_likely-export-do_check_likely.patch

