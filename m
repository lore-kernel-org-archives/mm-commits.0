From: akpm@linux-foundation.org
Subject: - pci-hotplug-cpqphp_ctrlc-remove-stale-bkl-use.patch removed from -mm tree
Date: Tue, 31 Jul 2007 13:30:13 -0700
Message-ID: <200707312030.l6VKUDYC020954@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36447 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932719AbXGaUbN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 16:31:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     pci/hotplug/cpqphp_ctrl.c: remove stale BKL use
has been removed from the -mm tree.  Its filename was
     pci-hotplug-cpqphp_ctrlc-remove-stale-bkl-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pci/hotplug/cpqphp_ctrl.c: remove stale BKL use
From: Ingo Molnar <mingo@elte.hu>

Remove stale BKL use from drivers/pci/hotplug/cpqphp_ctrl.c.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/cpqphp_ctrl.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/pci/hotplug/cpqphp_ctrl.c~pci-hotplug-cpqphp_ctrlc-remove-stale-bkl-use drivers/pci/hotplug/cpqphp_ctrl.c
--- a/drivers/pci/hotplug/cpqphp_ctrl.c~pci-hotplug-cpqphp_ctrlc-remove-stale-bkl-use
+++ a/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -1746,10 +1746,8 @@ static void pushbutton_helper_thread(uns
 static int event_thread(void* data)
 {
 	struct controller *ctrl;
-	lock_kernel();
+
 	daemonize("phpd_event");
-	
-	unlock_kernel();
 
 	while (1) {
 		dbg("!!!!event_thread sleeping\n");
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
sched-fix-kernel-doc-warnings.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
futex-pass-nr_wake2-to-futex_wake_op.patch
genirq-temporary-fix-for-level-triggered-irq-resend.patch
genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
git-acpi.patch
git-kvm.patch
mips-qemu-network-work-again.patch
fix-theoretical-ccids_readwrite_lock-race.patch
kernel-schedc-make-code-static.patch
tiny-sched_getaffinity-cleanup.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
i386-remove-unnecessary-code.patch
x86-expand-proc-interrupts-to-include-missing-vectors-v2.patch
x86-expand-proc-interrupts-to-include-missing-vectors-v2-fix.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
remove-workaround-for-unimmunized-rcu_dereference-from-mce_log.patch
softlockup-use-cpu_clock-instead-of-sched_clock.patch
fix-the-softlockup-watchdog-to-actually-work.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
softlockup-improve-debug-output.patch
softlockup-watchdog-style-cleanups.patch
softlockup-add-a-proc-tuning-parameter.patch
softlockup-add-a-proc-tuning-parameter-fix.patch
cfs-mark-print_cfs_stats-static.patch
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
mm-implement-swap-prefetching.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
