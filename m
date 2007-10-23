From: akpm@linux-foundation.org
Subject: - gfs2-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:51 -0700
Message-ID: <200710230647.l9N6lpEA004317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230AbXJWHCL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 03:02:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, neilb@suse.de, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     gfs2: new export ops
has been removed from the -mm tree.  Its filename was
     gfs2-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gfs2: new export ops
From: Christoph Hellwig <hch@lst.de>

Convert gfs2 to the new ops.  Uses a similar structure to the generic helpers,
but gfs2 has it's own file handle formats.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/ops_export.c |   81 +++++++++++++++++++++--------------------
 1 file changed, 43 insertions(+), 38 deletions(-)

diff -puN fs/gfs2/ops_export.c~gfs2-new-export-ops fs/gfs2/ops_export.c
--- a/fs/gfs2/ops_export.c~gfs2-new-export-ops
+++ a/fs/gfs2/ops_export.c
@@ -31,40 +31,6 @@
 #define GFS2_LARGE_FH_SIZE 8
 #define GFS2_OLD_FH_SIZE 10
 
-static struct dentry *gfs2_decode_fh(struct super_block *sb,
-				     __u32 *p,
-				     int fh_len,
-				     int fh_type,
-				     int (*acceptable)(void *context,
-						       struct dentry *dentry),
-				     void *context)
-{
-	__be32 *fh = (__force __be32 *)p;
-	struct gfs2_inum_host inum, parent;
-
-	memset(&parent, 0, sizeof(struct gfs2_inum));
-
-	switch (fh_len) {
-	case GFS2_LARGE_FH_SIZE:
-	case GFS2_OLD_FH_SIZE:
-		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
-		parent.no_formal_ino |= be32_to_cpu(fh[5]);
-		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
-		parent.no_addr |= be32_to_cpu(fh[7]);
-	case GFS2_SMALL_FH_SIZE:
-		inum.no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
-		inum.no_formal_ino |= be32_to_cpu(fh[1]);
-		inum.no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
-		inum.no_addr |= be32_to_cpu(fh[3]);
-		break;
-	default:
-		return NULL;
-	}
-
-	return gfs2_export_ops.find_exported_dentry(sb, &inum, &parent,
-						    acceptable, context);
-}
-
 static int gfs2_encode_fh(struct dentry *dentry, __u32 *p, int *len,
 			  int connectable)
 {
@@ -189,10 +155,10 @@ static struct dentry *gfs2_get_parent(st
 	return dentry;
 }
 
-static struct dentry *gfs2_get_dentry(struct super_block *sb, void *inum_obj)
+static struct dentry *gfs2_get_dentry(struct super_block *sb,
+		struct gfs2_inum_host *inum)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
-	struct gfs2_inum_host *inum = inum_obj;
 	struct gfs2_holder i_gh, ri_gh, rgd_gh;
 	struct gfs2_rgrpd *rgd;
 	struct inode *inode;
@@ -289,11 +255,50 @@ fail:
 	return ERR_PTR(error);
 }
 
+static struct dentry *gfs2_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	struct gfs2_inum_host this;
+	__be32 *fh = (__force __be32 *)fid->raw;
+
+	switch (fh_type) {
+	case GFS2_SMALL_FH_SIZE:
+	case GFS2_LARGE_FH_SIZE:
+	case GFS2_OLD_FH_SIZE:
+		this.no_formal_ino = ((u64)be32_to_cpu(fh[0])) << 32;
+		this.no_formal_ino |= be32_to_cpu(fh[1]);
+		this.no_addr = ((u64)be32_to_cpu(fh[2])) << 32;
+		this.no_addr |= be32_to_cpu(fh[3]);
+		return gfs2_get_dentry(sb, &this);
+	default:
+		return NULL;
+	}
+}
+
+static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	struct gfs2_inum_host parent;
+	__be32 *fh = (__force __be32 *)fid->raw;
+
+	switch (fh_type) {
+	case GFS2_LARGE_FH_SIZE:
+	case GFS2_OLD_FH_SIZE:
+		parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
+		parent.no_formal_ino |= be32_to_cpu(fh[5]);
+		parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
+		parent.no_addr |= be32_to_cpu(fh[7]);
+		return gfs2_get_dentry(sb, &parent);
+	default:
+		return NULL;
+	}
+}
+
 struct export_operations gfs2_export_ops = {
-	.decode_fh = gfs2_decode_fh,
 	.encode_fh = gfs2_encode_fh,
+	.fh_to_dentry = gfs2_fh_to_dentry,
+	.fh_to_parent = gfs2_fh_to_parent,
 	.get_name = gfs2_get_name,
 	.get_parent = gfs2_get_parent,
-	.get_dentry = gfs2_get_dentry,
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
