From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-handle-spurious-wakeups.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:58 -0800
Message-ID: <201111072027.pA7KRwBs023470@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab1KGU2M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: handle spurious wakeups
has been removed from the -mm tree.  Its filename was
     ipc-semc-handle-spurious-wakeups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem.c: handle spurious wakeups

semtimedop() does not handle spurious wakeups, it returns -EINTR to user
space.  Most other schedule() users would just loop and not return to user
space.  The patch adds such a loop to semtimedop()

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-semc-alternatives-to-preempt_disable.patch
slab-leaks3-default-y.patch

