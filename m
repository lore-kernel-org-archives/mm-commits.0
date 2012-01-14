From: akpm@linux-foundation.org
Subject: + mm-oom-fold-oom_kill_task-into-oom_kill_process.patch added to -mm tree
Date: Fri, 13 Jan 2012 16:48:42 -0800
Message-ID: <20120114004843.281F1100052@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:63060 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab2ANAso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 19:48:44 -0500
Received: by qcsc20 with SMTP id c20so120524qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 16:48:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm, oom: fold oom_kill_task() into oom_kill_process()
has been added to the -mm tree.  Its filename is
     mm-oom-fold-oom_kill_task-into-oom_kill_process.patch

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
Subject: mm, oom: fold oom_kill_task() into oom_kill_process()

oom_kill_task() has a single caller, so fold it into its parent function,
oom_kill_process().  Slightly reduces the number of lines in the oom
killer.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   85 +++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 47 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-fold-oom_kill_task-into-oom_kill_process mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-fold-oom_kill_task-into-oom_kill_process
+++ a/mm/oom_kill.c
@@ -434,52 +434,6 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
-static void oom_kill_task(struct task_struct *p)
-{
-	struct task_struct *q;
-	struct mm_struct *mm;
-
-	p = find_lock_task_mm(p);
-	if (!p)
-		return;
-
-	/* mm cannot be safely dereferenced after task_unlock(p) */
-	mm = p->mm;
-
-	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
-		task_pid_nr(p), p->comm, K(p->mm->total_vm),
-		K(get_mm_counter(p->mm, MM_ANONPAGES)),
-		K(get_mm_counter(p->mm, MM_FILEPAGES)));
-	task_unlock(p);
-
-	/*
-	 * Kill all user processes sharing p->mm in other thread groups, if any.
-	 * They don't get access to memory reserves or a higher scheduler
-	 * priority, though, to avoid depletion of all memory or task
-	 * starvation.  This prevents mm->mmap_sem livelock when an oom killed
-	 * task cannot exit because it requires the semaphore and its contended
-	 * by another thread trying to allocate memory itself.  That thread will
-	 * now get access to memory reserves since it has a pending fatal
-	 * signal.
-	 */
-	for_each_process(q)
-		if (q->mm == mm && !same_thread_group(q, p) &&
-		    !(q->flags & PF_KTHREAD)) {
-			if (q->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
-				continue;
-
-			task_lock(q);	/* Protect ->comm from prctl() */
-			pr_err("Kill process %d (%s) sharing same memory\n",
-				task_pid_nr(q), q->comm);
-			task_unlock(q);
-			force_sig(SIGKILL, q);
-		}
-
-	set_tsk_thread_flag(p, TIF_MEMDIE);
-	force_sig(SIGKILL, p);
-}
-#undef K
-
 static void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     unsigned int points, unsigned long totalpages,
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
@@ -488,6 +442,7 @@ static void oom_kill_process(struct task
 	struct task_struct *victim = p;
 	struct task_struct *child;
 	struct task_struct *t = p;
+	struct mm_struct *mm;
 	unsigned int victim_points = 0;
 
 	if (printk_ratelimit())
@@ -531,8 +486,44 @@ static void oom_kill_process(struct task
 		}
 	} while_each_thread(p, t);
 
-	oom_kill_task(victim);
+	victim = find_lock_task_mm(victim);
+	if (!victim)
+		return;
+
+	/* mm cannot safely be dereferenced after task_unlock(victim) */
+	mm = victim->mm;
+	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+		task_pid_nr(victim), victim->comm, K(victim->mm->total_vm),
+		K(get_mm_counter(victim->mm, MM_ANONPAGES)),
+		K(get_mm_counter(victim->mm, MM_FILEPAGES)));
+	task_unlock(victim);
+
+	/*
+	 * Kill all user processes sharing victim->mm in other thread groups, if
+	 * any.  They don't get access to memory reserves, though, to avoid
+	 * depletion of all memory.  This prevents mm->mmap_sem livelock when an
+	 * oom killed thread cannot exit because it requires the semaphore and
+	 * its contended by another thread trying to allocate memory itself.
+	 * That thread will now get access to memory reserves since it has a
+	 * pending fatal signal.
+	 */
+	for_each_process(p)
+		if (p->mm == mm && !same_thread_group(p, victim) &&
+		    !(p->flags & PF_KTHREAD)) {
+			if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
+				continue;
+
+			task_lock(p);	/* Protect ->comm from prctl() */
+			pr_err("Kill process %d (%s) sharing same memory\n",
+				task_pid_nr(p), p->comm);
+			task_unlock(p);
+			force_sig(SIGKILL, p);
+		}
+
+	set_tsk_thread_flag(victim, TIF_MEMDIE);
+	force_sig(SIGKILL, victim);
 }
+#undef K
 
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
_
Subject: Subject: mm, oom: fold oom_kill_task() into oom_kill_process()

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch

