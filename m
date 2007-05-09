From: akpm@linux-foundation.org
Subject: - reiserfs-use-zero_user_page.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:54 -0700
Message-ID: <200705092153.l49Lrskq003121@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758944AbXEIVyN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nate.diller@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: use zero_user_page
has been removed from the -mm tree.  Its filename was
     reiserfs-use-zero_user_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: reiserfs: use zero_user_page
From: Nate Diller <nate.diller@gmail.com>

Use zero_user_page() instead of open-coding it.

Signed-off-by: Nate Diller <nate.diller@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/file.c  |   39 +++++++++++----------------------------
 fs/reiserfs/inode.c |   13 ++-----------
 2 files changed, 13 insertions(+), 39 deletions(-)

diff -puN fs/reiserfs/file.c~reiserfs-use-zero_user_page fs/reiserfs/file.c
--- a/fs/reiserfs/file.c~reiserfs-use-zero_user_page
+++ a/fs/reiserfs/file.c
@@ -1059,20 +1059,12 @@ static int reiserfs_prepare_file_region_
 	   maping blocks, since there is none, so we just zero out remaining
 	   parts of first and last pages in write area (if needed) */
 	if ((pos & ~((loff_t) PAGE_CACHE_SIZE - 1)) > inode->i_size) {
-		if (from != 0) {	/* First page needs to be partially zeroed */
-			char *kaddr = kmap_atomic(prepared_pages[0], KM_USER0);
-			memset(kaddr, 0, from);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(prepared_pages[0]);
-		}
-		if (to != PAGE_CACHE_SIZE) {	/* Last page needs to be partially zeroed */
-			char *kaddr =
-			    kmap_atomic(prepared_pages[num_pages - 1],
-					KM_USER0);
-			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
-			kunmap_atomic(kaddr, KM_USER0);
-			flush_dcache_page(prepared_pages[num_pages - 1]);
-		}
+		if (from != 0)		/* First page needs to be partially zeroed */
+			zero_user_page(prepared_pages[0], 0, from, KM_USER0);
+
+		if (to != PAGE_CACHE_SIZE)	/* Last page needs to be partially zeroed */
+			zero_user_page(prepared_pages[num_pages-1], to,
+					PAGE_CACHE_SIZE - to, KM_USER0);
 
 		/* Since all blocks are new - use already calculated value */
 		return blocks;
@@ -1199,13 +1191,9 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					char *kaddr =
-					    kmap_atomic(prepared_pages[0],
-							KM_USER0);
-					memset(kaddr + block_start, 0,
-					       from - block_start);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(prepared_pages[0]);
+					zero_user_page(prepared_pages[0],
+						       block_start,
+						       from - block_start, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 			}
@@ -1237,13 +1225,8 @@ static int reiserfs_prepare_file_region_
 					ll_rw_block(READ, 1, &bh);
 					*wait_bh++ = bh;
 				} else {	/* Not mapped, zero it */
-					char *kaddr =
-					    kmap_atomic(prepared_pages
-							[num_pages - 1],
-							KM_USER0);
-					memset(kaddr + to, 0, block_end - to);
-					kunmap_atomic(kaddr, KM_USER0);
-					flush_dcache_page(prepared_pages[num_pages - 1]);
+					zero_user_page(prepared_pages[num_pages-1],
+							to, block_end - to, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 			}
diff -puN fs/reiserfs/inode.c~reiserfs-use-zero_user_page fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~reiserfs-use-zero_user_page
+++ a/fs/reiserfs/inode.c
@@ -2148,13 +2148,8 @@ int reiserfs_truncate_file(struct inode 
 		length = offset & (blocksize - 1);
 		/* if we are not on a block boundary */
 		if (length) {
-			char *kaddr;
-
 			length = blocksize - length;
-			kaddr = kmap_atomic(page, KM_USER0);
-			memset(kaddr + offset, 0, length);
-			flush_dcache_page(page);
-			kunmap_atomic(kaddr, KM_USER0);
+			zero_user_page(page, offset, length, KM_USER0);
 			if (buffer_mapped(bh) && bh->b_blocknr != 0) {
 				mark_buffer_dirty(bh);
 			}
@@ -2370,7 +2365,6 @@ static int reiserfs_write_full_page(stru
 	 ** last byte in the file
 	 */
 	if (page->index >= end_index) {
-		char *kaddr;
 		unsigned last_offset;
 
 		last_offset = inode->i_size & (PAGE_CACHE_SIZE - 1);
@@ -2379,10 +2373,7 @@ static int reiserfs_write_full_page(stru
 			unlock_page(page);
 			return 0;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr + last_offset, 0, PAGE_CACHE_SIZE - last_offset);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, last_offset, PAGE_CACHE_SIZE - last_offset, KM_USER0);
 	}
 	bh = head;
 	block = page->index << (PAGE_CACHE_SHIFT - s->s_blocksize_bits);
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
