From: akpm@linux-foundation.org
Subject: + highres-improve-debug-output.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:07:38 -0700
Message-ID: <200706260007.l5Q07ceX014424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44131 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755367AbXFZAIW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:08:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, johnstul@us.ibm.com, tglx@linutronix.de


The patch titled
     highres: improve debug output
has been added to the -mm tree.  Its filename is
     highres-improve-debug-output.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
+			else if (!(dev->features & CLOCK_EVT_FEAT_ONESHOT))
+				printk(" %s does not support one-shot mode.\n",
+				       dev->name);
+		}
 		return -EINVAL;
+	}
 
 	td->mode = TICKDEV_MODE_ONESHOT;
 	dev->event_handler = handler;
_

Patches currently in -mm which might be from mingo@elte.hu are

git-acpi-add-exports.patch
git-kvm.patch
git-selinux.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
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
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
pie-randomization.patch
vdso-print-fatal-signals.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
introduce-o_cloexec-take-2.patch
introduce-o_cloexec-parisc-fix.patch
o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
allow-softlockup-to-be-runtime-disabled.patch
sys_time-speedup.patch
cfs-scheduler.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-v14-rc2-mm1.patch
cfs-scheduler-warning-fixes.patch
cfs-scheduler-v15-rc3-mm1.patch
fs-proc-basec-make-a-struct-static.patch
cfs-warning-fixes.patch
schedstats-fix-printk-format.patch
cfs-scheduler-v16.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
