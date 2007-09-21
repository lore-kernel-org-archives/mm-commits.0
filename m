From: akpm@linux-foundation.org
Subject: + isofs-new-export-ops.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:23 -0700
Message-ID: <200709210013.l8L0DNnF009779@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbXIUASc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 20:18:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, bfields@fieldses.org, neilb@suse.de


The patch titled
     isofs: new export ops
has been added to the -mm tree.  Its filename is
     isofs-new-export-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isofs: new export ops
From: Christoph Hellwig <hch@lst.de>

Nice little cleanup by consolidating things a little and using a structure for
the special file handle format.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/export.c |   67 +++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 38 deletions(-)

diff -puN fs/isofs/export.c~isofs-new-export-ops fs/isofs/export.c
--- a/fs/isofs/export.c~isofs-new-export-ops
+++ a/fs/isofs/export.c
@@ -42,16 +42,6 @@ isofs_export_iget(struct super_block *sb
 	return result;
 }
 
-static struct dentry *
-isofs_export_get_dentry(struct super_block *sb, void *vobjp)
-{
-	__u32 *objp = vobjp;
-	unsigned long block = objp[0];
-	unsigned long offset = objp[1];
-	__u32 generation = objp[2];
-	return isofs_export_iget(sb, block, offset, generation);
-}
-
 /* This function is surprisingly simple.  The trick is understanding
  * that "child" is always a directory. So, to find its parent, you
  * simply need to find its ".." entry, normalize its block and offset,
@@ -182,43 +172,44 @@ isofs_export_encode_fh(struct dentry *de
 	return type;
 }
 
+struct isofs_fid {
+	u32 block;
+	u16 offset;
+	u16 parent_offset;
+	u32 generation;
+	u32 parent_block;
+	u32 parent_generation;
+};
 
-static struct dentry *
-isofs_export_decode_fh(struct super_block *sb,
-		       __u32 *fh32,
-		       int fh_len,
-		       int fileid_type,
-		       int (*acceptable)(void *context, struct dentry *de),
-		       void *context)
+static struct dentry *isofs_fh_to_dentry(struct super_block *sb,
+	struct fid *fid, int fh_len, int fh_type)
 {
-	__u16 *fh16 = (__u16*)fh32;
-	__u32 child[3];   /* The child is what triggered all this. */
-	__u32 parent[3];  /* The parent is just along for the ride. */
+	struct isofs_fid *ifid = (struct isofs_fid *)fid;
 
-	if (fh_len < 3 || fileid_type > 2)
+	if (fh_len < 3 || fh_type > 2)
 		return NULL;
 
-	child[0] = fh32[0];
-	child[1] = fh16[2];  /* fh16 [sic] */
-	child[2] = fh32[2];
-
-	parent[0] = 0;
-	parent[1] = 0;
-	parent[2] = 0;
-	if (fileid_type == 2) {
-		if (fh_len > 2) parent[0] = fh32[3];
-		parent[1] = fh16[3];  /* fh16 [sic] */
-		if (fh_len > 4) parent[2] = fh32[4];
-	}
-
-	return sb->s_export_op->find_exported_dentry(sb, child, parent,
-						     acceptable, context);
+	return isofs_export_iget(sb, ifid->block, ifid->offset,
+			ifid->generation);
 }
 
+static struct dentry *isofs_fh_to_parent(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	struct isofs_fid *ifid = (struct isofs_fid *)fid;
+
+	if (fh_type != 2)
+		return NULL;
+
+	return isofs_export_iget(sb,
+			fh_len > 2 ? ifid->parent_block : 0,
+			ifid->parent_offset,
+			fh_len > 4 ? ifid->parent_generation : 0);
+}
 
 struct export_operations isofs_export_ops = {
-	.decode_fh	= isofs_export_decode_fh,
 	.encode_fh	= isofs_export_encode_fh,
-	.get_dentry	= isofs_export_get_dentry,
+	.fh_to_dentry	= isofs_fh_to_dentry,
+	.fh_to_parent	= isofs_fh_to_parent,
 	.get_parent     = isofs_export_get_parent,
 };
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
