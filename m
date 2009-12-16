From: akpm@linux-foundation.org
Subject: [merged] ufs-nfs-support.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:36:59 -0800
Message-ID: <200912162036.nBGKaxFx013278@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51776 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935480AbZLPUhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:37:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, dushistov@mail.ru, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     ufs: NFS support
has been removed from the -mm tree.  Its filename was
     ufs-nfs-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ufs: NFS support
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/super.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

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
linux-next.patch
asus_acpi-convert-to-seq_file.patch
toshiba_acpi-convert-to-seq_file.patch
thinkpad_acpi-convert-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file.patch
arm-convert-proc-cpu-aligment-to-seq_file-fix.patch
iseries-convert-to-proc_fops.patch
proc_fops-convert-av7110.patch
proc_fops-convert-drivers-isdn-to-seq_file.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix.patch
proc_fops-convert-drivers-isdn-to-seq_file-fix2.patch
mpt-fusion-convert-to-seq_file.patch
uml-irq-register-race-condition.patch

