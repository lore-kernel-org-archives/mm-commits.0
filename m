From: akpm@linux-foundation.org
Subject: + iget-stop-qnx4-from-using-iget-and-read_inode-try.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:48:49 -0700
Message-ID: <200710270748.l9R7mnFC003500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087AbXJ0HtK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:49:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, al@alarsen.net


The patch titled
     iget: stop QNX4 from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-qnx4-from-using-iget-and-read_inode-try.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop QNX4 from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the QNX4 filesystem from using iget() and read_inode().  Replace
qnx4_read_inode() with qnx4_iget(), and call that instead of iget(). 
qnx4_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

qnx4_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Anders Larsen <al@alarsen.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/inode.c         |   45 +++++++++++++++++++++++++-------------
 fs/qnx4/namei.c         |    8 ++++--
 include/linux/qnx4_fs.h |    1 
 3 files changed, 36 insertions(+), 18 deletions(-)

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
+ 	root = qnx4_iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
+ 	if (IS_ERR(root)) {
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
@@ -462,29 +463,37 @@ static const struct address_space_operat
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
+		printk("qnx4: bad inode number on dev %s: %lu is out of range\n",
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
@@ -515,9 +524,15 @@ static void qnx4_read_inode(struct inode
 		inode->i_op = &page_symlink_inode_operations;
 		inode->i_mapping->a_ops = &qnx4_aops;
 		qnx4_i(inode)->mmu_private = inode->i_size;
-	} else
-		printk("qnx4: bad inode %d on dev %s\n",ino,sb->s_id);
+	} else {
+		printk("qnx4: bad inode %lu on dev %s\n",ino,sb->s_id);
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
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
