From: akpm@linux-foundation.org
Subject: - sysvipc-fix-the-ipc-structures-initialization.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:42:09 -0800
Message-ID: <200811202042.mAKKg9WT006773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755207AbYKTUnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:43:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, cboulte@gmail.com, manfred@colorfullife.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     sysvipc: fix the ipc structures initialization
has been removed from the -mm tree.  Its filename was
     sysvipc-fix-the-ipc-structures-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysvipc: fix the ipc structures initialization
From: Nadia Derbey <Nadia.Derbey@bull.net>

A problem was found while reviewing the code after Bugzilla bug
http://bugzilla.kernel.org/show_bug.cgi?id=11796.

In ipc_addid(), the newly allocated ipc structure is inserted into the
ipcs tree (i.e made visible to readers) without locking it.  This is not
correct since its initialization continues after it has been inserted in
the tree.

This patch moves the ipc structure lock initialization + locking before
the actual insertion.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Reported-by: Clement Calmels <cboulte@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: <stable@kernel.org>		[2.6.27.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN ipc/util.c~sysvipc-fix-the-ipc-structures-initialization ipc/util.c
--- a/ipc/util.c~sysvipc-fix-the-ipc-structures-initialization
+++ a/ipc/util.c
@@ -266,9 +266,17 @@ int ipc_addid(struct ipc_ids* ids, struc
 	if (ids->in_use >= size)
 		return -ENOSPC;
 
+	spin_lock_init(&new->lock);
+	new->deleted = 0;
+	rcu_read_lock();
+	spin_lock(&new->lock);
+
 	err = idr_get_new(&ids->ipcs_idr, new, &id);
-	if (err)
+	if (err) {
+		spin_unlock(&new->lock);
+		rcu_read_unlock();
 		return err;
+	}
 
 	ids->in_use++;
 
@@ -280,10 +288,6 @@ int ipc_addid(struct ipc_ids* ids, struc
 		ids->seq = 0;
 
 	new->id = ipc_buildid(id, new->seq);
-	spin_lock_init(&new->lock);
-	new->deleted = 0;
-	rcu_read_lock();
-	spin_lock(&new->lock);
 	return id;
 }
 
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
ipc-clean-up-ipc-shmc.patch
ipc-ipc_sysctlc-move-the-definition-of-ipc_auto_callback.patch

