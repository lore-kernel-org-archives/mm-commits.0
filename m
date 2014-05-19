From: akpm@linux-foundation.org
Subject: + ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch
 added to -mm tree
Date: Mon, 19 May 2014 15:46:51 -0700
Message-ID: <537a89db.UEtyTUu+mW64pg4k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaESWqx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 May 2014 18:46:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mtk.manpages@gmail.com, davidlohr.bueso@hp.com, manfred@colorfullife.com

Subject: + ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch added to -mm tree
To: manfred@colorfullife.com,davidlohr.bueso@hp.com,mtk.manpages@gmail.com
From: akpm@linux-foundation.org
Date: Mon, 19 May 2014 15:46:51 -0700


The patch titled
     Subject: ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard compliant
has been added to the -mm tree.  Its filename is
     ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-make-semctlgetncntgetzcnt-standard-compliant.patch

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
Subject: ipc/sem.c: make semctl(,,{GETNCNT,GETZCNT}) standard compliant

SUSv4 clearly defines how semncnt and semzcnt must be calculated: A task
waits on exactly one semaphore: The semaphore from the first operation in
the sop array that cannot proceed.

The Linux implementation never followed the standard, it tried to count
all semaphores that might be the reason why a task sleeps.

This patch fixes that.

Note:
a) The implementation assumes that GETNCNT and GETZCNT are rare operations,
   therefore the code counts them only on demand.
   (If they wouldn't be rare, then the non-compliance would have
   been found earlier)

b) compared to the initial version of the patch, the BUG_ONs were removed
   and it was clarified that the new behavior conforms to SUS.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff -puN ipc/sem.c~ipc-semc-make-semctlgetncntgetzcnt-standard-compliant ipc/sem.c
--- a/ipc/sem.c~ipc-semc-make-semctlgetncntgetzcnt-standard-compliant
+++ a/ipc/sem.c
@@ -993,38 +993,30 @@ static void do_smart_update(struct sem_a
 }
 
 /*
- * check_qop: Test how often a queued operation sleeps on the semaphore semnum
+ * check_qop: Test if a queued operation sleeps on the semaphore semnum
  */
 static int check_qop(struct sem_array *sma, int semnum, struct sem_queue *q,
 			bool count_zero)
 {
-	struct sembuf *sops = q->sops;
-	int nsops = q->nsops;
-	int i, semcnt;
+	struct sembuf *sop = q->blocking;
 
-	semcnt = 0;
+	if (sop->sem_num != semnum)
+		return 0;
 
-	for (i = 0; i < nsops; i++) {
-		if (sops[i].sem_num != semnum)
-			continue;
-		if (sops[i].sem_flg & IPC_NOWAIT)
-			continue;
-		if (count_zero && sops[i].sem_op == 0)
-			semcnt++;
-		if (!count_zero && sops[i].sem_op < 0)
-			semcnt++;
-	}
-	return semcnt;
+	if (count_zero && sop->sem_op == 0)
+		return 1;
+	if (!count_zero && sop->sem_op < 0)
+		return 1;
+
+	return 0;
 }
 
 /* The following counts are associated to each semaphore:
  *   semncnt        number of tasks waiting on semval being nonzero
  *   semzcnt        number of tasks waiting on semval being zero
- * This model assumes that a task waits on exactly one semaphore.
- * Since semaphore operations are to be performed atomically, tasks actually
- * wait on a whole sequence of semaphores simultaneously.
- * The counts we return here are a rough approximation, but still
- * warrant that semncnt+semzcnt>0 if the task is on the pending queue.
+ *
+ * Per definition, a task waits only on the semaphore of the first semop
+ * that cannot proceed, even if additional operation would block, too.
  */
 static int count_semcnt(struct sem_array *sma, ushort semnum,
 			bool count_zero)
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

