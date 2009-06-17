From: akpm@linux-foundation.org
Subject: [merged] cpusets-restructure-the-function-cpuset_update_task_memory_state.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:33:19 -0700
Message-ID: <200906171833.n5HIXJNR031825@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52350 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758959AbZFQSd5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:33:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, a.p.zijlstra@chello.nl, cl@linux-foundation.org, menage@google.com, mingo@elte.hu, nickpiggin@yahoo.com.au, penberg@cs.helsinki.fi, rientjes@google.com, y-goto@j


The patch titled
     cpusets: restructure the function cpuset_update_task_memory_state()
has been removed from the -mm tree.  Its filename was
     cpusets-restructure-the-function-cpuset_update_task_memory_state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: restructure the function cpuset_update_task_memory_state()
From: Miao Xie <miaox@cn.fujitsu.com>

The kernel still allocates the page caches on old node after modifying its
cpuset's mems when 'memory_spread_page' was set, or it didn't spread the
page cache evenly over all the nodes that faulting task is allowed to usr
after memory_spread_page was set.  it is caused by the old mem_allowed and
flags of the task, the current kernel doesn't updates them unless some
function invokes cpuset_update_task_memory_state(), it is too late
sometimes.We must update the mem_allowed and the flags of the tasks in
time.

Slab has the same problem.

The following patches fix this bug by updating tasks' mem_allowed and
spread flag after its cpuset's mems or spread flag is changed.


This patch:

Extract a function from cpuset_update_task_memory_state().  It will be
used later for update tasks' page/slab spread flags after its cpuset's
flag is set

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Paul Menage <menage@google.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff -puN kernel/cpuset.c~cpusets-restructure-the-function-cpuset_update_task_memory_state kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-restructure-the-function-cpuset_update_task_memory_state
+++ a/kernel/cpuset.c
@@ -331,6 +331,24 @@ static void guarantee_online_mems(const 
 	BUG_ON(!nodes_intersects(*pmask, node_states[N_HIGH_MEMORY]));
 }
 
+/*
+ * update task's spread flag if cpuset's page/slab spread flag is set
+ *
+ * Called with callback_mutex/cgroup_mutex held
+ */
+static void cpuset_update_task_spread_flag(struct cpuset *cs,
+					struct task_struct *tsk)
+{
+	if (is_spread_page(cs))
+		tsk->flags |= PF_SPREAD_PAGE;
+	else
+		tsk->flags &= ~PF_SPREAD_PAGE;
+	if (is_spread_slab(cs))
+		tsk->flags |= PF_SPREAD_SLAB;
+	else
+		tsk->flags &= ~PF_SPREAD_SLAB;
+}
+
 /**
  * cpuset_update_task_memory_state - update task memory placement
  *
@@ -388,14 +406,7 @@ void cpuset_update_task_memory_state(voi
 		cs = task_cs(tsk); /* Maybe changed when task not locked */
 		guarantee_online_mems(cs, &tsk->mems_allowed);
 		tsk->cpuset_mems_generation = cs->mems_generation;
-		if (is_spread_page(cs))
-			tsk->flags |= PF_SPREAD_PAGE;
-		else
-			tsk->flags &= ~PF_SPREAD_PAGE;
-		if (is_spread_slab(cs))
-			tsk->flags |= PF_SPREAD_SLAB;
-		else
-			tsk->flags &= ~PF_SPREAD_SLAB;
+		cpuset_update_task_spread_flag(cs, tsk);
 		task_unlock(tsk);
 		mutex_unlock(&callback_mutex);
 		mpol_rebind_task(tsk, &tsk->mems_allowed);
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch

