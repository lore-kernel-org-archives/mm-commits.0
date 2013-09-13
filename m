From: akpm@linux-foundation.org
Subject: [merged] truncate-drop-oldsize-truncate_pagecache-parameter.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:52 -0700
Message-ID: <52336f6c.voaj8EiRabjqGPw5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUCw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, kirill.shutemov@linux.intel.com

Subject: [merged] truncate-drop-oldsize-truncate_pagecache-parameter.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,hirofumi@mail.parknet.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:52 -0700


The patch titled
     Subject: truncate: drop 'oldsize' truncate_pagecache() parameter
has been removed from the -mm tree.  Its filename was
     truncate-drop-oldsize-truncate_pagecache-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: truncate: drop 'oldsize' truncate_pagecache() parameter

truncate_pagecache() doesn't care about old size since cedabed49b ("vfs:
Fix vmtruncate() regression").  Let's drop it.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/adfs/inode.c             |    2 +-
 fs/affs/file.c              |    2 +-
 fs/bfs/file.c               |    2 +-
 fs/btrfs/free-space-cache.c |    4 +---
 fs/btrfs/inode.c            |    2 +-
 fs/cifs/inode.c             |    5 +----
 fs/exofs/inode.c            |    2 +-
 fs/ext2/inode.c             |    2 +-
 fs/ext4/inode.c             |    3 +--
 fs/fat/inode.c              |    2 +-
 fs/fuse/dir.c               |    2 +-
 fs/fuse/inode.c             |    2 +-
 fs/gfs2/bmap.c              |    4 ++--
 fs/hfs/inode.c              |    2 +-
 fs/hfsplus/inode.c          |    2 +-
 fs/hpfs/file.c              |    2 +-
 fs/jfs/inode.c              |    2 +-
 fs/minix/inode.c            |    2 +-
 fs/nfs/inode.c              |    4 +---
 fs/nilfs2/inode.c           |    2 +-
 fs/ntfs/file.c              |    2 +-
 fs/omfs/file.c              |    2 +-
 fs/sysv/itree.c             |    2 +-
 fs/udf/inode.c              |    2 +-
 fs/ufs/inode.c              |    2 +-
 fs/xfs/xfs_aops.c           |    4 ++--
 include/linux/mm.h          |    2 +-
 mm/truncate.c               |    9 ++-------
 28 files changed, 31 insertions(+), 44 deletions(-)

diff -puN fs/adfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/adfs/inode.c
--- a/fs/adfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/adfs/inode.c
@@ -50,7 +50,7 @@ static void adfs_write_failed(struct add
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size)
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 }
 
 static int adfs_write_begin(struct file *file, struct address_space *mapping,
diff -puN fs/affs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/affs/file.c
--- a/fs/affs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/affs/file.c
@@ -406,7 +406,7 @@ static void affs_write_failed(struct add
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		affs_truncate(inode);
 	}
 }
diff -puN fs/bfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/bfs/file.c
--- a/fs/bfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/bfs/file.c
@@ -166,7 +166,7 @@ static void bfs_write_failed(struct addr
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size)
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 }
 
 static int bfs_write_begin(struct file *file, struct address_space *mapping,
diff -puN fs/btrfs/free-space-cache.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/btrfs/free-space-cache.c
--- a/fs/btrfs/free-space-cache.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/btrfs/free-space-cache.c
@@ -221,12 +221,10 @@ int btrfs_truncate_free_space_cache(stru
 				    struct btrfs_path *path,
 				    struct inode *inode)
 {
-	loff_t oldsize;
 	int ret = 0;
 
-	oldsize = i_size_read(inode);
 	btrfs_i_size_write(inode, 0);
-	truncate_pagecache(inode, oldsize, 0);
+	truncate_pagecache(inode, 0);
 
 	/*
 	 * We don't need an orphan item because truncating the free space cache
diff -puN fs/btrfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/btrfs/inode.c
--- a/fs/btrfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/btrfs/inode.c
@@ -4409,7 +4409,7 @@ static int btrfs_setsize(struct inode *i
 		inode->i_ctime = inode->i_mtime = current_fs_time(inode->i_sb);
 
 	if (newsize > oldsize) {
-		truncate_pagecache(inode, oldsize, newsize);
+		truncate_pagecache(inode, newsize);
 		ret = btrfs_cont_expand(inode, oldsize, newsize);
 		if (ret)
 			return ret;
diff -puN fs/cifs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/cifs/inode.c
--- a/fs/cifs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/cifs/inode.c
@@ -1852,14 +1852,11 @@ static int cifs_truncate_page(struct add
 
 static void cifs_setsize(struct inode *inode, loff_t offset)
 {
-	loff_t oldsize;
-
 	spin_lock(&inode->i_lock);
-	oldsize = inode->i_size;
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
 
-	truncate_pagecache(inode, oldsize, offset);
+	truncate_pagecache(inode, offset);
 }
 
 static int
diff -puN fs/exofs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/exofs/inode.c
--- a/fs/exofs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/exofs/inode.c
@@ -861,7 +861,7 @@ static int exofs_writepage(struct page *
 static void _write_failed(struct inode *inode, loff_t to)
 {
 	if (to > inode->i_size)
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 }
 
 int exofs_write_begin(struct file *file, struct address_space *mapping,
diff -puN fs/ext2/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/ext2/inode.c
--- a/fs/ext2/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/ext2/inode.c
@@ -58,7 +58,7 @@ static void ext2_write_failed(struct add
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		ext2_truncate_blocks(inode, inode->i_size);
 	}
 }
diff -puN fs/ext4/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/ext4/inode.c
--- a/fs/ext4/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/ext4/inode.c
@@ -4587,7 +4587,6 @@ int ext4_setattr(struct dentry *dentry,
 
 	if (attr->ia_valid & ATTR_SIZE && attr->ia_size != inode->i_size) {
 		handle_t *handle;
-		loff_t oldsize = inode->i_size;
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4650,7 +4649,7 @@ int ext4_setattr(struct dentry *dentry,
 		 * Truncate pagecache after we've waited for commit
 		 * in data=journal mode to make pages freeable.
 		 */
-		truncate_pagecache(inode, oldsize, inode->i_size);
+			truncate_pagecache(inode, inode->i_size);
 	}
 	/*
 	 * We want to call ext4_truncate() even if attr->ia_size ==
diff -puN fs/fat/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/fat/inode.c
--- a/fs/fat/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/fat/inode.c
@@ -147,7 +147,7 @@ static void fat_write_failed(struct addr
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		fat_truncate_blocks(inode, inode->i_size);
 	}
 }
diff -puN fs/fuse/dir.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/fuse/dir.c
--- a/fs/fuse/dir.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/fuse/dir.c
@@ -1678,7 +1678,7 @@ int fuse_do_setattr(struct inode *inode,
 	 * FUSE_NOWRITE, otherwise fuse_launder_page() would deadlock.
 	 */
 	if (S_ISREG(inode->i_mode) && oldsize != outarg.attr.size) {
-		truncate_pagecache(inode, oldsize, outarg.attr.size);
+		truncate_pagecache(inode, outarg.attr.size);
 		invalidate_inode_pages2(inode->i_mapping);
 	}
 
diff -puN fs/fuse/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/fuse/inode.c
--- a/fs/fuse/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/fuse/inode.c
@@ -218,7 +218,7 @@ void fuse_change_attributes(struct inode
 		bool inval = false;
 
 		if (oldsize != attr->size) {
-			truncate_pagecache(inode, oldsize, attr->size);
+			truncate_pagecache(inode, attr->size);
 			inval = true;
 		} else if (fc->auto_inval_data) {
 			struct timespec new_mtime = {
diff -puN fs/gfs2/bmap.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/gfs2/bmap.c
--- a/fs/gfs2/bmap.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/gfs2/bmap.c
@@ -1016,7 +1016,7 @@ static int gfs2_journaled_truncate(struc
 		chunk = oldsize - newsize;
 		if (chunk > max_chunk)
 			chunk = max_chunk;
-		truncate_pagecache(inode, oldsize, oldsize - chunk);
+		truncate_pagecache(inode, oldsize - chunk);
 		oldsize -= chunk;
 		gfs2_trans_end(sdp);
 		error = gfs2_trans_begin(sdp, RES_DINODE, GFS2_JTRUNC_REVOKES);
@@ -1067,7 +1067,7 @@ static int trunc_start(struct inode *ino
 	if (journaled)
 		error = gfs2_journaled_truncate(inode, oldsize, newsize);
 	else
-		truncate_pagecache(inode, oldsize, newsize);
+		truncate_pagecache(inode, newsize);
 
 	if (error) {
 		brelse(dibh);
diff -puN fs/hfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/hfs/inode.c
--- a/fs/hfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/hfs/inode.c
@@ -41,7 +41,7 @@ static void hfs_write_failed(struct addr
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		hfs_file_truncate(inode);
 	}
 }
diff -puN fs/hfsplus/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/hfsplus/inode.c
--- a/fs/hfsplus/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/hfsplus/inode.c
@@ -36,7 +36,7 @@ static void hfsplus_write_failed(struct
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		hfsplus_file_truncate(inode);
 	}
 }
diff -puN fs/hpfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/hpfs/file.c
--- a/fs/hpfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/hpfs/file.c
@@ -138,7 +138,7 @@ static void hpfs_write_failed(struct add
 	hpfs_lock(inode->i_sb);
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		hpfs_truncate(inode);
 	}
 
diff -puN fs/jfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/jfs/inode.c
--- a/fs/jfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/jfs/inode.c
@@ -306,7 +306,7 @@ static void jfs_write_failed(struct addr
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		jfs_truncate(inode);
 	}
 }
diff -puN fs/minix/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/minix/inode.c
--- a/fs/minix/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/minix/inode.c
@@ -400,7 +400,7 @@ static void minix_write_failed(struct ad
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		minix_truncate(inode);
 	}
 }
diff -puN fs/nfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/nfs/inode.c
--- a/fs/nfs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/nfs/inode.c
@@ -541,7 +541,6 @@ EXPORT_SYMBOL_GPL(nfs_setattr);
  */
 static int nfs_vmtruncate(struct inode * inode, loff_t offset)
 {
-	loff_t oldsize;
 	int err;
 
 	err = inode_newsize_ok(inode, offset);
@@ -549,11 +548,10 @@ static int nfs_vmtruncate(struct inode *
 		goto out;
 
 	spin_lock(&inode->i_lock);
-	oldsize = inode->i_size;
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
 
-	truncate_pagecache(inode, oldsize, offset);
+	truncate_pagecache(inode, offset);
 out:
 	return err;
 }
diff -puN fs/nilfs2/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/nilfs2/inode.c
@@ -254,7 +254,7 @@ void nilfs_write_failed(struct address_s
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		nilfs_truncate(inode);
 	}
 }
diff -puN fs/ntfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/ntfs/file.c
--- a/fs/ntfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/ntfs/file.c
@@ -1768,7 +1768,7 @@ static void ntfs_write_failed(struct add
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		ntfs_truncate_vfs(inode);
 	}
 }
diff -puN fs/omfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/omfs/file.c
--- a/fs/omfs/file.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/omfs/file.c
@@ -311,7 +311,7 @@ static void omfs_write_failed(struct add
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		omfs_truncate(inode);
 	}
 }
diff -puN fs/sysv/itree.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/sysv/itree.c
--- a/fs/sysv/itree.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/sysv/itree.c
@@ -469,7 +469,7 @@ static void sysv_write_failed(struct add
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size) {
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 		sysv_truncate(inode);
 	}
 }
diff -puN fs/udf/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/udf/inode.c
--- a/fs/udf/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/udf/inode.c
@@ -172,7 +172,7 @@ static void udf_write_failed(struct addr
 	loff_t isize = inode->i_size;
 
 	if (to > isize) {
-		truncate_pagecache(inode, to, isize);
+		truncate_pagecache(inode, isize);
 		if (iinfo->i_alloc_type != ICBTAG_FLAG_AD_IN_ICB) {
 			down_write(&iinfo->i_data_sem);
 			udf_clear_extent_cache(inode);
diff -puN fs/ufs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/ufs/inode.c
--- a/fs/ufs/inode.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/ufs/inode.c
@@ -531,7 +531,7 @@ static void ufs_write_failed(struct addr
 	struct inode *inode = mapping->host;
 
 	if (to > inode->i_size)
-		truncate_pagecache(inode, to, inode->i_size);
+		truncate_pagecache(inode, inode->i_size);
 }
 
 static int ufs_write_begin(struct file *file, struct address_space *mapping,
diff -puN fs/xfs/xfs_aops.c~truncate-drop-oldsize-truncate_pagecache-parameter fs/xfs/xfs_aops.c
--- a/fs/xfs/xfs_aops.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/fs/xfs/xfs_aops.c
@@ -1582,7 +1582,7 @@ xfs_vm_write_begin(
 		unlock_page(page);
 
 		if (pos + len > i_size_read(inode))
-			truncate_pagecache(inode, pos + len, i_size_read(inode));
+			truncate_pagecache(inode, i_size_read(inode));
 
 		page_cache_release(page);
 		page = NULL;
@@ -1618,7 +1618,7 @@ xfs_vm_write_end(
 		loff_t		to = pos + len;
 
 		if (to > isize) {
-			truncate_pagecache(inode, to, isize);
+			truncate_pagecache(inode, isize);
 			xfs_vm_kill_delalloc_range(inode, isize, to);
 		}
 	}
diff -puN include/linux/mm.h~truncate-drop-oldsize-truncate_pagecache-parameter include/linux/mm.h
--- a/include/linux/mm.h~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/include/linux/mm.h
@@ -985,7 +985,7 @@ static inline void unmap_shared_mapping_
 	unmap_mapping_range(mapping, holebegin, holelen, 0);
 }
 
-extern void truncate_pagecache(struct inode *inode, loff_t old, loff_t new);
+extern void truncate_pagecache(struct inode *inode, loff_t new);
 extern void truncate_setsize(struct inode *inode, loff_t newsize);
 void truncate_pagecache_range(struct inode *inode, loff_t offset, loff_t end);
 int truncate_inode_page(struct address_space *mapping, struct page *page);
diff -puN mm/truncate.c~truncate-drop-oldsize-truncate_pagecache-parameter mm/truncate.c
--- a/mm/truncate.c~truncate-drop-oldsize-truncate_pagecache-parameter
+++ a/mm/truncate.c
@@ -567,7 +567,6 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
 /**
  * truncate_pagecache - unmap and remove pagecache that has been truncated
  * @inode: inode
- * @oldsize: old file size
  * @newsize: new file size
  *
  * inode's new i_size must already be written before truncate_pagecache
@@ -580,7 +579,7 @@ EXPORT_SYMBOL_GPL(invalidate_inode_pages
  * situations such as writepage being called for a page that has already
  * had its underlying blocks deallocated.
  */
-void truncate_pagecache(struct inode *inode, loff_t oldsize, loff_t newsize)
+void truncate_pagecache(struct inode *inode, loff_t newsize)
 {
 	struct address_space *mapping = inode->i_mapping;
 	loff_t holebegin = round_up(newsize, PAGE_SIZE);
@@ -614,12 +613,8 @@ EXPORT_SYMBOL(truncate_pagecache);
  */
 void truncate_setsize(struct inode *inode, loff_t newsize)
 {
-	loff_t oldsize;
-
-	oldsize = inode->i_size;
 	i_size_write(inode, newsize);
