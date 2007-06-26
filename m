From: akpm@linux-foundation.org
Subject: + acpi-remove-the-useless-ifdef-code.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:08:04 -0700
Message-ID: <200706260008.l5Q084Bh014468@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58161 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650AbXFZAPS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:15:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu


The patch titled
     ACPI: remove the useless ifdef code
has been added to the -mm tree.  Its filename is
     acpi-remove-the-useless-ifdef-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: remove the useless ifdef code
From: Thomas Gleixner <tglx@linutronix.de>

The conversion of x86-64 to clock events makes the
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 n the timer broadcast functions useless. Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   12 ------------
 1 files changed, 12 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-remove-the-useless-ifdef-code drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-remove-the-useless-ifdef-code
+++ a/drivers/acpi/processor_idle.c
@@ -203,21 +203,12 @@ static void acpi_timer_check_state(int s
 
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
 	unsigned long reason;
 
 	reason = pr->power.timer_broadcast_on_state < INT_MAX ?
 		CLOCK_EVT_NOTIFY_BROADCAST_ON : CLOCK_EVT_NOTIFY_BROADCAST_OFF;
 
 	clockevents_notify(reason, &pr->id);
-#else
-	cpumask_t mask = cpumask_of_cpu(pr->id);
-
-	if (pr->power.timer_broadcast_on_state < INT_MAX)
-		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-	else
-		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
-#endif
 }
 
 /* Power(C) State timer broadcast control */
@@ -225,8 +216,6 @@ static void acpi_state_timer_broadcast(s
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-
 	int state = cx - pr->power.states;
 
 	if (state >= pr->power.timer_broadcast_on_state) {
@@ -236,7 +225,6 @@ static void acpi_state_timer_broadcast(s
 			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
 		clockevents_notify(reason, &pr->id);
 	}
-#endif
 }
 
 #else
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi-add-exports.patch
git-arm.patch
i386-hpet-check-if-the-counter-works.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
timekeeping-fixup-shadow-variable-argument.patch
timerc-cleanup-recently-introduced-whitespace-damage.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
pcspkr-use-the-global-pit-lock.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch
i386-remove-volatile-in-apicc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
i386-move-pit-function-declarations-and-constants-to-correct-header-file.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-remove-dead-code-and-other-janitor-work-in-tscc.patch
x86_64-fix-apic-typo.patch
x86_64-convert-to-cleckevents.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
sys_time-speedup.patch
lguest-the-host-code.patch
