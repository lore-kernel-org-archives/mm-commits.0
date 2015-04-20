From: akpm@linux-foundation.org
Subject: [merged]
 nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:41 -0700
Message-ID: <55355111.WS1oZj2KZy9LvjZv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbDTTMU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: use set_mask_bits() for operations on buffer state bitmap
has been removed from the -mm tree.  Its filename was
     nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: use set_mask_bits() for operations on buffer state bitmap

nilfs_forget_buffer(), nilfs_clear_dirty_page(), and
nilfs_segctor_complete_write() are using a bunch of atomic bit operations
against buffer state bitmap.

This reduces the number of them by utilizing set_mask_bits() macro.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/page.c    |   24 ++++++++++--------------
 fs/nilfs2/segment.c |   14 ++++++++------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff -puN fs/nilfs2/page.c~nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap fs/nilfs2/page.c
--- a/fs/nilfs2/page.c~nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap
+++ a/fs/nilfs2/page.c
@@ -89,18 +89,16 @@ struct buffer_head *nilfs_grab_buffer(st
 void nilfs_forget_buffer(struct buffer_head *bh)
 {
 	struct page *page = bh->b_page;
+	const unsigned long clear_bits =
+		(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
+		 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
+		 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
 
 	lock_buffer(bh);
-	clear_buffer_nilfs_volatile(bh);
-	clear_buffer_nilfs_checked(bh);
-	clear_buffer_nilfs_redirected(bh);
-	clear_buffer_async_write(bh);
-	clear_buffer_dirty(bh);
+	set_mask_bits(&bh->b_state, clear_bits, 0);
 	if (nilfs_page_buffers_clean(page))
 		__nilfs_clear_page_dirty(page);
 
-	clear_buffer_uptodate(bh);
-	clear_buffer_mapped(bh);
 	bh->b_blocknr = -1;
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
@@ -421,6 +419,10 @@ void nilfs_clear_dirty_page(struct page
 
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh, *head;
+		const unsigned long clear_bits =
+			(1 << BH_Uptodate | 1 << BH_Dirty | 1 << BH_Mapped |
+			 1 << BH_Async_Write | 1 << BH_NILFS_Volatile |
+			 1 << BH_NILFS_Checked | 1 << BH_NILFS_Redirected);
 
 		bh = head = page_buffers(page);
 		do {
@@ -430,13 +432,7 @@ void nilfs_clear_dirty_page(struct page
 					"discard block %llu, size %zu",
 					(u64)bh->b_blocknr, bh->b_size);
 			}
-			clear_buffer_async_write(bh);
-			clear_buffer_dirty(bh);
-			clear_buffer_nilfs_volatile(bh);
-			clear_buffer_nilfs_checked(bh);
-			clear_buffer_nilfs_redirected(bh);
-			clear_buffer_uptodate(bh);
-			clear_buffer_mapped(bh);
+			set_mask_bits(&bh->b_state, clear_bits, 0);
 			unlock_buffer(bh);
 		} while (bh = bh->b_this_page, bh != head);
 	}
diff -puN fs/nilfs2/segment.c~nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap fs/nilfs2/segment.c
--- a/fs/nilfs2/segment.c~nilfs2-use-set_mask_bits-for-operations-on-buffer-state-bitmap
+++ a/fs/nilfs2/segment.c
@@ -24,6 +24,7 @@
 #include <linux/pagemap.h>
 #include <linux/buffer_head.h>
 #include <linux/writeback.h>
+#include <linux/bitops.h>
 #include <linux/bio.h>
 #include <linux/completion.h>
 #include <linux/blkdev.h>
@@ -1785,12 +1786,13 @@ static void nilfs_segctor_complete_write
 		 */
 		list_for_each_entry(bh, &segbuf->sb_payload_buffers,
 				    b_assoc_buffers) {
-			set_buffer_uptodate(bh);
-			clear_buffer_dirty(bh);
-			clear_buffer_async_write(bh);
-			clear_buffer_delay(bh);
-			clear_buffer_nilfs_volatile(bh);
-			clear_buffer_nilfs_redirected(bh);
+			const unsigned long set_bits = (1 << BH_Uptodate);
+			const unsigned long clear_bits =
+				(1 << BH_Dirty | 1 << BH_Async_Write |
+				 1 << BH_Delay | 1 << BH_NILFS_Volatile |
+				 1 << BH_NILFS_Redirected);
+
+			set_mask_bits(&bh->b_state, clear_bits, set_bits);
 			if (bh == segbuf->sb_super_root) {
 				if (bh->b_page != bd_page) {
 					end_page_writeback(bd_page);
_

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are

origin.patch

