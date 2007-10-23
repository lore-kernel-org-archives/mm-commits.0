From: akpm@linux-foundation.org
Subject: - efs-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:32 -0700
Message-ID: <200710230647.l9N6lWdV004290@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51369 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbXJWG7X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:59:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     efs: new export ops
has been removed from the -mm tree.  Its filename was
     efs-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: efs: new export ops
From: Christoph Hellwig <hch@lst.de>

Trivial switch over to the new generic helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/namei.c         |   36 ++++++++++++++++++++----------------
 fs/efs/super.c         |    3 ++-
 include/linux/efs_fs.h |    6 +++++-
 3 files changed, 27 insertions(+), 18 deletions(-)

diff -puN fs/efs/namei.c~efs-new-export-ops fs/efs/namei.c
--- a/fs/efs/namei.c~efs-new-export-ops
+++ a/fs/efs/namei.c
@@ -10,6 +10,8 @@
 #include <linux/string.h>
 #include <linux/efs_fs.h>
 #include <linux/smp_lock.h>
+#include <linux/exportfs.h>
+
 
 static efs_ino_t efs_find_entry(struct inode *inode, const char *name, int len) {
 	struct buffer_head *bh;
@@ -75,13 +77,10 @@ struct dentry *efs_lookup(struct inode *
 	return NULL;
 }
 
-struct dentry *efs_get_dentry(struct super_block *sb, void *vobjp)
+static struct inode *efs_nfs_get_inode(struct super_block *sb, u64 ino,
+		u32 generation)
 {
-	__u32 *objp = vobjp;
-	unsigned long ino = objp[0];
-	__u32 generation = objp[1];
 	struct inode *inode;
-	struct dentry *result;
 
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
@@ -91,20 +90,25 @@ struct dentry *efs_get_dentry(struct sup
 
 	if (is_bad_inode(inode) ||
 	    (generation && inode->i_generation != generation)) {
-	    	result = ERR_PTR(-ESTALE);
-		goto out_iput;
+		iput(inode);
+		return ERR_PTR(-ESTALE);
 	}
 
-	result = d_alloc_anon(inode);
-	if (!result) {
-		result = ERR_PTR(-ENOMEM);
-		goto out_iput;
-	}
-	return result;
+	return inode;
+}
 
- out_iput:
-	iput(inode);
-	return result;
+struct dentry *efs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    efs_nfs_get_inode);
+}
+
+struct dentry *efs_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    efs_nfs_get_inode);
 }
 
 struct dentry *efs_get_parent(struct dentry *child)
diff -puN fs/efs/super.c~efs-new-export-ops fs/efs/super.c
--- a/fs/efs/super.c~efs-new-export-ops
+++ a/fs/efs/super.c
@@ -114,7 +114,8 @@ static const struct super_operations efs
 };
 
 static struct export_operations efs_export_ops = {
-	.get_dentry	= efs_get_dentry,
+	.fh_to_dentry	= efs_fh_to_dentry,
+	.fh_to_parent	= efs_fh_to_parent,
 	.get_parent	= efs_get_parent,
 };
 
diff -puN include/linux/efs_fs.h~efs-new-export-ops include/linux/efs_fs.h
--- a/include/linux/efs_fs.h~efs-new-export-ops
+++ a/include/linux/efs_fs.h
@@ -35,6 +35,7 @@ static inline struct efs_sb_info *SUPER_
 }
 
 struct statfs;
+struct fid;
 
 extern const struct inode_operations efs_dir_inode_operations;
 extern const struct file_operations efs_dir_operations;
@@ -45,7 +46,10 @@ extern efs_block_t efs_map_block(struct 
 extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
 extern struct dentry *efs_lookup(struct inode *, struct dentry *, struct nameidata *);
-extern struct dentry *efs_get_dentry(struct super_block *sb, void *vobjp);
+extern struct dentry *efs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type);
+extern struct dentry *efs_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type);
 extern struct dentry *efs_get_parent(struct dentry *);
 extern int efs_bmap(struct inode *, int);
 
_

Patches currently in -mm which might be from hch@lst.de are

origin.patch
git-unionfs.patch
git-xfs.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
r-o-bind-mounts-stub-functions.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes-touch-command-causes-oops.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
r-o-bind-mounts-honor-r-w-changes-at-do_remount-time.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
make-__d_path-to-take-a-struct-path-argument.patch
use-struct-path-argument-in-proc_get_link.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
introduce-path_put-unionfs.patch
introduce-path_get-unionfs.patch
