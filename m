From: akpm@linux-foundation.org
Subject: + sched-emit-thread-info-flags-with-stack-trace.patch added to -mm tree
Date: Tue, 05 May 2009 12:21:11 -0700
Message-ID: <200905051921.n45JLBpY003502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53143 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753030AbZEETXm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 May 2009 15:23:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, mingo@elte.hu


The patch titled
     sched: emit thread info flags with stack trace
has been added to the -mm tree.  Its filename is
     sched-emit-thread-info-flags-with-stack-trace.patch

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
Subject: sched: emit thread info flags with stack trace
From: David Rientjes <rientjes@google.com>

When a thread is oom killed and fails to exit, it's helpful to know which
threads have access to memory reserves if the machine livelocks.  This is
done by testing for the TIF_MEMDIE thread info flag and should be
displayed alongside stack traces to identify tasks that have access to
such reserves but are still stuck allocating pages, for instance.

It would probably be helpful in other cases as well, so all thread info
flags are emitted when showing a task.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~sched-emit-thread-info-flags-with-stack-trace kernel/sched.c
--- a/kernel/sched.c~sched-emit-thread-info-flags-with-stack-trace
+++ a/kernel/sched.c
@@ -6606,8 +6606,9 @@ void sched_show_task(struct task_struct 
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	printk(KERN_CONT "%5lu %5d %6d\n", free,
-		task_pid_nr(p), task_pid_nr(p->real_parent));
+	printk(KERN_CONT "%5lu %5d %6d 0x%08x\n", free,
+		task_pid_nr(p), task_pid_nr(p->real_parent),
+		task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
sched-emit-thread-info-flags-with-stack-trace.patch
oom-prevent-livelock-when-oom_kill_allocating_task-is-set.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

