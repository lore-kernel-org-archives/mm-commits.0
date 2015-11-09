From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-add-helper-functions-to-delete-blocks-from-dat-file.patch removed
 from -mm tree
Date: Mon, 09 Nov 2015 12:13:08 -0800
Message-ID: <5640fe54.Lf2nXxb9DkLhn802%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbKIUNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: add helper functions to delete blocks from dat file
has been removed from the -mm tree.  Its filename was
     nilfs2-add-helper-functions-to-delete-blocks-from-dat-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: add helper functions to delete blocks from dat file

This adds delete functions for data blocks of metadata files using bitmap
based allocator.  nilfs_palloc_delete_entry_block() deletes an entry block
(e.g.  block storing dat entries), and nilfs_palloc_delete_bitmap_block()
deletes a bitmap block, respectively.

These helpers are intended to be used in the successive change on
deallocator of block addresses ("nilfs2: free unused dat file blocks
during garbage collection").

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c |   50 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff -puN fs/nilfs2/alloc.c~nilfs2-add-helper-functions-to-delete-blocks-from-dat-file fs/nilfs2/alloc.c
--- a/fs/nilfs2/alloc.c~nilfs2-add-helper-functions-to-delete-blocks-from-dat-file
+++ a/fs/nilfs2/alloc.c
@@ -236,6 +236,26 @@ static int nilfs_palloc_get_block(struct
 }
 
 /**
+ * nilfs_palloc_delete_block - delete a block on the persistent allocator file
+ * @inode: inode of metadata file using this allocator
+ * @blkoff: block offset
+ * @prev: nilfs_bh_assoc struct of the last used buffer
+ * @lock: spin lock protecting @prev
+ */
+static int nilfs_palloc_delete_block(struct inode *inode, unsigned long blkoff,
+				     struct nilfs_bh_assoc *prev,
+				     spinlock_t *lock)
+{
+	spin_lock(lock);
+	if (prev->bh && blkoff == prev->blkoff) {
+		brelse(prev->bh);
+		prev->bh = NULL;
+	}
+	spin_unlock(lock);
+	return nilfs_mdt_delete_block(inode, blkoff);
+}
+
+/**
  * nilfs_palloc_get_desc_block - get buffer head of a group descriptor block
  * @inode: inode of metadata file using this allocator
  * @group: group number
@@ -274,6 +294,22 @@ static int nilfs_palloc_get_bitmap_block
 }
 
 /**
+ * nilfs_palloc_delete_bitmap_block - delete a bitmap block
+ * @inode: inode of metadata file using this allocator
+ * @group: group number
+ */
+static int nilfs_palloc_delete_bitmap_block(struct inode *inode,
+					    unsigned long group)
+{
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	return nilfs_palloc_delete_block(inode,
+					 nilfs_palloc_bitmap_blkoff(inode,
+								    group),
+					 &cache->prev_bitmap, &cache->lock);
+}
+
+/**
  * nilfs_palloc_get_entry_block - get buffer head of an entry block
  * @inode: inode of metadata file using this allocator
  * @nr: serial number of the entry (e.g. inode number)
@@ -292,6 +328,20 @@ int nilfs_palloc_get_entry_block(struct
 }
 
 /**
+ * nilfs_palloc_delete_entry_block - delete an entry block
+ * @inode: inode of metadata file using this allocator
+ * @nr: serial number of the entry
+ */
+static int nilfs_palloc_delete_entry_block(struct inode *inode, __u64 nr)
+{
+	struct nilfs_palloc_cache *cache = NILFS_MDT(inode)->mi_palloc_cache;
+
+	return nilfs_palloc_delete_block(inode,
+					 nilfs_palloc_entry_blkoff(inode, nr),
+					 &cache->prev_entry, &cache->lock);
+}
+
+/**
  * nilfs_palloc_block_get_group_desc - get kernel address of a group descriptor
  * @inode: inode of metadata file using this allocator
  * @group: group number
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


