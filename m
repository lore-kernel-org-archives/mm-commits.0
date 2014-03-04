From: akpm@linux-foundation.org
Subject: [to-be-updated]
 fat-add-i_disksize-to-represent-uninitialized-size.patch removed from -mm
 tree
Date: Tue, 04 Mar 2014 13:15:22 -0800
Message-ID: <5316426a.nyr/VQGFxBmkJGQw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932214AbaCDVPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2014 16:15:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hirofumi@mail.parknet.co.jp, a.sahrawat@samsung.com, namjae.jeon@samsung.com

Subject: [to-be-updated] fat-add-i_disksize-to-represent-uninitialized-size.patch removed from -mm tree
To: namjae.jeon@samsung.com,a.sahrawat@samsung.com,hirofumi@mail.parknet.co.jp,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 04 Mar 2014 13:15:22 -0800


The patch titled
     Subject: fat: add i_disksize to represent uninitialized size
has been removed from the -mm tree.  Its filename was
     fat-add-i_disksize-to-represent-uninitialized-size.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: add i_disksize to represent uninitialized size

Add i_disksize to represent uninitialized allocated size.
And mmu_private represent initialized allocated size.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/cache.c |    6 +++---
 fs/fat/fat.h   |    3 ++-
 fs/fat/file.c  |    4 +++-
 fs/fat/inode.c |    4 ++++
 4 files changed, 12 insertions(+), 5 deletions(-)

diff -puN fs/fat/cache.c~fat-add-i_disksize-to-represent-uninitialized-size fs/fat/cache.c
--- a/fs/fat/cache.c~fat-add-i_disksize-to-represent-uninitialized-size
+++ a/fs/fat/cache.c
@@ -329,10 +329,10 @@ int fat_bmap(struct inode *inode, sector
 			return 0;
 
 		/*
-		 * ->mmu_private can access on only allocation path.
-		 * (caller must hold ->i_mutex)
+		 * Both ->mmu_private and ->i_disksize can access
+		 * on only allocation path. (caller must hold ->i_mutex)
 		 */
-		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+		last_block = (MSDOS_I(inode)->i_disksize + (blocksize - 1))
 			>> blocksize_bits;
 		if (sector >= last_block)
 			return 0;
diff -puN fs/fat/fat.h~fat-add-i_disksize-to-represent-uninitialized-size fs/fat/fat.h
--- a/fs/fat/fat.h~fat-add-i_disksize-to-represent-uninitialized-size
+++ a/fs/fat/fat.h
@@ -118,7 +118,8 @@ struct msdos_inode_info {
 	unsigned int cache_valid_id;
 
 	/* NOTE: mmu_private is 64bits, so must hold ->i_mutex to access */
-	loff_t mmu_private;	/* physically allocated size */
+	loff_t mmu_private;	/* physically allocated size (initialized) */
+	loff_t i_disksize;	/* physically allocated size (uninitialized) */
 
 	int i_start;		/* first cluster or 0 */
 	int i_logstart;		/* logical first cluster */
diff -puN fs/fat/file.c~fat-add-i_disksize-to-represent-uninitialized-size fs/fat/file.c
--- a/fs/fat/file.c~fat-add-i_disksize-to-represent-uninitialized-size
+++ a/fs/fat/file.c
@@ -300,8 +300,10 @@ void fat_truncate_blocks(struct inode *i
 	 * This protects against truncating a file bigger than it was then
 	 * trying to write into the hole.
 	 */
-	if (MSDOS_I(inode)->mmu_private > offset)
+	if (MSDOS_I(inode)->i_disksize > offset) {
 		MSDOS_I(inode)->mmu_private = offset;
+		MSDOS_I(inode)->i_disksize = offset;
+	}
 
 	nr_clusters = (offset + (cluster_size - 1)) >> sbi->cluster_bits;
 
diff -puN fs/fat/inode.c~fat-add-i_disksize-to-represent-uninitialized-size fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-i_disksize-to-represent-uninitialized-size
+++ a/fs/fat/inode.c
@@ -93,6 +93,7 @@ static inline int __fat_get_block(struct
 
 	*max_blocks = min(mapped_blocks, *max_blocks);
 	MSDOS_I(inode)->mmu_private += *max_blocks << sb->s_blocksize_bits;
+	MSDOS_I(inode)->i_disksize = MSDOS_I(inode)->mmu_private;
 
 	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
@@ -408,6 +409,7 @@ int fat_fill_inode(struct inode *inode,
 		if (error < 0)
 			return error;
 		MSDOS_I(inode)->mmu_private = inode->i_size;
+		MSDOS_I(inode)->i_disksize = inode->i_size;
 
 		set_nlink(inode, fat_subdirs(inode));
 	} else { /* not a directory */
@@ -423,6 +425,7 @@ int fat_fill_inode(struct inode *inode,
 		inode->i_fop = &fat_file_operations;
 		inode->i_mapping->a_ops = &fat_aops;
 		MSDOS_I(inode)->mmu_private = inode->i_size;
+		MSDOS_I(inode)->i_disksize = inode->i_size;
 	}
 	if (de->attr & ATTR_SYS) {
 		if (sbi->options.sys_immutable)
@@ -1223,6 +1226,7 @@ static int fat_read_root(struct inode *i
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 	MSDOS_I(inode)->i_logstart = 0;
 	MSDOS_I(inode)->mmu_private = inode->i_size;
+	MSDOS_I(inode)->i_disksize = inode->i_size;
 
 	fat_save_attrs(inode, ATTR_DIR);
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = 0;
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

fat-add-fat_fallocate-operation.patch
fat-zero-out-seek-range-on-_fat_get_block.patch
fat-fallback-to-buffered-write-in-case-of-fallocated-region-on-direct-io.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
fat-update-the-limitation-for-fat-fallocate.patch
linux-next.patch

