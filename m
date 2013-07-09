From: akpm@linux-foundation.org
Subject: [merged] ipc-move-rcu-lock-out-of-ipc_addid.patch removed from
 -mm tree
Date: Tue, 09 Jul 2013 16:21:29 -0700
Message-ID: <51dc9af9.ihMHuHLP+ImuPBPj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab3GIXVa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:21:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, andi@firstfloor.org, davidlohr.bueso@hp.com

Subject: [merged] ipc-move-rcu-lock-out-of-ipc_addid.patch removed from -mm tree
To: davidlohr.bueso@hp.com,andi@firstfloor.org,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:21:29 -0700


The patch titled
     Subject: ipc: move rcu lock out of ipc_addid
has been removed from the -mm tree.  Its filename was
     ipc-move-rcu-lock-out-of-ipc_addid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 ipc/msg.c  |    7 +++----
 ipc/shm.c  |    5 ++++-
 ipc/util.c |    3 +--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff -puN ipc/msg.c~ipc-move-rcu-lock-out-of-ipc_addid ipc/msg.c
--- a/ipc/msg.c~ipc-move-rcu-lock-out-of-ipc_addid
+++ a/ipc/msg.c
@@ -199,9 +199,7 @@ static int newque(struct ipc_namespace *
 		return retval;
 	}
 
-	/*
-	 * ipc_addid() locks msq
-	 */
+	/* ipc_addid() locks msq upon success. */
 	id = ipc_addid(&msg_ids(ns), &msq->q_perm, ns->msg_ctlmni);
 	if (id < 0) {
 		security_msg_queue_free(msq);
@@ -218,7 +216,8 @@ static int newque(struct ipc_namespace *
 	INIT_LIST_HEAD(&msq->q_receivers);
 	INIT_LIST_HEAD(&msq->q_senders);
 
-	msg_unlock(msq);
+	spin_unlock(&msq->q_perm.lock);
+	rcu_read_unlock();
 
 	return msq->q_perm.id;
 }
diff -puN ipc/shm.c~ipc-move-rcu-lock-out-of-ipc_addid ipc/shm.c
--- a/ipc/shm.c~ipc-move-rcu-lock-out-of-ipc_addid
+++ a/ipc/shm.c
@@ -535,6 +535,7 @@ static int newseg(struct ipc_namespace *
 	shp->shm_nattch = 0;
 	shp->shm_file = file;
 	shp->shm_creator = current;
+
 	/*
 	 * shmid gets reported as "inode#" in /proc/pid/maps.
 	 * proc-ps tools use this. Changing this will break them.
@@ -543,7 +544,9 @@ static int newseg(struct ipc_namespace *
 
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
+ *	Called with writer ipc_ids.rw_mutex held.
  */
- 
 int ipc_addid(struct ipc_ids* ids, struct kern_ipc_perm* new, int size)
 {
 	kuid_t euid;
_

Patches currently in -mm which might be from davidlohr.bueso@hp.com are

origin.patch

