From: akpm@linux-foundation.org
Subject: - iget-stop-romfs-from-using-iget-and-read_inode.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:08:03 -0800
Message-ID: <200802080807.m1887iFs014583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42330 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762011AbYBHIU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:20:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget: stop ROMFS from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-romfs-from-using-iget-and-read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget: stop ROMFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the ROMFS filesystem from using iget() and read_inode().  Replace
romfs_read_inode() with romfs_iget(), and call that instead of iget(). 
romfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

romfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |   46 +++++++++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff -puN fs/romfs/inode.c~iget-stop-romfs-from-using-iget-and-read_inode fs/romfs/inode.c
--- a/fs/romfs/inode.c~iget-stop-romfs-from-using-iget-and-read_inode
+++ a/fs/romfs/inode.c
@@ -84,6 +84,8 @@ struct romfs_inode_info {
 	struct inode vfs_inode;
 };
 
+static struct inode *romfs_iget(struct super_block *, unsigned long);
+
 /* instead of private superblock data */
 static inline unsigned long romfs_maxsize(struct super_block *sb)
 {
@@ -117,7 +119,7 @@ static int romfs_fill_super(struct super
 	struct buffer_head *bh;
 	struct romfs_super_block *rsb;
 	struct inode *root;
-	int sz;
+	int sz, ret = -EINVAL;
 
 	/* I would parse the options here, but there are none.. :) */
 
@@ -157,10 +159,13 @@ static int romfs_fill_super(struct super
 	     & ROMFH_MASK;
 
 	s->s_op	= &romfs_ops;
-	root = iget(s, sz);
-	if (!root)
+	root = romfs_iget(s, sz);
+	if (IS_ERR(root)) {
+		ret = PTR_ERR(root);
 		goto out;
+	}
 
+	ret = -ENOMEM;
 	s->s_root = d_alloc_root(root);
 	if (!s->s_root)
 		goto outiput;
@@ -173,7 +178,7 @@ outiput:
 out:
 	brelse(bh);
 outnobh:
-	return -EINVAL;
+	return ret;
 }
 
 /* That's simple too. */
@@ -389,8 +394,11 @@ romfs_lookup(struct inode *dir, struct d
 	if ((be32_to_cpu(ri.next) & ROMFH_TYPE) == ROMFH_HRD)
 		offset = be32_to_cpu(ri.spec) & ROMFH_MASK;
 
-	if ((inode = iget(dir->i_sb, offset)))
-		goto outi;
+	inode = romfs_iget(dir->i_sb, offset);
+	if (IS_ERR(inode)) {
+		res = PTR_ERR(inode);
+		goto out;
+	}
 
 	/*
 	 * it's a bit funky, _lookup needs to return an error code
@@ -402,7 +410,7 @@ romfs_lookup(struct inode *dir, struct d
 	 */
 
 out0:	inode = NULL;
-outi:	res = 0;
+	res = 0;
 	d_add (dentry, inode);
 
 out:	unlock_kernel();
@@ -478,20 +486,29 @@ static mode_t romfs_modemap[] =
 	S_IFBLK+0600, S_IFCHR+0600, S_IFSOCK+0644, S_IFIFO+0644
 };
 
-static void
-romfs_read_inode(struct inode *i)
+static struct inode *
+romfs_iget(struct super_block *sb, unsigned long ino)
 {
-	int nextfh, ino;
+	int nextfh;
 	struct romfs_inode ri;
+	struct inode *i;
+
+	ino &= ROMFH_MASK;
+	i = iget_locked(sb, ino);
+	if (!i)
+		return ERR_PTR(-ENOMEM);
+	if (!(i->i_state & I_NEW))
+		return i;
 
-	ino = i->i_ino & ROMFH_MASK;
 	i->i_mode = 0;
 
 	/* Loop for finding the real hard link */
 	for(;;) {
 		if (romfs_copyfrom(i, &ri, ino, ROMFH_SIZE) <= 0) {
-			printk("romfs: read error for inode 0x%x\n", ino);
-			return;
+			printk(KERN_ERR "romfs: read error for inode 0x%lx\n",
+				ino);
+			iget_failed(i);
+			return ERR_PTR(-EIO);
 		}
 		/* XXX: do romfs_checksum here too (with name) */
 
@@ -548,6 +565,8 @@ romfs_read_inode(struct inode *i)
 			init_special_inode(i, ino,
 					MKDEV(nextfh>>16,nextfh&0xffff));
 	}
+	unlock_new_inode(i);
+	return i;
 }
 
 static struct kmem_cache * romfs_inode_cachep;
@@ -599,7 +618,6 @@ static int romfs_remount(struct super_bl
 static const struct super_operations romfs_ops = {
 	.alloc_inode	= romfs_alloc_inode,
 	.destroy_inode	= romfs_destroy_inode,
-	.read_inode	= romfs_read_inode,
 	.statfs		= romfs_statfs,
 	.remount_fs	= romfs_remount,
 };
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
