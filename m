From: akpm@linux-foundation.org
Subject: [merged] hfsplus-fix-concurrent-acess-of-alloc_blocks.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:36:41 -0700
Message-ID: <533f09c9.XTYLFwitjKr7WdjS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbaDDTgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slava@dubeyko.com, khoroshilov@ispras.ru, hch@lst.de, sougata@tuxera.com

Subject: [merged] hfsplus-fix-concurrent-acess-of-alloc_blocks.patch removed from -mm tree
To: sougata@tuxera.com,hch@lst.de,khoroshilov@ispras.ru,slava@dubeyko.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:36:41 -0700


The patch titled
     Subject: fs/hfsplus/extents.c: fix concurrent acess of alloc_blocks
has been removed from the -mm tree.  Its filename was
     hfsplus-fix-concurrent-acess-of-alloc_blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sougata Santra <sougata@tuxera.com>
Subject: fs/hfsplus/extents.c: fix concurrent acess of alloc_blocks

Concurrent access to alloc_blocks in hfsplus_inode_info() is protected by
extents_lock mutex.  This patch fixes two instances where alloc_blocks
modification was not protected with this lock.  This fixes possible
allocation bitmap corruption in race conditions while extending and
truncating files.

[akpm@linux-foundation.org: take extents_lock before taking a copy of ->alloc_blocks]
[akpm@linux-foundation.org: remove now-unused label `out']
Signed-off-by: Sougata Santra <sougata@tuxera.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/extents.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff -puN fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks fs/hfsplus/extents.c
--- a/fs/hfsplus/extents.c~hfsplus-fix-concurrent-acess-of-alloc_blocks
+++ a/fs/hfsplus/extents.c
@@ -496,11 +496,13 @@ int hfsplus_file_extend(struct inode *in
 			goto insert_extent;
 	}
 out:
-	mutex_unlock(&hip->extents_lock);
 	if (!res) {
 		hip->alloc_blocks += len;
+		mutex_unlock(&hip->extents_lock);
 		hfsplus_mark_inode_dirty(inode, HFSPLUS_I_ALLOC_DIRTY);
+		return 0;
 	}
+	mutex_unlock(&hip->extents_lock);
 	return res;
 
 insert_extent:
@@ -554,11 +556,13 @@ void hfsplus_file_truncate(struct inode
 
 	blk_cnt = (inode->i_size + HFSPLUS_SB(sb)->alloc_blksz - 1) >>
 			HFSPLUS_SB(sb)->alloc_blksz_shift;
+
+	mutex_lock(&hip->extents_lock);
+
 	alloc_cnt = hip->alloc_blocks;
 	if (blk_cnt == alloc_cnt)
-		goto out;
+		goto out_unlock;
 
-	mutex_lock(&hip->extents_lock);
 	res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
 	if (res) {
 		mutex_unlock(&hip->extents_lock);
@@ -590,10 +594,10 @@ void hfsplus_file_truncate(struct inode
 		hfs_brec_remove(&fd);
 	}
 	hfs_find_exit(&fd);
-	mutex_unlock(&hip->extents_lock);
 
 	hip->alloc_blocks = blk_cnt;
-out:
+out_unlock:
+	mutex_unlock(&hip->extents_lock);
 	hip->phys_size = inode->i_size;
 	hip->fs_blocks = (inode->i_size + sb->s_blocksize - 1) >>
 		sb->s_blocksize_bits;
_

Patches currently in -mm which might be from sougata@tuxera.com are

origin.patch
hfsplus-fix-longname-handling.patch

