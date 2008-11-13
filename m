From: akpm@linux-foundation.org
Subject: + sysvipc-fix-the-ipc-structures-initialization.patch added to -mm tree
Date: Thu, 13 Nov 2008 10:09:25 -0800
Message-ID: <200811131809.mADI9Psc026373@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751653AbYKMSK1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 13:10:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, cboulte@gmail.com, manfred@colorfullife.com, stable@kernel.org


The patch titled
     sysvipc: fix the ipc structures initialization
has been added to the -mm tree.  Its filename is
     sysvipc-fix-the-ipc-structures-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysvipc: fix the ipc structures initialization


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

sysvipc-fix-the-ipc-structures-initialization.patch
ipc-clean-up-ipc-shmc.patch

