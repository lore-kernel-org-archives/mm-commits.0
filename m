From: akpm@linux-foundation.org
Subject: + atl1-use-spin_trylock_irqsave.patch added to -mm tree
Date: Wed, 01 Aug 2007 15:25:29 -0700
Message-ID: <200708012225.l71MPTb7020580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52826 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453AbXHAWZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2007 18:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, jacliburn@bellsouth.net


The patch titled
     atl1: use spin_trylock_irqsave()
has been added to the -mm tree.  Its filename is
     atl1-use-spin_trylock_irqsave.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
genirq-temporary-fix-for-level-triggered-irq-resend.patch
genirq-temporary-fix-for-level-triggered-irq-resend-fix.patch
git-acpi.patch
git-kvm.patch
mips-qemu-network-work-again.patch
atl1-use-spin_trylock_irqsave.patch
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
