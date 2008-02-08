From: akpm@linux-foundation.org
Subject: - iget-stop-qnx4-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:00 -0800
Message-ID: <200802080807.m1887f2D014573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55253 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933057AbYBHIVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, al@alarsen.net, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop QNX4 from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-qnx4-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop QNX4 from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the QNX4 filesystem from using iget() and read_inode().  Replace
qnx4_read_inode() with qnx4_iget(), and call that instead of iget(). 
qnx4_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

qnx4_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Anders Larsen <al@alarsen.net>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/inode.c         |   47 +++++++++++++++++++++++++-------------
 fs/qnx4/namei.c         |    8 ++++--
 include/linux/qnx4_fs.h |    1 
 3 files changed, 38 insertions(+), 18 deletions(-)

diff -puN fs/qnx4/inode.c~iget-stop-qnx4-from-using-iget-and-read_inode-try fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~iget-stop-qnx4-from-using-iget-and-read_inode-try
+++ a/fs/qnx4/inode.c
@@ -125,7 +125,6 @@ static int qnx4_write_inode(struct inode
 static void qnx4_put_super(struct super_block *sb);
 static struct inode *qnx4_alloc_inode(struct super_block *sb);
 static void qnx4_destroy_inode(struct inode *inode);
-static void qnx4_read_inode(struct inode *);
 static int qnx4_remount(struct super_block *sb, int *flags, char *data);
 static int qnx4_statfs(struct dentry *, struct kstatfs *);
 
@@ -133,7 +132,6 @@ static const struct super_operations qnx
 {
 	.alloc_inode	= qnx4_alloc_inode,
 	.destroy_inode	= qnx4_destroy_inode,
-	.read_inode	= qnx4_read_inode,
 	.put_super	= qnx4_put_super,
 	.statfs		= qnx4_statfs,
 	.remount_fs	= qnx4_remount,
@@ -357,6 +355,7 @@ static int qnx4_fill_super(struct super_
 	struct inode *root;
 	const char *errmsg;
 	struct qnx4_sb_info *qs;
+	int ret = -EINVAL;
 
 	qs = kzalloc(sizeof(struct qnx4_sb_info), GFP_KERNEL);
 	if (!qs)
@@ -396,12 +395,14 @@ static int qnx4_fill_super(struct super_
 	}
 
  	/* does root not have inode number QNX4_ROOT_INO ?? */
- 	root = iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
- 	if (!root) {
+	root = qnx4_iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
+	if (IS_ERR(root)) {
  		printk("qnx4: get inode failed\n");
+		ret = PTR_ERR(root);
  		goto out;
  	}
 
+	ret = -ENOMEM;
  	s->s_root = d_alloc_root(root);
  	if (s->s_root == NULL)
  		goto outi;
@@ -417,7 +418,7 @@ static int qnx4_fill_super(struct super_
       outnobh:
 	kfree(qs);
 	s->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static void qnx4_put_super(struct super_block *sb)
@@ -462,29 +463,38 @@ static const struct address_space_operat
 	.bmap		= qnx4_bmap
 };
 
-static void qnx4_read_inode(struct inode *inode)
+struct inode *qnx4_iget(struct super_block *sb, unsigned long ino)
 {
 	struct buffer_head *bh;
 	struct qnx4_inode_entry *raw_inode;
-	int block, ino;
-	struct super_block *sb = inode->i_sb;
-	struct qnx4_inode_entry *qnx4_inode = qnx4_raw_inode(inode);
+	int block;
+	struct qnx4_inode_entry *qnx4_inode;
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
-	ino = inode->i_ino;
+	qnx4_inode = qnx4_raw_inode(inode);
 	inode->i_mode = 0;
 
 	QNX4DEBUG(("Reading inode : [%d]\n", ino));
 	if (!ino) {
-		printk("qnx4: bad inode number on dev %s: %d is out of range\n",
+		printk(KERN_ERR "qnx4: bad inode number on dev %s: %lu is "
+				"out of range\n",
 		       sb->s_id, ino);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	block = ino / QNX4_INODES_PER_BLOCK;
 
 	if (!(bh = sb_bread(sb, block))) {
 		printk("qnx4: major problem: unable to read inode from dev "
 		       "%s\n", sb->s_id);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	raw_inode = ((struct qnx4_inode_entry *) bh->b_data) +
 	    (ino % QNX4_INODES_PER_BLOCK);
@@ -515,9 +525,16 @@ static void qnx4_read_inode(struct inode
 		inode->i_op = &page_symlink_inode_operations;
 		inode->i_mapping->a_ops = &qnx4_aops;
 		qnx4_i(inode)->mmu_private = inode->i_size;
-	} else
-		printk("qnx4: bad inode %d on dev %s\n",ino,sb->s_id);
+	} else {
+		printk(KERN_ERR "qnx4: bad inode %lu on dev %s\n",
+			ino, sb->s_id);
+		iget_failed(inode);
+		brelse(bh);
+		return ERR_PTR(-EIO);
+	}
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
 }
 
 static struct kmem_cache *qnx4_inode_cachep;
diff -puN fs/qnx4/namei.c~iget-stop-qnx4-from-using-iget-and-read_inode-try fs/qnx4/namei.c
--- a/fs/qnx4/namei.c~iget-stop-qnx4-from-using-iget-and-read_inode-try
+++ a/fs/qnx4/namei.c
@@ -128,10 +128,12 @@ struct dentry * qnx4_lookup(struct inode
 	}
 	brelse(bh);
 
-	if ((foundinode = iget(dir->i_sb, ino)) == NULL) {
+	foundinode = qnx4_iget(dir->i_sb, ino);
+	if (IS_ERR(foundinode)) {
 		unlock_kernel();
-		QNX4DEBUG(("qnx4: lookup->iget -> NULL\n"));
-		return ERR_PTR(-EACCES);
+		QNX4DEBUG(("qnx4: lookup->iget -> error %ld\n",
+			   PTR_ERR(foundinode)));
+		return ERR_CAST(foundinode);
 	}
 out:
 	unlock_kernel();
diff -puN include/linux/qnx4_fs.h~iget-stop-qnx4-from-using-iget-and-read_inode-try include/linux/qnx4_fs.h
--- a/include/linux/qnx4_fs.h~iget-stop-qnx4-from-using-iget-and-read_inode-try
+++ a/include/linux/qnx4_fs.h
@@ -110,6 +110,7 @@ struct qnx4_inode_info {
 	struct inode vfs_inode;
 };
 
+extern struct inode *qnx4_iget(struct super_block *, unsigned long);
 extern struct dentry *qnx4_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd);
 extern unsigned long qnx4_count_free_blocks(struct super_block *sb);
 extern unsigned long qnx4_block_map(struct inode *inode, long iblock);
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
