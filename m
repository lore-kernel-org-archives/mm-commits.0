From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-change-perform_atomic_semop-parameters.patch
 removed from -mm tree
Date: Mon, 09 Jun 2014 12:38:02 -0700
Message-ID: <53960d1a./nY+LymAgC/fmepl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFITiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jun 2014 15:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [merged] ipc-semc-change-perform_atomic_semop-parameters.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Jun 2014 12:38:02 -0700


The patch titled
     Subject: ipc/sem.c: change perform_atomic_semop parameters
has been removed from the -mm tree.  Its filename was
     ipc-semc-change-perform_atomic_semop-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: change perform_atomic_semop parameters

Right now, perform_atomic_semop gets the content of sem_queue as
individual fields.  Changes that, instead pass a pointer to sem_queue.

This is a preparation for the next patch: it uses sem_queue to store the
reason why a task must sleep.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff -puN ipc/sem.c~ipc-semc-change-perform_atomic_semop-parameters ipc/sem.c
--- a/ipc/sem.c~ipc-semc-change-perform_atomic_semop-parameters
+++ a/ipc/sem.c
@@ -585,21 +585,23 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 /**
  * perform_atomic_semop - Perform (if possible) a semaphore operation
  * @sma: semaphore array
- * @sops: array with operations that should be checked
- * @nsops: number of operations
- * @un: undo array
- * @pid: pid that did the change
+ * @q: struct sem_queue that describes the operation
  *
  * Returns 0 if the operation was possible.
  * Returns 1 if the operation is impossible, the caller must sleep.
  * Negative values are error codes.
  */
-static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
-			     int nsops, struct sem_undo *un, int pid)
+static int perform_atomic_semop(struct sem_array *sma, struct sem_queue *q)
 {
-	int result, sem_op;
+	int result, sem_op, nsops, pid;
 	struct sembuf *sop;
 	struct sem *curr;
+	struct sembuf *sops;
+	struct sem_undo *un;
+
+	sops = q->sops;
+	nsops = q->nsops;
+	un = q->undo;
 
 	for (sop = sops; sop < sops + nsops; sop++) {
 		curr = sma->sem_base + sop->sem_num;
@@ -627,6 +629,7 @@ static int perform_atomic_semop(struct s
 	}
 
 	sop--;
+	pid = q->pid;
 	while (sop >= sops) {
 		sma->sem_base[sop->sem_num].sempid = pid;
 		sop--;
@@ -779,8 +782,7 @@ static int wake_const_ops(struct sem_arr
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
-		error = perform_atomic_semop(sma, q->sops, q->nsops,
-						 q->undo, q->pid);
+		error = perform_atomic_semop(sma, q);
 
 		if (error <= 0) {
 			/* operation completed, remove from queue & wakeup */
@@ -892,8 +894,7 @@ again:
 		if (semnum != -1 && sma->sem_base[semnum].semval == 0)
 			break;
 
-		error = perform_atomic_semop(sma, q->sops, q->nsops,
-					 q->undo, q->pid);
+		error = perform_atomic_semop(sma, q);
 
 		/* Does q->sleeper still need to sleep? */
 		if (error > 0)
@@ -1871,8 +1872,13 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	if (un && un->semid == -1)
 		goto out_unlock_free;
 
-	error = perform_atomic_semop(sma, sops, nsops, un,
-					task_tgid_vnr(current));
+	queue.sops = sops;
+	queue.nsops = nsops;
+	queue.undo = un;
+	queue.pid = task_tgid_vnr(current);
+	queue.alter = alter;
+
+	error = perform_atomic_semop(sma, &queue);
 	if (error == 0) {
 		/* If the operation was successful, then do
 		 * the required updates.
@@ -1889,12 +1895,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	 * task into the pending queue and go to sleep.
 	 */
 
-	queue.sops = sops;
-	queue.nsops = nsops;
-	queue.undo = un;
-	queue.pid = task_tgid_vnr(current);
-	queue.alter = alter;
