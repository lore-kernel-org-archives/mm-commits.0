From: akpm@linux-foundation.org
Subject: - ecryptfs-clean-up-unlock_parent.patch removed from -mm tree
Date: Tue, 13 May 2008 14:33:05 -0700
Message-ID: <200805132133.m4DLX5LO000782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37485 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762118AbYEMVdw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:33:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hch@infradead.org, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: clean up (un)lock_parent
has been removed from the -mm tree.  Its filename was
     ecryptfs-clean-up-unlock_parent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: clean up (un)lock_parent
From: Miklos Szeredi <mszeredi@suse.cz>

dget(dentry->d_parent) --> dget_parent(dentry)

unlock_parent() is racy and unnecessary.  Replace single caller with
unlock_dir().

There are several other suspect uses of ->d_parent in ecryptfs...

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-clean-up-unlock_parent fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-clean-up-unlock_parent
+++ a/fs/ecryptfs/inode.c
@@ -37,17 +37,11 @@ static struct dentry *lock_parent(struct
 {
 	struct dentry *dir;
 
-	dir = dget(dentry->d_parent);
+	dir = dget_parent(dentry);
 	mutex_lock_nested(&(dir->d_inode->i_mutex), I_MUTEX_PARENT);
 	return dir;
 }
 
-static void unlock_parent(struct dentry *dentry)
-{
-	mutex_unlock(&(dentry->d_parent->d_inode->i_mutex));
-	dput(dentry->d_parent);
-}
-
 static void unlock_dir(struct dentry *dir)
 {
 	mutex_unlock(&dir->d_inode->i_mutex);
@@ -426,8 +420,9 @@ static int ecryptfs_unlink(struct inode 
 	int rc = 0;
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
 	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
+	struct dentry *lower_dir_dentry;
 
-	lock_parent(lower_dentry);
+	lower_dir_dentry = lock_parent(lower_dentry);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
@@ -439,7 +434,7 @@ static int ecryptfs_unlink(struct inode 
 	dentry->d_inode->i_ctime = dir->i_ctime;
 	d_drop(dentry);
 out_unlock:
-	unlock_parent(lower_dentry);
+	unlock_dir(lower_dir_dentry);
 	return rc;
 }
 
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-vfs-cleanups.patch
mm-fix-infinite-loop-in-filemap_fault.patch

