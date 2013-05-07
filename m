From: akpm@linux-foundation.org
Subject: [merged] ipcsem-open-code-and-rename-sem_lock.patch removed from -mm tree
Date: Tue, 07 May 2013 10:52:21 -0700
Message-ID: <20130507175221.974F45A4525@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:45889 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759576Ab3EGRwX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 13:52:23 -0400
Received: by mail-gg0-f201.google.com with SMTP id k25so86568ggl.2
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 10:52:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@surriel.com, benisty.e@gmail.com, chegu_vinod@hp.com, davidlohr.bueso@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, sedat.dilek@gmail.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sem: open code and rename sem_lock
has been removed from the -mm tree.  Its filename was
     ipcsem-open-code-and-rename-sem_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: ipc,sem: open code and rename sem_lock

Rename sem_lock() to sem_obtain_lock(), so we can introduce a sem_lock()
later that only locks the sem_array and does nothing else.

Open code the locking from ipc_lock() in sem_obtain_lock() so we can
introduce finer grained locking for the sem_array in the next patch.

[akpm@linux-foundation.org: propagate the ipc_obtain_object() errno out of sem_obtain_lock()]
Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff -puN ipc/sem.c~ipcsem-open-code-and-rename-sem_lock ipc/sem.c
--- a/ipc/sem.c~ipcsem-open-code-and-rename-sem_lock
+++ a/ipc/sem.c
@@ -194,14 +194,31 @@ void __init sem_init (void)
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
+static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp;
+	struct sem_array *sma;
 
-	if (IS_ERR(ipcp))
-		return (struct sem_array *)ipcp;
+	rcu_read_lock();
+	ipcp = ipc_obtain_object(&sem_ids(ns), id);
+	if (IS_ERR(ipcp)) {
+		sma = ERR_CAST(ipcp);
+		goto err;
+	}
 
-	return container_of(ipcp, struct sem_array, sem_perm);
+	spin_lock(&ipcp->lock);
+
+	/* ipc_rmid() may have already freed the ID while sem_lock
+	 * was spinning: verify that the structure is still valid
+	 */
+	if (!ipcp->deleted)
+		return container_of(ipcp, struct sem_array, sem_perm);
+
+	spin_unlock(&ipcp->lock);
+	sma = ERR_PTR(-EINVAL);
+err:
+	rcu_read_unlock();
+	return sma;
 }
 
 static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
@@ -1593,7 +1610,7 @@ sleep_again:
 		goto out_free;
 	}
 
-	sma = sem_lock(ns, semid);
+	sma = sem_obtain_lock(ns, semid);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
_

Patches currently in -mm which might be from riel@surriel.com are

origin.patch

