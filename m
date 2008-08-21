From: akpm@linux-foundation.org
Subject: - cramfs-fix-named-pipe-handling.patch removed from -mm tree
Date: Wed, 20 Aug 2008 20:50:02 -0700
Message-ID: <200808210350.m7L3o2aS015686@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38153 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbYHUDuN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Aug 2008 23:50:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viro@ZenIV.linux.org.uk, anemo@mba.ocn.ne.jp, stable@kernel.orgviro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     cramfs: fix named-pipe handling
has been removed from the -mm tree.  Its filename was
     cramfs-fix-named-pipe-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: fix named-pipe handling
From: Al Viro <viro@ZenIV.linux.org.uk>

After commit a97c9bf33f4612e2aed6f000f6b1d268b6814f3c (fix cramfs
making duplicate entries in inode cache) in kernel 2.6.14, named-pipe
on cramfs does not work properly.

It seems the commit make all named-pipe on cramfs share their inode
(and named-pipe buffer).

Make ..._test() refuse to merge inodes with ->i_ino == 1, take inode setup
back to get_cramfs_inode() and make ->drop_inode() evict ones with ->i_ino
== 1 immediately.

Reported-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@kernel.org>		[2.6.14 and later]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |   84 +++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-fix-named-pipe-handling fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-fix-named-pipe-handling
+++ a/fs/cramfs/inode.c
@@ -43,58 +43,13 @@ static DEFINE_MUTEX(read_mutex);
 static int cramfs_iget5_test(struct inode *inode, void *opaque)
 {
 	struct cramfs_inode *cramfs_inode = opaque;
-
-	if (inode->i_ino != CRAMINO(cramfs_inode))
-		return 0; /* does not match */
-
-	if (inode->i_ino != 1)
-		return 1;
-
-	/* all empty directories, char, block, pipe, and sock, share inode #1 */
-
-	if ((inode->i_mode != cramfs_inode->mode) ||
-	    (inode->i_gid != cramfs_inode->gid) ||
-	    (inode->i_uid != cramfs_inode->uid))
-		return 0; /* does not match */
-
-	if ((S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode)) &&
-	    (inode->i_rdev != old_decode_dev(cramfs_inode->size)))
-		return 0; /* does not match */
-
-	return 1; /* matches */
+	return inode->i_ino == CRAMINO(cramfs_inode) && inode->i_ino != 1;
 }
 
 static int cramfs_iget5_set(struct inode *inode, void *opaque)
 {
-	static struct timespec zerotime;
 	struct cramfs_inode *cramfs_inode = opaque;
-	inode->i_mode = cramfs_inode->mode;
-	inode->i_uid = cramfs_inode->uid;
-	inode->i_size = cramfs_inode->size;
-	inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
-	inode->i_gid = cramfs_inode->gid;
-	/* Struct copy intentional */
-	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
 	inode->i_ino = CRAMINO(cramfs_inode);
-	/* inode->i_nlink is left 1 - arguably wrong for directories,
-	   but it's the best we can do without reading the directory
-           contents.  1 yields the right result in GNU find, even
-	   without -noleaf option. */
-	if (S_ISREG(inode->i_mode)) {
-		inode->i_fop = &generic_ro_fops;
-		inode->i_data.a_ops = &cramfs_aops;
-	} else if (S_ISDIR(inode->i_mode)) {
-		inode->i_op = &cramfs_dir_inode_operations;
-		inode->i_fop = &cramfs_directory_operations;
-	} else if (S_ISLNK(inode->i_mode)) {
-		inode->i_op = &page_symlink_inode_operations;
-		inode->i_data.a_ops = &cramfs_aops;
-	} else {
-		inode->i_size = 0;
-		inode->i_blocks = 0;
-		init_special_inode(inode, inode->i_mode,
-			old_decode_dev(cramfs_inode->size));
-	}
 	return 0;
 }
 
@@ -104,12 +59,48 @@ static struct inode *get_cramfs_inode(st
 	struct inode *inode = iget5_locked(sb, CRAMINO(cramfs_inode),
 					    cramfs_iget5_test, cramfs_iget5_set,
 					    cramfs_inode);
+	static struct timespec zerotime;
+
 	if (inode && (inode->i_state & I_NEW)) {
+		inode->i_mode = cramfs_inode->mode;
+		inode->i_uid = cramfs_inode->uid;
+		inode->i_size = cramfs_inode->size;
+		inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
+		inode->i_gid = cramfs_inode->gid;
+		/* Struct copy intentional */
+		inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
+		/* inode->i_nlink is left 1 - arguably wrong for directories,
+		   but it's the best we can do without reading the directory
+		   contents.  1 yields the right result in GNU find, even
+		   without -noleaf option. */
+		if (S_ISREG(inode->i_mode)) {
+			inode->i_fop = &generic_ro_fops;
+			inode->i_data.a_ops = &cramfs_aops;
+		} else if (S_ISDIR(inode->i_mode)) {
+			inode->i_op = &cramfs_dir_inode_operations;
+			inode->i_fop = &cramfs_directory_operations;
+		} else if (S_ISLNK(inode->i_mode)) {
+			inode->i_op = &page_symlink_inode_operations;
+			inode->i_data.a_ops = &cramfs_aops;
+		} else {
+			inode->i_size = 0;
+			inode->i_blocks = 0;
+			init_special_inode(inode, inode->i_mode,
+				old_decode_dev(cramfs_inode->size));
+		}
 		unlock_new_inode(inode);
 	}
 	return inode;
 }
 
+static void cramfs_drop_inode(struct inode *inode)
+{
+	if (inode->i_ino == 1)
+		generic_delete_inode(inode);
+	else
+		generic_drop_inode(inode);
+}
+
 /*
  * We have our own block cache: don't fill up the buffer cache
  * with the rom-image, because the way the filesystem is set
@@ -534,6 +525,7 @@ static const struct super_operations cra
 	.put_super	= cramfs_put_super,
 	.remount_fs	= cramfs_remount,
 	.statfs		= cramfs_statfs,
+	.drop_inode	= cramfs_drop_inode,
 };
 
 static int cramfs_get_sb(struct file_system_type *fs_type,
_

Patches currently in -mm which might be from viro@ZenIV.linux.org.uk are

linux-next.patch

