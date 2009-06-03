From: akpm@linux-foundation.org
Subject: [alternative-merged] time-move-calc_load-call-out-from-xtime_lock-protection.patch removed from -mm tree
Date: Wed, 03 Jun 2009 12:56:15 -0700
Message-ID: <200906031956.n53JuG1V029244@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48144 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbZFCT4c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jun 2009 15:56:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sivanich@sgi.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: move calc_load call out from xtime_lock protection
has been removed from the -mm tree.  Its filename was
     time-move-calc_load-call-out-from-xtime_lock-protection.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: time: move calc_load call out from xtime_lock protection
From: Dimitri Sivanich <sivanich@sgi.com>

The xtime_lock is being held for long periods on larger systems due to an
extensive amount of time being spent in calc_load(), specifically here:

  do_timer->update_times->calc_load->count_active_tasks->nr_active()

On a 64 cpu system I've seen this take approximately 55 usec.  Presumably
it would be worse on larger systems.  This causes other cpus to be held
off in places such as scheduler_tick->sched_clock_tick waiting for the
xtime_lock to be released.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/time.c                   |    1 
 arch/arm/kernel/time.c                     |    1 
 arch/arm/mach-clps711x/include/mach/time.h |    2 +
 arch/arm/mach-l7200/include/mach/time.h    |    2 +
 arch/blackfin/kernel/time.c                |    2 +
 arch/cris/arch-v10/kernel/time.c           |    2 +
 arch/cris/arch-v32/kernel/time.c           |    1 
 arch/frv/kernel/time.c                     |    1 
 arch/h8300/kernel/time.c                   |    1 
 arch/ia64/kernel/time.c                    |    1 
 arch/ia64/xen/time.c                       |    2 +
 arch/m32r/kernel/time.c                    |    1 
 arch/m68k/kernel/time.c                    |    1 
 arch/m68k/sun3/sun3ints.c                  |    1 
 arch/m68knommu/kernel/time.c               |    2 +
 arch/mn10300/kernel/time.c                 |    1 
 arch/parisc/kernel/time.c                  |    1 
 arch/sparc/kernel/pcic.c                   |    2 +
 arch/sparc/kernel/time_32.c                |    1 
 arch/xtensa/kernel/time.c                  |    2 +
 include/linux/timer.h                      |    5 ++++
 kernel/time/tick-common.c                  |    1 
 kernel/time/tick-sched.c                   |    2 +
 kernel/timer.c                             |   22 ++++++++++++-------
 24 files changed, 51 insertions(+), 7 deletions(-)

diff -puN arch/alpha/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/alpha/kernel/time.c
@@ -137,6 +137,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 
 	write_sequnlock(&xtime_lock);
+	calc_load(nticks);
 
 #ifndef CONFIG_SMP
 	while (nticks--)
diff -puN arch/arm/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/arm/kernel/time.c
--- a/arch/arm/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/arm/kernel/time.c
@@ -339,6 +339,7 @@ void timer_tick(void)
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff -puN arch/arm/mach-clps711x/include/mach/time.h~time-move-calc_load-call-out-from-xtime_lock-protection arch/arm/mach-clps711x/include/mach/time.h
--- a/arch/arm/mach-clps711x/include/mach/time.h~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/arm/mach-clps711x/include/mach/time.h
@@ -17,6 +17,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/timer.h>
 #include <asm/leds.h>
 #include <asm/hardware/clps7111.h>
 
@@ -31,6 +32,7 @@ p720t_timer_interrupt(int irq, void *dev
 	struct pt_regs *regs = get_irq_regs();
 	do_leds();
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
diff -puN arch/arm/mach-l7200/include/mach/time.h~time-move-calc_load-call-out-from-xtime_lock-protection arch/arm/mach-l7200/include/mach/time.h
--- a/arch/arm/mach-l7200/include/mach/time.h~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/arm/mach-l7200/include/mach/time.h
@@ -11,6 +11,7 @@
 #ifndef _ASM_ARCH_TIME_H
 #define _ASM_ARCH_TIME_H
 
+#include <linux/timer.h>
 #include <mach/irqs.h>
 
 /*
@@ -47,6 +48,7 @@ timer_interrupt(int irq, void *dev_id)
 {
 	struct pt_regs *regs = get_irq_regs();
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(regs));
 #endif
diff -puN arch/blackfin/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/blackfin/kernel/time.c
--- a/arch/blackfin/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/blackfin/kernel/time.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/profile.h>
 #include <linux/interrupt.h>
+#include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/irq.h>
 #include <linux/delay.h>
@@ -164,6 +165,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	}
 #endif
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifdef CONFIG_IPIPE
 	update_root_process_times(get_irq_regs());
diff -puN arch/cris/arch-v10/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/cris/arch-v10/kernel/time.c
@@ -231,6 +231,8 @@ timer_interrupt(int irq, void *dev_id)
 	/* call the real timer interrupt handler */
 
 	do_timer(1);
+
+	calc_load(1);
 	
         cris_do_profile(regs); /* Save profiling information */
 
diff -puN arch/cris/arch-v32/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/cris/arch-v32/kernel/time.c
--- a/arch/cris/arch-v32/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/cris/arch-v32/kernel/time.c
@@ -240,6 +240,7 @@ timer_interrupt(int irq, void *dev_id)
 	/* Call the real timer interrupt handler */
 	do_timer(1);
 
+	calc_load(1);
 	/*
 	 * If we have an externally synchronized Linux clock, then update
 	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
diff -puN arch/frv/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/frv/kernel/time.c
--- a/arch/frv/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/frv/kernel/time.c
@@ -97,6 +97,7 @@ static irqreturn_t timer_interrupt(int i
 #endif /* CONFIG_HEARTBEAT */
 
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 	update_process_times(user_mode(get_irq_regs()));
 
diff -puN arch/h8300/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/h8300/kernel/time.c
--- a/arch/h8300/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/h8300/kernel/time.c
@@ -38,6 +38,7 @@ void h8300_timer_tick(void)
 	write_seqlock(&xtime_lock);
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff -puN arch/ia64/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/ia64/kernel/time.c
@@ -201,6 +201,7 @@ timer_interrupt (int irq, void *dev_id)
 			do_timer(1);
 			local_cpu_data->itm_next = new_itm;
 			write_sequnlock(&xtime_lock);
+			calc_load(1);
 		} else
 			local_cpu_data->itm_next = new_itm;
 
diff -puN arch/ia64/xen/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/ia64/xen/time.c
--- a/arch/ia64/xen/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/ia64/xen/time.c
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/kernel_stat.h>
 #include <linux/posix-timers.h>
+#include <linux/timer.h>
 #include <linux/irq.h>
 #include <linux/clocksource.h>
 
@@ -145,6 +146,7 @@ consider_steal_time(unsigned long new_it
 			do_timer(stolen + blocked);
 			local_cpu_data->itm_next = delta_itm + new_itm;
 			write_sequnlock(&xtime_lock);
+			calc_load(stolen + blocked);
 		} else {
 			local_cpu_data->itm_next = delta_itm + new_itm;
 		}
diff -puN arch/m32r/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/m32r/kernel/time.c
--- a/arch/m32r/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/m32r/kernel/time.c
@@ -193,6 +193,7 @@ static irqreturn_t timer_interrupt(int i
 	profile_tick(CPU_PROFILING);
 #endif
 	do_timer(1);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff -puN arch/m68k/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/m68k/kernel/time.c
--- a/arch/m68k/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/m68k/kernel/time.c
@@ -42,6 +42,7 @@ static inline int set_rtc_mmss(unsigned 
 static irqreturn_t timer_interrupt(int irq, void *dummy)
 {
 	do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff -puN arch/m68k/sun3/sun3ints.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/m68k/sun3/sun3ints.c
--- a/arch/m68k/sun3/sun3ints.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/m68k/sun3/sun3ints.c
@@ -67,6 +67,7 @@ static irqreturn_t sun3_int5(int irq, vo
 	intersil_clear();
 #endif
         do_timer(1);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff -puN arch/m68knommu/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/m68knommu/kernel/time.c
--- a/arch/m68knommu/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/m68knommu/kernel/time.c
@@ -50,6 +50,8 @@ irqreturn_t arch_timer_interrupt(int irq
 
 	write_sequnlock(&xtime_lock);
 
+	calc_load(1);
+
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff -puN arch/mn10300/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/mn10300/kernel/time.c
--- a/arch/mn10300/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/mn10300/kernel/time.c
@@ -111,6 +111,7 @@ static irqreturn_t timer_interrupt(int i
 		/* advance the kernel's time tracking system */
 		profile_tick(CPU_PROFILING);
 		do_timer(1);
+		calc_load(1);
 		check_rtc_time();
 	}
 
diff -puN arch/parisc/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/parisc/kernel/time.c
--- a/arch/parisc/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/parisc/kernel/time.c
@@ -148,6 +148,7 @@ irqreturn_t __irq_entry timer_interrupt(
 		write_seqlock(&xtime_lock);
 		do_timer(ticks_elapsed);
 		write_sequnlock(&xtime_lock);
+		calc_load(ticks_elapsed);
 	}
 
 	return IRQ_HANDLED;
diff -puN arch/sparc/kernel/pcic.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/sparc/kernel/pcic.c
--- a/arch/sparc/kernel/pcic.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/sparc/kernel/pcic.c
@@ -12,6 +12,7 @@
 
 #include <linux/kernel.h>
 #include <linux/types.h>
+#include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
@@ -707,6 +708,7 @@ static irqreturn_t pcic_timer_handler (i
 	pcic_clear_clock_irq();
 	do_timer(1);
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff -puN arch/sparc/kernel/time_32.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/sparc/kernel/time_32.c
--- a/arch/sparc/kernel/time_32.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/sparc/kernel/time_32.c
@@ -110,6 +110,7 @@ static irqreturn_t timer_interrupt(int d
 	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
 	}
 	write_sequnlock(&xtime_lock);
+	calc_load(1);
 
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
diff -puN arch/xtensa/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection arch/xtensa/kernel/time.c
--- a/arch/xtensa/kernel/time.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/arch/xtensa/kernel/time.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/timer.h>
 #include <linux/time.h>
 #include <linux/clocksource.h>
 #include <linux/interrupt.h>
@@ -111,6 +112,7 @@ again:
 		set_linux_timer(next);
 
 		write_sequnlock(&xtime_lock);
+		calc_load(1);
 	}
 
 	/* Allow platform to do something useful (Wdog). */
diff -puN include/linux/timer.h~time-move-calc_load-call-out-from-xtime_lock-protection include/linux/timer.h
--- a/include/linux/timer.h~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/include/linux/timer.h
@@ -186,6 +186,11 @@ extern unsigned long next_timer_interrup
 extern unsigned long get_next_timer_interrupt(unsigned long now);
 
 /*
+ * Calculate load averages.
+ */
+extern void calc_load(unsigned long);
+
+/*
  * Timer-statistics info:
  */
 #ifdef CONFIG_TIMER_STATS
diff -puN kernel/time/tick-common.c~time-move-calc_load-call-out-from-xtime_lock-protection kernel/time/tick-common.c
--- a/kernel/time/tick-common.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/kernel/time/tick-common.c
@@ -67,6 +67,7 @@ static void tick_periodic(int cpu)
 
 		do_timer(1);
 		write_sequnlock(&xtime_lock);
+		calc_load(1);
 	}
 
 	update_process_times(user_mode(get_irq_regs()));
diff -puN kernel/time/tick-sched.c~time-move-calc_load-call-out-from-xtime_lock-protection kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/kernel/time/tick-sched.c
@@ -81,6 +81,8 @@ static void tick_do_update_jiffies64(kti
 		tick_next_period = ktime_add(last_jiffies_update, tick_period);
 	}
 	write_sequnlock(&xtime_lock);
+	if (ticks)
+		calc_load(ticks);
 }
 
 /*
diff -puN kernel/timer.c~time-move-calc_load-call-out-from-xtime_lock-protection kernel/timer.c
--- a/kernel/timer.c~time-move-calc_load-call-out-from-xtime_lock-protection
+++ a/kernel/timer.c
@@ -1173,30 +1173,39 @@ static unsigned long count_active_tasks(
  * Nothing else seems to be standardized: the fractional size etc
  * all seem to differ on different machines.
  *
- * Requires xtime_lock to access.
+ * Requires avenrun_lock to write.  Readers are not protected.
  */
 unsigned long avenrun[3];
+static DEFINE_SPINLOCK(avenrun_lock);
 
 EXPORT_SYMBOL(avenrun);
 
 /*
  * calc_load - given tick count, update the avenrun load estimates.
- * This is called while holding a write_lock on xtime_lock.
  */
-static inline void calc_load(unsigned long ticks)
+void calc_load(unsigned long ticks)
 {
 	unsigned long active_tasks; /* fixed-point */
 	static int count = LOAD_FREQ;
 
 	count -= ticks;
 	if (unlikely(count < 0)) {
+		unsigned long avr_1, avr_5, avr_15;
 		active_tasks = count_active_tasks();
+		spin_lock(&avenrun_lock);
+		avr_1 = avenrun[0];
+		avr_5 = avenrun[1];
+		avr_15 = avenrun[2];
 		do {
-			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
+			CALC_LOAD(avr_1, EXP_1, active_tasks);
+			CALC_LOAD(avr_5, EXP_5, active_tasks);
+			CALC_LOAD(avr_15, EXP_15, active_tasks);
 			count += LOAD_FREQ;
 		} while (count < 0);
+		avenrun[0] = avr_1;
+		avenrun[1] = avr_5;
+		avenrun[2] = avr_15;
+		spin_unlock(&avenrun_lock);
 	}
 }
 
@@ -1230,7 +1239,6 @@ void run_local_timers(void)
 static inline void update_times(unsigned long ticks)
 {
 	update_wall_time();
-	calc_load(ticks);
 }
 
 /*
_

Patches currently in -mm which might be from sivanich@sgi.com are

time-move-calc_load-call-out-from-xtime_lock-protection.patch

