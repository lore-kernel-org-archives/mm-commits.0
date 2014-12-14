From: akpm@linux-foundation.org
Subject: [merged] fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch removed from -mm tree
Date: Sat, 13 Dec 2014 20:09:14 -0800
Message-ID: <548d0d6a.IQanI6wYV4p9oSyj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbaLNEJH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:09:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix data past EOF resulting from fsx testsuite
has been removed from the -mm tree.  Its filename was
     fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat: fix data past EOF resulting from fsx testsuite

When running FSX with direct I/O mode, fsx resulted in DATA past EOF issues.

fsx ./file2 -Z -r 4096 -w 4096
...
..
truncating to largest ever: 0x907c
fallocating to largest ever: 0x11137
truncating to largest ever: 0x2c6fe
truncating to largest ever: 0x2cfdf
fallocating to largest ever: 0x40000
Mapped Read: non-zero data past EOF (0x18628) page offset 0x629 is 0x2a4e
...
..

The reason being, it is doing a truncate down, but the zeroing does not
happen on the last block boundary when offset is not aligned.  Even though
it calls truncate_setsize()->truncate_inode_pages()->
truncate_inode_pages_range() and considers the partial zeroout but it
retrieves the page using find_lock_page() - which only looks the page in
the cache.  So, zeroing out does not happen in case of direct IO.

Make a truncate page based around block_truncate_page for FAT filesystem
and invoke that helper to zerout in case the offset is not aligned with
the blocksize.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 +
 fs/fat/file.c  |    3 +++
 fs/fat/inode.c |   12 ++++++++++++
 3 files changed, 16 insertions(+)

diff -puN fs/fat/fat.h~fat-fix-data-past-eof-resulting-from-fsx-testsuite fs/fat/fat.h
--- a/fs/fat/fat.h~fat-fix-data-past-eof-resulting-from-fsx-testsuite
+++ a/fs/fat/fat.h
@@ -370,6 +370,7 @@ extern int fat_file_fsync(struct file *f
 			  int datasync);
 
 /* fat/inode.c */
+extern int fat_block_truncate_page(struct inode *inode, loff_t from);
 extern void fat_attach(struct inode *inode, loff_t i_pos);
 extern void fat_detach(struct inode *inode);
 extern struct inode *fat_iget(struct super_block *sb, loff_t i_pos);
diff -puN fs/fat/file.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite fs/fat/file.c
--- a/fs/fat/file.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite
+++ a/fs/fat/file.c
@@ -443,6 +443,9 @@ int fat_setattr(struct dentry *dentry, s
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
+		error = fat_block_truncate_page(inode, attr->ia_size);
+		if (error)
+			goto out;
 		down_write(&MSDOS_I(inode)->truncate_lock);
 		truncate_setsize(inode, attr->ia_size);
 		fat_truncate_blocks(inode, attr->ia_size);
diff -puN fs/fat/inode.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite
+++ a/fs/fat/inode.c
@@ -294,6 +294,18 @@ static sector_t _fat_bmap(struct address
 	return blocknr;
 }
 
+/*
+ * fat_block_truncate_page() zeroes out a mapping from file offset `from'
+ * up to the end of the block which corresponds to `from'.
+ * This is required during truncate to physically zeroout the tail end
+ * of that block so it doesn't yield old data if the file is later grown.
+ * Also, avoid causing failure from fsx for cases of "data past EOF"
+ */
+int fat_block_truncate_page(struct inode *inode, loff_t from)
+{
+	return block_truncate_page(inode->i_mapping, from, fat_get_block);
+}
+
 static const struct address_space_operations fat_aops = {
 	.readpage	= fat_readpage,
 	.readpages	= fat_readpages,
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch
linux-next.patch

