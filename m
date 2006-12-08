From: akpm@osdl.org
Subject: - ecryptfs-use-fsstacks-generic-copy-inode-attr.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:24 -0800
Message-ID: <200612082001.kB8K1O7G001860@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426199AbWLHUBb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     eCryptfs: Use fsstack's generic copy inode attr functions
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-fsstacks-generic-copy-inode-attr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: eCryptfs: Use fsstack's generic copy inode attr functions
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Replace eCryptfs specific code & calls with the more generic fsstack
equivalents and remove the eCryptfs specific functions.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/dentry.c          |    3 -
 fs/ecryptfs/ecryptfs_kernel.h |    4 -
 fs/ecryptfs/file.c            |    3 -
 fs/ecryptfs/inode.c           |   75 ++++++++------------------------
 fs/ecryptfs/main.c            |    5 +-
 5 files changed, 27 insertions(+), 63 deletions(-)

diff -puN fs/ecryptfs/dentry.c~ecryptfs-use-fsstacks-generic-copy-inode-attr fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~ecryptfs-use-fsstacks-generic-copy-inode-attr
+++ a/fs/ecryptfs/dentry.c
@@ -25,6 +25,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/mount.h>
+#include <linux/fs_stack.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -61,7 +62,7 @@ static int ecryptfs_d_revalidate(struct 
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
 
-		ecryptfs_copy_attr_all(dentry->d_inode, lower_inode);
+		fsstack_copy_attr_all(dentry->d_inode, lower_inode, NULL);
 	}
 out:
 	return rc;
diff -puN fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-use-fsstacks-generic-copy-inode-attr fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~ecryptfs-use-fsstacks-generic-copy-inode-attr
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -28,6 +28,7 @@
 
 #include <keys/user-type.h>
 #include <linux/fs.h>
+#include <linux/fs_stack.h>
 #include <linux/scatterlist.h>
 
 /* Version verification for shared data structures w/ userspace */
@@ -413,9 +414,6 @@ int ecryptfs_encode_filename(struct ecry
 			     const char *name, int length,
 			     char **encoded_name);
 struct dentry *ecryptfs_lower_dentry(struct dentry *this_dentry);
-void ecryptfs_copy_attr_atime(struct inode *dest, const struct inode *src);
-void ecryptfs_copy_attr_all(struct inode *dest, const struct inode *src);
-void ecryptfs_copy_inode_size(struct inode *dst, const struct inode *src);
 void ecryptfs_dump_hex(char *data, int bytes);
 int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
 			int sg_size);
diff -puN fs/ecryptfs/file.c~ecryptfs-use-fsstacks-generic-copy-inode-attr fs/ecryptfs/file.c
--- a/fs/ecryptfs/file.c~ecryptfs-use-fsstacks-generic-copy-inode-attr
+++ a/fs/ecryptfs/file.c
@@ -30,6 +30,7 @@
 #include <linux/security.h>
 #include <linux/smp_lock.h>
 #include <linux/compat.h>
+#include <linux/fs_stack.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -192,7 +193,7 @@ retry:
 		goto retry;
 	file->f_pos = lower_file->f_pos;
 	if (rc >= 0)
-		ecryptfs_copy_attr_atime(inode, lower_file->f_dentry->d_inode);
+		fsstack_copy_attr_atime(inode, lower_file->f_dentry->d_inode);
 	return rc;
 }
 
diff -puN fs/ecryptfs/inode.c~ecryptfs-use-fsstacks-generic-copy-inode-attr fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-use-fsstacks-generic-copy-inode-attr
+++ a/fs/ecryptfs/inode.c
@@ -30,6 +30,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/crypto.h>
+#include <linux/fs_stack.h>
 #include "ecryptfs_kernel.h"
 
 static struct dentry *lock_parent(struct dentry *dentry)
@@ -53,48 +54,6 @@ static void unlock_dir(struct dentry *di
 	dput(dir);
 }
 
-void ecryptfs_copy_inode_size(struct inode *dst, const struct inode *src)
-{
-	i_size_write(dst, i_size_read((struct inode *)src));
-	dst->i_blocks = src->i_blocks;
-}
-
-void ecryptfs_copy_attr_atime(struct inode *dest, const struct inode *src)
-{
-	dest->i_atime = src->i_atime;
-}
-
-static void ecryptfs_copy_attr_times(struct inode *dest,
-				     const struct inode *src)
-{
-	dest->i_atime = src->i_atime;
-	dest->i_mtime = src->i_mtime;
-	dest->i_ctime = src->i_ctime;
-}
-
-static void ecryptfs_copy_attr_timesizes(struct inode *dest,
-					 const struct inode *src)
-{
-	dest->i_atime = src->i_atime;
-	dest->i_mtime = src->i_mtime;
-	dest->i_ctime = src->i_ctime;
-	ecryptfs_copy_inode_size(dest, src);
-}
-
-void ecryptfs_copy_attr_all(struct inode *dest, const struct inode *src)
-{
-	dest->i_mode = src->i_mode;
-	dest->i_nlink = src->i_nlink;
-	dest->i_uid = src->i_uid;
-	dest->i_gid = src->i_gid;
-	dest->i_rdev = src->i_rdev;
-	dest->i_atime = src->i_atime;
-	dest->i_mtime = src->i_mtime;
-	dest->i_ctime = src->i_ctime;
-	dest->i_blkbits = src->i_blkbits;
-	dest->i_flags = src->i_flags;
-}
-
 /**
  * ecryptfs_create_underlying_file
  * @lower_dir_inode: inode of the parent in the lower fs of the new file
@@ -171,8 +130,8 @@ ecryptfs_do_create(struct inode *directo
 		ecryptfs_printk(KERN_ERR, "Failure in ecryptfs_interpose\n");
 		goto out_lock;
 	}
-	ecryptfs_copy_attr_timesizes(directory_inode,
-				     lower_dir_dentry->d_inode);
+	fsstack_copy_attr_times(directory_inode, lower_dir_dentry->d_inode);
+	fsstack_copy_inode_size(directory_inode, lower_dir_dentry->d_inode);
 out_lock:
 	unlock_dir(lower_dir_dentry);
 out:
@@ -365,7 +324,7 @@ static struct dentry *ecryptfs_lookup(st
        		"d_name.name = [%s]\n", lower_dentry,
 		lower_dentry->d_name.name);
 	lower_inode = lower_dentry->d_inode;
-	ecryptfs_copy_attr_atime(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_atime(dir, lower_dir_dentry->d_inode);
 	BUG_ON(!atomic_read(&lower_dentry->d_count));
 	ecryptfs_set_dentry_private(dentry,
 				    kmem_cache_alloc(ecryptfs_dentry_info_cache,
@@ -462,7 +421,8 @@ static int ecryptfs_link(struct dentry *
 	rc = ecryptfs_interpose(lower_new_dentry, new_dentry, dir->i_sb, 0);
 	if (rc)
 		goto out_lock;
-	ecryptfs_copy_attr_timesizes(dir, lower_new_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_new_dentry->d_inode);
+	fsstack_copy_inode_size(dir, lower_new_dentry->d_inode);
 	old_dentry->d_inode->i_nlink =
 		ecryptfs_inode_to_lower(old_dentry->d_inode)->i_nlink;
 	i_size_write(new_dentry->d_inode, file_size_save);
@@ -488,7 +448,7 @@ static int ecryptfs_unlink(struct inode 
 		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
 		goto out_unlock;
 	}
-	ecryptfs_copy_attr_times(dir, lower_dir_inode);
+	fsstack_copy_attr_times(dir, lower_dir_inode);
 	dentry->d_inode->i_nlink =
 		ecryptfs_inode_to_lower(dentry->d_inode)->i_nlink;
 	dentry->d_inode->i_ctime = dir->i_ctime;
@@ -527,7 +487,8 @@ static int ecryptfs_symlink(struct inode
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out_lock;
-	ecryptfs_copy_attr_timesizes(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
 out_lock:
 	unlock_dir(lower_dir_dentry);
 	dput(lower_dentry);
@@ -550,7 +511,8 @@ static int ecryptfs_mkdir(struct inode *
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out;
-	ecryptfs_copy_attr_timesizes(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
 	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
 out:
 	unlock_dir(lower_dir_dentry);
@@ -573,7 +535,7 @@ static int ecryptfs_rmdir(struct inode *
 	dput(lower_dentry);
 	if (!rc)
 		d_delete(lower_dentry);
-	ecryptfs_copy_attr_times(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
 	dir->i_nlink = lower_dir_dentry->d_inode->i_nlink;
 	unlock_dir(lower_dir_dentry);
 	if (!rc)
@@ -597,7 +559,8 @@ ecryptfs_mknod(struct inode *dir, struct
 	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out;
-	ecryptfs_copy_attr_timesizes(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
+	fsstack_copy_inode_size(dir, lower_dir_dentry->d_inode);
 out:
 	unlock_dir(lower_dir_dentry);
 	if (!dentry->d_inode)
@@ -626,9 +589,9 @@ ecryptfs_rename(struct inode *old_dir, s
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
-	ecryptfs_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
+	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
 	if (new_dir != old_dir)
-		ecryptfs_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);
+		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode, NULL);
 out_lock:
 	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	dput(lower_new_dentry->d_parent);
@@ -684,8 +647,8 @@ ecryptfs_readlink(struct dentry *dentry,
 				rc = -EFAULT;
 		}
 		kfree(decoded_name);
-		ecryptfs_copy_attr_atime(dentry->d_inode,
-					 lower_dentry->d_inode);
+		fsstack_copy_attr_atime(dentry->d_inode,
+					lower_dentry->d_inode);
 	}
 out_free_lower_buf:
 	kfree(lower_buf);
@@ -915,7 +878,7 @@ static int ecryptfs_setattr(struct dentr
 	}
 	rc = notify_change(lower_dentry, ia);
 out:
-	ecryptfs_copy_attr_all(inode, lower_inode);
+	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	return rc;
 }
 
diff -puN fs/ecryptfs/main.c~ecryptfs-use-fsstacks-generic-copy-inode-attr fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-use-fsstacks-generic-copy-inode-attr
+++ a/fs/ecryptfs/main.c
@@ -35,6 +35,7 @@
 #include <linux/pagemap.h>
 #include <linux/key.h>
 #include <linux/parser.h>
+#include <linux/fs_stack.h>
 #include "ecryptfs_kernel.h"
 
 /**
@@ -112,10 +113,10 @@ int ecryptfs_interpose(struct dentry *lo
 		d_add(dentry, inode);
 	else
 		d_instantiate(dentry, inode);
-	ecryptfs_copy_attr_all(inode, lower_inode);
+	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
-	ecryptfs_copy_inode_size(inode, lower_inode);
+	fsstack_copy_inode_size(inode, lower_inode);
 out:
 	return rc;
 }
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

ecryptfs-use-fsstacks-generic-copy-inode-attr.patch
struct-path-rename-reiserfss-struct-path.patch
struct-path-rename-dms-struct-path.patch
struct-path-move-struct-path-from-fs-nameic-into.patch
struct-path-make-ecryptfs-a-user-of-struct-path.patch
vfs-change-struct-file-to-use-struct-path.patch
sysfs-change-uses-of-f_dentry.patch
proc-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext2-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext3-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ext4-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
fat-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
isofs-change-uses-of-f_dentry.patch
nfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
nfsd-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ntfs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
i386-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
x86_64-change-uses-of-f_dentry.patch
kernel-change-uses-of-f_dentry.patch
mm-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
9p-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch
affs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
autofs-change-uses-of-f_dentry.patch
autofs4-change-uses-of-f_dentry.patch
configfs-change-uses-of-f_dentry.patch
cifs-change-uses-of-f_dentry-vfsmnt-to-use-f_path.patch
ecryptfs-change-uses-of-f_dentry.patch
xfs-change-uses-of-f_dentryvfsmnt-to-use-f_path.patch

