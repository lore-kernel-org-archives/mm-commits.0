From: akpm@linux-foundation.org
Subject: - acpi-default-unmap-fixpatch.patch removed from -mm tree
Date: Tue, 05 Feb 2008 00:01:29 -0800
Message-ID: <200802050801.m1581ApC011112@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43907 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754874AbYBEIBZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 03:01:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     acpi-default-unmap-fix.patch
has been removed from the -mm tree.  Its filename was
     acpi-default-unmap-fixpatch.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi-default-unmap-fix.patch
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/osl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/acpi/osl.c~acpi-default-unmap-fixpatch drivers/acpi/osl.c
--- a/drivers/acpi/osl.c~acpi-default-unmap-fixpatch
+++ a/drivers/acpi/osl.c
@@ -287,6 +287,15 @@ acpi_os_map_memory(acpi_physical_address
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
+/*
+ * Architectures can provide an unmap method - but for most this NOP
+ * will be fine because they use state-less __va() for mapping, which
+ * needs no unmap component:
+ */
+void __attribute__((weak)) __acpi_unmap_table (void * addr, unsigned long size)
+{
+}
+
 void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
 {
 	if (acpi_gbl_permanent_mmap) {
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
kvm-i386-fix.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
fix-proc-dcache-deadlock-in-do_exit.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-x86.patch
git-x86-fix-git-conflicts.patch
deprecate-find_task_by_pid-kgdb.patch
acpi-default-unmap-fixpatch.patch
x86-amd-thermal-interrupt-support.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
read_current_time-cleanups.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
unix98-allocated_ptys_lock-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex.patch
stopmachine-semaphore-to-mutex-fix.patch
calibrate_delay-must-be-__cpuinit.patch
idle_regs-must-be-__cpuinit.patch
debug_smp_processor_id-fixlets.patch
make-sys_poll-wait-at-least-timeout-ms.patch
system-timer-fix-crash-in-100hz-system-timer.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos-fix.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
documentation-create-new-scheduler-subdirectory.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
d_path-make-d_path-use-a-struct-path-fix.patch
proc-fix-the-threaded-proc-self.patch
modules-make-module_address_lookup-safe-fix.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
asm-posix_typesh-scrub-__glibc__.patch
use-find_task_by_vpid-in-posix-timers.patch
dont-operate-with-pid_t-in-rtmutex-tester.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
