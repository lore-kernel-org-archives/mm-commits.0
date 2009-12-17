From: akpm@linux-foundation.org
Subject: [merged] fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all.patch removed from -mm tree
Date: Thu, 17 Dec 2009 12:39:50 -0800
Message-ID: <200912172039.nBHKdo91017543@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764572AbZLQUkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Dec 2009 15:40:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ezk@cs.sunysb.edu, kirkland@canonical.com, tyhicks@linux.vnet.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fsstack/ecryptfs: remove unused get_nlinks param to fsstack_copy_attr_all
has been removed from the -mm tree.  Its filename was
     fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fsstack/ecryptfs: remove unused get_nlinks param to fsstack_copy_attr_all
From: Erez Zadok <ezk@cs.sunysb.edu>

This get_nlinks parameter was never used by the only mainline user,
ecryptfs; and it has never been used by unionfs or wrapfs either.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Acked-by: Dustin Kirkland <kirkland@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ecryptfs/dentry.c     |    2 +-
 fs/ecryptfs/inode.c      |    6 +++---
 fs/ecryptfs/main.c       |    2 +-
 fs/stack.c               |   17 +++--------------
 include/linux/fs_stack.h |    4 +---
 5 files changed, 9 insertions(+), 22 deletions(-)

diff -puN fs/ecryptfs/dentry.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all
+++ a/fs/ecryptfs/dentry.c
@@ -62,7 +62,7 @@ static int ecryptfs_d_revalidate(struct 
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
 
-		fsstack_copy_attr_all(dentry->d_inode, lower_inode, NULL);
+		fsstack_copy_attr_all(dentry->d_inode, lower_inode);
 	}
 out:
 	return rc;
diff -puN fs/ecryptfs/inode.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all
+++ a/fs/ecryptfs/inode.c
@@ -635,9 +635,9 @@ ecryptfs_rename(struct inode *old_dir, s
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
-	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
+	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
 	if (new_dir != old_dir)
-		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode, NULL);
+		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);
 out_lock:
 	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	dput(lower_new_dentry->d_parent);
@@ -1011,7 +1011,7 @@ static int ecryptfs_setattr(struct dentr
 	rc = notify_change(lower_dentry, &lower_ia);
 	mutex_unlock(&lower_dentry->d_inode->i_mutex);
 out:
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	return rc;
 }
 
diff -puN fs/ecryptfs/main.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all
+++ a/fs/ecryptfs/main.c
@@ -194,7 +194,7 @@ int ecryptfs_interpose(struct dentry *lo
 		init_special_inode(inode, lower_inode->i_mode,
 				   lower_inode->i_rdev);
 	dentry->d_op = &ecryptfs_dops;
-	fsstack_copy_attr_all(inode, lower_inode, NULL);
+	fsstack_copy_attr_all(inode, lower_inode);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
diff -puN fs/stack.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all fs/stack.c
--- a/fs/stack.c~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all
+++ a/fs/stack.c
@@ -14,11 +14,8 @@ void fsstack_copy_inode_size(struct inod
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
 
-/* copy all attributes; get_nlinks is optional way to override the i_nlink
- * copying
- */
-void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-				int (*get_nlinks)(struct inode *))
+/* copy all attributes */
+void fsstack_copy_attr_all(struct inode *dest, const struct inode *src)
 {
 	dest->i_mode = src->i_mode;
 	dest->i_uid = src->i_uid;
@@ -29,14 +26,6 @@ void fsstack_copy_attr_all(struct inode 
 	dest->i_ctime = src->i_ctime;
 	dest->i_blkbits = src->i_blkbits;
 	dest->i_flags = src->i_flags;
-
-	/*
-	 * Update the nlinks AFTER updating the above fields, because the
-	 * get_links callback may depend on them.
-	 */
-	if (!get_nlinks)
-		dest->i_nlink = src->i_nlink;
-	else
-		dest->i_nlink = (*get_nlinks)(dest);
+	dest->i_nlink = src->i_nlink;
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_attr_all);
diff -puN include/linux/fs_stack.h~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all include/linux/fs_stack.h
--- a/include/linux/fs_stack.h~fsstack-ecryptfs-remove-unused-get_nlinks-param-to-fsstack_copy_attr_all
+++ a/include/linux/fs_stack.h
@@ -8,9 +8,7 @@
 #include <linux/fs.h>
 
 /* externs for fs/stack.c */
-extern void fsstack_copy_attr_all(struct inode *dest, const struct inode *src,
-				int (*get_nlinks)(struct inode *));
