From: akpm@linux-foundation.org
Subject: + shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
 added to -mm tree
Date: Wed, 18 Jun 2014 16:00:15 -0700
Message-ID: <53a219ff.AkxlKxgVFBCgKnUj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42935 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156AbaFRXAQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:00:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, miltonm@bga.com, manfred@colorfullife.com, davidlohr@hp.com, anton@samba.org, millerjo@us.ibm.com


The patch titled
     Subject: shm: allow exit_shm in parallel if only marking orphans
has been added to the -mm tree.  Its filename is
     shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jack Miller <millerjo@us.ibm.com>
Subject: shm: allow exit_shm in parallel if only marking orphans

If shm_rmid_force (the default state) is not set then the shmids are only
marked as orphaned and does not require any add, delete, or locking of the
tree structure.

Seperate the sysctl on and off case, and only obtain the read lock.  The
newly added list head can be deleted under the read lock because we are
only called with current and will only change the semids allocated by this
task and not manipulate the list.

This commit assumes that up_read includes a sufficient memory barrier for
the writes to be seen my others that later obtain a write lock.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Jack Miller <millerjo@us.ibm.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/shm.c |   67 +++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

diff -puN ipc/shm.c~shm-allow-exit_shm-in-parallel-if-only-marking-orphans ipc/shm.c
--- a/ipc/shm.c~shm-allow-exit_shm-in-parallel-if-only-marking-orphans
+++ a/ipc/shm.c
@@ -269,32 +269,6 @@ static void shm_close(struct vm_area_str
 }
 
 /* Called with ns->shm_ids(ns).rwsem locked */
-static void shm_mark_orphan(struct shmid_kernel *shp, struct ipc_namespace *ns)
-{
-	if (WARN_ON(shp->shm_creator != current)) /* Remove me when it works */
-		return;
-
-	/*
-	 * Mark it as orphaned to destroy the segment when
-	 * kernel.shm_rmid_forced is changed.
-	 * It is noop if the following shm_may_destroy() returns true.
-	 */
-	shp->shm_creator = NULL;
-
-	/*
-	 * Don't even try to destroy it.  If shm_rmid_forced=0 and IPC_RMID
-	 * is not set, it shouldn't be deleted here.
-	 */
-	if (!ns->shm_rmid_forced)
-		return;
-
-	if (shm_may_destroy(ns, shp)) {
-		shm_lock_by_ptr(shp);
-		shm_destroy(ns, shp);
-	}
-}
-
-/* Called with ns->shm_ids(ns).rwsem locked */
 static int shm_try_destroy_orphaned(int id, void *p, void *data)
 {
 	struct ipc_namespace *ns = data;
@@ -325,20 +299,49 @@ void shm_destroy_orphaned(struct ipc_nam
 	up_write(&shm_ids(ns).rwsem);
 }
 
-
+/* Locking assumes this will only be called with task == current */
 void exit_shm(struct task_struct *task)
 {
 	struct ipc_namespace *ns = task->nsproxy->ipc_ns;
 	struct shmid_kernel *shp, *n;
 
-	if (shm_ids(ns).in_use == 0)
+	if (list_empty(&task->sysvshm.shm_clist))
+		return;
+
+	/*
+	 * If kernel.shm_rmid_forced is not set then only keep track of
+	 * which shmids are orphaned, so that a later set of the sysctl
+	 * can clean them up.
+	 */
+	if (!ns->shm_rmid_forced) {
+		down_read(&shm_ids(ns).rwsem);
+		list_for_each_entry(shp, &task->sysvshm.shm_clist, shm_clist)
+			shp->shm_creator = NULL;
+		/*
+		 * Only under read lock but we are only called on current
+		 * so no entry on the list will be shared.
+		 */
+		list_del(&task->sysvshm.shm_clist);
+		up_read(&shm_ids(ns).rwsem);
 		return;
+	}
 
-	/* Destroy all already created segments, but not mapped yet */
+	/*
+	 * Destroy all already created segments, that were not yet mapped,
+	 * and mark any mapped as orphan to cover the sysctl toggling.
+	 * Destroy is skipped if shm_may_destroy() returns false.
+	 */
 	down_write(&shm_ids(ns).rwsem);
-	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist)
-		shm_mark_orphan(shp, ns);
-	/* remove the list head from any segments still attached */
+	list_for_each_entry_safe(shp, n, &task->sysvshm.shm_clist, shm_clist) {
+		shp->shm_creator = NULL;
+
+		if (shm_may_destroy(ns, shp)) {
+			shm_lock_by_ptr(shp);
+			shm_destroy(ns, shp);
+		}
+	}
+
+	/* Remove the list head from any segments still attached. */
 	list_del(&task->sysvshm.shm_clist);
 	up_write(&shm_ids(ns).rwsem);
 }
_

Patches currently in -mm which might be from millerjo@us.ibm.com are

shm-make-exit_shm-work-proportional-to-task-activity.patch
shm-allow-exit_shm-in-parallel-if-only-marking-orphans.patch
shm-remove-unneeded-extern-for-function.patch

