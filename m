From: akpm@linux-foundation.org
Subject: - acpi-remove-the-useless-ifdef-code.patch removed from -mm tree
Date: Tue, 24 Jul 2007 02:19:22 -0700
Message-ID: <200707240923.l6O9NtDX006243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41840 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758426AbXGXJZR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2007 05:25:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     ACPI: remove the useless ifdef code
has been removed from the -mm tree.  Its filename was
     acpi-remove-the-useless-ifdef-code.patch

This patch was dropped because an updated version will be merged

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
@@ -222,21 +222,12 @@ static void acpi_timer_check_state(int s
 
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
@@ -244,8 +235,6 @@ static void acpi_state_timer_broadcast(s
 				       struct acpi_processor_cx *cx,
 				       int broadcast)
 {
-#ifdef CONFIG_GENERIC_CLOCKEVENTS
-
 	int state = cx - pr->power.states;
 
 	if (state >= pr->power.timer_broadcast_on_state) {
@@ -255,7 +244,6 @@ static void acpi_state_timer_broadcast(s
 			CLOCK_EVT_NOTIFY_BROADCAST_EXIT;
 		clockevents_notify(reason, &pr->id);
 	}
-#endif
 }
 
 #else
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
drivers-char-hpetc-integer-constant-is-too-large-for-long-type.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
