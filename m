From: akpm@linux-foundation.org
Subject: + ich-force-hpet-restructure-hpet-generic-clock-code.patch added to -mm tree
Date: Tue, 26 Jun 2007 12:20:35 -0700
Message-ID: <200706261920.l5QJKZnv000371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758203AbXFZTVZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 15:21:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: venkatesh.pallipadi@intel.com, ak@suse.de, greg@kroah.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     ICH Force HPET: restructure hpet generic clock code
has been added to the -mm tree.  Its filename is
     ich-force-hpet-restructure-hpet-generic-clock-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ICH Force HPET: restructure hpet generic clock code
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>

Restructure and rename legacy replacement mode HPET timer support.  Just the
code structural changes and should be zero functionality change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/hpet.c |  148 +++++++++++++++++++++-----------------
 1 files changed, 83 insertions(+), 65 deletions(-)

diff -puN arch/i386/kernel/hpet.c~ich-force-hpet-restructure-hpet-generic-clock-code arch/i386/kernel/hpet.c
--- a/arch/i386/kernel/hpet.c~ich-force-hpet-restructure-hpet-generic-clock-code
+++ a/arch/i386/kernel/hpet.c
@@ -158,9 +158,9 @@ static void hpet_reserve_platform_timers
  */
 static unsigned long hpet_period;
 
-static void hpet_set_mode(enum clock_event_mode mode,
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt);
-static int hpet_next_event(unsigned long delta,
+static int hpet_legacy_next_event(unsigned long delta,
 			   struct clock_event_device *evt);
 
 /*
@@ -169,8 +169,8 @@ static int hpet_next_event(unsigned long
 static struct clock_event_device hpet_clockevent = {
 	.name		= "hpet",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
-	.set_mode	= hpet_set_mode,
-	.set_next_event = hpet_next_event,
+	.set_mode	= hpet_legacy_set_mode,
+	.set_next_event = hpet_legacy_next_event,
 	.shift		= 32,
 	.irq		= 0,
 };
@@ -187,7 +187,7 @@ static void hpet_start_counter(void)
 	hpet_writel(cfg, HPET_CFG);
 }
 
-static void hpet_enable_int(void)
+static void hpet_enable_legacy_int(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
 
@@ -196,7 +196,39 @@ static void hpet_enable_int(void)
 	hpet_legacy_int_enabled = 1;
 }
 
-static void hpet_set_mode(enum clock_event_mode mode,
+static void hpet_legacy_clockevent_register(void)
+{
+	uint64_t hpet_freq;
+
+	/* Start HPET legacy interrupts */
+	hpet_enable_legacy_int();
+
+	/*
+	 * The period is a femto seconds value. We need to calculate the
+	 * scaled math multiplication factor for nanosecond to hpet tick
+	 * conversion.
+	 */
+	hpet_freq = 1000000000000000ULL;
+	do_div(hpet_freq, hpet_period);
+	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
+				      NSEC_PER_SEC, 32);
+	/* Calculate the min / max delta */
+	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
+							   &hpet_clockevent);
+	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
+							   &hpet_clockevent);
+
+	/*
+	 * Start hpet with the boot cpu mask and make it
+	 * global after the IO_APIC has been initialized.
+	 */
+	hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
+	clockevents_register_device(&hpet_clockevent);
+	global_clock_event = &hpet_clockevent;
+	printk(KERN_DEBUG "hpet clockevent registered\n");
+}
+
+static void hpet_legacy_set_mode(enum clock_event_mode mode,
 			  struct clock_event_device *evt)
 {
 	unsigned long cfg, cmp, now;
@@ -237,12 +269,12 @@ static void hpet_set_mode(enum clock_eve
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
-		hpet_enable_int();
+		hpet_enable_legacy_int();
 		break;
 	}
 }
 
-static int hpet_next_event(unsigned long delta,
+static int hpet_legacy_next_event(unsigned long delta,
 			   struct clock_event_device *evt)
 {
 	unsigned long cnt;
@@ -282,58 +314,11 @@ static struct clocksource clocksource_hp
 #endif
 };
 
-/*
- * Try to setup the HPET timer
- */
-int __init hpet_enable(void)
+static int hpet_clocksource_register(void)
 {
-	unsigned long id;
-	uint64_t hpet_freq;
 	u64 tmp, start, now;
 	cycle_t t1;
 
-	if (!is_hpet_capable())
-		return 0;
-
-	hpet_set_mapping();
-
-	/*
-	 * Read the period and check for a sane value:
-	 */
-	hpet_period = hpet_readl(HPET_PERIOD);
-	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
-		goto out_nohpet;
-
-	/*
-	 * The period is a femto seconds value. We need to calculate the
-	 * scaled math multiplication factor for nanosecond to hpet tick
-	 * conversion.
-	 */
-	hpet_freq = 1000000000000000ULL;
-	do_div(hpet_freq, hpet_period);
-	hpet_clockevent.mult = div_sc((unsigned long) hpet_freq,
-				      NSEC_PER_SEC, 32);
-	/* Calculate the min / max delta */
-	hpet_clockevent.max_delta_ns = clockevent_delta2ns(0x7FFFFFFF,
-							   &hpet_clockevent);
-	hpet_clockevent.min_delta_ns = clockevent_delta2ns(0x30,
-							   &hpet_clockevent);
-
-	/*
-	 * Read the HPET ID register to retrieve the IRQ routing
-	 * information and the number of channels
-	 */
-	id = hpet_readl(HPET_ID);
-
-#ifdef CONFIG_HPET_EMULATE_RTC
-	/*
-	 * The legacy routing mode needs at least two channels, tick timer
-	 * and the rtc emulation channel.
-	 */
-	if (!(id & HPET_ID_NUMBER))
-		goto out_nohpet;
-#endif
-
 	/* Start the counter */
 	hpet_start_counter();
 
@@ -355,7 +340,7 @@ int __init hpet_enable(void)
 	if (t1 == read_hpet()) {
 		printk(KERN_WARNING
 		       "HPET counter not counting. HPET disabled\n");
-		goto out_nohpet;
+		return -ENODEV;
 	}
 
 	/* Initialize and register HPET clocksource
@@ -376,16 +361,49 @@ int __init hpet_enable(void)
 
 	clocksource_register(&clocksource_hpet);
 
+	return 0;
+}
+
+/*
+ * Try to setup the HPET timer
+ */
+int __init hpet_enable(void)
+{
+	unsigned long id;
+
+	if (!is_hpet_capable())
+		return 0;
+
+	hpet_set_mapping();
+
+	/*
+	 * Read the period and check for a sane value:
+	 */
+	hpet_period = hpet_readl(HPET_PERIOD);
+	if (hpet_period < HPET_MIN_PERIOD || hpet_period > HPET_MAX_PERIOD)
+		goto out_nohpet;
+
+	/*
+	 * Read the HPET ID register to retrieve the IRQ routing
+	 * information and the number of channels
+	 */
+	id = hpet_readl(HPET_ID);
+
+#ifdef CONFIG_HPET_EMULATE_RTC
+	/*
+	 * The legacy routing mode needs at least two channels, tick timer
+	 * and the rtc emulation channel.
+	 */
+	if (!(id & HPET_ID_NUMBER))
+		goto out_nohpet;
+#endif
+
+	if (hpet_clocksource_register())
+		goto out_nohpet;
+
 	if (id & HPET_ID_LEGSUP) {
-		hpet_enable_int();
+		hpet_legacy_clockevent_register();
 		hpet_reserve_platform_timers(id);
-		/*
-		 * Start hpet with the boot cpu mask and make it
-		 * global after the IO_APIC has been initialized.
-		 */
-		hpet_clockevent.cpumask = cpumask_of_cpu(smp_processor_id());
-		clockevents_register_device(&hpet_clockevent);
-		global_clock_event = &hpet_clockevent;
 		return 1;
 	}
 	return 0;
_

Patches currently in -mm which might be from venkatesh.pallipadi@intel.com are

git-acpi.patch
cpuidle-menu-governor-and-hrtimer-compile-fix.patch
cpuidle-reenable-proc-acpi-power-interface-for-the-time-being.patch
cpuidle-fix-the-uninitialized-variable-in-sysfs-routine.patch
cpuidle-menu-governor-change-the-early-break-condition.patch
cpuidle-make-cpuidle-sysfs-driver-governor-switch-off-by-default.patch
cpuidle-add-rating-to-the-governors-and-pick-the-one-with-highest-rating-by-default.patch
cpuidle-first-round-of-documentation-updates.patch
git-acpi-add-exports.patch
git-cpufreq.patch
make-usb-autosuspend-timer-1-sec-jiffy-aligned.patch
round_jiffies-for-i386-and-x86-64-non-critical-corrected-mce-polling.patch
x86_64-convert-to-cleckevents.patch
x86_64-block-irq-balancing-for-timer.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
git-newsetup.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
