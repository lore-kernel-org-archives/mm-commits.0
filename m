From: akpm@linux-foundation.org
Subject: - iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:20:53 -0800
Message-ID: <200802080820.m188KY7a015328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36988 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932733AbYBHIUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     Unionfs: stop using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch

This patch was dropped because it was folded into iget-stop-unionfs-from-using-iget-and-read_inode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Unionfs: stop using iget() and read_inode()
From: Erez Zadok <ezk@cs.sunysb.edu>

Unionfs: bugfix to initialize unionfs_inode_info node

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/unionfs/super.c~iget-stop-unionfs-from-using-iget-and-read_inode-fix fs/unionfs/super.c
--- a/fs/unionfs/super.c~iget-stop-unionfs-from-using-iget-and-read_inode-fix
+++ a/fs/unionfs/super.c
@@ -36,6 +36,7 @@ struct inode *unionfs_iget(struct super_
  	if (!(inode->i_state & I_NEW))
  		return inode;
 
+	info = UNIONFS_I(inode);
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
_

Patches currently in -mm which might be from ezk@cs.sunysb.edu are

origin.patch
git-unionfs.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
use-struct-path-in-struct-svc_export-nfsd-fix-wrong-mnt_writer-count-in-rename.patch
