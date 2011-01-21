From: akpm@linux-foundation.org
Subject: + kthread-use-kthread_create_on_cpu-update.patch added to -mm tree
Date: Fri, 21 Jan 2011 14:32:37 -0800
Message-ID: <201101212232.p0LMWbVD004904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39114 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522Ab1AUWdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Jan 2011 17:33:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eric.dumazet@gmail.com, andi@firstfloor.org, davem@davemloft.net, rusty@rustcorp.com.au, tj@kernel.org


The patch titled
     kthread-numa-aware-kthread_create_on_cpu-update
has been added to the -mm tree.  Its filename is
     kthread-use-kthread_create_on_cpu-update.patch

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
Subject: kthread-numa-aware-kthread_create_on_cpu-update
From: Eric Dumazet <eric.dumazet@gmail.com>

People told me kthread_create_on_cpu() was a wrong name and prefer
kthread_create_on_node()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softirq.c      |    6 ++++--
 kernel/stop_machine.c |    6 ++++--
 kernel/workqueue.c    |    6 ++++--
 net/core/pktgen.c     |    6 ++++--
 4 files changed, 16 insertions(+), 8 deletions(-)

diff -puN kernel/softirq.c~kthread-use-kthread_create_on_cpu-update kernel/softirq.c
--- a/kernel/softirq.c~kthread-use-kthread_create_on_cpu-update
+++ a/kernel/softirq.c
@@ -831,8 +831,10 @@ static int __cpuinit cpu_callback(struct
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		p = kthread_create_on_cpu(run_ksoftirqd, hcpu, hotcpu,
-					  "ksoftirqd/%d", hotcpu);
+		p = kthread_create_on_node(run_ksoftirqd,
+					   hcpu,
+					   cpu_to_node(hotcpu),
+					   "ksoftirqd/%d", hotcpu);
 		if (IS_ERR(p)) {
 			printk("ksoftirqd for %i failed\n", hotcpu);
 			return notifier_from_errno(PTR_ERR(p));
diff -puN kernel/stop_machine.c~kthread-use-kthread_create_on_cpu-update kernel/stop_machine.c
--- a/kernel/stop_machine.c~kthread-use-kthread_create_on_cpu-update
+++ a/kernel/stop_machine.c
@@ -301,8 +301,10 @@ static int __cpuinit cpu_stop_cpu_callba
 	case CPU_UP_PREPARE:
 		BUG_ON(stopper->thread || stopper->enabled ||
 		       !list_empty(&stopper->works));
-		p = kthread_create_on_cpu(cpu_stopper_thread, stopper, cpu,
-					  "migration/%d", cpu);
+		p = kthread_create_on_node(cpu_stopper_thread,
+					   stopper,
+					   cpu_to_node(cpu),
+					   "migration/%d", cpu);
 		if (IS_ERR(p))
 			return notifier_from_errno(PTR_ERR(p));
 		get_task_struct(p);
diff -puN kernel/workqueue.c~kthread-use-kthread_create_on_cpu-update kernel/workqueue.c
--- a/kernel/workqueue.c~kthread-use-kthread_create_on_cpu-update
+++ a/kernel/workqueue.c
@@ -1356,8 +1356,10 @@ static struct worker *create_worker(stru
 	worker->id = id;
 
 	if (!on_unbound_cpu)
-		worker->task = kthread_create_on_cpu(worker_thread, worker, gcwq->cpu,
-						     "kworker/%u:%d", gcwq->cpu, id);
+		worker->task = kthread_create_on_node(worker_thread,
+						      worker,
+						      cpu_to_node(gcwq->cpu),
+						      "kworker/%u:%d", gcwq->cpu, id);
 	else
 		worker->task = kthread_create(worker_thread, worker,
 					      "kworker/u:%d", id);
diff -puN net/core/pktgen.c~kthread-use-kthread_create_on_cpu-update net/core/pktgen.c
--- a/net/core/pktgen.c~kthread-use-kthread_create_on_cpu-update
+++ a/net/core/pktgen.c
@@ -3812,8 +3812,10 @@ static int __init pktgen_create_thread(i
 	list_add_tail(&t->th_list, &pktgen_threads);
 	init_completion(&t->start_done);
 
-	p = kthread_create_on_cpu(pktgen_thread_worker, t, cpu,
-				  "kpktgend_%d", cpu);
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
mm-numa-aware-alloc_task_struct_node.patch
mm-numa-aware-alloc_thread_info_node.patch
kthread-numa-aware-kthread_create_on_cpu.patch
kthread-numa-aware-kthread_create_on_cpu-update.patch
kthread-use-kthread_create_on_cpu.patch
kthread-use-kthread_create_on_cpu-update.patch
net-convert-%p-usage-to-%pk.patch

