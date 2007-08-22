From: akpm@linux-foundation.org
Subject: - nohz-fix-nohz-x86-dyntick-idle-handling.patch removed from -mm tree
Date: Wed, 22 Aug 2007 01:16:38 -0700
Message-ID: <200708220816.l7M8Gg7k002216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXHVISI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Aug 2007 04:18:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, abelay@novell.com, davem@davemloft.net, lenb@kernel.org, lethal@linux-sh.org, mingo@elte.hu, rmk+kernel@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     NOHZ: fix nohz x86 dyntick idle handling
has been removed from the -mm tree.  Its filename was
     nohz-fix-nohz-x86-dyntick-idle-handling.patch

This patch was dropped because it has started killing the Vaio

------------------------------------------------------
Subject: NOHZ: fix nohz x86 dyntick idle handling
From: Thomas Gleixner <tglx@linutronix.de>

The cpuidle patches moved the tick nohz handling from irq_exit into the inner
idle loop.  The change is correct as it covers non interrupt based wakeups
(e.g DMA) on x86 as well, but the move breaks ARM, SH and SPARC64.

Keep the original implementation and deselet the irq exit code for those
architectures which have idle wakeups without interrupts.

This way the non affected architectures are not burdened with the extra
changes in the idle implementation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Adam Belay <abelay@novell.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Dave Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/Kconfig |    4 ++++
 kernel/softirq.c  |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/i386/Kconfig~nohz-fix-nohz-x86-dyntick-idle-handling arch/i386/Kconfig
--- a/arch/i386/Kconfig~nohz-fix-nohz-x86-dyntick-idle-handling
+++ a/arch/i386/Kconfig
@@ -35,6 +35,10 @@ config GENERIC_CLOCKEVENTS_BROADCAST
 	default y
 	depends on X86_LOCAL_APIC
 
+config NONIRQ_WAKEUP
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
diff -puN kernel/softirq.c~nohz-fix-nohz-x86-dyntick-idle-handling kernel/softirq.c
--- a/kernel/softirq.c~nohz-fix-nohz-x86-dyntick-idle-handling
+++ a/kernel/softirq.c
@@ -304,7 +304,7 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
-#ifdef CONFIG_NO_HZ
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_NONIRQ_WAKEUP)
 	/* Make sure that timer wheel updates are propagated */
 	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
 		tick_nohz_stop_sched_tick();
_

Patches currently in -mm which might be from tglx@linutronix.de are

futex_unlock_pi-hurts-my-brain-and-may-cause.patch
posix-timers-fix-deletion-race.patch
posix-timers-fix-creation-race.patch
signalfd-fix-interaction-with-posix-timers.patch
signalfd-make-it-group-wide-fix-posix-timers-scheduling.patch
git-acpi.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
use-num_possible_cpus-instead-of-nr_cpus-for-timer.patch
kernel-time-clocksourcec-use-list_for_each_entry-instead-of-list_for_each.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
