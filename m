From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:23 -0800
Message-ID: <52e80063.87Lr63zHUCz7q2cJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45488 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, manfred@colorfullife.com, jkosina@suse.cz, davidlohr@hp.com, pmladek@suse.cz

Subject: [merged] ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch removed from -mm tree
To: pmladek@suse.cz,davidlohr@hp.com,jkosina@suse.cz,manfred@colorfullife.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:23 -0800


The patch titled
     Subject: ipc/sem.c: avoid overflow of semop undo (semadj) value
has been removed from the -mm tree.  Its filename was
     ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[akpm@linux-foundation.org: restore lessened scope of local `undo']
[davidlohr@hp.com: correct header comment for perform_atomic_semop]
Signed-off-by: Petr Mladek <pmladek@suse.cz>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Acked-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff -puN ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value ipc/sem.c
--- a/ipc/sem.c~ipc-semc-avoid-overflow-of-semop-undo-semadj-value
+++ a/ipc/sem.c
@@ -584,10 +584,11 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
 	return ipcget(ns, &sem_ids(ns), &sem_ops, &sem_params);
 }
 
-/** perform_atomic_semop - Perform (if possible) a semaphore operation
+/**
+ * perform_atomic_semop - Perform (if possible) a semaphore operation
  * @sma: semaphore array
  * @sops: array with operations that should be checked
- * @nsems: number of sops
+ * @nsops: number of operations
  * @un: undo array
  * @pid: pid that did the change
  *
@@ -595,7 +596,6 @@ SYSCALL_DEFINE3(semget, key_t, key, int,
  * Returns 1 if the operation is impossible, the caller must sleep.
  * Negative values are error codes.
  */
-
 static int perform_atomic_semop(struct sem_array *sma, struct sembuf *sops,
 			     int nsops, struct sem_undo *un, int pid)
 {
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
 			int undo = un->semadj[sop->sem_num] - sem_op;
-			/*
-	 		 *	Exceeding the undo range is an error.
-			 */
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

origin.patch

