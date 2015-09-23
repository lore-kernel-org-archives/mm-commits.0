From: akpm@linux-foundation.org
Subject: + mm-oom-remove-task_lock-protecting-comm-printing.patch added to -mm tree
Date: Wed, 23 Sep 2015 14:52:13 -0700
Message-ID: <56031f0d.u6Hsev5GTrZ7j9zZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbbIWVwO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 Sep 2015 17:52:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mhocko@kernel.org, oleg@redhat.com, sergey.senozhatsky.work@gmail.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: remove task_lock protecting comm printing
has been added to the -mm tree.  Its filename is
     mm-oom-remove-task_lock-protecting-comm-printing.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-remove-task_lock-protecting-comm-printing.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-remove-task_lock-protecting-comm-printing.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: remove task_lock protecting comm printing

The oom killer takes task_lock() in a couple of places solely to protect
printing the task's comm.

A process's comm, including current's comm, may change due to
/proc/pid/comm or PR_SET_NAME.

The comm will always be NULL-terminated, so the worst race scenario would
only be during update.  We can tolerate a comm being printed that is in
the middle of an update to avoid taking the lock.

Other locations in the kernel have already dropped task_lock() when
printing comm, so this is consistent.

Signed-off-by: David Rientjes <rientjes@google.com>
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    4 ++--
 kernel/cpuset.c        |   14 +++++++-------
 mm/oom_kill.c          |    8 +-------
 3 files changed, 10 insertions(+), 16 deletions(-)

diff -puN include/linux/cpuset.h~mm-oom-remove-task_lock-protecting-comm-printing include/linux/cpuset.h
--- a/include/linux/cpuset.h~mm-oom-remove-task_lock-protecting-comm-printing
+++ a/include/linux/cpuset.h
@@ -93,7 +93,7 @@ extern int current_cpuset_is_being_rebou
 
 extern void rebuild_sched_domains(void);
 
-extern void cpuset_print_task_mems_allowed(struct task_struct *p);
+extern void cpuset_print_current_mems_allowed(void);
 
 /*
  * read_mems_allowed_begin is required when making decisions involving
@@ -219,7 +219,7 @@ static inline void rebuild_sched_domains
 	partition_sched_domains(1, NULL, NULL);
 }
 
-static inline void cpuset_print_task_mems_allowed(struct task_struct *p)
+static inline void cpuset_print_current_mems_allowed(void)
 {
 }
 
diff -puN kernel/cpuset.c~mm-oom-remove-task_lock-protecting-comm-printing kernel/cpuset.c
--- a/kernel/cpuset.c~mm-oom-remove-task_lock-protecting-comm-printing
+++ a/kernel/cpuset.c
@@ -2598,22 +2598,22 @@ int cpuset_mems_allowed_intersects(const
 }
 
 /**
- * cpuset_print_task_mems_allowed - prints task's cpuset and mems_allowed
- * @tsk: pointer to task_struct of some task.
+ * cpuset_print_current_mems_allowed - prints current's cpuset and mems_allowed
  *
- * Description: Prints @task's name, cpuset name, and cached copy of its
+ * Description: Prints current's name, cpuset name, and cached copy of its
  * mems_allowed to the kernel log.
  */
-void cpuset_print_task_mems_allowed(struct task_struct *tsk)
+void cpuset_print_current_mems_allowed(void)
 {
 	struct cgroup *cgrp;
 
 	rcu_read_lock();
 
-	cgrp = task_cs(tsk)->css.cgroup;
-	pr_info("%s cpuset=", tsk->comm);
+	cgrp = task_cs(current)->css.cgroup;
+	pr_info("%s cpuset=", current->comm);
 	pr_cont_cgroup_name(cgrp);
-	pr_cont(" mems_allowed=%*pbl\n", nodemask_pr_args(&tsk->mems_allowed));
+	pr_cont(" mems_allowed=%*pbl\n",
+		nodemask_pr_args(&current->mems_allowed));
 
 	rcu_read_unlock();
 }
diff -puN mm/oom_kill.c~mm-oom-remove-task_lock-protecting-comm-printing mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-remove-task_lock-protecting-comm-printing
+++ a/mm/oom_kill.c
@@ -386,13 +386,11 @@ static void dump_tasks(struct mem_cgroup
 static void dump_header(struct oom_control *oc, struct task_struct *p,
 			struct mem_cgroup *memcg)
 {
-	task_lock(current);
 	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
 		"oom_score_adj=%hd\n",
 		current->comm, oc->gfp_mask, oc->order,
 		current->signal->oom_score_adj);
-	cpuset_print_task_mems_allowed(current);
-	task_unlock(current);
+	cpuset_print_current_mems_allowed();
 	dump_stack();
 	if (memcg)
 		mem_cgroup_print_oom_info(memcg, p);
@@ -518,10 +516,8 @@ void oom_kill_process(struct oom_control
 	if (__ratelimit(&oom_rs))
 		dump_header(oc, p, memcg);
 
-	task_lock(p);
 	pr_err("%s: Kill process %d (%s) score %u or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
-	task_unlock(p);
 
 	/*
 	 * If any of p's children has a different mm and is eligible for kill,
@@ -595,10 +591,8 @@ void oom_kill_process(struct oom_control
 			if (fatal_signal_pending(p))
 				continue;
 
-			task_lock(p);	/* Protect ->comm from prctl() */
 			pr_info("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(p), p->comm);
-			task_unlock(p);
 			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 		}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from rientjes@google.com are

mm-oom-remove-task_lock-protecting-comm-printing.patch

