From: akpm@osdl.org
Subject: - x86_64-fix-boot-hang-caused-by-calgary_iommu_enabled_by_default.patch removed from -mm tree
Date: Wed, 20 Dec 2006 23:39:59 -0800
Message-ID: <200612210739.kBL7dxJ3018985@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45896 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422825AbWLUHkX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 02:40:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, ak@suse.de, muli@il.ibm.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix boot hang caused by CALGARY_IOMMU_ENABLED_BY_DEFAULT
has been removed from the -mm tree.  Its filename was
     x86_64-fix-boot-hang-caused-by-calgary_iommu_enabled_by_default.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: x86_64: fix boot hang caused by CALGARY_IOMMU_ENABLED_BY_DEFAULT
From: Ingo Molnar <mingo@elte.hu>

One of my boxes didnt boot the 2.6.20-rc1-rt0 kernel rpm, it hung during
early bootup.  After an hour or two of happy debugging i narrowed it down
to the CALGARY_IOMMU_ENABLED_BY_DEFAULT option, which was freshly added to
2.6.20 via the x86_64 tree and /enabled by default/.

commit bff6547bb6a4e82c399d74e7fba78b12d2f162ed claims:

    [PATCH] Calgary: allow compiling Calgary in but not using it by default

    This patch makes it possible to compile Calgary in but not use it by
    default. In this mode, use 'iommu=calgary' to activate it.

but the change does not actually practice it:

 config CALGARY_IOMMU_ENABLED_BY_DEFAULT
        bool "Should Calgary be enabled by default?"
        default y
        depends on CALGARY_IOMMU
        help
          Should Calgary be enabled by default? if you choose 'y', Calgary
          will be used (if it exists). If you choose 'n', Calgary will not be
          used even if it exists. If you choose 'n' and would like to use
          Calgary anyway, pass 'iommu=calgary' on the kernel command line.
          If unsure, say Y.

It's both 'default y', and says "If unsure, say Y". Clearly not a typo.

Disabling this option makes my box boot again.  The patch below fixes the
Kconfig entry.  Grumble.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/Kconfig~x86_64-fix-boot-hang-caused-by-calgary_iommu_enabled_by_default arch/x86_64/Kconfig
--- a/arch/x86_64/Kconfig~x86_64-fix-boot-hang-caused-by-calgary_iommu_enabled_by_default
+++ a/arch/x86_64/Kconfig
@@ -480,14 +480,13 @@ config CALGARY_IOMMU
 
 config CALGARY_IOMMU_ENABLED_BY_DEFAULT
 	bool "Should Calgary be enabled by default?"
-	default y
 	depends on CALGARY_IOMMU
 	help
-	  Should Calgary be enabled by default? if you choose 'y', Calgary
+	  Should Calgary be enabled by default? If you choose 'y', Calgary
 	  will be used (if it exists). If you choose 'n', Calgary will not be
 	  used even if it exists. If you choose 'n' and would like to use
 	  Calgary anyway, pass 'iommu=calgary' on the kernel command line.
-	  If unsure, say Y.
+	  If unsure, say N.
 
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
_

Patches currently in -mm which might be from mingo@elte.hu are

conditionally-check-expected_preempt_count-in-__resched_legal.patch
sched-remove-__cpuinitdata-anotation-to-cpu_isolated_map.patch
genirq-fix-irq-flow-handler-uninstall.patch
lock-debugging-fix-debug_locks_warn_on-debug_locks_silent.patch
workqueue-fix-schedule_on_each_cpu.patch
__set_irq_handler-bogus-space.patch
x86_64-fix-boot-time-hang-in-detect_calgary.patch
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
x86_64-fix-boot-hang-caused-by-calgary_iommu_enabled_by_default.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
schedule_on_each_cpu-use-preempt_disable.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
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
clockevents-i386-hpet-driver.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
high-res-timers-core.patch
high-res-timers-core-do-itimer-rearming-in-process-context.patch
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
debugging-feature-sysrq-q-to-print-timers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
time-x86_64-hpet_address-cleanup.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
workqueue-dont-hold-workqueue_mutex-in-flush_scheduled_work.patch
sched-improve-efficiency-of-sched_fork.patch
sched-improve-efficiency-of-sched_fork-tidy.patch
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

