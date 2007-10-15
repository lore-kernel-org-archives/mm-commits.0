From: akpm@linux-foundation.org
Subject: - clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:17:03 -0700
Message-ID: <200710150917.l9F9H3vt027240@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49975 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754897AbXJOJR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:17:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     clockevents: fix bogus next_event reset for oneshot broadcast devices
has been removed from the -mm tree.  Its filename was
     clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: clockevents: fix bogus next_event reset for oneshot broadcast devices
From: Thomas Gleixner <tglx@linutronix.de>

In periodic broadcast mode the next_event member of the broadcast device
structure is set to KTIME_MAX in the interrupt handler. This is wrong,
as we calculate the next periodic interrupt with this variable.

Remove it.

Noticed by Ralf. MIPS is the first user of this mode, it does not affect
existing users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-and-tested-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-broadcast.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN kernel/time/tick-broadcast.c~clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices kernel/time/tick-broadcast.c
--- a/kernel/time/tick-broadcast.c~clockevents-fix-bogus-next_event-reset-for-oneshot-broadcast-devices
+++ a/kernel/time/tick-broadcast.c
@@ -176,8 +176,6 @@ static void tick_do_periodic_broadcast(v
  */
 static void tick_handle_periodic_broadcast(struct clock_event_device *dev)
 {
-	dev->next_event.tv64 = KTIME_MAX;
-
 	tick_do_periodic_broadcast();
 
 	/*
_

Patches currently in -mm which might be from tglx@linutronix.de are

origin.patch
git-acpi.patch
git-arm.patch
git-mips.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
git-sched.patch
i386-cleanup-struct-irqaction-initializers.patch
x86_64-cleanup-struct-irqaction-initializers.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
frv-cleanup-struct-irqaction-initializers.patch
m32r-cleanup-struct-irqaction-initializers.patch
cris-cleanup-struct-irqaction-initializers.patch
uml-eliminate-hz.patch
uml-fix-timer-switching.patch
uml-simplify-interval-setting.patch
uml-separate-timer-initialization.patch
uml-generic_time-support.patch
uml-generic_clockevents-support.patch
uml-clocksource-support.patch
uml-clocksource-support-fix.patch
uml-tickless-support.patch
uml-tickless-support-fix.patch
uml-eliminate-interrupts-in-the-idle-loop.patch
uml-eliminate-sigalrm.patch
uml-use-sec_per_sec-constants.patch
v850-cleanup-struct-irqaction-initializers.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
spin_lock_unlocked-cleanups.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
