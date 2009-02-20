From: akpm@linux-foundation.org
Subject: [merged] sysfs-reference-sysfs_dirent-from-sysfs-inodes.patch removed from -mm tree
Date: Fri, 20 Feb 2009 11:21:46 -0800
Message-ID: <200902201921.n1KJLkMa026503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460AbZBTTWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Feb 2009 14:22:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@aristanetworks.com, cornelia.huck@de.ibm.com, gregkh@suse.de, tj@kernel.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     sysfs: reference sysfs_dirent from sysfs inodes
has been removed from the -mm tree.  Its filename was
     sysfs-reference-sysfs_dirent-from-sysfs-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysfs: reference sysfs_dirent from sysfs inodes
From: Eric W. Biederman <ebiederm@aristanetworks.com>

The sysfs_dirent serves as both an inode and a directory entry
for sysfs.  To prevent the sysfs inode numbers from being freed
prematurely hold a reference to sysfs_dirent from the sysfs inode.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysfs/inode.c |   17 +++++++++++++++++
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 19 insertions(+)

diff -puN fs/sysfs/inode.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes fs/sysfs/inode.c
--- a/fs/sysfs/inode.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes
+++ a/fs/sysfs/inode.c
@@ -147,6 +147,7 @@ static void sysfs_init_inode(struct sysf
 {
 	struct bin_attribute *bin_attr;
 
+	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
 	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
 	inode->i_op = &sysfs_inode_operations;
@@ -214,6 +215,22 @@ struct inode * sysfs_get_inode(struct sy
 	return inode;
 }
 
+/*
+ * The sysfs_dirent serves as both an inode and a directory entry for sysfs.
+ * To prevent the sysfs inode numbers from being freed prematurely we take a
+ * reference to sysfs_dirent from the sysfs inode.  A
+ * super_operations.delete_inode() implementation is needed to drop that
+ * reference upon inode destruction.
+ */
+void sysfs_delete_inode(struct inode *inode)
+{
+	struct sysfs_dirent *sd  = inode->i_private;
+
+	truncate_inode_pages(&inode->i_data, 0);
+	clear_inode(inode);
+	sysfs_put(sd);
+}
+
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
 	struct sysfs_addrm_cxt acxt;
diff -puN fs/sysfs/mount.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes fs/sysfs/mount.c
--- a/fs/sysfs/mount.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes
+++ a/fs/sysfs/mount.c
@@ -29,6 +29,7 @@ struct kmem_cache *sysfs_dir_cachep;
 static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
+	.delete_inode	= sysfs_delete_inode,
 };
 
 struct sysfs_dirent sysfs_root = {
diff -puN fs/sysfs/sysfs.h~sysfs-reference-sysfs_dirent-from-sysfs-inodes fs/sysfs/sysfs.h
--- a/fs/sysfs/sysfs.h~sysfs-reference-sysfs_dirent-from-sysfs-inodes
+++ a/fs/sysfs/sysfs.h
@@ -145,6 +145,7 @@ static inline void __sysfs_put(struct sy
  * inode.c
  */
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
+void sysfs_delete_inode(struct inode *inode);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
_

Patches currently in -mm which might be from ebiederm@aristanetworks.com are

linux-next.patch

