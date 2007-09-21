From: akpm@linux-foundation.org
Subject: + shmem-new-export-ops.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:25 -0700
Message-ID: <200709210013.l8L0DPlR009782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbXIUASh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 20:18:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, bfields@fieldses.org, hugh@veritas.com, neilb@suse.de


The patch titled
     shmem: new export ops
has been added to the -mm tree.  Its filename is
     shmem-new-export-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 13 insertions(+), 22 deletions(-)

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
