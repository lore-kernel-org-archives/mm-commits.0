From: akpm@linux-foundation.org
Subject: - mm-owner-fix-race-between-swap-and-exit.patch removed from -mm tree
Date: Wed, 01 Oct 2008 14:52:53 -0700
Message-ID: <200810012152.m91Lqr71006087@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753996AbYJAVxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 17:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balbir@linux.vnet.ibm.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     mm owner: fix race between swap and exit
has been removed from the -mm tree.  Its filename was
     mm-owner-fix-race-between-swap-and-exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm owner: fix race between swap and exit
From: Balbir Singh <balbir@linux.vnet.ibm.com>

There's a race between mm->owner assignment and try_to_unuse().  The
condition occurs when try_to_unuse() runs in parallel with an exiting
task.

The race can be visualized below.  To quote Hugh "I don't think your
careful alternation of CPU0/1 events at the end matters: the swapoff CPU
simply dereferences mm->owner after that task has gone"

But the alteration does help understand the race better (at-least for me :))

CPU0					CPU1
					try_to_unuse
task 1 stars exiting			look at mm = task1->mm
..					increment mm_users
task 1 exits
mm->owner needs to be updated, but
no new owner is found
(mm_users > 1, but no other task
has task->mm = task1->mm)
mm_update_next_owner() leaves

grace period
					user count drops, call mmput(mm)
task 1 freed
					dereferencing mm->owner fails

The fix is to notify the subsystem (via mm_owner_changed callback), if no
new owner is found by specifying the new task as NULL.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reported-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |    5 +++--
 kernel/exit.c   |   10 ++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup.c~mm-owner-fix-race-between-swap-and-exit kernel/cgroup.c
--- a/kernel/cgroup.c~mm-owner-fix-race-between-swap-and-exit
+++ a/kernel/cgroup.c
@@ -2743,14 +2743,15 @@ void cgroup_fork_callbacks(struct task_s
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
-	struct cgroup *oldcgrp, *newcgrp;
+	struct cgroup *oldcgrp, *newcgrp = NULL;
 
 	if (need_mm_owner_callback) {
 		int i;
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 			oldcgrp = task_cgroup(old, ss->subsys_id);
-			newcgrp = task_cgroup(new, ss->subsys_id);
+			if (new)
+				newcgrp = task_cgroup(new, ss->subsys_id);
 			if (oldcgrp == newcgrp)
 				continue;
 			if (ss->mm_owner_changed)
diff -puN kernel/exit.c~mm-owner-fix-race-between-swap-and-exit kernel/exit.c
--- a/kernel/exit.c~mm-owner-fix-race-between-swap-and-exit
+++ a/kernel/exit.c
@@ -634,6 +634,16 @@ retry:
 	} while_each_thread(g, c);
 
 	read_unlock(&tasklist_lock);
+	/*
+	 * We found no owner and mm_users > 1, this implies that
+	 * we are most likely racing with swap (try_to_unuse())
+	 * Mark owner as NULL, so that subsystems can understand
+	 * the callback and take action
+	 */
+	down_write(&mm->mmap_sem);
+	mm->owner = NULL;
+	cgroup_mm_owner_callbacks(mm->owner, NULL);
+	up_write(&mm->mmap_sem);
 	return;
 
 assign_new_owner:
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-enhance-mm_owner_changed-callback-to-deal-with-exited-owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memory-rlimit-fix-crash-on-fork.patch
memrlimit-add-memrlimit-controller-accounting-and-control-fix-task_lock-recursive-locking-v2.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch

