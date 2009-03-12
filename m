From: akpm@linux-foundation.org
Subject: + cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads.patch added to -mm tree
Date: Thu, 12 Mar 2009 15:51:56 -0700
Message-ID: <200903122251.n2CMpvpT014007@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146AbZCLWz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Mar 2009 18:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhaval@linux.vnet.ibm.com, balbir@in.ibm.com, menage@google.com, rientjes@google.com, vatsa@linux.vnet.ibm.com


The patch titled
     cpuset: check if the cpus allowed is a subset of the cpuset's cpus for PF_THREAD_BOUND threads
has been added to the -mm tree.  Its filename is
     cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads.patch

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

origin.patch
cgroup-css-id-support-remove-rcu_read_lock-from-css_get_next.patch
cpuset-check-if-the-cpus-allowed-is-a-subset-of-the-cpusets-cpus-for-pf_thread_bound-threads.patch

