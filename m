From: akpm@osdl.org
Subject: + acpi-keep-track-of-timer-broadcasting.patch added to -mm tree
Date: Wed, 24 Jan 2007 22:36:39 -0800
Message-ID: <200701250636.l0P6ad3Z008355__39861.4526530311$1169707382$gmane$org@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50591 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965620AbXAYGmu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Jan 2007 01:42:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, len.brown@intel.com, linux-acpi@vger.kernel.org, mingo@elte.hu, zippel@linux-m68k.org


The patch titled
     ACPI keep track of timer broadcasting
has been added to the -mm tree.  Its filename is
     acpi-keep-track-of-timer-broadcasting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI keep track of timer broadcasting
From: Thomas Gleixner <tglx@linutronix.de>

This is a preperatory patch for highres/dyntick:

- replace the big #ifdef ARCH_APICTIMER_STOPS_ON_C3 hackery by functions

- remove the double switch in the power verify function (in the worst case
  we switched ipi to apic and 20usec later apic to ipi)

- keep track of the the state which stops local APIC timer

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <len.brown@intel.com>
Cc: <linux-acpi@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_idle.c |   67 ++++++++++++++++++++++----------
 include/acpi/processor.h      |    1 
 2 files changed, 49 insertions(+), 19 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-keep-track-of-timer-broadcasting drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-keep-track-of-timer-broadcasting
+++ a/drivers/acpi/processor_idle.c
@@ -250,6 +250,49 @@ static void acpi_cstate_enter(struct acp
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
@@ -920,11 +963,7 @@ static int acpi_processor_power_verify(s
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
@@ -936,21 +975,14 @@ static int acpi_processor_power_verify(s
 
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
 
@@ -958,10 +990,7 @@ static int acpi_processor_power_verify(s
 			working++;
 	}
 
-#ifdef ARCH_APICTIMER_STOPS_ON_C3
-	if (timer_broadcast)
-		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-#endif
+	acpi_propagate_timer_broadcast(pr);
 
 	return (working);
 }
diff -puN include/acpi/processor.h~acpi-keep-track-of-timer-broadcasting include/acpi/processor.h
--- a/include/acpi/processor.h~acpi-keep-track-of-timer-broadcasting
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
git-block.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
clocksource-add-verification-watchdog-helper-fix.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
make-good_sigevent-non-static.patch
aio-completion-signal-notification.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
