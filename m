From: akpm@osdl.org
Subject: + kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:16:01 -0800
Message-ID: <200612282316.kBSNG18q015869@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40734 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbWL1XQK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:16:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, avi@qumranet.com


The patch titled
     kvm: fix GFP_KERNEL allocation in atomic section in kvm_dev_ioctl_create_vcpu()
has been added to the -mm tree.  Its filename is
     kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kvm: fix GFP_KERNEL allocation in atomic section in kvm_dev_ioctl_create_vcpu()
From: Ingo Molnar <mingo@elte.hu>

fix an GFP_KERNEL allocation in atomic section: kvm_dev_ioctl_create_vcpu()
called kvm_mmu_init(), which calls alloc_pages(), while holding the vcpu.

The fix is to set up the MMU state in two phases: kvm_mmu_create() and
kvm_mmu_setup().

(NOTE: free_vcpus does an kvm_mmu_destroy() call so there's no need for any
extra teardown branch on allocation/init failure here.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/kvm/kvm.h      |    3 ++-
 drivers/kvm/kvm_main.c |   10 ++++++----
 drivers/kvm/mmu.c      |   24 +++++++++---------------
 3 files changed, 17 insertions(+), 20 deletions(-)

diff -puN drivers/kvm/kvm.h~kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu drivers/kvm/kvm.h
--- a/drivers/kvm/kvm.h~kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu
+++ a/drivers/kvm/kvm.h
@@ -319,7 +319,8 @@ int kvm_init_arch(struct kvm_arch_ops *o
 void kvm_exit_arch(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
-int kvm_mmu_init(struct kvm_vcpu *vcpu);
+int kvm_mmu_create(struct kvm_vcpu *vcpu);
+int kvm_mmu_setup(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot);
diff -puN drivers/kvm/kvm_main.c~kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu drivers/kvm/kvm_main.c
--- a/drivers/kvm/kvm_main.c~kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu
+++ a/drivers/kvm/kvm_main.c
@@ -522,12 +522,14 @@ static int kvm_dev_ioctl_create_vcpu(str
 	if (r < 0)
 		goto out_free_vcpus;
 
-	kvm_arch_ops->vcpu_load(vcpu);
+	r = kvm_mmu_create(vcpu);
+	if (r < 0)
+		goto out_free_vcpus;
 
-	r = kvm_arch_ops->vcpu_setup(vcpu);
+	kvm_arch_ops->vcpu_load(vcpu);
+	r = kvm_mmu_setup(vcpu);
 	if (r >= 0)
-		r = kvm_mmu_init(vcpu);
-
+		r = kvm_arch_ops->vcpu_setup(vcpu);
 	vcpu_put(vcpu);
 
 	if (r < 0)
diff -puN drivers/kvm/mmu.c~kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu drivers/kvm/mmu.c
--- a/drivers/kvm/mmu.c~kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu
+++ a/drivers/kvm/mmu.c
@@ -639,28 +639,22 @@ error_1:
 	return -ENOMEM;
 }
 
-int kvm_mmu_init(struct kvm_vcpu *vcpu)
+int kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
-	int r;
-
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
 	ASSERT(list_empty(&vcpu->free_pages));
 
-	r = alloc_mmu_pages(vcpu);
-	if (r)
-		goto out;
-
-	r = init_kvm_mmu(vcpu);
-	if (r)
-		goto out_free_pages;
+	return alloc_mmu_pages(vcpu);
+}
 
-	return 0;
+int kvm_mmu_setup(struct kvm_vcpu *vcpu)
+{
+	ASSERT(vcpu);
+	ASSERT(!VALID_PAGE(vcpu->mmu.root_hpa));
+	ASSERT(!list_empty(&vcpu->free_pages));
 
-out_free_pages:
-	free_mmu_pages(vcpu);
-out:
-	return r;
+	return init_kvm_mmu(vcpu);
 }
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
_

Patches currently in -mm which might be from mingo@elte.hu are

change-warn_on-back-to-bug-at.patch
rcu-rcutorture-suspend-fix.patch
sched-fix-cond_resched_softirq-offset.patch
lockdep-printk-warning-fix.patch
kvm-fix-gfp_kernel-allocation-in-atomic-section-in-kvm_dev_ioctl_create_vcpu.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
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

