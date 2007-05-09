From: akpm@linux-foundation.org
Subject: - ext3-use-zero_user_page.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:52 -0700
Message-ID: <200705092153.l49LrqHf003118@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:57330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbXEIWI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:08:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ext3: use zero_user_page
has been removed from the -mm tree.  Its filename was
     ext3-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext3: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/inode.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff -puN fs/ext3/inode.c~ext3-use-zero_user_page fs/ext3/inode.c
--- a/fs/ext3/inode.c~ext3-use-zero_user_page
+++ a/fs/ext3/inode.c
@@ -1767,7 +1767,6 @@ static int ext3_block_truncate_page(hand
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
@@ -1779,10 +1778,7 @@ static int ext3_block_truncate_page(hand
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext3_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, length, KM_USER0);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1835,11 +1831,7 @@ static int ext3_block_truncate_page(hand
 			goto unlock;
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
-
+	zero_user_page(page, offset, length, KM_USER0);
 	BUFFER_TRACE(bh, "zeroed end of block");
 
 	err = 0;
_

Patches currently in -mm which might be from nate.diller@gmail.com are

origin.patch
cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
ecryptfs-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
xfs-use-zero_user_page.patch
reiser4.patch
reiser4-use-zero_user_page.patch
