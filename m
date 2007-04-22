From: akpm@linux-foundation.org
Subject: + v9fs-dont-use-primary-fid-when-removing-file.patch added to -mm tree
Date: Sat, 21 Apr 2007 19:55:04 -0700
Message-ID: <200704220255.l3M2t48B018236@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43160 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754018AbXDVC46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Apr 2007 22:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lucho@ionkov.net, ericvh@hera.kernel.org


The patch titled
     v9fs: don't use primary fid when removing file
has been added to the -mm tree.  Its filename is
     v9fs-dont-use-primary-fid-when-removing-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

v9fs-dont-use-primary-fid-when-removing-file.patch
