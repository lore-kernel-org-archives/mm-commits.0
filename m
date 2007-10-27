From: akpm@linux-foundation.org
Subject: + iget-stop-jfs-from-using-iget-and-read_inode-try.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:46:47 -0700
Message-ID: <200710270746.l9R7klcX003392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40165 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752202AbXJ0HrM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:47:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, shaggy@linux.vnet.ibm.com


The patch titled
     iget: stop JFS from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-jfs-from-using-iget-and-read_inode-try.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop JFS from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the JFS filesystem from using iget() and read_inode().  Replace
jfs_read_inode() with jfs_iget(), and call that instead of iget().  jfs_iget()
then uses iget_locked() directly and returns a proper error code instead of an
inode in the event of an error.

jfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/inode.c     |   20 ++++++++++++++++----
 fs/jfs/jfs_inode.h |    2 +-
 fs/jfs/namei.c     |   34 ++++++++++++++--------------------
 fs/jfs/super.c     |   15 +++++++++------
 4 files changed, 40 insertions(+), 31 deletions(-)

diff -puN fs/jfs/inode.c~iget-stop-jfs-from-using-iget-and-read_inode-try fs/jfs/inode.c
--- a/fs/jfs/inode.c~iget-stop-jfs-from-using-iget-and-read_inode-try
+++ a/fs/jfs/inode.c
@@ -31,11 +31,21 @@
 #include "jfs_debug.h"
 
 
-void jfs_read_inode(struct inode *inode)
+struct inode *jfs_iget(struct super_block *sb, unsigned long ino)
 {
-	if (diRead(inode)) {
-		make_bad_inode(inode);
-		return;
+	struct inode *inode;
+	int ret;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	ret = diRead(inode);
+	if (ret < 0) {
+		iget_failed(inode);
+		return ERR_PTR(ret);
 	}
 
 	if (S_ISREG(inode->i_mode)) {
@@ -55,6 +65,8 @@ void jfs_read_inode(struct inode *inode)
 		inode->i_op = &jfs_file_inode_operations;
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
 	}
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
diff -puN fs/jfs/jfs_inode.h~iget-stop-jfs-from-using-iget-and-read_inode-try fs/jfs/jfs_inode.h
--- a/fs/jfs/jfs_inode.h~iget-stop-jfs-from-using-iget-and-read_inode-try
+++ a/fs/jfs/jfs_inode.h
@@ -24,7 +24,7 @@ extern struct inode *ialloc(struct inode
 extern int jfs_fsync(struct file *, struct dentry *, int);
 extern int jfs_ioctl(struct inode *, struct file *,
 			unsigned int, unsigned long);
-extern void jfs_read_inode(struct inode *);
+extern struct inode *jfs_iget(struct super_block *, unsigned long);
 extern int jfs_commit_inode(struct inode *, int);
 extern int jfs_write_inode(struct inode*, int);
 extern void jfs_delete_inode(struct inode *);
diff -puN fs/jfs/namei.c~iget-stop-jfs-from-using-iget-and-read_inode-try fs/jfs/namei.c
--- a/fs/jfs/namei.c~iget-stop-jfs-from-using-iget-and-read_inode-try
+++ a/fs/jfs/namei.c
@@ -1462,12 +1462,10 @@ static struct dentry *jfs_lookup(struct 
 		}
 	}
 
-	ip = iget(dip->i_sb, inum);
-	if (ip == NULL || is_bad_inode(ip)) {
+	ip = jfs_iget(dip->i_sb, inum);
+	if (IS_ERR(ip)) {
 		jfs_err("jfs_lookup: iget failed on inum %d", (uint) inum);
-		if (ip)
-			iput(ip);
-		return ERR_PTR(-EACCES);
+		return ERR_CAST(ip);
 	}
 
 	dentry = d_splice_alias(ip, dentry);
@@ -1485,12 +1483,11 @@ static struct inode *jfs_nfs_get_inode(s
 
 	if (ino == 0)
 		return ERR_PTR(-ESTALE);
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
+	inode = jfs_iget(sb, ino);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
 
-	if (is_bad_inode(inode) ||
-	    (generation && inode->i_generation != generation)) {
+	if (generation && inode->i_generation != generation) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
@@ -1521,17 +1518,14 @@ struct dentry *jfs_get_parent(struct den
 
 	parent_ino =
 		le32_to_cpu(JFS_IP(dentry->d_inode)->i_dtroot.header.idotdot);
-	inode = iget(sb, parent_ino);
-	if (inode) {
-		if (is_bad_inode(inode)) {
+	inode = jfs_iget(sb, parent_ino);
+	if (IS_ERR(inode)) {
+		parent = ERR_CAST(inode);
+	} else {
+		parent = d_alloc_anon(inode);
+		if (!parent) {
+			parent = ERR_PTR(-ENOMEM);
 			iput(inode);
-			parent = ERR_PTR(-EACCES);
-		} else {
-			parent = d_alloc_anon(inode);
-			if (!parent) {
-				parent = ERR_PTR(-ENOMEM);
-				iput(inode);
-			}
 		}
 	}
 
diff -puN fs/jfs/super.c~iget-stop-jfs-from-using-iget-and-read_inode-try fs/jfs/super.c
--- a/fs/jfs/super.c~iget-stop-jfs-from-using-iget-and-read_inode-try
+++ a/fs/jfs/super.c
@@ -414,7 +414,7 @@ static int jfs_fill_super(struct super_b
 	struct inode *inode;
 	int rc;
 	s64 newLVSize = 0;
-	int flag;
+	int flag, ret = -EINVAL;
 
 	jfs_info("In jfs_read_super: s_flags=0x%lx", sb->s_flags);
 
@@ -461,8 +461,10 @@ static int jfs_fill_super(struct super_b
 	 * Initialize direct-mapping inode/address-space
 	 */
 	inode = new_inode(sb);
-	if (inode == NULL)
+	if (inode == NULL) {
+		ret = -ENOMEM;
 		goto out_kfree;
+	}
 	inode->i_ino = 0;
 	inode->i_nlink = 1;
 	inode->i_size = sb->s_bdev->bd_inode->i_size;
@@ -494,9 +496,11 @@ static int jfs_fill_super(struct super_b
 
 	sb->s_magic = JFS_SUPER_MAGIC;
 
-	inode = iget(sb, ROOT_I);
-	if (!inode || is_bad_inode(inode))
+	inode = jfs_iget(sb, ROOT_I);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
 		goto out_no_root;
+	}
 	sb->s_root = d_alloc_root(inode);
 	if (!sb->s_root)
 		goto out_no_root;
@@ -536,7 +540,7 @@ out_kfree:
 	if (sbi->nls_tab)
 		unload_nls(sbi->nls_tab);
 	kfree(sbi);
-	return -EINVAL;
+	return ret;
 }
 
 static void jfs_write_super_lockfs(struct super_block *sb)
@@ -720,7 +724,6 @@ out:
 static const struct super_operations jfs_super_operations = {
 	.alloc_inode	= jfs_alloc_inode,
 	.destroy_inode	= jfs_destroy_inode,
-	.read_inode	= jfs_read_inode,
 	.dirty_inode	= jfs_dirty_inode,
 	.write_inode	= jfs_write_inode,
 	.delete_inode	= jfs_delete_inode,
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
