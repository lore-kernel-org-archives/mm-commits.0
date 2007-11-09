From: akpm@linux-foundation.org
Subject: + iget-stop-unionfs-from-using-iget-and-read_inode.patch added to -mm tree
Date: Fri, 09 Nov 2007 00:26:26 -0800
Message-ID: <200711090826.lA98QSdM004527@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751308AbXKII0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 03:26:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, ezk@cs.sunysb.edu


The patch titled
     iget: stop unionfs from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-unionfs-from-using-iget-and-read_inode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop unionfs from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the UnionFS filesystem from using iget() and read_inode().  Replace
unionfs_read_inode() with unionfs_iget(), and call that instead of iget(). 
unionfs_iget() then uses iget_locked() directly and returns a proper error
code instead of an inode in the event of an error.

unionfs_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/main.c  |   11 +++++------
 fs/unionfs/super.c |   22 ++++++++++++++++------
 fs/unionfs/union.h |    1 +
 3 files changed, 22 insertions(+), 12 deletions(-)

diff -puN fs/unionfs/main.c~iget-stop-unionfs-from-using-iget-and-read_inode fs/unionfs/main.c
--- a/fs/unionfs/main.c~iget-stop-unionfs-from-using-iget-and-read_inode
+++ a/fs/unionfs/main.c
@@ -104,9 +104,8 @@ struct dentry *unionfs_interpose(struct 
 	BUG_ON(is_negative_dentry);
 
 	/*
-	 * We allocate our new inode below, by calling iget.
-	 * iget will call our read_inode which will initialize some
-	 * of the new inode's fields
+	 * We allocate our new inode below by calling unionfs_iget,
+	 * which will initialize some of the new inode's fields
 	 */
 
 	/*
@@ -128,9 +127,9 @@ struct dentry *unionfs_interpose(struct 
 		}
 	} else {
 		/* get unique inode number for unionfs */
-		inode = iget(sb, iunique(sb, UNIONFS_ROOT_INO));
-		if (!inode) {
-			err = -EACCES;
+		inode = unionfs_iget(sb, iunique(sb, UNIONFS_ROOT_INO));
+		if (IS_ERR(inode)) {
+			err = PTR_ERR(inode);
 			goto out;
 		}
 		if (atomic_read(&inode->i_count) > 1)
diff -puN fs/unionfs/super.c~iget-stop-unionfs-from-using-iget-and-read_inode fs/unionfs/super.c
--- a/fs/unionfs/super.c~iget-stop-unionfs-from-using-iget-and-read_inode
+++ a/fs/unionfs/super.c
@@ -24,12 +24,19 @@
  */
 static struct kmem_cache *unionfs_inode_cachep;
 
-static void unionfs_read_inode(struct inode *inode)
+struct inode *unionfs_iget(struct super_block *sb, unsigned long ino)
 {
 	int size;
-	struct unionfs_inode_info *info = UNIONFS_I(inode);
+	struct unionfs_inode_info *info;
+	struct inode *inode;
 
-	unionfs_read_lock(inode->i_sb);
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+ 	if (!(inode->i_state & I_NEW))
+ 		return inode;
+
+ 	unionfs_read_lock(sb);
 
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
@@ -46,7 +53,9 @@ static void unionfs_read_inode(struct in
 	if (unlikely(!info->lower_inodes)) {
 		printk(KERN_CRIT "unionfs: no kernel memory when allocating "
 		       "lower-pointer array!\n");
-		BUG();
+		iget_failed(inode);
+		unionfs_read_unlock(sb);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_version++;
@@ -55,7 +64,9 @@ static void unionfs_read_inode(struct in
 
 	inode->i_mapping->a_ops = &unionfs_aops;
 
-	unionfs_read_unlock(inode->i_sb);
+	unlock_new_inode(inode);
+	unionfs_read_unlock(sb);
+	return inode;
 }
 
 /*
@@ -1002,7 +1013,6 @@ out:
 }
 
 struct super_operations unionfs_sops = {
-	.read_inode	= unionfs_read_inode,
 	.delete_inode	= unionfs_delete_inode,
 	.put_super	= unionfs_put_super,
 	.statfs		= unionfs_statfs,
diff -puN fs/unionfs/union.h~iget-stop-unionfs-from-using-iget-and-read_inode fs/unionfs/union.h
--- a/fs/unionfs/union.h~iget-stop-unionfs-from-using-iget-and-read_inode
+++ a/fs/unionfs/union.h
@@ -352,6 +352,7 @@ extern int unionfs_fsync(struct file *fi
 extern int unionfs_fasync(int fd, struct file *file, int flag);
 
 /* Inode operations */
+extern struct inode *unionfs_iget(struct super_block *sb, unsigned long ino);
 extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 extern int unionfs_unlink(struct inode *dir, struct dentry *dentry);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-remove-bogus-no_irq-=-1-define.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
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
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
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
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
dhowells-broke-unionfs.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
mutex-subsystem-synchro-test-module.patch
