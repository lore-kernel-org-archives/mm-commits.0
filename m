From: akpm@osdl.org
Subject: - updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:49:05 -0800
Message-ID: <200612132249.kBDMn5pU023132@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52882 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbWLMWtQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:49:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, len.brown@intel.com, linux-acpi@vger.kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     ACPI: Add state propagation for dynamic broadcasting
has been removed from the -mm tree.  Its filename was
     updated-acpi-add-state-propagation-for-dynamic-broadcasting.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: ACPI: Add state propagation for dynamic broadcasting
From: Thomas Gleixner <tglx@linutronix.de>

This is a preparatory patch for high resolution timers and dynticks.

The local APIC timer is fast and per CPU, but it gets stopped in C3 state.  On
some broken systems, especially AMD based ones it gets stopped in C2.  This
also affects akpm's jinxed VAIO.

The broadcast function informs the local APIC management code that a state
which stops the local APIC is going to be entered/exited.  This switches the
local APIC timer to the PIT broadcast mode.  The clockevents layer takes care
of the distribution of events.

The lapic_timer_idle_broadcast() function is an empty inline for now, which
will be replaced by the later clockevents patches for the affected
architectures.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: <linux-acpi@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_idle.c |   20 ++++++++++++++++++++
 include/asm-i386/apic.h       |    1 +
 include/asm-x86_64/apic.h     |    1 +
 3 files changed, 22 insertions(+)

diff -puN drivers/acpi/processor_idle.c~updated-acpi-add-state-propagation-for-dynamic-broadcasting drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~updated-acpi-add-state-propagation-for-dynamic-broadcasting
+++ a/drivers/acpi/processor_idle.c
@@ -281,11 +281,27 @@ static void acpi_propagate_timer_broadca
 		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
 }
 
+/* Power(C) State timer broadcast control */
+static void acpi_state_timer_broadcast(struct acpi_processor *pr,
+				       struct acpi_processor_cx *cx,
+				       int broadcast)
+{
+	int state = cx - pr->power.states;
+
+	if (state >= pr->power.timer_broadcast_on_state)
+		lapic_timer_idle_broadcast(broadcast);
+}
+
 #else
 
 static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cstate) { }
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr) { }
+static void acpi_state_timer_broadcast(struct acpi_processor *pr,
+				       struct acpi_processor_cx *cx,
+				       int broadcast)
+{
+}
 
 #endif
 
@@ -431,6 +447,7 @@ static void acpi_processor_idle(void)
 		/* Get start time (ticks) */
 		t1 = inl(acpi_fadt.xpm_tmr_blk.address);
 		/* Invoke C2 */
+		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
 		t2 = inl(acpi_fadt.xpm_tmr_blk.address);
@@ -445,6 +462,7 @@ static void acpi_processor_idle(void)
 		/* Compute time (ticks) that we were actually asleep */
 		sleep_ticks =
 		    ticks_elapsed(t1, t2) - cx->latency_ticks - C2_OVERHEAD;
+		acpi_state_timer_broadcast(pr, cx, 0);
 		break;
 
 	case ACPI_STATE_C3:
@@ -467,6 +485,7 @@ static void acpi_processor_idle(void)
 		/* Get start time (ticks) */
 		t1 = inl(acpi_fadt.xpm_tmr_blk.address);
 		/* Invoke C3 */
+		acpi_state_timer_broadcast(pr, cx, 1);
 		acpi_cstate_enter(cx);
 		/* Get end time (ticks) */
 		t2 = inl(acpi_fadt.xpm_tmr_blk.address);
@@ -487,6 +506,7 @@ static void acpi_processor_idle(void)
 		/* Compute time (ticks) that we were actually asleep */
 		sleep_ticks =
 		    ticks_elapsed(t1, t2) - cx->latency_ticks - C3_OVERHEAD;
+		acpi_state_timer_broadcast(pr, cx, 0);
 		break;
 
 	default:
diff -puN include/asm-i386/apic.h~updated-acpi-add-state-propagation-for-dynamic-broadcasting include/asm-i386/apic.h
--- a/include/asm-i386/apic.h~updated-acpi-add-state-propagation-for-dynamic-broadcasting
+++ a/include/asm-i386/apic.h
@@ -113,6 +113,7 @@ extern void setup_secondary_APIC_clock (
 extern int APIC_init_uniprocessor (void);
 extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
+static inline void lapic_timer_idle_broadcast(int broadcast) { }
 
 extern void enable_NMI_through_LVT0 (void * dummy);
 
diff -puN include/asm-x86_64/apic.h~updated-acpi-add-state-propagation-for-dynamic-broadcasting include/asm-x86_64/apic.h
--- a/include/asm-x86_64/apic.h~updated-acpi-add-state-propagation-for-dynamic-broadcasting
+++ a/include/asm-x86_64/apic.h
@@ -84,6 +84,7 @@ extern int APIC_init_uniprocessor (void)
 extern void disable_APIC_timer(void);
 extern void enable_APIC_timer(void);
 extern void setup_apic_routing(void);
+static inline void lapic_timer_idle_broadcast(int broadcast) { }
 
 extern void setup_APIC_extened_lvt(unsigned char lvt_off, unsigned char vector,
 				   unsigned char msg_type, unsigned char mask);
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

