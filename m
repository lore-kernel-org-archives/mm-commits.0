From: akpm@linux-foundation.org
Subject: + fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch
 added to -mm tree
Date: Wed, 12 Nov 2014 13:46:17 -0800
Message-ID: <5463d529.Xn4umhyVffZnUzez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaKLVqT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 16:46:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namjae.jeon@samsung.com, a.sahrawat@samsung.com, hirofumi@mail.parknet.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2
has been added to the -mm tree.  Its filename is
     fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch

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
@@ -508,11 +508,12 @@ int fat_setattr(struct dentry *dentry, s
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
@@ -333,7 +333,7 @@ static sector_t _fat_bmap(struct address
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

fat-add-fat_fallocate-operation.patch
fat-skip-cluster-allocation-on-fallocated-region.patch
fat-permit-to-return-phy-block-number-by-fibmap-in-fallocated-region.patch
documentation-filesystems-vfattxt-update-the-limitation-for-fat-fallocate.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite.patch
fat-fix-data-past-eof-resulting-from-fsx-testsuite-v2.patch

