From: akpm@linux-foundation.org
Subject: [merged] mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:23 -0700
Message-ID: <20120322201723.5486CA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:60535 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab2CVURY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:24 -0400
Received: by mail-gy0-f202.google.com with SMTP id z15so402093ghb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: avoid looping when chosen thread detaches its mm
has been removed from the -mm tree.  Its filename was
     mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: avoid looping when chosen thread detaches its mm

oom_kill_task() returns non-zero iff the chosen process does not have any
threads with an attached ->mm.

In such a case, it's better to just return to the page allocator and retry
the allocation because memory could have been freed in the interim and the
oom condition may no longer exist.  It's unnecessary to loop in the oom
killer and find another thread to kill.

This allows both oom_kill_task() and oom_kill_process() to be converted to
void functions.  If the oom condition persists, the oom killer will be
recalled.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   56 +++++++++++++++++-------------------------------
 1 file changed, 20 insertions(+), 36 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm
+++ a/mm/oom_kill.c
@@ -434,14 +434,14 @@ static void dump_header(struct task_stru
 }
 
 #define K(x) ((x) << (PAGE_SHIFT-10))
-static int oom_kill_task(struct task_struct *p)
+static void oom_kill_task(struct task_struct *p)
 {
 	struct task_struct *q;
 	struct mm_struct *mm;
 
 	p = find_lock_task_mm(p);
 	if (!p)
-		return 1;
+		return;
 
 	/* mm cannot be safely dereferenced after task_unlock(p) */
 	mm = p->mm;
@@ -477,15 +477,13 @@ static int oom_kill_task(struct task_str
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 	force_sig(SIGKILL, p);
-
-	return 0;
 }
 #undef K
 
-static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
-			    unsigned int points, unsigned long totalpages,
-			    struct mem_cgroup *memcg, nodemask_t *nodemask,
-			    const char *message)
+static void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+			     unsigned int points, unsigned long totalpages,
+			     struct mem_cgroup *memcg, nodemask_t *nodemask,
+			     const char *message)
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
@@ -501,7 +499,7 @@ static int oom_kill_process(struct task_
 	 */
 	if (p->flags & PF_EXITING) {
 		set_tsk_thread_flag(p, TIF_MEMDIE);
-		return 0;
+		return;
 	}
 
 	task_lock(p);
@@ -533,7 +531,7 @@ static int oom_kill_process(struct task_
 		}
 	} while_each_thread(p, t);
 
-	return oom_kill_task(victim);
+	oom_kill_task(victim);
 }
 
 /*
@@ -580,15 +578,10 @@ void mem_cgroup_out_of_memory(struct mem
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
 	limit = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT;
 	read_lock(&tasklist_lock);
-retry:
 	p = select_bad_process(&points, limit, memcg, NULL);
-	if (!p || PTR_ERR(p) == -1UL)
-		goto out;
-
-	if (oom_kill_process(p, gfp_mask, 0, points, limit, memcg, NULL,
-				"Memory cgroup out of memory"))
-		goto retry;
-out:
+	if (p && PTR_ERR(p) != -1UL)
+		oom_kill_process(p, gfp_mask, 0, points, limit, memcg, NULL,
+				 "Memory cgroup out of memory");
 	read_unlock(&tasklist_lock);
 }
 #endif
@@ -745,33 +738,24 @@ void out_of_memory(struct zonelist *zone
 	if (sysctl_oom_kill_allocating_task &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
 	    current->mm) {
-		/*
-		 * oom_kill_process() needs tasklist_lock held.  If it returns
-		 * non-zero, current could not be killed so we must fallback to
-		 * the tasklist scan.
-		 */
-		if (!oom_kill_process(current, gfp_mask, order, 0, totalpages,
-				NULL, nodemask,
-				"Out of memory (oom_kill_allocating_task)"))
-			goto out;
+		oom_kill_process(current, gfp_mask, order, 0, totalpages, NULL,
+				 nodemask,
+				 "Out of memory (oom_kill_allocating_task)");
+		goto out;
 	}
 
-retry:
 	p = select_bad_process(&points, totalpages, NULL, mpol_mask);
-	if (PTR_ERR(p) == -1UL)
-		goto out;
-
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!p) {
 		dump_header(NULL, gfp_mask, order, NULL, mpol_mask);
 		read_unlock(&tasklist_lock);
 		panic("Out of memory and no killable processes...\n");
 	}
-
-	if (oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
-				nodemask, "Out of memory"))
-		goto retry;
-	killed = 1;
+	if (PTR_ERR(p) != -1UL) {
+		oom_kill_process(p, gfp_mask, order, points, totalpages, NULL,
+				 nodemask, "Out of memory");
+		killed = 1;
+	}
 out:
 	read_unlock(&tasklist_lock);
 
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

