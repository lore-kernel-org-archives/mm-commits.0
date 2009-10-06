From: akpm@linux-foundation.org
Subject: + ipc-semc-add-a-per-semaphore-pending-list.patch added to -mm tree
Date: Tue, 06 Oct 2009 14:17:41 -0700
Message-ID: <200910062117.n96LHfsq000813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46537 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933417AbZJFVSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:18:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, npiggin@suse.de, peifferp@gmail.com


The patch titled
     ipc/sem.c: add a per-semaphore pending list
has been added to the -mm tree.  Its filename is
     ipc-semc-add-a-per-semaphore-pending-list.patch

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
Subject: ipc/sem.c: add a per-semaphore pending list
From: Manfred Spraul <manfred@colorfullife.com>

Based on Nick's findings:

sysv sem has the concept of semaphore arrays that consist out of multiple
semaphores.  Atomic operations that affect multiple semaphores are
supported.

The patch is the first step for optimizing simple, single semaphore
operations: In addition to the global list of all pending operations, a
2nd, per-semaphore list with the simple operations is added.

Note: this patch does not make sense by itself, the new list is used
nowhere.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |    5 ++++-
 ipc/sem.c           |   37 ++++++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 6 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-add-a-per-semaphore-pending-list include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-add-a-per-semaphore-pending-list
+++ a/include/linux/sem.h
@@ -86,6 +86,7 @@ struct task_struct;
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	struct list_head sem_pending; /* pending single-sop operations */
 };
 
 /* One sem_array data structure for each set of semaphores in the system. */
@@ -96,11 +97,13 @@ struct sem_array {
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
 	struct list_head	sem_pending;	/* pending operations to be processed */
 	struct list_head	list_id;	/* undo requests on this array */
-	unsigned long		sem_nsems;	/* no. of semaphores in array */
+	int			sem_nsems;	/* no. of semaphores in array */
+	int			complex_count;	/* pending complex operations */
 };
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
+	struct list_head	simple_list; /* queue of pending operations */
 	struct list_head	list;	 /* queue of pending operations */
 	struct task_struct	*sleeper; /* this process */
 	struct sem_undo		*undo;	 /* undo structure */
diff -puN ipc/sem.c~ipc-semc-add-a-per-semaphore-pending-list ipc/sem.c
--- a/ipc/sem.c~ipc-semc-add-a-per-semaphore-pending-list
+++ a/ipc/sem.c
@@ -240,6 +240,7 @@ static int newary(struct ipc_namespace *
 	key_t key = params->key;
 	int nsems = params->u.nsems;
 	int semflg = params->flg;
+	int i;
 
 	if (!nsems)
 		return -EINVAL;
@@ -272,6 +273,11 @@ static int newary(struct ipc_namespace *
 	ns->used_sems += nsems;
 
 	sma->sem_base = (struct sem *) &sma[1];
+
+	for (i = 0; i < nsems; i++)
+		INIT_LIST_HEAD(&sma->sem_base[i].sem_pending);
+
+	sma->complex_count = 0;
 	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
@@ -418,6 +424,15 @@ static void wake_up_sem_queue(struct sem
 	preempt_enable();
 }
 
+static void unlink_queue(struct sem_array *sma, struct sem_queue *q)
+{
+	list_del(&q->list);
+	if (q->nsops == 1)
+		list_del(&q->simple_list);
+	else
+		sma->complex_count--;
+}
+
 /* Go through the pending queue for the indicated semaphore
  * looking for tasks that can be completed.
  */
@@ -437,7 +452,7 @@ again:
 		if (error > 0)
 			continue;
 
-		list_del(&q->list);
+		unlink_queue(sma, q);
 
 		/*
 		 * The next operation that must be checked depends on the type
@@ -531,8 +546,7 @@ static void freeary(struct ipc_namespace
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
 	list_for_each_entry_safe(q, tq, &sma->sem_pending, list) {
-		list_del(&q->list);
-
+		unlink_queue(sma, q);
 		wake_up_sem_queue(q, -EIDRM);
 	}
 
@@ -1190,6 +1204,19 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	else
 		list_add(&queue.list, &sma->sem_pending);
 
+	if (nsops == 1) {
+		struct sem *curr;
+		curr = &sma->sem_base[sops->sem_num];
+
+		if (alter)
+			list_add_tail(&queue.simple_list, &curr->sem_pending);
+		else
+			list_add(&queue.simple_list, &curr->sem_pending);
+	} else {
+		INIT_LIST_HEAD(&queue.simple_list);
+		sma->complex_count++;
+	}
+
 	queue.status = -EINTR;
 	queue.sleeper = current;
 	current->state = TASK_INTERRUPTIBLE;
@@ -1231,7 +1258,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
-	list_del(&queue.list);
+	unlink_queue(sma, &queue);
 
 out_unlock_free:
 	sem_unlock(sma);
@@ -1374,7 +1401,7 @@ static int sysvipc_sem_proc_show(struct 
 	struct sem_array *sma = it;
 
 	return seq_printf(s,
-			  "%10d %10d  %4o %10lu %5u %5u %5u %5u %10lu %10lu\n",
+			  "%10d %10d  %4o %10u %5u %5u %5u %5u %10lu %10lu\n",
 			  sma->sem_perm.key,
 			  sma->sem_perm.id,
 			  sma->sem_perm.mode,
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

