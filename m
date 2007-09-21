From: akpm@linux-foundation.org
Subject: + jfs-new-export-ops.patch added to -mm tree
Date: Thu, 20 Sep 2007 17:13:15 -0700
Message-ID: <200709210013.l8L0DFk5009767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272AbXIUATW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 20:19:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hch@lst.de, bfields@fieldses.org, neilb@suse.de, shaggy@austin.ibm.com


The patch titled
     jfs: new export ops
has been added to the -mm tree.  Its filename is
     jfs-new-export-ops.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: jfs: new export ops
From: Christoph Hellwig <hch@lst.de>

Trivial switch over to the new generic helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Dave Kleikamp <shaggy@austin.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/jfs_inode.h |    7 ++++++-
 fs/jfs/namei.c     |   35 +++++++++++++++++++----------------
 fs/jfs/super.c     |    3 ++-
 3 files changed, 27 insertions(+), 18 deletions(-)

diff -puN fs/jfs/jfs_inode.h~jfs-new-export-ops fs/jfs/jfs_inode.h
--- a/fs/jfs/jfs_inode.h~jfs-new-export-ops
+++ a/fs/jfs/jfs_inode.h
@@ -18,6 +18,8 @@
 #ifndef	_H_JFS_INODE
 #define _H_JFS_INODE
 
+struct fid;
+
 extern struct inode *ialloc(struct inode *, umode_t);
 extern int jfs_fsync(struct file *, struct dentry *, int);
 extern int jfs_ioctl(struct inode *, struct file *,
@@ -32,7 +34,10 @@ extern void jfs_truncate_nolock(struct i
 extern void jfs_free_zero_link(struct inode *);
 extern struct dentry *jfs_get_parent(struct dentry *dentry);
 extern void jfs_get_inode_flags(struct jfs_inode_info *);
-extern struct dentry *jfs_get_dentry(struct super_block *sb, void *vobjp);
+extern struct dentry *jfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+	int fh_len, int fh_type);
+extern struct dentry *jfs_fh_to_parent(struct super_block *sb, struct fid *fid,
+	int fh_len, int fh_type);
 extern void jfs_set_inode_flags(struct inode *);
 extern int jfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
diff -puN fs/jfs/namei.c~jfs-new-export-ops fs/jfs/namei.c
--- a/fs/jfs/namei.c~jfs-new-export-ops
+++ a/fs/jfs/namei.c
@@ -20,6 +20,7 @@
 #include <linux/fs.h>
 #include <linux/ctype.h>
 #include <linux/quotaops.h>
+#include <linux/exportfs.h>
 #include "jfs_incore.h"
 #include "jfs_superblock.h"
 #include "jfs_inode.h"
@@ -1477,13 +1478,10 @@ static struct dentry *jfs_lookup(struct 
 	return dentry;
 }
 
-struct dentry *jfs_get_dentry(struct super_block *sb, void *vobjp)
+static struct inode *jfs_nfs_get_inode(struct super_block *sb,
+		u64 ino, u32 generation)
 {
-	__u32 *objp = vobjp;
-	unsigned long ino = objp[0];
-	__u32 generation = objp[1];
 	struct inode *inode;
-	struct dentry *result;
 
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
@@ -1493,20 +1491,25 @@ struct dentry *jfs_get_dentry(struct sup
 
 	if (is_bad_inode(inode) ||
 	    (generation && inode->i_generation != generation)) {
-	    	result = ERR_PTR(-ESTALE);
-		goto out_iput;
+		iput(inode);
+		return ERR_PTR(-ESTALE);
 	}
 
-	result = d_alloc_anon(inode);
-	if (!result) {
-		result = ERR_PTR(-ENOMEM);
-		goto out_iput;
-	}
-	return result;
+	return inode;
+}
 
- out_iput:
-	iput(inode);
-	return result;
+struct dentry *jfs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    jfs_nfs_get_inode);
+}
+
+struct dentry *jfs_fh_to_parent(struct super_block *sb, struct fid *fid,
+		int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    jfs_nfs_get_inode);
 }
 
 struct dentry *jfs_get_parent(struct dentry *dentry)
diff -puN fs/jfs/super.c~jfs-new-export-ops fs/jfs/super.c
--- a/fs/jfs/super.c~jfs-new-export-ops
+++ a/fs/jfs/super.c
@@ -738,7 +738,8 @@ static const struct super_operations jfs
 };
 
 static struct export_operations jfs_export_operations = {
-	.get_dentry	= jfs_get_dentry,
+	.fh_to_dentry	= jfs_fh_to_dentry,
+	.fh_to_parent	= jfs_fh_to_parent,
 	.get_parent	= jfs_get_parent,
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
