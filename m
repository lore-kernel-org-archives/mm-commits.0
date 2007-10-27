From: akpm@linux-foundation.org
Subject: + iget-stop-ufs-from-using-iget-and-read_inode-try.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:51:38 -0700
Message-ID: <200710270751.l9R7pcuw003597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbXJ0Hvz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:51:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, dushistov@mail.ru


The patch titled
     iget: stop UFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-ufs-from-using-iget-and-read_inode-try.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop UFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the UFS filesystem from using iget() and read_inode().  Replace
ufs_read_inode() with ufs_iget(), and call that instead of iget().  ufs_iget()
then uses iget_locked() directly and returns a proper error code instead of an
inode in the event of an error.

ufs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ufs/inode.c |   34 ++++++++++++++++++++--------------
 fs/ufs/namei.c |    6 +++---
 fs/ufs/super.c |   14 +++++++++-----
 fs/ufs/ufs.h   |    2 +-
 4 files changed, 33 insertions(+), 23 deletions(-)

diff -puN fs/ufs/inode.c~iget-stop-ufs-from-using-iget-and-read_inode-try fs/ufs/inode.c
--- a/fs/ufs/inode.c~iget-stop-ufs-from-using-iget-and-read_inode-try
+++ a/fs/ufs/inode.c
@@ -714,26 +714,30 @@ static int ufs2_read_inode(struct inode 
 	return 0;
 }
 
-void ufs_read_inode(struct inode * inode)
+struct inode *ufs_iget (struct super_block *sb, unsigned long ino)
 {
-	struct ufs_inode_info *ufsi = UFS_I(inode);
-	struct super_block * sb;
-	struct ufs_sb_private_info * uspi;
+	struct ufs_inode_info *ufsi;
+	struct ufs_sb_private_info * uspi = UFS_SB(sb)->s_uspi;
 	struct buffer_head * bh;
+	struct inode *inode;
 	int err;
 
-	UFSD("ENTER, ino %lu\n", inode->i_ino);
-
-	sb = inode->i_sb;
-	uspi = UFS_SB(sb)->s_uspi;
+	UFSD("ENTER, ino %lu\n", ino);
 
-	if (inode->i_ino < UFS_ROOTINO ||
-	    inode->i_ino > (uspi->s_ncg * uspi->s_ipg)) {
+	if (ino < UFS_ROOTINO || ino > (uspi->s_ncg * uspi->s_ipg)) {
 		ufs_warning(sb, "ufs_read_inode", "bad inode number (%lu)\n",
-			    inode->i_ino);
-		goto bad_inode;
+			    ino);
+		return ERR_PTR(-EIO);
 	}
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ufsi = UFS_I(inode);
+
 	bh = sb_bread(sb, uspi->s_sbbase + ufs_inotofsba(inode->i_ino));
 	if (!bh) {
 		ufs_warning(sb, "ufs_read_inode", "unable to read inode %lu\n",
@@ -765,10 +769,12 @@ void ufs_read_inode(struct inode * inode
 	brelse(bh);
 
 	UFSD("EXIT\n");
-	return;
+	unlock_new_inode(inode);
+	return inode;
 
 bad_inode:
-	make_bad_inode(inode);
+	iget_failed(inode);
+	return ERR_PTR(-EIO);
 }
 
 static void ufs1_update_inode(struct inode *inode, struct ufs_inode *ufs_inode)
diff -puN fs/ufs/namei.c~iget-stop-ufs-from-using-iget-and-read_inode-try fs/ufs/namei.c
--- a/fs/ufs/namei.c~iget-stop-ufs-from-using-iget-and-read_inode-try
+++ a/fs/ufs/namei.c
@@ -57,10 +57,10 @@ static struct dentry *ufs_lookup(struct 
 	lock_kernel();
 	ino = ufs_inode_by_name(dir, dentry);
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
-		if (!inode) {
+		inode = ufs_iget(dir->i_sb, ino);
+		if (IS_ERR(inode)) {
 			unlock_kernel();
-			return ERR_PTR(-EACCES);
+			return ERR_CAST(inode);
 		}
 	}
 	unlock_kernel();
diff -puN fs/ufs/super.c~iget-stop-ufs-from-using-iget-and-read_inode-try fs/ufs/super.c
--- a/fs/ufs/super.c~iget-stop-ufs-from-using-iget-and-read_inode-try
+++ a/fs/ufs/super.c
@@ -633,6 +633,7 @@ static int ufs_fill_super(struct super_b
 	unsigned block_size, super_block_size;
 	unsigned flags;
 	unsigned super_block_offset;
+	int ret = -EINVAL;
 
 	uspi = NULL;
 	ubh = NULL;
@@ -1066,12 +1067,16 @@ magic_found:
 		uspi->s_maxsymlinklen =
 		    fs32_to_cpu(sb, usb3->fs_un2.fs_44.fs_maxsymlinklen);
 
-	inode = iget(sb, UFS_ROOTINO);
-	if (!inode || is_bad_inode(inode))
+	inode = ufs_iget(sb, UFS_ROOTINO);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
 		goto failed;
+	}
 	sb->s_root = d_alloc_root(inode);
-	if (!sb->s_root)
+	if (!sb->s_root) {
+		ret = -ENOMEM;
 		goto dalloc_failed;
+	}
 
 	ufs_setup_cstotal(sb);
 	/*
@@ -1093,7 +1098,7 @@ failed:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 	UFSD("EXIT (FAILED)\n");
-	return -EINVAL;
+	return ret;
 
 failed_nomem:
 	UFSD("EXIT (NOMEM)\n");
@@ -1327,7 +1332,6 @@ static ssize_t ufs_quota_write(struct su
 static const struct super_operations ufs_super_ops = {
 	.alloc_inode	= ufs_alloc_inode,
 	.destroy_inode	= ufs_destroy_inode,
-	.read_inode	= ufs_read_inode,
 	.write_inode	= ufs_write_inode,
 	.delete_inode	= ufs_delete_inode,
 	.put_super	= ufs_put_super,
diff -puN fs/ufs/ufs.h~iget-stop-ufs-from-using-iget-and-read_inode-try fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~iget-stop-ufs-from-using-iget-and-read_inode-try
+++ a/fs/ufs/ufs.h
@@ -106,7 +106,7 @@ extern void ufs_free_inode (struct inode
 extern struct inode * ufs_new_inode (struct inode *, int);
 
 /* inode.c */
-extern void ufs_read_inode (struct inode *);
+extern struct inode *ufs_iget(struct super_block *, unsigned long);
 extern void ufs_put_inode (struct inode *);
 extern int ufs_write_inode (struct inode *, int);
 extern int ufs_sync_inode (struct inode *);
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
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
mutex-subsystem-synchro-test-module.patch
