From: akpm@linux-foundation.org
Subject: + ipc-semc-change-perform_atomic_semop-parameters.patch added to
 -mm tree
Date: Mon, 19 May 2014 15:46:49 -0700
Message-ID: <537a89d9.9+lKCkxwXLOFkiqg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbaESWqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-change-perform_atomic_semop-parameters.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:46:49 -0700


The patch titled
     Subject: ipc/sem.c: change perform_atomic_semop parameters
has been added to the -mm tree.  Its filename is
     ipc-semc-change-perform_atomic_semop-parameters.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-change-perform_atomic_semop-parameters.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-change-perform_atomic_semop-parameters.patch

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
-
 	if (nsops == 1) {
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-constify-ipc_ops.patch
ipc-shmc-check-for-ulong-overflows-in-shmat.patch
ipc-shmc-check-for-overflows-of-shm_tot.patch
ipc-shmc-check-for-integer-overflow-during-shmget.patch
ipc-shmc-increase-the-defaults-for-shmall-shmmax.patch
ipcshm-document-new-limits-in-the-uapi-header.patch
ipcshm-document-new-limits-in-the-uapi-header-v2.patch
ipcshm-document-new-limits-in-the-uapi-header-v3.patch
ipcmsg-use-current-state-helpers.patch
ipcmsg-move-some-msgq-ns-code-around.patch
ipcmsg-document-volatile-r_msg.patch
ipc-semc-bugfix-for-semctlgetzcnt.patch
ipc-semc-remove-code-duplication.patch
ipc-semc-change-perform_atomic_semop-parameters.patch
ipc-semc-store-which-operation-blocks-in-perform_atomic_semop.patch
ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch
slab-leaks3-default-y.patch

