From: akpm@linux-foundation.org
Subject: [merged] sched-emit-thread-info-flags-with-stack-trace.patch removed from -mm tree
Date: Thu, 07 May 2009 12:16:48 -0700
Message-ID: <200905071916.n47JGm0Y020666@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57145 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbZEGTUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 May 2009 15:20:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     sched: emit thread info flags with stack trace
has been removed from the -mm tree.  Its filename was
     sched-emit-thread-info-flags-with-stack-trace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
x86-srat-do-not-register-nodes-beyond-e820-map.patch
cpusets-restructure-the-function-cpuset_update_task_memory_state.patch
cpusets-update-tasks-page-slab-spread-flags-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time.patch
cpusetmm-update-tasks-mems_allowed-in-time-fix.patch
cpusetmm-update-tasks-mems_allowed-in-time-cleanup.patch
page-allocator-use-a-pre-calculated-value-instead-of-num_online_nodes-in-fast-paths-do-not-override-definition-of-node_set_online-with-macro.patch
mm-setup_per_zone_inactive_ratio-do-not-call-for-int_sqrt-if-not-needed.patch
mm-setup_per_zone_inactive_ratio-fix-comment-and-make-it-__init.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch

