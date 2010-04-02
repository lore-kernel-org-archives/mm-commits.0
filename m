From: akpm@linux-foundation.org
Subject: + oom-clean-up-oom_badness.patch added to -mm tree
Date: Fri, 02 Apr 2010 15:25:59 -0700
Message-ID: <201004022225.o32MPxOM008845@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498Ab0DBW0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Apr 2010 18:26:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com


The patch titled
     oom: clean up oom_badness()
has been added to the -mm tree.  Its filename is
     oom-clean-up-oom_badness.patch

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
Subject: oom: clean up oom_badness()
From: David Rientjes <rientjes@google.com>

oom_badness() no longer uses its uptime formal, so it can be removed.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c      |    5 +----
 include/linux/oom.h |    3 +--
 mm/oom_kill.c       |   12 +++---------
 3 files changed, 5 insertions(+), 15 deletions(-)

diff -puN fs/proc/base.c~oom-clean-up-oom_badness fs/proc/base.c
--- a/fs/proc/base.c~oom-clean-up-oom_badness
+++ a/fs/proc/base.c
@@ -444,9 +444,7 @@ static const struct file_operations proc
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
 	unsigned long points = 0;
-	struct timespec uptime;
 
-	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
 	if (pid_alive(task))
 		points = oom_badness(task->group_leader,
@@ -454,8 +452,7 @@ static int proc_oom_score(struct task_st
 					global_page_state(NR_ACTIVE_ANON) +
 					global_page_state(NR_INACTIVE_FILE) +
 					global_page_state(NR_ACTIVE_FILE) +
-					total_swap_pages,
-					uptime.tv_sec);
+					total_swap_pages);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
diff -puN include/linux/oom.h~oom-clean-up-oom_badness include/linux/oom.h
--- a/include/linux/oom.h~oom-clean-up-oom_badness
+++ a/include/linux/oom.h
@@ -40,8 +40,7 @@ enum oom_constraint {
 	CONSTRAINT_MEMORY_POLICY,
 };
 
-extern int oom_badness(struct task_struct *p,
-			unsigned long totalpages, unsigned long uptime);
+extern int oom_badness(struct task_struct *p, unsigned long totalpages);
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
diff -puN mm/oom_kill.c~oom-clean-up-oom_badness mm/oom_kill.c
--- a/mm/oom_kill.c~oom-clean-up-oom_badness
+++ a/mm/oom_kill.c
@@ -149,14 +149,12 @@ static unsigned long oom_forkbomb_penalt
  * oom_badness - heuristic function to determine which candidate task to kill
  * @p: task struct of which task we should calculate
  * @totalpages: total present RAM allowed for page allocation
- * @uptime: current uptime in seconds
  *
  * The heuristic for determining which task to kill is made to be as simple and
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom conditions.
  */
-int oom_badness(struct task_struct *p, unsigned long totalpages,
-							unsigned long uptime)
+int oom_badness(struct task_struct *p, unsigned long totalpages)
 {
 	int points;
 
@@ -294,10 +292,8 @@ static struct task_struct *select_bad_pr
 {
 	struct task_struct *p;
 	struct task_struct *chosen = NULL;
-	struct timespec uptime;
 	*ppoints = 0;
 
-	do_posix_clock_monotonic_gettime(&uptime);
 	for_each_process(p) {
 		int points;
 
@@ -344,7 +340,7 @@ static struct task_struct *select_bad_pr
 		if (p->signal->oom_score_adj == OOM_SCORE_ADJ_MIN)
 			continue;
 
-		points = oom_badness(p, totalpages, uptime.tv_sec);
+		points = oom_badness(p, totalpages);
 		if (points >= 0 && (points > *ppoints || !chosen)) {
 			chosen = p;
 			*ppoints = points;
@@ -448,7 +444,6 @@ static int oom_kill_process(struct task_
 	struct task_struct *victim = p;
 	struct task_struct *c;
 	unsigned int victim_points = 0;
-	struct timespec uptime;
 
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem);
@@ -465,7 +460,6 @@ static int oom_kill_process(struct task_
 	pr_err("%s: Kill process %d (%s) with score %d or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
 
-	do_posix_clock_monotonic_gettime(&uptime);
 	/* Try to sacrifice the worst child first */
 	list_for_each_entry(c, &p->children, sibling) {
 		unsigned int cpoints;
@@ -476,7 +470,7 @@ static int oom_kill_process(struct task_
 			continue;
 
 		/* oom_badness() returns 0 if the thread is unkillable */
-		cpoints = oom_badness(c, totalpages, uptime.tv_sec);
+		cpoints = oom_badness(c, totalpages);
 		if (cpoints > victim_points) {
 			victim = c;
 			victim_points = cpoints;
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi-map-pxms-to-low-node-ids.patch
mempolicy-remove-redundant-code.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
oom-select_bad_process-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-select_bad_process-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-oom_forkbomb_penalty-move-thread_group_cputime-out-of-task_lock.patch
oom-hold-tasklist_lock-when-dumping-tasks.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-clean-up-oom_kill_task.patch
oom-clean-up-oom_badness.patch
mempolicy-remove-case-mpol_interleave-from-policy_zonelist.patch
mempolicy-remove-redundant-check.patch
mempolicy-dont-call-mpol_set_nodemask-when-no_context.patch
mempolicy-lose-unnecessary-loop-variable-in-mpol_parse_str.patch
mempolicy-rename-policy_types-and-cleanup-initialization.patch
mempolicy-factor-mpol_shared_policy_init-return-paths.patch
mempolicy-document-cpuset-interaction-with-tmpfs-mpol-mount-option.patch
mm-default-to-node-zonelist-ordering-when-nodes-have-only-lowmem.patch
oom-move-sysctl-declarations-to-oomh.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch

