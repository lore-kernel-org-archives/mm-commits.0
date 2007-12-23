From: akpm@linux-foundation.org
Subject: + x86-fix-system-gate-related-crash.patch added to -mm tree
Date: Sun, 23 Dec 2007 12:26:45 -0800
Message-ID: <200712232027.lBNKR81m006459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481AbXLWU3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 23 Dec 2007 15:29:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu


The patch titled
     x86: fix system gate related crash
has been added to the -mm tree.  Its filename is
     x86-fix-system-gate-related-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -328,7 +328,11 @@ static inline void set_trap_gate(unsigne
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

origin.patch
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
kvm-ist-kaput.patch
pci-disable-decoding-during-sizing-of-bars.patch
git-sched.patch
git-sched-fixup.patch
git-sched-fix-preempt-rcu-on-non-preemptible-architectures.patch
git-x86.patch
git-x86-fixup.patch
git-x86-arch-x86-math-emu-errorsc-fix-printk-warnings.patch
git-x86-drivers-pnp-pnpbios-bioscallsc-build-fix.patch
git-x86-fix-doubly-merged-patch.patch
git-x86-export-leave_mm.patch
x86-fix-system-gate-related-crash.patch
arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5.patch
arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes.patch
arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes-checkpatch-fixes.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-cryptodev-fixup.patch
fix-rtc_aie-with-config_hpet_emulate_rtc.patch
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
avoid-overflows-in-kernel-timec.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
aout-move-stack_top-to-asm-processorh-fix.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
kernel-remove-fastcall-in-kernel.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
