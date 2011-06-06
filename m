From: akpm@linux-foundation.org
Subject: [obsolete] reiserfs-fix-null-pointer-deference-in-open_xa_dir.patch removed from -mm tree
Date: Mon, 06 Jun 2011 15:41:36 -0700
Message-ID: <201106062241.p56MfaMX027333@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758181Ab1FFWmJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2011 18:42:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, hch@lst.de, sage@newdream.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix NULL pointer deference in open_xa_dir()
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-null-pointer-deference-in-open_xa_dir.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix NULL pointer deference in open_xa_dir()
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Commit cc350c2764a ("reiserfs: remove unnecessary dentry_unhash from
rmdir, dir rename") removed dentry_unhash() from rmdir, dir rename
functions.  That caused NULL pointer dereference at open_xa_dir+0x3f/01b3

Trace:
?xattr_unlink()
reiserfs_for_each_xattr()
?mutex_lock_nested()
?get_parent_ip()
reiserfs_delete_xattrs()
reiserfs_evict_inode()
[..]

Patch reverts cc350c2764a657ee0.  The difference is that reiserfs_rmdir()
calls dentry_unhash() only for xattr dirs, since (as commit message
states) references to unlinked non-xattrs directories are handled by
reiserfs.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/namei.c |    7 +++++++
 fs/reiserfs/xattr.c |    1 +
 2 files changed, 8 insertions(+)

diff -puN fs/reiserfs/namei.c~reiserfs-fix-null-pointer-deference-in-open_xa_dir fs/reiserfs/namei.c
--- a/fs/reiserfs/namei.c~reiserfs-fix-null-pointer-deference-in-open_xa_dir
+++ a/fs/reiserfs/namei.c
@@ -831,6 +831,10 @@ static int reiserfs_rmdir(struct inode *
 	INITIALIZE_PATH(path);
 	struct reiserfs_dir_entry de;
 
+	/* This is the xattr dir, handle specially. */
+	if (S_ISDIR(dentry->d_inode->i_mode))
+		dentry_unhash(dentry);
+
 	/* we will be doing 2 balancings and update 2 stat data, we change quotas
 	 * of the owner of the directory and of the owner of the parent directory.
 	 * The quota structure is possibly deleted only on last iput => outside
@@ -1225,6 +1229,9 @@ static int reiserfs_rename(struct inode 
 	unsigned long savelink = 1;
 	struct timespec ctime;
 
+	if (new_dentry->d_inode && S_ISDIR(new_dentry->d_inode->i_mode))
+		dentry_unhash(new_dentry);
+
 	/* three balancings: (1) old name removal, (2) new name insertion
 	   and (3) maybe "save" link insertion
 	   stat data updates: (1) old directory,
diff -puN fs/reiserfs/xattr.c~reiserfs-fix-null-pointer-deference-in-open_xa_dir fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~reiserfs-fix-null-pointer-deference-in-open_xa_dir
+++ a/fs/reiserfs/xattr.c
@@ -98,6 +98,7 @@ static int xattr_rmdir(struct inode *dir
 
 	reiserfs_mutex_lock_nested_safe(&dentry->d_inode->i_mutex,
 					I_MUTEX_CHILD, dir->i_sb);
+	dentry_unhash(dentry);
 	error = dir->i_op->rmdir(dir, dentry);
 	if (!error)
 		dentry->d_inode->i_flags |= S_DEAD;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are


