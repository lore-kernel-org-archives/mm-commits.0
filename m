From: akpm@linux-foundation.org
Subject: - iget-stop-befs-from-using-iget-and-read_inode-try.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:20 -0800
Message-ID: <200802080807.m188712Q014499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60734 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933213AbYBHIVO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:21:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, will_dyson@pobox.com, mm-commits@vger.kernel.org


The patch titled
     iget: stop BEFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-befs-from-using-iget-and-read_inode-try.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop BEFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the BEFS filesystem from using iget() and read_inode().  Replace
befs_read_inode() with befs_iget(), and call that instead of iget(). 
befs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

befs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Will Dyson <will_dyson@pobox.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

diff -puN fs/befs/linuxvfs.c~iget-stop-befs-from-using-iget-and-read_inode-try fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~iget-stop-befs-from-using-iget-and-read_inode-try
+++ a/fs/befs/linuxvfs.c
@@ -35,7 +35,7 @@ static int befs_get_block(struct inode *
 static int befs_readpage(struct file *file, struct page *page);
 static sector_t befs_bmap(struct address_space *mapping, sector_t block);
 static struct dentry *befs_lookup(struct inode *, struct dentry *, struct nameidata *);
-static void befs_read_inode(struct inode *ino);
+static struct inode *befs_iget(struct super_block *, unsigned long);
 static struct inode *befs_alloc_inode(struct super_block *sb);
 static void befs_destroy_inode(struct inode *inode);
 static int befs_init_inodecache(void);
@@ -52,7 +52,6 @@ static int befs_statfs(struct dentry *, 
 static int parse_options(char *, befs_mount_options *);
 
 static const struct super_operations befs_sops = {
-	.read_inode	= befs_read_inode,	/* initialize & read inode */
 	.alloc_inode	= befs_alloc_inode,	/* allocate a new inode */
 	.destroy_inode	= befs_destroy_inode, /* deallocate an inode */
 	.put_super	= befs_put_super,	/* uninit super */
@@ -198,9 +197,9 @@ befs_lookup(struct inode *dir, struct de
 		return ERR_PTR(-ENODATA);
 	}
 
-	inode = iget(dir->i_sb, (ino_t) offset);
-	if (!inode)
-		return ERR_PTR(-EACCES);
+	inode = befs_iget(dir->i_sb, (ino_t) offset);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
 	d_add(dentry, inode);
 
@@ -296,17 +295,23 @@ static void init_once(struct kmem_cache 
 	inode_init_once(&bi->vfs_inode);
 }
 
-static void
-befs_read_inode(struct inode *inode)
+static struct inode *befs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct buffer_head *bh = NULL;
 	befs_inode *raw_inode = NULL;
 
-	struct super_block *sb = inode->i_sb;
 	befs_sb_info *befs_sb = BEFS_SB(sb);
 	befs_inode_info *befs_ino = NULL;
+	struct inode *inode;
+	long ret = -EIO;
 
-	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", inode->i_ino);
+	befs_debug(sb, "---> befs_read_inode() " "inode = %lu", ino);
+
+	inode = iget_locked(sb, ino);
+	if (IS_ERR(inode))
+		return inode;
+	if (!(inode->i_state & I_NEW))
+		return inode;
 
 	befs_ino = BEFS_I(inode);
 
@@ -402,15 +407,16 @@ befs_read_inode(struct inode *inode)
 
 	brelse(bh);
 	befs_debug(sb, "<--- befs_read_inode()");
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
       unacquire_bh:
 	brelse(bh);
 
       unacquire_none:
-	make_bad_inode(inode);
+	iget_failed(inode);
 	befs_debug(sb, "<--- befs_read_inode() - Bad inode");
-	return;
+	return ERR_PTR(ret);
 }
 
 /* Initialize the inode cache. Called at fs setup.
@@ -752,6 +758,7 @@ befs_fill_super(struct super_block *sb, 
 	befs_sb_info *befs_sb;
 	befs_super_block *disk_sb;
 	struct inode *root;
+	long ret = -EINVAL;
 
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
@@ -833,7 +840,11 @@ befs_fill_super(struct super_block *sb, 
 	/* Set real blocksize of fs */
 	sb_set_blocksize(sb, (ulong) befs_sb->block_size);
 	sb->s_op = (struct super_operations *) &befs_sops;
-	root = iget(sb, iaddr2blockno(sb, &(befs_sb->root_dir)));
+	root = befs_iget(sb, iaddr2blockno(sb, &(befs_sb->root_dir)));
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
+		goto unacquire_priv_sbp;
+	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		iput(root);
@@ -868,7 +879,7 @@ befs_fill_super(struct super_block *sb, 
 
       unacquire_none:
 	sb->s_fs_info = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static int
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
