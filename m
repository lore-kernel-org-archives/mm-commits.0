From: akpm@linux-foundation.org
Subject: + iget-stop-romfs-from-using-iget-and-read_inode.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:50:45 -0700
Message-ID: <200710270750.l9R7ojxs003566@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbXJ0Hu6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:50:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     iget: stop ROMFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-romfs-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop ROMFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the ROMFS filesystem from using iget() and read_inode().  Replace
romfs_read_inode() with romfs_iget(), and call that instead of iget(). 
romfs_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

romfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |   45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

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
@@ -478,20 +486,28 @@ static mode_t romfs_modemap[] =
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
+			printk("romfs: read error for inode 0x%lx\n", ino);
+			iget_failed(i);
+			return ERR_PTR(-EIO);
 		}
 		/* XXX: do romfs_checksum here too (with name) */
 
@@ -548,6 +564,8 @@ romfs_read_inode(struct inode *i)
 			init_special_inode(i, ino,
 					MKDEV(nextfh>>16,nextfh&0xffff));
 	}
+	unlock_new_inode(i);
+	return i;
 }
 
 static struct kmem_cache * romfs_inode_cachep;
@@ -599,7 +617,6 @@ static int romfs_remount(struct super_bl
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
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
