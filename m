From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch
 removed from -mm tree
Date: Fri, 06 Nov 2015 12:09:00 -0800
Message-ID: <563d08dc.2nifwKDFFesRn3qZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033532AbbKFUJB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:09:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, kwalker@redhat.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, skozina@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: fix the wrong task->mm == mm checks in oom_kill_process()
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/oom_kill: fix the wrong task->mm == mm checks in oom_kill_process()

Both "child->mm == mm" and "p->mm != mm" checks in oom_kill_process() are
wrong.  task->mm can be NULL if the task is the exited group leader.  This
means in particular that "kill sharing same memory" loop can miss a
process with a zombie leader which uses the same ->mm.

Note: the process_has_mm(child, p->mm) check is still not 100% correct,
p->mm can be NULL too.  This is minor, but probably deserves a fix or a
comment anyway.

[akpm@linux-foundation.org: document process_shares_mm() a bit]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Kyle Walker <kwalker@redhat.com>
Cc: Stanislav Kozina <skozina@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff -puN mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process
+++ a/mm/oom_kill.c
@@ -474,6 +474,24 @@ void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
+/*
+ * task->mm can be NULL if the task is the exited group leader.  So to
+ * determine whether the task is using a particular mm, we examine all the
+ * task's threads: if one of those is using this mm then this task was also
+ * using it.
+ */
+static bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+{
+	struct task_struct *t;
+
+	for_each_thread(p, t) {
+		struct mm_struct *t_mm = READ_ONCE(t->mm);
+		if (t_mm)
+			return t_mm == mm;
+	}
+	return false;
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
@@ -521,7 +539,7 @@ void oom_kill_process(struct oom_control
 		list_for_each_entry(child, &t->children, sibling) {
 			unsigned int child_points;
 
-			if (child->mm == p->mm)
+			if (process_shares_mm(child, p->mm))
 				continue;
 			/*
 			 * oom_badness() returns 0 if the thread is unkillable
@@ -575,7 +593,7 @@ void oom_kill_process(struct oom_control
 	 */
 	rcu_read_lock();
 	for_each_process(p) {
-		if (p->mm != mm)
+		if (!process_shares_mm(p, mm))
 			continue;
 		if (same_thread_group(p, victim))
 			continue;
_

Patches currently in -mm which might be from oleg@redhat.com are

proc-actually-make-proc_fd_permission-thread-friendly.patch
change-current_is_single_threaded-to-use-for_each_thread.patch
signals-kill-block_all_signals-and-unblock_all_signals.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal.patch
signal-turn-dequeue_signal_lock-into-kernel_dequeue_signal-fix.patch
signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch
signal-remove-jffs2_garbage_collect_thread-allow_signalsigcont.patch
coredump-ensure-all-coredumping-tasks-have-signal_group_coredump.patch
coredump-change-zap_threads-and-zap_process-to-use-for_each_thread.patch

