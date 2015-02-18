From: akpm@linux-foundation.org
Subject: [merged] fs-affs-fix-casting-in-printed-messages.patch removed
 from -mm tree
Date: Wed, 18 Feb 2015 11:43:26 -0800
Message-ID: <54e4eb5e.vEtZX/KBNwltg1NA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbbBRTn1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs: fix casting in printed messages
has been removed from the -mm tree.  Its filename was
     fs-affs-fix-casting-in-printed-messages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: fs/affs: fix casting in printed messages

  - "inode.i_ino" is "unsigned long",
  - "loff_t" is always "unsigned long long",
  - "sector_t" should be cast to "unsigned long long" for printing,
  - "u32" should not be cast to "unsigned int" for printing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/amigaffs.c |    6 +++---
 fs/affs/dir.c      |    8 +++-----
 fs/affs/file.c     |   36 ++++++++++++++++++------------------
 fs/affs/inode.c    |    5 ++---
 fs/affs/namei.c    |   18 +++++++-----------
 5 files changed, 33 insertions(+), 40 deletions(-)

diff -puN fs/affs/amigaffs.c~fs-affs-fix-casting-in-printed-messages fs/affs/amigaffs.c
--- a/fs/affs/amigaffs.c~fs-affs-fix-casting-in-printed-messages
+++ a/fs/affs/amigaffs.c
@@ -30,7 +30,7 @@ affs_insert_hash(struct inode *dir, stru
 	ino = bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, bh)->name + 1, AFFS_TAIL(sb, bh)->name[0]);
 
-	pr_debug("%s(dir=%u, ino=%d)\n", __func__, (u32)dir->i_ino, ino);
+	pr_debug("%s(dir=%lu, ino=%d)\n", __func__, dir->i_ino, ino);
 
 	dir_bh = affs_bread(sb, dir->i_ino);
 	if (!dir_bh)
@@ -80,8 +80,8 @@ affs_remove_hash(struct inode *dir, stru
 	sb = dir->i_sb;
 	rem_ino = rem_bh->b_blocknr;
 	offset = affs_hash_name(sb, AFFS_TAIL(sb, rem_bh)->name+1, AFFS_TAIL(sb, rem_bh)->name[0]);
-	pr_debug("%s(dir=%d, ino=%d, hashval=%d)\n",
-		 __func__, (u32)dir->i_ino, rem_ino, offset);
+	pr_debug("%s(dir=%lu, ino=%d, hashval=%d)\n", __func__, dir->i_ino,
+		 rem_ino, offset);
 
 	bh = affs_bread(sb, dir->i_ino);
 	if (!bh)
diff -puN fs/affs/dir.c~fs-affs-fix-casting-in-printed-messages fs/affs/dir.c
--- a/fs/affs/dir.c~fs-affs-fix-casting-in-printed-messages
+++ a/fs/affs/dir.c
@@ -54,8 +54,7 @@ affs_readdir(struct file *file, struct d
 	u32			 ino;
 	int			 error = 0;
 
-	pr_debug("%s(ino=%lu,f_pos=%lx)\n",
-		 __func__, inode->i_ino, (unsigned long)ctx->pos);
+	pr_debug("%s(ino=%lu,f_pos=%llx)\n", __func__, inode->i_ino, ctx->pos);
 
 	if (ctx->pos < 2) {
 		file->private_data = (void *)0;
@@ -117,9 +116,8 @@ inside:
 
 			namelen = min(AFFS_TAIL(sb, fh_bh)->name[0], (u8)30);
 			name = AFFS_TAIL(sb, fh_bh)->name + 1;
-			pr_debug("readdir(): dir_emit(\"%.*s\", "
-				 "ino=%u), hash=%d, f_pos=%x\n",
-				 namelen, name, ino, hash_pos, (u32)ctx->pos);
+			pr_debug("readdir(): dir_emit(\"%.*s\", ino=%u), hash=%d, f_pos=%llx\n",
+				 namelen, name, ino, hash_pos, ctx->pos);
 
 			if (!dir_emit(ctx, name, namelen, ino, DT_UNKNOWN))
 				goto done;
diff -puN fs/affs/file.c~fs-affs-fix-casting-in-printed-messages fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-fix-casting-in-printed-messages
+++ a/fs/affs/file.c
@@ -299,8 +299,8 @@ affs_get_block(struct inode *inode, sect
 	struct buffer_head	*ext_bh;
 	u32			 ext;
 
-	pr_debug("%s(%u, %lu)\n",
-		 __func__, (u32)inode->i_ino, (unsigned long)block);
+	pr_debug("%s(%lu, %llu)\n", __func__, inode->i_ino,
+		 (unsigned long long)block);
 
 	BUG_ON(block > (sector_t)0x7fffffffUL);
 
@@ -330,8 +330,9 @@ affs_get_block(struct inode *inode, sect
 
 		/* store new block */
 		if (bh_result->b_blocknr)
-			affs_warning(sb, "get_block", "block already set (%lx)",
-				     (unsigned long)bh_result->b_blocknr);
+			affs_warning(sb, "get_block",
+				     "block already set (%llx)",
+				     (unsigned long long)bh_result->b_blocknr);
 		AFFS_BLOCK(sb, ext_bh, block) = cpu_to_be32(blocknr);
 		AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(block + 1);
 		affs_adjust_checksum(ext_bh, blocknr - bh_result->b_blocknr + 1);
@@ -353,8 +354,8 @@ affs_get_block(struct inode *inode, sect
 	return 0;
 
 err_big:
-	affs_error(inode->i_sb, "get_block", "strange block request %d",
-		   (int)block);
+	affs_error(inode->i_sb, "get_block", "strange block request %llu",
+		   (unsigned long long)block);
 	return -EIO;
 err_ext:
 	// unlock cache
@@ -503,7 +504,7 @@ affs_do_readpage_ofs(struct page *page,
 	u32 bidx, boff, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%u, %ld, 0, %d)\n", __func__, (u32)inode->i_ino,
+	pr_debug("%s(%lu, %ld, 0, %d)\n", __func__, inode->i_ino,
 		 page->index, to);
 	BUG_ON(to > PAGE_CACHE_SIZE);
 	kmap(page);
@@ -539,7 +540,7 @@ affs_extent_file_ofs(struct inode *inode
 	u32 size, bsize;
 	u32 tmp;
 
-	pr_debug("%s(%u, %d)\n", __func__, (u32)inode->i_ino, newsize);
+	pr_debug("%s(%lu, %d)\n", __func__, inode->i_ino, newsize);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	bh = NULL;
 	size = AFFS_I(inode)->mmu_private;
@@ -608,7 +609,7 @@ affs_readpage_ofs(struct file *file, str
 	u32 to;
 	int err;
 
-	pr_debug("%s(%u, %ld)\n", __func__, (u32)inode->i_ino, page->index);
+	pr_debug("%s(%lu, %ld)\n", __func__, inode->i_ino, page->index);
 	to = PAGE_CACHE_SIZE;
 	if (((page->index + 1) << PAGE_CACHE_SHIFT) > inode->i_size) {
 		to = inode->i_size & ~PAGE_CACHE_MASK;
@@ -631,8 +632,8 @@ static int affs_write_begin_ofs(struct f
 	pgoff_t index;
 	int err = 0;
 
-	pr_debug("%s(%u, %llu, %llu)\n", __func__, (u32)inode->i_ino,
-		 (unsigned long long)pos, (unsigned long long)pos + len);
+	pr_debug("%s(%lu, %llu, %llu)\n", __func__, inode->i_ino, pos,
+		 pos + len);
 	if (pos > AFFS_I(inode)->mmu_private) {
 		/* XXX: this probably leaves a too-big i_size in case of
 		 * failure. Should really be updating i_size at write_end time
@@ -681,9 +682,8 @@ static int affs_write_end_ofs(struct fil
 	 * due to write_begin.
 	 */
 
-	pr_debug("%s(%u, %llu, %llu)\n",
-		 __func__, (u32)inode->i_ino, (unsigned long long)pos,
-		(unsigned long long)pos + len);
+	pr_debug("%s(%lu, %llu, %llu)\n", __func__, inode->i_ino, pos,
+		 pos + len);
 	bsize = AFFS_SB(sb)->s_data_blksize;
 	data = page_address(page);
 
@@ -831,8 +831,8 @@ affs_truncate(struct inode *inode)
 	struct buffer_head *ext_bh;
 	int i;
 
-	pr_debug("truncate(inode=%d, oldsize=%u, newsize=%u)\n",
-		 (u32)inode->i_ino, (u32)AFFS_I(inode)->mmu_private, (u32)inode->i_size);
+	pr_debug("truncate(inode=%lu, oldsize=%llu, newsize=%llu)\n",
+		 inode->i_ino, AFFS_I(inode)->mmu_private, inode->i_size);
 
 	last_blk = 0;
 	ext = 0;
@@ -863,7 +863,7 @@ affs_truncate(struct inode *inode)
 	if (IS_ERR(ext_bh)) {
 		affs_warning(sb, "truncate",
 			     "unexpected read error for ext block %u (%ld)",
-			     (unsigned int)ext, PTR_ERR(ext_bh));
+			     ext, PTR_ERR(ext_bh));
 		return;
 	}
 	if (AFFS_I(inode)->i_lc) {
@@ -911,7 +911,7 @@ affs_truncate(struct inode *inode)
 			if (IS_ERR(bh)) {
 				affs_warning(sb, "truncate",
 					     "unexpected read error for last block %u (%ld)",
-					     (unsigned int)ext, PTR_ERR(bh));
+					     ext, PTR_ERR(bh));
 				return;
 			}
 			tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);
diff -puN fs/affs/inode.c~fs-affs-fix-casting-in-printed-messages fs/affs/inode.c
--- a/fs/affs/inode.c~fs-affs-fix-casting-in-printed-messages
+++ a/fs/affs/inode.c
@@ -348,9 +348,8 @@ affs_add_entry(struct inode *dir, struct
 	u32 block = 0;
 	int retval;
 
-	pr_debug("%s(dir=%u, inode=%u, \"%pd\", type=%d)\n",
-		 __func__, (u32)dir->i_ino,
-	         (u32)inode->i_ino, dentry, type);
+	pr_debug("%s(dir=%lu, inode=%lu, \"%pd\", type=%d)\n", __func__,
+		 dir->i_ino, inode->i_ino, dentry, type);
 
 	retval = -EIO;
 	bh = affs_bread(sb, inode->i_ino);
diff -puN fs/affs/namei.c~fs-affs-fix-casting-in-printed-messages fs/affs/namei.c
--- a/fs/affs/namei.c~fs-affs-fix-casting-in-printed-messages
+++ a/fs/affs/namei.c
@@ -248,9 +248,8 @@ affs_lookup(struct inode *dir, struct de
 int
 affs_unlink(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%d, %lu \"%pd\")\n",
-		 __func__, (u32)dir->i_ino, dentry->d_inode->i_ino,
-		dentry);
+	pr_debug("%s(dir=%lu, %lu \"%pd\")\n", __func__, dir->i_ino,
+		 dentry->d_inode->i_ino, dentry);
 
 	return affs_remove_header(dentry);
 }
@@ -317,9 +316,8 @@ affs_mkdir(struct inode *dir, struct den
 int
 affs_rmdir(struct inode *dir, struct dentry *dentry)
 {
-	pr_debug("%s(dir=%u, %lu \"%pd\")\n",
-		__func__, (u32)dir->i_ino, dentry->d_inode->i_ino,
-		 dentry);
+	pr_debug("%s(dir=%lu, %lu \"%pd\")\n", __func__, dir->i_ino,
+		 dentry->d_inode->i_ino, dentry);
 
 	return affs_remove_header(dentry);
 }
@@ -404,8 +402,7 @@ affs_link(struct dentry *old_dentry, str
 {
 	struct inode *inode = old_dentry->d_inode;
 
-	pr_debug("%s(%u, %u, \"%pd\")\n",
-		 __func__, (u32)inode->i_ino, (u32)dir->i_ino,
+	pr_debug("%s(%lu, %lu, \"%pd\")\n", __func__, inode->i_ino, dir->i_ino,
 		 dentry);
 
 	return affs_add_entry(dir, inode, dentry, ST_LINKFILE);
@@ -419,9 +416,8 @@ affs_rename(struct inode *old_dir, struc
 	struct buffer_head *bh = NULL;
 	int retval;
 
-	pr_debug("%s(old=%u,\"%pd\" to new=%u,\"%pd\")\n",
-		 __func__, (u32)old_dir->i_ino, old_dentry,
-		 (u32)new_dir->i_ino, new_dentry);
+	pr_debug("%s(old=%lu,\"%pd\" to new=%lu,\"%pd\")\n", __func__,
+		 old_dir->i_ino, old_dentry, new_dir->i_ino, new_dentry);
 
 	retval = affs_check_name(new_dentry->d_name.name,
 				 new_dentry->d_name.len,
_

Patches currently in -mm which might be from geert@linux-m68k.org are

origin.patch
linux-next.patch

