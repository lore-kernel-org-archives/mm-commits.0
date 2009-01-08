From: akpm@linux-foundation.org
Subject: - cpuset-rcu_read_lock-to-protect-task_cs.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:50:03 -0800
Message-ID: <200901082250.n08Mo3Tc029281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758526AbZAHW6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     cpuset: rcu_read_lock() to protect task_cs()
has been removed from the -mm tree.  Its filename was
     cpuset-rcu_read_lock-to-protect-task_cs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: rcu_read_lock() to protect task_cs()
From: Lai Jiangshan <laijs@cn.fujitsu.com>

task_cs() calls task_subsys_state().

Ee must use rcu_read_lock() to protect cgroup_subsys_state().

It's correct that top_cpuset is never freed, but cgroup_subsys_state()
accesses css_set, this css_set maybe freed when task_cs() called.

We use use rcu_read_lock() to protect it.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff -puN kernel/cpuset.c~cpuset-rcu_read_lock-to-protect-task_cs kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-rcu_read_lock-to-protect-task_cs
+++ a/kernel/cpuset.c
@@ -375,14 +375,9 @@ void cpuset_update_task_memory_state(voi
 	struct task_struct *tsk = current;
 	struct cpuset *cs;
 
-	if (task_cs(tsk) == &top_cpuset) {
-		/* Don't need rcu for top_cpuset.  It's never freed. */
-		my_cpusets_mem_gen = top_cpuset.mems_generation;
-	} else {
-		rcu_read_lock();
-		my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
-		rcu_read_unlock();
-	}
+	rcu_read_lock();
+	my_cpusets_mem_gen = task_cs(tsk)->mems_generation;
+	rcu_read_unlock();
 
 	if (my_cpusets_mem_gen != tsk->cpuset_mems_generation) {
 		mutex_lock(&callback_mutex);
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch

