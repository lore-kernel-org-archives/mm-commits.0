From: akpm@linux-foundation.org
Subject: [merged] kthread-use-kthread_create_on_cpu.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:47 -0700
Message-ID: <201103232037.p2NKbNc9028237__29867.7945429974$1300912743$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933394Ab1CWUiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.dumazet@gmail.com, ak@linux.intel.com, davem@davemloft.net, dhowells@redhat.com, fenghua.yu@intel.com, linux-arch@vger.kernel.org, rusty@rustcorp.com.au, tj@kernel.org, tony.luck


The patch titled
     kthread: use kthread_create_on_node()
has been removed from the -mm tree.  Its filename was
     kthread-use-kthread_create_on_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kthread: use kthread_create_on_node()
From: Eric Dumazet <eric.dumazet@gmail.com>

ksoftirqd, kworker, migration, and pktgend kthreads can be created with
kthread_create_on_node(), to get proper NUMA affinities for their stack and
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

 kernel/softirq.c      |    5 ++++-
 kernel/stop_machine.c |    6 ++++--
 kernel/workqueue.c    |    6 ++++--
 net/core/pktgen.c     |    5 ++++-
 4 files changed, 16 insertions(+), 6 deletions(-)

diff -puN kernel/softirq.c~kthread-use-kthread_create_on_cpu kernel/softirq.c
--- a/kernel/softirq.c~kthread-use-kthread_create_on_cpu
+++ a/kernel/softirq.c
@@ -845,7 +845,10 @@ static int __cpuinit cpu_callback(struct
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create(run_ksoftirqd, hcpu, "ksoftirqd/%d", hotcpu);
+		p = kthread_create_on_node(run_ksoftirqd,
+					   hcpu,
+					   cpu_to_node(hotcpu),
+					   "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
 			return notifier_from_errno(PTR_ERR(p));
diff -puN kernel/stop_machine.c~kthread-use-kthread_create_on_cpu kernel/stop_machine.c
--- a/kernel/stop_machine.c~kthread-use-kthread_create_on_cpu
+++ a/kernel/stop_machine.c
@@ -301,8 +301,10 @@ static int __cpuinit cpu_stop_cpu_callba
 	case CPU_UP_PREPARE:
 		BUG_ON(stopper->thread || stopper->enabled ||
 		       !list_empty(&stopper->works));
-		p = kthread_create(cpu_stopper_thread, stopper, "migration/%d",
-				   cpu);
+		p = kthread_create_on_node(cpu_stopper_thread,
+					   stopper,
+					   cpu_to_node(cpu),
+					   "migration/%d", cpu);
 		if (IS_ERR(p))
 			return notifier_from_errno(PTR_ERR(p));
 		get_task_struct(p);
diff -puN kernel/workqueue.c~kthread-use-kthread_create_on_cpu kernel/workqueue.c
--- a/kernel/workqueue.c~kthread-use-kthread_create_on_cpu
+++ a/kernel/workqueue.c
@@ -1366,8 +1366,10 @@ static struct worker *create_worker(stru
 	worker->id = id;
 
 	if (!on_unbound_cpu)
-		worker->task = kthread_create(worker_thread, worker,
-					      "kworker/%u:%d", gcwq->cpu, id);
+		worker->task = kthread_create_on_node(worker_thread,
+						      worker,
+						      cpu_to_node(gcwq->cpu),
+						      "kworker/%u:%d", gcwq->cpu, id);
 	else
 		worker->task = kthread_create(worker_thread, worker,
 					      "kworker/u:%d", id);
diff -puN net/core/pktgen.c~kthread-use-kthread_create_on_cpu net/core/pktgen.c
--- a/net/core/pktgen.c~kthread-use-kthread_create_on_cpu
+++ a/net/core/pktgen.c
@@ -3761,7 +3761,10 @@ static int __init pktgen_create_thread(i
 	list_add_tail(&t->th_list, &pktgen_threads);
 	init_completion(&t->start_done);
 
-	p = kthread_create(pktgen_thread_worker, t, "kpktgend_%d", cpu);
+	p = kthread_create_on_node(pktgen_thread_worker,
+				   t,
+				   cpu_to_node(cpu),
+				   "kpktgend_%d", cpu);
 	if (IS_ERR(p)) {
 		pr_err("kernel_thread() failed for cpu %d\n", t->cpu);
 		list_del(&t->th_list);
_

Patches currently in -mm which might be from eric.dumazet@gmail.com are

origin.patch
net-convert-%p-usage-to-%pk.patch

