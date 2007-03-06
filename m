From: akpm@linux-foundation.org
Subject: + ecryptfs-nested-locking-annotation.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:09:34 -0800
Message-ID: <200703060409.l2649Yjg011383@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49975 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933931AbXCFET1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mhalcrow@us.ibm.com


The patch titled
     ecryptfs: nested locking annotation
has been added to the -mm tree.  Its filename is
     ecryptfs-nested-locking-annotation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mqueue-nested-locking-annotation.patch
ecryptfs-nested-locking-annotation.patch
nfs-fix-congestion-control-v4.patch
nfs-fix-congestion-control-use-atomic_longs.patch
