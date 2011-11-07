From: akpm@linux-foundation.org
Subject: [merged] ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:27:54 -0800
Message-ID: <201111072027.pA7KRsIs020697@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5478 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab1KGU2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem.c: fix return code race with semop vs. semop +semctl(IPC_RMID)
has been removed from the -mm tree.  Its filename was
     ipc-semc-fix-return-code-race-with-semop-vs-semop-semctlipc_rmid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

Patches currently in -mm which might be from manfred@colorfullife.com are

origin.patch
ipc-mqueue-cleanup-definition-names-and-locations.patch
ipc-mqueue-switch-back-to-using-non-max-values-on-create.patch
ipc-mqueue-enforce-hard-limits.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-semc-alternatives-to-preempt_disable.patch
slab-leaks3-default-y.patch

