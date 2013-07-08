From: akpm@linux-foundation.org
Subject: [folded-merged]
 ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 15:31:20 -0700
Message-ID: <51db3db8.H2Vd1hLDg2PRB9DE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3GHWbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 18:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sedat.dilek@gmail.com, riel@redhat.com, manfred@colorfullife.com, davidlohr.bueso@hp.com

Subject: [folded-merged] ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2.patch removed from -mm tree
To: davidlohr.bueso@hp.com,manfred@colorfullife.com,riel@redhat.com,sedat.dilek@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 15:31:20 -0700


The patch titled
     Subject: ipc,msq: fix race in msgrcv(2)
has been removed from the -mm tree.  Its filename was
     ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2.patch

This patch was dropped because it was folded into ipcmsg-shorten-critical-region-in-msgrcv.patch

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc,msq: fix race in msgrcv(2)

Sedat reported the following issue when building the latest linux-next:

Building via 'make deb-pkg' with fakeroot fails here like this:

make: *** [deb-pkg] Terminated
/usr/bin/fakeroot: line 181:  2386 Terminated
FAKEROOTKEY=$FAKEROOTKEY LD_LIBRARY_PATH="$PATHS" LD_PRELOAD="$LIB"
"$@"
semop(1): encountered an error: Identifier removed
semop(2): encountered an error: Invalid argument
semop(1): encountered an error: Identifier removed
semop(1): encountered an error: Identifier removed
semop(1): encountered an error: Invalid argument
semop(1): encountered an error: Invalid argument
semop(1): encountered an error: Invalid argument

The issue was caused by a race in find_msg(), so acquire the q_perm.lock
before calling the function. This also broke some LTP test cases:

<<<test_start>>>
tag=msgctl08 stime=1372174954
cmdline="msgctl08"
contacts=""
analysis=exit
<<<test_output>>>
msgctl08    0  TWARN  :  Verify error in child 0, *buf = 28, val = 27, size = 8
msgctl08    1  TFAIL  :  in child 0 read # = 73,key =  127
msgctl08    0  TWARN  :  Verify error in child 3, *buf = ffffff8a, val
= ffffff89, size = 52
msgctl08    1  TFAIL  :  in child 3 read # = 157,key =  189
msgctl08    0  TWARN  :  Verify error in child 2, *buf = ffffff87, val
= ffffff86, size = 71
msgctl08    1  TFAIL  :  in child 2 read # = 15954,key =  3e86
msgctl08    0  TWARN  :  Verify error in child 12, *buf = ffffffa9,
val = ffffffa8, size = 22
msgctl08    1  TFAIL  :  in child 12 read # = 12904,key =  32a8
msgctl08    0  TWARN  :  Verify error in child 13, *buf = 36, val =
35, size = 27
...

Also update a comment referring to ipc_lock_by_ptr(), which has already
been deleted and no longer applies to this context.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN ipc/msg.c~ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2 ipc/msg.c
--- a/ipc/msg.c~ipcmsg-shorten-critical-region-in-msgrcv-fix-race-in-msgrcv2
+++ a/ipc/msg.c
@@ -920,6 +920,7 @@ long do_msgrcv(int msqid, void __user *b
 		if (ipcperms(ns, &msq->q_perm, S_IRUGO))
 			goto out_unlock1;
 
+		ipc_lock_object(&msq->q_perm);
 		msg = find_msg(msq, &msgtyp, mode);
 		if (!IS_ERR(msg)) {
 			/*
@@ -928,7 +929,7 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if ((bufsz < msg->m_ts) && !(msgflg & MSG_NOERROR)) {
 				msg = ERR_PTR(-E2BIG);
-				goto out_unlock1;
+				goto out_unlock0;
 			}
 			/*
 			 * If we are copying, then do not unlink message and do
@@ -936,10 +937,9 @@ long do_msgrcv(int msqid, void __user *b
 			 */
 			if (msgflg & MSG_COPY) {
 				msg = copy_msg(msg, copy);
-				goto out_unlock1;
+				goto out_unlock0;
 			}
 
-			ipc_lock_object(&msq->q_perm);
 			list_del(&msg->m_list);
 			msq->q_qnum--;
 			msq->q_rtime = get_seconds();
@@ -955,10 +955,9 @@ long do_msgrcv(int msqid, void __user *b
 		/* No message waiting. Wait for a message */
 		if (msgflg & IPC_NOWAIT) {
 			msg = ERR_PTR(-ENOMSG);
-			goto out_unlock1;
+			goto out_unlock0;
 		}
 
-		ipc_lock_object(&msq->q_perm);
 		list_add_tail(&msr_d.r_list, &msq->q_receivers);
 		msr_d.r_tsk = current;
 		msr_d.r_msgtype = msgtyp;
@@ -982,7 +981,7 @@ long do_msgrcv(int msqid, void __user *b
 		 * Prior to destruction, expunge_all(-EIRDM) changes r_msg.
 		 * Thus if r_msg is -EAGAIN, then the queue not yet destroyed.
 		 * rcu_read_lock() prevents preemption between reading r_msg
-		 * and the spin_lock() inside ipc_lock_by_ptr().
+		 * and acquiring the q_perm.lock in ipc_lock_object().
 		 */
 		rcu_read_lock();
 
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch
ipc-move-rcu-lock-out-of-ipc_addid.patch
ipc-introduce-ipc-object-locking-helpers.patch
ipc-close-open-coded-spin-lock-calls.patch
ipc-move-locking-out-of-ipcctl_pre_down_nolock.patch
ipcmsg-shorten-critical-region-in-msgctl_down.patch
ipcmsg-introduce-msgctl_nolock.patch
ipcmsg-introduce-lockless-functions-to-obtain-the-ipc-object.patch
ipcmsg-make-msgctl_nolock-lockless.patch
ipcmsg-shorten-critical-region-in-msgsnd.patch
ipcmsg-shorten-critical-region-in-msgrcv.patch
ipc-remove-unused-functions.patch
ipc-utilc-ipc_rcu_alloc-cacheline-align-allocation.patch
ipc-semc-cacheline-align-the-semaphore-structures.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues.patch
ipc-sem-separate-wait-for-zero-and-alter-tasks-into-seperate-queues-fix.patch
ipc-semc-always-use-only-one-queue-for-alter-operations.patch
ipc-semc-replace-shared-sem_otime-with-per-semaphore-value.patch
ipc-semc-rename-try_atomic_semop-to-perform_atomic_semop-docu-update.patch

