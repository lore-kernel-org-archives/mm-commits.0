From: akpm@linux-foundation.org
Subject: [patch 051/114] ipc/sem: do not call wake_sem_queue_do()
 prematurely
Date: Wed, 14 Dec 2016 15:06:31 -0800
Message-ID: <5851d077.RM3s5sgM6hi1zDLB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756928AbcLNXGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:06:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com

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
@@ -1887,16 +1887,22 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
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
@@ -2039,7 +2045,6 @@ sleep_again:
 
 out_unlock_free:
 	sem_unlock(sma, locknum);
-out_rcu_wakeup:
 	rcu_read_unlock();
 	wake_up_sem_queue_do(&tasks);
 out_free:
_
