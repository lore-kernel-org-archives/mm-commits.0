From: akpm@linux-foundation.org
Subject: [nacked] mm-oom-avoid-printk-iteration-under-rcu.patch
 removed from -mm tree
Date: Thu, 30 Jan 2020 20:33:24 -0800
Message-ID: <20200131043324.wkArXTf6-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727448AbgAaEdZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 30 Jan 2020 23:33:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, mhocko@suse.com, mm-commits@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, shakeelb@google.com


The patch titled
     Subject: mm, oom: avoid printk() iteration under RCU
has been removed from the -mm tree.  Its filename was
     mm-oom-avoid-printk-iteration-under-rcu.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm, oom: avoid printk() iteration under RCU

Currently dump_tasks() might call printk() for many thousands times under
RCU, which might take many minutes for slow consoles.  Therefore, split
dump_tasks() into three stages; take a snapshot of possible OOM victim
candidates under RCU, dump the snapshot from reschedulable context, and
destroy the snapshot.

In a future patch, the first stage would be moved to select_bad_process()
and the third stage would be moved to after oom_kill_process(), and will
simplify refcount handling.

[akpm@linux-foundation.org: make dump_tasks::list non-static]
Link: http://lkml.kernel.org/r/1563360901-8277-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 
 mm/oom_kill.c         |   67 +++++++++++++++++++---------------------
 2 files changed, 34 insertions(+), 34 deletions(-)

--- a/include/linux/sched.h~mm-oom-avoid-printk-iteration-under-rcu
+++ a/include/linux/sched.h
@@ -1261,6 +1261,7 @@ struct task_struct {
 #ifdef CONFIG_MMU
 	struct task_struct		*oom_reaper_list;
 #endif
+	struct list_head		oom_victim_list;
 #ifdef CONFIG_VMAP_STACK
 	struct vm_struct		*stack_vm_area;
 #endif
--- a/mm/oom_kill.c~mm-oom-avoid-printk-iteration-under-rcu
+++ a/mm/oom_kill.c
@@ -377,36 +377,13 @@ static void select_bad_process(struct oo
 	}
 }
 
-static int dump_task(struct task_struct *p, void *arg)
-{
-	struct oom_control *oc = arg;
-	struct task_struct *task;
-
-	if (oom_unkillable_task(p))
-		return 0;
 
-	/* p may not have freeable memory in nodemask */
-	if (!is_memcg_oom(oc) && !oom_cpuset_eligible(p, oc))
-		return 0;
-
-	task = find_lock_task_mm(p);
-	if (!task) {
-		/*
-		 * This is a kthread or all of p's threads have already
-		 * detached their mm's.  There's no need to report
-		 * them; they can't be oom killed anyway.
-		 */
-		return 0;
+static int add_candidate_task(struct task_struct *p, void *arg)
+{
+	if (!oom_unkillable_task(p)) {
+		get_task_struct(p);
+		list_add_tail(&p->oom_victim_list, (struct list_head *) arg);
 	}
-
-	pr_info("[%7d] %5d %5d %8lu %8lu %8ld %8lu         %5hd %s\n",
-		task->pid, from_kuid(&init_user_ns, task_uid(task)),
-		task->tgid, task->mm->total_vm, get_mm_rss(task->mm),
-		mm_pgtables_bytes(task->mm),
-		get_mm_counter(task->mm, MM_SWAPENTS),
-		task->signal->oom_score_adj, task->comm);
-	task_unlock(task);
-
 	return 0;
 }
 
@@ -422,19 +399,41 @@ static int dump_task(struct task_struct
  */
 static void dump_tasks(struct oom_control *oc)
 {
-	pr_info("Tasks state (memory values in pages):\n");
-	pr_info("[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name\n");
+	LIST_HEAD(list);
+	struct task_struct *p;
+	struct task_struct *t;
 
 	if (is_memcg_oom(oc))
-		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
+		mem_cgroup_scan_tasks(oc->memcg, add_candidate_task, &list);
 	else {
-		struct task_struct *p;
-
 		rcu_read_lock();
 		for_each_process(p)
-			dump_task(p, oc);
+			add_candidate_task(p, &list);
 		rcu_read_unlock();
 	}
+	pr_info("Tasks state (memory values in pages):\n");
+	pr_info("[  pid  ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name\n");
+	list_for_each_entry(p, &list, oom_victim_list) {
+		cond_resched();
+		/* p may not have freeable memory in nodemask */
+		if (!is_memcg_oom(oc) && !oom_cpuset_eligible(p, oc))
+			continue;
+		/* All of p's threads might have already detached their mm's. */
+		t = find_lock_task_mm(p);
+		if (!t)
+			continue;
+		pr_info("[%7d] %5d %5d %8lu %8lu %8ld %8lu         %5hd %s\n",
+			t->pid, from_kuid(&init_user_ns, task_uid(t)),
+			t->tgid, t->mm->total_vm, get_mm_rss(t->mm),
+			mm_pgtables_bytes(t->mm),
+			get_mm_counter(t->mm, MM_SWAPENTS),
+			t->signal->oom_score_adj, t->comm);
+		task_unlock(t);
+	}
+	list_for_each_entry_safe(p, t, &list, oom_victim_list) {
+		list_del(&p->oom_victim_list);
+		put_task_struct(p);
+	}
 }
 
 static void dump_oom_summary(struct oom_control *oc, struct task_struct *victim)
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are
