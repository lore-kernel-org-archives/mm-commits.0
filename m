From: akpm@linux-foundation.org
Subject: - ipc-call-idr_find-without-locking-in-ipc_lock.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:00:49 -0700
Message-ID: <200807252300.m6PN0nSu003623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56444 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754995AbYGYXJR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:09:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, paulmck@us.ibm.com, peifferp@gmail.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ipc: call idr_find() without locking in ipc_lock()
has been removed from the -mm tree.  Its filename was
     ipc-call-idr_find-without-locking-in-ipc_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: call idr_find() without locking in ipc_lock()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Call idr_find() locklessly from ipc_lock(), since the idr tree is now RCU
protected.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Acked-by: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    9 ---------
 1 file changed, 9 deletions(-)

diff -puN ipc/util.c~ipc-call-idr_find-without-locking-in-ipc_lock ipc/util.c
--- a/ipc/util.c~ipc-call-idr_find-without-locking-in-ipc_lock
+++ a/ipc/util.c
@@ -688,10 +688,6 @@ void ipc64_perm_to_ipc_perm (struct ipc6
  * Look for an id in the ipc ids idr and lock the associated ipc object.
  *
  * The ipc object is locked on exit.
- *
- * This is the routine that should be called when the rw_mutex is not already
- * held, i.e. idr tree not protected: it protects the idr tree in read mode
- * during the idr_find().
  */
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *ids, int id)
@@ -699,18 +695,13 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
 
-	down_read(&ids->rw_mutex);
-
 	rcu_read_lock();
 	out = idr_find(&ids->ipcs_idr, lid);
 	if (out == NULL) {
 		rcu_read_unlock();
-		up_read(&ids->rw_mutex);
 		return ERR_PTR(-EINVAL);
 	}
 
-	up_read(&ids->rw_mutex);
