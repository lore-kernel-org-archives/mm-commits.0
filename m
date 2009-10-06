From: akpm@linux-foundation.org
Subject: + ipc-semc-optimize-single-semop-operations.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:17:43 -0700
Message-ID: <200910062117.n96LHh9J000846@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933419AbZJFVSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:18:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, npiggin@suse.de, peifferp@gmail.com


The patch titled
     ipc/sem.c: optimize single semop operations
has been added to the -mm tree.  Its filename is
     ipc-semc-optimize-single-semop-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -433,17 +433,45 @@ static void unlink_queue(struct sem_arra
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
@@ -768,7 +796,7 @@ static int semctl_main(struct ipc_namesp
 		}
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		err = 0;
 		goto out_unlock;
 	}
@@ -810,7 +838,7 @@ static int semctl_main(struct ipc_namesp
 		curr->sempid = task_tgid_vnr(current);
 		sma->sem_ctime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, semnum);
 		err = 0;
 		goto out_unlock;
 	}
@@ -1186,7 +1214,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	error = try_atomic_semop (sma, sops, nsops, un, task_tgid_vnr(current));
 	if (error <= 0) {
 		if (alter && error == 0)
-			update_queue (sma);
+			update_queue(sma, (nsops == 1) ? sops[0].sem_num : -1);
+
 		goto out_unlock_free;
 	}
 
@@ -1387,7 +1416,7 @@ void exit_sem(struct task_struct *tsk)
 		}
 		sma->sem_otime = get_seconds();
 		/* maybe some queued-up processes were waiting for this */
-		update_queue(sma);
+		update_queue(sma, -1);
 		sem_unlock(sma);
 
 		call_rcu(&un->rcu, free_un);
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-sem-optimise-undo-list-search.patch
ipc-semc-sem-use-list-operations.patch
ipc-semc-sem-preempt-improve.patch
ipc-semc-optimize-if-semops-fail.patch
ipc-semc-add-a-per-semaphore-pending-list.patch
ipc-semc-optimize-single-semop-operations.patch
ipc-semc-optimize-single-sops-when-semval-is-zero.patch
slab-leaks3-default-y.patch

