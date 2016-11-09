From: akpm@linux-foundation.org
Subject: + ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop.patch added to -mm tree
Date: Wed, 09 Nov 2016 14:36:58 -0800
Message-ID: <5823a50a.+D07PcbtCPSg9t1i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752990AbcKIWg7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2016 17:36:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: avoid idr tree lookup for interrupted semop
has been added to the -mm tree.  Its filename is
     ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop.patch

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
Subject: ipc/sem: avoid idr tree lookup for interrupted semop

We can avoid the idr tree lookup (albeit possibly avoiding
idr_find_fast()) when being awoken in EINTR, as the semid will not change
in this context while blocked.  Use the sma pointer directly and take the
sem_lock, then re-check for RMID races.  We continue to re-check the
queue.status with the lock held such that we can detect situations where
we where are dealing with a spurious wakeup but another task that holds
the sem_lock updated the queue.status while we were spinning for it.  Once
we take the lock it obviously won't change again.

Being the only caller, get rid of sem_obtain_lock() altogether.

Link: http://lkml.kernel.org/r/1478708774-28826-3-git-send-email-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |   37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff -puN ipc/sem.c~ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop ipc/sem.c
--- a/ipc/sem.c~ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop
+++ a/ipc/sem.c
@@ -431,29 +431,6 @@ static inline void sem_unlock(struct sem
  *
  * The caller holds the RCU read lock.
  */
-static inline struct sem_array *sem_obtain_lock(struct ipc_namespace *ns,
-			int id, struct sembuf *sops, int nsops, int *locknum)
-{
-	struct kern_ipc_perm *ipcp;
-	struct sem_array *sma;
-
-	ipcp = ipc_obtain_object_idr(&sem_ids(ns), id);
-	if (IS_ERR(ipcp))
-		return ERR_CAST(ipcp);
-
-	sma = container_of(ipcp, struct sem_array, sem_perm);
-	*locknum = sem_lock(sma, sops, nsops);
-
-	/* ipc_rmid() may have already freed the ID while sem_lock
-	 * was spinning: verify that the structure is still valid
-	 */
-	if (ipc_valid_object(ipcp))
-		return container_of(ipcp, struct sem_array, sem_perm);
-
-	sem_unlock(sma, *locknum);
-	return ERR_PTR(-EINVAL);
-}
-
 static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_obtain_object_idr(&sem_ids(ns), id);
@@ -2016,16 +1993,12 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 		}
 
 		rcu_read_lock();
-		sma = sem_obtain_lock(ns, semid, sops, nsops, &locknum);
-		error = READ_ONCE(queue.status);
+		sem_lock(sma, sops, nsops);
 
-		/*
-		 * Array removed? If yes, leave without sem_unlock().
-		 */
-		if (IS_ERR(sma)) {
-			rcu_read_unlock();
-			goto out_free;
-		}
+		if (!ipc_valid_object(&sma->sem_perm))
+			goto out_unlock_free;
+
+		error = READ_ONCE(queue.status);
 
 		/*
 		 * If queue.status != -EINTR we are woken up by another process.
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-sem-do-not-call-wake_sem_queue_do-prematurely.patch
ipc-sem-rework-task-wakeups.patch
ipc-sem-optimize-perform_atomic_semop.patch
ipc-sem-explicitly-inline-check_restart.patch
ipc-sem-use-proper-list-api-for-pending_list-wakeups.patch
ipc-sem-simplify-wait-wake-loop.patch
ipc-sem-avoid-idr-tree-lookup-for-interrupted-semop.patch

