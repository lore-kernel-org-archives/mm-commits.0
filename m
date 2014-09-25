From: akpm@linux-foundation.org
Subject: + fat-add-i_disksize-to-represent-uninitialized-size.patch added
 to -mm tree
Date: Thu, 25 Sep 2014 13:26:50 -0700
Message-ID: <54247a8a.k8AkYRiJ4gCNHOXv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35454 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaIYU0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Sep 2014 16:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: add i_disksize to represent uninitialized size
has been added to the -mm tree.  Its filename is
     fat-add-i_disksize-to-represent-uninitialized-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-add-i_disksize-to-represent-uninitialized-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-add-i_disksize-to-represent-uninitialized-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: add i_disksize to represent uninitialized size

This patchset provides support for doing fallocate operation on FAT
filesystem.


This patch (of 5):

Add i_disksize to represent uninitialized allocated size.  And mmu_private
represent initialized allocated size.  i_disksize - is always kept cluster
size aligned mmu_private - is normally block size aligned

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    3 ++-
 fs/fat/file.c  |    5 ++++-
 fs/fat/inode.c |   11 +++++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff -puN fs/fat/fat.h~fat-add-i_disksize-to-represent-uninitialized-size fs/fat/fat.h
--- a/fs/fat/fat.h~fat-add-i_disksize-to-represent-uninitialized-size
+++ a/fs/fat/fat.h
@@ -119,7 +119,8 @@ struct msdos_inode_info {
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
@@ -300,8 +300,11 @@ void fat_truncate_blocks(struct inode *i
 	 * This protects against truncating a file bigger than it was then
 	 * trying to write into the hole.
 	 */
-	if (MSDOS_I(inode)->mmu_private > offset)
+	if (MSDOS_I(inode)->mmu_private > offset) {
 		MSDOS_I(inode)->mmu_private = offset;
+		MSDOS_I(inode)->i_disksize = round_up(offset,
+			sbi->cluster_size);
+	}
 
 	nr_clusters = (offset + (cluster_size - 1)) >> sbi->cluster_bits;
 
diff -puN fs/fat/inode.c~fat-add-i_disksize-to-represent-uninitialized-size fs/fat/inode.c
--- a/fs/fat/inode.c~fat-add-i_disksize-to-represent-uninitialized-size
+++ a/fs/fat/inode.c
@@ -104,6 +104,7 @@ static struct fat_floppy_defaults {
 static int fat_add_cluster(struct inode *inode)
 {
 	int err, cluster;
+	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 
 	err = fat_alloc_clusters(inode, &cluster, 1);
 	if (err)
@@ -113,6 +114,9 @@ static int fat_add_cluster(struct inode
 	err = fat_chain_add(inode, cluster, 1);
 	if (err)
 		fat_free_clusters(inode, cluster);
+	else
+		MSDOS_I(inode)->i_disksize += sbi->cluster_size;
+
 	return err;
 }
 
@@ -469,7 +473,6 @@ int fat_fill_inode(struct inode *inode,
 		error = fat_calc_dir_size(inode);
 		if (error < 0)
 			return error;
-		MSDOS_I(inode)->mmu_private = inode->i_size;
 
 		set_nlink(inode, fat_subdirs(inode));
 	} else { /* not a directory */
@@ -484,8 +487,11 @@ int fat_fill_inode(struct inode *inode,
 		inode->i_op = &fat_file_inode_operations;
 		inode->i_fop = &fat_file_operations;
 		inode->i_mapping->a_ops = &fat_aops;
-		MSDOS_I(inode)->mmu_private = inode->i_size;
 	}
+
+	MSDOS_I(inode)->mmu_private = inode->i_size;
+	MSDOS_I(inode)->i_disksize = round_up(inode->i_size, sbi->cluster_size);
+
 	if (de->attr & ATTR_SYS) {
 		if (sbi->options.sys_immutable)
 			inode->i_flags |= S_IMMUTABLE;
@@ -1293,6 +1299,7 @@ static int fat_read_root(struct inode *i
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 	MSDOS_I(inode)->i_logstart = 0;
 	MSDOS_I(inode)->mmu_private = inode->i_size;
+	MSDOS_I(inode)->i_disksize = round_up(inode->i_size, sbi->cluster_size);
 
 	fat_save_attrs(inode, ATTR_DIR);
 	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = 0;
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

linux-next.patch
fat-add-i_disksize-to-represent-uninitialized-size.patch
fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch

