From: akpm@linux-foundation.org
Subject: + ipc-move-rcu-lock-out-of-ipc_addid.patch added to -mm tree
Date: Fri, 24 May 2013 13:17:34 -0700
Message-ID: <519fcade.0FkcNcVSUZf2pVPA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58096 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756705Ab3EXURf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 May 2013 16:17:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: + ipc-move-rcu-lock-out-of-ipc_addid.patch added to -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 24 May 2013 13:17:34 -0700


The patch titled
     Subject: ipc: move rcu lock out of ipc_addid
has been added to the -mm tree.  Its filename is
     ipc-move-rcu-lock-out-of-ipc_addid.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: ipc: move rcu lock out of ipc_addid

This patchset continues the work that began in the sysv ipc semaphore
scaling series: https://lkml.org/lkml/2013/3/20/546

Just like semaphores used to be, sysv shared memory and msg queues also
abuse the ipc lock, unnecessarily holding it for operations such as
permission and security checks.  This patchset mostly deals with mqueues,
and while shared mem can be done in a very similar way, I want to get
these patches out in the open first.  It also does some pending cleanups,
mostly focused on the two level locking we have in ipc code, taking care
of ipc_addid() and ipcctl_pre_down_nolock() - yes there are still
functions that need to be updated as well.



This patch:

Make all callers explicitly take and release the RCU read lock.

This addresses the two level locking seen in newary(), newseg() and
newqueue().  For the last two, explicitly unlock the ipc object and the
rcu lock, instead of calling the custom shm_unlock and msg_unlock
functions.  The next patch will deal with the open coded locking for
->perm.lock

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    9 +++++----
 ipc/sem.c  |    2 ++
 ipc/shm.c  |    7 ++++++-
 ipc/util.c |    4 +---
 4 files changed, 14 insertions(+), 8 deletions(-)

diff -puN ipc/msg.c~ipc-move-rcu-lock-out-of-ipc_addid ipc/msg.c
--- a/ipc/msg.c~ipc-move-rcu-lock-out-of-ipc_addid
+++ a/ipc/msg.c
@@ -199,11 +199,11 @@ static int newque(struct ipc_namespace *
 		return retval;
 	}
 
-	/*
-	 * ipc_addid() locks msq
-	 */
+	/* ipc_addid() locks msq upon success. */
+	rcu_read_lock();
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id < 0) {
+		rcu_read_unlock();
 		security_msg_queue_free(msq);
 		ipc_rcu_putref(msq);
 		return id;
@@ -218,7 +218,8 @@ static int newque(struct ipc_namespace *
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
 
-	msg_unlock(msq);
+	spin_unlock(&msq->q_perm.lock);
+	rcu_read_unlock();
 
 	return msq->q_perm.id;
 }
diff -puN ipc/sem.c~ipc-move-rcu-lock-out-of-ipc_addid ipc/sem.c
--- a/ipc/sem.c~ipc-move-rcu-lock-out-of-ipc_addid
+++ a/ipc/sem.c
@@ -407,8 +407,10 @@ static int newary(struct ipc_namespace *
 		return retval;
 	}
 
+	rcu_read_lock();
 	id = ipc_addid(&sem_ids(ns), &sma->sem_perm, ns->sc_semmni);
 	if (id < 0) {
+		rcu_read_unlock();
 		security_sem_free(sma);
 		ipc_rcu_putref(sma);
 		return id;
diff -puN ipc/shm.c~ipc-move-rcu-lock-out-of-ipc_addid ipc/shm.c
--- a/ipc/shm.c~ipc-move-rcu-lock-out-of-ipc_addid
+++ a/ipc/shm.c
@@ -521,9 +521,11 @@ static int newseg(struct ipc_namespace *
 	if (IS_ERR(file))
 		goto no_file;
 
+	rcu_read_lock();
 	id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
 	if (id < 0) {
 		error = id;
+		rcu_read_unlock();
 		goto no_id;
 	}
 
@@ -535,6 +537,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
 	shp->shm_creator = current;
+
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
 	 * proc-ps tools use this. Changing this will break them.
@@ -543,7 +546,9 @@ static int newseg(struct ipc_namespace *
 
 	ns->shm_tot += numpages;
 	error = shp->shm_perm.id;
-	shm_unlock(shp);
+
+	spin_unlock(&shp->shm_perm.lock);
+	rcu_read_unlock();
 	return error;
 
 no_id:
diff -puN ipc/util.c~ipc-move-rcu-lock-out-of-ipc_addid ipc/util.c
--- a/ipc/util.c~ipc-move-rcu-lock-out-of-ipc_addid
+++ a/ipc/util.c
@@ -246,9 +246,8 @@ int ipc_get_maxid(struct ipc_ids *ids)
  *	is returned. The 'new' entry is returned in a locked state on success.
  *	On failure the entry is not locked and a negative err-code is returned.
  *
- *	Called with ipc_ids.rw_mutex held as a writer.
+ *	Called with RCU read lock and writer ipc_ids.rw_mutex held.
  */
- 
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
 	kuid_t euid;
@@ -266,7 +265,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
-	rcu_read_lock();
 	spin_lock(&new->lock);
 
 	id = idr_alloc(&ids->ipcs_idr, new,
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

linux-next.patch
shm-fix-null-pointer-deref-when-userspace-specifies-invalid-hugepage-size-fix.patch
softirq-use-_ret_ip_.patch
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

