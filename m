From: akpm@linux-foundation.org
Subject: - x86-fix-system-gate-related-crash.patch removed from -mm tree
Date: Thu, 17 Jan 2008 01:49:33 -0800
Message-ID: <200801170949.m0H9nDVf019428@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52645 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132AbYAQJtn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jan 2008 04:49:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86: fix system gate related crash
has been removed from the -mm tree.  Its filename was
     x86-fix-system-gate-related-crash.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix system gate related crash
From: Ingo Molnar <mingo@elte.hu>

on 32-bit, system gates are traps.

on 64-bit, they are interrupts (which disable hardirqs).

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/desc.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/asm-x86/desc.h~x86-fix-system-gate-related-crash include/asm-x86/desc.h
--- a/include/asm-x86/desc.h~x86-fix-system-gate-related-crash
+++ a/include/asm-x86/desc.h
@@ -332,7 +332,11 @@ static inline void set_trap_gate(unsigne
 static inline void set_system_gate(unsigned int n, void *addr)
 {
 	BUG_ON((unsigned)n > 0xFF);
+#ifdef CONFIG_X86_32
+	_set_gate(n, GATE_TRAP, addr, 0x3, 0, __KERNEL_CS);
+#else
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
+#endif
 }
 
 static inline void set_task_gate(unsigned int n, unsigned int gdt_entry)
_

Patches currently in -mm which might be from mingo@elte.hu are

cpufreq-initialise-default-governor-before-use.patch
mm-fix-section-mismatch-warning-in-page_allocc.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
git-alsa.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fixup.patch
revert-kvm-stuff-to-make-git-x86-apply.patch
git-x86.patch
git-x86-fixup.patch
git-x86-fixup-2.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
x86-fix-system-gate-related-crash.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-cryptodev-fixup.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
fix-proc-dcache-deadlock-in-do_exit.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
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
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
documentation-create-new-scheduler-subdirectory.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-make-module_address_lookup-safe.patch
modules-make-module_address_lookup-safe-fix.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
efi-split-efi-tables-parsing-code-from-efi-runtime-service-support-code.patch
dont-error-on-higher-hz-values.patch
asm-posix_typesh-scrub-__glibc__.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
