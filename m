From: akpm@linux-foundation.org
Subject: - atl1-use-spin_trylock_irqsave.patch removed from -mm tree
Date: Wed, 08 Aug 2007 12:07:47 -0700
Message-ID: <200708081907.l78J7l5F025795@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764579AbXHHTId (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Aug 2007 15:08:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, jacliburn@bellsouth.net, mm-commits@vger.kernel.org


The patch titled
     atl1: use spin_trylock_irqsave()
has been removed from the -mm tree.  Its filename was
     atl1-use-spin_trylock_irqsave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: atl1: use spin_trylock_irqsave()
From: Ingo Molnar <mingo@elte.hu>

use the simpler spin_trylock_irqsave() API to get the adapter lock.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/atl1/atl1_main.c |    4 +---
 1 files changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/net/atl1/atl1_main.c~atl1-use-spin_trylock_irqsave drivers/net/atl1/atl1_main.c
--- a/drivers/net/atl1/atl1_main.c~atl1-use-spin_trylock_irqsave
+++ a/drivers/net/atl1/atl1_main.c
@@ -1703,10 +1703,8 @@ static int atl1_xmit_frame(struct sk_buf
 		}
 	}
 
-	local_irq_save(flags);
-	if (!spin_trylock(&adapter->lock)) {
+	if (!spin_trylock_irqsave(&adapter->lock, flags)) {
 		/* Can't get lock - tell upper layer to requeue */
-		local_irq_restore(flags);
 		dev_printk(KERN_DEBUG, &adapter->pdev->dev, "tx locked\n");
 		return NETDEV_TX_LOCKED;
 	}
_

Patches currently in -mm which might be from mingo@elte.hu are

genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
fix-local_irq_-macro-definition-thinkos-for-the-trace_irqflags_support-case.patch
git-kvm.patch
mips-qemu-network-work-again.patch
git-netdev-all.patch
fix-theoretical-ccids_readwrite_lock-race.patch
git-sched.patch
kernel-schedc-make-code-static.patch
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
i386-convert-mm_context_t-semaphore-to-a-mutex.patch
futex_unlock_pi-hurts-my-brain-and-may-cause.patch
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
time-simplify-smp_call_function_single-call-sequence.patch
kernel-rtmutex-debugc-cleanups.patch
pi-futex-set-pf_exiting-without-taking-pi_lock.patch
do_sigaction-remove-now-unneeded-recalc_sigpending.patch
handle-the-multi-threaded-inits-exit-properly.patch
msleep-with-hrtimers.patch
wait_task_zombie-fix-2-3-races-vs-forget_original_parent.patch
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
