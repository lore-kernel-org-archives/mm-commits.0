From: akpm@linux-foundation.org
Subject: + rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch added to -mm tree
Date: Thu, 03 Jun 2010 11:42:27 -0700
Message-ID: <201006031842.o53IgRmU009062@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755083Ab0FCSmz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 14:42:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, hpa@zytor.com, mikew@google.com, mingo@elte.hu, suleiman@google.com, tglx@linutronix.de, yinghan@google.com


The patch titled
     rwsem: smaller wrappers around rwsem_down_failed_common
has been added to the -mm tree.  Its filename is
     rwsem-smaller-wrappers-around-rwsem_down_failed_common.patch

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
Subject: rwsem: smaller wrappers around rwsem_down_failed_common
From: Michel Lespinasse <walken@google.com>

More code can be pushed from rwsem_down_read_failed and
rwsem_down_write_failed into rwsem_down_failed_common.

Following change adding down_read_critical infrastructure support also
enjoys having flags available in a register rather than having to fish it
out in the struct rwsem_waiter...

Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: Ying Han <yinghan@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/rwsem.c |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff -puN lib/rwsem.c~rwsem-smaller-wrappers-around-rwsem_down_failed_common lib/rwsem.c
--- a/lib/rwsem.c~rwsem-smaller-wrappers-around-rwsem_down_failed_common
+++ a/lib/rwsem.c
@@ -171,8 +171,9 @@ __rwsem_do_wake(struct rw_semaphore *sem
  */
 static struct rw_semaphore __sched *
 rwsem_down_failed_common(struct rw_semaphore *sem,
-			struct rwsem_waiter *waiter, signed long adjustment)
+			 unsigned int flags, signed long adjustment)
 {
+	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
 	signed long count;
 
@@ -180,12 +181,13 @@ rwsem_down_failed_common(struct rw_semap
 
 	/* set up my own style of waitqueue */
 	spin_lock_irq(&sem->wait_lock);
-	waiter->task = tsk;
+	waiter.task = tsk;
+	waiter.flags = flags;
 	get_task_struct(tsk);
 
 	if (list_empty(&sem->wait_list))
 		adjustment += RWSEM_WAITING_BIAS;
-	list_add_tail(&waiter->list, &sem->wait_list);
+	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we're now waiting on the lock, but no longer actively locking */
 	count = rwsem_atomic_update(adjustment, sem);
@@ -206,7 +208,7 @@ rwsem_down_failed_common(struct rw_semap
 
 	/* wait to be given the lock */
 	for (;;) {
-		if (!waiter->task)
+		if (!waiter.task)
 			break;
 		schedule();
 		set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -223,11 +225,8 @@ rwsem_down_failed_common(struct rw_semap
 asmregparm struct rw_semaphore __sched *
 rwsem_down_read_failed(struct rw_semaphore *sem)
 {
-	struct rwsem_waiter waiter;
-
-	waiter.flags = RWSEM_WAITING_FOR_READ;
-	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_READ_BIAS);
-	return sem;
+	return rwsem_down_failed_common(sem, RWSEM_WAITING_FOR_READ,
+					-RWSEM_ACTIVE_READ_BIAS);
 }
 
 /*
@@ -236,12 +235,8 @@ rwsem_down_read_failed(struct rw_semapho
 asmregparm struct rw_semaphore __sched *
 rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	struct rwsem_waiter waiter;
-
-	waiter.flags = RWSEM_WAITING_FOR_WRITE;
-	rwsem_down_failed_common(sem, &waiter, -RWSEM_ACTIVE_WRITE_BIAS);
