From: akpm@linux-foundation.org
Subject: + ipc-close-open-coded-spin-lock-calls.patch added to -mm tree
Date: Fri, 24 May 2013 13:17:36 -0700
Message-ID: <519fcae0.JMCZWPTy5dUujw2L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913Ab3EXURi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipc-close-open-coded-spin-lock-calls.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:36 -0700


The patch titled
     Subject: ipc: close open coded spin lock calls
has been added to the -mm tree.  Its filename is
     ipc-close-open-coded-spin-lock-calls.patch

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
Subject: ipc: close open coded spin lock calls

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    2 +-
 ipc/sem.c  |   14 +++++++-------
 ipc/shm.c  |    4 ++--
 ipc/util.h |    4 ++--
 4 files changed, 12 insertions(+), 12 deletions(-)

diff -puN ipc/msg.c~ipc-close-open-coded-spin-lock-calls ipc/msg.c
--- a/ipc/msg.c~ipc-close-open-coded-spin-lock-calls
+++ a/ipc/msg.c
@@ -218,7 +218,7 @@ static int newque(struct ipc_namespace *
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
 
-	spin_unlock(&msq->q_perm.lock);
+	ipc_unlock_object(&msq->q_perm);
 	rcu_read_unlock();
 
 	return msq->q_perm.id;
diff -puN ipc/sem.c~ipc-close-open-coded-spin-lock-calls ipc/sem.c
--- a/ipc/sem.c~ipc-close-open-coded-spin-lock-calls
+++ a/ipc/sem.c
@@ -246,7 +246,7 @@ static inline int sem_lock(struct sem_ar
 		 * their critical section while the array lock is held.
 		 */
  lock_array:
-		spin_lock(&sma->sem_perm.lock);
+		ipc_lock_object(&sma->sem_perm);
 		for (i = 0; i < sma->sem_nsems; i++) {
 			struct sem *sem = sma->sem_base + i;
 			spin_unlock_wait(&sem->lock);
@@ -259,7 +259,7 @@ static inline int sem_lock(struct sem_ar
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
-		spin_unlock(&sma->sem_perm.lock);
+		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
 		spin_unlock(&sem->lock);
@@ -857,7 +857,7 @@ static void freeary(struct ipc_namespace
 	int i;
 
 	/* Free the existing undo structures for this semaphore set.  */
-	assert_spin_locked(&sma->sem_perm.lock);
+	ipc_assert_locked_object(&sma->sem_perm);
 	list_for_each_entry_safe(un, tu, &sma->list_id, list_id) {
 		list_del(&un->list_id);
 		spin_lock(&un->ulp->lock);
@@ -1055,7 +1055,7 @@ static int semctl_setval(struct ipc_name
 
 	curr = &sma->sem_base[semnum];
 
-	assert_spin_locked(&sma->sem_perm.lock);
+	ipc_assert_locked_object(&sma->sem_perm);
 	list_for_each_entry(un, &sma->list_id, list_id)
 		un->semadj[semnum] = 0;
 
@@ -1184,7 +1184,7 @@ static int semctl_main(struct ipc_namesp
 		for (i = 0; i < nsems; i++)
 			sma->sem_base[i].semval = sem_io[i];
 
-		assert_spin_locked(&sma->sem_perm.lock);
+		ipc_assert_locked_object(&sma->sem_perm);
 		list_for_each_entry(un, &sma->list_id, list_id) {
 			for (i = 0; i < nsems; i++)
 				un->semadj[i] = 0;
@@ -1481,7 +1481,7 @@ static struct sem_undo *find_alloc_undo(
 	new->semid = semid;
 	assert_spin_locked(&ulp->lock);
 	list_add_rcu(&new->list_proc, &ulp->list_proc);
-	assert_spin_locked(&sma->sem_perm.lock);
+	ipc_assert_locked_object(&sma->sem_perm);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
 
@@ -1818,7 +1818,7 @@ void exit_sem(struct task_struct *tsk)
 		}
 
 		/* remove un from the linked lists */
-		assert_spin_locked(&sma->sem_perm.lock);
+		ipc_assert_locked_object(&sma->sem_perm);
 		list_del(&un->list_id);
 
 		spin_lock(&ulp->lock);
diff -puN ipc/shm.c~ipc-close-open-coded-spin-lock-calls ipc/shm.c
--- a/ipc/shm.c~ipc-close-open-coded-spin-lock-calls
+++ a/ipc/shm.c
@@ -141,7 +141,7 @@ static inline struct shmid_kernel *shm_l
 static inline void shm_lock_by_ptr(struct shmid_kernel *ipcp)
 {
 	rcu_read_lock();
-	spin_lock(&ipcp->shm_perm.lock);
+	ipc_lock_object(&ipcp->shm_perm);
 }
 
 static inline struct shmid_kernel *shm_lock_check(struct ipc_namespace *ns,
@@ -547,7 +547,7 @@ static int newseg(struct ipc_namespace *
 	ns->shm_tot += numpages;
 	error = shp->shm_perm.id;
 
-	spin_unlock(&shp->shm_perm.lock);
+	ipc_unlock_object(&shp->shm_perm);
 	rcu_read_unlock();
 	return error;
 
diff -puN ipc/util.h~ipc-close-open-coded-spin-lock-calls ipc/util.h
--- a/ipc/util.h~ipc-close-open-coded-spin-lock-calls
+++ a/ipc/util.h
@@ -177,12 +177,12 @@ static inline void ipc_assert_locked_obj
 static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
 {
 	rcu_read_lock();
-	spin_lock(&perm->lock);
+	ipc_lock_object(perm);
 }
 
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
-	spin_unlock(&perm->lock);
+	ipc_unlock_object(perm);
 	rcu_read_unlock();
 }
 
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
softirq-use-_ret_ip_.patch
ipc-move-rcu-lock-out-of-ipc_addid.patch
ipc-introduce-ipc-object-locking-helpers.patch
ipc-close-open-coded-spin-lock-calls.patch
ipc-move-locking-out-of-ipcctl_pre_down_nolock.patch
ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-introduce-msgctl_nolock.patch
ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcmsg-make-msgctl_nolock-lockless.patch
ipcmsg-shorten-critical-region-in-msgsnd.patch
ipcmsg-shorten-critical-region-in-msgrcv.patch
ipc-remove-unused-functions.patch

