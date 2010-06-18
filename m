From: akpm@linux-foundation.org
Subject: + mempolicy-reduce-stack-size-of-migrate_pages.patch added to -mm tree
Date: Fri, 18 Jun 2010 14:39:17 -0700
Message-ID: <201006182139.o5ILdHUB024852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47571 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753084Ab0FRVjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jun 2010 17:39:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     mempolicy: reduce stack size of migrate_pages()
has been added to the -mm tree.  Its filename is
     mempolicy-reduce-stack-size-of-migrate_pages.patch

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
Subject: mempolicy: reduce stack size of migrate_pages()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

migrate_pages() is using >500 bytes stack. Reduce it.

   mm/mempolicy.c: In function 'sys_migrate_pages':
   mm/mempolicy.c:1344: warning: the frame size of 528 bytes is larger than 512 bytes

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-reduce-stack-size-of-migrate_pages mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-reduce-stack-size-of-migrate_pages
+++ a/mm/mempolicy.c
@@ -1275,33 +1275,39 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 		const unsigned long __user *, new_nodes)
 {
 	const struct cred *cred = current_cred(), *tcred;
-	struct mm_struct *mm;
+	struct mm_struct *mm = NULL;
 	struct task_struct *task;
-	nodemask_t old;
-	nodemask_t new;
 	nodemask_t task_nodes;
 	int err;
+	NODEMASK_SCRATCH(scratch);
+	nodemask_t *old = &scratch->mask1;
+	nodemask_t *new = &scratch->mask2;
 
-	err = get_nodes(&old, old_nodes, maxnode);
+	if (!scratch)
+		return -ENOMEM;
+
+	err = get_nodes(old, old_nodes, maxnode);
 	if (err)
-		return err;
+		goto out;
 
-	err = get_nodes(&new, new_nodes, maxnode);
+	err = get_nodes(new, new_nodes, maxnode);
 	if (err)
-		return err;
+		goto out;
 
 	/* Find the mm_struct */
 	read_lock(&tasklist_lock);
 	task = pid ? find_task_by_vpid(pid) : current;
 	if (!task) {
 		read_unlock(&tasklist_lock);
-		return -ESRCH;
+		err = -ESRCH;
+		goto out;
 	}
 	mm = get_task_mm(task);
 	read_unlock(&tasklist_lock);
 
+	err = -EINVAL;
 	if (!mm)
-		return -EINVAL;
+		goto out;
 
 	/*
 	 * Check if this process has the right to modify the specified
@@ -1322,12 +1328,12 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 
 	task_nodes = cpuset_mems_allowed(task);
 	/* Is the user allowed to access the target nodes? */
-	if (!nodes_subset(new, task_nodes) && !capable(CAP_SYS_NICE)) {
+	if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out;
 	}
 
-	if (!nodes_subset(new, node_states[N_HIGH_MEMORY])) {
+	if (!nodes_subset(*new, node_states[N_HIGH_MEMORY])) {
 		err = -EINVAL;
 		goto out;
 	}
@@ -1336,10 +1342,13 @@ SYSCALL_DEFINE4(migrate_pages, pid_t, pi
 	if (err)
 		goto out;
 
-	err = do_migrate_pages(mm, &old, &new,
+	err = do_migrate_pages(mm, old, new,
 		capable(CAP_SYS_NICE) ? MPOL_MF_MOVE_ALL : MPOL_MF_MOVE);
 out:
-	mmput(mm);
+	if (mm)
+		mmput(mm);
+	NODEMASK_SCRATCH_FREE(scratch);
+
 	return err;
 }
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

mempolicy-fix-dangling-reference-to-tmpfs-superblock-mpol.patch
acpi-fix-unused-function-warning.patch
mm-use-memdup_user.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-pf_exiting-check-should-take-mm-into-account.patch
oom-introduce-find_lock_task_mm-to-fix-mm-false-positives.patch
oom-dump_tasks-use-find_lock_task_mm-too.patch
oom-improve-commentary-in-dump_tasks.patch
oom-dump_tasks-use-find_lock_task_mm-too-dump_tasks-use-find_lock_task_mm-too-fix.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-protect-dereferencing-of-tasks-comm.patch
oom-sacrifice-child-with-highest-badness-score-for-parent-fix.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-add-has_intersects_mems_allowed-uma-variant.patch
oom-select-task-from-tasklist-for-mempolicy-ooms-introduce-find_lock_task_mm-to-fix-mm-false-positives-fix.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
reiser4.patch

