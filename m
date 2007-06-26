From: akpm@linux-foundation.org
Subject: + nohz-fix-nohz-x86-dyntick-idle-handling.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:19 -0700
Message-ID: <200706260007.l5Q07J9b014397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47103 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754714AbXFZAIU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tglx@linutronix.de, abelay@novell.com, davem@davemloft.net, lenb@kernel.org, lethal@linux-sh.org, mingo@elte.hu, rmk+kernel@arm.linux.org.uk


The patch titled
     NOHZ: fix nohz x86 dyntick idle handling
has been added to the -mm tree.  Its filename is
     nohz-fix-nohz-x86-dyntick-idle-handling.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 kernel/softirq.c  |    5 +++++
 2 files changed, 9 insertions(+)

diff -puN arch/i386/Kconfig~nohz-fix-nohz-x86-dyntick-idle-handling arch/i386/Kconfig
--- a/arch/i386/Kconfig~nohz-fix-nohz-x86-dyntick-idle-handling
+++ a/arch/i386/Kconfig
@@ -31,6 +31,10 @@ config GENERIC_CLOCKEVENTS_BROADCAST
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
@@ -303,6 +303,11 @@ void irq_exit(void)
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_NONIRQ_WAKEUP)
+	/* Make sure that timer wheel updates are propagated */
+	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
+		tick_nohz_stop_sched_tick();
+#endif
 	preempt_enable_no_resched();
 }
 
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
