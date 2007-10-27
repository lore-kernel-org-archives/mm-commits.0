From: akpm@linux-foundation.org
Subject: + iget-stop-the-minix-filesystem-from-using-iget-and.patch added to -mm tree
Date: Sat, 27 Oct 2007 00:46:49 -0700
Message-ID: <200710270746.l9R7kn1d003395@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47704 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbXJ0HrD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 27 Oct 2007 03:47:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     iget: stop the MINIX filesystem from using iget() and read_inode()
has been added to the -mm tree.  Its filename is
     iget-stop-the-minix-filesystem-from-using-iget-and.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: iget: stop the MINIX filesystem from using iget() and read_inode()
From: David Howells <dhowells@redhat.com>

Stop the MINIX filesystem from using iget() and read_inode().  Replace
minix_read_inode() with minix_iget(), and call that instead of iget(). 
minix_iget() then uses iget_locked() directly and returns a proper error code
instead of an inode in the event of an error.

minix_fill_super() returns any error incurred when getting the root inode
instead of EINVAL.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |   43 +++++++++++++++++++++++++++++--------------
 fs/minix/minix.h |    1 +
 fs/minix/namei.c |    7 +++----
 3 files changed, 33 insertions(+), 18 deletions(-)

diff -puN fs/minix/inode.c~iget-stop-the-minix-filesystem-from-using-iget-and fs/minix/inode.c
--- a/fs/minix/inode.c~iget-stop-the-minix-filesystem-from-using-iget-and
+++ a/fs/minix/inode.c
@@ -18,7 +18,6 @@
 #include <linux/highuid.h>
 #include <linux/vfs.h>
 
-static void minix_read_inode(struct inode * inode);
 static int minix_write_inode(struct inode * inode, int wait);
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int minix_remount (struct super_block * sb, int * flags, char * data);
@@ -96,7 +95,6 @@ static void destroy_inodecache(void)
 static const struct super_operations minix_sops = {
 	.alloc_inode	= minix_alloc_inode,
 	.destroy_inode	= minix_destroy_inode,
-	.read_inode	= minix_read_inode,
 	.write_inode	= minix_write_inode,
 	.delete_inode	= minix_delete_inode,
 	.put_super	= minix_put_super,
@@ -149,6 +147,7 @@ static int minix_fill_super(struct super
 	unsigned long i, block;
 	struct inode *root_inode;
 	struct minix_sb_info *sbi;
+	int ret = -EINVAL;
 
 	sbi = kzalloc(sizeof(struct minix_sb_info), GFP_KERNEL);
 	if (!sbi)
@@ -246,10 +245,13 @@ static int minix_fill_super(struct super
 
 	/* set up enough so that it can read an inode */
 	s->s_op = &minix_sops;
-	root_inode = iget(s, MINIX_ROOT_INO);
-	if (!root_inode || is_bad_inode(root_inode))
+	root_inode = minix_iget(s, MINIX_ROOT_INO);
+	if (IS_ERR(root_inode)) {
+		ret = PTR_ERR(root_inode);
 		goto out_no_root;
+	}
 
+	ret = -ENOMEM;
 	s->s_root = d_alloc_root(root_inode);
 	if (!s->s_root)
 		goto out_iput;
@@ -290,6 +292,7 @@ out_freemap:
 	goto out_release;
 
 out_no_map:
+	ret = -ENOMEM;
 	if (!silent)
 		printk("MINIX-fs: can't allocate map\n");
 	goto out_release;
@@ -316,7 +319,7 @@ out_bad_sb:
 out:
 	s->s_fs_info = NULL;
 	kfree(sbi);
-	return -EINVAL;
+	return ret;
 }
 
 static int minix_statfs(struct dentry *dentry, struct kstatfs *buf)
@@ -409,7 +412,7 @@ void minix_set_inode(struct inode *inode
 /*
  * The minix V1 function to read an inode.
  */
-static void V1_minix_read_inode(struct inode * inode)
+static struct inode *V1_minix_iget(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
@@ -418,8 +421,8 @@ static void V1_minix_read_inode(struct i
 
 	raw_inode = minix_V1_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode) {
-		make_bad_inode(inode);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	inode->i_mode = raw_inode->i_mode;
 	inode->i_uid = (uid_t)raw_inode->i_uid;
@@ -435,12 +438,14 @@ static void V1_minix_read_inode(struct i
 		minix_inode->u.i1_data[i] = raw_inode->i_zone[i];
 	minix_set_inode(inode, old_decode_dev(raw_inode->i_zone[0]));
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
  * The minix V2 function to read an inode.
  */
-static void V2_minix_read_inode(struct inode * inode)
+static struct inode *V2_minix_iget(struct inode * inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
@@ -449,8 +454,8 @@ static void V2_minix_read_inode(struct i
 
 	raw_inode = minix_V2_raw_inode(inode->i_sb, inode->i_ino, &bh);
 	if (!raw_inode) {
-		make_bad_inode(inode);
-		return;
+		iget_failed(inode);
+		return ERR_PTR(-EIO);
 	}
 	inode->i_mode = raw_inode->i_mode;
 	inode->i_uid = (uid_t)raw_inode->i_uid;
@@ -468,17 +473,27 @@ static void V2_minix_read_inode(struct i
 		minix_inode->u.i2_data[i] = raw_inode->i_zone[i];
 	minix_set_inode(inode, old_decode_dev(raw_inode->i_zone[0]));
 	brelse(bh);
+	unlock_new_inode(inode);
+	return inode;
 }
 
 /*
  * The global function to read an inode.
  */
-static void minix_read_inode(struct inode * inode)
+struct inode *minix_iget(struct super_block *sb, unsigned long ino)
 {
+	struct inode *inode;
+
+	inode = iget_locked(sb, ino);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
 	if (INODE_VERSION(inode) == MINIX_V1)
-		V1_minix_read_inode(inode);
+		return V1_minix_iget(inode);
 	else
-		V2_minix_read_inode(inode);
+		return V2_minix_iget(inode);
 }
 
 /*
diff -puN fs/minix/minix.h~iget-stop-the-minix-filesystem-from-using-iget-and fs/minix/minix.h
--- a/fs/minix/minix.h~iget-stop-the-minix-filesystem-from-using-iget-and
+++ a/fs/minix/minix.h
@@ -45,6 +45,7 @@ struct minix_sb_info {
 	unsigned short s_version;
 };
 
+extern struct inode *minix_iget(struct super_block *, unsigned long);
 extern struct minix_inode * minix_V1_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 extern struct minix2_inode * minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 extern struct inode * minix_new_inode(const struct inode * dir, int * error);
diff -puN fs/minix/namei.c~iget-stop-the-minix-filesystem-from-using-iget-and fs/minix/namei.c
--- a/fs/minix/namei.c~iget-stop-the-minix-filesystem-from-using-iget-and
+++ a/fs/minix/namei.c
@@ -54,10 +54,9 @@ static struct dentry *minix_lookup(struc
 
 	ino = minix_inode_by_name(dentry);
 	if (ino) {
-		inode = iget(dir->i_sb, ino);
- 
-		if (!inode)
-			return ERR_PTR(-EACCES);
+		inode = minix_iget(dir->i_sb, ino);
+ 		if (IS_ERR(inode))
+			return ERR_CAST(inode);
 	}
 	d_add(dentry, inode);
 	return NULL;
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
