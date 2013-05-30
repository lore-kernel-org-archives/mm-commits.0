From: akpm@linux-foundation.org
Subject: + ipc-semc-always-use-only-one-queue-for-alter-operations.patch
 added to -mm tree
Date: Thu, 30 May 2013 14:13:51 -0700
Message-ID: <51a7c10f.ekJz9vbWU1CeEUx3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab3E3VNw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 17:13:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-always-use-only-one-queue-for-alter-operations.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 14:13:51 -0700


The patch titled
     Subject: ipc/sem.c: Always use only one queue for alter operations.
has been added to the -mm tree.  Its filename is
     ipc-semc-always-use-only-one-queue-for-alter-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: Always use only one queue for alter operations.

There are two places that can contain alter operations:
- the global queue: sma->pending_alter
- the per-semaphore queues: sma->sem_base[].pending_alter.

Since one of the queues must be processed first, this causes an odd
priorization of the wakeups:
Right now, complex operations have priority over simple ops.

The patch restores the behavior of linux <=3.0.9: The longest
waiting operation has the highest priority.

This is done by using only one queue:
- if there are complex ops, then sma->pending_alter is used.
- otherwise, the per-semaphore queues are used.

As a side effect, do_smart_update_queue() becomes much simpler:
No more goto logic.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  128 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 40 deletions(-)

diff -puN ipc/sem.c~ipc-semc-always-use-only-one-queue-for-alter-operations ipc/sem.c
--- a/ipc/sem.c~ipc-semc-always-use-only-one-queue-for-alter-operations
+++ a/ipc/sem.c
@@ -192,6 +192,53 @@ void __init sem_init (void)
 				IPC_SEM_IDS, sysvipc_sem_proc_show);
 }
 
+/**
+ * unmerge_queues - unmerge queues, if possible.
+ * @sma: semaphore array
+ *
+ * The function unmerges the wait queues if complex_count is 0.
+ * It must be called prior to dropping the global semaphore array lock.
+ */
+static void unmerge_queues(struct sem_array *sma)
+{
+	struct sem_queue *q, *tq;
+
+	/* complex operations still around? */
+	if (sma->complex_count)
+		return;
+	/*
+	 * We will switch back to simple mode.
+	 * Move all pending operation back into the per-semaphore
+	 * queues.
+	 */
+	list_for_each_entry_safe(q, tq, &sma->pending_alter, list) {
+		struct sem *curr;
+		curr = &sma->sem_base[q->sops[0].sem_num];
+
+		list_add_tail(&q->list, &curr->pending_alter);
+	}
+	INIT_LIST_HEAD(&sma->pending_alter);
+}
+
+/**
+ * merge_queues - Merge single semop queues into global queue
+ * @sma: semaphore array
+ *
+ * This function merges all per-semaphore queues into the global queue.
+ * It is necessary to achieve FIFO ordering for the pending single-sop
+ * operations when a multi-semop operation must sleep.
+ * Only the alter operations must be moved, the const operations can stay.
+ */
+static void merge_queues(struct sem_array *sma)
+{
+	int i;
+	for (i = 0; i < sma->sem_nsems; i++) {
+		struct sem *sem = sma->sem_base + i;
+
+		list_splice_init(&sem->pending_alter, &sma->pending_alter);
+	}
+}
+
 /*
  * If the request contains only one semaphore operation, and there are
  * no complex transactions pending, lock only the semaphore involved.
@@ -262,6 +309,7 @@ static inline int sem_lock(struct sem_ar
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
+		unmerge_queues(sma);
 		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -831,49 +879,38 @@ static void do_smart_update(struct sem_a
 			int otime, struct list_head *pt)
 {
 	int i;
-	int progress;
 
 	otime |= do_smart_wakeup_zero(sma, sops, nsops, pt);
 
-	progress = 1;
-retry_global:
-	if (sma->complex_count) {
-		if (update_queue(sma, -1, pt)) {
-			progress = 1;
-			otime = 1;
-			sops = NULL;
-		}
-	}
-	if (!progress)
-		goto done;
-
-	if (!sops) {
-		/* No semops; something special is going on. */
-		for (i = 0; i < sma->sem_nsems; i++) {
-			if (update_queue(sma, i, pt)) {
-				otime = 1;
-				progress = 1;
+	if (!list_empty(&sma->pending_alter)) {
+		/* semaphore array uses the global queue - just process it. */
+		otime |= update_queue(sma, -1, pt);
+	} else {
+		if (!sops) {
+			/*
+			 * No sops, thus the modified semaphores are not
+			 * known. Check all.
+			 */
+			for (i = 0; i < sma->sem_nsems; i++)
+				otime |= update_queue(sma, i, pt);
+		} else {
+			/*
+			 * Check the semaphores that were increased:
+			 * - No complex ops, thus all sleeping ops are
+			 *   decrease.
+			 * - if we decreased the value, then any sleeping
+			 *   semaphore ops wont be able to run: If the
+			 *   previous value was too small, then the new
+			 *   value will be too small, too.
+			 */
+			for (i = 0; i < nsops; i++) {
+				if (sops[i].sem_op > 0) {
+					otime |= update_queue(sma,
+							sops[i].sem_num, pt);
+				}
 			}
 		}
-		goto done_checkretry;
-	}
-
-	/* Check the semaphores that were modified. */
-	for (i = 0; i < nsops; i++) {
-		if (sops[i].sem_op > 0 ||
-			(sops[i].sem_op < 0 &&
-				sma->sem_base[sops[i].sem_num].semval == 0))
-			if (update_queue(sma, sops[i].sem_num, pt)) {
-				otime = 1;
-				progress = 1;
-			}
-	}
-done_checkretry:
-	if (progress) {
-		progress = 0;
-		goto retry_global;
 	}
-done:
 	if (otime)
 		sma->sem_otime = get_seconds();
 }
@@ -1747,11 +1784,22 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
 
-		if (alter)
-			list_add_tail(&queue.list, &curr->pending_alter);
-		else
+		if (alter) {
+			if (sma->complex_count) {
+				list_add_tail(&queue.list,
+						&sma->pending_alter);
+			} else {
+
+				list_add_tail(&queue.list,
+						&curr->pending_alter);
+			}
+		} else {
 			list_add_tail(&queue.list, &curr->pending_const);
+		}
 	} else {
+		if (!sma->complex_count)
+			merge_queues(sma);
+
 		if (alter)
 			list_add_tail(&queue.list, &sma->pending_alter);
 		else
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-sem-seperate-wait-for-zero-and-alter-tasks-into-seperate-queues.patch
ipc-semc-always-use-only-one-queue-for-alter-operations.patch
ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch
slab-leaks3-default-y.patch

