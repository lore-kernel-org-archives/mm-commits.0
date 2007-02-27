From: akpm@linux-foundation.org
Subject: + log-reason-why-tsc-was-marked-unstable.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:52:20 -0800
Message-ID: <200702272052.l1RKqOvs028157@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51423 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593AbXB0Uws (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:52:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Log reason why TSC was marked unstable
has been added to the -mm tree.  Its filename is
     log-reason-why-tsc-was-marked-unstable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Log reason why TSC was marked unstable
From: john stultz <johnstul@us.ibm.com>

Change mark_tsc_unstable() so it takes a string argument, which holds the
reason the TSC was marked unstable.

This is then displayed the first time mark_tsc_unstable is called.

This should help us better debug why the TSC was marked unstable on certain
systems and allow us to make sure we're not being overly paranoid when
throwing out this troublesome clocksource.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c                      |    5 +++--
 arch/x86_64/kernel/time.c                   |    2 +-
 arch/x86_64/kernel/tsc.c                    |    5 +++--
 arch/x86_64/kernel/tsc_sync.c               |    2 +-
 drivers/acpi/processor_idle.c               |    4 ++--
 include/asm-i386/mach-summit/mach_mpparse.h |    4 ++--
 include/asm-x86_64/timex.h                  |    2 +-
 include/asm-x86_64/tsc.h                    |    2 +-
 8 files changed, 14 insertions(+), 12 deletions(-)

diff -puN arch/i386/kernel/tsc.c~log-reason-why-tsc-was-marked-unstable arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~log-reason-why-tsc-was-marked-unstable
+++ a/arch/i386/kernel/tsc.c
@@ -262,7 +262,7 @@ time_cpufreq_notifier(struct notifier_bl
 				 * TSC based sched_clock turns
 				 * to junk w/ cpufreq
 				 */
-				mark_tsc_unstable();
+				mark_tsc_unstable("cpufreq changes");
 			}
 		}
 	}
@@ -310,10 +310,11 @@ static struct clocksource clocksource_ts
 				  CLOCK_SOURCE_MUST_VERIFY,
 };
 
-void mark_tsc_unstable(void)
+void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		printk("Marking TSC unstable due to: %s.\n", reason);
 		/* Can be called before registration */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
diff -puN arch/x86_64/kernel/time.c~log-reason-why-tsc-was-marked-unstable arch/x86_64/kernel/time.c
--- a/arch/x86_64/kernel/time.c~log-reason-why-tsc-was-marked-unstable
+++ a/arch/x86_64/kernel/time.c
@@ -348,7 +348,7 @@ void __init time_init(void)
 	}
 
 	if (unsynchronized_tsc())
-		mark_tsc_unstable();
+		mark_tsc_unstable("TSCs unsynchronized");
 
 	if (cpu_has(&boot_cpu_data, X86_FEATURE_RDTSCP))
 		vgetcpu_mode = VGETCPU_RDTSCP;
diff -puN arch/x86_64/kernel/tsc.c~log-reason-why-tsc-was-marked-unstable arch/x86_64/kernel/tsc.c
--- a/arch/x86_64/kernel/tsc.c~log-reason-why-tsc-was-marked-unstable
+++ a/arch/x86_64/kernel/tsc.c
@@ -109,7 +109,7 @@ static int time_cpufreq_notifier(struct 
 
 		cpu_khz = cpufreq_scale(cpu_khz_ref, ref_freq, freq->new);
 		if (!(freq->flags & CPUFREQ_CONST_LOOPS))
-			mark_tsc_unstable();
+			mark_tsc_unstable("cpufreq changes");
 	}
 
 	set_cyc2ns_scale(cpu_khz_ref);
@@ -197,10 +197,11 @@ static struct clocksource clocksource_ts
 	.vread			= vread_tsc,
 };
 
-void mark_tsc_unstable(void)
+void mark_tsc_unstable(char *reason)
 {
 	if (!tsc_unstable) {
 		tsc_unstable = 1;
+		printk("Marking TSC unstable due to %s\n", reason);
 		/* Change only the rating, when not registered */
 		if (clocksource_tsc.mult)
 			clocksource_change_rating(&clocksource_tsc, 0);
diff -puN arch/x86_64/kernel/tsc_sync.c~log-reason-why-tsc-was-marked-unstable arch/x86_64/kernel/tsc_sync.c
--- a/arch/x86_64/kernel/tsc_sync.c~log-reason-why-tsc-was-marked-unstable
+++ a/arch/x86_64/kernel/tsc_sync.c
@@ -138,7 +138,7 @@ void __cpuinit check_tsc_sync_source(int
 		printk("\n");
 		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
 				    " turning off TSC clock.\n", max_warp);
-		mark_tsc_unstable();
+		mark_tsc_unstable("check_tsc_sync_source failed");
 		nr_warps = 0;
 		max_warp = 0;
 		last_tsc = 0;
diff -puN drivers/acpi/processor_idle.c~log-reason-why-tsc-was-marked-unstable drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~log-reason-why-tsc-was-marked-unstable
+++ a/drivers/acpi/processor_idle.c
@@ -482,7 +482,7 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C2, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable("possible TSC halt in C2");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
@@ -524,7 +524,7 @@ static void acpi_processor_idle(void)
 
 #ifdef CONFIG_GENERIC_TIME
 		/* TSC halts in C3, so notify users */
-		mark_tsc_unstable();
+		mark_tsc_unstable("TSC halts in C3");
 #endif
 		/* Re-enable interrupts */
 		local_irq_enable();
diff -puN include/asm-i386/mach-summit/mach_mpparse.h~log-reason-why-tsc-was-marked-unstable include/asm-i386/mach-summit/mach_mpparse.h
--- a/include/asm-i386/mach-summit/mach_mpparse.h~log-reason-why-tsc-was-marked-unstable
+++ a/include/asm-i386/mach-summit/mach_mpparse.h
@@ -30,7 +30,7 @@ static inline int mps_oem_check(struct m
 			(!strncmp(productid, "VIGIL SMP", 9) 
 			 || !strncmp(productid, "EXA", 3)
 			 || !strncmp(productid, "RUTHLESS SMP", 12))){
-		mark_tsc_unstable();
+		mark_tsc_unstable("Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
@@ -44,7 +44,7 @@ static inline int acpi_madt_oem_check(ch
 	if (!strncmp(oem_id, "IBM", 3) &&
 	    (!strncmp(oem_table_id, "SERVIGIL", 8)
 	     || !strncmp(oem_table_id, "EXA", 3))){
-		mark_tsc_unstable();
+		mark_tsc_unstable("Summit based system");
 		use_cyclone = 1; /*enable cyclone-timer*/
 		setup_summit();
 		return 1;
diff -puN include/asm-x86_64/timex.h~log-reason-why-tsc-was-marked-unstable include/asm-x86_64/timex.h
--- a/include/asm-x86_64/timex.h~log-reason-why-tsc-was-marked-unstable
+++ a/include/asm-x86_64/timex.h
@@ -27,6 +27,6 @@ extern int read_current_timer(unsigned l
 #define NS_SCALE        10 /* 2^10, carefully chosen */
 #define US_SCALE        32 /* 2^32, arbitralrily chosen */
 
-extern void mark_tsc_unstable(void);
+extern void mark_tsc_unstable(char*);
 extern void set_cyc2ns_scale(unsigned long khz);
 #endif
diff -puN include/asm-x86_64/tsc.h~log-reason-why-tsc-was-marked-unstable include/asm-x86_64/tsc.h
--- a/include/asm-x86_64/tsc.h~log-reason-why-tsc-was-marked-unstable
+++ a/include/asm-x86_64/tsc.h
@@ -53,7 +53,7 @@ static __always_inline cycles_t get_cycl
 }
 
 extern void tsc_init(void);
-extern void mark_tsc_unstable(void);
+extern void mark_tsc_unstable(char*);
 extern int unsynchronized_tsc(void);
 
 /*
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

log-reason-why-tsc-was-marked-unstable.patch
clocksource-init-adjustments-fix-bug-7426.patch
convert-h8-300-to-generic-timekeeping.patch
v850-generic-timekeeping-conversion.patch
profile-likely-unlikely-macros-x86_64-fix.patch
