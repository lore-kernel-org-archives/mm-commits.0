From: akpm@linux-foundation.org
Subject: [merged] ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:46:54 -0800
Message-ID: <5852e51e.cIRbBAQf1BZgMi7Z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756196AbcLOSqz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: do not call wake_sem_queue_do() prematurely
has been removed from the -mm tree.  Its filename was
     ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from dave@stgolabs.net are


