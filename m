From: akpm@linux-foundation.org
Subject: [merged] cramfs-propagate-uncompression-errors-v21.patch removed from -mm tree
Date: Mon, 06 Apr 2009 12:37:49 -0700
Message-ID: <200904061937.n36JbnCY013120@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbZDFTt2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Apr 2009 15:49:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvomlehn@cisco.com, mm-commits@vger.kernel.org


The patch titled
     cramfs: propagate uncompression errors
has been removed from the -mm tree.  Its filename was
     cramfs-propagate-uncompression-errors-v21.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: propagate uncompression errors
From: David VomLehn <dvomlehn@cisco.com>

Decompression errors can arise due to corruption of compressed blocks on
flash or in memory.  This patch propagates errors detected during
decompression back to the block layer.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c      |   36 ++++++++++++++++++++++++++----------
 fs/cramfs/uncompress.c |    2 +-
 2 files changed, 27 insertions(+), 11 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-propagate-uncompression-errors-v21 fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-propagate-uncompression-errors-v21
+++ a/fs/cramfs/inode.c
@@ -459,11 +459,14 @@ static struct dentry * cramfs_lookup(str
 static int cramfs_readpage(struct file *file, struct page * page)
 {
 	struct inode *inode = page->mapping->host;
-	u32 maxblock, bytes_filled;
+	u32 maxblock;
+	int bytes_filled;
 	void *pgdata;
 
 	maxblock = (inode->i_size + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	bytes_filled = 0;
+	pgdata = kmap(page);
+
 	if (page->index < maxblock) {
 		struct super_block *sb = inode->i_sb;
 		u32 blkptr_offset = OFFSET(inode) + page->index*4;
@@ -472,30 +475,43 @@ static int cramfs_readpage(struct file *
 		start_offset = OFFSET(inode) + maxblock*4;
 		mutex_lock(&read_mutex);
 		if (page->index)
-			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
-		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
+			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4,
+				4);
+		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) -
+			start_offset);
 		mutex_unlock(&read_mutex);
-		pgdata = kmap(page);
+
 		if (compr_len == 0)
 			; /* hole */
-		else if (compr_len > (PAGE_CACHE_SIZE << 1))
-			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
-		else {
+		else if (unlikely(compr_len > (PAGE_CACHE_SIZE << 1))) {
+			pr_err("cramfs: bad compressed blocksize %u\n",
+				compr_len);
+			goto err;
+		} else {
 			mutex_lock(&read_mutex);
 			bytes_filled = cramfs_uncompress_block(pgdata,
 				 PAGE_CACHE_SIZE,
 				 cramfs_read(sb, start_offset, compr_len),
 				 compr_len);
 			mutex_unlock(&read_mutex);
+			if (unlikely(bytes_filled < 0))
+				goto err;
 		}
-	} else
-		pgdata = kmap(page);
+	}
+
 	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
-	kunmap(page);
 	flush_dcache_page(page);
+	kunmap(page);
 	SetPageUptodate(page);
 	unlock_page(page);
 	return 0;
+
+err:
+	kunmap(page);
+	ClearPageUptodate(page);
+	SetPageError(page);
+	unlock_page(page);
+	return 0;
 }
 
 static const struct address_space_operations cramfs_aops = {
diff -puN fs/cramfs/uncompress.c~cramfs-propagate-uncompression-errors-v21 fs/cramfs/uncompress.c
--- a/fs/cramfs/uncompress.c~cramfs-propagate-uncompression-errors-v21
+++ a/fs/cramfs/uncompress.c
@@ -50,7 +50,7 @@ int cramfs_uncompress_block(void *dst, i
 err:
 	printk("Error %d while decompressing!\n", err);
 	printk("%p(%d)->%p(%d)\n", src, srclen, dst, dstlen);
-	return 0;
+	return -EIO;
 }
 
 int cramfs_uncompress_init(void)
_

Patches currently in -mm which might be from dvomlehn@cisco.com are

origin.patch
linux-next.patch

