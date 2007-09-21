From: akpm@linux-foundation.org
Subject: + ntfs-new-export-ops.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:17 -0700
Message-ID: <200709210013.l8L0DHUi009770@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46499 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129AbXIUAO2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 20:14:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, aia21@cantab.net, bfields@fieldses.org, neilb@suse.de


The patch titled
     ntfs: new export ops
has been added to the -mm tree.  Its filename is
     ntfs-new-export-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ntfs: new export ops
From: Christoph Hellwig <hch@lst.de>

Trivial switch over to the new generic helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/namei.c |   77 +++++++++++++++++-----------------------------
 1 files changed, 29 insertions(+), 48 deletions(-)

diff -puN fs/ntfs/namei.c~ntfs-new-export-ops fs/ntfs/namei.c
--- a/fs/ntfs/namei.c~ntfs-new-export-ops
+++ a/fs/ntfs/namei.c
@@ -450,58 +450,40 @@ try_next:
 	return parent_dent;
 }
 
-/**
- * ntfs_get_dentry - find a dentry for the inode from a file handle sub-fragment
- * @sb:		super block identifying the mounted ntfs volume
- * @fh:		the file handle sub-fragment
- *
- * Find a dentry for the inode given a file handle sub-fragment.  This function
- * is called from fs/exportfs/expfs.c::find_exported_dentry() which in turn is
- * called from the default ->decode_fh() which is export_decode_fh() in the
- * same file.  The code is closely based on the default ->get_dentry() helper
- * fs/exportfs/expfs.c::get_object().
- *
- * The @fh contains two 32-bit unsigned values, the first one is the inode
- * number and the second one is the inode generation.
- *
- * Return the dentry on success or the error code on error (IS_ERR() is true).
- */
-static struct dentry *ntfs_get_dentry(struct super_block *sb, void *fh)
+static struct inode *ntfs_nfs_get_inode(struct super_block *sb,
+		u64 ino, u32 generation)
 {
-	struct inode *vi;
-	struct dentry *dent;
-	unsigned long ino = ((u32 *)fh)[0];
-	u32 gen = ((u32 *)fh)[1];
-
-	ntfs_debug("Entering for inode 0x%lx, generation 0x%x.", ino, gen);
-	vi = ntfs_iget(sb, ino);
-	if (IS_ERR(vi)) {
-		ntfs_error(sb, "Failed to get inode 0x%lx.", ino);
-		return (struct dentry *)vi;
-	}
-	if (unlikely(is_bad_inode(vi) || vi->i_generation != gen)) {
-		/* We didn't find the right inode. */
-		ntfs_error(sb, "Inode 0x%lx, bad count: %d %d or version 0x%x "
-				"0x%x.", vi->i_ino, vi->i_nlink,
-				atomic_read(&vi->i_count), vi->i_generation,
-				gen);
-		iput(vi);
-		return ERR_PTR(-ESTALE);
-	}
-	/* Now find a dentry.  If possible, get a well-connected one. */
-	dent = d_alloc_anon(vi);
-	if (unlikely(!dent)) {
-		iput(vi);
-		return ERR_PTR(-ENOMEM);
+	struct inode *inode;
+
+	inode = ntfs_iget(sb, ino);
+	if (!IS_ERR(inode)) {
+		if (is_bad_inode(inode) || inode->i_generation != generation) {
+			iput(inode);
+			inode = ERR_PTR(-ESTALE);
+		}
 	}
-	ntfs_debug("Done for inode 0x%lx, generation 0x%x.", ino, gen);
-	return dent;
+
+	return inode;
+}
+
+static struct dentry *ntfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    ntfs_nfs_get_inode);
+}
+
+static struct dentry *ntfs_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    ntfs_nfs_get_inode);
 }
 
 /**
  * Export operations allowing NFS exporting of mounted NTFS partitions.
  *
- * We use the default ->decode_fh() and ->encode_fh() for now.  Note that they
+ * We use the default ->encode_fh() for now.  Note that they
  * use 32 bits to store the inode number which is an unsigned long so on 64-bit
  * architectures is usually 64 bits so it would all fail horribly on huge
  * volumes.  I guess we need to define our own encode and decode fh functions
@@ -520,7 +502,6 @@ static struct dentry *ntfs_get_dentry(st
 struct export_operations ntfs_export_ops = {
 	.get_parent	= ntfs_get_parent,	/* Find the parent of a given
 						   directory. */
-	.get_dentry	= ntfs_get_dentry,	/* Find a dentry for the inode
-						   given a file handle
-						   sub-fragment. */
+	.fh_to_dentry	= ntfs_fh_to_dentry,
+	.fh_to_parent	= ntfs_fh_to_parent,
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
