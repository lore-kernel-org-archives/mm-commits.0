From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:23:53 -0700
Message-ID: <20130424222353.D53B231C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:46879 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758159Ab3DXWXz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:23:55 -0400
Received: by mail-yh0-f74.google.com with SMTP id z12so119548yhz.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:23:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidlohr.bueso@hp.com, benisty.e@gmail.com, paul.mckenney@linaro.org, riel@surriel.com, sedat.dilek@gmail.com, torvalds@linux-foundation.org


The patch titled
     Subject: ipc: make refcounter atomic
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: make refcounter atomic

Sedat reported an issue leading to a NULL dereference in update_queue():

[  178.490583] BUG: spinlock bad magic on CPU#1, sh/8066
[  178.490595]  lock: 0xffff88008b53ea18, .magic: 6b6b6b6b, .owner: make/8068, .owner_cpu: 3
[  178.490599] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  178.490608] IP: [<ffffffff812bacd0>] update_queue+0x70/0x210
[  178.490610] PGD 0
[  178.490612] Oops: 0000 [#1] SMP
...
[  178.490704] Call Trace:
[  178.490710]  [<ffffffff812baf51>] do_smart_update+0xe1/0x140
[  178.490713]  [<ffffffff812bd6e1>] exit_sem+0x2b1/0x350
[  178.490718]  [<ffffffff8105de80>] do_exit+0x290/0xa70
[  178.490721]  [<ffffffff8105e6f4>] do_group_exit+0x44/0xa0
[  178.490724]  [<ffffffff8105e767>] SyS_exit_group+0x17/0x20
[  178.490728]  [<ffffffff816ce15d>] system_call_fastpath+0x1a/0x1f

Linus pin-pointed the problem to a race in the reference counter. To quote:

"That dmesg spew very much implies that the same RCU head got added twice
to the RCU freeing list, and the only way that happens is if the refcount
goes to zero twice.  Which implies that either we increment a zero, or we
lack locking and the coherency of the non-atomic access goes away."

This patch converts the IPC RCU header's reference counter to atomic_t. 
The return of ipc_rcu_getref() is modified to inform the callers if it
actually succeeded.

Now all callers return -EIDRM upon failure and abort the current
operation.  Two exceptions are in semaphore code where
sem_getref_and_unlock() and sem_getref() trigger a warning but proceed to
freeing up any held locks.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Paul McKenney <paul.mckenney@linaro.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    7 ++++++-
 ipc/sem.c  |   18 ++++++++++++------
 ipc/util.c |   46 ++++++++++++++++++++++++----------------------
 ipc/util.h |    2 +-
 4 files changed, 43 insertions(+), 30 deletions(-)

diff -puN ipc/msg.c~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic ipc/msg.c
--- a/ipc/msg.c~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic
+++ a/ipc/msg.c
@@ -687,7 +687,12 @@ long do_msgsnd(int msqid, long mtype, vo
 			goto out_unlock_free;
 		}
 		ss_add(msq, &s);
-		ipc_rcu_getref(msq);
+
+		if (!ipc_rcu_getref(msq)) {
+			err = -EIDRM;
+			goto out_unlock_free;
+		}
+
 		msg_unlock(msq);
 		schedule();
 
diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic
+++ a/ipc/sem.c
@@ -313,7 +313,7 @@ static inline void sem_lock_and_putref(s
 
 static inline void sem_getref_and_unlock(struct sem_array *sma)
 {
-	ipc_rcu_getref(sma);
+	WARN_ON_ONCE(!ipc_rcu_getref(sma));
 	sem_unlock(sma, -1);
 }
 
@@ -329,7 +329,7 @@ static inline void sem_putref(struct sem
 static inline void sem_getref(struct sem_array *sma)
 {
 	sem_lock(sma, NULL, -1);
-	ipc_rcu_getref(sma);
+	WARN_ON_ONCE(!ipc_rcu_getref(sma));
 	sem_unlock(sma, -1);
 }
 
@@ -1131,7 +1131,10 @@ static int semctl_main(struct ipc_namesp
 		int i;
 		struct sem_undo *un;
 
-		ipc_rcu_getref(sma);
+		if (!ipc_rcu_getref(sma)) {
+			rcu_read_unlock();
+			return -EIDRM;
+		}
 		rcu_read_unlock();
 
 		if(nsems > SEMMSL_FAST) {
@@ -1400,8 +1403,7 @@ static struct sem_undo *find_alloc_undo(
 	struct sem_array *sma;
 	struct sem_undo_list *ulp;
 	struct sem_undo *un, *new;
-	int nsems;
-	int error;
+	int nsems, error;
 
 	error = get_undo_list(&ulp);
 	if (error)
@@ -1423,7 +1425,11 @@ static struct sem_undo *find_alloc_undo(
 	}
 
 	nsems = sma->sem_nsems;
-	ipc_rcu_getref(sma);
+	if (!ipc_rcu_getref(sma)) {
+		rcu_read_unlock();
+		un = ERR_PTR(-EIDRM);
+		goto out;
+	}
 	rcu_read_unlock();
 
 	/* step 2: allocate new undo structure */
diff -puN ipc/util.c~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic ipc/util.c
--- a/ipc/util.c~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic
+++ a/ipc/util.c
@@ -439,9 +439,9 @@ void ipc_rmid(struct ipc_ids *ids, struc
  *	NULL is returned if the allocation fails
  */
  
-void* ipc_alloc(int size)
+void *ipc_alloc(int size)
 {
-	void* out;
+	void *out;
 	if(size > PAGE_SIZE)
 		out = vmalloc(size);
 	else
@@ -478,7 +478,7 @@ void ipc_free(void* ptr, int size)
  */
 struct ipc_rcu_hdr
 {
-	int refcount;
+	atomic_t refcount;
 	int is_vmalloc;
 	void *data[0];
 };
@@ -516,39 +516,41 @@ static inline int rcu_use_vmalloc(int si
  *	@size: size desired
  *
  *	Allocate memory for the rcu header structure +  the object.
- *	Returns the pointer to the object.
- *	NULL is returned if the allocation fails. 
+ *	Returns the pointer to the object or NULL upon failure.
  */
- 
-void* ipc_rcu_alloc(int size)
+void *ipc_rcu_alloc(int size)
 {
 	void* out;
-	/* 
+
+	/*
 	 * We prepend the allocation with the rcu struct, and
-	 * workqueue if necessary (for vmalloc). 
+	 * workqueue if necessary (for vmalloc).
 	 */
 	if (rcu_use_vmalloc(size)) {
 		out = vmalloc(HDRLEN_VMALLOC + size);
-		if (out) {
-			out += HDRLEN_VMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
-		}
+		if (!out)
+			goto done;
+
+		out += HDRLEN_VMALLOC;
+		container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
 	} else {
 		out = kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
-		if (out) {
-			out += HDRLEN_KMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
-		}
+		if (!out)
+			goto done;
+
+		out += HDRLEN_KMALLOC;
+		container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
 	}
 
+	/* set reference counter no matter what kind of allocation was done */
+	atomic_set(&container_of(out, struct ipc_rcu_hdr, data)->refcount, 1);
+done:
 	return out;
 }
 
-void ipc_rcu_getref(void *ptr)
+int ipc_rcu_getref(void *ptr)
 {
-	container_of(ptr, struct ipc_rcu_hdr, data)->refcount++;
+	return atomic_inc_not_zero(&container_of(ptr, struct ipc_rcu_hdr, data)->refcount);
 }
 
 static void ipc_do_vfree(struct work_struct *work)
@@ -578,7 +580,7 @@ static void ipc_schedule_free(struct rcu
 
 void ipc_rcu_putref(void *ptr)
 {
-	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
+	if (!atomic_dec_and_test(&container_of(ptr, struct ipc_rcu_hdr, data)->refcount))
 		return;
 
 	if (container_of(ptr, struct ipc_rcu_hdr, data)->is_vmalloc) {
diff -puN ipc/util.h~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic ipc/util.h
--- a/ipc/util.h~ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic
+++ a/ipc/util.h
@@ -119,7 +119,7 @@ void ipc_free(void* ptr, int size);
  * to 0 schedules the rcu destruction. Caller must guarantee locking.
  */
 void* ipc_rcu_alloc(int size);
-void ipc_rcu_getref(void *ptr);
+int ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
lib-int_sqrtc-optimize-square-root-algorithm.patch
ipc-remove-bogus-lock-comment-for-ipc_checkid.patch
ipc-introduce-obtaining-a-lockless-ipc-object.patch
ipc-introduce-obtaining-a-lockless-ipc-object-fix.patch
ipc-introduce-lockless-pre_down-ipcctl.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary.patch
ipcsem-do-not-hold-ipc-lock-more-than-necessary-fix.patch
ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-fix.patch
ipcsem-fine-grained-locking-for-semtimedop-fix-locking-in-semctl_main.patch
ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo.patch
ipcsem-fine-grained-locking-for-semtimedop-do-not-call-sem_lock-when-bogus-sma.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic.patch
ipcsem-fine-grained-locking-for-semtimedop-ipc-make-refcounter-atomic-fix.patch
rbtree_test-add-extra-rbtree-integrity-check.patch
rbtree_test-add-__init-__exit-annotations.patch

