From: akpm@linux-foundation.org
Subject: [merged] cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:10:05 -0800
Message-ID: <201101132012.p0DKCk00030325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933746Ab1AMUXZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:23:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net, penberg@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     cramfs: generate unique inode number for better inode cache usage
has been removed from the -mm tree.  Its filename was
     cramfs-generate-unique-inode-number-for-better-inode-cache-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: generate unique inode number for better inode cache usage
From: Stefani Seibold <stefani@seibold.net>

Generate a unique inode numbers for any entries in the cram file system. 
For files which did not contain data's (device nodes, fifos and sockets)
the offset of the directory entry inside the cramfs plus 1 will be used as
inode number.

The + 1 for the inode will it make possible to distinguish between a file
which contains no data and files which has data, the later one has a inode
value where the lower two bits are always 0.

It also reimplements the behavior to set the size and the number of block
to 0 for special file, which is the right value for empty files, devices,
fifos and sockets

As a little benefit it will be also more compatible which older mkcramfs,
because it will never use the cramfs_inode->offset for creating a inode
number for special files.

[akpm@linux-foundation.org: trivial comment fix]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |  110 +++++++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 41 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-generate-unique-inode-number-for-better-inode-cache-usage
+++ a/fs/cramfs/inode.c
@@ -34,57 +34,81 @@ static const struct address_space_operat
 static DEFINE_MUTEX(read_mutex);
 
 
-/* These two macros may change in future, to provide better st_ino
-   semantics. */
-#define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
+/* These macros may change in future, to provide better st_ino semantics. */
 #define OFFSET(x)	((x)->i_ino)
 
-static void setup_inode(struct inode *inode, struct cramfs_inode * cramfs_inode)
+static unsigned long cramino(struct cramfs_inode *cino, unsigned int offset)
 {
+	if (!cino->offset)
+		return offset + 1;
+	if (!cino->size)
+		return offset + 1;
+
+	/*
+	 * The file mode test fixes buggy mkcramfs implementations where
+	 * cramfs_inode->offset is set to a non zero value for entries
+	 * which did not contain data, like devices node and fifos.
+	 */
+	switch (cino->mode & S_IFMT) {
+	case S_IFREG:
+	case S_IFDIR:
+	case S_IFLNK:
+		return cino->offset << 2;
+	default:
+		break;
+	}
+	return offset + 1;
+}
+
+static struct inode *get_cramfs_inode(struct super_block *sb,
+	struct cramfs_inode *cramfs_inode, unsigned int offset)
+{
+	struct inode *inode;
 	static struct timespec zerotime;
+
+	inode = iget_locked(sb, cramino(cramfs_inode, offset));
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+	if (!(inode->i_state & I_NEW))
+		return inode;
+
+	switch (cramfs_inode->mode & S_IFMT) {
+	case S_IFREG:
+		inode->i_fop = &generic_ro_fops;
+		inode->i_data.a_ops = &cramfs_aops;
+		break;
+	case S_IFDIR:
+		inode->i_op = &cramfs_dir_inode_operations;
+		inode->i_fop = &cramfs_directory_operations;
+		break;
+	case S_IFLNK:
+		inode->i_op = &page_symlink_inode_operations;
+		inode->i_data.a_ops = &cramfs_aops;
+		break;
+	default:
+		init_special_inode(inode, cramfs_inode->mode,
+				old_decode_dev(cramfs_inode->size));
+	}
+
 	inode->i_mode = cramfs_inode->mode;
 	inode->i_uid = cramfs_inode->uid;
-	inode->i_size = cramfs_inode->size;
-	inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
 	inode->i_gid = cramfs_inode->gid;
+
+	/* if the lower 2 bits are zero, the inode contains data */
+	if (!(inode->i_ino & 3)) {
+		inode->i_size = cramfs_inode->size;
+		inode->i_blocks = (cramfs_inode->size - 1) / 512 + 1;
+	}
+
 	/* Struct copy intentional */
 	inode->i_mtime = inode->i_atime = inode->i_ctime = zerotime;
 	/* inode->i_nlink is left 1 - arguably wrong for directories,
 	   but it's the best we can do without reading the directory
 	   contents.  1 yields the right result in GNU find, even
 	   without -noleaf option. */
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
-		init_special_inode(inode, inode->i_mode,
-			old_decode_dev(cramfs_inode->size));
-	}
-}
 
-static struct inode *get_cramfs_inode(struct super_block *sb,
-				struct cramfs_inode * cramfs_inode)
-{
-	struct inode *inode;
-	if (CRAMINO(cramfs_inode) == 1) {
-		inode = new_inode(sb);
-		if (inode) {
-			inode->i_ino = 1;
-			setup_inode(inode, cramfs_inode);
-		}
-	} else {
-		inode = iget_locked(sb, CRAMINO(cramfs_inode));
-		if (inode && (inode->i_state & I_NEW)) {
-			setup_inode(inode, cramfs_inode);
-			unlock_new_inode(inode);
-		}
-	}
+	unlock_new_inode(inode);
+
 	return inode;
 }
 
@@ -265,6 +289,9 @@ static int cramfs_fill_super(struct supe
 		printk(KERN_ERR "cramfs: root is not a directory\n");
 		goto out;
 	}
+	/* correct strange, hard-coded permissions of mkcramfs */
+	super.root.mode |= (S_IRUSR | S_IXUSR | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH);
+
 	root_offset = super.root.offset << 2;
 	if (super.flags & CRAMFS_FLAG_FSID_VERSION_2) {
 		sbi->size=super.size;
@@ -289,7 +316,7 @@ static int cramfs_fill_super(struct supe
 
 	/* Set it all up.. */
 	sb->s_op = &cramfs_ops;
-	root = get_cramfs_inode(sb, &super.root);
+	root = get_cramfs_inode(sb, &super.root, 0);
 	if (!root)
 		goto out;
 	sb->s_root = d_alloc_root(root);
@@ -365,7 +392,7 @@ static int cramfs_readdir(struct file *f
 		 */
 		namelen = de->namelen << 2;
 		memcpy(buf, name, namelen);
-		ino = CRAMINO(de);
+		ino = cramino(de, OFFSET(inode) + offset);
 		mode = de->mode;
 		mutex_unlock(&read_mutex);
 		nextoffset = offset + sizeof(*de) + namelen;
@@ -404,8 +431,9 @@ static struct dentry * cramfs_lookup(str
 		struct cramfs_inode *de;
 		char *name;
 		int namelen, retval;
+		int dir_off = OFFSET(dir) + offset;
 
-		de = cramfs_read(dir->i_sb, OFFSET(dir) + offset, sizeof(*de)+CRAMFS_MAXPATHLEN);
+		de = cramfs_read(dir->i_sb, dir_off, sizeof(*de)+CRAMFS_MAXPATHLEN);
 		name = (char *)(de+1);
 
 		/* Try to take advantage of sorted directories */
@@ -436,7 +464,7 @@ static struct dentry * cramfs_lookup(str
 		if (!retval) {
 			struct cramfs_inode entry = *de;
 			mutex_unlock(&read_mutex);
-			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry));
+			d_add(dentry, get_cramfs_inode(dir->i_sb, &entry, dir_off));
 			return NULL;
 		}
 		/* else (retval < 0) */
_

Patches currently in -mm which might be from stefani@seibold.net are

origin.patch

