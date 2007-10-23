From: akpm@linux-foundation.org
Subject: - ocfs2-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:53 -0700
Message-ID: <200710230647.l9N6lrL2004320@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37948 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbXJWHCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 03:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, mark.fasheh@oracle.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     ocfs2: new export ops
has been removed from the -mm tree.  Its filename was
     ocfs2-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ocfs2: new export ops
From: Christoph Hellwig <hch@lst.de>

OCFS2 has it's own 64bit-firendly filehandle format so we can't use the
generic helpers here.  I'll add a struct for the types later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/export.c |   65 ++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 41 deletions(-)

diff -puN fs/ocfs2/export.c~ocfs2-new-export-ops fs/ocfs2/export.c
--- a/fs/ocfs2/export.c~ocfs2-new-export-ops
+++ a/fs/ocfs2/export.c
@@ -45,9 +45,9 @@ struct ocfs2_inode_handle
 	u32 ih_generation;
 };
 
-static struct dentry *ocfs2_get_dentry(struct super_block *sb, void *vobjp)
+static struct dentry *ocfs2_get_dentry(struct super_block *sb,
+		struct ocfs2_inode_handle *handle)
 {
-	struct ocfs2_inode_handle *handle = vobjp;
 	struct inode *inode;
 	struct dentry *result;
 
@@ -194,54 +194,37 @@ bail:
 	return type;
 }
 
-static struct dentry *ocfs2_decode_fh(struct super_block *sb, u32 *fh_in,
-				      int fh_len, int fileid_type,
-				      int (*acceptable)(void *context,
-						        struct dentry *de),
-				      void *context)
+static struct dentry *ocfs2_fh_to_dentry(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
 {
-	struct ocfs2_inode_handle handle, parent;
-	struct dentry *ret = NULL;
-	__le32 *fh = (__force __le32 *) fh_in;
-
-	mlog_entry("(0x%p, 0x%p, %d, %d, 0x%p, 0x%p)\n",
-		   sb, fh, fh_len, fileid_type, acceptable, context);
+	struct ocfs2_inode_handle handle;
 
-	if (fh_len < 3 || fileid_type > 2)
-		goto bail;
+	if (fh_len < 3 || fh_type > 2)
+		return NULL;
 
-	if (fileid_type == 2) {
-		if (fh_len < 6)
-			goto bail;
-
-		parent.ih_blkno = (u64)le32_to_cpu(fh[3]) << 32;
-		parent.ih_blkno |= (u64)le32_to_cpu(fh[4]);
-		parent.ih_generation = le32_to_cpu(fh[5]);
-
-		mlog(0, "Decoding parent: blkno: %llu, generation: %u\n",
-		     (unsigned long long)parent.ih_blkno,
-		     parent.ih_generation);
-	}
-
-	handle.ih_blkno = (u64)le32_to_cpu(fh[0]) << 32;
-	handle.ih_blkno |= (u64)le32_to_cpu(fh[1]);
-	handle.ih_generation = le32_to_cpu(fh[2]);
+	handle.ih_blkno = (u64)le32_to_cpu(fid->raw[0]) << 32;
+	handle.ih_blkno |= (u64)le32_to_cpu(fid->raw[1]);
+	handle.ih_generation = le32_to_cpu(fid->raw[2]);
+	return ocfs2_get_dentry(sb, &handle);
+}
 
-	mlog(0, "Encoding fh: blkno: %llu, generation: %u\n",
-	     (unsigned long long)handle.ih_blkno, handle.ih_generation);
+static struct dentry *ocfs2_fh_to_parent(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
+{
+	struct ocfs2_inode_handle parent;
 
-	ret = ocfs2_export_ops.find_exported_dentry(sb, &handle, &parent,
-						    acceptable, context);
+	if (fh_type != 2 || fh_len < 6)
+		return NULL;
 
-bail:
-	mlog_exit_ptr(ret);
-	return ret;
+	parent.ih_blkno = (u64)le32_to_cpu(fid->raw[3]) << 32;
+	parent.ih_blkno |= (u64)le32_to_cpu(fid->raw[4]);
+	parent.ih_generation = le32_to_cpu(fid->raw[5]);
+	return ocfs2_get_dentry(sb, &parent);
 }
 
 struct export_operations ocfs2_export_ops = {
-	.decode_fh	= ocfs2_decode_fh,
 	.encode_fh	= ocfs2_encode_fh,
-
+	.fh_to_dentry	= ocfs2_fh_to_dentry,
+	.fh_to_parent	= ocfs2_fh_to_parent,
 	.get_parent	= ocfs2_get_parent,
-	.get_dentry	= ocfs2_get_dentry,
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
