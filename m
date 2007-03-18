From: akpm@linux-foundation.org
Subject: + i386-trust-the-pm-timer-calibration-of-the-local-apic.patch added to -mm tree
Date: Sun, 18 Mar 2007 00:12:53 -0800
Message-ID: <200703180812.l2I8CrXK019070@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59349 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbXCRIND (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 18 Mar 2007 04:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, mingo@elte.hu


The patch titled
     i386: trust the PM-Timer calibration of the local APIC timer
has been added to the -mm tree.  Its filename is
     i386-trust-the-pm-timer-calibration-of-the-local-apic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: trust the PM-Timer calibration of the local APIC timer
From: Thomas Gleixner <tglx@linutronix.de>

When PM-Timer is available for local APIC timer calibration we can skip the
verification of the calibrated time value.  The resulting error is quite
small on a bunch of evaluated platforms and is less harming than the
observed false positives.

We need to keep the verification on systems, which have no PM-Timer to
avoid bogus local APIC timer calibrations in the range of factor 2-10,
which can be observed when swicthing off the PM-timer support in the kernel
configuration.

The wrong calibration values are probably caused by SMM code trying to
emulate a PS/2 keyboard from a (maybe connected or not) USB keyboard.  This
prohibits the accurate delivery of PIT interrupts, which are used to
calibrate the local APIC timer.  Unfortunately we have no way to disable
this BIOS misfeature in the early boot process.

Add also the dropped cpu_relax() back to the wait loops.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c |   78 +++++++++++++-------------------------
 1 file changed, 27 insertions(+), 51 deletions(-)

diff -puN arch/i386/kernel/apic.c~i386-trust-the-pm-timer-calibration-of-the-local-apic arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~i386-trust-the-pm-timer-calibration-of-the-local-apic
+++ a/arch/i386/kernel/apic.c
@@ -338,6 +338,7 @@ void __init setup_boot_APIC_clock(void)
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
 	long delta, deltapm;
+	int pm_referenced = 0;
 
 	apic_printk(APIC_VERBOSE, "Using local APIC timer interrupts.\n"
 		    "calibrating APIC timer ...\n");
@@ -357,7 +358,8 @@ void __init setup_boot_APIC_clock(void)
 	/* Let the interrupts run */
 	local_irq_enable();
 
-	while(lapic_cal_loops <= LAPIC_CAL_LOOPS);
+	while (lapic_cal_loops <= LAPIC_CAL_LOOPS)
+		cpu_relax();
 
 	local_irq_disable();
 
@@ -394,6 +396,7 @@ void __init setup_boot_APIC_clock(void)
 			       "%lu (%ld)\n", (unsigned long) res, delta);
 			delta = (long) res;
 		}
+		pm_referenced = 1;
 	}
 
 	/* Calculate the scaled math multiplication factor */
@@ -423,68 +426,41 @@ void __init setup_boot_APIC_clock(void)
 		    calibration_result / (1000000 / HZ),
 		    calibration_result % (1000000 / HZ));
 
-
-	apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
-
-	/*
-	 * Setup the apic timer manually
-	 */
 	local_apic_timer_verify_ok = 1;
-	levt->event_handler = lapic_cal_handler;
-	lapic_timer_setup(CLOCK_EVT_MODE_PERIODIC, levt);
-	lapic_cal_loops = -1;
 
-	/* Let the interrupts run */
-	local_irq_enable();
+	/* We trust the pm timer based calibration */
+	if (!pm_referenced) {
+		apic_printk(APIC_VERBOSE, "... verify APIC timer\n");
 
-	while(lapic_cal_loops <= LAPIC_CAL_LOOPS);
+		/*
+		 * Setup the apic timer manually
+		 */
+		levt->event_handler = lapic_cal_handler;
+		lapic_timer_setup(CLOCK_EVT_MODE_PERIODIC, levt);
+		lapic_cal_loops = -1;
 
-	local_irq_disable();
+		/* Let the interrupts run */
+		local_irq_enable();
 
-	/* Stop the lapic timer */
-	lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
+		while(lapic_cal_loops <= LAPIC_CAL_LOOPS)
+			cpu_relax();
 
-	local_irq_enable();
+		local_irq_disable();
 
-	/* Jiffies delta */
-	deltaj = lapic_cal_j2 - lapic_cal_j1;
-	apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
+		/* Stop the lapic timer */
+		lapic_timer_setup(CLOCK_EVT_MODE_SHUTDOWN, levt);
 
-	/* Check, if the PM timer is available */
-	deltapm = lapic_cal_pm2 - lapic_cal_pm1;
-	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+		local_irq_enable();
 
-	local_apic_timer_verify_ok = 0;
+		/* Jiffies delta */
+		deltaj = lapic_cal_j2 - lapic_cal_j1;
+		apic_printk(APIC_VERBOSE, "... jiffies delta = %lu\n", deltaj);
 
-	if (deltapm) {
-		if (deltapm > (pm_100ms - pm_thresh) &&
-		    deltapm < (pm_100ms + pm_thresh)) {
-			apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
-			/* Check, if the jiffies result is consistent */
-			if (deltaj < LAPIC_CAL_LOOPS-2 ||
-			    deltaj > LAPIC_CAL_LOOPS+2) {
-				/*
-				 * Not sure, what we can do about this one.
-				 * When high resultion timers are active
-				 * and the lapic timer does not stop in C3
-				 * we are fine. Otherwise more trouble might
-				 * be waiting. -- tglx
-				 */
-				printk(KERN_WARNING "Global event device %s "
-				       "has wrong frequency "
-				       "(%lu ticks instead of %d)\n",
-				       global_clock_event->name, deltaj,
-				       LAPIC_CAL_LOOPS);
-			}
-			local_apic_timer_verify_ok = 1;
-		}
-	} else {
 		/* Check, if the jiffies result is consistent */
-		if (deltaj >= LAPIC_CAL_LOOPS-2 &&
-		    deltaj <= LAPIC_CAL_LOOPS+2) {
+		if (deltaj >= LAPIC_CAL_LOOPS-2 && deltaj <= LAPIC_CAL_LOOPS+2)
 			apic_printk(APIC_VERBOSE, "... jiffies result ok\n");
-			local_apic_timer_verify_ok = 1;
-		}
+		else
+			local_apic_timer_verify_ok = 0;
 	}
 
 	if (!local_apic_timer_verify_ok) {
_

Patches currently in -mm which might be from tglx@linutronix.de are

hrtimer-prevent-overrun-dos-in-hrtimer_forward.patch
hrtimer-fixup-unlocked-access-to-wall_to_monotonic.patch
futex-pi-state-locking-fix.patch
fix-ktime_sec_max-on-32-bit.patch
i386-trust-the-pm-timer-calibration-of-the-local-apic.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
