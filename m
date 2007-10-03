From: akpm@linux-foundation.org
Subject: + mtd-fix-cfi_interleave-build-errors.patch added to -mm tree
Date: Wed, 03 Oct 2007 14:27:03 -0700
Message-ID: <200710032127.l93LR3M8009509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39757 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbXJCV12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 17:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, dwmw2@infradead.org


The patch titled
     MTD: fix cfi_interleave() build errors
has been added to the -mm tree.  Its filename is
     mtd-fix-cfi_interleave-build-errors.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTD: fix cfi_interleave() build errors
From: Ingo Molnar <mingo@elte.hu>

If the .config specifies no cfi_interleave() then generate a run-time bug. 
This makes 'make randconfig' build tests work again.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/mtd/cfi.h~mtd-fix-cfi_interleave-build-errors include/linux/mtd/cfi.h
--- a/include/linux/mtd/cfi.h~mtd-fix-cfi_interleave-build-errors
+++ a/include/linux/mtd/cfi.h
@@ -66,6 +66,10 @@ static inline int cfi_interleave(void *c
 }
 #endif
 
+#ifndef cfi_interleave
+# define cfi_interleave(cfi) ({ BUG_ON(1); 0; })
+#endif
+
 static inline int cfi_interleave_supported(int i)
 {
 	switch (i) {
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-kvm.patch
mtd-fix-cfi_interleave-build-errors.patch
provide-stubs-for-enable_irq_wake-and-disable_irq_wake.patch
git-sched.patch
rt-ptracer-can-monopolize-cpu-was-cpu-hotplug-and-real-time.patch
some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug.patch
geode-mfgpt-clock-event-device-support.patch
i386-convert-mm_context_t-semaphore-to-a-mutex.patch
x86-64-disable-local-apic-timer-use-on-amd-systems-with-c1e.patch
clockevents-remove-unused-inline-function.patch
clockevents-allow-build-without-runtime-use.patch
x86_64-consolidate-tsc-calibration.patch
i386-prepare-sharing-hpet-code.patch
i386-hpet-add-x8664-hpet-bits.patch
i386-prepare-sharing-pit-code.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
jiffies-remove-unused-macros.patch
acpi-remove-the-useless-ifdef-code.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
ich-force-hpet-make-generic-time-capable-of-switching-broadcast-timer.patch
ich-force-hpet-restructure-hpet-generic-clock-code.patch
ich-force-hpet-ich7-or-later-quirk-to-force-detect-enable.patch
ich-force-hpet-late-initialization-of-hpet-after-quirk.patch
ich-force-hpet-ich5-quirk-to-force-detect-enable.patch
ich-force-hpet-ich5-fix-a-bug-with-suspend-resume.patch
ich-force-hpet-add-ich7_0-pciid-to-quirk-list.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
softlockup-use-cpu_clock-instead-of-sched_clock.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-improve-debug-output-fix.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
pie-executable-randomization.patch
pie-executable-randomization-fix.patch
pie-executable-randomization-fix-2.patch
pie-executable-randomization-fix-3.patch
make-rcutorture-rng-use-temporal-entropy.patch
shrink-task_struct-if-config_futex=n.patch
move-preempt_notifiers-into-an-always-included-kconfig.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime-fix.patch
mutex-documentation-is-unclear-about-software-interrupts-tasklets-and-timers.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
do-cpu_dead-migrating-under-read_locktasklist-instead-of-write_lock_irqtasklist.patch
migration_callcpu_dead-use-spin_lock_irq-instead-of-task_rq_lock.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
uninline-find_task_by_xxx-set-of-functions.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
