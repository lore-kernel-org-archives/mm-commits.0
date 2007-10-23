From: akpm@linux-foundation.org
Subject: - isofs-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:44 -0700
Message-ID: <200710230647.l9N6liJ5004308@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53715 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752164AbXJWG6v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 02:58:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     isofs: new export ops
has been removed from the -mm tree.  Its filename was
     isofs-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 29 insertions(+), 38 deletions(-)

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
