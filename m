From: akpm@linux-foundation.org
Subject: [folded-merged] fs-add-i_blocksize-fix.patch removed from -mm
 tree
Date: Mon, 27 Feb 2017 14:19:20 -0800
Message-ID: <58b4a5e8.kjo9+cV4hPgzqLOn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43690 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751837AbdB0WT1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:19:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geliangtang@gmail.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: truncate: use i_blocksize()
has been removed from the -mm tree.  Its filename was
     fs-add-i_blocksize-fix.patch

This patch was dropped because it was folded into fs-add-i_blocksize.patch

------------------------------------------------------
From: Geliang Tang <geliangtang@gmail.com>
Subject: truncate: use i_blocksize()

Since i_blocksize() helper has been defined in fs.h, use it instead
of open-coding.

Link: http://lkml.kernel.org/r/9c8b2cd83c8f5653805d43debde9fa8817e02fc4.1484895804.git.geliangtang@gmail.com
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/truncate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/truncate.c~fs-add-i_blocksize-fix mm/truncate.c
--- a/mm/truncate.c~fs-add-i_blocksize-fix
+++ a/mm/truncate.c
@@ -786,7 +786,7 @@ EXPORT_SYMBOL(truncate_setsize);
  */
 void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 {
-	int bsize = 1 << inode->i_blkbits;
+	int bsize = i_blocksize(inode);
 	loff_t rounded_from;
 	struct page *page;
 	pgoff_t index;
_

Patches currently in -mm which might be from geliangtang@gmail.com are

fs-add-i_blocksize.patch
nilfs2-use-nilfs_btree_node_size.patch
nilfs2-use-i_blocksize.patch

