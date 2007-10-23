From: akpm@linux-foundation.org
Subject: - reiserfs-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:49 -0700
Message-ID: <200710230647.l9N6lngv004314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbXJWHCQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 03:02:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, jeffm@suse.com, mason@suse.com, neilb@suse.de, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: new export ops
has been removed from the -mm tree.  Its filename was
     reiserfs-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: new export ops
From: Christoph Hellwig <hch@lst.de>

Another nice little cleanup by using the new methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Chris Mason <mason@suse.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: "Vladimir V. Saveliev" <vs@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/inode.c         |   62 ++++++++++++++--------------------
 fs/reiserfs/super.c         |    4 +-
 include/linux/reiserfs_fs.h |   12 +++---
 3 files changed, 35 insertions(+), 43 deletions(-)

diff -puN fs/reiserfs/inode.c~reiserfs-new-export-ops fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-new-export-ops
+++ a/fs/reiserfs/inode.c
@@ -1515,19 +1515,20 @@ struct inode *reiserfs_iget(struct super
 	return inode;
 }
 
-struct dentry *reiserfs_get_dentry(struct super_block *sb, void *vobjp)
+static struct dentry *reiserfs_get_dentry(struct super_block *sb,
+	u32 objectid, u32 dir_id, u32 generation)
+
 {
-	__u32 *data = vobjp;
 	struct cpu_key key;
 	struct dentry *result;
 	struct inode *inode;
 
-	key.on_disk_key.k_objectid = data[0];
-	key.on_disk_key.k_dir_id = data[1];
+	key.on_disk_key.k_objectid = objectid;
+	key.on_disk_key.k_dir_id = dir_id;
 	reiserfs_write_lock(sb);
 	inode = reiserfs_iget(sb, &key);
-	if (inode && !IS_ERR(inode) && data[2] != 0 &&
-	    data[2] != inode->i_generation) {
+	if (inode && !IS_ERR(inode) && generation != 0 &&
+	    generation != inode->i_generation) {
 		iput(inode);
 		inode = NULL;
 	}
@@ -1544,14 +1545,9 @@ struct dentry *reiserfs_get_dentry(struc
 	return result;
 }
 
-struct dentry *reiserfs_decode_fh(struct super_block *sb, __u32 * data,
-				  int len, int fhtype,
-				  int (*acceptable) (void *contect,
-						     struct dentry * de),
-				  void *context)
+struct dentry *reiserfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
 {
-	__u32 obj[3], parent[3];
-
 	/* fhtype happens to reflect the number of u32s encoded.
 	 * due to a bug in earlier code, fhtype might indicate there
 	 * are more u32s then actually fitted.
@@ -1564,32 +1560,28 @@ struct dentry *reiserfs_decode_fh(struct
 	 *   6 - as above plus generation of directory
 	 * 6 does not fit in NFSv2 handles
 	 */
-	if (fhtype > len) {
-		if (fhtype != 6 || len != 5)
+	if (fh_type > fh_len) {
+		if (fh_type != 6 || fh_len != 5)
 			reiserfs_warning(sb,
-					 "nfsd/reiserfs, fhtype=%d, len=%d - odd",
-					 fhtype, len);
-		fhtype = 5;
+				"nfsd/reiserfs, fhtype=%d, len=%d - odd",
+				fh_type, fh_len);
+		fh_type = 5;
 	}
 
-	obj[0] = data[0];
-	obj[1] = data[1];
-	if (fhtype == 3 || fhtype >= 5)
-		obj[2] = data[2];
-	else
-		obj[2] = 0;	/* generation number */
+	return reiserfs_get_dentry(sb, fid->raw[0], fid->raw[1],
+		(fh_type == 3 || fh_type >= 5) ? fid->raw[2] : 0);
+}
 
-	if (fhtype >= 4) {
-		parent[0] = data[fhtype >= 5 ? 3 : 2];
-		parent[1] = data[fhtype >= 5 ? 4 : 3];
-		if (fhtype == 6)
-			parent[2] = data[5];
-		else
-			parent[2] = 0;
-	}
-	return sb->s_export_op->find_exported_dentry(sb, obj,
-						     fhtype < 4 ? NULL : parent,
-						     acceptable, context);
+struct dentry *reiserfs_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	if (fh_type < 4)
+		return NULL;
+
+	return reiserfs_get_dentry(sb,
+		(fh_type >= 5) ? fid->raw[3] : fid->raw[2],
+		(fh_type >= 5) ? fid->raw[4] : fid->raw[3],
+		(fh_type == 6) ? fid->raw[5] : 0);
 }
 
 int reiserfs_encode_fh(struct dentry *dentry, __u32 * data, int *lenp,
diff -puN fs/reiserfs/super.c~reiserfs-new-export-ops fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~reiserfs-new-export-ops
+++ a/fs/reiserfs/super.c
@@ -663,9 +663,9 @@ static struct quotactl_ops reiserfs_qctl
 
 static struct export_operations reiserfs_export_ops = {
 	.encode_fh = reiserfs_encode_fh,
-	.decode_fh = reiserfs_decode_fh,
+	.fh_to_dentry = reiserfs_fh_to_dentry,
+	.fh_to_parent = reiserfs_fh_to_parent,
 	.get_parent = reiserfs_get_parent,
-	.get_dentry = reiserfs_get_dentry,
 };
 
 /* this struct is used in reiserfs_getopt () for containing the value for those
diff -puN include/linux/reiserfs_fs.h~reiserfs-new-export-ops include/linux/reiserfs_fs.h
--- a/include/linux/reiserfs_fs.h~reiserfs-new-export-ops
+++ a/include/linux/reiserfs_fs.h
@@ -28,6 +28,8 @@
 #include <linux/reiserfs_fs_sb.h>
 #endif
 
+struct fid;
+
 /*
  *  include/linux/reiser_fs.h
  *
@@ -1877,12 +1879,10 @@ void reiserfs_delete_inode(struct inode 
 int reiserfs_write_inode(struct inode *inode, int);
 int reiserfs_get_block(struct inode *inode, sector_t block,
 		       struct buffer_head *bh_result, int create);
-struct dentry *reiserfs_get_dentry(struct super_block *, void *);
-struct dentry *reiserfs_decode_fh(struct super_block *sb, __u32 * data,
-				  int len, int fhtype,
-				  int (*acceptable) (void *contect,
-						     struct dentry * de),
-				  void *context);
+struct dentry *reiserfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				     int fh_len, int fh_type);
+struct dentry *reiserfs_fh_to_parent(struct super_block *sb, struct fid *fid,
+				     int fh_len, int fh_type);
 int reiserfs_encode_fh(struct dentry *dentry, __u32 * data, int *lenp,
 		       int connectable);
 
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
