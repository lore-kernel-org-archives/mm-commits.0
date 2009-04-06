From: akpm@linux-foundation.org
Subject: [merged] cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:35:10 -0700
Message-ID: <200904061935.n36JZA76011928@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752703AbZDFU3D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 16:29:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com, menage@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpusets: prevent PF_THREAD_BOUND tasks from attaching to non-root cpusets
has been removed from the -mm tree.  Its filename was
     cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: prevent PF_THREAD_BOUND tasks from attaching to non-root cpusets
From: David Rientjes <rientjes@google.com>

Kthreads that have the PF_THREAD_BOUND bit set in their flags are bound to a
specific cpu.  Thus, their set of allowed cpus shall not change.

This patch prevents such threads from attaching to non-root cpusets.  They do
not have mempolicies that restrict them to a subset of system nodes and, since
their cpumask may never change, they cannot use any of the features of
cpusets.

The tasks will forever be a member of the root cpuset and will be returned
when listing the tasks attached to that cpuset.

Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff -puN kernel/cpuset.c~cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets
+++ a/kernel/cpuset.c
@@ -1342,19 +1342,22 @@ static int cpuset_can_attach(struct cgro
 			     struct cgroup *cont, struct task_struct *tsk)
 {
 	struct cpuset *cs = cgroup_cs(cont);
-	int ret = 0;
 
 	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
 
-	if (tsk->flags & PF_THREAD_BOUND) {
-		mutex_lock(&callback_mutex);
-		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
-			ret = -EINVAL;
-		mutex_unlock(&callback_mutex);
-	}
+	/*
+	 * Kthreads bound to specific cpus cannot be moved to a new cpuset; we
+	 * cannot change their cpu affinity and isolating such threads by their
+	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
+	 * applicable for such threads.  This prevents checking for success of
+	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
+	 * be changed.
+	 */
+	if (tsk->flags & PF_THREAD_BOUND)
+		return -EINVAL;
 
-	return ret < 0 ? ret : security_task_setscheduler(tsk, 0, NULL);
+	return security_task_setscheduler(tsk, 0, NULL);
 }
 
 static void cpuset_attach(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch

