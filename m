From: akpm@linux-foundation.org
Subject: [merged] ipc-convert-to-idr_alloc.patch removed from -mm tree
Date: Thu, 28 Feb 2013 12:15:39 -0800
Message-ID: <20130228201540.353AB31C0A0@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:59045 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758343Ab3B1UPl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 28 Feb 2013 15:15:41 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so246533yhz.5
        for <mm-commits@vger.kernel.org>; Thu, 28 Feb 2013 12:15:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tj@kernel.org, ebiederm@xmission.com, jmorris@namei.org, sedat.dilek@gmail.com, skinsbursky@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: convert to idr_alloc()
has been removed from the -mm tree.  Its filename was
     ipc-convert-to-idr_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tejun Heo <tj@kernel.org>
Subject: ipc: convert to idr_alloc()

Convert to the much saner new idr interface.

The new interface doesn't directly translate to the way idr_pre_get()
was used around ipc_addid() as preloading disables preemption.  From
my cursory reading, it seems like we should be able to do all
allocation from ipc_addid(), so I moved it there.  Can you please
check whether this would be okay?  If this is wrong and ipc_addid()
should be allowed to be called from non-sleepable context, I'd suggest
allocating id itself in the outer functions and later install the
pointer using idr_replace().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: James Morris <jmorris@namei.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff -puN ipc/util.c~ipc-convert-to-idr_alloc ipc/util.c
--- a/ipc/util.c~ipc-convert-to-idr_alloc
+++ a/ipc/util.c
@@ -252,7 +252,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 {
 	kuid_t euid;
 	kgid_t egid;
-	int id, err;
+	int id;
 	int next_id = ids->next_id;
 
 	if (size > IPCMNI)
@@ -261,17 +261,21 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
+	idr_preload(GFP_KERNEL);
+
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
 	rcu_read_lock();
 	spin_lock(&new->lock);
 
-	err = idr_get_new_above(&ids->ipcs_idr, new,
-				(next_id < 0) ? 0 : ipcid_to_idx(next_id), &id);
-	if (err) {
+	id = idr_alloc(&ids->ipcs_idr, new,
+		       (next_id < 0) ? 0 : ipcid_to_idx(next_id), 0,
+		       GFP_NOWAIT);
+	idr_preload_end();
+	if (id < 0) {
 		spin_unlock(&new->lock);
 		rcu_read_unlock();
-		return err;
+		return id;
 	}
 
 	ids->in_use++;
@@ -307,19 +311,10 @@ static int ipcget_new(struct ipc_namespa
 		struct ipc_ops *ops, struct ipc_params *params)
 {
 	int err;
-retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
-
-	if (!err)
-		return -ENOMEM;
 
 	down_write(&ids->rw_mutex);
 	err = ops->getnew(ns, params);
 	up_write(&ids->rw_mutex);
-
-	if (err == -EAGAIN)
-		goto retry;
-
 	return err;
 }
 
@@ -376,8 +371,6 @@ static int ipcget_public(struct ipc_name
 	struct kern_ipc_perm *ipcp;
 	int flg = params->flg;
 	int err;
-retry:
-	err = idr_pre_get(&ids->ipcs_idr, GFP_KERNEL);
 
 	/*
 	 * Take the lock as a writer since we are potentially going to add
@@ -389,8 +382,6 @@ retry:
 		/* key not used */
 		if (!(flg & IPC_CREAT))
 			err = -ENOENT;
-		else if (!err)
-			err = -ENOMEM;
 		else
 			err = ops->getnew(ns, params);
 	} else {
@@ -413,9 +404,6 @@ retry:
 	}
 	up_write(&ids->rw_mutex);
 
-	if (err == -EAGAIN)
-		goto retry;
