From: akpm@linux-foundation.org
Subject: [to-be-updated]
 ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch
 removed from -mm tree
Date: Tue, 11 Jun 2013 15:02:00 -0700
Message-ID: <51b79e58.iDytvjqnLCO0zZco%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988Ab3FKWCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jun 2013 18:02:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: [to-be-updated] ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch removed from -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Jun 2013 15:02:00 -0700


The patch titled
     Subject: ipc/sem.c: rename try_atomic_semop() to perform_atomic_semop(), docu update
has been removed from the -mm tree.  Its filename was
     ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: rename try_atomic_semop() to perform_atomic_semop(), docu update

Final cleanup: Some minor points that I noticed while writing the
previous 3 patches

1) The name try_atomic_semop() is misleading: The function performs the
   operation (if it is possible).

2) Some documentation updates.

No real code change, a rename and documentation changes.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff -puN ipc/sem.c~ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update ipc/sem.c
--- a/ipc/sem.c~ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update
+++ a/ipc/sem.c
@@ -153,12 +153,15 @@ static int sysvipc_sem_proc_show(struct
 #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */
 
 /*
- * linked list protection:
+ * Locking:
  *	sem_undo.id_next,
+ *	sem_array.complex_count,
  *	sem_array.pending{_alter,_cont},
- *	sem_array.sem_undo: sem_lock() for read/write
+ *	sem_array.sem_undo: global sem_lock() for read/write
  *	sem_undo.proc_next: only "current" is allowed to read/write that field.
  *	
+ *	sem_array.sem_base[i].pending_{const,alter}:
+ *		global or semaphore sem_lock() for read/write
  */
 
 #define sc_semmsl	sem_ctls[0]
@@ -537,12 +540,19 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
 }
 
-/*
- * Determine whether a sequence of semaphore operations would succeed
- * all at once. Return 0 if yes, 1 if need to sleep, else return error code.
+/** perform_atomic_semop - Perform (if possible) a semaphore operation
+ * @sma: semaphore array
+ * @sops: array with operations that should be checked
+ * @nsems: number of sops
+ * @un: undo array
+ * @pid: pid that did the change
+ *
+ * Returns 0 if the operation was possible.
+ * Returns 1 if the operation is impossible, the caller must sleep.
+ * Negative values are error codes.
  */
 
-static int try_atomic_semop (struct sem_array * sma, struct sembuf * sops,
+static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
 	int result, sem_op;
@@ -725,8 +735,8 @@ static int wake_const_ops(struct sem_arr
 		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
-						q->undo, q->pid);
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
+						 q->undo, q->pid);
 
 		if (error <= 0) {
 			/* operation completed, remove from queue & wakeup */
@@ -837,7 +847,7 @@ again:
 		if (semnum != -1 && sma->sem_base[semnum].semval == 0)
 			break;
 
-		error = try_atomic_semop(sma, q->sops, q->nsops,
+		error = perform_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
 		/* Does q->sleeper still need to sleep? */
@@ -1664,7 +1674,6 @@ static int get_queue_result(struct sem_q
 	return error;
 }
 
