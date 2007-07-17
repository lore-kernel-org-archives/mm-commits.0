From: akpm@linux-foundation.org
Subject: - knfsd-exportfs-remove-iget-abuse.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:04:07 -0700
Message-ID: <200707172304.l6HN47op011775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50076 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936782AbXGQXQy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hch@infradead.org, hch@lst.de, neilb@suse.de, shaggy@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     knfsd: exportfs: remove iget abuse
has been removed from the -mm tree.  Its filename was
     knfsd-exportfs-remove-iget-abuse.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: exportfs: remove iget abuse
From: Christoph Hellwig <hch@infradead.org>

When the exportfs interface was added the expectation was that filesystems
provide an operation to convert from a file handle to an inode/dentry, but it
kept a backwards compat option that still calls into iget.

Calling into iget from non-filesystem code is very bad, because it gives too
little information to filesystem, and simply crashes if the filesystem doesn't
implement the ->read_inode routine.

Fortunately there are only two filesystems left using this fallback: efs and
jfs.  This patch moves a copy of export_iget to each of those to implement the
get_dentry method.

While this is a temporary increase of lines of code in the kernel it allows
for a much cleaner interface and important code restructuring in later
patches.

[akpm@linux-foundation.org: add jfs_get_inode_flags() declaration]
Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/efs/namei.c         |   32 ++++++++++++++++++++++
 fs/efs/super.c         |    1 
 fs/exportfs/expfs.c    |   56 ++-------------------------------------
 fs/jfs/jfs_inode.h     |    1 
 fs/jfs/namei.c         |   32 ++++++++++++++++++++++
 fs/jfs/super.c         |    1 
 include/linux/efs_fs.h |    1 
 7 files changed, 71 insertions(+), 53 deletions(-)

diff -puN fs/efs/namei.c~knfsd-exportfs-remove-iget-abuse fs/efs/namei.c
--- a/fs/efs/namei.c~knfsd-exportfs-remove-iget-abuse
+++ a/fs/efs/namei.c
@@ -75,6 +75,38 @@ struct dentry *efs_lookup(struct inode *
 	return NULL;
 }
 
+struct dentry *efs_get_dentry(struct super_block *sb, void *vobjp)
+{
+	__u32 *objp = vobjp;
+	unsigned long ino = objp[0];
+	__u32 generation = objp[1];
+	struct inode *inode;
+	struct dentry *result;
+
+	if (ino == 0)
+		return ERR_PTR(-ESTALE);
+	inode = iget(sb, ino);
+	if (inode == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	if (is_bad_inode(inode) ||
+	    (generation && inode->i_generation != generation)) {
+	    	result = ERR_PTR(-ESTALE);
+		goto out_iput;
+	}
+
+	result = d_alloc_anon(inode);
+	if (!result) {
+		result = ERR_PTR(-ENOMEM);
+		goto out_iput;
+	}
+	return result;
+
+ out_iput:
+	iput(inode);
+	return result;
+}
+
 struct dentry *efs_get_parent(struct dentry *child)
 {
 	struct dentry *parent;
diff -puN fs/efs/super.c~knfsd-exportfs-remove-iget-abuse fs/efs/super.c
--- a/fs/efs/super.c~knfsd-exportfs-remove-iget-abuse
+++ a/fs/efs/super.c
@@ -114,6 +114,7 @@ static const struct super_operations efs
 };
 
 static struct export_operations efs_export_ops = {
+	.get_dentry	= efs_get_dentry,
 	.get_parent	= efs_get_parent,
 };
 
diff -puN fs/exportfs/expfs.c~knfsd-exportfs-remove-iget-abuse fs/exportfs/expfs.c
--- a/fs/exportfs/expfs.c~knfsd-exportfs-remove-iget-abuse
+++ a/fs/exportfs/expfs.c
@@ -391,61 +391,11 @@ out:
 	return error;
 }
 
-
-static struct dentry *export_iget(struct super_block *sb, unsigned long ino, __u32 generation)
+static struct dentry *get_dentry(struct super_block *sb, void *vobjp)
 {
-
-	/* iget isn't really right if the inode is currently unallocated!!
-	 * This should really all be done inside each filesystem
-	 *
-	 * ext2fs' read_inode has been strengthed to return a bad_inode if
-	 * the inode had been deleted.
-	 *
-	 * Currently we don't know the generation for parent directory, so
-	 * a generation of 0 means "accept any"
-	 */
-	struct inode *inode;
-	struct dentry *result;
-	if (ino == 0)
-		return ERR_PTR(-ESTALE);
-	inode = iget(sb, ino);
-	if (inode == NULL)
-		return ERR_PTR(-ENOMEM);
-	if (is_bad_inode(inode)
-	    || (generation && inode->i_generation != generation)
-		) {
-		/* we didn't find the right inode.. */
-		dprintk("fh_verify: Inode %lu, Bad count: %d %d or version  %u %u\n",
-			inode->i_ino,
-			inode->i_nlink, atomic_read(&inode->i_count),
-			inode->i_generation,
-			generation);
-
-		iput(inode);
-		return ERR_PTR(-ESTALE);
-	}
-	/* now to find a dentry.
-	 * If possible, get a well-connected one
-	 */
-	result = d_alloc_anon(inode);
-	if (!result) {
-		iput(inode);
-		return ERR_PTR(-ENOMEM);
-	}
-	return result;
+	return ERR_PTR(-ESTALE);
 }
 
-
-static struct dentry *get_object(struct super_block *sb, void *vobjp)
-{
-	__u32 *objp = vobjp;
-	unsigned long ino = objp[0];
-	__u32 generation = objp[1];
-
-	return export_iget(sb, ino, generation);
-}
-
-
 /**
  * export_encode_fh - default export_operations->encode_fh function
  * @dentry:  the dentry to encode
@@ -524,7 +474,7 @@ struct export_operations export_op_defau
 
 	.get_name	= get_name,
 	.get_parent	= get_parent,
-	.get_dentry	= get_object,
+	.get_dentry	= get_dentry,
 };
 
 EXPORT_SYMBOL(export_op_default);
diff -puN fs/jfs/jfs_inode.h~knfsd-exportfs-remove-iget-abuse fs/jfs/jfs_inode.h
--- a/fs/jfs/jfs_inode.h~knfsd-exportfs-remove-iget-abuse
+++ a/fs/jfs/jfs_inode.h
@@ -32,6 +32,7 @@ extern void jfs_truncate_nolock(struct i
 extern void jfs_free_zero_link(struct inode *);
 extern struct dentry *jfs_get_parent(struct dentry *dentry);
 extern void jfs_get_inode_flags(struct jfs_inode_info *);
+extern struct dentry *jfs_get_dentry(struct super_block *sb, void *vobjp);
 extern void jfs_set_inode_flags(struct inode *);
 extern int jfs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
diff -puN fs/jfs/namei.c~knfsd-exportfs-remove-iget-abuse fs/jfs/namei.c
--- a/fs/jfs/namei.c~knfsd-exportfs-remove-iget-abuse
+++ a/fs/jfs/namei.c
@@ -1477,6 +1477,38 @@ static struct dentry *jfs_lookup(struct 
 	return dentry;
 }
 
+struct dentry *jfs_get_dentry(struct super_block *sb, void *vobjp)
+{
+	__u32 *objp = vobjp;
+	unsigned long ino = objp[0];
+	__u32 generation = objp[1];
+	struct inode *inode;
+	struct dentry *result;
+
+	if (ino == 0)
+		return ERR_PTR(-ESTALE);
+	inode = iget(sb, ino);
+	if (inode == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	if (is_bad_inode(inode) ||
+	    (generation && inode->i_generation != generation)) {
+	    	result = ERR_PTR(-ESTALE);
+		goto out_iput;
+	}
+
+	result = d_alloc_anon(inode);
+	if (!result) {
+		result = ERR_PTR(-ENOMEM);
+		goto out_iput;
+	}
+	return result;
+
+ out_iput:
+	iput(inode);
+	return result;
+}
+
 struct dentry *jfs_get_parent(struct dentry *dentry)
 {
 	struct super_block *sb = dentry->d_inode->i_sb;
diff -puN fs/jfs/super.c~knfsd-exportfs-remove-iget-abuse fs/jfs/super.c
--- a/fs/jfs/super.c~knfsd-exportfs-remove-iget-abuse
+++ a/fs/jfs/super.c
@@ -738,6 +738,7 @@ static const struct super_operations jfs
 };
 
 static struct export_operations jfs_export_operations = {
+	.get_dentry	= jfs_get_dentry,
 	.get_parent	= jfs_get_parent,
 };
 
diff -puN include/linux/efs_fs.h~knfsd-exportfs-remove-iget-abuse include/linux/efs_fs.h
--- a/include/linux/efs_fs.h~knfsd-exportfs-remove-iget-abuse
+++ a/include/linux/efs_fs.h
@@ -45,6 +45,7 @@ extern efs_block_t efs_map_block(struct 
 extern int efs_get_block(struct inode *, sector_t, struct buffer_head *, int);
 
 extern struct dentry *efs_lookup(struct inode *, struct dentry *, struct nameidata *);
+extern struct dentry *efs_get_dentry(struct super_block *sb, void *vobjp);
 extern struct dentry *efs_get_parent(struct dentry *);
 extern int efs_bmap(struct inode *, int);
 
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
dvb_en_50221-convert-to-kthread-api.patch
git-vfs-lease-api.patch
git-xfs.patch
introduce-i_sync.patch
