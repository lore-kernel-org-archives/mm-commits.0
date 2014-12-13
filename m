From: akpm@linux-foundation.org
Subject: [folded-merged]
 fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch removed from
 -mm tree
Date: Fri, 12 Dec 2014 16:46:13 -0800
Message-ID: <548b8c55.DJTlWoRQrNA1+nPx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbaLMAqO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:46:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2
has been removed from the -mm tree.  Its filename was
     fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch

This patch was dropped because it was folded into fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch

------------------------------------------------------
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/file.c  |    5 +++--
 fs/fat/inode.c |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN fs/fat/file.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2 fs/fat/file.c
--- a/fs/fat/file.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2
+++ a/fs/fat/file.c
@@ -505,11 +505,12 @@ int fat_setattr(struct dentry *dentry, s
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {
+		error = fat_block_truncate_page(inode, attr->ia_size);
+		if (error)
+			goto out;
 		down_write(&MSDOS_I(inode)->truncate_lock);
 		truncate_setsize(inode, attr->ia_size);
 		fat_truncate_blocks(inode, attr->ia_size);
-		if (inode->i_size & (inode->i_sb->s_blocksize - 1))
-			fat_block_truncate_page(inode, inode->i_size);
 		up_write(&MSDOS_I(inode)->truncate_lock);
 	}
 
diff -puN fs/fat/inode.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2 fs/fat/inode.c
--- a/fs/fat/inode.c~fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2
+++ a/fs/fat/inode.c
@@ -334,7 +334,7 @@ static sector_t _fat_bmap(struct address
 /*
  * fat_block_truncate_page() zeroes out a mapping from file offset `from'
  * up to the end of the block which corresponds to `from'.
- * This is required during truncate to physically zero out the tail end
+ * This is required during truncate to physically zeroout the tail end
  * of that block so it doesn't yield old data if the file is later grown.
  * Also, avoid causing failure from fsx for cases of "data past EOF"
  */
_

Patches currently in -mm which might be from namjae.jeon@samsung.com are

origin.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch

