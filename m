From: akpm@linux-foundation.org
Subject: [merged] kthread-ensure-locality-of-task_struct-allocations.patch removed from -mm tree
Date: Fri, 04 Apr 2014 12:29:22 -0700
Message-ID: <533f0812.jQ2It+txczOqubcN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaDDT3X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, tglx@linutronix.de, rientjes@google.com, penguin-kernel@I-love.SAKURA.ne.jp, oleg@redhat.com, liwanp@linux.vnet.ibm.com, jack@suse.cz, iamjoonsoo.kim@lge.com, cl@linux.com, benh@kernel.crashing.org, anton@samba.org, nacc@linux.vnet.ibm.com

Subject: [merged] kthread-ensure-locality-of-task_struct-allocations.patch removed from -mm tree
To: nacc@linux.vnet.ibm.com,anton@samba.org,benh@kernel.crashing.org,cl@linux.com,iamjoonsoo.kim@lge.com,jack@suse.cz,liwanp@linux.vnet.ibm.com,oleg@redhat.com,penguin-kernel@I-love.SAKURA.ne.jp,rientjes@google.com,tglx@linutronix.de,tj@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:22 -0700


The patch titled
     Subject: kthread: ensure locality of task_struct allocations
has been removed from the -mm tree.  Its filename was
     kthread-ensure-locality-of-task_struct-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Subject: kthread: ensure locality of task_struct allocations

In the presence of memoryless nodes, numa_node_id() will return the
current CPU's NUMA node, but that may not be where we expect to allocate
from memory from.  Instead, we should rely on the fallback code in the
memory allocator itself, by using NUMA_NO_NODE.  Also, when calling
kthread_create_on_node(), use the nearest node with memory to the cpu in
question, rather than the node it is running on.

Signed-off-by: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kthread.c~kthread-ensure-locality-of-task_struct-allocations kernel/kthread.c
--- a/kernel/kthread.c~kthread-ensure-locality-of-task_struct-allocations
+++ a/kernel/kthread.c
@@ -217,7 +217,7 @@ int tsk_fork_get_node(struct task_struct
 	if (tsk == kthreadd_task)
 		return tsk->pref_node_fork;
 #endif
-	return numa_node_id();
+	return NUMA_NO_NODE;
 }
 
 static void create_kthread(struct kthread_create_info *create)
@@ -369,7 +369,7 @@ struct task_struct *kthread_create_on_cp
 {
 	struct task_struct *p;
 
-	p = kthread_create_on_node(threadfn, data, cpu_to_node(cpu), namefmt,
+	p = kthread_create_on_node(threadfn, data, cpu_to_mem(cpu), namefmt,
 				   cpu);
 	if (IS_ERR(p))
 		return p;
_

Patches currently in -mm which might be from nacc@linux.vnet.ibm.com are

origin.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch

