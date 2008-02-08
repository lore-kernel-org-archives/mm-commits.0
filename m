From: akpm@linux-foundation.org
Subject: - iget-stop-openpromfs-from-using-iget-and.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:12 -0800
Message-ID: <200802080807.m1887r8B014599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932918AbYBHIUs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, davem@davemloft.net, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop OPENPROMFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-openpromfs-from-using-iget-and.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop OPENPROMFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the OPENPROMFS filesystem from using iget() and read_inode().  Replace
openpromfs_read_inode() with openpromfs_iget(), and call that instead of
iget().  openpromfs_iget() then uses iget_locked() directly and returns a
proper error code instead of an inode in the event of an error.

openpromfs_fill_super() returns any error incurred when getting the root inode
instead of ENOMEM (not that it currently incurs any other error).

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/openpromfs/inode.c |   45 ++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff -puN fs/openpromfs/inode.c~iget-stop-openpromfs-from-using-iget-and fs/openpromfs/inode.c
--- a/fs/openpromfs/inode.c~iget-stop-openpromfs-from-using-iget-and
+++ a/fs/openpromfs/inode.c
@@ -38,6 +38,8 @@ struct op_inode_info {
 	union op_inode_data	u;
 };
 
+static struct inode *openprom_iget(struct super_block *sb, ino_t ino);
+
 static inline struct op_inode_info *OP_I(struct inode *inode)
 {
 	return container_of(inode, struct op_inode_info, vfs_inode);
@@ -226,10 +228,10 @@ static struct dentry *openpromfs_lookup(
 	return ERR_PTR(-ENOENT);
 
 found:
-	inode = iget(dir->i_sb, ino);
+	inode = openprom_iget(dir->i_sb, ino);
 	mutex_unlock(&op_mutex);
-	if (!inode)
-		return ERR_PTR(-EINVAL);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 	ent_oi = OP_I(inode);
 	ent_oi->type = ent_type;
 	ent_oi->u = ent_data;
@@ -348,14 +350,23 @@ static void openprom_destroy_inode(struc
 	kmem_cache_free(op_inode_cachep, OP_I(inode));
 }
 
-static void openprom_read_inode(struct inode * inode)
+static struct inode *openprom_iget(struct super_block *sb, ino_t ino)
 {
-	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
-	if (inode->i_ino == OPENPROM_ROOT_INO) {
-		inode->i_op = &openprom_inode_operations;
-		inode->i_fop = &openprom_operations;
-		inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (inode->i_state & I_NEW) {
+		inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
+		if (inode->i_ino == OPENPROM_ROOT_INO) {
+			inode->i_op = &openprom_inode_operations;
+			inode->i_fop = &openprom_operations;
+			inode->i_mode = S_IFDIR | S_IRUGO | S_IXUGO;
+		}
+		unlock_new_inode(inode);
 	}
+	return inode;
 }
 
 static int openprom_remount(struct super_block *sb, int *flags, char *data)
@@ -367,7 +378,6 @@ static int openprom_remount(struct super
 static const struct super_operations openprom_sops = {
 	.alloc_inode	= openprom_alloc_inode,
 	.destroy_inode	= openprom_destroy_inode,
-	.read_inode	= openprom_read_inode,
 	.statfs		= simple_statfs,
 	.remount_fs	= openprom_remount,
 };
@@ -376,6 +386,7 @@ static int openprom_fill_super(struct su
 {
 	struct inode *root_inode;
 	struct op_inode_info *oi;
+	int ret;
 
 	s->s_flags |= MS_NOATIME;
 	s->s_blocksize = 1024;
@@ -383,9 +394,11 @@ static int openprom_fill_super(struct su
 	s->s_magic = OPENPROM_SUPER_MAGIC;
 	s->s_op = &openprom_sops;
 	s->s_time_gran = 1;
-	root_inode = iget(s, OPENPROM_ROOT_INO);
-	if (!root_inode)
+	root_inode = openprom_iget(s, OPENPROM_ROOT_INO);
+	if (IS_ERR(root_inode)) {
+		ret = PTR_ERR(root_inode);
 		goto out_no_root;
+	}
 
 	oi = OP_I(root_inode);
 	oi->type = op_inode_node;
@@ -393,13 +406,15 @@ static int openprom_fill_super(struct su
 
 	s->s_root = d_alloc_root(root_inode);
 	if (!s->s_root)
-		goto out_no_root;
+		goto out_no_root_dentry;
 	return 0;
 
+out_no_root_dentry:
+	iput(root_inode);
+	ret = -ENOMEM;
 out_no_root:
 	printk("openprom_fill_super: get root inode failed\n");
-	iput(root_inode);
-	return -ENOMEM;
+	return ret;
 }
 
 static int openprom_get_sb(struct file_system_type *fs_type,
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-afs.patch
remove-aout-interpreter-support-in-elf-loader.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
