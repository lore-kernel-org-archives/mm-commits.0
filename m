From: akpm@osdl.org
Subject: - genirq-fix-irq-flow-handler-uninstall.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:53:55 -0800
Message-ID: <200612230753.kBN7rtsr010171@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910AbWLWHyI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, mingo@elte.hu, tnt@246tNt.com, mm-commits@vger.kernel.org


The patch titled
     genirq: fix irq flow handler uninstall
has been removed from the -mm tree.  Its filename was
     genirq-fix-irq-flow-handler-uninstall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: genirq: fix irq flow handler uninstall
From: Thomas Gleixner <tglx@linutronix.de>

The sanity check for no_irq_chip in __set_irq_hander() is unconditional on
both install and uninstall of an handler.  This triggers false warnings and
replaces no_irq_chip by dummy_irq_chip in the uninstall case.

Check only, when a real handler is installed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Sylvain Munaut <tnt@246tNt.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/irq/chip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN kernel/irq/chip.c~genirq-fix-irq-flow-handler-uninstall kernel/irq/chip.c
--- a/kernel/irq/chip.c~genirq-fix-irq-flow-handler-uninstall
+++ a/kernel/irq/chip.c
@@ -517,8 +517,7 @@ __set_irq_handler(unsigned int irq, irq_
 
 	if (!handle)
 		handle = handle_bad_irq;
-
-	if (desc->chip == &no_irq_chip) {
+	else if (desc->chip == &no_irq_chip) {
 		printk(KERN_WARNING "Trying to install %sinterrupt handler "
 		       "for IRQ%d\n", is_chained ? "chained " : "", irq);
 		/*
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
clockevents-i386-drivers-high-res-timers-fix-apic-event-broadcasting-code.patch
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
high-res-timers-core-do-itimer-rearming-in-process-context-fix2.patch
high-res-timers-core-hrtimers-add-state-tracking-fix.patch
high-res-timers-core-hrtimers-add-state-tracking-fix-fix.patch
high-res-timers-allow-tsc-clocksource-if-pmtimer-present.patch
dynticks-core.patch
dynticks-add-nohz-stats-to-proc-stat.patch
dynticks-i386-support-idle-handler-callbacks.patch
dynticks-i386-prepare-nmi-watchdog.patch
high-res-timers-dynticks-i386-support-enable-in-kconfig.patch
debugging-feature-add-proc-timer_stat.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch

