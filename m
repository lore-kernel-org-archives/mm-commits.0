From: akpm@linux-foundation.org
Subject: + ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch added
 to -mm tree
Date: Tue, 25 Oct 2016 15:55:08 -0700
Message-ID: <580fe2cc.SAiRq3KYsCBkWybH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40259 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752987AbcJYWzJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2016 18:55:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: do not call wake_sem_queue_do() prematurely
has been added to the -mm tree.  Its filename is
     ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch

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
Subject: ipc/sem: do not call wake_sem_queue_do() prematurely

... as this call should obviously be paired with its _prepare()
counterpart. At least whenever possible, as there is no harm in
calling it bogusly as we do now in a few places. Immediate error
semop(2) paths that are far from ever having the task block can
be simplified and avoid a few unnecessary loads on their way out
of the call as it is not deeply nested.

Link: http://lkml.kernel.org/r/1474225896-10066-2-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff -puN ipc/sem.c~ipc-sem-do-not-call-wake_sem_queue_do-prematurely ipc/sem.c
--- a/ipc/sem.c~ipc-sem-do-not-call-wake_sem_queue_do-prematurely
+++ a/ipc/sem.c
@@ -1904,16 +1904,22 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	}
 
 	error = -EFBIG;
-	if (max >= sma->sem_nsems)
-		goto out_rcu_wakeup;
+	if (max >= sma->sem_nsems) {
+		rcu_read_unlock();
+		goto out_free;
+	}
 
 	error = -EACCES;
-	if (ipcperms(ns, &sma->sem_perm, alter ? S_IWUGO : S_IRUGO))
-		goto out_rcu_wakeup;
+	if (ipcperms(ns, &sma->sem_perm, alter ? S_IWUGO : S_IRUGO)) {
+		rcu_read_unlock();
+		goto out_free;
+	}
 
 	error = security_sem_semop(sma, sops, nsops, alter);
-	if (error)
-		goto out_rcu_wakeup;
+	if (error) {
+		rcu_read_unlock();
+		goto out_free;
+	}
 
 	error = -EIDRM;
 	locknum = sem_lock(sma, sops, nsops);
@@ -2056,7 +2062,6 @@ sleep_again:
 
 out_unlock_free:
 	sem_unlock(sma, locknum);
-out_rcu_wakeup:
 	rcu_read_unlock();
 	wake_up_sem_queue_do(&tasks);
 out_free:
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch
ipc-sem-rework-task-wakeups.patch
ipc-sem-optimize-perform_atomic_semop.patch
ipc-sem-explicitly-inline-check_restart.patch
ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch

