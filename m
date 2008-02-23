From: akpm@linux-foundation.org
Subject: - iget-stop-unionfs-from-using-iget-and-read_inode.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:53 -0800
Message-ID: <200802232022.m1NKMrF9013464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763054AbYBWU3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     iget: stop unionfs from using iget() and read_inode()
has been removed from the -mm tree.  Its filename was
     iget-stop-unionfs-from-using-iget-and-read_inode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
 fs/unionfs/super.c |   19 ++++++++++++++-----
 fs/unionfs/union.h |    1 +
 3 files changed, 20 insertions(+), 11 deletions(-)

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
@@ -24,11 +24,19 @@
  */
 static struct kmem_cache *unionfs_inode_cachep;
 
-static void unionfs_read_inode(struct inode *inode)
+struct inode *unionfs_iget(struct super_block *sb, unsigned long ino)
 {
 	int size;
-	struct unionfs_inode_info *info = UNIONFS_I(inode);
+	struct unionfs_inode_info *info;
+	struct inode *inode;
 
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+ 	if (!(inode->i_state & I_NEW))
+ 		return inode;
+
+	info = UNIONFS_I(inode);
 	memset(info, 0, offsetof(struct unionfs_inode_info, vfs_inode));
 	info->bstart = -1;
 	info->bend = -1;
@@ -44,7 +52,8 @@ static void unionfs_read_inode(struct in
 	if (unlikely(!info->lower_inodes)) {
 		printk(KERN_CRIT "unionfs: no kernel memory when allocating "
 		       "lower-pointer array!\n");
-		BUG();
+		iget_failed(inode);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_version++;
@@ -60,7 +69,8 @@ static void unionfs_read_inode(struct in
 	inode->i_atime.tv_sec = inode->i_atime.tv_nsec = 0;
 	inode->i_mtime.tv_sec = inode->i_mtime.tv_nsec = 0;
 	inode->i_ctime.tv_sec = inode->i_ctime.tv_nsec = 0;
-
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
@@ -1011,7 +1021,6 @@ out:
 }
 
 struct super_operations unionfs_sops = {
-	.read_inode	= unionfs_read_inode,
 	.delete_inode	= unionfs_delete_inode,
 	.put_super	= unionfs_put_super,
 	.statfs		= unionfs_statfs,
diff -puN fs/unionfs/union.h~iget-stop-unionfs-from-using-iget-and-read_inode fs/unionfs/union.h
--- a/fs/unionfs/union.h~iget-stop-unionfs-from-using-iget-and-read_inode
+++ a/fs/unionfs/union.h
@@ -361,6 +361,7 @@ extern int unionfs_fsync(struct file *fi
 extern int unionfs_fasync(int fd, struct file *file, int flag);
 
 /* Inode operations */
+extern struct inode *unionfs_iget(struct super_block *sb, unsigned long ino);
 extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			  struct inode *new_dir, struct dentry *new_dentry);
 extern int unionfs_unlink(struct inode *dir, struct dentry *dentry);
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
mn10300-define-hz-as-a-config-option.patch
mn10300-define-so_mark.patch
nommu-is_vmalloc_addr-wont-compile-if-mmu.patch
git-unionfs.patch
ntp-make-the-kernel-ntp-code-hand-64-bit-unsigned-values-to-do_div.patch
keys-increase-the-payload-size-when-instantiating-a-key.patch
keys-check-starting-keyring-as-part-of-search.patch
keys-allow-the-callout-data-to-be-passed-as-a-blob-rather-than-a-string.patch
keys-add-keyctl-function-to-get-a-security-label.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
mutex-subsystem-synchro-test-module.patch
