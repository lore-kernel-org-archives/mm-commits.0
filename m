From: akpm@linux-foundation.org
Subject: - v9fs-dont-use-primary-fid-when-removing-file.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:52 -0700
Message-ID: <200704252038.l3PKcqDM012259@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48569 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993174AbXDYUlH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:41:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucho@ionkov.net, ericvh@hera.kernel.org, mm-commits@vger.kernel.org


The patch titled
     v9fs: don't use primary fid when removing file
has been removed from the -mm tree.  Its filename was
     v9fs-dont-use-primary-fid-when-removing-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: v9fs: don't use primary fid when removing file
From: "Latchesar Ionkov" <lucho@ionkov.net>

v9fs_insert uses v9fs_fid_lookup (which also locks the fid) to get the
primary fid associated with the dentry and destroys the v9fs_fid struct
after removing the file.  If another process called v9fs_fid_lookup on the
same dentry, it may wait undefinitely for the fid's lock (as the struct is
freed).

This patch changes v9fs_remove to use a cloned fid, so the primary fid is
not locked and freed.

Signed-off-by: Latchesar Ionkov <lucho@ionkov.net>
Cc: Eric Van Hensbergen <ericvh@hera.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/vfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/9p/vfs_inode.c~v9fs-dont-use-primary-fid-when-removing-file fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~v9fs-dont-use-primary-fid-when-removing-file
+++ a/fs/9p/vfs_inode.c
@@ -415,7 +415,7 @@ static int v9fs_remove(struct inode *dir
 	file_inode = file->d_inode;
 	sb = file_inode->i_sb;
 	v9ses = v9fs_inode2v9ses(file_inode);
-	v9fid = v9fs_fid_lookup(file);
+	v9fid = v9fs_fid_clone(file);
 	if(IS_ERR(v9fid))
 		return PTR_ERR(v9fid);
 
_

Patches currently in -mm which might be from lucho@ionkov.net are

origin.patch
