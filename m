From: akpm@linux-foundation.org
Subject: - tick-management-spread-timer-interrupt.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:04 -0700
Message-ID: <200707230934.l6N9Y4q7016352@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37337 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759136AbXGWJp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     tick management: spread timer interrupt
has been removed from the -mm tree.  Its filename was
     tick-management-spread-timer-interrupt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/time/tick-sched.c~tick-management-spread-timer-interrupt kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~tick-management-spread-timer-interrupt
+++ a/kernel/time/tick-sched.c
@@ -546,6 +546,7 @@ void tick_setup_sched_timer(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
 	ktime_t now = ktime_get();
+	u64 offset;
 
 	/*
 	 * Emulate tick processing via per-CPU hrtimers:
@@ -554,8 +555,12 @@ void tick_setup_sched_timer(void)
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

git-acpi.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
