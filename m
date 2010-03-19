From: akpm@linux-foundation.org
Subject: + cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch added to -mm tree
Date: Fri, 19 Mar 2010 16:49:35 -0700
Message-ID: <201003192349.o2JNnZXZ019184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40798 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186Ab0CSXuC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Mar 2010 19:50:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com, stable@kernel.org


The patch titled
     cpuset: fix the problem that cpuset_mem_spread_node() returns an offline node
has been added to the -mm tree.  Its filename is
     cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch

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
Subject: cpuset: fix the problem that cpuset_mem_spread_node() returns an offline node
From: Miao Xie <miaox@cn.fujitsu.com>

cpuset_mem_spread_node() returns an offline node, and causes an oops.

This patch fixes it by initializing task->mems_allowed to
node_states[N_HIGH_MEMORY], and updating task->mems_allowed when doing
memory hotplug.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Reported-by: Nick Piggin <npiggin@suse.de>
Tested-by: Nick Piggin <npiggin@suse.de>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c      |    2 +-
 kernel/cpuset.c  |   20 ++++++++++++--------
 kernel/kthread.c |    2 +-
 3 files changed, 14 insertions(+), 10 deletions(-)

diff -puN init/main.c~cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node init/main.c
--- a/init/main.c~cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node
+++ a/init/main.c
@@ -860,7 +860,7 @@ static int __init kernel_init(void * unu
 	/*
 	 * init can allocate pages on any node
 	 */
-	set_mems_allowed(node_possible_map);
+	set_mems_allowed(node_states[N_HIGH_MEMORY]);
 	/*
 	 * init can run on any cpu.
 	 */
diff -puN kernel/cpuset.c~cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node
+++ a/kernel/cpuset.c
@@ -920,9 +920,6 @@ static int update_cpumask(struct cpuset 
  *    call to guarantee_online_mems(), as we know no one is changing
  *    our task's cpuset.
  *
- *    Hold callback_mutex around the two modifications of our tasks
- *    mems_allowed to synchronize with cpuset_mems_allowed().
- *
  *    While the mm_struct we are migrating is typically from some
  *    other task, the task_struct mems_allowed that we are hacking
  *    is for our current task, which must allocate new pages for that
@@ -1391,11 +1388,10 @@ static void cpuset_attach(struct cgroup_
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
-		to = node_possible_map;
 	} else {
 		guarantee_online_cpus(cs, cpus_attach);
-		guarantee_online_mems(cs, &to);
 	}
+	guarantee_online_mems(cs, &to);
 
 	/* do per-task migration stuff possibly for each in the threadgroup */
 	cpuset_attach_task(tsk, &to, cs);
@@ -2090,15 +2086,23 @@ static int cpuset_track_online_cpus(stru
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
+	nodemask_t oldmems;
+
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-	case MEM_OFFLINE:
+		oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 		mutex_unlock(&callback_mutex);
-		if (action == MEM_OFFLINE)
-			scan_for_empty_cpusets(&top_cpuset);
+		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
+		break;
+	case MEM_OFFLINE:
+		/*
+		 * needn't update top_cpuset.mems_allowed explicitly because
+		 * scan_for_empty_cpusets() will update it.
+		 */
+		scan_for_empty_cpusets(&top_cpuset);
 		break;
 	default:
 		break;
diff -puN kernel/kthread.c~cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node kernel/kthread.c
--- a/kernel/kthread.c~cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node
+++ a/kernel/kthread.c
@@ -219,7 +219,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
-	set_mems_allowed(node_possible_map);
+	set_mems_allowed(node_states[N_HIGH_MEMORY]);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch
cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
cpuset-alloc-nodemask_t-on-the-heap-rather-than-the-stack.patch

