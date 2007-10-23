From: akpm@linux-foundation.org
Subject: - fat-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:42 -0700
Message-ID: <200710230647.l9N6lgxV004305@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823AbXJWG7x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:59:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, hirofumi@mail.parknet.co.jp, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     fat: new export ops
has been removed from the -mm tree.  Its filename was
     fat-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 7 insertions(+), 17 deletions(-)

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
