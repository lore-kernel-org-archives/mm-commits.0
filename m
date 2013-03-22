From: akpm@linux-foundation.org
Subject: + ipcsem-open-code-and-rename-sem_lock.patch added to -mm tree
Date: Fri, 22 Mar 2013 14:04:44 -0700
Message-ID: <20130322210444.E51BA5A43CE@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:47255 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423086Ab3CVVEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Mar 2013 17:04:46 -0400
Received: by mail-gh0-f201.google.com with SMTP id z19so422618ghb.0
        for <mm-commits@vger.kernel.org>; Fri, 22 Mar 2013 14:04:45 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@surriel.com, benisty.e@gmail.com, chegu_vinod@hp.com, davidlohr.bueso@hp.com, jason.low2@hp.com, peter@hurleysoftware.com, riel@redhat.com, skinsbursky@parallels.com, torvalds@linux-foundation.org, walken@google.com


The patch titled
     Subject: ipc,sem: open code and rename sem_lock
has been added to the -mm tree.  Its filename is
     ipcsem-open-code-and-rename-sem_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: ipc,sem: open code and rename sem_lock

Rename sem_lock() to sem_obtain_lock(), so we can introduce a sem_lock()
later that only locks the sem_array and does nothing else.

Open code the locking from ipc_lock() in sem_obtain_lock() so we can
introduce finer grained locking for the sem_array in the next patch.

Signed-off-by: Rik van Riel <riel@redhat.com>
Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Chegu Vinod <chegu_vinod@hp.com>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Jason Low <jason.low2@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN ipc/sem.c~ipcsem-open-code-and-rename-sem_lock ipc/sem.c
--- a/ipc/sem.c~ipcsem-open-code-and-rename-sem_lock
+++ a/ipc/sem.c
@@ -194,14 +194,29 @@ void __init sem_init (void)
  * sem_lock_(check_) routines are called in the paths where the rw_mutex
  * is not held.
  */
-static inline struct sem_array *sem_lock(struct ipc_namespace *ns, int id)
+static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns, int id)
 {
-	struct kern_ipc_perm *ipcp = ipc_lock(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp;
 
+	rcu_read_lock();
+	ipcp = ipc_obtain_object(&sem_ids(ns), id);
 	if (IS_ERR(ipcp))
-		return (struct sem_array *)ipcp;
+		goto err1;
+
+	spin_lock(&ipcp->lock);
+
+	/* ipc_rmid() may have already freed the ID while sem_lock
+	 * was spinning: verify that the structure is still valid
+	 */
+	if (ipcp->deleted)
+		goto err0;
 
 	return container_of(ipcp, struct sem_array, sem_perm);
+err0:
+	spin_unlock(&ipcp->lock);
+err1:
+	rcu_read_unlock();
+	return ERR_PTR(-EINVAL);
 }
 
 static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
@@ -1591,7 +1606,7 @@ sleep_again:
 		goto out_free;
 	}
 
-	sma = sem_lock(ns, semid);
+	sma = sem_obtain_lock(ns, semid);
 
 	/*
 	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
_

Patches currently in -mm which might be from riel@surriel.com are

ipcsem-open-code-and-rename-sem_lock.patch
ipcsem-open-code-and-rename-sem_lock-fix.patch
ipcsem-have-only-one-list-in-struct-sem_queue.patch
ipcsem-fine-grained-locking-for-semtimedop.patch

