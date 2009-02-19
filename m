From: akpm@linux-foundation.org
Subject: [to-be-updated] cramfs-propagate-uncompression-errors.patch removed from -mm tree
Date: Thu, 19 Feb 2009 15:39:11 -0800
Message-ID: <200902192339.n1JNdBE5031149@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbZBSXjt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 18:39:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvomlehn@cisco.com, mm-commits@vger.kernel.org


The patch titled
     cramfs: propagate uncompression errors
has been removed from the -mm tree.  Its filename was
     cramfs-propagate-uncompression-errors.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cramfs: propagate uncompression errors
From: David VomLehn <dvomlehn@cisco.com>

If cramfs_uncompress_block() detects an error uncompressing it will return
a zero value.  This patch checks the return value and propagates the error
back up to the block layer.

Signed-off-by: David VomLehn <dvomlehn@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-propagate-uncompression-errors fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-propagate-uncompression-errors
+++ a/fs/cramfs/inode.c
@@ -475,25 +475,32 @@ static int cramfs_readpage(struct file *
 			start_offset = *(u32 *) cramfs_read(sb, blkptr_offset-4, 4);
 		compr_len = (*(u32 *) cramfs_read(sb, blkptr_offset, 4) - start_offset);
 		mutex_unlock(&read_mutex);
-		pgdata = kmap(page);
 		if (compr_len == 0)
-			; /* hole */
-		else if (compr_len > (PAGE_CACHE_SIZE << 1))
-			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
-		else {
-			mutex_lock(&read_mutex);
-			bytes_filled = cramfs_uncompress_block(pgdata,
-				 PAGE_CACHE_SIZE,
-				 cramfs_read(sb, start_offset, compr_len),
-				 compr_len);
-			mutex_unlock(&read_mutex);
+			goto out; /* hole */
+		if (compr_len > (PAGE_CACHE_SIZE << 1)) {
+			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n",
+					compr_len);
+			goto out;
 		}
-	} else
 		pgdata = kmap(page);
-	memset(pgdata + bytes_filled, 0, PAGE_CACHE_SIZE - bytes_filled);
-	kunmap(page);
-	flush_dcache_page(page);
-	SetPageUptodate(page);
+		mutex_lock(&read_mutex);
+		bytes_filled = cramfs_uncompress_block(pgdata, PAGE_CACHE_SIZE,
+			 cramfs_read(sb, start_offset, compr_len), compr_len);
+		mutex_unlock(&read_mutex);
+
+		if (bytes_filled == 0) {
+			/* Decompression error */
+			ClearPageUptodate(page);
+			SetPageError(page);
+		} else {
+			memset(pgdata + bytes_filled, 0,
+					PAGE_CACHE_SIZE - bytes_filled);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+		}
+		kunmap(page);
+	}
+out:
 	unlock_page(page);
 	return 0;
 }
_

Patches currently in -mm which might be from dvomlehn@cisco.com are

cramfs-propagate-uncompression-errors-v21.patch
cramfs-propagate-uncompression-errors.patch

