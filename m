From: akpm@linux-foundation.org
Subject: + cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets.patch added to -mm tree
Date: Wed, 18 Mar 2009 16:46:00 -0700
Message-ID: <200903182349.n2INnMqe031029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZCRXxm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 19:53:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com, menage@google.com, mingo@elte.hu


The patch titled
     cpusets: prevent PF_THREAD_BOUND tasks from attaching to non-root cpusets
has been added to the -mm tree.  Its filename is
     cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets.patch

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

linux-next.patch
oom_kill-dont-call-for-int_sqrt0.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets.patch
cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads.patch

