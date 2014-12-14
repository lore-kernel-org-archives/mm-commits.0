From: akpm@linux-foundation.org
Subject: [merged]
 oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:08:16 -0800
Message-ID: <548d0d30.O6ID3ViaX0sZD8+0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEII (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.cz, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: don't assume that a coredumping thread will exit soon
has been removed from the -mm tree.  Its filename was
     oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: oom: don't assume that a coredumping thread will exit soon

oom_kill.c assumes that PF_EXITING task should exit and free the memory
soon.  This is wrong in many ways and one important case is the coredump. 
A task can sleep in exit_mm() "forever" while the coredumping sub-thread
can need more memory.

Change the PF_EXITING checks to take SIGNAL_GROUP_COREDUMP into account,
we add the new trivial helper for that.

Note: this is only the first step, this patch doesn't try to solve other
problems.  The SIGNAL_GROUP_COREDUMP check is obviously racy, a task can
participate in coredump after it was already observed in PF_EXITING state,
so TIF_MEMDIE (which also blocks oom-killer) still can be wrongly set. 
fatal_signal_pending() can be true because of SIGNAL_GROUP_COREDUMP so
out_of_memory() and mem_cgroup_out_of_memory() shouldn't blindly trust it.
 And even the name/usage of the new helper is confusing, an exiting thread
can only free its ->mm if it is the only/last task in thread group.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   11 +++++++++++
 mm/memcontrol.c     |    2 +-
 mm/oom_kill.c       |    6 +++---
 3 files changed, 15 insertions(+), 4 deletions(-)

diff -puN include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon include/linux/oom.h
--- a/include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon
+++ a/include/linux/oom.h
@@ -92,6 +92,17 @@ static inline bool oom_gfp_allowed(gfp_t
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
+static inline bool task_will_free_mem(struct task_struct *task)
+{
+	/*
+	 * A coredumping process may sleep for an extended period in exit_mm(),
+	 * so the oom killer cannot assume that the process will promptly exit
+	 * and release memory.
+	 */
+	return (task->flags & PF_EXITING) &&
+		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+}
+
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
diff -puN mm/memcontrol.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon mm/memcontrol.c
--- a/mm/memcontrol.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon
+++ a/mm/memcontrol.c
@@ -1559,7 +1559,7 @@ static void mem_cgroup_out_of_memory(str
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
diff -puN mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon
+++ a/mm/oom_kill.c
@@ -281,7 +281,7 @@ enum oom_scan_t oom_scan_process_thread(
 	if (oom_task_origin(task))
 		return OOM_SCAN_SELECT;
 
-	if (task->flags & PF_EXITING && !force_kill) {
+	if (task_will_free_mem(task) && !force_kill) {
 		/*
 		 * If this task is not being ptraced on exit, then wait for it
 		 * to finish before killing some other task unnecessarily.
@@ -443,7 +443,7 @@ void oom_kill_process(struct task_struct
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
-	if (p->flags & PF_EXITING) {
+	if (task_will_free_mem(p)) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
 		put_task_struct(p);
 		return;
@@ -649,7 +649,7 @@ void out_of_memory(struct zonelist *zone
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
remove-unnecessary-is_valid_nodemask.patch
linux-next.patch
all-arches-signal-move-restart_block-to-struct-task_struct.patch

