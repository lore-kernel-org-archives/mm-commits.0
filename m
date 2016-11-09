From: akpm@linux-foundation.org
Subject: + ipc-sem-simplify-wait-wake-loop.patch added to -mm tree
Date: Wed, 09 Nov 2016 14:36:56 -0800
Message-ID: <5823a508.xiHPV/CgQCd5t8BW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43666 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751506AbcKIWg5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2016 17:36:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: simplify wait-wake loop
has been added to the -mm tree.  Its filename is
     ipc-sem-simplify-wait-wake-loop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-simplify-wait-wake-loop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-simplify-wait-wake-loop.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc/sem: simplify wait-wake loop

Instead of using the reverse goto, we can simplify the flow and make it
more language natural by just doing do-while instead.  One would hope this
is the standard way (or obviously just with a while bucle) that we do
wait/wakeup handling in the kernel.  The exact same logic is kept, just
more indented.

Link: http://lkml.kernel.org/r/1478708774-28826-2-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |  117 ++++++++++++++++++++++++----------------------------
 1 file changed, 56 insertions(+), 61 deletions(-)

diff -puN ipc/sem.c~ipc-sem-simplify-wait-wake-loop ipc/sem.c
--- a/ipc/sem.c~ipc-sem-simplify-wait-wake-loop
+++ a/ipc/sem.c
@@ -1980,71 +1980,66 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		sma->complex_count++;
 	}
 
-sleep_again:
-	queue.status = -EINTR;
-	queue.sleeper = current;
-
-	__set_current_state(TASK_INTERRUPTIBLE);
-	sem_unlock(sma, locknum);
-	rcu_read_unlock();
-
-	if (timeout)
-		jiffies_left = schedule_timeout(jiffies_left);
-	else
-		schedule();
-
-	/*
-	 * fastpath: the semop has completed, either successfully or not, from
-	 * the syscall pov, is quite irrelevant to us at this point; we're done.
-	 *
-	 * We _do_ care, nonetheless, about being awoken by a signal or
-	 * spuriously.  The queue.status is checked again in the slowpath (aka
-	 * after taking sem_lock), such that we can detect scenarios where we
-	 * were awakened externally, during the window between wake_q_add() and
-	 * wake_up_q().
-	 */
-	error = READ_ONCE(queue.status);
-	if (error != -EINTR) {
+	do {
+		queue.status = -EINTR;
+		queue.sleeper = current;
+
+		__set_current_state(TASK_INTERRUPTIBLE);
+		sem_unlock(sma, locknum);
+		rcu_read_unlock();
+
+		if (timeout)
+			jiffies_left = schedule_timeout(jiffies_left);
+		else
+			schedule();
+
 		/*
-		 * User space could assume that semop() is a memory barrier:
-		 * Without the mb(), the cpu could speculatively read in user
-		 * space stale data that was overwritten by the previous owner
-		 * of the semaphore.
+		 * fastpath: the semop has completed, either successfully or not, from
+		 * the syscall pov, is quite irrelevant to us at this point; we're done.
+		 *
+		 * We _do_ care, nonetheless, about being awoken by a signal or
+		 * spuriously.  The queue.status is checked again in the slowpath (aka
+		 * after taking sem_lock), such that we can detect scenarios where we
+		 * were awakened externally, during the window between wake_q_add() and
+		 * wake_up_q().
 		 */
-		smp_mb();
-		goto out_free;
-	}
+		error = READ_ONCE(queue.status);
+		if (error != -EINTR) {
+			/*
+			 * User space could assume that semop() is a memory barrier:
+			 * Without the mb(), the cpu could speculatively read in user
+			 * space stale data that was overwritten by the previous owner
+			 * of the semaphore.
+			 */
+			smp_mb();
+			goto out_free;
+		}
+
+		rcu_read_lock();
+		sma = sem_obtain_lock(ns, semid, sops, nsops, &locknum);
+		error = READ_ONCE(queue.status);
 
-	rcu_read_lock();
-	sma = sem_obtain_lock(ns, semid, sops, nsops, &locknum);
-	error = READ_ONCE(queue.status);
-
-	/*
-	 * Array removed? If yes, leave without sem_unlock().
-	 */
-	if (IS_ERR(sma)) {
-		rcu_read_unlock();
-		goto out_free;
-	}
+		/*
+		 * Array removed? If yes, leave without sem_unlock().
+		 */
+		if (IS_ERR(sma)) {
+			rcu_read_unlock();
+			goto out_free;
+		}
 
-	/*
-	 * If queue.status != -EINTR we are woken up by another process.
-	 * Leave without unlink_queue(), but with sem_unlock().
-	 */
-	if (error != -EINTR)
-		goto out_unlock_free;
-
-	/*
-	 * If an interrupt occurred we have to clean up the queue.
-	 */
-	if (timeout && jiffies_left == 0)
-		error = -EAGAIN;
-
-	/*
-	 * If the wakeup was spurious, just retry.
-	 */
-	if (error == -EINTR && !signal_pending(current))
-		goto sleep_again;
+		/*
+		 * If queue.status != -EINTR we are woken up by another process.
+		 * Leave without unlink_queue(), but with sem_unlock().
+		 */
+		if (error != -EINTR)
+			goto out_unlock_free;
+
+		/*
+		 * If an interrupt occurred we have to clean up the queue.
+		 */
+		if (timeout && jiffies_left == 0)
+			error = -EAGAIN;
+	} while (error == -EINTR && !signal_pending(current)); /* spurious */
 
 	unlink_queue(sma, &queue);
 
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch
ipc-sem-rework-task-wakeups.patch
ipc-sem-optimize-perform_atomic_semop.patch
ipc-sem-explicitly-inline-check_restart.patch
ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch
ipc-sem-simplify-wait-wake-loop.patch
ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop.patch

