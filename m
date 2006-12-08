From: akpm@osdl.org
Subject: - struct-path-make-ecryptfs-a-user-of-struct-path.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:01:33 -0800
Message-ID: <200612082001.kB8K1XI0001877@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56836 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426213AbWLHUBg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:01:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     struct path: make eCryptfs a user of struct path
has been removed from the -mm tree.  Its filename was
     struct-path-make-ecryptfs-a-user-of-struct-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: make eCryptfs a user of struct path
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

Convert eCryptfs dentry-vfsmount pairs in dentry private data to struct
path.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/ecryptfs_kernel.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/ecryptfs/ecryptfs_kernel.h~struct-path-make-ecryptfs-a-user-of-struct-path fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~struct-path-make-ecryptfs-a-user-of-struct-path
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -29,6 +29,7 @@
 #include <keys/user-type.h>
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
+#include <linux/namei.h>
 #include <linux/scatterlist.h>
 
 /* Version verification for shared data structures w/ userspace */
@@ -228,8 +229,7 @@ struct ecryptfs_inode_info {
 /* dentry private data. Each dentry must keep track of a lower
  * vfsmount too. */
 struct ecryptfs_dentry_info {
-	struct dentry *wdi_dentry;
-	struct vfsmount *lower_mnt;
+	struct path lower_path;
 	struct ecryptfs_crypt_stat *crypt_stat;
 };
 
@@ -356,26 +356,26 @@ ecryptfs_set_dentry_private(struct dentr
 static inline struct dentry *
 ecryptfs_dentry_to_lower(struct dentry *dentry)
 {
-	return ((struct ecryptfs_dentry_info *)dentry->d_fsdata)->wdi_dentry;
+	return ((struct ecryptfs_dentry_info *)dentry->d_fsdata)->lower_path.dentry;
 }
 
 static inline void
 ecryptfs_set_dentry_lower(struct dentry *dentry, struct dentry *lower_dentry)
 {
-	((struct ecryptfs_dentry_info *)dentry->d_fsdata)->wdi_dentry =
+	((struct ecryptfs_dentry_info *)dentry->d_fsdata)->lower_path.dentry =
 		lower_dentry;
 }
 
 static inline struct vfsmount *
 ecryptfs_dentry_to_lower_mnt(struct dentry *dentry)
 {
-	return ((struct ecryptfs_dentry_info *)dentry->d_fsdata)->lower_mnt;
+	return ((struct ecryptfs_dentry_info *)dentry->d_fsdata)->lower_path.mnt;
 }
 
 static inline void
 ecryptfs_set_dentry_lower_mnt(struct dentry *dentry, struct vfsmount *lower_mnt)
 {
-	((struct ecryptfs_dentry_info *)dentry->d_fsdata)->lower_mnt =
+	((struct ecryptfs_dentry_info *)dentry->d_fsdata)->lower_path.mnt =
 		lower_mnt;
 }
 
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

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

