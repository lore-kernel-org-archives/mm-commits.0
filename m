From: akpm@google.com
Subject: + ipc-semc-handle-spurious-wakeups.patch added to -mm tree
Date: Tue, 11 Oct 2011 14:54:58 -0700
Message-ID: <201110112154.p9BLsw5w027616@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:47586 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1JKVzG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 17:55:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de


The patch titled
     Subject: ipc/sem.c: handle spurious wakeups
has been added to the -mm tree.  Its filename is
     ipc-semc-handle-spurious-wakeups.patch

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
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: handle spurious wakeups

semtimedop() does not handle spurious wakeups, it returns -EINTR to user
space.  Most other schedule() users would just loop and not return to user
space.  The patch adds such a loop to semtimedop()

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 ipc/sem.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN ipc/sem.c~ipc-semc-handle-spurious-wakeups ipc/sem.c
--- a/ipc/sem.c~ipc-semc-handle-spurious-wakeups
+++ a/ipc/sem.c
@@ -1426,6 +1426,8 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 
 	queue.status = -EINTR;
 	queue.sleeper = current;
+
+sleep_again:
 	current->state = TASK_INTERRUPTIBLE;
 	sem_unlock(sma);
 
@@ -1478,6 +1480,13 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	 */
 	if (timeout && jiffies_left == 0)
 		error = -EAGAIN;
+
+	/*
+	 * If the wakeup was spurious, just retry
+	 */
+	if (error == -EINTR && !signal_pending(current))
+		goto sleep_again;
+
 	unlink_queue(sma, &queue);
 
 out_unlock_free:
_
Subject: Subject: ipc/sem.c: handle spurious wakeups

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid.patch
ipc-semc-handle-spurious-wakeups.patch
ipc-semc-replace-busy-loop-with-completion.patch
slab-leaks3-default-y.patch

