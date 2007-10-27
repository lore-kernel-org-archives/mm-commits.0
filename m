From: akpm@linux-foundation.org
Subject: + iget-stop-bfs-from-using-iget-and-read_inode-try.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:44:41 -0700
Message-ID: <200710270744.l9R7ifca003275@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbXJ0Hoz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:44:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     iget: stop BFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-bfs-from-using-iget-and-read_inode-try.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop BFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the BFS filesystem from using iget() and read_inode().  Replace
bfs_read_inode() with bfs_iget(), and call that instead of iget().  bfs_iget()
then uses iget_locked() directly and returns a proper error code instead of an
inode in the event of an error.

bfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/bfs.h   |    2 ++
 fs/bfs/dir.c   |    6 +++---
 fs/bfs/inode.c |   32 ++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 13 deletions(-)

diff -puN fs/bfs/bfs.h~iget-stop-bfs-from-using-iget-and-read_inode-try fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~iget-stop-bfs-from-using-iget-and-read_inode-try
+++ a/fs/bfs/bfs.h
@@ -46,6 +46,8 @@ static inline struct bfs_inode_info *BFS
 #define printf(format, args...) \
 	printk(KERN_ERR "BFS-fs: %s(): " format, __FUNCTION__, ## args)
 
+/* inode.c */
+extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
 
 /* file.c */
 extern const struct inode_operations bfs_file_inops;
diff -puN fs/bfs/dir.c~iget-stop-bfs-from-using-iget-and-read_inode-try fs/bfs/dir.c
--- a/fs/bfs/dir.c~iget-stop-bfs-from-using-iget-and-read_inode-try
+++ a/fs/bfs/dir.c
@@ -141,10 +141,10 @@ static struct dentry * bfs_lookup(struct
 	if (bh) {
 		unsigned long ino = (unsigned long)le16_to_cpu(de->ino);
 		brelse(bh);
-		inode = iget(dir->i_sb, ino);
-		if (!inode) {
+		inode = bfs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
diff -puN fs/bfs/inode.c~iget-stop-bfs-from-using-iget-and-read_inode-try fs/bfs/inode.c
--- a/fs/bfs/inode.c~iget-stop-bfs-from-using-iget-and-read_inode-try
+++ a/fs/bfs/inode.c
@@ -32,25 +32,29 @@ MODULE_LICENSE("GPL");
 
 void dump_imap(const char *prefix, struct super_block * s);
 
-static void bfs_read_inode(struct inode * inode)
+struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
-	unsigned long ino = inode->i_ino;
 	struct bfs_inode * di;
 	struct buffer_head * bh;
+	struct inode *inode;
 	int block, off;
 
+	inode = iget_locked(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	if (ino < BFS_ROOT_INO || ino > BFS_SB(inode->i_sb)->si_lasti) {
 		printf("Bad inode number %s:%08lx\n", inode->i_sb->s_id, ino);
-		make_bad_inode(inode);
-		return;
+		goto error;
 	}
 
 	block = (ino - BFS_ROOT_INO)/BFS_INODES_PER_BLOCK + 1;
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
 		printf("Unable to read inode %s:%08lx\n", inode->i_sb->s_id, ino);
-		make_bad_inode(inode);
-		return;
+		goto error;
 	}
 
 	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
@@ -85,6 +89,12 @@ static void bfs_read_inode(struct inode 
 	BFS_I(inode)->i_dsk_ino = le16_to_cpu(di->i_ino); /* can be 0 so we store a copy */
 
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
+
+error:
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static int bfs_write_inode(struct inode * inode, int unused)
@@ -271,7 +281,6 @@ static void destroy_inodecache(void)
 static const struct super_operations bfs_sops = {
 	.alloc_inode	= bfs_alloc_inode,
 	.destroy_inode	= bfs_destroy_inode,
-	.read_inode	= bfs_read_inode,
 	.write_inode	= bfs_write_inode,
 	.delete_inode	= bfs_delete_inode,
 	.put_super	= bfs_put_super,
@@ -306,6 +315,7 @@ static int bfs_fill_super(struct super_b
 	struct inode * inode;
 	unsigned i, imap_len;
 	struct bfs_sb_info * info;
+	long ret = -EINVAL;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -340,14 +350,16 @@ static int bfs_fill_super(struct super_b
 		set_bit(i, info->si_imap);
 
 	s->s_op = &bfs_sops;
-	inode = iget(s, BFS_ROOT_INO);
-	if (!inode) {
+	inode = bfs_iget(s, BFS_ROOT_INO);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
 		kfree(info->si_imap);
 		goto out;
 	}
 	s->s_root = d_alloc_root(inode);
 	if (!s->s_root) {
 		iput(inode);
+		ret = -ENOMEM;
 		kfree(info->si_imap);
 		goto out;
 	}
@@ -402,7 +414,7 @@ out:
 	brelse(bh);
 	kfree(info);
 	s->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static int bfs_get_sb(struct file_system_type *fs_type,
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
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
