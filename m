From: akpm@linux-foundation.org
Subject: [to-be-updated] ecryptfs-some-inode-attr-fixes.patch removed from -mm tree
Date: Thu, 15 Jan 2009 15:52:11 -0800
Message-ID: <200901152352.n0FNqB9Z020268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53606 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935155AbZAOXwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jan 2009 18:52:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hooanon05@yahoo.co.jp, shaggy@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs: some inode attr fixes
has been removed from the -mm tree.  Its filename was
     ecryptfs-some-inode-attr-fixes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ecryptfs: some inode attr fixes
From: J. R. Okajima <hooanon05@yahoo.co.jp>

- The ecryptfs inode holds a reference to the lower inode, but doesn't
  increment the reference counter. When a user sets inotify to the
  ecryptfs inode, it may live without the corresponding dentry. In this
  case the referecen to the lower inode may be broken.
  This patch maintains the reference of the lower inode.

- follow the VFS unlink sequence in ecryptfs_unlink() which is
  inrementing and decrementing the inode->i_count and the reference
  counter for the dentry.

- maintain the link count and ctime in ecryptfs_rmdir() because a user
  may issue fstat(2) later.

- remove the unnecessary d_drop()s in ecryptfs_link().

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/inode.c |   13 +++++++++----
 fs/ecryptfs/super.c |    2 ++
 2 files changed, 11 insertions(+), 4 deletions(-)

diff -puN fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-some-inode-attr-fixes
+++ a/fs/ecryptfs/inode.c
@@ -467,9 +467,6 @@ out_lock:
 	unlock_dir(lower_dir_dentry);
 	dput(lower_new_dentry);
 	dput(lower_old_dentry);
-	d_drop(lower_old_dentry);
-	d_drop(new_dentry);
-	d_drop(old_dentry);
 	return rc;
 }
 
@@ -481,7 +478,10 @@ static int ecryptfs_unlink(struct inode 
 	struct dentry *lower_dir_dentry;
 
 	lower_dir_dentry = lock_parent(lower_dentry);
+	dget(lower_dentry);
+	atomic_inc_return(&lower_dentry->d_inode->i_count);
 	rc = vfs_unlink(lower_dir_inode, lower_dentry);
+	dput(lower_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
 		goto out_unlock;
@@ -492,6 +492,7 @@ static int ecryptfs_unlink(struct inode 
 	dentry->d_inode->i_ctime = dir->i_ctime;
 	d_drop(dentry);
 out_unlock:
+	iput(lower_dentry->d_inode);
 	unlock_dir(lower_dir_dentry);
 	return rc;
 }
@@ -577,8 +578,12 @@ static int ecryptfs_rmdir(struct inode *
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
 	unlock_dir(lower_dir_dentry);
-	if (!rc)
+	if (!rc) {
+		struct inode *inode = dentry->d_inode;
+		inode->i_nlink = ecryptfs_inode_to_lower(inode)->i_nlink;
+		inode->i_ctime = dir->i_ctime;
 		d_drop(dentry);
+	}
 	dput(dentry);
 	return rc;
 }
diff -puN fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes fs/ecryptfs/super.c
--- a/fs/ecryptfs/super.c~ecryptfs-some-inode-attr-fixes
+++ a/fs/ecryptfs/super.c
@@ -89,6 +89,7 @@ static void ecryptfs_destroy_inode(struc
 		}
 	}
 	mutex_unlock(&inode_info->lower_file_mutex);
+	iput(inode_info->wii_inode);
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
 	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
 }
@@ -101,6 +102,7 @@ static void ecryptfs_destroy_inode(struc
  */
 void ecryptfs_init_inode(struct inode *inode, struct inode *lower_inode)
 {
+	atomic_inc_return(&lower_inode->i_count);
 	ecryptfs_set_inode_lower(inode, lower_inode);
 	inode->i_ino = lower_inode->i_ino;
 	inode->i_version++;
_

Patches currently in -mm which might be from hooanon05@yahoo.co.jp are

loop-add-ioctl-to-resize-a-loop-device.patch
loop-add-ioctl-to-resize-a-loop-device-security-check-for-loop_set_capacity.patch
loop-add-ioctl-to-resize-a-loop-device-loop_set_capacity-sector_t-may-be-narrow-for-bit-shfit.patch
ecryptfs-some-inode-attr-fixes.patch

