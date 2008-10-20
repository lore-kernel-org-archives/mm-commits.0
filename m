From: akpm@linux-foundation.org
Subject: - container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:24 -0700
Message-ID: <200810202034.m9KKYOGX010836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753593AbYJTUey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthltc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     container freezer: prevent frozen tasks or cgroups from changing
has been removed from the -mm tree.  Its filename was
     container-freezer-prevent-frozen-tasks-or-cgroups-from-changing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: container freezer: prevent frozen tasks or cgroups from changing
From: Matt Helsley <matthltc@us.ibm.com>

Don't let frozen tasks or cgroups change.  This means frozen tasks can't
leave their current cgroup for another cgroup.  It also means that tasks
cannot be added to or removed from a cgroup in the FROZEN state.  We
enforce these rules by checking for frozen tasks and cgroups in the
can_attach() function.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup_freezer.c |   43 ++++++++++++++++++++++----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff -puN kernel/cgroup_freezer.c~container-freezer-prevent-frozen-tasks-or-cgroups-from-changing kernel/cgroup_freezer.c
--- a/kernel/cgroup_freezer.c~container-freezer-prevent-frozen-tasks-or-cgroups-from-changing
+++ a/kernel/cgroup_freezer.c
@@ -145,22 +145,40 @@ static void freezer_destroy(struct cgrou
 	kfree(cgroup_freezer(cgroup));
 }
 
+/* Task is frozen or will freeze immediately when next it gets woken */
+static bool is_task_frozen_enough(struct task_struct *task)
+{
+	return frozen(task) ||
+		(task_is_stopped_or_traced(task) && freezing(task));
+}
 
+/*
+ * The call to cgroup_lock() in the freezer.state write method prevents
+ * a write to that file racing against an attach, and hence the
+ * can_attach() result will remain valid until the attach completes.
+ */
 static int freezer_can_attach(struct cgroup_subsys *ss,
 			      struct cgroup *new_cgroup,
 			      struct task_struct *task)
 {
 	struct freezer *freezer;
-	int retval = 0;
+	int retval;
+
+	/* Anything frozen can't move or be moved to/from */
+
+	if (is_task_frozen_enough(task))
+		return -EBUSY;
 
-	/*
-	 * The call to cgroup_lock() in the freezer.state write method prevents
-	 * a write to that file racing against an attach, and hence the
-	 * can_attach() result will remain valid until the attach completes.
-	 */
 	freezer = cgroup_freezer(new_cgroup);
 	if (freezer->state == STATE_FROZEN)
+		return -EBUSY;
+
+	retval = 0;
+	task_lock(task);
+	freezer = task_freezer(task);
+	if (freezer->state == STATE_FROZEN)
 		retval = -EBUSY;
+	task_unlock(task);
 	return retval;
 }
 
@@ -193,12 +211,7 @@ static void check_if_frozen(struct cgrou
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		/*
-		 * Task is frozen or will freeze immediately when next it gets
-		 * woken
-		 */
-		if (frozen(task) ||
-		    (task_is_stopped_or_traced(task) && freezing(task)))
+		if (is_task_frozen_enough(task))
 			nfrozen++;
 	}
 
@@ -249,11 +262,7 @@ static int try_to_freeze_cgroup(struct c
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
 			continue;
-		if (task_is_stopped_or_traced(task) && freezing(task))
-			/*
-			 * The freeze flag is set so these tasks will
-			 * immediately go into the fridge upon waking.
-			 */
+		if (is_task_frozen_enough(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;
_

Patches currently in -mm which might be from matthltc@us.ibm.com are

origin.patch

