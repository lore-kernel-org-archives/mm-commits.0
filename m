From: akpm@linux-foundation.org
Subject: + ipc-semc-move-wake_up_process-out-of-the-spinlock-section-bugfix-for-incorrect-setting-of-sem_otime.patch added to -mm tree
Date: Fri, 14 May 2010 10:59:36 -0700
Message-ID: <201005141759.o4EHxaJk013564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758608Ab0ENR7p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 May 2010 13:59:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: manfred@colorfullife.com, chris.mason@oracle.com, jens.axboe@oracle.com, npiggin@suse.de, zach.brown@oracle.com


The patch titled
     ipc/sem.c: bugfix for incorrect setting of sem_otime
has been added to the -mm tree.  Its filename is
     ipc-semc-move-wake_up_process-out-of-the-spinlock-section-bugfix-for-incorrect-setting-of-sem_otime.patch

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
Subject: ipc/sem.c: bugfix for incorrect setting of sem_otime
From: Manfred Spraul <manfred@colorfullife.com>

The attached patch corrects a bug that I've introduced with the previous
patch series: sem_otime is the time of the last successful semop() call.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Zach Brown <zach.brown@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN ipc/sem.c~ipc-semc-move-wake_up_process-out-of-the-spinlock-section-bugfix-for-incorrect-setting-of-sem_otime ipc/sem.c
--- a/ipc/sem.c~ipc-semc-move-wake_up_process-out-of-the-spinlock-section-bugfix-for-incorrect-setting-of-sem_otime
+++ a/ipc/sem.c
@@ -534,7 +534,7 @@ static int check_restart(struct sem_arra
  * must be set to -1.
  * The tasks that must be woken up are added to @pt. The return code
  * is stored in q->pid.
- * The function return 1 if at least one array variable was modified.
+ * The function return 1 if at least one semop was completed successfully.
  */
 static int update_queue(struct sem_array *sma, int semnum, struct list_head *pt)
 {
@@ -542,7 +542,7 @@ static int update_queue(struct sem_array
 	struct list_head *walk;
 	struct list_head *pending_list;
 	int offset;
-	int retval = 0;
+	int semop_completed = 0;
 
 	/* if there are complex operations around, then knowing the semaphore
 	 * that was modified doesn't help us. Assume that multiple semaphores
@@ -586,19 +586,19 @@ again:
 			continue;
 
 		unlink_queue(sma, q);
-		if (q->alter)
-			retval = 1;
 
-		if (error)
+		if (error) {
 			restart = 0;
-		else
+		} else {
+			semop_completed = 1;
 			restart = check_restart(sma, q);
+		}
 
 		wake_up_sem_queue_prepare(pt, q, error);
 		if (restart)
 			goto again;
 	}
-	return retval;
+	return semop_completed;
 }
 
 /**
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-optimize-update_queue-for-bulk-wakeup-calls.patch
ipc-semc-optimize-update_queue-for-bulk-wakeup-calls-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-fix-2.patch
ipc-semc-move-wake_up_process-out-of-the-spinlock-section-bugfix-for-incorrect-setting-of-sem_otime.patch
ipc-semc-cacheline-align-the-ipc-spinlock-for-semaphores.patch
slab-leaks3-default-y.patch

