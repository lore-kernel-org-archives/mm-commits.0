From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-optimize-single-semop-operations.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:48 -0800
Message-ID: <200912162038.nBGKcmfA013467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964980AbZLPUix (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, npiggin@suse.de, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc/sem.c: optimize single semop operations
has been removed from the -mm tree.  Its filename was
     ipc-semc-optimize-single-semop-operations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: optimize single semop operations
From: Manfred Spraul <manfred@colorfullife.com>

sysv sem has the concept of semaphore arrays that consist out of multiple
semaphores.  Atomic operations that affect multiple semaphores are
supported.

The patch optimizes single semaphore operation calls that affect only one
semaphore: It's not necessary to scan all pending operations, it is
sufficient to scan the per-semaphore list.

The idea is from Nick Piggin version of an ipc sem improvement, the
implementation is different: The code tries to keep as much common code as
possible.

As the result, the patch is simpler, but optimizes fewer cases.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff -puN ipc/sem.c~ipc-semc-optimize-single-semop-operations ipc/sem.c
--- a/ipc/sem.c~ipc-semc-optimize-single-semop-operations
+++ a/ipc/sem.c
@@ -434,17 +434,45 @@ static void unlink_queue(struct sem_arra
 		sma->complex_count--;
 }
 
-/* Go through the pending queue for the indicated semaphore
- * looking for tasks that can be completed.
+
+/**
+ * update_queue(sma, semnum): Look for tasks that can be completed.
+ * @sma: semaphore array.
+ * @semnum: semaphore that was modified.
+ *
+ * update_queue must be called after a semaphore in a semaphore array
+ * was modified. If multiple semaphore were modified, then @semnum
+ * must be set to -1.
  */
-static void update_queue (struct sem_array * sma)
+static void update_queue(struct sem_array *sma, int semnum)
 {
-	struct sem_queue *q, *tq;
+	struct sem_queue *q;
+	struct list_head *walk;
+	struct list_head *pending_list;
+	int offset;
+
+	/* if there are complex operations around, then knowing the semaphore
+	 * that was modified doesn't help us. Assume that multiple semaphores
+	 * were modified.
+	 */
+	if (sma->complex_count)
+		semnum = -1;
+
+	if (semnum == -1) {
+		pending_list = &sma->sem_pending;
+		offset = offsetof(struct sem_queue, list);
+	} else {
+		pending_list = &sma->sem_base[semnum].sem_pending;
+		offset = offsetof(struct sem_queue, simple_list);
+	}
 
 again:
-	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
-		int error;
-		int alter;
+	walk = pending_list->next;
+	while (walk != pending_list) {
+		int error, alter;
+
+		q = (struct sem_queue *)((char *)walk - offset);
+		walk = walk->next;
 
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
@@ -769,7 +797,7 @@ static int semctl_main(struct ipc_namesp
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		err = 0;
 		goto out_unlock;
 	}
@@ -811,7 +839,7 @@ static int semctl_main(struct ipc_namesp
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, semnum);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1187,7 +1215,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			update_queue (sma);
+			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
+
 		goto out_unlock_free;
 	}
 
@@ -1388,7 +1417,7 @@ void exit_sem(struct task_struct *tsk)
 		}
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		sem_unlock(sma);
 
 		call_rcu(&un->rcu, free_un);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
slab-leaks3-default-y.patch

