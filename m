From: akpm@linux-foundation.org
Subject: + oom-give-the-dying-task-a-higher-priority.patch added to -mm tree
Date: Fri, 02 Jul 2010 14:52:51 -0700
Message-ID: <201007022152.o62LqpSn028869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46771 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab0GBVxH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2010 17:53:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lclaudio@uudg.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com, rientjes@google.com


The patch titled
     oom: give the dying task a higher priority
has been added to the -mm tree.  Its filename is
     oom-give-the-dying-task-a-higher-priority.patch

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
Subject: oom: give the dying task a higher priority
From: Luis Claudio R. Goncalves <lclaudio@uudg.org>

In a system under heavy load it was observed that even after the
oom-killer selects a task to die, the task may take a long time to die.

Right after sending a SIGKILL to the task selected by the oom-killer this
task has its priority increased so that it can exit() soon, freeing
memory.  That is accomplished by:

        /*
         * We give our sacrificial lamb high priority and access to
         * all the memory it needs. That way it should be able to
         * exit() and clear out its resources quickly...
         */
 	p->rt.time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);

It sounds plausible giving the dying task an even higher priority to be
sure it will be scheduled sooner and free the desired memory.  It was
suggested on LKML using SCHED_FIFO:1, the lowest RT priority so that this
task won't interfere with any running RT task.

If the dying task is already an RT task, leave it untouched.  Another good
suggestion, implemented here, was to avoid boosting the dying task
priority in case of mem_cgroup OOM.

Signed-off-by: Luis Claudio R. Goncalves <lclaudio@uudg.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   34 +++++++++++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~oom-give-the-dying-task-a-higher-priority mm/oom_kill.c
--- a/mm/oom_kill.c~oom-give-the-dying-task-a-higher-priority
+++ a/mm/oom_kill.c
@@ -82,6 +82,24 @@ static bool has_intersects_mems_allowed(
 #endif /* CONFIG_NUMA */
 
 /*
+ * If this is a system OOM (not a memcg OOM) and the task selected to be
+ * killed is not already running at high (RT) priorities, speed up the
+ * recovery by boosting the dying task to the lowest FIFO priority.
+ * That helps with the recovery and avoids interfering with RT tasks.
+ */
+static void boost_dying_task_prio(struct task_struct *p,
+				  struct mem_cgroup *mem)
+{
+	struct sched_param param = { .sched_priority = 1 };
+
+	if (mem)
+		return;
+
+	if (!rt_task(p))
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+}
+
+/*
  * The process p may have detached its own ->mm while exiting or through
  * use_mm(), but one or more of its subthreads may still have a valid
  * pointer.  Return p, or any of its subthreads with a valid ->mm, with
@@ -421,7 +439,7 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
-static int oom_kill_task(struct task_struct *p)
+static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 {
 	p = find_lock_task_mm(p);
 	if (!p) {
@@ -434,9 +452,17 @@ static int oom_kill_task(struct task_str
 		K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);
 
-	p->rt.time_slice = HZ;
+
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
+
+	/*
+	 * We give our sacrificial lamb high priority and access to
+	 * all the memory it needs. That way it should be able to
+	 * exit() and clear out its resources quickly...
+	 */
+	boost_dying_task_prio(p, mem);
+
 	return 0;
 }
 #undef K
@@ -460,6 +486,7 @@ static int oom_kill_process(struct task_
 	 */
 	if (p->flags & PF_EXITING) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
+		boost_dying_task_prio(p, mem);
 		return 0;
 	}
 
@@ -489,7 +516,7 @@ static int oom_kill_process(struct task_
 		}
 	} while_each_thread(p, t);
 
-	return oom_kill_task(victim);
+	return oom_kill_task(victim, mem);
 }
 
 /*
@@ -670,6 +697,7 @@ void out_of_memory(struct zonelist *zone
 	 */
 	if (fatal_signal_pending(current)) {
 		set_thread_flag(TIF_MEMDIE);
+		boost_dying_task_prio(current, NULL);
 		return;
 	}
 
_

Patches currently in -mm which might be from lclaudio@uudg.org are

oom-give-the-dying-task-a-higher-priority.patch

