From: akpm@osdl.org
Subject: + acpi-keep-track-of-timer-broadcast.patch added to -mm tree
Date: Wed, 13 Dec 2006 14:44:08 -0800
Message-ID: <200612132244.kBDMi8gj022864@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52355 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbWLMWoV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:44:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, len.brown@intel.com, linux-acpi@vger.kernel.org, mingo@elte.hu


The patch titled
     ACPI: keep track of timer broadcast
has been added to the -mm tree.  Its filename is
     acpi-keep-track-of-timer-broadcast.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: keep track of timer broadcast
From: Thomas Gleixner <tglx@linutronix.de>

This is a preperatory patch for highres/dyntick:

- replace the big #ifdef ARCH_APICTIMER_STOPS_ON_C3 hackery by functions

- remove the double switch in the power verify function (in the worst case
  we switched ipi to apic and 20usec later apic to ipi)

- keep track of the the state which stops local APIC timer

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: <linux-acpi@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_idle.c |   67 ++++++++++++++++++++++----------
 include/acpi/processor.h      |    1 
 2 files changed, 49 insertions(+), 19 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-keep-track-of-timer-broadcast drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-keep-track-of-timer-broadcast
+++ a/drivers/acpi/processor_idle.c
@@ -246,6 +246,49 @@ static void acpi_cstate_enter(struct acp
 	}
 }
 
+#ifdef ARCH_APICTIMER_STOPS_ON_C3
+
+/*
+ * Some BIOS implementations switch to C3 in the published C2 state. This seems
+ * to be a common problem on AMD boxen.
+ */
+static void acpi_timer_check_state(int state, struct acpi_processor *pr,
+				   struct acpi_processor_cx *cx)
+{
+	struct acpi_processor_power *pwr = &pr->power;
+
+	/*
+	 * Check, if one of the previous states already marked the lapic
+	 * unstable
+	 */
+	if (pwr->timer_broadcast_on_state < state)
+		return;
+
+	if(cx->type == ACPI_STATE_C3 ||
+	   boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
+		pr->power.timer_broadcast_on_state = state;
+		return;
+	}
+}
+
+static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
+{
+	cpumask_t mask = cpumask_of_cpu(pr->id);
+
+	if (pr->power.timer_broadcast_on_state < INT_MAX)
+		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
+	else
+		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
+}
+
+#else
+
+static void acpi_timer_check_state(int state, struct acpi_processor *pr,
+				   struct acpi_processor_cx *cstate) { }
+static void acpi_propagate_timer_broadcast(struct acpi_processor *pr) { }
+
+#endif
+
 static void acpi_processor_idle(void)
 {
 	struct acpi_processor *pr = NULL;
@@ -912,11 +955,7 @@ static int acpi_processor_power_verify(s
 	unsigned int i;
 	unsigned int working = 0;
 
-#ifdef ARCH_APICTIMER_STOPS_ON_C3
-	int timer_broadcast = 0;
-	cpumask_t mask = cpumask_of_cpu(pr->id);
-	on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
-#endif
+	pr->power.timer_broadcast_on_state = INT_MAX;
 
 	for (i = 1; i < ACPI_PROCESSOR_MAX_POWER; i++) {
 		struct acpi_processor_cx *cx = &pr->power.states[i];
@@ -928,21 +967,14 @@ static int acpi_processor_power_verify(s
 
 		case ACPI_STATE_C2:
 			acpi_processor_power_verify_c2(cx);
-#ifdef ARCH_APICTIMER_STOPS_ON_C3
-			/* Some AMD systems fake C3 as C2, but still
-			   have timer troubles */
-			if (cx->valid && 
-				boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
-				timer_broadcast++;
-#endif
+			if (cx->valid)
+				acpi_timer_check_state(i, pr, cx);
 			break;
 
 		case ACPI_STATE_C3:
 			acpi_processor_power_verify_c3(pr, cx);
-#ifdef ARCH_APICTIMER_STOPS_ON_C3
 			if (cx->valid)
-				timer_broadcast++;
-#endif
+				acpi_timer_check_state(i, pr, cx);
 			break;
 		}
 
@@ -950,10 +982,7 @@ static int acpi_processor_power_verify(s
 			working++;
 	}
 
-#ifdef ARCH_APICTIMER_STOPS_ON_C3
-	if (timer_broadcast)
-		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-#endif
+	acpi_propagate_timer_broadcast(pr);
 
 	return (working);
 }
diff -puN include/acpi/processor.h~acpi-keep-track-of-timer-broadcast include/acpi/processor.h
--- a/include/acpi/processor.h~acpi-keep-track-of-timer-broadcast
+++ a/include/acpi/processor.h
@@ -79,6 +79,7 @@ struct acpi_processor_power {
 	u32 bm_activity;
 	int count;
 	struct acpi_processor_cx states[ACPI_PROCESSOR_MAX_POWER];
+	int timer_broadcast_on_state;
 };
 
 /* Performance Management */
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-mtd.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-clean-up-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-include-fix.patch
acpi-keep-track-of-timer-broadcast.patch
acpi-add-state-propagation-for-dynamic-broadcasting.patch
acpi-cleanups-allow-early-access-to-pmtimer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-core.patch
clockevents-i386-drivers.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch

