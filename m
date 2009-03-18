From: akpm@linux-foundation.org
Subject: [alternative-merged] cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads.patch removed from -mm tree
Date: Wed, 18 Mar 2009 16:46:06 -0700
Message-ID: <200903182349.n2INnTrw031035@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752192AbZCRXyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Mar 2009 19:54:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhaval@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, balbir@in.ibm.com, menage@google.com, mingo@elte.hu, rientjes@google.com, vatsa@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: check if the cpus allowed is a subset of the cpuset's cpus for PF_THREAD_BOUND threads
has been removed from the -mm tree.  Its filename was
     cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads.patch

This patch was dropped because an alternative patch was merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: check if the cpus allowed is a subset of the cpuset's cpus for PF_THREAD_BOUND threads
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>

When a kernel thread which has been bound to a CPU is moved to a cpuset
which is a superset of the CPU it is bound to, the movement fails.

[root@llm11 cgroups]# mkdir a
[root@llm11 cgroups]# echo 3 > a/cpuset.cpus
[root@llm11 cgroups]# echo 0 > a/cpuset.mems
[root@llm11 cgroups]# echo 12 > a/tasks
[root@llm11 cgroups]# echo 12 > tasks
-bash: echo: write error: Invalid argument
[root@llm11 cgroups]# cat cpuset.cpus
0-7
[root@llm11 cgroups]#

(pid 12 is the migration thread bound to CPU 3)

Change the check to see if the cpus allowed is a subset of the cpus
allowed for that cpuset.

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpuset.c~cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads
+++ a/kernel/cpuset.c
@@ -1349,7 +1349,7 @@ static int cpuset_can_attach(struct cgro
 
 	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
+		if (!cpumask_subset(&tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
 	}
_

Patches currently in -mm which might be from dhaval@linux.vnet.ibm.com are

cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cpusets-prevent-pf_thread_bound-tasks-from-attaching-to-non-root-cpusets.patch
cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads.patch

