From: akpm@linux-foundation.org
Subject: + ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo.patch added to -mm tree
Date: Tue, 23 Apr 2013 12:35:46 -0700
Message-ID: <20130423193546.787C45A426B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:44134 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab3DWTfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Apr 2013 15:35:47 -0400
Received: by mail-qc0-f201.google.com with SMTP id o22so107199qcr.2
        for <mm-commits@vger.kernel.org>; Tue, 23 Apr 2013 12:35:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@surriel.com, davidlohr.bueso@hp.com, riel@redhat.com, sasha.levin@oracle.com


The patch titled
     Subject: ipc,sem: untangle RCU locking with find_alloc_undo
has been added to the -mm tree.  Its filename is
     ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: ipc,sem: untangle RCU locking with find_alloc_undo

The ipc semaphore code has a nasty RCU locking tangle, with both
find_alloc_undo and semtimedop taking the rcu_read_lock(). The
code can be cleaned up somewhat by only taking the rcu_read_lock
once.

There are no other callers to find_alloc_undo.

This should also solve the trinity issue reported by Sasha Levin.

Signed-off-by: Rik van Riel <riel@redhat.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff -puN ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo ipc/sem.c
--- a/ipc/sem.c~ipcsem-fine-grained-locking-for-semtimedop-untangle-rcu-locking-with-find_alloc_undo
+++ a/ipc/sem.c
@@ -1548,22 +1548,23 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 			alter = 1;
 	}
 
+	INIT_LIST_HEAD(&tasks);
+
 	if (undos) {
+		/* On success, find_alloc_undo takes the rcu_read_lock */
 		un = find_alloc_undo(ns, semid);
 		if (IS_ERR(un)) {
 			error = PTR_ERR(un);
 			goto out_free;
 		}
-	} else
+	} else {
 		un = NULL;
+		rcu_read_lock();
+	}
 
-	INIT_LIST_HEAD(&tasks);
-
-	rcu_read_lock();
 	sma = sem_obtain_object_check(ns, semid);
 	if (IS_ERR(sma)) {
-		if (un)
-			rcu_read_unlock();
+		rcu_read_unlock();
 		error = PTR_ERR(sma);
 		goto out_free;
 	}
@@ -1595,22 +1596,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	 */
 	error = -EIDRM;
 	locknum = sem_lock(sma, sops, nsops);
-	if (un) {
-		if (un->semid == -1) {
-			rcu_read_unlock();
-			goto out_unlock_free;
-		} else {
-			/*
-			 * rcu lock can be released, "un" cannot disappear:
-			 * - sem_lock is acquired, thus IPC_RMID is
-			 *   impossible.
-			 * - exit_sem is impossible, it always operates on
-			 *   current (or a dead task).
-			 */
