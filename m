From: akpm@linux-foundation.org
Subject: + fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch added
 to -mm tree
Date: Thu, 30 Oct 2014 15:29:31 -0700
Message-ID: <5452bbcb.7QaN21CKftCLLZIL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41494 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161035AbaJ3W3a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 Oct 2014 18:29:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat: fix data past EOF resulting from fsx testsuite
has been added to the -mm tree.  Its filename is
     fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch

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
Subject: fat: fix data past EOF resulting from fsx testsuite

When running FSX with direct I/O mode, fsx resulted in DATA past EOF
issues.

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
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h   |    1 +
 fs/fat/file.c  |    2 ++
 fs/fat/inode.c |   12 ++++++++++++
 3 files changed, 15 insertions(+)

diff -puN fs/fat/fat.h~fat-fix-data-past-eof-resulting-from-fsx-testsuite fs/fat/fat.h
--- a/fs/fat/fat.h~fat-fix-data-past-eof-resulting-from-fsx-testsuite
+++ a/fs/fat/fat.h
@@ -373,6 +373,7 @@ extern int fat_file_fsync(struct file *f
 			  int datasync);
 
 /* fat/inode.c */
+extern int fat_block_truncate_page(struct inode *inode, loff_t from);
 extern void fat_attach(struct inode *inode, loff_t i_pos);
 extern void fat_detach(struct inode *inode);
 extern struct inode *fat_iget(struct super_block *sb, loff_t i_pos);
diff -puN fs/fat/file.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite fs/fat/file.c
--- a/fs/fat/file.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite
+++ a/fs/fat/file.c
@@ -511,6 +511,8 @@ int fat_setattr(struct dentry *dentry, s
 		down_write(&MSDOS_I(inode)->truncate_lock);
 		truncate_setsize(inode, attr->ia_size);
 		fat_truncate_blocks(inode, attr->ia_size);
+		if (inode->i_size & (inode->i_sb->s_blocksize - 1))
+			fat_block_truncate_page(inode, inode->i_size);
 		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 
diff -puN fs/fat/inode.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite
+++ a/fs/fat/inode.c
@@ -330,6 +330,18 @@ static sector_t _fat_bmap(struct address
 	return blocknr;
 }
 
+/*
+ * fat_block_truncate_page() zeroes out a mapping from file offset `from'
+ * up to the end of the block which corresponds to `from'.
+ * This is required during truncate to physically zero out the tail end
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

fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch

