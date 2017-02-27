From: akpm@linux-foundation.org
Subject: [patch 23/78] fs/affs: make affs exportable
Date: Mon, 27 Feb 2017 14:27:49 -0800
Message-ID: <58b4a7e5.ONrrkdIWljijFi8q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751894AbdB0WgE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:36:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, fabf@skynet.be, viro@zeniv.linux.org.uk

From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs: make affs exportable

Add standard functions making AFFS work with NFS.

Functions based on ext4 implementation.  Tested on loop device.

Link: http://lkml.kernel.org/r/20170109191208.6085-4-fabf@skynet.be
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h  |    1 +
 fs/affs/namei.c |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/affs/super.c |    1 +
 3 files changed, 42 insertions(+)

diff -puN fs/affs/affs.h~fs-affs-make-affs-exportable fs/affs/affs.h
--- a/fs/affs/affs.h~fs-affs-make-affs-exportable
+++ a/fs/affs/affs.h
@@ -162,6 +162,7 @@ extern void	affs_free_bitmap(struct supe
 
 /* namei.c */
 
+extern const struct export_operations affs_export_ops;
 extern int	affs_hash_name(struct super_block *sb, const u8 *name, unsigned int len);
 extern struct dentry *affs_lookup(struct inode *dir, struct dentry *dentry, unsigned int);
 extern int	affs_unlink(struct inode *dir, struct dentry *dentry);
diff -puN fs/affs/namei.c~fs-affs-make-affs-exportable fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-make-affs-exportable
+++ a/fs/affs/namei.c
@@ -9,6 +9,7 @@
  */
 
 #include "affs.h"
+#include <linux/exportfs.h>
 
 typedef int (*toupper_t)(int);
 
@@ -465,3 +466,42 @@ done:
 	affs_brelse(bh);
 	return retval;
 }
+
+static struct inode *affs_nfs_get_inode(struct super_block *sb, u64 ino,
+					u32 generation)
+{
+	struct inode *inode;
+
+	if (!affs_validblock(sb, ino))
+		return ERR_PTR(-ESTALE);
+
+	inode = affs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+
+	if (generation && inode->i_generation != generation) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	return inode;
+}
+
+static struct dentry *affs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+					int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type,
+				    affs_nfs_get_inode);
+}
+
+static struct dentry *affs_fh_to_parent(struct super_block *sb, struct fid *fid,
+					int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type,
+				    affs_nfs_get_inode);
+}
+
+const struct export_operations affs_export_ops = {
+	.fh_to_dentry = affs_fh_to_dentry,
+	.fh_to_parent = affs_fh_to_parent,
+};
diff -puN fs/affs/super.c~fs-affs-make-affs-exportable fs/affs/super.c
--- a/fs/affs/super.c~fs-affs-make-affs-exportable
+++ a/fs/affs/super.c
@@ -507,6 +507,7 @@ got_root:
 		return -ENOMEM;
 	}
 
+	sb->s_export_op = &affs_export_ops;
 	pr_debug("s_flags=%lX\n", sb->s_flags);
 	return 0;
 }
_
