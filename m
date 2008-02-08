From: akpm@linux-foundation.org
Subject: - iget-stop-bfs-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:23 -0800
Message-ID: <200802080807.m18874pd014508@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933085AbYBHIVF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, kamalesh@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     iget: stop BFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-bfs-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop BFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the BFS filesystem from using iget() and read_inode().  Replace
bfs_read_inode() with bfs_iget(), and call that instead of iget().  bfs_iget()
then uses iget_locked() directly and returns a proper error code instead of an
inode in the event of an error.

bfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

[kamalesh@linux.vnet.ibm.com: build fix]
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/bfs.h   |    2 ++
 fs/bfs/dir.c   |    6 +++---
 fs/bfs/inode.c |   32 ++++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 13 deletions(-)

diff -puN fs/bfs/bfs.h~iget-stop-bfs-from-using-iget-and-read_inode-try fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~iget-stop-bfs-from-using-iget-and-read_inode-try
+++ a/fs/bfs/bfs.h
@@ -44,6 +44,8 @@ static inline struct bfs_inode_info *BFS
 #define printf(format, args...) \
 	printk(KERN_ERR "BFS-fs: %s(): " format, __FUNCTION__, ## args)
 
+/* inode.c */
+extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
 
 /* file.c */
 extern const struct inode_operations bfs_file_inops;
diff -puN fs/bfs/dir.c~iget-stop-bfs-from-using-iget-and-read_inode-try fs/bfs/dir.c
--- a/fs/bfs/dir.c~iget-stop-bfs-from-using-iget-and-read_inode-try
+++ a/fs/bfs/dir.c
@@ -148,10 +148,10 @@ static struct dentry *bfs_lookup(struct 
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
@@ -32,17 +32,22 @@ MODULE_LICENSE("GPL");
 
 void dump_imap(const char *prefix, struct super_block *s);
 
-static void bfs_read_inode(struct inode *inode)
+struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
-	unsigned long ino = inode->i_ino;
 	struct bfs_inode *di;
+	struct inode *inode;
 	struct buffer_head *bh;
 	int block, off;
 
+	inode = iget_locked(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	if ((ino < BFS_ROOT_INO) || (ino > BFS_SB(inode->i_sb)->si_lasti)) {
 		printf("Bad inode number %s:%08lx\n", inode->i_sb->s_id, ino);
-		make_bad_inode(inode);
-		return;
+		goto error;
 	}
 
 	block = (ino - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
@@ -50,8 +55,7 @@ static void bfs_read_inode(struct inode 
 	if (!bh) {
 		printf("Unable to read inode %s:%08lx\n", inode->i_sb->s_id,
 									ino);
-		make_bad_inode(inode);
-		return;
+		goto error;
 	}
 
 	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
@@ -85,6 +89,12 @@ static void bfs_read_inode(struct inode 
 	inode->i_ctime.tv_nsec = 0;
 
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
+
+error:
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static int bfs_write_inode(struct inode *inode, int unused)
@@ -276,7 +286,6 @@ static void destroy_inodecache(void)
 static const struct super_operations bfs_sops = {
 	.alloc_inode	= bfs_alloc_inode,
 	.destroy_inode	= bfs_destroy_inode,
-	.read_inode	= bfs_read_inode,
 	.write_inode	= bfs_write_inode,
 	.delete_inode	= bfs_delete_inode,
 	.put_super	= bfs_put_super,
@@ -312,6 +321,7 @@ static int bfs_fill_super(struct super_b
 	struct inode *inode;
 	unsigned i, imap_len;
 	struct bfs_sb_info *info;
+	long ret = -EINVAL;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -346,14 +356,16 @@ static int bfs_fill_super(struct super_b
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
@@ -404,7 +416,7 @@ out:
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
