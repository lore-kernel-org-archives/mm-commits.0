From: akpm@linux-foundation.org
Subject: - change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch removed from -mm tree
Date: Tue, 08 May 2007 19:53:13 -0700
Message-ID: <200705090253.l492rDGW009669@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52586 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032223AbXEICx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     inode numbering: change libfs sb creation routines to avoid collisions with their root inodes
has been removed from the -mm tree.  Its filename was
     change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: inode numbering: change libfs sb creation routines to avoid collisions with their root inodes
From: Jeff Layton <jlayton@redhat.com>

This patch makes it so that simple_fill_super and get_sb_pseudo assign their
root inodes to be number 1.  It also fixes up a couple of callers of
simple_fill_super that were passing in files arrays that had an index at
number 1, and adds a warning for any caller that sends in such an array.

It would have been nice to have made it so that it wasn't possible to make
such a collision, but some callers need to be able to control what inode
number their entries get, so I think this is the best that can be done.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/ipath/ipath_fs.c |    2 +-
 fs/binfmt_misc.c                       |    4 ++--
 fs/libfs.c                             |   23 +++++++++++++++++++++++
 3 files changed, 26 insertions(+), 3 deletions(-)

diff -puN drivers/infiniband/hw/ipath/ipath_fs.c~change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes drivers/infiniband/hw/ipath/ipath_fs.c
--- a/drivers/infiniband/hw/ipath/ipath_fs.c~change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes
+++ a/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -523,7 +523,7 @@ static int ipathfs_fill_super(struct sup
 	int ret;
 
 	static struct tree_descr files[] = {
-		[1] = {"atomic_stats", &atomic_stats_ops, S_IRUGO},
+		[2] = {"atomic_stats", &atomic_stats_ops, S_IRUGO},
 		{""},
 	};
 
diff -puN fs/binfmt_misc.c~change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes fs/binfmt_misc.c
--- a/fs/binfmt_misc.c~change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes
+++ a/fs/binfmt_misc.c
@@ -727,8 +727,8 @@ static const struct super_operations s_o
 static int bm_fill_super(struct super_block * sb, void * data, int silent)
 {
 	static struct tree_descr bm_files[] = {
-		[1] = {"status", &bm_status_operations, S_IWUSR|S_IRUGO},
-		[2] = {"register", &bm_register_operations, S_IWUSR},
+		[2] = {"status", &bm_status_operations, S_IWUSR|S_IRUGO},
+		[3] = {"register", &bm_register_operations, S_IWUSR},
 		/* last one */ {""}
 	};
 	int err = simple_fill_super(sb, 0x42494e4d, bm_files);
diff -puN fs/libfs.c~change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes fs/libfs.c
--- a/fs/libfs.c~change-libfs-sb-creation-routines-to-avoid-collisions-with-their-root-inodes
+++ a/fs/libfs.c
@@ -220,6 +220,12 @@ int get_sb_pseudo(struct file_system_typ
 	root = new_inode(s);
 	if (!root)
 		goto Enomem;
+	/*
+	 * since this is the first inode, make it number 1. New inodes created
+	 * after this must take care not to collide with it (by passing
+	 * max_reserved of 1 to iunique).
+	 */
+	root->i_ino = 1;
 	root->i_mode = S_IFDIR | S_IRUSR | S_IWUSR;
 	root->i_uid = root->i_gid = 0;
 	root->i_atime = root->i_mtime = root->i_ctime = CURRENT_TIME;
@@ -360,6 +366,11 @@ int simple_commit_write(struct file *fil
 	return 0;
 }
 
+/*
+ * the inodes created here are not hashed. If you use iunique to generate
+ * unique inode values later for this filesystem, then you must take care
+ * to pass it an appropriate max_reserved value to avoid collisions.
+ */
 int simple_fill_super(struct super_block *s, int magic, struct tree_descr *files)
 {
 	struct inode *inode;
@@ -376,6 +387,11 @@ int simple_fill_super(struct super_block
 	inode = new_inode(s);
 	if (!inode)
 		return -ENOMEM;
+	/*
+	 * because the root inode is 1, the files array must not contain an
+	 * entry at index 1
+	 */
+	inode->i_ino = 1;
 	inode->i_mode = S_IFDIR | 0755;
 	inode->i_uid = inode->i_gid = 0;
 	inode->i_blocks = 0;
@@ -391,6 +407,13 @@ int simple_fill_super(struct super_block
 	for (i = 0; !files->name || files->name[0]; i++, files++) {
 		if (!files->name)
 			continue;
+
+		/* warn if it tries to conflict with the root inode */
+		if (unlikely(i == 1))
+			printk(KERN_WARNING "%s: %s passed in a files array"
+				"with an index of 1!\n", __func__,
+				s->s_type->name);
+
 		dentry = d_alloc_name(root, files->name);
 		if (!dentry)
 			goto out;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
