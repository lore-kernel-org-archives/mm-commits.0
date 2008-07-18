From: akpm@linux-foundation.org
Subject: - hppfs-remove-hppfs_permission.patch removed from -mm tree
Date: Fri, 18 Jul 2008 16:24:27 -0700
Message-ID: <200807182324.m6INORIK004196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758324AbYGRX1I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Jul 2008 19:27:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     hppfs: remove hppfs_permission
has been removed from the -mm tree.  Its filename was
     hppfs-remove-hppfs_permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hppfs: remove hppfs_permission
From: Miklos Szeredi <mszeredi@suse.cz>

hppfs_permission() is equivalent to the '.permission == NULL' case.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hppfs/hppfs.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN fs/hppfs/hppfs.c~hppfs-remove-hppfs_permission fs/hppfs/hppfs.c
--- a/fs/hppfs/hppfs.c~hppfs-remove-hppfs_permission
+++ a/fs/hppfs/hppfs.c
@@ -655,20 +655,13 @@ static void *hppfs_follow_link(struct de
 	return proc_dentry->d_inode->i_op->follow_link(proc_dentry, nd);
 }
 
-int hppfs_permission(struct inode *inode, int mask, struct nameidata *nd)
-{
-	return generic_permission(inode, mask, NULL);
-}
-
 static const struct inode_operations hppfs_dir_iops = {
 	.lookup		= hppfs_lookup,
-	.permission	= hppfs_permission,
 };
 
 static const struct inode_operations hppfs_link_iops = {
 	.readlink	= hppfs_readlink,
 	.follow_link	= hppfs_follow_link,
-	.permission	= hppfs_permission,
 };
 
 static struct inode *get_inode(struct super_block *sb, struct dentry *dentry)
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
linux-next.patch
git-unprivileged-mounts.patch
ecryptfs-string-copy-cleanup.patch
lockd-dont-return-eagain-for-a-permanent-error.patch
locks-add-special-return-value-for-asynchronous-locks.patch
locks-cleanup-code-duplication.patch
locks-allow-lock-to-return-file_lock_deferred.patch
fuse-prepare-lookup-for-nfs-export.patch
fuse-add-export-operations.patch
fuse-add-fuse_lookup_name-helper.patch
fuse-nfs-export-special-lookups.patch
fuse-lockd-support.patch

