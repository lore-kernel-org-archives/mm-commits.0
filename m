From: akpm@linux-foundation.org
Subject: - signalfd-fix-undefined-reference-to-compat_sys_signalfd4.patch removed from -mm tree
Date: Fri, 25 Jul 2008 19:12:40 -0700
Message-ID: <200807260212.m6Q2CegE010825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125AbYGZCMy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 22:12:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     signalfd: fix undefined reference to `compat_sys_signalfd4'
has been removed from the -mm tree.  Its filename was
     signalfd-fix-undefined-reference-to-compat_sys_signalfd4.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signalfd: fix undefined reference to `compat_sys_signalfd4'
From: Ingo Molnar <mingo@elte.hu>

fix:

arch/x86/ia32/built-in.o: In function `ia32_sys_call_table':
(.rodata+0xa38): undefined reference to `compat_sys_signalfd4'

on !CONFIG_SIGNALFD.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys_ni.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/sys_ni.c~signalfd-fix-undefined-reference-to-compat_sys_signalfd4 kernel/sys_ni.c
--- a/kernel/sys_ni.c~signalfd-fix-undefined-reference-to-compat_sys_signalfd4
+++ a/kernel/sys_ni.c
@@ -160,6 +160,7 @@ cond_syscall(sys_ioprio_get);
 cond_syscall(sys_signalfd);
 cond_syscall(sys_signalfd4);
 cond_syscall(compat_sys_signalfd);
+cond_syscall(compat_sys_signalfd4);
 cond_syscall(sys_timerfd_create);
 cond_syscall(sys_timerfd_settime);
 cond_syscall(sys_timerfd_gettime);
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
hugetlb-fix-config_sysctl=n-build.patch
dma-mapping-add-the-device-argument-to-dma_mapping_error.patch
x86-calgary-fix-handling-of-devices-that-arent-behind-the-calgary.patch
kexec-jump.patch
kexec-jump-save-restore-device-state.patch
x86-implement-pte_special.patch
mm-introduce-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
use-warn-in-kernel-irq-managec.patch
use-warn-in-kernel-irq-chipc.patch
tracehook-add-linux-tracehookh.patch
tracehook-exec.patch
tracehook-unexport-ptrace_notify.patch
tracehook-exit.patch
tracehook-clone.patch
tracehook-vfork-done.patch
tracehook-release_task.patch
tracehook-tracehook_tracer_task.patch
tracehook-tracehook_expect_breakpoints.patch
tracehook-tracehook_signal_handler.patch
tracehook-tracehook_consider_ignored_signal.patch
tracehook-tracehook_consider_fatal_signal.patch
tracehook-syscall.patch
tracehook-get_signal_to_deliver.patch
tracehook-job-control.patch
tracehook-death.patch
tracehook-force-signal_pending.patch
tracehook-tif_notify_resume.patch
tracehook-asm-syscallh.patch
tracehook-config_have_arch_tracehook.patch
tracehook-wait_task_inactive.patch
task_current_syscall.patch
proc-pid-syscall.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
x86-use-generic-show_mem.patch
linux-next.patch
linux-next-fixups.patch
x86-pci-replace-dbg-with-pr_debug.patch
x86-pci-replace-dbg-with-pr_debug-fix.patch
x86-pci-replace-dbg-with-pr_debug-fix-2.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
x86-remove-init_mm-export-as-planned-for-2626.patch
include-asm-generic-pgtable-nopmdh-macros-are-noxious-reason-435.patch
arch-x86-pci-i386c-fix-printk-warnings.patch
migrate_timers-add-comment-use-spinlock_irq.patch
firmware-fix-memmap-printk-format-warnings.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
aes-x86_64-asm-implementation-optimization.patch
cpufreq-acpi-only-call-_ppc-after-cpufreq-acpi-init-funcs-got-called-already.patch
acpi-cpufreq-cleanup-move-bailing-out-of-function-before-locking-the-mutex.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
clocksource-keep-track-of-original-clocksource-frequency.patch
clocksource-introduce-clocksource_forward_now.patch
clocksource-introduce-clock_monotonic_raw.patch
mmu-notifiers-add-list_del_init_rcu.patch
use-warn-in-kernel-lockdepc.patch
use-warn-in-arch-x86-mm-ioremapc.patch
use-warn-in-arch-x86-mm-pageattrc.patch
use-warn-in-arch-x86-kernel.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
likely-profiling-disable-ftrace.patch

