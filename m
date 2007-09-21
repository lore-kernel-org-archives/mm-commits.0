From: akpm@linux-foundation.org
Subject: + reiserfs-new-export-ops.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:27 -0700
Message-ID: <200709210013.l8L0DRfM009785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752194AbXIUASn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 20:18:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, bfields@fieldses.org, jeffm@suse.com, mason@suse.com, neilb@suse.de, vs@namesys.com


The patch titled
     reiserfs: new export ops
has been added to the -mm tree.  Its filename is
     reiserfs-new-export-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1865,12 +1867,10 @@ void reiserfs_delete_inode(struct inode 
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

git-nfs.patch
git-nfsd.patch
partially-fix-up-the-lookup_one_noperm-mess.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft.patch
optimize-x86-page-faults-like-all-other-achitectures-and-kill-notifier-cruft-fix.patch
git-xfs.patch
sysv-convert-to-new-aops.patch
alpha-convert-to-generic-sys_ptrace.patch
kill-declare_mutex_locked.patch
remove-unneded-lock_kernel-in-driver-block-loopc.patch
ufs-move-non-layout-parts-of-ufs_fsh-to-fs-ufs.patch
fix-execute-checking-in-permission.patch
exec-remove-unnecessary-check-for-mnt_noexec.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
unprivileged-mounts-add-user-mounts-to-the-kernel.patch
unprivileged-mounts-allow-unprivileged-umount.patch
unprivileged-mounts-account-user-mounts.patch
unprivileged-mounts-propagate-error-values-from-clone_mnt.patch
unprivileged-mounts-allow-unprivileged-bind-mounts.patch
unprivileged-mounts-put-declaration-of-put_filesystem-in-fsh.patch
unprivileged-mounts-allow-unprivileged-mounts.patch
unprivileged-mounts-allow-unprivileged-fuse-mounts.patch
unprivileged-mounts-propagation-inherit-owner-from-parent.patch
unprivileged-mounts-add-no-submounts-flag.patch
revoke-special-mmap-handling.patch
revoke-core-code.patch
revoke-support-for-ext2-and-ext3.patch
revoke-add-documentation.patch
revoke-wire-up-i386-system-calls.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
ext2-new-export-ops.patch
ext3-new-export-ops.patch
ext4-new-export-ops.patch
efs-new-export-ops.patch
jfs-new-export-ops.patch
ntfs-new-export-ops.patch
xfs-new-export-ops.patch
fat-new-export-ops.patch
isofs-new-export-ops.patch
shmem-new-export-ops.patch
reiserfs-new-export-ops.patch
gfs2-new-export-ops.patch
ocfs2-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
