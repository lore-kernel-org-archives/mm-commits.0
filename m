From: akpm@linux-foundation.org
Subject: [patch 37/84] kernek/fork.c: allocate idle task for a CPU always
 on its local node
Date: Mon, 23 May 2016 16:24:05 -0700
Message-ID: <57439115.GkDabDz+zI6l0QIS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbcEWXYG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:24:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ak@linux.intel.com, tglx@linutronix.de

From: Andi Kleen <ak@linux.intel.com>
Subject: kernek/fork.c: allocate idle task for a CPU always on its local node

Linux preallocates the task structs of the idle tasks for all possible
CPUs.  This currently means they all end up on node 0.  This also implies
that the cache line of MWAIT, which is around the flags field in the task
struct, are all located in node 0.

We see a noticeable performance improvement on Knights Landing CPUs when
the cache lines used for MWAIT are located in the local nodes of the CPUs
using them.  I would expect this to give a (likely slight) improvement on
other systems too.

The patch implements placing the idle task in the node of its CPUs, by
passing the right target node to copy_process()

[akpm@linux-foundation.org: use NUMA_NO_NODE, not a bare -1]
Link: http://lkml.kernel.org/r/1463492694-15833-1-git-send-email-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~allocate-idle-task-for-a-cpu-always-on-its-local-node kernel/fork.c
--- a/kernel/fork.c~allocate-idle-task-for-a-cpu-always-on-its-local-node
+++ a/kernel/fork.c
@@ -340,13 +340,14 @@ void set_task_stack_end_magic(struct tas
 	*stackend = STACK_END_MAGIC;	/* for overflow detection */
 }
 
-static struct task_struct *dup_task_struct(struct task_struct *orig)
+static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 {
 	struct task_struct *tsk;
 	struct thread_info *ti;
-	int node = tsk_fork_get_node(orig);
 	int err;
 
+	if (node == NUMA_NO_NODE)
+		node = tsk_fork_get_node(orig);
 	tsk = alloc_task_struct_node(node);
 	if (!tsk)
 		return NULL;
@@ -1276,7 +1277,8 @@ static struct task_struct *copy_process(
 					int __user *child_tidptr,
 					struct pid *pid,
 					int trace,
-					unsigned long tls)
+					unsigned long tls,
+					int node)
 {
 	int retval;
 	struct task_struct *p;
@@ -1328,7 +1330,7 @@ static struct task_struct *copy_process(
 		goto fork_out;
 
 	retval = -ENOMEM;
-	p = dup_task_struct(current);
+	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
 
@@ -1706,7 +1708,8 @@ static inline void init_idle_pids(struct
 struct task_struct *fork_idle(int cpu)
 {
 	struct task_struct *task;
-	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0);
+	task = copy_process(CLONE_VM, 0, 0, NULL, &init_struct_pid, 0, 0,
+			    cpu_to_node(cpu));
 	if (!IS_ERR(task)) {
 		init_idle_pids(task->pids);
 		init_idle(task, cpu);
@@ -1751,7 +1754,7 @@ long _do_fork(unsigned long clone_flags,
 	}
 
 	p = copy_process(clone_flags, stack_start, stack_size,
-			 child_tidptr, NULL, trace, tls);
+			 child_tidptr, NULL, trace, tls, NUMA_NO_NODE);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
_
