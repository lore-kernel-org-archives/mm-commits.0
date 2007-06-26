From: akpm@linux-foundation.org
Subject: + tick-management-spread-timer-interrupt.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:36 -0700
Message-ID: <200706260007.l5Q07acS014421@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51485 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbXFZAIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     tick management: spread timer interrupt
has been added to the -mm tree.  Its filename is
     tick-management-spread-timer-interrupt.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tick management: spread timer interrupt
From: john stultz <johnstul@us.ibm.com>

After discussing w/ Thomas over IRC, it seems the issue is the sched tick
fires on every cpu at the same time, causing extra lock contention.

This smaller change, adds an extra offset per cpu so the ticks don't line up. 
This patch also drops the idle latency from 40us down to under 20us.

Signed-off-by: john stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~tick-management-spread-timer-interrupt kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-management-spread-timer-interrupt
+++ a/kernel/time/tick-sched.c
@@ -573,6 +573,7 @@ void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now = ktime_get();
+	u64 offset;
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -581,8 +582,12 @@ void tick_setup_sched_timer(void)
 	ts->sched_timer.function = tick_sched_timer;
 	ts->sched_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 
-	/* Get the next period */
+	/* Get the next period (per cpu) */
 	ts->sched_timer.expires = tick_init_jiffy_update();
+	offset = ktime_to_ns(tick_period) >> 1;
+	do_div(offset, NR_CPUS);
+	offset *= smp_processor_id();
+	ts->sched_timer.expires = ktime_add_ns(ts->sched_timer.expires, offset);
 
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
_

Patches currently in -mm which might be from johnstul@us.ibm.com are

git-acpi-add-exports.patch
i386-hpet-check-if-the-counter-works.patch
clockevents-fix-typo-in-acpi_pmc.patch
timekeeping-fixup-shadow-variable-argument.patch
clockevents-remove-prototypes-of-removed-functions.patch
clockevents-fix-resume-logic.patch
clockevents-fix-device-replacement.patch
tick-management-spread-timer-interrupt.patch
highres-improve-debug-output.patch
hrtimer-speedup-hrtimer_enqueue.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
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
introduce-boot-based-time.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-2.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix-3.patch
use-boot-based-time-for-uptime-in-proc.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
sys_time-speedup.patch
