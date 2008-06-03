From: akpm@linux-foundation.org
Subject: + cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch added to -mm tree
Date: Tue, 03 Jun 2008 15:04:05 -0700
Message-ID: <200806032204.m53M45si022124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759274AbYFCWEK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jun 2008 18:04:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, pj@sgi.com


The patch titled
     cpusets: update task's cpus_allowed and mems_allowed after CPU/NODE offline/online
has been added to the -mm tree.  Its filename is
     cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: update task's cpus_allowed and mems_allowed after CPU/NODE offline/online
From: Miao Xie <miaox@cn.fujitsu.com>

The bug is, a task may run on the cpu/node which is not in its cpuset.cpus/
cpuset.mems.

It can be reproduced by the following commands:
===================================
# mkdir /dev/cpuset
# mount -t cpuset xxx /dev/cpuset
# mkdir /dev/cpuset/0
# echo 0-1 > /dev/cpuset/0/cpus
# echo 0 > /dev/cpuset/0/mems
# echo $$ > /dev/cpuset/0/tasks
# echo 0 > /sys/devices/system/cpu/cpu1/online
# echo 1 > /sys/devices/system/cpu/cpu1/online
===================================

There is only CPU0 in cpuset.cpus, but the task in this cpuset runs on
both CPU0 and CPU1.

It is because the task's cpu_allowed didn't get updated after we did CPU
offline/online manipulation.  Similar for mem_allowed.

This patch fixes this bug expect for root cpuset.  Because there is a
problem about root cpuset, in that whether it is necessary to update all
the tasks in root cpuset or not after cpu/node offline/online.

If updating, some kernel threads which is bound into a specified cpu will
be unbound.

If not updating, there is a bug in root cpuset.  This bug is also caused
by offline/online manipulation.  For example, there is a dual-cpu machine.
 we create a sub cpuset in root cpuset and assign 1 to its cpus.  And then
we attach some tasks into this sub cpuset.  After this, we offline CPU1. 
Now, the tasks in this new cpuset are moved into root cpuset automatically
because there is no cpu in sub cpuset.  Then we online CPU1, we find all
the tasks which doesn't belong to root cpuset originally just run on CPU0.

Maybe we need to add a flag in the task_struct to mark which task can't be
unbound?

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN kernel/cpuset.c~cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online kernel/cpuset.c
--- a/kernel/cpuset.c~cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online
+++ a/kernel/cpuset.c
@@ -1874,6 +1874,7 @@ static void scan_for_empty_cpusets(const
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct list_head queue;
 	struct cgroup *cont;
+	nodemask_t oldmems;
 
 	INIT_LIST_HEAD(&queue);
 
@@ -1893,6 +1894,8 @@ static void scan_for_empty_cpusets(const
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
+		oldmems = cp->mems_allowed;
+
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
 		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
@@ -1904,6 +1907,10 @@ static void scan_for_empty_cpusets(const
 		if (cpus_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
+		else {
+			update_tasks_cpumask(cp);
+			update_tasks_nodemask(cp, &oldmems);
+		}
 	}
 }
 
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

cpusets-fix-and-update-documentation.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

