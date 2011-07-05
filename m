From: akpm@linux-foundation.org
Subject: [merged] stop_machine-reorganize-stop_cpus-implementation.patch removed from -mm tree
Date: Tue, 05 Jul 2011 12:59:17 -0700
Message-ID: <201107051958.p65JwrZ0020569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39440 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753909Ab1GET7M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jul 2011 15:59:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     stop_machine: reorganize stop_cpus() implementation
has been removed from the -mm tree.  Its filename was
     stop_machine-reorganize-stop_cpus-implementation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stop_machine: reorganize stop_cpus() implementation
From: Tejun Heo <tj@kernel.org>

Refactor the queuing part of the stop cpus work from __stop_cpus() into
queue_stop_cpus_work().

The reorganization is to help future improvements to stop_machine() and
doesn't introduce any behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN kernel/stop_machine.c~stop_machine-reorganize-stop_cpus-implementation kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-reorganize-stop_cpus-implementation
+++ a/kernel/stop_machine.c
@@ -136,10 +136,11 @@ DEFINE_MUTEX(stop_cpus_mutex);
 /* static data for stop_cpus */
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
-int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+static void queue_stop_cpus_work(const struct cpumask *cpumask,
+				 cpu_stop_fn_t fn, void *arg,
+				 struct cpu_stop_done *done)
 {
 	struct cpu_stop_work *work;
-	struct cpu_stop_done done;
 	unsigned int cpu;
 
 	/* initialize works and done */
@@ -147,9 +148,8 @@ int __stop_cpus(const struct cpumask *cp
 		work = &per_cpu(stop_cpus_work, cpu);
 		work->fn = fn;
 		work->arg = arg;
-		work->done = &done;
+		work->done = done;
 	}
-	cpu_stop_init_done(&done, cpumask_weight(cpumask));
 
 	/*
 	 * Disable preemption while queueing to avoid getting
@@ -161,7 +161,15 @@ int __stop_cpus(const struct cpumask *cp
 		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
 				    &per_cpu(stop_cpus_work, cpu));
 	preempt_enable();
+}
 
+static int __stop_cpus(const struct cpumask *cpumask,
+		       cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_done done;
+
+	cpu_stop_init_done(&done, cpumask_weight(cpumask));
+	queue_stop_cpus_work(cpumask, fn, arg, &done);
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
 }
_

Patches currently in -mm which might be from tj@kernel.org are

linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
devres-fix-possible-use-after-free.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update.patch
scatterlist-new-helper-functions-update-fix.patch

