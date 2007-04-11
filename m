From: akpm@linux-foundation.org
Subject: + ext4-use-zero_user_page.patch added to -mm tree
Date: Tue, 10 Apr 2007 23:17:55 -0700
Message-ID: <200704110617.l3B6HtBK030116@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161221AbXDKGSA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 02:18:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nate.diller@gmail.com


The patch titled
     ext4: use zero_user_page
has been added to the -mm tree.  Its filename is
     ext4-use-zero_user_page.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -961,7 +961,6 @@ int ext4_wb_writepage(struct page *page,
 	loff_t i_size = i_size_read(inode);
 	pgoff_t end_index = i_size >> PAGE_CACHE_SHIFT;
 	unsigned offset;
-	void *kaddr;
 
 	wb_debug("writepage %lu from inode %lu\n", page->index, inode->i_ino);
 
@@ -1011,10 +1010,7 @@ int ext4_wb_writepage(struct page *page,
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
 
@@ -1065,7 +1061,6 @@ int ext4_wb_block_truncate_page(handle_t
 	struct inode *inode = mapping->host;
 	struct buffer_head bh, *bhw = &bh;
 	unsigned blocksize, length;
-	void *kaddr;
 	int err = 0;
 
 	wb_debug("partial truncate from %lu on page %lu from inode %lu\n",
@@ -1104,10 +1099,7 @@ int ext4_wb_block_truncate_page(handle_t
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

cifs-use-simple_prepare_write-to-zero-page-data.patch
ext4-use-simple_prepare_write-to-zero-page-data.patch
fs-convert-core-functions-to-zero_user_page.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
affs-use-zero_user_page.patch
ecryptfs-use-zero_user_page.patch
ext3-use-zero_user_page.patch
ext4-use-zero_user_page.patch
gfs2-use-zero_user_page.patch
nfs-use-zero_user_page.patch
ntfs-use-zero_user_page.patch
ocfs2-use-zero_user_page.patch
reiserfs-use-zero_user_page.patch
xfs-use-zero_user_page.patch
fs-deprecate-memclear_highpage_flush.patch
reiser4-use-zero_user_page.patch
reiser4-use-simple_prepare_write-to-zero-page-data.patch
