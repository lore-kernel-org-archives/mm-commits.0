From: akpm@linux-foundation.org
Subject: + fat-new-export-ops.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:21 -0700
Message-ID: <200709210013.l8L0DLFV009776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37105 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbXIUASe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 20:18:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, neilb@suse.de


The patch titled
     fat: new export ops
has been added to the -mm tree.  Its filename is
     fat-new-export-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fat: new export ops
From: Christoph Hellwig <hch@lst.de>

Very little changes here, fat had a mostly no op decode_fh before and does not
store any parent information.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/inode.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff -puN fs/fat/inode.c~fat-new-export-ops fs/fat/inode.c
--- a/fs/fat/inode.c~fat-new-export-ops
+++ a/fs/fat/inode.c
@@ -653,24 +653,15 @@ static const struct super_operations fat
  * of i_logstart is used to store the directory entry offset.
  */
 
-static struct dentry *
-fat_decode_fh(struct super_block *sb, __u32 *fh, int len, int fhtype,
-	      int (*acceptable)(void *context, struct dentry *de),
-	      void *context)
-{
-	if (fhtype != 3)
-		return ERR_PTR(-ESTALE);
-	if (len < 5)
-		return ERR_PTR(-ESTALE);
-
-	return sb->s_export_op->find_exported_dentry(sb, fh, NULL, acceptable, context);
-}
-
-static struct dentry *fat_get_dentry(struct super_block *sb, void *inump)
+static struct dentry *fat_fh_to_dentry(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
 {
 	struct inode *inode = NULL;
 	struct dentry *result;
-	__u32 *fh = inump;
+	u32 *fh = fid->raw;
+
+	if (fh_len < 5 || fh_type != 3)
+		return NULL;
 
 	inode = iget(sb, fh[0]);
 	if (!inode || is_bad_inode(inode) || inode->i_generation != fh[1]) {
@@ -784,9 +775,8 @@ out:
 }
 
 static struct export_operations fat_export_ops = {
-	.decode_fh	= fat_decode_fh,
 	.encode_fh	= fat_encode_fh,
-	.get_dentry	= fat_get_dentry,
+	.fh_to_dentry	= fat_fh_to_dentry,
 	.get_parent	= fat_get_parent,
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
