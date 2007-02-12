From: akpm@linux-foundation.org
Subject: - kvm-fix-vcpu-freeing-bug.patch removed from -mm tree
Date: Mon, 12 Feb 2007 14:48:57 -0800
Message-ID: <200702122248.l1CMmvpI014069@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45605 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030379AbXBLWtK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Feb 2007 17:49:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     kvm: fix vcpu freeing bug
has been removed from the -mm tree.  Its filename was
     kvm-fix-vcpu-freeing-bug.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kvm: fix vcpu freeing bug
From: Ingo Molnar <mingo@elte.hu>

vcpu_load() can return NULL and it sometimes does in failure paths (for
example when the userspace ABI version is too old) - causing a preemption
count underflow in the ->vcpu_free() later on.  So check for NULL.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/kvm/kvm_main.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/kvm/kvm_main.c~kvm-fix-vcpu-freeing-bug drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-fix-vcpu-freeing-bug
+++ a/drivers/kvm/kvm_main.c
@@ -272,7 +272,9 @@ static void kvm_free_physmem(struct kvm 
 
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
-	vcpu_load(vcpu->kvm, vcpu_slot(vcpu));
+	if (!vcpu_load(vcpu->kvm, vcpu_slot(vcpu)))
+		return;
+
 	kvm_mmu_destroy(vcpu);
 	vcpu_put(vcpu);
 	kvm_arch_ops->vcpu_free(vcpu);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
bugfixes-pci-devices-get-assigned-redundant-irqs.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
simplify-the-stacktrace-code.patch
add-irq-flag-to-disable-balancing-for-an-interrupt.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
add-a-functions-to-handle-interrupt-affinity-setting-alpha-fix.patch
hz-free-ntp.patch
uninline-jiffiesh-functions.patch
fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
fix-timeout-overflow-with-jiffies.patch
gtod-persistent-clock-support.patch
i386-use-gtod-persistent-clock-support.patch
i386-remove-useless-code-in-tscc.patch
simplify-the-registration-of-clocksources.patch
x86-rewrite-smp-tsc-sync-code.patch
clocksource-replace-is_continuous-by-a-flag-field.patch
clocksource-replace-is_continuous-by-a-flag-field-fix.patch
clocksource-fixup-is_continous-changes-on-arm.patch
clocksource-fixup-is_continous-changes-on-avr32.patch
clocksource-fixup-is_continous-changes-on-s390.patch
clocksource-fixup-is_continous-changes-on-mips.patch
clocksource-remove-the-update-callback.patch
clocksource-add-verification-watchdog-helper.patch
mark-tsc-on-geodelx-reliable.patch
uninline-irq_enter.patch
fix-cascade-lookup-of-next_timer_interrupt.patch
extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
hrtimers-clean-up-callback-tracking.patch
hrtimers-move-and-add-documentation.patch
acpi-fix-missing-include-for-up.patch
acpi-keep-track-of-timer-broadcasting.patch
allow-early-access-to-the-power-management-timer.patch
i386-apic-clean-up-the-apic-code.patch
clockevents-add-core-functionality.patch
tick-management-core-functionality.patch
tick-management-broadcast-functionality.patch
tick-management-dyntick--highres-functionality.patch
clockevents-i383-drivers.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-for-dyntick.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
i386-enable-dynticks-in-kconfig.patch
hrtimers-add-high-resolution-timer-support.patch
hrtimers-prevent-possible-itimer-dos.patch
add-debugging-feature-proc-timer_stat.patch
add-debugging-feature-proc-timer_stat-cleanup.patch
add-debugging-feature-proc-timer_list.patch
add-sysrq-q-to-print-timer_list-debug-info.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-hpet-fixup-clocksource-changes.patch
time-x86_64-tsc-fixup-clocksource-changes.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
posix-timers-rcu-optimization-for-clock_gettime.patch
posix-timers-rcu-optimization-for-clock_gettime-fix.patch
genirq-do-not-mask-interrupts-by-default.patch
genirq-remove-irq_disabled.patch
schedule_on_each_cpu-use-preempt_disable.patch
workqueue-kill-run_scheduled_work.patch
workqueue-dont-save-interrupts-in-run_workqueue.patch
workqueue-make-cancel_rearming_delayed_workqueue-work-on-idle-dwork.patch
workqueue-introduce-cpu_singlethread_map.patch
workqueue-introduce-workqueue_struct-singlethread.patch
workqueue-make-init_workqueues-__init.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
deprecate-sa_interrupt-and-friends.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
