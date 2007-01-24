From: akpm@osdl.org
Subject: + acpi-fix-cpufreq-regression.patch added to -mm tree
Date: Tue, 23 Jan 2007 20:11:43 -0800
Message-ID: <200701240411.l0O4BhI3008016@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:50450 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965635AbXAXENd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 23:13:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, davej@redhat.com, lenb@kernel.org


The patch titled
     ACPI: fix cpufreq regression
has been added to the -mm tree.  Its filename is
     acpi-fix-cpufreq-regression.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: fix cpufreq regression
From: Ingo Molnar <mingo@elte.hu>

Recently cpufreq support on my laptop (Lenovo T60) broke completely: when
it's plugged into AC it would never go higher than 1 GHz - neither 1.3 GHz
nor 1.83 GHz is possible - no matter which governor (userspace, speed or
ondemand) is used.

After some cpufreq debugging i tracked the regression back to the following
(totally correct) bug-fix commit:

   commit 0916bd3ebb7cefdd0f432e8491abe24f4b5a101e
   Author: Dave Jones <davej@redhat.com>
   Date:   Wed Nov 22 20:42:01 2006 -0500

    [PATCH] Correct bound checking from the value returned from _PPC method.

This bugfix, which makes other laptops work, made a previously hidden
(BIOS) bug visible on my laptop.

The bug is the following: if the _PPC (Performance Present Capabilities)
optional ACPI object is queried /after/ bootup then the BIOS reports an
incorrect value of '2'.

My laptop (Lenovo T60) has the following performance states supported:

   0: 1833000
   1: 1333000
   2: 1000000

Per ACPI specification, a _PPC value of '0' means that all 3 performance
states are usable.  A _PPC value of '1' means states 1 ..  2 are usable, a
value of '2' means only state '2' (slowest) is usable.

now, the _PPC object is optional, and it also comes with notification. 
Furthermore, when a CPU object is initialized, the _PPC object is
initialized as well.  So the following evaluation of the _PPC object is
superfluous:

 [<c028ba5f>] acpi_processor_get_platform_limit+0xa1/0xaf
 [<c028c040>] acpi_processor_register_performance+0x3b9/0x3ef
 [<c0111a85>] acpi_cpufreq_cpu_init+0xb7/0x596
 [<c03dab74>] cpufreq_add_dev+0x160/0x4a8
 [<c02bed90>] sysdev_driver_register+0x5a/0xa0
 [<c03d9c4c>] cpufreq_register_driver+0xb4/0x176
 [<c068ac08>] acpi_cpufreq_init+0xe5/0xeb
 [<c010056e>] init+0x14f/0x3dd

And this is the point where my laptop's BIOS returns the incorrect value of
'2'.  Note that it has not sent any notification event, so the value is
probably not really intentional (possibly spurious), and Windows likely
doesnt query it after bootup either.  Maybe the value is kept at '2'
normally, and is only set to the real value when a true asynchronous event
(such as AC plug event, battery switch, etc.) occurs.

So i /think/ this is a grey area of the ACPI spec: per the letter of the
spec the _PPC value only changes when notified, so there's no reason to
query it after the system has booted up.  So in my opinion the best (and
most compatible) strategy would be to do the change below, and to not
evaluate the _PPC object in the acpi_processor_get_performance_info() call,
but only evaluate it if _PPC is present during CPU object init, or if it's
notified during an asynchronous event.  This change is more permissive than
the previous logic, so it definitely shouldnt break any existing system.

This also happens to fix my laptop, which is merrily chugging along at
1.83 GHz now. Yay!

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/acpi/processor_perflib.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN drivers/acpi/processor_perflib.c~acpi-fix-cpufreq-regression drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c~acpi-fix-cpufreq-regression
+++ a/drivers/acpi/processor_perflib.c
@@ -322,10 +322,6 @@ static int acpi_processor_get_performanc
 	if (result)
 		return result;
 
-	result = acpi_processor_get_platform_limit(pr);
-	if (result)
-		return result;
-
 	return 0;
 }
 
_

Patches currently in -mm which might be from mingo@elte.hu are

kvm-add-vm-exit-profiling-fix.patch
revert-nmi_known_cpu-check-during-boot-option-parsing.patch
paravirt-mark-the-paravirt_ops-export-internal.patch
kvm-make-sure-there-is-a-vcpu-context-loaded-when.patch
kvm-fix-race-between-mmio-reads-and-injected-interrupts.patch
kvm-x86-emulator-fix-bit-string-instructions.patch
kvm-fix-bogus-pagefault-on-writable-pages.patch
fix-config_compat_vdso.patch
fix-gate_vmavm_flags.patch
add-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump.patch
i386-vdso-use-vm_alwaysdump-tidy.patch
x86_64-ia32-vdso-use-vm_alwaysdump.patch
powerpc-vdso-use-vm_alwaysdump.patch
x86_64-ia32-vdso-define-arch_vma_name.patch
acpi-fix-cpufreq-regression.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
add-install_special_mapping.patch
i386-vdso-use-install_special_mapping.patch
x86_64-ia32-vdso-use-install_special_mapping.patch
powerpc-vdso-use-install_special_mapping.patch
acpi-i686-x86_64-fix-laptop-bootup-hang-in-init_acpi.patch
fix-for-crash-in-adummy_init.patch
fix-x86_64-mm-convert-i386-pda-code-to-use-%fs.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
spin_lock_irq-enable-interrupts-while-spinning-preparatory-patch.patch
spin_lock_irq-enable-interrupts-while-spinning-x86_64-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix.patch
spin_lock_irq-enable-interrupts-while-spinning-i386-implementation-fix-fix.patch
i386-kwatch-kernel-watchpoints-using-cpu-debug-registers.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
lockdep-also-check-for-freed-locks-in-kmem_cache_free.patch
lockdep-more-unlock-on-error-fixes.patch
lockdep-more-unlock-on-error-fixes-fix.patch
lockdep-add-graph-depth-information-to-proc-lockdep.patch
consolidate-default-sched_clock.patch
use-cycle_t-instead-of-u64-in-struct-time_interpolator.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
audit-fix-audit_filter_user_rules-initialization-bug.patch
gtod-uninline-jiffiesh.patch
gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
gtod-fix-timeout-overflow.patch
gtod-persistent-clock-support-core.patch
gtod-persistent-clock-support-i386.patch
dynticks-uninline-irq_enter.patch
dynticks-extend-next_timer_interrupt-to-use-a-reference-jiffie.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-namespace-and-enum-cleanup-vs-git-input.patch
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
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
schedule_on_each_cpu-use-preempt_disable.patch
fsaio-add-a-wait-queue-arg-to-the-wait_bit-action-routine.patch
fsaio-rename-__lock_page-to-lock_page_blocking.patch
fsaio-interfaces-to-initialize-and-to-test-a-wait-bit-key.patch
fsaio-add-a-default-io-wait-bit-field-in-task-struct.patch
fsaio-enable-wait-bit-based-filtered-wakeups-to-work-for-aio.patch
fsaio-enable-asynchronous-wait-page-and-lock-page.patch
fsaio-filesystem-aio-read.patch
fsaio-aio-o_sync-filesystem-write.patch
aio-is-unlikely.patch
sched-avoid-div-in-rebalance_tick.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
sched-cleanup-remove-task_t-convert-to-struct-task_struct-prefetch.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups.patch
scheduled-removal-of-sa_xxx-interrupt-flags-fixups-2.patch
scheduled-removal-of-sa_xxx-interrupt-flags.patch
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
