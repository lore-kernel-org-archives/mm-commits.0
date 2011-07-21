From: akpm@linux-foundation.org
Subject: + ipc-semc-fix-race-with-concurrent-semtimedop-timeouts-and-ipc_rmid.patch added to -mm tree
Date: Wed, 20 Jul 2011 23:58:43 -0700
Message-ID: <201107210658.p6L6wgmb024257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34811 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257Ab1GUG7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 02:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, kernel@dasr.de, stable@kernel.org, yuriy@ucoz.com


The patch titled
     ipc/sem.c: fix race with concurrent semtimedop() timeouts and IPC_RMID
has been added to the -mm tree.  Its filename is
     ipc-semc-fix-race-with-concurrent-semtimedop-timeouts-and-ipc_rmid.patch

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
Subject: ipc/sem.c: fix race with concurrent semtimedop() timeouts and IPC_RMID
From: Manfred Spraul <manfred@colorfullife.com>

If a semaphore array is removed and in parallel a sleeping task is woken
up (signal or timeout, does not matter), then the woken up task does not
wait until wake_up_sem_queue_do() is completed.  This will cause crashes,
because wake_up_sem_queue_do() will read from a stale pointer.

The fix is simple: Regardless of anything, always call get_queue_result().
This function waits until wake_up_sem_queue_do() has finished it's task.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=27142

Reported-by: Yuriy Yevtukhov <yuriy@ucoz.com>
Reported-by: Harald Laabs <kernel@dasr.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN ipc/sem.c~ipc-semc-fix-race-with-concurrent-semtimedop-timeouts-and-ipc_rmid ipc/sem.c
--- a/ipc/sem.c~ipc-semc-fix-race-with-concurrent-semtimedop-timeouts-and-ipc_rmid
+++ a/ipc/sem.c
@@ -1456,15 +1456,24 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	}
 
 	sma = sem_lock(ns, semid);
+
+	/*
+	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
+	 */
+	error = get_queue_result(&queue);
+
+	/*
+	 * Array removed? If yes, leave without sem_unlock().
+	 */
 	if (IS_ERR(sma)) {
 		error = -EIDRM;
 		goto out_free;
 	}
 
-	error = get_queue_result(&queue);
 
 	/*
-	 * If queue.status != -EINTR we are woken up by another process
+	 * If queue.status != -EINTR we are woken up by another process.
+	 * Leave without unlink_queue(), but with sem_unlock().
 	 */
 
 	if (error != -EINTR) {
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-fix-race-with-concurrent-semtimedop-timeouts-and-ipc_rmid.patch
ipc-mqueue-refactor-failure-handling.patch
ipc-mqueue-fix-mq_open-return-value.patch
slab-leaks3-default-y.patch

