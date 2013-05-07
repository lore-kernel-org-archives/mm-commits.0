From: akpm@linux-foundation.org
Subject: [merged] ipcsem-have-only-one-list-in-struct-sem_queue.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:24 -0700
Message-ID: <20130507175224.991FD31C4F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:54892 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759568Ab3EGRw0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:26 -0400
Received: by mail-gh0-f202.google.com with SMTP id g24so74798ghb.1
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@surriel.com, benisty.e@gmail.com, chegu_vinod@hp.com, davidlohr.bueso@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, sedat.dilek@gmail.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: have only one list in struct sem_queue
has been removed from the -mm tree.  Its filename was
     ipcsem-have-only-one-list-in-struct-sem_queue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: ipc,sem: have only one list in struct sem_queue

Having only one list in struct sem_queue, and only queueing simple
semaphore operations on the list for the semaphore involved, allows us to
introduce finer grained locking for semtimedop.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   65 +++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 31 deletions(-)

diff -puN ipc/sem.c~ipcsem-have-only-one-list-in-struct-sem_queue ipc/sem.c
--- a/ipc/sem.c~ipcsem-have-only-one-list-in-struct-sem_queue
+++ a/ipc/sem.c
@@ -99,7 +99,6 @@ struct sem {
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
-	struct list_head	simple_list; /* queue of pending operations */
 	struct list_head	list;	 /* queue of pending operations */
 	struct task_struct	*sleeper; /* this process */
 	struct sem_undo		*undo;	 /* undo structure */
@@ -519,7 +518,7 @@ static void wake_up_sem_queue_prepare(st
 	q->status = IN_WAKEUP;
 	q->pid = error;
 
-	list_add_tail(&q->simple_list, pt);
+	list_add_tail(&q->list, pt);
 }
 
 /**
@@ -537,7 +536,7 @@ static void wake_up_sem_queue_do(struct 
 	int did_something;
 
 	did_something = !list_empty(pt);
-	list_for_each_entry_safe(q, t, pt, simple_list) {
+	list_for_each_entry_safe(q, t, pt, list) {
 		wake_up_process(q->sleeper);
 		/* q can disappear immediately after writing q->status. */
 		smp_wmb();
@@ -550,9 +549,7 @@ static void wake_up_sem_queue_do(struct 
 static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
 {
 	list_del(&q->list);
-	if (q->nsops == 1)
-		list_del(&q->simple_list);
-	else
+	if (q->nsops > 1)
 		sma->complex_count--;
 }
 
@@ -605,9 +602,9 @@ static int check_restart(struct sem_arra
 	}
 	/*
 	 * semval is 0. Check if there are wait-for-zero semops.
-	 * They must be the first entries in the per-semaphore simple queue
+	 * They must be the first entries in the per-semaphore queue
 	 */
-	h = list_first_entry(&curr->sem_pending, struct sem_queue, simple_list);
+	h = list_first_entry(&curr->sem_pending, struct sem_queue, list);
 	BUG_ON(h->nsops != 1);
 	BUG_ON(h->sops[0].sem_num != q->sops[0].sem_num);
 
@@ -627,8 +624,9 @@ static int check_restart(struct sem_arra
  * @pt: list head for the tasks that must be woken up.
  *
  * update_queue must be called after a semaphore in a semaphore array
- * was modified. If multiple semaphore were modified, then @semnum
- * must be set to -1.
+ * was modified. If multiple semaphores were modified, update_queue must
+ * be called with semnum = -1, as well as with the number of each modified
+ * semaphore.
  * The tasks that must be woken up are added to @pt. The return code
  * is stored in q->pid.
  * The function return 1 if at least one semop was completed successfully.
@@ -638,30 +636,19 @@ static int update_queue(struct sem_array
 	struct sem_queue *q;
 	struct list_head *walk;
 	struct list_head *pending_list;
-	int offset;
 	int semop_completed = 0;
 
-	/* if there are complex operations around, then knowing the semaphore
-	 * that was modified doesn't help us. Assume that multiple semaphores
-	 * were modified.
-	 */
-	if (sma->complex_count)
-		semnum = -1;
-
-	if (semnum == -1) {
+	if (semnum == -1)
 		pending_list = &sma->sem_pending;
-		offset = offsetof(struct sem_queue, list);
-	} else {
+	else
 		pending_list = &sma->sem_base[semnum].sem_pending;
-		offset = offsetof(struct sem_queue, simple_list);
-	}
 
 again:
 	walk = pending_list->next;
 	while (walk != pending_list) {
 		int error, restart;
 
-		q = (struct sem_queue *)((char *)walk - offset);
+		q = container_of(walk, struct sem_queue, list);
 		walk = walk->next;
 
 		/* If we are scanning the single sop, per-semaphore list of
@@ -720,9 +707,18 @@ static void do_smart_update(struct sem_a
 	if (sma->complex_count || sops == NULL) {
 		if (update_queue(sma, -1, pt))
 			otime = 1;
+	}
+
+	if (!sops) {
+		/* No semops; something special is going on. */
+		for (i = 0; i < sma->sem_nsems; i++) {
+			if (update_queue(sma, i, pt))
+				otime = 1;
+		}
 		goto done;
 	}
 
+	/* Check the semaphores that were modified. */
 	for (i = 0; i < nsops; i++) {
 		if (sops[i].sem_op > 0 ||
 			(sops[i].sem_op < 0 &&
@@ -793,6 +789,7 @@ static void freeary(struct ipc_namespace
 	struct sem_queue *q, *tq;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
 	struct list_head tasks;
+	int i;
 
 	/* Free the existing undo structures for this semaphore set.  */
 	assert_spin_locked(&sma->sem_perm.lock);
@@ -811,6 +808,13 @@ static void freeary(struct ipc_namespace
 		unlink_queue(sma, q);
 		wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
 	}
+	for (i = 0; i < sma->sem_nsems; i++) {
+		struct sem *sem = sma->sem_base + i;
+		list_for_each_entry_safe(q, tq, &sem->sem_pending, list) {
+			unlink_queue(sma, q);
+			wake_up_sem_queue_prepare(&tasks, q, -EIDRM);
+		}
+	}
 
 	/* Remove the semaphore set from the IDR */
 	sem_rmid(ns, sma);
@@ -1565,21 +1569,20 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	queue.undo = un;
 	queue.pid = task_tgid_vnr(current);
 	queue.alter = alter;
-	if (alter)
-		list_add_tail(&queue.list, &sma->sem_pending);
-	else
-		list_add(&queue.list, &sma->sem_pending);
 
 	if (nsops == 1) {
 		struct sem *curr;
 		curr = &sma->sem_base[sops->sem_num];
 
 		if (alter)
-			list_add_tail(&queue.simple_list, &curr->sem_pending);
+			list_add_tail(&queue.list, &curr->sem_pending);
 		else
-			list_add(&queue.simple_list, &curr->sem_pending);
+			list_add(&queue.list, &curr->sem_pending);
 	} else {
-		INIT_LIST_HEAD(&queue.simple_list);
+		if (alter)
+			list_add_tail(&queue.list, &sma->sem_pending);
+		else
+			list_add(&queue.list, &sma->sem_pending);
 		sma->complex_count++;
 	}
 
_

Patches currently in -mm which might be from riel@surriel.com are

origin.patch

