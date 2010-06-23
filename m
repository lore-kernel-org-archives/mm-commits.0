From: akpm@linux-foundation.org
Subject: + ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch added to -mm tree
Date: Wed, 23 Jun 2010 12:24:36 -0700
Message-ID: <201006231924.o5NJOabf026800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33844 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753055Ab0FWTY7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jun 2010 15:24:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, cl@linux-foundation.org, kronos.it@gmail.com, maciej.rutecki@gmail.com


The patch titled
     ipc/sem.c: bugfix for semop() not reporting successful operation
has been added to the -mm tree.  Its filename is
     ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch

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
Subject: ipc/sem.c: bugfix for semop() not reporting successful operation
From: Manfred Spraul <manfred@colorfullife.com>

The last change to improve the scalability moved the actual wake-up out of
the section that is protected by spin_lock(sma->sem_perm.lock).

This means that IN_WAKEUP can be in queue.status even when the spinlock is
acquired by the current task.  Thus the same loop that is performed when
queue.status is read without the spinlock acquired must be performed when
the spinlock is acquired.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=16255

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Luca Tettamanti <kronos.it@gmail.com>
Tested-by: Luca Tettamanti <kronos.it@gmail.com>
Reported-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff -puN ipc/sem.c~ipc-semc-bugfix-for-semop-not-reporting-successful-operation ipc/sem.c
--- a/ipc/sem.c~ipc-semc-bugfix-for-semop-not-reporting-successful-operation
+++ a/ipc/sem.c
@@ -1256,6 +1256,32 @@ out:
 	return un;
 }
 
+
+/** get_queue_result - Retrieve the result code from sem_queue
+ * @q: Pointer to queue structure
+ *
+ * The function retrieve the return code from the pending queue. If
+ * IN_WAKEUP is found in q->status, then we must loop until the value
+ * is replaced with the final value: This may happen if a task is
+ * woken up by an unrelated event (e.g. signal) and in parallel the task
+ * is woken up by another task because it got the requested semaphores.
+ *
+ * The function can be called with or without holding the semaphore spinlock.
+ */
+static int get_queue_result(struct sem_queue *q)
+{
+	int error;
+
+	error = q->status;
+	while(unlikely(error == IN_WAKEUP)) {
+		cpu_relax();
+		error = q->status;
+	}
+
+	return error;
+}
+
+
 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,
 		unsigned, nsops, const struct timespec __user *, timeout)
 {
@@ -1409,11 +1435,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	else
 		schedule();
 
-	error = queue.status;
-	while(unlikely(error == IN_WAKEUP)) {
-		cpu_relax();
-		error = queue.status;
-	}
+	error = get_queue_result(&queue);
 
 	if (error != -EINTR) {
 		/* fast path: update_queue already obtained all requested
@@ -1427,10 +1449,12 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 		goto out_free;
 	}
 
+	error = get_queue_result(&queue);
+
 	/*
 	 * If queue.status != -EINTR we are woken up by another process
 	 */
-	error = queue.status;
+
 	if (error != -EINTR) {
 		goto out_unlock_free;
 	}
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation-fix.patch
slab-leaks3-default-y.patch

