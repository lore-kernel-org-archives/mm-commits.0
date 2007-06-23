From: akpm@linux-foundation.org
Subject: - sched-fix-sysrq-n-normalize-rt-tasks.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:27:54 -0700
Message-ID: <200706231927.l5NJRsZ4022098@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351AbXFWTev (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:34:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, gene.heskett@gmail.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sched: fix SysRq-N (normalize RT tasks)
has been removed from the -mm tree.  Its filename was
     sched-fix-sysrq-n-normalize-rt-tasks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sched: fix SysRq-N (normalize RT tasks)
From: Ingo Molnar <mingo@elte.hu>

Gene Heskett reported the following problem while testing CFS: SysRq-N is
not always effective in normalizing tasks back to SCHED_OTHER.

The reason for that turns out to be the following bug: normalize_rt_tasks()
uses for_each_process() to iterate through all tasks in the system.  The
problem is, this method does not iterate through all tasks, it iterates
through all thread groups.  The proper mechanism to enumerate all tasks is
to use a do_each_thread() + while_each_thread() loop.

Reported-by: Gene Heskett <gene.heskett@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/sched.c~sched-fix-sysrq-n-normalize-rt-tasks kernel/sched.c
--- a/kernel/sched.c~sched-fix-sysrq-n-normalize-rt-tasks
+++ a/kernel/sched.c
@@ -7071,12 +7071,13 @@ EXPORT_SYMBOL(__might_sleep);
 void normalize_rt_tasks(void)
 {
 	struct prio_array *array;
-	struct task_struct *p;
+	struct task_struct *g, *p;
 	unsigned long flags;
 	struct rq *rq;
 
 	read_lock_irq(&tasklist_lock);
-	for_each_process(p) {
+
+	do_each_thread(g, p) {
 		if (!rt_task(p))
 			continue;
 
@@ -7094,7 +7095,8 @@ void normalize_rt_tasks(void)
 
 		__task_rq_unlock(rq);
 		spin_unlock_irqrestore(&p->pi_lock, flags);
-	}
+	} while_each_thread(g, p);
+
 	read_unlock_irq(&tasklist_lock);
 }
 
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
sched-fix-next_interval-determination-in-idle_balance.patch
git-acpi-add-exports.patch
git-kvm.patch
git-selinux.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
only-allow-nonlinear-vmas-for-ram-backed-filesystems.patch
cpuset-remove-sched-domain-hooks-from-cpusets.patch
introduce-write_trylock_irqsave.patch
use-write_trylock_irqsave-in-ptrace_attach.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
pie-randomization.patch
vdso-print-fatal-signals.patch
remove-clockevents_releaserequest_device.patch
add-a-flag-to-indicate-deferrable-timers-in-proc-timer_stats.patch
introduce-o_cloexec-take-2.patch
introduce-o_cloexec-parisc-fix.patch
o_cloexec-for-scm_rights.patch
o_cloexec-for-scm_rights-fix.patch
o_cloexec-for-scm_rights-fix-2.patch
improve-behaviour-of-spurious-irq-detect.patch
improve-behaviour-of-spurious-irq-detect-fix.patch
allow-softlockup-to-be-runtime-disabled.patch
cfs-scheduler.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-v14-rc2-mm1.patch
cfs-scheduler-warning-fixes.patch
cfs-scheduler-v15-rc3-mm1.patch
fs-proc-basec-make-a-struct-static.patch
cfs-warning-fixes.patch
schedstats-fix-printk-format.patch
cfs-scheduler-v16.patch
sched-add-above-background-load-function.patch
mm-implement-swap-prefetching.patch
fix-raw_spinlock_t-vs-lockdep.patch
lockdep-sanitise-config_prove_locking.patch
lockdep-reduce-the-ifdeffery.patch
lockstat-core-infrastructure.patch
lockstat-core-infrastructure-fix.patch
lockstat-core-infrastructure-fix-fix.patch
lockstat-core-infrastructure-fix-fix-fix.patch
lockstat-human-readability-tweaks.patch
lockstat-hook-into-spinlock_t-rwlock_t-rwsem-and-mutex.patch
lockdep-various-fixes.patch
lockdep-various-fixes-checkpatch.patch
lockdep-fixup-sk_callback_lock-annotation.patch
lockstat-measure-lock-bouncing.patch
lockstat-measure-lock-bouncing-checkpatch.patch
lockstat-better-class-name-representation.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
random-warning-squishes.patch
