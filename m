From: akpm@linux-foundation.org
Subject: [merged]
 mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch removed from -mm tree
Date: Fri, 29 Jul 2016 11:53:46 -0700
Message-ID: <579ba63a.bRgaZB8NJFF5hBKZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcG2Sxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2016 14:53:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj
has been removed from the -mm tree.  Its filename was
     mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj

oom_score_adj is shared for the thread groups (via struct signal) but this
is not sufficient to cover processes sharing mm (CLONE_VM without
CLONE_SIGHAND) and so we can easily end up in a situation when some
processes update their oom_score_adj and confuse the oom killer.  In the
worst case some of those processes might hide from the oom killer
altogether via OOM_SCORE_ADJ_MIN while others are eligible.  OOM killer
would then pick up those eligible but won't be allowed to kill others
sharing the same mm so the mm wouldn't release the mm and so the memory.

It would be ideal to have the oom_score_adj per mm_struct because that is
the natural entity OOM killer considers.  But this will not work because
some programs are doing

	vfork()
	set_oom_adj()
	exec()

We can achieve the same though.  oom_score_adj write handler can set the
oom_score_adj for all processes sharing the same mm if the task is not in
the middle of vfork.  As a result all the processes will share the same
oom_score_adj.  The current implementation is rather pessimistic and
checks all the existing processes by default if there is more than 1
holder of the mm but we do not have any reliable way to check for external
users yet.

Link: http://lkml.kernel.org/r/1466426628-15074-5-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c     |   46 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mm.h |    2 +
 mm/oom_kill.c      |    2 -
 3 files changed, 49 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj fs/proc/base.c
--- a/fs/proc/base.c~mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj
+++ a/fs/proc/base.c
@@ -1040,6 +1040,7 @@ static ssize_t oom_adj_read(struct file
 static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 {
 	static DEFINE_MUTEX(oom_adj_mutex);
+	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	int err = 0;
 
@@ -1069,10 +1070,55 @@ static int __set_oom_adj(struct file *fi
 		}
 	}
 
+	/*
+	 * Make sure we will check other processes sharing the mm if this is
+	 * not vfrok which wants its own oom_score_adj.
+	 * pin the mm so it doesn't go away and get reused after task_unlock
+	 */
+	if (!task->vfork_done) {
+		struct task_struct *p = find_lock_task_mm(task);
+
+		if (p) {
+			if (atomic_read(&p->mm->mm_users) > 1) {
+				mm = p->mm;
+				atomic_inc(&mm->mm_count);
+			}
+			task_unlock(p);
+		}
+	}
+
 	task->signal->oom_score_adj = oom_adj;
 	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
 		task->signal->oom_score_adj_min = (short)oom_adj;
 	trace_oom_score_adj_update(task);
+
+	if (mm) {
+		struct task_struct *p;
+
+		rcu_read_lock();
+		for_each_process(p) {
+			if (same_thread_group(task, p))
+				continue;
+
+			/* do not touch kernel threads or the global init */
+			if (p->flags & PF_KTHREAD || is_global_init(p))
+				continue;
+
+			task_lock(p);
+			if (!p->vfork_done && process_shares_mm(p, mm)) {
+				pr_info("updating oom_score_adj for %d (%s) from %d to %d because it shares mm with %d (%s). Report if this is unexpected.\n",
+						task_pid_nr(p), p->comm,
+						p->signal->oom_score_adj, oom_adj,
+						task_pid_nr(task), task->comm);
+				p->signal->oom_score_adj = oom_adj;
+				if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
+					p->signal->oom_score_adj_min = (short)oom_adj;
+			}
+			task_unlock(p);
+		}
+		rcu_read_unlock();
+		mmdrop(mm);
+	}
 err_unlock:
 	mutex_unlock(&oom_adj_mutex);
 	put_task_struct(task);
diff -puN include/linux/mm.h~mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj include/linux/mm.h
--- a/include/linux/mm.h~mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj
+++ a/include/linux/mm.h
@@ -2284,6 +2284,8 @@ static inline int in_gate_area(struct mm
 }
 #endif	/* __HAVE_ARCH_GATE_AREA */
 
+extern bool process_shares_mm(struct task_struct *p, struct mm_struct *mm);
+
 #ifdef CONFIG_SYSCTL
 extern int sysctl_drop_caches;
 int drop_caches_sysctl_handler(struct ctl_table *, int,
diff -puN mm/oom_kill.c~mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj
+++ a/mm/oom_kill.c
@@ -415,7 +415,7 @@ bool oom_killer_disabled __read_mostly;
  * task's threads: if one of those is using this mm then this task was also
  * using it.
  */
-static bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
+bool process_shares_mm(struct task_struct *p, struct mm_struct *mm)
 {
 	struct task_struct *t;
 
_

Patches currently in -mm which might be from mhocko@suse.com are


