From: akpm@linux-foundation.org
Subject: + ipc-semc-remove-code-duplication.patch added to -mm tree
Date: Mon, 19 May 2014 15:46:48 -0700
Message-ID: <537a89d8.fSNDci1kygVaX/N+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaESWqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-remove-code-duplication.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:46:48 -0700


The patch titled
     Subject: ipc/sem.c: remove code duplication
has been added to the -mm tree.  Its filename is
     ipc-semc-remove-code-duplication.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-remove-code-duplication.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-remove-code-duplication.patch

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
Subject: ipc/sem.c: remove code duplication

count_semzcnt and count_semncnt are more of less identical.  The patch
creates a single function that either counts the number of tasks waiting
for zero or waiting due to a decrease operation.

Compared to the initial version, the BUG_ONs were removed.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  107 ++++++++++++++++++++++++----------------------------
 1 file changed, 51 insertions(+), 56 deletions(-)

diff -puN ipc/sem.c~ipc-semc-remove-code-duplication ipc/sem.c
--- a/ipc/sem.c~ipc-semc-remove-code-duplication
+++ a/ipc/sem.c
@@ -47,8 +47,7 @@
  *   Thus: Perfect SMP scaling between independent semaphore arrays.
  *         If multiple semaphores in one array are used, then cache line
  *         trashing on the semaphore array spinlock will limit the scaling.
- * - semncnt and semzcnt are calculated on demand in count_semncnt() and
- *   count_semzcnt()
+ * - semncnt and semzcnt are calculated on demand in count_semcnt()
  * - the task that performs a successful semop() scans the list of all
  *   sleeping tasks and completes any pending operations that can be fulfilled.
  *   Semaphores are actively given to waiting tasks (necessary for FIFO).
@@ -989,6 +988,31 @@ static void do_smart_update(struct sem_a
 		set_semotime(sma, sops);
 }
 
+/*
+ * check_qop: Test how often a queued operation sleeps on the semaphore semnum
+ */
+static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
+			bool count_zero)
+{
+	struct sembuf *sops = q->sops;
+	int nsops = q->nsops;
+	int i, semcnt;
+
+	semcnt = 0;
+
+	for (i = 0; i < nsops; i++) {
+		if (sops[i].sem_num != semnum)
+			continue;
+		if (sops[i].sem_flg & IPC_NOWAIT)
+			continue;
+		if (count_zero && sops[i].sem_op == 0)
+			semcnt++;
+		if (!count_zero && sops[i].sem_op < 0)
+			semcnt++;
+	}
+	return semcnt;
+}
+
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
@@ -998,66 +1022,37 @@ static void do_smart_update(struct sem_a
  * The counts we return here are a rough approximation, but still
  * warrant that semncnt+semzcnt>0 if the task is on the pending queue.
  */
-static int count_semncnt(struct sem_array *sma, ushort semnum)
+static int count_semcnt(struct sem_array *sma, ushort semnum,
+			bool count_zero)
 {
-	int semncnt;
+	struct list_head *l;
 	struct sem_queue *q;
+	int semcnt;
 
-	semncnt = 0;
-	list_for_each_entry(q, &sma->sem_base[semnum].pending_alter, list) {
-		struct sembuf *sops = q->sops;
-		BUG_ON(sops->sem_num != semnum);
-		if ((sops->sem_op < 0) && !(sops->sem_flg & IPC_NOWAIT))
-			semncnt++;
-	}
-
-	list_for_each_entry(q, &sma->pending_alter, list) {
-		struct sembuf *sops = q->sops;
-		int nsops = q->nsops;
-		int i;
-		for (i = 0; i < nsops; i++)
-			if (sops[i].sem_num == semnum
-			    && (sops[i].sem_op < 0)
-			    && !(sops[i].sem_flg & IPC_NOWAIT))
-				semncnt++;
-	}
-	return semncnt;
-}
-
-static int count_semzcnt(struct sem_array *sma, ushort semnum)
-{
-	int semzcnt;
-	struct sem_queue *q;
+	semcnt = 0;
+	/* First: check the simple operations. They are easy to evaluate */
+	if (count_zero)
+		l = &sma->sem_base[semnum].pending_const;
+	else
+		l = &sma->sem_base[semnum].pending_alter;
 
-	semzcnt = 0;
-	list_for_each_entry(q, &sma->sem_base[semnum].pending_const, list) {
-		struct sembuf *sops = q->sops;
-		BUG_ON(sops->sem_num != semnum);
-		if ((sops->sem_op == 0) && !(sops->sem_flg & IPC_NOWAIT))
-			semzcnt++;
+	list_for_each_entry(q, l, list) {
+		/* all task on a per-semaphore list sleep on exactly
+		 * that semaphore
+		 */
+		semcnt++;
 	}
 
-	list_for_each_entry(q, &sma->pending_const, list) {
-		struct sembuf *sops = q->sops;
-		int nsops = q->nsops;
-		int i;
-		for (i = 0; i < nsops; i++)
-			if (sops[i].sem_num == semnum
-			    && (sops[i].sem_op == 0)
-			    && !(sops[i].sem_flg & IPC_NOWAIT))
-				semzcnt++;
-	}
+	/* Then: check the complex operations. */
 	list_for_each_entry(q, &sma->pending_alter, list) {
-		struct sembuf *sops = q->sops;
-		int nsops = q->nsops;
-		int i;
-		for (i = 0; i < nsops; i++)
-			if (sops[i].sem_num == semnum
-			    && (sops[i].sem_op == 0)
-			    && !(sops[i].sem_flg & IPC_NOWAIT))
-				semzcnt++;
+		semcnt += check_qop(sma, semnum, q, count_zero);
+	}
+	if (count_zero) {
+		list_for_each_entry(q, &sma->pending_const, list) {
+			semcnt += check_qop(sma, semnum, q, count_zero);
+		}
 	}
-	return semzcnt;
+	return semcnt;
 }
 
 /* Free a semaphore set. freeary() is called with sem_ids.rwsem locked
@@ -1459,10 +1454,10 @@ static int semctl_main(struct ipc_namesp
 		err = curr->sempid;
 		goto out_unlock;
 	case GETNCNT:
-		err = count_semncnt(sma, semnum);
+		err = count_semcnt(sma, semnum, 0);
 		goto out_unlock;
 	case GETZCNT:
-		err = count_semzcnt(sma, semnum);
+		err = count_semcnt(sma, semnum, 1);
 		goto out_unlock;
 	}
 
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

