From: akpm@linux-foundation.org
Subject: [merged] mm-oom-fold-oom_kill_task-into-oom_kill_process.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:25 -0700
Message-ID: <20120322201725.63E2BA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:56681 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756652Ab2CVUR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:27 -0400
Received: by mail-lb0-f202.google.com with SMTP id gj3so134062lbb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: fold oom_kill_task() into oom_kill_process()
has been removed from the -mm tree.  Its filename was
     mm-oom-fold-oom_kill_task-into-oom_kill_process.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: fold oom_kill_task() into oom_kill_process()

oom_kill_task() has a single caller, so fold it into its parent function,
oom_kill_process().  Slightly reduces the number of lines in the oom
killer.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
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

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
signal-give-send_sig_forced-more-power-to-beat-signal_unkillable.patch
signal-cosmetic-s-from_ancestor_ns-force-in-prepare_signal-paths.patch
signal-oom_kill_task-use-send_sig_forced-instead-of-force_sig.patch
signal-zap_pid_ns_processes-s-send_sig_noinfo-send_sig_forced.patch
usermodehelper-introduce-umh_completesub_info.patch
usermodehelper-implement-umh_killable.patch
usermodehelper-kill-umh_wait-renumber-umh_-constants.patch
usermodehelper-____call_usermodehelper-doesnt-need-do_exit.patch
kmod-introduce-call_modprobe-helper.patch
kmod-make-__request_module-killable.patch

