From: akpm@linux-foundation.org
Subject: - cpuset-two-minor-code-cleanups.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:13 -0700
Message-ID: <200807252259.m6PMxDJt003362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60134 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbYGYW7v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: two minor code-cleanups
has been removed from the -mm tree.  Its filename was
     cpuset-two-minor-code-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: two minor code-cleanups
From: Lai Jiangshan <laijs@cn.fujitsu.com>

In cpuset_update_task_memory_state() local variable struct task_struct
*tsk = current;

And local variable tsk is used 14 times and statement task_cs(tsk) is used
twice in this function.  So using task_cs(tsk) instead of task_cs(current)
is better for readability.

And "(struct cgroup_scanner *)&scan" is not good for readability also. 
(and "container_of" is used in cpuset_do_move_task(), not
"(cpuset_hotplug_scanner *)scan")

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpuset-two-minor-code-cleanups kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-two-minor-code-cleanups
+++ a/kernel/cpuset.c
@@ -365,7 +365,7 @@ void cpuset_update_task_memory_state(voi
 		my_cpusets_mem_gen = top_cpuset.mems_generation;
 	} else {
 		rcu_read_lock();
-		my_cpusets_mem_gen = task_cs(current)->mems_generation;
+		my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
 		rcu_read_unlock();
 	}
 
@@ -1777,7 +1777,7 @@ static void move_member_tasks_to_cpuset(
 	scan.scan.heap = NULL;
 	scan.to = to->css.cgroup;
 
-	if (cgroup_scan_tasks((struct cgroup_scanner *)&scan))
+	if (cgroup_scan_tasks(&scan.scan))
 		printk(KERN_ERR "move_member_tasks_to_cpuset: "
 				"cgroup_scan_tasks failed\n");
 }
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

