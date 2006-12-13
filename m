From: akpm@osdl.org
Subject: - time-fix-msecs_to_jiffies-bug.patch removed from -mm tree
Date: Wed, 13 Dec 2006 14:48:26 -0800
Message-ID: <200612132248.kBDMmQS8023080@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52774 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbWLMWsd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 13 Dec 2006 17:48:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: fix msecs_to_jiffies() bug
has been removed from the -mm tree.  Its filename was
     time-fix-msecs_to_jiffies-bug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: time: fix msecs_to_jiffies() bug
From: Ingo Molnar <mingo@elte.hu>

Fix multiple conversion bugs in msecs_to_jiffies().

The main problem is that this condition:

	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))

overflows if HZ is smaller than 1000!

This change is user-visible: for HZ=250 SUS-compliant poll()-timeout value of
-20 is mistakenly converted to 'immediate timeout'.

(The new dyntick code also triggered this, as it frequently creates 'lagging
timer wheel' scenarios.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 42 insertions(+), 1 deletion(-)

diff -puN kernel/time.c~time-fix-msecs_to_jiffies-bug kernel/time.c
--- a/kernel/time.c~time-fix-msecs_to_jiffies-bug
+++ a/kernel/time.c
@@ -500,15 +500,56 @@ unsigned int jiffies_to_usecs(const unsi
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
 
+/*
+ * When we convert to jiffies then we interpret incoming values
+ * the following way:
+ *
+ * - negative values mean 'infinite timeout' (MAX_JIFFY_OFFSET)
+ *
+ * - 'too large' values [that would result in larger than
+ *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.
+ *
+ * - all other values are converted to jiffies by either multiplying
+ *   the input value by a factor or dividing it with a factor
+ *
+ * We must also be careful about 32-bit overflows.
+ */
 unsigned long msecs_to_jiffies(const unsigned int m)
 {
-	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+	/*
+	 * Negative value, means infinite timeout:
+	 */
+	if ((int)m < 0)
 		return MAX_JIFFY_OFFSET;
+
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	/*
+	 * HZ is equal to or smaller than 1000, and 1000 is a nice
+	 * round multiple of HZ, divide with the factor between them,
+	 * but round upwards:
+	 */
 	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
 #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	/*
+	 * HZ is larger than 1000, and HZ is a nice round multiple of
+	 * 1000 - simply multiply with the factor between them.
+	 *
+	 * But first make sure the multiplication result cannot
+	 * overflow:
+	 */
+	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+
 	return m * (HZ / MSEC_PER_SEC);
 #else
+	/*
+	 * Generic case - multiply, round and divide. But first
+	 * check that if we are doing a net multiplication, that
+	 * we wouldnt overflow:
+	 */
+	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+
 	return (m * HZ + MSEC_PER_SEC - 1) / MSEC_PER_SEC;
 #endif
 }
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
debug-add-sysrq_always_enabled-boot-option.patch
lockdep-filter-off-by-default.patch
lockdep-improve-verbose-messages.patch
lockdep-improve-lockdep_reset.patch
lockdep-clean-up-very_verbose-define.patch
lockdep-use-chain-hash-on-config_debug_lockdep-too.patch
lockdep-print-irq-trace-info-on-asserts.patch
lockdep-fix-possible-races-while-disabling-lock-debugging.patch
optimize-calc_load.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
convert-i386-pda-code-to-use-%fs-fixes.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
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
debugging-feature-proc-timer_list.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch

