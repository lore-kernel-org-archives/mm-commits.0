From: akpm@linux-foundation.org
Subject: + oom-dump_tasks-use-find_lock_task_mm-too.patch added to -mm tree
Date: Tue, 08 Jun 2010 12:56:43 -0700
Message-ID: <201006081956.o58JuhR7021609@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41482 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850Ab0FHT5G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jun 2010 15:57:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, balbir@in.ibm.com, oleg@redhat.com, rientjes@google.com


The patch titled
     oom: dump_tasks use find_lock_task_mm too
has been added to the -mm tree.  Its filename is
     oom-dump_tasks-use-find_lock_task_mm-too.patch

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
Subject: oom: dump_tasks use find_lock_task_mm too
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

dump_task() should use find_lock_task_mm() too. It is necessary for
protecting task-exiting race.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff -puN mm/oom_kill.c~oom-dump_tasks-use-find_lock_task_mm-too mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dump_tasks-use-find_lock_task_mm-too
+++ a/mm/oom_kill.c
@@ -336,35 +336,38 @@ static struct task_struct *select_bad_pr
  */
 static void dump_tasks(const struct mem_cgroup *mem)
 {
-	struct task_struct *g, *p;
+	struct task_struct *p;
+	struct task_struct *task;
 
 	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
 	       "name\n");
-	do_each_thread(g, p) {
-		struct mm_struct *mm;
-
-		if (mem && !task_in_mem_cgroup(p, mem))
+	for_each_process(p) {
+		/*
+		 * We don't have is_global_init() check here, because the old
+		 * code do that. printing init process is not big matter. But
+		 * we don't hope to make unnecessary compatibility breaking.
+		 */
+		if (p->flags & PF_KTHREAD)
 			continue;
-		if (!thread_group_leader(p))
+		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 
-		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
+		task = find_lock_task_mm(p);
+		if (!task) {
 			/*
-			 * total_vm and rss sizes do not exist for tasks with no
-			 * mm so there's no need to report them; they can't be
-			 * oom killed anyway.
+			 * Probably oom vs task-exiting race was happen and ->mm
+			 * have been detached. thus there's no need to report
+			 * them; they can't be oom killed anyway.
 			 */
-			task_unlock(p);
 			continue;
 		}
+
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
-		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
-		       get_mm_rss(mm), (int)task_cpu(p), p->signal->oom_adj,
-		       p->comm);
-		task_unlock(p);
-	} while_each_thread(g, p);
+		       task->pid, __task_cred(task)->uid, task->tgid,
+		       task->mm->total_vm, get_mm_rss(task->mm),
+		       (int)task_cpu(task), task->signal->oom_adj, p->comm);
+		task_unlock(task);
+	}
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mm-use-memdup_user.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
reiser4.patch

