From: akpm@osdl.org
Subject: + kvm-fix-gfp_kernel-alloc-in-atomic-section-bug.patch added to -mm tree
Date: Tue, 02 Jan 2007 14:05:31 -0800
Message-ID: <200701022205.l02M5WPl031366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36857 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXABWGD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 17:06:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, avi@qumranet.com


The patch titled
     KVM: Fix GFP_KERNEL alloc in atomic section bug
has been added to the -mm tree.  Its filename is
     kvm-fix-gfp_kernel-alloc-in-atomic-section-bug.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KVM: Fix GFP_KERNEL alloc in atomic section bug
From: Ingo Molnar <mingo@elte.hu>

KVM does kmalloc() in an atomic section while having preemption disabled via
vcpu_load().  Fix this by moving the ->*_msr setup from the vcpu_setup method
to the vcpu_create method.

(This is also a small speedup for setting up a vcpu, which can in theory be
more frequent than the vcpu_create method).

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/vmx.c |   32 +++++++++++++++++++++-----------
 1 files changed, 21 insertions(+), 11 deletions(-)

diff -puN drivers/kvm/vmx.c~kvm-fix-gfp_kernel-alloc-in-atomic-section-bug drivers/kvm/vmx.c
--- a/drivers/kvm/vmx.c~kvm-fix-gfp_kernel-alloc-in-atomic-section-bug
+++ a/drivers/kvm/vmx.c
@@ -1094,14 +1094,6 @@ static int vmx_vcpu_setup(struct kvm_vcp
 	rdmsrl(MSR_IA32_SYSENTER_EIP, a);
 	vmcs_writel(HOST_IA32_SYSENTER_EIP, a);   /* 22.2.3 */
 
-	ret = -ENOMEM;
-	vcpu->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!vcpu->guest_msrs)
-		goto out;
-	vcpu->host_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!vcpu->host_msrs)
-		goto out_free_guest_msrs;
-
 	for (i = 0; i < NR_VMX_MSR; ++i) {
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
@@ -1155,8 +1147,6 @@ static int vmx_vcpu_setup(struct kvm_vcp
 
 	return 0;
 
-out_free_guest_msrs:
-	kfree(vcpu->guest_msrs);
 out:
 	return ret;
 }
@@ -1906,13 +1896,33 @@ static int vmx_create_vcpu(struct kvm_vc
 {
 	struct vmcs *vmcs;
 
+	vcpu->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!vcpu->guest_msrs)
+		return -ENOMEM;
+
+	vcpu->host_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!vcpu->host_msrs)
+		goto out_free_guest_msrs;
+
 	vmcs = alloc_vmcs();
 	if (!vmcs)
-		return -ENOMEM;
+		goto out_free_msrs;
+
 	vmcs_clear(vmcs);
 	vcpu->vmcs = vmcs;
 	vcpu->launched = 0;
+
 	return 0;
+
+out_free_msrs:
+	kfree(vcpu->host_msrs);
+	vcpu->host_msrs = NULL;
+
+out_free_guest_msrs:
+	kfree(vcpu->guest_msrs);
+	vcpu->guest_msrs = NULL;
+
+	return -ENOMEM;
 }
 
 static struct kvm_arch_ops vmx_arch_ops = {
_

Patches currently in -mm which might be from mingo@elte.hu are

kvm-fix-gfp_kernel-alloc-in-atomic-section-bug.patch
kvm-use-raw_smp_processor_id-instead-of.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
revert-i386-fix-the-verify_quirk_intel_irqbalance.patch
revert-x86_64-mm-add-genapic_force.patch
revert-x86_64-mm-fix-the-irqbalance-quirk-for-e7320-e7520-e7525.patch
convert-i386-pda-code-to-use-%fs.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
sched-improve-sched_clock-on-i686.patch
sched-improve-sched_clock-on-i686-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
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
debugging-feature-proc-timer_list.patch
debugging-feature-proc-timer_list-warning-fix.patch
debugging-feature-sysrq-q-to-print-timers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
fsaio-add-a-wait-queue-parameter-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_slow.patch
fsaio-routines-to-initialize-and-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-filesystem-aio-read-tidy.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
detect-atomic-counter-underflows.patch
debug-shared-irqs.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
vdso-print-fatal-signals.patch
vdso-improve-print_fatal_signals-support-by-adding-memory-maps.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix.patch
lockdep-show-held-locks-when-showing-a-stackdump-fix-2.patch
kmap_atomic-debugging.patch
