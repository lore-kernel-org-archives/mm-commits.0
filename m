From: akpm@linux-foundation.org
Subject: + freezer_cg-remove-redundant-check-in-freezer_can_attach.patch added to -mm tree
Date: Tue, 21 Oct 2008 13:58:24 -0700
Message-ID: <200810212058.m9LKwOXV018398@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35457 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752507AbYJUU7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Oct 2008 16:59:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, clg@fr.ibm.com


The patch titled
     freezer_cg: remove redundant check in freezer_can_attach()
has been added to the -mm tree.  Its filename is
     freezer_cg-remove-redundant-check-in-freezer_can_attach.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: freezer_cg: remove redundant check in freezer_can_attach()
From: Li Zefan <lizf@cn.fujitsu.com>

It is sufficient to check if @task is frozen, and no need to check if the
original freezer is frozen.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN kernel/cgroup_freezer.c~freezer_cg-remove-redundant-check-in-freezer_can_attach kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~freezer_cg-remove-redundant-check-in-freezer_can_attach
+++ a/kernel/cgroup_freezer.c
@@ -162,9 +162,13 @@ static int freezer_can_attach(struct cgr
 			      struct task_struct *task)
 {
 	struct freezer *freezer;
-	int retval;
 
-	/* Anything frozen can't move or be moved to/from */
+	/*
+	 * Anything frozen can't move or be moved to/from.
+	 *
+	 * Since orig_freezer->state == FROZEN means that @task has been
+	 * frozen, so it's sufficient to check the latter condition.
+	 */
 
 	if (is_task_frozen_enough(task))
 		return -EBUSY;
@@ -173,13 +177,7 @@ static int freezer_can_attach(struct cgr
 	if (freezer->state == CGROUP_FROZEN)
 		return -EBUSY;
 
-	retval = 0;
-	task_lock(task);
-	freezer = task_freezer(task);
-	if (freezer->state == CGROUP_FROZEN)
-		retval = -EBUSY;
-	task_unlock(task);
-	return retval;
+	return 0;
 }
 
 static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

origin.patch
freezer_cg-fix-improper-bug_on-causing-oops.patch
freezer_cg-remove-redundant-check-in-freezer_can_attach.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup.patch
freezer_cg-use-thaw_process-in-unfreeze_cgroup-fix.patch
freezer_cg-simplify-freezer_change_state.patch
cgroups-tiny-cleanups.patch

