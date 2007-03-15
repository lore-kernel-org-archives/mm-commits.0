From: akpm@linux-foundation.org
Subject: - ecryptfs-nested-locking-annotation.patch removed from -mm tree
Date: Thu, 15 Mar 2007 13:56:36 -0800
Message-ID: <200703152156.l2FLuaQv027578@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42590 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752069AbXCOV7v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:59:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: nested locking annotation
has been removed from the -mm tree.  Its filename was
     ecryptfs-nested-locking-annotation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ecryptfs: nested locking annotation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

ecryptfs uses a lock_parent() function, which I hope really locks the parents
and is not abused

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-nested-locking-annotation fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-nested-locking-annotation
+++ a/fs/ecryptfs/inode.c
@@ -38,7 +38,7 @@ static struct dentry *lock_parent(struct
 	struct dentry *dir;
 
 	dir = dget(dentry->d_parent);
-	mutex_lock(&(dir->d_inode->i_mutex));
+	mutex_lock_nested(&(dir->d_inode->i_mutex), I_MUTEX_PARENT);
 	return dir;
 }
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
nfs-fix-congestion-control-v4.patch
exec-fix-remove_arg_zero-add-comment.patch
lists-add-list-splice-tail.patch
nfs-fix-congestion-control-use-atomic_longs.patch
