From: akpm@linux-foundation.org
Subject: + iget-stop-openpromfs-from-using-iget-and.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:52:07 -0700
Message-ID: <200710270752.l9R7q7is003612@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57912 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752586AbXJ0HwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, davem@davemloft.net


The patch titled
     iget: stop OPENPROMFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-openpromfs-from-using-iget-and.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
