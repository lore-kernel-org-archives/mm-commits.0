From: akpm@linux-foundation.org
Subject: + ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch added
 to -mm tree
Date: Tue, 03 Dec 2013 14:47:11 -0800
Message-ID: <529e5f6f.XsCt6o+e19FZ/ttz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3LCWrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 17:47:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, jkosina@suse.cz, davidlohr@hp.com, pmladek@suse.cz

Subject: + ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch added to -mm tree
To: pmladek@suse.cz,davidlohr@hp.com,jkosina@suse.cz,manfred@colorfullife.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 14:47:11 -0800


The patch titled
     Subject: ipc/sem.c: avoid overflow of semop undo (semadj) value
has been added to the -mm tree.  Its filename is
     ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Petr Mladek <pmladek@suse.cz>
Subject: ipc/sem.c: avoid overflow of semop undo (semadj) value

When trying to understand semop code, I found a small mistake in the check
for semadj (undo) value overflow.  The new undo value is not stored
immediately and next potential checks are done against the old value.

The failing scenario is not much practical.  One semop call has to do more
operations on the same semaphore.  Also semval and semadj must have
different values, so there has to be some operations without SEM_UNDO
flag.  For example:

	struct sembuf depositor_op[1];
	struct sembuf collector_op[2];

	depositor_op[0].sem_num = 0;
	depositor_op[0].sem_op = 20000;
	depositor_op[0].sem_flg = 0;

	collector_op[0].sem_num = 0;
	collector_op[0].sem_op = -10000;
	collector_op[0].sem_flg = SEM_UNDO;
	collector_op[1].sem_num = 0;
	collector_op[1].sem_op = -10000;
	collector_op[1].sem_flg = SEM_UNDO;

	if (semop(semid, depositor_op, 1) == -1)
		{ perror("Failed to do 1st deposit"); return 1; }

	if (semop(semid, collector_op, 2) == -1)
		{ perror("Failed to do 1st collect"); return 1; }

	if (semop(semid, depositor_op, 1) == -1)
		{ perror("Failed to do 2nd deposit"); return 1; }

	if (semop(semid, collector_op, 2) == -1)
		{ perror("Failed to do 2nd collect"); return 1; }

	return 0;

It passes without error now but the semadj value has overflown in the 2nd
collector operation.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value
+++ a/ipc/sem.c
@@ -599,7 +599,7 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
-	int result, sem_op;
+	int result, undo, sem_op;
 	struct sembuf *sop;
 	struct sem * curr;
 
@@ -607,7 +607,7 @@ static int perform_atomic_semop(struct s
 		curr = sma->sem_base + sop->sem_num;
 		sem_op = sop->sem_op;
 		result = curr->semval;
-  
+
 		if (!sem_op && result)
 			goto would_block;
 
@@ -616,25 +616,24 @@ static int perform_atomic_semop(struct s
 			goto would_block;
 		if (result > SEMVMX)
 			goto out_of_range;
+
 		if (sop->sem_flg & SEM_UNDO) {
-			int undo = un->semadj[sop->sem_num] - sem_op;
-			/*
-	 		 *	Exceeding the undo range is an error.
-			 */
+			undo = un->semadj[sop->sem_num] - sem_op;
+			/* Exceeding the undo range is an error. */
 			if (undo < (-SEMAEM - 1) || undo > SEMAEM)
 				goto out_of_range;
+			un->semadj[sop->sem_num] = undo;
 		}
+
 		curr->semval = result;
 	}
 
 	sop--;
 	while (sop >= sops) {
 		sma->sem_base[sop->sem_num].sempid = pid;
-		if (sop->sem_flg & SEM_UNDO)
-			un->semadj[sop->sem_num] -= sop->sem_op;
 		sop--;
 	}
-	
+
 	return 0;
 
 out_of_range:
@@ -650,7 +649,10 @@ would_block:
 undo:
 	sop--;
 	while (sop >= sops) {
-		sma->sem_base[sop->sem_num].semval -= sop->sem_op;
+		sem_op = sop->sem_op;
+		sma->sem_base[sop->sem_num].semval -= sem_op;
+		if (sop->sem_flg & SEM_UNDO)
+			un->semadj[sop->sem_num] += sem_op;
 		sop--;
 	}
 
_

Patches currently in -mm which might be from pmladek@suse.cz are

ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch

