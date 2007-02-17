From: akpm@linux-foundation.org
Subject: - i386-rework-local-apic-timer-calibration.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:15:01 -0800
Message-ID: <200702170715.l1H7F1Wh021590@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51046 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946468AbXBQHPs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:15:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, ebiederm@xmission.com, johnstul@us.ibm.com, mingo@elte.hu, rohitseth@google.com, zach@vmware.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     i386 rework local apic timer calibration
has been removed from the -mm tree.  Its filename was
     i386-rework-local-apic-timer-calibration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 rework local apic timer calibration
From: Thomas Gleixner <tglx@linutronix.de>

The local apic timer calibration has two problem cases:

1.  The calibration is based on readout of the PIT/HPET timer to detect the
   wrap of the periodic tick.  It happens that a box gets stuck in the
   calibration loop due to a PIT with a broken readout function.

2.  CoreDuo boxen show a sporadic PIT runs too slow defect, which results
   in a wrong lapic calibration.  The PIT goes back to normal operation once
   the lapic timer is switched to periodic mode.

Both are existing and unfixed problems in the current upstream kernel and
prevent certain laptops and other systems from booting Linux.

Rework the code to address both problems:

- Make the calibration interrupt driven.  This removes the wait_timer_tick
  magic hackery from lapic.c and time_hpet.c.  The clockevents framework
  allows easy substitution of the global tick event handler for the
  calibration.  This is more accurate than monitoring jiffies.  At this point
  of the boot process, nothing disturbes the interrupt delivery, so the
  results are very accurate.

- Verify the calibration against the PM timer, when available by using the
  early access function.  When the measured calibration period is outside of
  an one percent window, then the lapic timer calibration is adjusted to the
  pm timer result.

- Verify the calibration by running the lapic timer with the calibration
  handler.  Disable lapic timer in case of deviation.

This also removes the "synchronization" of the local apic timer to the global
tick.  This synchronization never worked, as there is no way to synchronize
PIT(HPET) and local APIC timer.  The synchronization by waiting for the tick
just alignes the local APIC timer for the first events, but later the events
drift away due to the different clocks.  Removing the "sync" is just
randomizing the asynchronous behaviour at setup time.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Zachary Amsden <zach@vmware.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rohit Seth <rohitseth@google.com>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c |  371 ++++++++++++++++++++++----------------
 include/asm-i386/apic.h |    2 
 2 files changed, 218 insertions(+), 155 deletions(-)

diff -puN arch/i386/kernel/apic.c~i386-rework-local-apic-timer-calibration arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~i386-rework-local-apic-timer-calibration
+++ a/arch/i386/kernel/apic.c
@@ -26,6 +26,7 @@
 #include <linux/sysdev.h>
 #include <linux/cpu.h>
 #include <linux/clockchips.h>
+#include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 
 #include <asm/atomic.h>
@@ -59,8 +60,8 @@
  */
 static int enable_local_apic __initdata = 0;
 
-/* Enable local APIC timer for highres/dyntick on UP */
-static int enable_local_apic_timer __initdata = 0;
+/* Local APIC timer verification ok */
+static int local_apic_timer_verify_ok;
 
 /*
  * Debug level, exported for io_apic.c
@@ -82,7 +83,7 @@ static void apic_pm_activate(void);
 static struct clock_event_device lapic_clockevent = {
 	.name		= "lapic",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT
-			| CLOCK_EVT_FEAT_C3STOP,
+			| CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_DUMMY,
 	.shift		= 32,
 	.set_mode	= lapic_timer_setup,
 	.set_next_event	= lapic_next_event,
@@ -159,64 +160,8 @@ int lapic_get_maxlvt(void)
  * Local APIC timer
  */
 
-/*
- * This part sets up the APIC 32 bit clock in LVTT1, with HZ interrupts
- * per second. We assume that the caller has already set up the local
- * APIC.
- *
- * The APIC timer is not exactly sync with the external timer chip, it
- * closely follows bus clocks.
- */
-
-/*
- * FIXME: Move this to i8253.h. There is no need to keep the access to
- * the PIT scattered all around the place -tglx
- */
-
-/*
- * The timer chip is already set up at HZ interrupts per second here,
- * but we do not accept timer interrupts yet. We only allow the BP
- * to calibrate.
- */
-static unsigned int __devinit get_8254_timer_count(void)
-{
-	unsigned long flags;
-
-	unsigned int count;
-
-	spin_lock_irqsave(&i8253_lock, flags);
-
-	outb_p(0x00, PIT_MODE);
-	count = inb_p(PIT_CH0);
-	count |= inb_p(PIT_CH0) << 8;
-
-	spin_unlock_irqrestore(&i8253_lock, flags);
-
-	return count;
-}
-
-/* next tick in 8254 can be caught by catching timer wraparound */
-static void __devinit wait_8254_wraparound(void)
-{
-	unsigned int curr_count, prev_count;
-
-	curr_count = get_8254_timer_count();
-	do {
-		prev_count = curr_count;
-		curr_count = get_8254_timer_count();
-
-		/* workaround for broken Mercury/Neptune */
-		if (prev_count >= curr_count + 0x100)
-			curr_count = get_8254_timer_count();
-
-	} while (prev_count >= curr_count);
-}
-
-/*
- * Default initialization for 8254 timers. If we use other timers like HPET,
- * we override this later
- */
-void (*wait_timer_tick)(void) __devinitdata = wait_8254_wraparound;
+/* Clock divisor is set to 16 */
+#define APIC_DIVISOR 16
 
 /*
  * This function sets up the local APIC timer, with a timeout of
@@ -228,9 +173,6 @@ void (*wait_timer_tick)(void) __devinitd
  * We do reads before writes even if unnecessary, to get around the
  * P5 APIC double write bug.
  */
-
-#define APIC_DIVISOR 16
-
 static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
 {
 	unsigned int lvtt_value, tmp_value;
@@ -277,6 +219,10 @@ static void lapic_timer_setup(enum clock
 	unsigned long flags;
 	unsigned int v;
 
+	/* Lapic used for broadcast ? */
+	if (!local_apic_timer_verify_ok)
+		return;
+
 	local_irq_save(flags);
 
 	switch (mode) {
@@ -321,111 +267,238 @@ static void __devinit setup_APIC_timer(v
 }
 
 /*
- * In this function we calibrate APIC bus clocks to the external
- * timer. Unfortunately we cannot use jiffies and the timer irq
- * to calibrate, since some later bootup code depends on getting
- * the first irq? Ugh.
+ * In this functions we calibrate APIC bus clocks to the external timer.
+ *
+ * We want to do the calibration only once since we want to have local timer
+ * irqs syncron. CPUs connected by the same APIC bus have the very same bus
+ * frequency.
  *
- * TODO: Fix this rather than saying "Ugh" -tglx
+ * This was previously done by reading the PIT/HPET and waiting for a wrap
+ * around to find out, that a tick has elapsed. I have a box, where the PIT
+ * readout is broken, so it never gets out of the wait loop again. This was
+ * also reported by others.
  *
- * We want to do the calibration only once since we
- * want to have local timer irqs syncron. CPUs connected
- * by the same APIC bus have the very same bus frequency.
- * And we want to have irqs off anyways, no accidental
- * APIC irq that way.
+ * Monitoring the jiffies value is inaccurate and the clockevents
+ * infrastructure allows us to do a simple substitution of the interrupt
+ * handler.
+ *
+ * The calibration routine also uses the pm_timer when possible, as the PIT
+ * happens to run way too slow (factor 2.3 on my VAIO CoreDuo, which goes
+ * back to normal later in the boot process).
+ */
+
+#define LAPIC_CAL_LOOPS		(HZ/10)
+
+static __initdata volatile int lapic_cal_loops = -1;
+static __initdata long lapic_cal_t1, lapic_cal_t2;
+static __initdata unsigned long long lapic_cal_tsc1, lapic_cal_tsc2;
+static __initdata unsigned long lapic_cal_pm1, lapic_cal_pm2;
+static __initdata unsigned long lapic_cal_j1, lapic_cal_j2;
+
+/*
+ * Temporary interrupt handler.
  */
+static void __init lapic_cal_handler(struct clock_event_device *dev)
+{
+	unsigned long long tsc = 0;
+	long tapic = apic_read(APIC_TMCCT);
+	unsigned long pm = acpi_pm_read_early();
+
+	if (cpu_has_tsc)
+		rdtscll(tsc);
+
+	switch (lapic_cal_loops++) {
+	case 0:
+		lapic_cal_t1 = tapic;
+		lapic_cal_tsc1 = tsc;
+		lapic_cal_pm1 = pm;
+		lapic_cal_j1 = jiffies;
+		break;
+
+	case LAPIC_CAL_LOOPS:
+		lapic_cal_t2 = tapic;
+		lapic_cal_tsc2 = tsc;
+		if (pm < lapic_cal_pm1)
+			pm += ACPI_PM_OVRRUN;
+		lapic_cal_pm2 = pm;
+		lapic_cal_j2 = jiffies;
+		break;
+	}
+}
 
-static int __init calibrate_APIC_clock(void)
+/*
+ * Setup the boot APIC
+ *
+ * Calibrate and verify the result.
+ */
+void __init setup_boot_APIC_clock(void)
 {
-	unsigned long long t1 = 0, t2 = 0;
-	long tt1, tt2;
-	long result;
-	int i;
-	const int LOOPS = HZ/10;
+	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
+	const long pm_100ms = PMTMR_TICKS_PER_SEC/10;
+	const long pm_thresh = pm_100ms/100;
+	void (*real_handler)(struct clock_event_device *dev);
+	unsigned long deltaj;
+	long delta, deltapm;
+
+	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
+		    "calibrating APIC timer ...\n");
 
-	apic_printk(APIC_VERBOSE, "calibrating APIC timer ...\n");
+	local_irq_disable();
+
+	/* Replace the global interrupt handler */
+	real_handler = global_clock_event->event_handler;
+	global_clock_event->event_handler = lapic_cal_handler;
 
 	/*
-	 * Put whatever arbitrary (but long enough) timeout
-	 * value into the APIC clock, we just want to get the
-	 * counter running for calibration.
+	 * Setup the APIC counter to 1e9. There is no way the lapic
+	 * can underflow in the 100ms detection time frame
 	 */
 	__setup_APIC_LVTT(1000000000, 0, 0);
 
-	/*
-	 * The timer chip counts down to zero. Let's wait
-	 * for a wraparound to start exact measurement:
-	 * (the current tick might have been already half done)
-	 */
+	/* Let the interrupts run */
+	local_irq_enable();
 
-	wait_timer_tick();
+	while(lapic_cal_loops <= LAPIC_CAL_LOOPS);
 
-	/*
-	 * We wrapped around just now. Let's start:
-	 */
-	if (cpu_has_tsc)
-		rdtscll(t1);
-	tt1 = apic_read(APIC_TMCCT);
+	local_irq_disable();
 
-	/*
-	 * Let's wait LOOPS wraprounds:
-	 */
-	for (i = 0; i < LOOPS; i++)
-		wait_timer_tick();
+	/* Restore the real event handler */
+	global_clock_event->event_handler = real_handler;
 
-	tt2 = apic_read(APIC_TMCCT);
-	if (cpu_has_tsc)
-		rdtscll(t2);
+	/* Build delta t1-t2 as apic timer counts down */
+	delta = lapic_cal_t1 - lapic_cal_t2;
+	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
 
-	/*
-	 * The APIC bus clock counter is 32 bits only, it
-	 * might have overflown, but note that we use signed
-	 * longs, thus no extra care needed.
-	 *
-	 * underflown to be exact, as the timer counts down ;)
-	 */
+	/* Check, if the PM timer is available */
+	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
+	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
 
-	result = (tt1-tt2)*APIC_DIVISOR/LOOPS;
+	if (deltapm) {
+		unsigned long mult;
+		u64 res;
+
+		mult = clocksource_hz2mult(PMTMR_TICKS_PER_SEC, 22);
+
+		if (deltapm > (pm_100ms - pm_thresh) &&
+		    deltapm < (pm_100ms + pm_thresh)) {
+			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+		} else {
+			res = (((u64) deltapm) *  mult) >> 22;
+			do_div(res, 1000000);
+			printk(KERN_WARNING "APIC calibration not consistent "
+			       "with PM Timer: %ldms instead of 100ms\n",
+			       (long)res);
+			/* Correct the lapic counter value */
+			res = (((u64) delta ) * pm_100ms);
+			do_div(res, deltapm);
+			printk(KERN_INFO "APIC delta adjusted to PM-Timer: "
+			       "%lu (%ld)\n", (unsigned long) res, delta);
+			delta = (long) res;
+		}
+	}
 
 	/* Calculate the scaled math multiplication factor */
-	lapic_clockevent.mult = div_sc(tt1-tt2, TICK_NSEC * LOOPS, 32);
+	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS, 32);
 	lapic_clockevent.max_delta_ns =
 		clockevent_delta2ns(0x7FFFFF, &lapic_clockevent);
 	lapic_clockevent.min_delta_ns =
 		clockevent_delta2ns(0xF, &lapic_clockevent);
 
-	apic_printk(APIC_VERBOSE, "..... tt1-tt2 %ld\n", tt1 - tt2);
+	calibration_result = (delta * APIC_DIVISOR) / LAPIC_CAL_LOOPS;
+
+	apic_printk(APIC_VERBOSE, "..... delta %ld\n", delta);
 	apic_printk(APIC_VERBOSE, "..... mult: %ld\n", lapic_clockevent.mult);
-	apic_printk(APIC_VERBOSE, "..... calibration result: %ld\n", result);
+	apic_printk(APIC_VERBOSE, "..... calibration result: %u\n",
+		    calibration_result);
 
-	if (cpu_has_tsc)
+	if (cpu_has_tsc) {
+		delta = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
 		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
-			"%ld.%04ld MHz.\n",
-			((long)(t2-t1)/LOOPS)/(1000000/HZ),
-			((long)(t2-t1)/LOOPS)%(1000000/HZ));
+			    "%ld.%04ld MHz.\n",
+			    (delta / LAPIC_CAL_LOOPS) / (1000000 / HZ),
+			    (delta / LAPIC_CAL_LOOPS) % (1000000 / HZ));
+	}
 
 	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
-		"%ld.%04ld MHz.\n",
-		result/(1000000/HZ),
-		result%(1000000/HZ));
-
-	return result;
-}
-
-void __init setup_boot_APIC_clock(void)
-{
-	unsigned long flags;
-	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n");
+		    "%u.%04u MHz.\n",
+		    calibration_result / (1000000 / HZ),
+		    calibration_result % (1000000 / HZ));
+
+
+	apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
+
+	/*
+	 * Setup the apic timer manually
+	 */
+	local_apic_timer_verify_ok = 1;
+	levt->event_handler = lapic_cal_handler;
+	lapic_timer_setup(CLOCK_EVT_MODE_PERIODIC, levt);
+	lapic_cal_loops = -1;
+
+	/* Let the interrupts run */
+	local_irq_enable();
+
+	while(lapic_cal_loops <= LAPIC_CAL_LOOPS);
+
+	local_irq_disable();
+
+	/* Stop the lapic timer */
+	lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
+
+	local_irq_enable();
+
+	/* Jiffies delta */
+	deltaj = lapic_cal_j2 - lapic_cal_j1;
+	apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
+
+	/* Check, if the PM timer is available */
+	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
+	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+
+	local_apic_timer_verify_ok = 0;
+
+	if (deltapm) {
+		if (deltapm > (pm_100ms - pm_thresh) &&
+		    deltapm < (pm_100ms + pm_thresh)) {
+			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
+			/* Check, if the jiffies result is consistent */
+			if (deltaj < LAPIC_CAL_LOOPS-2 ||
+			    deltaj > LAPIC_CAL_LOOPS+2) {
+				/*
+				 * Not sure, what we can do about this one.
+				 * When high resultion timers are active
+				 * and the lapic timer does not stop in C3
+				 * we are fine. Otherwise more trouble might
+				 * be waiting. -- tglx
+				 */
+				printk(KERN_WARNING "Global event device %s "
+				       "has wrong frequency "
+				       "(%lu ticks instead of %d)\n",
+				       global_clock_event->name, deltaj,
+				       LAPIC_CAL_LOOPS);
+			}
+			local_apic_timer_verify_ok = 1;
+		}
+	} else {
+		/* Check, if the jiffies result is consistent */
+		if (deltaj >= LAPIC_CAL_LOOPS-2 &&
+		    deltaj <= LAPIC_CAL_LOOPS+2) {
+			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
+			local_apic_timer_verify_ok = 1;
+		}
+	}
 
-	local_irq_save(flags);
+	if (!local_apic_timer_verify_ok) {
+		printk(KERN_WARNING
+		       "APIC timer disabled due to verification failure.\n");
+		/* No broadcast on UP ! */
+		if (num_possible_cpus() == 1)
+			return;
+	} else
+		lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
 
-	calibration_result = calibrate_APIC_clock();
-	/*
-	 * Now set up the timer for real.
-	 */
+	/* Setup the lapic or request the broadcast */
 	setup_APIC_timer();
-
-	local_irq_restore(flags);
 }
 
 void __devinit setup_secondary_APIC_clock(void)
@@ -442,16 +515,15 @@ static void local_apic_timer_interrupt(v
 	struct clock_event_device *evt = &per_cpu(lapic_events, cpu);
 
 	/*
-	 * Normally we should not be here till LAPIC has been
-	 * initialized but in some cases like kdump, its possible that
-	 * there is a pending LAPIC timer interrupt from previous
-	 * kernel's context and is delivered in new kernel the moment
-	 * interrupts are enabled.
+	 * Normally we should not be here till LAPIC has been initialized but
+	 * in some cases like kdump, its possible that there is a pending LAPIC
+	 * timer interrupt from previous kernel's context and is delivered in
+	 * new kernel the moment interrupts are enabled.
 	 *
-	 * Interrupts are enabled early and LAPIC is setup much later,
-	 * hence its possible that when we get here evt->event_handler
-	 * is NULL. Check for event_handler being NULL and discard
-	 * the interrupt as spurious.
+	 * Interrupts are enabled early and LAPIC is setup much later, hence
+	 * its possible that when we get here evt->event_handler is NULL.
+	 * Check for event_handler being NULL and discard the interrupt as
+	 * spurious.
 	 */
 	if (!evt->event_handler) {
 		printk(KERN_WARNING
@@ -1126,13 +1198,6 @@ static int __init parse_nolapic(char *ar
 }
 early_param("nolapic", parse_nolapic);
 
-static int __init apic_enable_lapic_timer(char *str)
-{
-	enable_local_apic_timer = 1;
-	return 0;
-}
-early_param("lapictimer", apic_enable_lapic_timer);
-
 static int __init apic_set_verbosity(char *str)
 {
 	if (strcmp("debug", str) == 0)
diff -puN include/asm-i386/apic.h~i386-rework-local-apic-timer-calibration include/asm-i386/apic.h
--- a/include/asm-i386/apic.h~i386-rework-local-apic-timer-calibration
+++ a/include/asm-i386/apic.h
@@ -95,8 +95,6 @@ static inline void ack_APIC_irq(void)
 	apic_write_around(APIC_EOI, 0);
 }
 
-extern void (*wait_timer_tick)(void);
-
 extern int lapic_get_maxlvt(void);
 extern void clear_local_APIC(void);
 extern void connect_bsp_APIC (void);
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-block.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-3.patch
