From: akpm@linux-foundation.org
Subject: - ext4-use-zero_user_page.patch removed from -mm tree
Date: Fri, 24 Aug 2007 20:24:17 -0700
Message-ID: <200708250324.l7P3OHUG027970@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56684 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982AbXHYDYU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 23:24:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ext4: use zero_user_page
has been removed from the -mm tree.  Its filename was
     ext4-use-zero_user_page.patch

This patch was dropped because it isn't in the present -mm lineup

------------------------------------------------------
Subject: ext4: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c     |   12 ++----------
 fs/ext4/writeback.c |   12 ++----------
 2 files changed, 4 insertions(+), 20 deletions(-)

diff -puN fs/ext4/inode.c~ext4-use-zero_user_page fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-use-zero_user_page
+++ a/fs/ext4/inode.c
@@ -1791,7 +1791,6 @@ int ext4_block_truncate_page(handle_t *h
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
 	int err = 0;
-	void *kaddr;
 
 	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) &&
 			test_opt(inode->i_sb, EXTENTS) &&
@@ -1808,10 +1807,7 @@ int ext4_block_truncate_page(handle_t *h
 	 */
 	if (!page_has_buffers(page) && test_opt(inode->i_sb, NOBH) &&
 	     ext4_should_writeback_data(inode) && PageUptodate(page)) {
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + offset, 0, length);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, offset, length, KM_USER0);
 		set_page_dirty(page);
 		goto unlock;
 	}
@@ -1864,11 +1860,7 @@ int ext4_block_truncate_page(handle_t *h
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
diff -puN fs/ext4/writeback.c~ext4-use-zero_user_page fs/ext4/writeback.c
--- a/fs/ext4/writeback.c~ext4-use-zero_user_page
+++ a/fs/ext4/writeback.c
@@ -971,7 +971,6 @@ int ext4_wb_writepage(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	wb_debug("writepage %lu from inode %lu\n", page->index, inode->i_ino);
 
@@ -1021,10 +1020,7 @@ int ext4_wb_writepage(struct page *page,
 	 * the  page size, the remaining memory is zeroed when mapped, and
 	 * writes to that region are not written out to the file."
 	 */
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, PAGE_CACHE_SIZE - offset);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, PAGE_CACHE_SIZE - offset, KM_USER0);
 	return ext4_wb_write_single_page(page, wbc);
 }
 
@@ -1075,7 +1071,6 @@ int ext4_wb_block_truncate_page(handle_t
 	struct inode *inode = mapping->host;
 	struct buffer_head bh, *bhw = &bh;
 	unsigned blocksize, length;
-	void *kaddr;
 	int err = 0;
 
 	wb_debug("partial truncate from %lu on page %lu from inode %lu\n",
@@ -1114,10 +1109,7 @@ int ext4_wb_block_truncate_page(handle_t
 		}
 	}
 
-	kaddr = kmap_atomic(page, KM_USER0);
-	memset(kaddr + offset, 0, length);
-	flush_dcache_page(page);
-	kunmap_atomic(kaddr, KM_USER0);
+	zero_user_page(page, offset, length, KM_USER0);
 	SetPageUptodate(page);
 	__set_page_dirty_nobuffers(page);
 
_

Patches currently in -mm which might be from nate.diller@gmail.com are

reiser4.patch
