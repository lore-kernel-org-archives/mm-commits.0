From: akpm@linux-foundation.org
Subject: - shmem-new-export-ops.patch removed from -mm tree
Date: Mon, 22 Oct 2007 23:47:47 -0700
Message-ID: <200710230647.l9N6llnU004311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751840AbXJWHB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Oct 2007 03:01:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@lst.de, bfields@fieldses.org, hugh@veritas.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     shmem: new export ops
has been removed from the -mm tree.  Its filename was
     shmem-new-export-ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: shmem: new export ops
From: Christoph Hellwig <hch@lst.de>

I'm not sure what people were thinking when adding support to export tmpfs,
but here's the conversion anyway:

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff -puN mm/shmem.c~shmem-new-export-ops mm/shmem.c
--- a/mm/shmem.c~shmem-new-export-ops
+++ a/mm/shmem.c
@@ -2020,33 +2020,25 @@ static int shmem_match(struct inode *ino
 	return ino->i_ino == inum && fh[0] == ino->i_generation;
 }
 
-static struct dentry *shmem_get_dentry(struct super_block *sb, void *vfh)
+static struct dentry *shmem_fh_to_dentry(struct super_block *sb,
+		struct fid *fid, int fh_len, int fh_type)
 {
-	struct dentry *de = NULL;
 	struct inode *inode;
-	__u32 *fh = vfh;
-	__u64 inum = fh[2];
-	inum = (inum << 32) | fh[1];
+	struct dentry *dentry = NULL;
+	u64 inum = fid->raw[2];
+	inum = (inum << 32) | fid->raw[1];
 
-	inode = ilookup5(sb, (unsigned long)(inum+fh[0]), shmem_match, vfh);
+	if (fh_len < 3)
+		return NULL;
+
+	inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
+			shmem_match, fid->raw);
 	if (inode) {
-		de = d_find_alias(inode);
+		dentry = d_find_alias(inode);
 		iput(inode);
 	}
 
-	return de? de: ERR_PTR(-ESTALE);
-}
-
-static struct dentry *shmem_decode_fh(struct super_block *sb, __u32 *fh,
-		int len, int type,
-		int (*acceptable)(void *context, struct dentry *de),
-		void *context)
-{
-	if (len < 3)
-		return ERR_PTR(-ESTALE);
-
-	return sb->s_export_op->find_exported_dentry(sb, fh, NULL, acceptable,
-							context);
+	return dentry;
 }
 
 static int shmem_encode_fh(struct dentry *dentry, __u32 *fh, int *len,
@@ -2081,9 +2073,8 @@ static int shmem_encode_fh(struct dentry
 
 static struct export_operations shmem_export_ops = {
 	.get_parent     = shmem_get_parent,
-	.get_dentry     = shmem_get_dentry,
 	.encode_fh      = shmem_encode_fh,
-	.decode_fh      = shmem_decode_fh,
+	.fh_to_dentry	= shmem_fh_to_dentry,
 };
 
 static int shmem_parse_options(char *options, int *mode, uid_t *uid,
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
