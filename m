From: akpm@linux-foundation.org
Subject: - highres-improve-debug-output.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:06 -0700
Message-ID: <200707230934.l6N9Y6C3016355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759476AbXGWJqA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:46:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     highres: improve debug output
has been removed from the -mm tree.  Its filename was
     highres-improve-debug-output.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: highres: improve debug output
From: Ingo Molnar <mingo@elte.hu>

Add some more debug information to the hrtimer and clock events code.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/apic.c    |    3 +++
 kernel/hrtimer.c           |    5 ++++-
 kernel/time/tick-oneshot.c |   15 ++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff -puN arch/i386/kernel/apic.c~highres-improve-debug-output arch/i386/kernel/apic.c
--- a/arch/i386/kernel/apic.c~highres-improve-debug-output
+++ a/arch/i386/kernel/apic.c
@@ -524,6 +524,9 @@ void __init setup_boot_APIC_clock(void)
 		 */
 		if (nmi_watchdog != NMI_IO_APIC)
 			lapic_clockevent.features &= ~CLOCK_EVT_FEAT_DUMMY;
+		else
+			printk(KERN_WARNING "APIC timer registered as dummy,"
+			       " due to nmi_watchdog=1!\n");
 	}
 
 	/* Setup the lapic or request the broadcast */
diff -puN kernel/hrtimer.c~highres-improve-debug-output kernel/hrtimer.c
--- a/kernel/hrtimer.c~highres-improve-debug-output
+++ a/kernel/hrtimer.c
@@ -558,7 +558,8 @@ static inline int hrtimer_enqueue_reprog
  */
 static int hrtimer_switch_to_hres(void)
 {
-	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
+	int cpu = smp_processor_id();
+	struct hrtimer_cpu_base *base = &per_cpu(hrtimer_bases, cpu);
 	unsigned long flags;
 
 	if (base->hres_active)
@@ -568,6 +569,8 @@ static int hrtimer_switch_to_hres(void)
 
 	if (tick_init_highres()) {
 		local_irq_restore(flags);
+		printk(KERN_WARNING "Could not switch to high resolution "
+				    "mode on CPU %d\n", cpu);
 		return 0;
 	}
 	base->hres_active = 1;
diff -puN kernel/time/tick-oneshot.c~highres-improve-debug-output kernel/time/tick-oneshot.c
--- a/kernel/time/tick-oneshot.c~highres-improve-debug-output
+++ a/kernel/time/tick-oneshot.c
@@ -73,8 +73,21 @@ int tick_switch_to_oneshot(void (*handle
 	struct clock_event_device *dev = td->evtdev;
 
 	if (!dev || !(dev->features & CLOCK_EVT_FEAT_ONESHOT) ||
-	    !tick_device_is_functional(dev))
+		    !tick_device_is_functional(dev)) {
+
+		printk(KERN_INFO "Clockevents: "
+		       "could not switch to one-shot mode:");
+		if (!dev) {
+			printk(" no tick device\n");
+		} else {
+			if (!tick_device_is_functional(dev))
+				printk(" %s is not functional.\n", dev->name);
+			else
+				printk(" %s does not support one-shot mode.\n",
+				       dev->name);
+		}
 		return -EINVAL;
+	}
 
 	td->mode = TICKDEV_MODE_ONESHOT;
 	dev->event_handler = handler;
_

Patches currently in -mm which might be from mingo@elte.hu are

git-acpi.patch
git-kvm.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
mark-sysrq_sched_debug_show-static.patch
cfs-mark-print_cfs_stats-static.patch
remove-kconfig-setting-config_debug_shirq.patch
debug-handling-of-early-spurious-interrupts.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
