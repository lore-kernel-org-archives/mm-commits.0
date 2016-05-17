From: akpm@linux-foundation.org
Subject: + allocate-idle-task-for-a-cpu-always-on-its-local-node.patch
 added to -mm tree
Date: Tue, 17 May 2016 14:13:15 -0700
Message-ID: <573b896b.ENIPIrGOKQXXXbD/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbcEQVNW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 May 2016 17:13:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kernek/fork.c: allocate idle task for a CPU always on its local node
has been added to the -mm tree.  Its filename is
     allocate-idle-task-for-a-cpu-always-on-its-local-node.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/allocate-idle-task-for-a-cpu-always-on-its-local-node.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/allocate-idle-task-for-a-cpu-always-on-its-local-node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
 
+	if (node < 0)
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
+			 child_tidptr, NULL, trace, tls, -1);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
_

Patches currently in -mm which might be from ak@linux.intel.com are

allocate-idle-task-for-a-cpu-always-on-its-local-node.patch

