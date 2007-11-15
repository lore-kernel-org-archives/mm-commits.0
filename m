From: akpm@linux-foundation.org
Subject: - fixes-to-the-bfs-filesystem-driver.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:09:55 -0800
Message-ID: <200711152109.lAFL9t0h015500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932605AbXKOVRe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmitri.vorobiev@gmail.com, tigran@veritas.com, mm-commits@vger.kernel.org


The patch titled
     Fixes to the BFS filesystem driver
has been removed from the -mm tree.  Its filename was
     fixes-to-the-bfs-filesystem-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fixes to the BFS filesystem driver
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>

I found a few bugs in the BFS driver.  Detailed description of the bugs as
well as the steps to reproduce the errors are given in the kernel bugzilla.
 Please follow these links for more information:

http://bugzilla.kernel.org/show_bug.cgi?id=9363
http://bugzilla.kernel.org/show_bug.cgi?id=9364
http://bugzilla.kernel.org/show_bug.cgi?id=9365
http://bugzilla.kernel.org/show_bug.cgi?id=9366

This patch fixes the bugs described above.  Besides, the patch introduces
coding style changes to make the BFS driver conform to the requirements
specified for Linux kernel code.  Finally, I made a few cosmetic changes
such as removal of trivial debug output.

Also, the patch removes the fields `si_lf_ioff' and `si_lf_sblk' of the
in-core superblock structure.  These fields are initialized but never
actually used.

If you are wondering why I need BFS, here is the answer: I am using this
driver in the context of Linux kernel classes I am teaching in the Moscow
State University and in the International Institute of Information
Technology in Pune, India.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: Tigran Aivazian <tigran@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/bfs.h   |    4 -
 fs/bfs/dir.c   |  146 +++++++++++++++++++++++++----------------------
 fs/bfs/file.c  |   62 +++++++++++++------
 fs/bfs/inode.c |  127 ++++++++++++++++++++--------------------
 4 files changed, 184 insertions(+), 155 deletions(-)

diff -puN fs/bfs/bfs.h~fixes-to-the-bfs-filesystem-driver fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~fixes-to-the-bfs-filesystem-driver
+++ a/fs/bfs/bfs.h
@@ -14,8 +14,6 @@ struct bfs_sb_info {
 	unsigned long si_blocks;
 	unsigned long si_freeb;
 	unsigned long si_freei;
-	unsigned long si_lf_ioff;
-	unsigned long si_lf_sblk;
 	unsigned long si_lf_eblk;
 	unsigned long si_lasti;
 	unsigned long * si_imap;
@@ -39,7 +37,7 @@ static inline struct bfs_sb_info *BFS_SB
 
 static inline struct bfs_inode_info *BFS_I(struct inode *inode)
 {
-	return list_entry(inode, struct bfs_inode_info, vfs_inode);
+	return container_of(inode, struct bfs_inode_info, vfs_inode);
 }
 
 
diff -puN fs/bfs/dir.c~fixes-to-the-bfs-filesystem-driver fs/bfs/dir.c
--- a/fs/bfs/dir.c~fixes-to-the-bfs-filesystem-driver
+++ a/fs/bfs/dir.c
@@ -21,29 +21,32 @@
 #define dprintf(x...)
 #endif
 
-static int bfs_add_entry(struct inode * dir, const unsigned char * name, int namelen, int ino);
-static struct buffer_head * bfs_find_entry(struct inode * dir, 
-	const unsigned char * name, int namelen, struct bfs_dirent ** res_dir);
+static int bfs_add_entry(struct inode *dir, const unsigned char *name,
+						int namelen, int ino);
+static struct buffer_head *bfs_find_entry(struct inode *dir,
+				const unsigned char *name, int namelen,
+				struct bfs_dirent **res_dir);
 
-static int bfs_readdir(struct file * f, void * dirent, filldir_t filldir)
+static int bfs_readdir(struct file *f, void *dirent, filldir_t filldir)
 {
-	struct inode * dir = f->f_path.dentry->d_inode;
-	struct buffer_head * bh;
-	struct bfs_dirent * de;
+	struct inode *dir = f->f_path.dentry->d_inode;
+	struct buffer_head *bh;
+	struct bfs_dirent *de;
 	unsigned int offset;
 	int block;
 
 	lock_kernel();
 
-	if (f->f_pos & (BFS_DIRENT_SIZE-1)) {
-		printf("Bad f_pos=%08lx for %s:%08lx\n", (unsigned long)f->f_pos, 
-			dir->i_sb->s_id, dir->i_ino);
+	if (f->f_pos & (BFS_DIRENT_SIZE - 1)) {
+		printf("Bad f_pos=%08lx for %s:%08lx\n",
+					(unsigned long)f->f_pos,
+					dir->i_sb->s_id, dir->i_ino);
 		unlock_kernel();
 		return -EBADF;
 	}
 
 	while (f->f_pos < dir->i_size) {
-		offset = f->f_pos & (BFS_BSIZE-1);
+		offset = f->f_pos & (BFS_BSIZE - 1);
 		block = BFS_I(dir)->i_sblock + (f->f_pos >> BFS_BSIZE_BITS);
 		bh = sb_bread(dir->i_sb, block);
 		if (!bh) {
@@ -54,7 +57,9 @@ static int bfs_readdir(struct file * f, 
 			de = (struct bfs_dirent *)(bh->b_data + offset);
 			if (de->ino) {
 				int size = strnlen(de->name, BFS_NAMELEN);
-				if (filldir(dirent, de->name, size, f->f_pos, le16_to_cpu(de->ino), DT_UNKNOWN) < 0) {
+				if (filldir(dirent, de->name, size, f->f_pos,
+						le16_to_cpu(de->ino),
+						DT_UNKNOWN) < 0) {
 					brelse(bh);
 					unlock_kernel();
 					return 0;
@@ -62,7 +67,7 @@ static int bfs_readdir(struct file * f, 
 			}
 			offset += BFS_DIRENT_SIZE;
 			f->f_pos += BFS_DIRENT_SIZE;
-		} while (offset < BFS_BSIZE && f->f_pos < dir->i_size);
+		} while ((offset < BFS_BSIZE) && (f->f_pos < dir->i_size));
 		brelse(bh);
 	}
 
@@ -78,13 +83,13 @@ const struct file_operations bfs_dir_ope
 
 extern void dump_imap(const char *, struct super_block *);
 
-static int bfs_create(struct inode * dir, struct dentry * dentry, int mode,
-		struct nameidata *nd)
+static int bfs_create(struct inode *dir, struct dentry *dentry, int mode,
+						struct nameidata *nd)
 {
 	int err;
-	struct inode * inode;
-	struct super_block * s = dir->i_sb;
-	struct bfs_sb_info * info = BFS_SB(s);
+	struct inode *inode;
+	struct super_block *s = dir->i_sb;
+	struct bfs_sb_info *info = BFS_SB(s);
 	unsigned long ino;
 
 	inode = new_inode(s);
@@ -97,7 +102,7 @@ static int bfs_create(struct inode * dir
 		iput(inode);
 		return -ENOSPC;
 	}
-	set_bit(ino, info->si_imap);	
+	set_bit(ino, info->si_imap);
 	info->si_freei--;
 	inode->i_uid = current->fsuid;
 	inode->i_gid = (dir->i_mode & S_ISGID) ? dir->i_gid : current->fsgid;
@@ -113,9 +118,10 @@ static int bfs_create(struct inode * dir
 	BFS_I(inode)->i_eblock = 0;
 	insert_inode_hash(inode);
         mark_inode_dirty(inode);
-	dump_imap("create",s);
+	dump_imap("create", s);
 
-	err = bfs_add_entry(dir, dentry->d_name.name, dentry->d_name.len, inode->i_ino);
+	err = bfs_add_entry(dir, dentry->d_name.name, dentry->d_name.len,
+							inode->i_ino);
 	if (err) {
 		inode_dec_link_count(inode);
 		iput(inode);
@@ -127,11 +133,12 @@ static int bfs_create(struct inode * dir
 	return 0;
 }
 
-static struct dentry * bfs_lookup(struct inode * dir, struct dentry * dentry, struct nameidata *nd)
+static struct dentry *bfs_lookup(struct inode *dir, struct dentry *dentry,
+						struct nameidata *nd)
 {
-	struct inode * inode = NULL;
-	struct buffer_head * bh;
-	struct bfs_dirent * de;
+	struct inode *inode = NULL;
+	struct buffer_head *bh;
+	struct bfs_dirent *de;
 
 	if (dentry->d_name.len > BFS_NAMELEN)
 		return ERR_PTR(-ENAMETOOLONG);
@@ -152,13 +159,15 @@ static struct dentry * bfs_lookup(struct
 	return NULL;
 }
 
-static int bfs_link(struct dentry * old, struct inode * dir, struct dentry * new)
+static int bfs_link(struct dentry *old, struct inode *dir,
+						struct dentry *new)
 {
-	struct inode * inode = old->d_inode;
+	struct inode *inode = old->d_inode;
 	int err;
 
 	lock_kernel();
-	err = bfs_add_entry(dir, new->d_name.name, new->d_name.len, inode->i_ino);
+	err = bfs_add_entry(dir, new->d_name.name, new->d_name.len,
+							inode->i_ino);
 	if (err) {
 		unlock_kernel();
 		return err;
@@ -172,23 +181,23 @@ static int bfs_link(struct dentry * old,
 	return 0;
 }
 
-
-static int bfs_unlink(struct inode * dir, struct dentry * dentry)
+static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int error = -ENOENT;
-	struct inode * inode;
-	struct buffer_head * bh;
-	struct bfs_dirent * de;
+	struct inode *inode;
+	struct buffer_head *bh;
+	struct bfs_dirent *de;
 
 	inode = dentry->d_inode;
 	lock_kernel();
 	bh = bfs_find_entry(dir, dentry->d_name.name, dentry->d_name.len, &de);
-	if (!bh || le16_to_cpu(de->ino) != inode->i_ino)
+	if (!bh || (le16_to_cpu(de->ino) != inode->i_ino))
 		goto out_brelse;
 
 	if (!inode->i_nlink) {
-		printf("unlinking non-existent file %s:%lu (nlink=%d)\n", inode->i_sb->s_id, 
-				inode->i_ino, inode->i_nlink);
+		printf("unlinking non-existent file %s:%lu (nlink=%d)\n",
+					inode->i_sb->s_id, inode->i_ino,
+					inode->i_nlink);
 		inode->i_nlink = 1;
 	}
 	de->ino = 0;
@@ -205,12 +214,12 @@ out_brelse:
 	return error;
 }
 
-static int bfs_rename(struct inode * old_dir, struct dentry * old_dentry, 
-			struct inode * new_dir, struct dentry * new_dentry)
+static int bfs_rename(struct inode *old_dir, struct dentry *old_dentry,
+			struct inode *new_dir, struct dentry *new_dentry)
 {
-	struct inode * old_inode, * new_inode;
-	struct buffer_head * old_bh, * new_bh;
-	struct bfs_dirent * old_de, * new_de;		
+	struct inode *old_inode, *new_inode;
+	struct buffer_head *old_bh, *new_bh;
+	struct bfs_dirent *old_de, *new_de;
 	int error = -ENOENT;
 
 	old_bh = new_bh = NULL;
@@ -223,7 +232,7 @@ static int bfs_rename(struct inode * old
 				old_dentry->d_name.name, 
 				old_dentry->d_name.len, &old_de);
 
-	if (!old_bh || le16_to_cpu(old_de->ino) != old_inode->i_ino)
+	if (!old_bh || (le16_to_cpu(old_de->ino) != old_inode->i_ino))
 		goto end_rename;
 
 	error = -EPERM;
@@ -239,7 +248,8 @@ static int bfs_rename(struct inode * old
 	if (!new_bh) {
 		error = bfs_add_entry(new_dir, 
 					new_dentry->d_name.name,
-			 		new_dentry->d_name.len, old_inode->i_ino);
+					new_dentry->d_name.len,
+					old_inode->i_ino);
 		if (error)
 			goto end_rename;
 	}
@@ -268,11 +278,12 @@ const struct inode_operations bfs_dir_in
 	.rename			= bfs_rename,
 };
 
-static int bfs_add_entry(struct inode * dir, const unsigned char * name, int namelen, int ino)
+static int bfs_add_entry(struct inode *dir, const unsigned char *name,
+							int namelen, int ino)
 {
-	struct buffer_head * bh;
-	struct bfs_dirent * de;
-	int block, sblock, eblock, off, eoff;
+	struct buffer_head *bh;
+	struct bfs_dirent *de;
+	int block, sblock, eblock, off, pos;
 	int i;
 
 	dprintf("name=%s, namelen=%d\n", name, namelen);
@@ -284,27 +295,24 @@ static int bfs_add_entry(struct inode * 
 
 	sblock = BFS_I(dir)->i_sblock;
 	eblock = BFS_I(dir)->i_eblock;
-	eoff = dir->i_size % BFS_BSIZE;
-	for (block=sblock; block<=eblock; block++) {
+	for (block = sblock; block <= eblock; block++) {
 		bh = sb_bread(dir->i_sb, block);
-		if(!bh) 
+		if (!bh)
 			return -ENOSPC;
-		for (off=0; off<BFS_BSIZE; off+=BFS_DIRENT_SIZE) {
+		for (off = 0; off < BFS_BSIZE; off += BFS_DIRENT_SIZE) {
 			de = (struct bfs_dirent *)(bh->b_data + off);
-			if (block==eblock && off>=eoff) {
-				/* Do not read/interpret the garbage in the end of eblock. */
-				de->ino = 0;
-			}
 			if (!de->ino) {
-				if ((block-sblock)*BFS_BSIZE + off >= dir->i_size) {
+				pos = (block - sblock) * BFS_BSIZE + off;
+				if (pos >= dir->i_size) {
 					dir->i_size += BFS_DIRENT_SIZE;
 					dir->i_ctime = CURRENT_TIME_SEC;
 				}
 				dir->i_mtime = CURRENT_TIME_SEC;
 				mark_inode_dirty(dir);
 				de->ino = cpu_to_le16((u16)ino);
-				for (i=0; i<BFS_NAMELEN; i++)
-					de->name[i] = (i < namelen) ? name[i] : 0;
+				for (i = 0; i < BFS_NAMELEN; i++)
+					de->name[i] =
+						(i < namelen) ? name[i] : 0;
 				mark_buffer_dirty(bh);
 				brelse(bh);
 				return 0;
@@ -315,25 +323,26 @@ static int bfs_add_entry(struct inode * 
 	return -ENOSPC;
 }
 
-static inline int bfs_namecmp(int len, const unsigned char * name, const char * buffer)
+static inline int bfs_namecmp(int len, const unsigned char *name,
+							const char *buffer)
 {
-	if (len < BFS_NAMELEN && buffer[len])
+	if ((len < BFS_NAMELEN) && buffer[len])
 		return 0;
 	return !memcmp(name, buffer, len);
 }
 
-static struct buffer_head * bfs_find_entry(struct inode * dir, 
-	const unsigned char * name, int namelen, struct bfs_dirent ** res_dir)
+static struct buffer_head *bfs_find_entry(struct inode *dir,
+			const unsigned char *name, int namelen,
+			struct bfs_dirent **res_dir)
 {
-	unsigned long block, offset;
-	struct buffer_head * bh;
-	struct bfs_dirent * de;
+	unsigned long block = 0, offset = 0;
+	struct buffer_head *bh = NULL;
+	struct bfs_dirent *de;
 
 	*res_dir = NULL;
 	if (namelen > BFS_NAMELEN)
 		return NULL;
-	bh = NULL;
-	block = offset = 0;
+
 	while (block * BFS_BSIZE + offset < dir->i_size) {
 		if (!bh) {
 			bh = sb_bread(dir->i_sb, BFS_I(dir)->i_sblock + block);
@@ -344,7 +353,8 @@ static struct buffer_head * bfs_find_ent
 		}
 		de = (struct bfs_dirent *)(bh->b_data + offset);
 		offset += BFS_DIRENT_SIZE;
-		if (le16_to_cpu(de->ino) && bfs_namecmp(namelen, name, de->name)) {
+		if (le16_to_cpu(de->ino) &&
+				bfs_namecmp(namelen, name, de->name)) {
 			*res_dir = de;
 			return bh;
 		}
diff -puN fs/bfs/file.c~fixes-to-the-bfs-filesystem-driver fs/bfs/file.c
--- a/fs/bfs/file.c~fixes-to-the-bfs-filesystem-driver
+++ a/fs/bfs/file.c
@@ -2,6 +2,11 @@
  *	fs/bfs/file.c
  *	BFS file operations.
  *	Copyright (C) 1999,2000 Tigran Aivazian <tigran@veritas.com>
+ *
+ *	Make the file block allocation algorithm understand the size
+ *	of the underlying block device.
+ *	Copyright (C) 2007 Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
+ *
  */
 
 #include <linux/fs.h>
@@ -27,7 +32,8 @@ const struct file_operations bfs_file_op
 	.splice_read	= generic_file_splice_read,
 };
 
-static int bfs_move_block(unsigned long from, unsigned long to, struct super_block *sb)
+static int bfs_move_block(unsigned long from, unsigned long to,
+					struct super_block *sb)
 {
 	struct buffer_head *bh, *new;
 
@@ -43,21 +49,22 @@ static int bfs_move_block(unsigned long 
 }
 
 static int bfs_move_blocks(struct super_block *sb, unsigned long start,
-                           unsigned long end, unsigned long where)
+				unsigned long end, unsigned long where)
 {
 	unsigned long i;
 
 	dprintf("%08lx-%08lx->%08lx\n", start, end, where);
 	for (i = start; i <= end; i++)
 		if(bfs_move_block(i, where + i, sb)) {
-			dprintf("failed to move block %08lx -> %08lx\n", i, where + i);
+			dprintf("failed to move block %08lx -> %08lx\n", i,
+								where + i);
 			return -EIO;
 		}
 	return 0;
 }
 
-static int bfs_get_block(struct inode * inode, sector_t block, 
-	struct buffer_head * bh_result, int create)
+static int bfs_get_block(struct inode *inode, sector_t block,
+			struct buffer_head *bh_result, int create)
 {
 	unsigned long phys;
 	int err;
@@ -66,9 +73,6 @@ static int bfs_get_block(struct inode * 
 	struct bfs_inode_info *bi = BFS_I(inode);
 	struct buffer_head *sbh = info->si_sbh;
 
-	if (block > info->si_blocks)
-		return -EIO;
-
 	phys = bi->i_sblock + block;
 	if (!create) {
 		if (phys <= bi->i_eblock) {
@@ -79,21 +83,29 @@ static int bfs_get_block(struct inode * 
 		return 0;
 	}
 
-	/* if the file is not empty and the requested block is within the range
-	   of blocks allocated for this file, we can grant it */
-	if (inode->i_size && phys <= bi->i_eblock) {
+	/*
+	 * If the file is not empty and the requested block is within the
+	 * range of blocks allocated for this file, we can grant it.
+	 */
+	if (bi->i_sblock && (phys <= bi->i_eblock)) {
 		dprintf("c=%d, b=%08lx, phys=%08lx (interim block granted)\n", 
 				create, (unsigned long)block, phys);
 		map_bh(bh_result, sb, phys);
 		return 0;
 	}
 
-	/* the rest has to be protected against itself */
+	/* The file will be extended, so let's see if there is enough space. */
+	if (phys >= info->si_blocks)
+		return -ENOSPC;
+
+	/* The rest has to be protected against itself. */
 	lock_kernel();
 
-	/* if the last data block for this file is the last allocated
-	   block, we can extend the file trivially, without moving it
-	   anywhere */
+	/*
+	 * If the last data block for this file is the last allocated
+	 * block, we can extend the file trivially, without moving it
+	 * anywhere.
+	 */
 	if (bi->i_eblock == info->si_lf_eblk) {
 		dprintf("c=%d, b=%08lx, phys=%08lx (simple extension)\n", 
 				create, (unsigned long)block, phys);
@@ -106,13 +118,19 @@ static int bfs_get_block(struct inode * 
 		goto out;
 	}
 
-	/* Ok, we have to move this entire file to the next free block */
+	/* Ok, we have to move this entire file to the next free block. */
 	phys = info->si_lf_eblk + 1;
-	if (bi->i_sblock) { /* if data starts on block 0 then there is no data */
+	if (phys + block >= info->si_blocks) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	if (bi->i_sblock) {
 		err = bfs_move_blocks(inode->i_sb, bi->i_sblock, 
-				bi->i_eblock, phys);
+						bi->i_eblock, phys);
 		if (err) {
-			dprintf("failed to move ino=%08lx -> fs corruption\n", inode->i_ino);
+			dprintf("failed to move ino=%08lx -> fs corruption\n",
+								inode->i_ino);
 			goto out;
 		}
 	} else
@@ -124,8 +142,10 @@ static int bfs_get_block(struct inode * 
 	phys += block;
 	info->si_lf_eblk = bi->i_eblock = phys;
 
-	/* this assumes nothing can write the inode back while we are here
-	 * and thus update inode->i_blocks! (XXX)*/
+	/*
+	 * This assumes nothing can write the inode back while we are here
+	 * and thus update inode->i_blocks! (XXX)
+	 */
 	info->si_freeb -= bi->i_eblock - bi->i_sblock + 1 - inode->i_blocks;
 	mark_inode_dirty(inode);
 	mark_buffer_dirty(sbh);
diff -puN fs/bfs/inode.c~fixes-to-the-bfs-filesystem-driver fs/bfs/inode.c
--- a/fs/bfs/inode.c~fixes-to-the-bfs-filesystem-driver
+++ a/fs/bfs/inode.c
@@ -30,25 +30,26 @@ MODULE_LICENSE("GPL");
 #define dprintf(x...)
 #endif
 
-void dump_imap(const char *prefix, struct super_block * s);
+void dump_imap(const char *prefix, struct super_block *s);
 
-static void bfs_read_inode(struct inode * inode)
+static void bfs_read_inode(struct inode *inode)
 {
 	unsigned long ino = inode->i_ino;
-	struct bfs_inode * di;
-	struct buffer_head * bh;
+	struct bfs_inode *di;
+	struct buffer_head *bh;
 	int block, off;
 
-	if (ino < BFS_ROOT_INO || ino > BFS_SB(inode->i_sb)->si_lasti) {
+	if ((ino < BFS_ROOT_INO) || (ino > BFS_SB(inode->i_sb)->si_lasti)) {
 		printf("Bad inode number %s:%08lx\n", inode->i_sb->s_id, ino);
 		make_bad_inode(inode);
 		return;
 	}
 
-	block = (ino - BFS_ROOT_INO)/BFS_INODES_PER_BLOCK + 1;
+	block = (ino - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
-		printf("Unable to read inode %s:%08lx\n", inode->i_sb->s_id, ino);
+		printf("Unable to read inode %s:%08lx\n", inode->i_sb->s_id,
+									ino);
 		make_bad_inode(inode);
 		return;
 	}
@@ -56,7 +57,7 @@ static void bfs_read_inode(struct inode 
 	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
 	di = (struct bfs_inode *)bh->b_data + off;
 
-	inode->i_mode = 0x0000FFFF &  le32_to_cpu(di->i_mode);
+	inode->i_mode = 0x0000FFFF & le32_to_cpu(di->i_mode);
 	if (le32_to_cpu(di->i_vtype) == BFS_VDIR) {
 		inode->i_mode |= S_IFDIR;
 		inode->i_op = &bfs_dir_inops;
@@ -70,48 +71,48 @@ static void bfs_read_inode(struct inode 
 
 	BFS_I(inode)->i_sblock =  le32_to_cpu(di->i_sblock);
 	BFS_I(inode)->i_eblock =  le32_to_cpu(di->i_eblock);
+	BFS_I(inode)->i_dsk_ino = le16_to_cpu(di->i_ino);
 	inode->i_uid =  le32_to_cpu(di->i_uid);
 	inode->i_gid =  le32_to_cpu(di->i_gid);
 	inode->i_nlink =  le32_to_cpu(di->i_nlink);
 	inode->i_size = BFS_FILESIZE(di);
 	inode->i_blocks = BFS_FILEBLOCKS(di);
-        if (inode->i_size || inode->i_blocks) dprintf("Registered inode with %lld size, %ld blocks\n", inode->i_size, inode->i_blocks);
 	inode->i_atime.tv_sec =  le32_to_cpu(di->i_atime);
 	inode->i_mtime.tv_sec =  le32_to_cpu(di->i_mtime);
 	inode->i_ctime.tv_sec =  le32_to_cpu(di->i_ctime);
 	inode->i_atime.tv_nsec = 0;
 	inode->i_mtime.tv_nsec = 0;
 	inode->i_ctime.tv_nsec = 0;
-	BFS_I(inode)->i_dsk_ino = le16_to_cpu(di->i_ino); /* can be 0 so we store a copy */
 
 	brelse(bh);
 }
 
-static int bfs_write_inode(struct inode * inode, int unused)
+static int bfs_write_inode(struct inode *inode, int unused)
 {
 	unsigned int ino = (u16)inode->i_ino;
         unsigned long i_sblock;
-	struct bfs_inode * di;
-	struct buffer_head * bh;
+	struct bfs_inode *di;
+	struct buffer_head *bh;
 	int block, off;
 
         dprintf("ino=%08x\n", ino);
 
-	if (ino < BFS_ROOT_INO || ino > BFS_SB(inode->i_sb)->si_lasti) {
+	if ((ino < BFS_ROOT_INO) || (ino > BFS_SB(inode->i_sb)->si_lasti)) {
 		printf("Bad inode number %s:%08x\n", inode->i_sb->s_id, ino);
 		return -EIO;
 	}
 
 	lock_kernel();
-	block = (ino - BFS_ROOT_INO)/BFS_INODES_PER_BLOCK + 1;
+	block = (ino - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh) {
-		printf("Unable to read inode %s:%08x\n", inode->i_sb->s_id, ino);
+		printf("Unable to read inode %s:%08x\n",
+				inode->i_sb->s_id, ino);
 		unlock_kernel();
 		return -EIO;
 	}
 
-	off = (ino - BFS_ROOT_INO)%BFS_INODES_PER_BLOCK;
+	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
 	di = (struct bfs_inode *)bh->b_data + off;
 
 	if (ino == BFS_ROOT_INO)
@@ -133,27 +134,26 @@ static int bfs_write_inode(struct inode 
 	di->i_eoffset = cpu_to_le32(i_sblock * BFS_BSIZE + inode->i_size - 1);
 
 	mark_buffer_dirty(bh);
-        dprintf("Written ino=%d into %d:%d\n",le16_to_cpu(di->i_ino),block,off);
 	brelse(bh);
 	unlock_kernel();
 	return 0;
 }
 
-static void bfs_delete_inode(struct inode * inode)
+static void bfs_delete_inode(struct inode *inode)
 {
 	unsigned long ino = inode->i_ino;
-	struct bfs_inode * di;
-	struct buffer_head * bh;
+	struct bfs_inode *di;
+	struct buffer_head *bh;
 	int block, off;
-	struct super_block * s = inode->i_sb;
-	struct bfs_sb_info * info = BFS_SB(s);
-	struct bfs_inode_info * bi = BFS_I(inode);
+	struct super_block *s = inode->i_sb;
+	struct bfs_sb_info *info = BFS_SB(s);
+	struct bfs_inode_info *bi = BFS_I(inode);
 
 	dprintf("ino=%08lx\n", ino);
 
 	truncate_inode_pages(&inode->i_data, 0);
 
-	if (ino < BFS_ROOT_INO || ino > info->si_lasti) {
+	if ((ino < BFS_ROOT_INO) || (ino > info->si_lasti)) {
 		printf("invalid ino=%08lx\n", ino);
 		return;
 	}
@@ -162,31 +162,35 @@ static void bfs_delete_inode(struct inod
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME_SEC;
 	lock_kernel();
 	mark_inode_dirty(inode);
-	block = (ino - BFS_ROOT_INO)/BFS_INODES_PER_BLOCK + 1;
+
+	block = (ino - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 	bh = sb_bread(s, block);
 	if (!bh) {
-		printf("Unable to read inode %s:%08lx\n", inode->i_sb->s_id, ino);
+		printf("Unable to read inode %s:%08lx\n",
+					inode->i_sb->s_id, ino);
 		unlock_kernel();
 		return;
 	}
-	off = (ino - BFS_ROOT_INO)%BFS_INODES_PER_BLOCK;
-	di = (struct bfs_inode *) bh->b_data + off;
+	off = (ino - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
+	di = (struct bfs_inode *)bh->b_data + off;
+	memset((void *)di, 0, sizeof(struct bfs_inode));
+	mark_buffer_dirty(bh);
+	brelse(bh);
+
         if (bi->i_dsk_ino) {
-		info->si_freeb += 1 + bi->i_eblock - bi->i_sblock;
+		info->si_freeb += BFS_FILEBLOCKS(bi);
 		info->si_freei++;
 		clear_bit(ino, info->si_imap);
 		dump_imap("delete_inode", s);
         }
-	di->i_ino = 0;
-	di->i_sblock = 0;
-	mark_buffer_dirty(bh);
-	brelse(bh);
 
-	/* if this was the last file, make the previous 
-	   block "last files last block" even if there is no real file there,
-	   saves us 1 gap */
-	if (info->si_lf_eblk == BFS_I(inode)->i_eblock) {
-		info->si_lf_eblk = BFS_I(inode)->i_sblock - 1;
+	/*
+	 * If this was the last file, make the previous block
+	 * "last block of the last file" even if there is no
+	 * real file there, saves us 1 gap.
+	 */
+	if (info->si_lf_eblk == bi->i_eblock) {
+		info->si_lf_eblk = bi->i_sblock - 1;
 		mark_buffer_dirty(info->si_sbh);
 	}
 	unlock_kernel();
@@ -228,7 +232,7 @@ static void bfs_write_super(struct super
 	unlock_kernel();
 }
 
-static struct kmem_cache * bfs_inode_cachep;
+static struct kmem_cache *bfs_inode_cachep;
 
 static struct inode *bfs_alloc_inode(struct super_block *sb)
 {
@@ -279,7 +283,7 @@ static const struct super_operations bfs
 	.statfs		= bfs_statfs,
 };
 
-void dump_imap(const char *prefix, struct super_block * s)
+void dump_imap(const char *prefix, struct super_block *s)
 {
 #ifdef DEBUG
 	int i;
@@ -287,25 +291,26 @@ void dump_imap(const char *prefix, struc
 
 	if (!tmpbuf)
 		return;
-	for (i=BFS_SB(s)->si_lasti; i>=0; i--) {
-		if (i > PAGE_SIZE-100) break;
+	for (i = BFS_SB(s)->si_lasti; i >= 0; i--) {
+		if (i > PAGE_SIZE - 100) break;
 		if (test_bit(i, BFS_SB(s)->si_imap))
 			strcat(tmpbuf, "1");
 		else
 			strcat(tmpbuf, "0");
 	}
-	printk(KERN_ERR "BFS-fs: %s: lasti=%08lx <%s>\n", prefix, BFS_SB(s)->si_lasti, tmpbuf);
+	printf("BFS-fs: %s: lasti=%08lx <%s>\n",
+				prefix, BFS_SB(s)->si_lasti, tmpbuf);
 	free_page((unsigned long)tmpbuf);
 #endif
 }
 
 static int bfs_fill_super(struct super_block *s, void *data, int silent)
 {
-	struct buffer_head * bh;
-	struct bfs_super_block * bfs_sb;
-	struct inode * inode;
+	struct buffer_head *bh;
+	struct bfs_super_block *bfs_sb;
+	struct inode *inode;
 	unsigned i, imap_len;
-	struct bfs_sb_info * info;
+	struct bfs_sb_info *info;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -329,14 +334,14 @@ static int bfs_fill_super(struct super_b
 
 	s->s_magic = BFS_MAGIC;
 	info->si_sbh = bh;
-	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE)/sizeof(struct bfs_inode)
-			+ BFS_ROOT_INO - 1;
-
-	imap_len = info->si_lasti/8 + 1;
+	info->si_lasti = (le32_to_cpu(bfs_sb->s_start) - BFS_BSIZE) /
+					sizeof(struct bfs_inode)
+					+ BFS_ROOT_INO - 1;
+	imap_len = (info->si_lasti / 8) + 1;
 	info->si_imap = kzalloc(imap_len, GFP_KERNEL);
 	if (!info->si_imap)
 		goto out;
-	for (i=0; i<BFS_ROOT_INO; i++) 
+	for (i = 0; i < BFS_ROOT_INO; i++)
 		set_bit(i, info->si_imap);
 
 	s->s_op = &bfs_sops;
@@ -352,16 +357,15 @@ static int bfs_fill_super(struct super_b
 		goto out;
 	}
 
-	info->si_blocks = (le32_to_cpu(bfs_sb->s_end) + 1)>>BFS_BSIZE_BITS; /* for statfs(2) */
-	info->si_freeb = (le32_to_cpu(bfs_sb->s_end) + 1 -  le32_to_cpu(bfs_sb->s_start))>>BFS_BSIZE_BITS;
+	info->si_blocks = (le32_to_cpu(bfs_sb->s_end) + 1) >> BFS_BSIZE_BITS;
+	info->si_freeb = (le32_to_cpu(bfs_sb->s_end) + 1
+			- le32_to_cpu(bfs_sb->s_start)) >> BFS_BSIZE_BITS;
 	info->si_freei = 0;
 	info->si_lf_eblk = 0;
-	info->si_lf_sblk = 0;
-	info->si_lf_ioff = 0;
 	bh = NULL;
-	for (i=BFS_ROOT_INO; i<=info->si_lasti; i++) {
+	for (i = BFS_ROOT_INO; i <= info->si_lasti; i++) {
 		struct bfs_inode *di;
-		int block = (i - BFS_ROOT_INO)/BFS_INODES_PER_BLOCK + 1;
+		int block = (i - BFS_ROOT_INO) / BFS_INODES_PER_BLOCK + 1;
 		int off = (i - BFS_ROOT_INO) % BFS_INODES_PER_BLOCK;
 		unsigned long sblock, eblock;
 
@@ -384,11 +388,8 @@ static int bfs_fill_super(struct super_b
 
 		sblock =  le32_to_cpu(di->i_sblock);
 		eblock =  le32_to_cpu(di->i_eblock);
-		if (eblock > info->si_lf_eblk) {
+		if (eblock > info->si_lf_eblk)
 			info->si_lf_eblk = eblock;
-			info->si_lf_sblk = sblock;
-			info->si_lf_ioff = BFS_INO2OFF(i);
-		}
 	}
 	brelse(bh);
 	if (!(s->s_flags & MS_RDONLY)) {
_

Patches currently in -mm which might be from dmitri.vorobiev@gmail.com are

origin.patch
