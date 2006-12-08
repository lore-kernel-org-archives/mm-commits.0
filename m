From: akpm@osdl.org
Subject: - ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix.patch removed from -mm tree
Date: Fri, 08 Dec 2006 00:48:56 -0800
Message-ID: <200612080848.kB88muMe013874@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425198AbWLHItW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:49:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@cs.sunysb.edu, mhalcrow@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy fix
has been removed from the -mm tree.  Its filename was
     ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix.patch

This patch was dropped because it was folded into ecryptfs-use-fsstacks-generic-copy-inode-attr.patch

------------------------------------------------------
Subject: ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy fix
From: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>

The fsstack tidy patch broke eCryptfs. This patch makes eCryptfs compile
again.

Signed-off-by: Josef "Jeff" Sipek <jsipek@cs.sunysb.edu>
Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ecryptfs/dentry.c |    2 +-
 fs/ecryptfs/inode.c  |    6 +++---
 fs/ecryptfs/main.c   |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/ecryptfs/dentry.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix fs/ecryptfs/dentry.c
--- a/fs/ecryptfs/dentry.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix
+++ a/fs/ecryptfs/dentry.c
@@ -61,7 +61,7 @@ static int ecryptfs_d_revalidate(struct 
 		struct inode *lower_inode =
 			ecryptfs_inode_to_lower(dentry->d_inode);
 
-		ecryptfs_copy_attr_all(dentry->d_inode, lower_inode);
+		fsstack_copy_attr_all(dentry->d_inode, lower_inode);
 	}
 out:
 	return rc;
diff -puN fs/ecryptfs/inode.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix fs/ecryptfs/inode.c
--- a/fs/ecryptfs/inode.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix
+++ a/fs/ecryptfs/inode.c
@@ -589,9 +589,9 @@ ecryptfs_rename(struct inode *old_dir, s
 			lower_new_dir_dentry->d_inode, lower_new_dentry);
 	if (rc)
 		goto out_lock;
-	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode);
+	fsstack_copy_attr_all(new_dir, lower_new_dir_dentry->d_inode, NULL);
 	if (new_dir != old_dir)
-		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode);
+		fsstack_copy_attr_all(old_dir, lower_old_dir_dentry->d_inode, NULL);
 out_lock:
 	unlock_rename(lower_old_dir_dentry, lower_new_dir_dentry);
 	dput(lower_new_dentry->d_parent);
@@ -878,7 +878,7 @@ static int ecryptfs_setattr(struct dentr
 	}
 	rc = notify_change(lower_dentry, ia);
 out:
-	fsstack_copy_attr_all(inode, lower_inode);
+	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	return rc;
 }
 
diff -puN fs/ecryptfs/main.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix fs/ecryptfs/main.c
--- a/fs/ecryptfs/main.c~ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix
+++ a/fs/ecryptfs/main.c
@@ -113,7 +113,7 @@ int ecryptfs_interpose(struct dentry *lo
 		d_add(dentry, inode);
 	else
 		d_instantiate(dentry, inode);
-	fsstack_copy_attr_all(inode, lower_inode);
+	fsstack_copy_attr_all(inode, lower_inode, NULL);
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
_

Patches currently in -mm which might be from jsipek@cs.sunysb.edu are

fsstack-introduce-fsstack_copy_attrinode_.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-fix.patch
ecryptfs-use-fsstacks-generic-copy-inode-attr-tidy-fix-up-ecryptfss-fsstack-usage.patch
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

