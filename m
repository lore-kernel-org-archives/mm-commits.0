From: akpm@linux-foundation.org
Subject: + ufs-nfs-support.patch added to -mm tree
Date: Mon, 09 Nov 2009 13:43:20 -0800
Message-ID: <200911092143.nA9LhKUF019108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbZKIVna (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 16:43:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@gmail.com, dushistov@mail.ru, hch@lst.de


The patch titled
     ufs: NFS support
has been added to the -mm tree.  Its filename is
     ufs-nfs-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: NFS support
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ufs/super.c~ufs-nfs-support fs/ufs/super.c
--- a/fs/ufs/super.c~ufs-nfs-support
+++ a/fs/ufs/super.c
@@ -66,6 +66,7 @@
  */
 
 
+#include <linux/exportfs.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
 
@@ -96,6 +97,56 @@
 #include "swab.h"
 #include "util.h"
 
+static struct inode *ufs_nfs_get_inode(struct super_block *sb, u64 ino, u32 generation)
+{
+	struct ufs_sb_private_info *uspi = UFS_SB(sb)->s_uspi;
+	struct inode *inode;
+
+	if (ino < UFS_ROOTINO || ino > uspi->s_ncg * uspi->s_ipg)
+		return ERR_PTR(-ESTALE);
+
+	inode = ufs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (generation && inode->i_generation != generation) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+	return inode;
+}
+
+static struct dentry *ufs_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	return generic_fh_to_dentry(sb, fid, fh_len, fh_type, ufs_nfs_get_inode);
+}
+
+static struct dentry *ufs_fh_to_parent(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	return generic_fh_to_parent(sb, fid, fh_len, fh_type, ufs_nfs_get_inode);
+}
+
+static struct dentry *ufs_get_parent(struct dentry *child)
+{
+	struct qstr dot_dot = {
+		.name	= "..",
+		.len	= 2,
+	};
+	ino_t ino;
+
+	ino = ufs_inode_by_name(child->d_inode, &dot_dot);
+	if (!ino)
+		return ERR_PTR(-ENOENT);
+	return d_obtain_alias(ufs_iget(child->d_inode->i_sb, ino));
+}
+
+static const struct export_operations ufs_export_ops = {
+	.fh_to_dentry	= ufs_fh_to_dentry,
+	.fh_to_parent	= ufs_fh_to_parent,
+	.get_parent	= ufs_get_parent,
+};
+
 #ifdef CONFIG_UFS_DEBUG
 /*
  * Print contents of ufs_super_block, useful for debugging
@@ -990,6 +1041,7 @@ magic_found:
 	 * Read ufs_super_block into internal data structures
 	 */
 	sb->s_op = &ufs_super_ops;
+	sb->s_export_op = &ufs_export_ops;
 	sb->dq_op = NULL; /***/
 	sb->s_magic = fs32_to_cpu(sb, usb3->fs_magic);
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
uml-irq-register-race-condition.patch
linux-next.patch
genirq-switch-proc-irq-spurious-to-seq_file.patch
const-constify-remaining-dev_pm_ops.patch
proc-rename-de_get-to-pde_get-and-inline-it.patch
const-constify-remaining-pipe_buf_operations.patch
ufs-pass-qstr-instead-of-dentry-where-necessary-for-nfs.patch
ufs-nfs-support.patch
reiserfs-remove-proc-fs-reiserfs-version.patch
reiserfs-dont-compile-procfso-at-all-if-no-support.patch

