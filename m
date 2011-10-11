From: akpm@google.com
Subject: + ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid.patch added to -mm tree
Date: Tue, 11 Oct 2011 14:54:50 -0700
Message-ID: <201110112154.p9BLsp0B015184@hpaq6.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:47553 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1JKVzC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2011 17:55:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de


The patch titled
     Subject: ipc/sem.c: fix return code race with semop vs. semop +semctl(IPC_RMID)
has been added to the -mm tree.  Its filename is
     ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid.patch

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
Subject: ipc/sem.c: fix return code race with semop vs. semop +semctl(IPC_RMID)

sys_semtimedop() may return -EIDRM although the semaphore operation
completed successfully:

thread 1:	thread 2:
		semtimedop(), sleeps
semop():
* acquires sem_lock()
		semtimedop() woken up due to timeout
		sem_lock() loops
* notices that thread 2 could be completed.
* performs the operations that thread 2 is sleeping on.
* marks the semaphore operation as IN_WAKEUP
* drops sem_lock(), does wakeup, sets return code to 0
		* thread delayed due to interrupt, whatever
* returns to user space
		* thread still delayed
semctl(IPC_RMID)
* acquires sem_lock()
* ipc_rmid(), ipcp->deleted=1
* drops sem_lock()
		* thread finally continues - but seem_lock()
		  now fails due to ipcp->deleted == 1
		* returns -EIDRM instead of 0

The fix is trivial: Always use the return code in queue.status.

In real world, the race probably doesn't matter:
If the semaphore array is destroyed, the app is probably not interested
if the last operation succeeded or was already cancelled.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 ipc/sem.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN ipc/sem.c~ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid ipc/sem.c
--- a/ipc/sem.c~ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid
+++ a/ipc/sem.c
@@ -1460,7 +1460,6 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	 * Array removed? If yes, leave without sem_unlock().
 	 */
 	if (IS_ERR(sma)) {
-		error = -EIDRM;
 		goto out_free;
 	}
 
_
Subject: Subject: ipc/sem.c: fix return code race with semop vs. semop +semctl(IPC_RMID)

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid.patch
ipc-semc-handle-spurious-wakeups.patch
ipc-semc-replace-busy-loop-with-completion.patch
slab-leaks3-default-y.patch

