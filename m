From: akpm@linux-foundation.org
Subject: + printk-add-kern_cont-annotation.patch added to -mm tree
Date: Thu, 04 Oct 2007 13:43:49 -0700
Message-ID: <200710042043.l94KhneT027796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33807 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757830AbXJDUop (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2007 16:44:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, apw@shadowen.org


The patch titled
     printk: add KERN_CONT annotation
has been added to the -mm tree.  Its filename is
     printk-add-kern_cont-annotation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: printk: add KERN_CONT annotation
From: Ingo Molnar <mingo@elte.hu>

printk: add the KERN_CONT annotation (which is empty string but via
which checkpatch.pl can notice that the lacking KERN_ level is fine).
This useful for multiple calls of hand-crafted printk output done by
early debug code or similar.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/kernel.h~printk-add-kern_cont-annotation include/linux/kernel.h
--- a/include/linux/kernel.h~printk-add-kern_cont-annotation
+++ a/include/linux/kernel.h
@@ -62,6 +62,13 @@ extern const char linux_proc_banner[];
 #define	KERN_INFO	"<6>"	/* informational			*/
 #define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
 
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define	KERN_CONT	""
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
fix-timer_stats-printout-of-events-sec.patch
git-kvm.patch
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
printk-add-kern_cont-annotation.patch
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
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
