From: akpm@linux-foundation.org
Subject: - ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:56 -0700
Message-ID: <200807252300.m6PN0uV5003643@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755570AbYGYXHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, Nadia.Derbey@bull.net, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ipc/sem.c: convert sem_array.sem_pending to struct list_head
has been removed from the -mm tree.  Its filename was
     ipc-semc-convert-sem_arraysem_pending-to-struct-list_head.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc/sem.c: convert sem_array.sem_pending to struct list_head
From: Manfred Spraul <manfred@colorfullife.com>

sem_array.sem_pending is a double linked list, the attached patch converts
it to struct list_head.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reviewed-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sem.h |   12 ++---
 ipc/sem.c           |   92 +++++++++++++++---------------------------
 2 files changed, 40 insertions(+), 64 deletions(-)

diff -puN include/linux/sem.h~ipc-semc-convert-sem_arraysem_pending-to-struct-list_head include/linux/sem.h
--- a/include/linux/sem.h~ipc-semc-convert-sem_arraysem_pending-to-struct-list_head
+++ a/include/linux/sem.h
@@ -93,21 +93,19 @@ struct sem_array {
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
-	struct sem_queue	*sem_pending;	/* pending operations to be processed */
-	struct sem_queue	**sem_pending_last; /* last pending operation */
+	struct list_head	sem_pending;	/* pending operations to be processed */
 	struct list_head	list_id;	/* undo requests on this array */
 	unsigned long		sem_nsems;	/* no. of semaphores in array */
 };
 
 /* One queue for each sleeping process in the system. */
 struct sem_queue {
-	struct sem_queue *	next;	 /* next entry in the queue */
-	struct sem_queue **	prev;	 /* previous entry in the queue, *(q->prev) == q */
-	struct task_struct*	sleeper; /* this process */
-	struct sem_undo *	undo;	 /* undo structure */
+	struct list_head	list;	 /* queue of pending operations */
+	struct task_struct	*sleeper; /* this process */
+	struct sem_undo		*undo;	 /* undo structure */
 	int    			pid;	 /* process id of requesting process */
 	int    			status;	 /* completion status of operation */
-	struct sembuf *		sops;	 /* array of pending operations */
+	struct sembuf		*sops;	 /* array of pending operations */
 	int			nsops;	 /* number of operations */
 	int			alter;   /* does the operation alter the array? */
 };
diff -puN ipc/sem.c~ipc-semc-convert-sem_arraysem_pending-to-struct-list_head ipc/sem.c
--- a/ipc/sem.c~ipc-semc-convert-sem_arraysem_pending-to-struct-list_head
+++ a/ipc/sem.c
@@ -272,8 +272,7 @@ static int newary(struct ipc_namespace *
 	ns->used_sems += nsems;
 
 	sma->sem_base = (struct sem *) &sma[1];
-	/* sma->sem_pending = NULL; */
-	sma->sem_pending_last = &sma->sem_pending;
+	INIT_LIST_HEAD(&sma->sem_pending);
 	INIT_LIST_HEAD(&sma->list_id);
 	sma->sem_nsems = nsems;
 	sma->sem_ctime = get_seconds();
@@ -331,38 +330,6 @@ asmlinkage long sys_semget(key_t key, in
 	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
 }
 
-/* Manage the doubly linked list sma->sem_pending as a FIFO:
- * insert new queue elements at the tail sma->sem_pending_last.
- */
-static inline void append_to_queue (struct sem_array * sma,
-				    struct sem_queue * q)
-{
-	*(q->prev = sma->sem_pending_last) = q;
-	*(sma->sem_pending_last = &q->next) = NULL;
-}
-
-static inline void prepend_to_queue (struct sem_array * sma,
-				     struct sem_queue * q)
-{
-	q->next = sma->sem_pending;
-	*(q->prev = &sma->sem_pending) = q;
-	if (q->next)
-		q->next->prev = &q->next;
-	else /* sma->sem_pending_last == &sma->sem_pending */
-		sma->sem_pending_last = &q->next;
-}
-
-static inline void remove_from_queue (struct sem_array * sma,
-				      struct sem_queue * q)
-{
-	*(q->prev) = q->next;
-	if (q->next)
-		q->next->prev = q->prev;
-	else /* sma->sem_pending_last == &q->next */
-		sma->sem_pending_last = q->prev;
-	q->prev = NULL; /* mark as removed */
-}
-
 /*
  * Determine whether a sequence of semaphore operations would succeed
  * all at once. Return 0 if yes, 1 if need to sleep, else return error code.
@@ -438,16 +405,15 @@ static void update_queue (struct sem_arr
 	int error;
 	struct sem_queue * q;
 
-	q = sma->sem_pending;
-	while(q) {
+	q = list_entry(sma->sem_pending.next, struct sem_queue, list);
+	while (&q->list != &sma->sem_pending) {
 		error = try_atomic_semop(sma, q->sops, q->nsops,
 					 q->undo, q->pid);
 
 		/* Does q->sleeper still need to sleep? */
 		if (error <= 0) {
 			struct sem_queue *n;
-			remove_from_queue(sma,q);
-			q->status = IN_WAKEUP;
+
 			/*
 			 * Continue scanning. The next operation
 			 * that must be checked depends on the type of the
@@ -458,11 +424,26 @@ static void update_queue (struct sem_arr
 			 *   for semaphore values to become 0.
 			 * - if the operation didn't modify the array,
 			 *   then just continue.
+			 * The order of list_del() and reading ->next
+			 * is crucial: In the former case, the list_del()
+			 * must be done first [because we might be the
+			 * first entry in ->sem_pending], in the latter
+			 * case the list_del() must be done last
+			 * [because the list is invalid after the list_del()]
 			 */
-			if (q->alter)
-				n = sma->sem_pending;
-			else
-				n = q->next;
+			if (q->alter) {
+				list_del(&q->list);
+				n = list_entry(sma->sem_pending.next,
+						struct sem_queue, list);
+			} else {
+				n = list_entry(q->list.next, struct sem_queue,
+						list);
+				list_del(&q->list);
+			}
+
+			/* wake up the waiting thread */
+			q->status = IN_WAKEUP;
+
 			wake_up_process(q->sleeper);
 			/* hands-off: q will disappear immediately after
 			 * writing q->status.
@@ -471,7 +452,7 @@ static void update_queue (struct sem_arr
 			q->status = error;
 			q = n;
 		} else {
-			q = q->next;
+			q = list_entry(q->list.next, struct sem_queue, list);
 		}
 	}
 }
@@ -491,7 +472,7 @@ static int count_semncnt (struct sem_arr
 	struct sem_queue * q;
 
 	semncnt = 0;
-	for (q = sma->sem_pending; q; q = q->next) {
+	list_for_each_entry(q, &sma->sem_pending, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;
 		int i;
@@ -503,13 +484,14 @@ static int count_semncnt (struct sem_arr
 	}
 	return semncnt;
 }
+
 static int count_semzcnt (struct sem_array * sma, ushort semnum)
 {
 	int semzcnt;
 	struct sem_queue * q;
 
 	semzcnt = 0;
-	for (q = sma->sem_pending; q; q = q->next) {
+	list_for_each_entry(q, &sma->sem_pending, list) {
 		struct sembuf * sops = q->sops;
 		int nsops = q->nsops;
 		int i;
@@ -529,7 +511,7 @@ static int count_semzcnt (struct sem_arr
 static void freeary(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp)
 {
 	struct sem_undo *un;
-	struct sem_queue *q;
+	struct sem_queue *q, *t;
 	struct sem_array *sma = container_of(ipcp, struct sem_array, sem_perm);
 
 	/* Invalidate the existing undo structures for this semaphore set.
@@ -541,17 +523,14 @@ static void freeary(struct ipc_namespace
 		un->semid = -1;
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
-	q = sma->sem_pending;
-	while(q) {
-		struct sem_queue *n;
-		/* lazy remove_from_queue: we are killing the whole queue */
-		q->prev = NULL;
-		n = q->next;
+
+	list_for_each_entry_safe(q, t, &sma->sem_pending, list) {
+		list_del(&q->list);
+
 		q->status = IN_WAKEUP;
 		wake_up_process(q->sleeper); /* doesn't sleep */
 		smp_wmb();
 		q->status = -EIDRM;	/* hands-off q */
-		q = n;
 	}
 
 	/* Remove the semaphore set from the IDR */
@@ -1166,9 +1145,9 @@ asmlinkage long sys_semtimedop(int semid
 	queue.pid = task_tgid_vnr(current);
 	queue.alter = alter;
 	if (alter)
-		append_to_queue(sma ,&queue);
+		list_add_tail(&queue.list, &sma->sem_pending);
 	else
-		prepend_to_queue(sma ,&queue);
+		list_add(&queue.list, &sma->sem_pending);
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
@@ -1194,7 +1173,6 @@ asmlinkage long sys_semtimedop(int semid
 
 	sma = sem_lock(ns, semid);
 	if (IS_ERR(sma)) {
-		BUG_ON(queue.prev != NULL);
 		error = -EIDRM;
 		goto out_free;
 	}
@@ -1212,7 +1190,7 @@ asmlinkage long sys_semtimedop(int semid
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
-	remove_from_queue(sma,&queue);
+	list_del(&queue.list);
 	goto out_unlock_free;
 
 out_unlock_free:
_

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
mm-debug-dump-pageframes-on-bad_page.patch
slab-leaks3-default-y.patch

