From: akpm@linux-foundation.org
Subject: - freezer_cg-remove-task_lock-from-freezer_fork.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:26:44 -0800
Message-ID: <200811132126.mADLQijq027452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36327 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751869AbYKMVgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:36:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, clg@fr.ibm.com, matthltc@us.ibm.com, menage@google.com, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     freezer_cg: remove task_lock from freezer_fork()
has been removed from the -mm tree.  Its filename was
     freezer_cg-remove-task_lock-from-freezer_fork.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freezer_cg: remove task_lock from freezer_fork()
From: Li Zefan <lizf@cn.fujitsu.com>

In theory the task can be moved to another cgroup and the freezer will be
freed right after task_lock is dropped, so the lock results in zero
protection.

But in the case of freezer_fork() no lock is needed, since the task is not
in tasklist yet so it won't be moved to another cgroup, so task->cgroups
won't be changed or invalidated.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/cgroup_freezer.c~freezer_cg-remove-task_lock-from-freezer_fork kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~freezer_cg-remove-task_lock-from-freezer_fork
+++ a/kernel/cgroup_freezer.c
@@ -184,9 +184,13 @@ static void freezer_fork(struct cgroup_s
 {
 	struct freezer *freezer;
 
-	task_lock(task);
+	/*
+	 * No lock is needed, since the task isn't on tasklist yet,
+	 * so it can't be moved to another cgroup, which means the
+	 * freezer won't be removed and will be valid during this
+	 * function call.
+	 */
 	freezer = task_freezer(task);
-	task_unlock(task);
 
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
linux-next.patch

