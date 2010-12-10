From: akpm@linux-foundation.org
Subject: + kthread-use-kthread_create_on_cpu.patch added to -mm tree
Date: Thu, 09 Dec 2010 16:45:00 -0800
Message-ID: <201012100045.oBA0j0Hd016994@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40937 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757629Ab0LJApO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Dec 2010 19:45:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, ak@linux.intel.com, davem@davemloft.net, dhowells@redhat.com, fenghua.yu@intel.com, linux-arch@vger.kernel.org, rusty@rustcorp.com.au, tj@kernel.org, tony.luck@intel.com


The patch titled
     kthread: use kthread_create_on_cpu()
has been added to the -mm tree.  Its filename is
     kthread-use-kthread_create_on_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthread: use kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>

ksoftirqd, kworker, migration, and pktgend kthreads can be created with
kthread_create_on_cpu(), to get proper NUMA affinities for their stack and
task_struct.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: David Howells <dhowells@redhat.com>
Cc: <linux-arch@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c      |    3 ++-
 kernel/stop_machine.c |    4 ++--
 kernel/workqueue.c    |    4 ++--
 net/core/pktgen.c     |    3 ++-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff -puN kernel/softirq.c~kthread-use-kthread_create_on_cpu kernel/softirq.c
--- a/kernel/softirq.c~kthread-use-kthread_create_on_cpu
+++ a/kernel/softirq.c
@@ -831,7 +831,8 @@ static int __cpuinit cpu_callback(struct
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create(run_ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
+		p = kthread_create_on_cpu(run_ksoftirqd, hcpu, hotcpu,
+					  "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
 			return notifier_from_errno(PTR_ERR(p));
diff -puN kernel/stop_machine.c~kthread-use-kthread_create_on_cpu kernel/stop_machine.c
--- a/kernel/stop_machine.c~kthread-use-kthread_create_on_cpu
+++ a/kernel/stop_machine.c
@@ -301,8 +301,8 @@ static int __cpuinit cpu_stop_cpu_callba
 	case CPU_UP_PREPARE:
 		BUG_ON(stopper->thread || stopper->enabled ||
 		       !list_empty(&stopper->works));
-		p = kthread_create(cpu_stopper_thread, stopper, "migration/%d",
-				   cpu);
+		p = kthread_create_on_cpu(cpu_stopper_thread, stopper, cpu,
+					  "migration/%d", cpu);
 		if (IS_ERR(p))
 			return notifier_from_errno(PTR_ERR(p));
 		get_task_struct(p);
diff -puN kernel/workqueue.c~kthread-use-kthread_create_on_cpu kernel/workqueue.c
--- a/kernel/workqueue.c~kthread-use-kthread_create_on_cpu
+++ a/kernel/workqueue.c
@@ -1318,8 +1318,8 @@ static struct worker *create_worker(stru
 	worker->id = id;
 
 	if (!on_unbound_cpu)
-		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/%u:%d", gcwq->cpu, id);
+		worker->task = kthread_create_on_cpu(worker_thread, worker, gcwq->cpu,
+						     "kworker/%u:%d", gcwq->cpu, id);
 	else
 		worker->task = kthread_create(worker_thread, worker,
 					      "kworker/u:%d", id);
diff -puN net/core/pktgen.c~kthread-use-kthread_create_on_cpu net/core/pktgen.c
--- a/net/core/pktgen.c~kthread-use-kthread_create_on_cpu
+++ a/net/core/pktgen.c
@@ -3811,7 +3811,8 @@ static int __init pktgen_create_thread(i
 	list_add_tail(&t->th_list, &pktgen_threads);
 	init_completion(&t->start_done);
 
-	p = kthread_create(pktgen_thread_worker, t, "kpktgend_%d", cpu);
+	p = kthread_create_on_cpu(pktgen_thread_worker, t, cpu,
+				  "kpktgend_%d", cpu);
 	if (IS_ERR(p)) {
 		pr_err("kernel_thread() failed for cpu %d\n", t->cpu);
 		list_del(&t->th_list);
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
linux-next.patch
irq-use-per_cpu-kstat_irqs.patch
timers-use-this_cpu_read.patch
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu.patch
include-asm-generic-vmlinuxldsh-make-readmostly-section-correctly-align.patch
percpu-add-new-macros-to-make-percpu-readmostly-section-correctly-align.patch
percpu-use-new-macros-for-x86-percpu-readmostly-section.patch

