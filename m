From: akpm@linux-foundation.org
Subject: [alternative-merged] cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch removed from -mm tree
Date: Wed, 01 Jun 2011 13:33:51 -0700
Message-ID: <201106012033.p51KXOLe008090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759180Ab1FAUdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2011 16:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, a.p.zijlstra@chello.nl, efault@gmx.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpumask: convert cpumask_of_cpu() to cpumask_of()
has been removed from the -mm tree.  Its filename was
     cpumask-convert-cpumask_of_cpu-to-cpumask_of.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpumask: convert cpumask_of_cpu() to cpumask_of()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Adapt the code to the new api fashion.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kthread.c~cpumask-convert-cpumask_of_cpu-to-cpumask_of kernel/kthread.c
--- a/kernel/kthread.c~cpumask-convert-cpumask_of_cpu-to-cpumask_of
+++ a/kernel/kthread.c
@@ -202,7 +202,7 @@ void kthread_bind(struct task_struct *p,
 		return;
 	}
 
-	p->cpus_allowed = cpumask_of_cpu(cpu);
+	cpumask_copy(&p->cpus_allowed, cpumask_of(cpu));
 	p->rt.nr_cpus_allowed = 1;
 	p->flags |= PF_THREAD_BOUND;
 }
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

