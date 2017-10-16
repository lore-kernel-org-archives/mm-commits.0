From: akpm@linux-foundation.org
Subject: [merged] fix-mpage_writepage-for-pages-with-buffers.patch
 removed from -mm tree
Date: Mon, 16 Oct 2017 12:55:52 -0700
Message-ID: <20171016195552.XqN7D2tiB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55614 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755892AbdJPTzx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2017 15:55:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, jthumshirn@suse.de, mawilcox@microsoft.com, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, stable@vger.kernel.org, toshi.kani@hpe.com, willy@infradead.org


The patch titled
     Subject: fs/mpage.c: fix mpage_writepage() for pages with buffers
has been removed from the -mm tree.  Its filename was
     fix-mpage_writepage-for-pages-with-buffers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: fs/mpage.c: fix mpage_writepage() for pages with buffers

When using FAT on a block device which supports rw_page, we can hit
BUG_ON(!PageLocked(page)) in try_to_free_buffers().  This is because we
call clean_buffers() after unlocking the page we've written.  Introduce a
new clean_page_buffers() which cleans all buffers associated with a page
and call it from within bdev_write_page().

[akpm@linux-foundation.org: s/PAGE_SIZE/~0U/ per Linus and Matthew]
Link: http://lkml.kernel.org/r/20171006211541.GA7409@bombadil.infradead.org
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
Reported-by: Toshi Kani <toshi.kani@hpe.com>
Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Tested-by: Toshi Kani <toshi.kani@hpe.com>
Acked-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/block_dev.c              |    6 ++++--
 fs/mpage.c                  |   14 +++++++++++---
 include/linux/buffer_head.h |    1 +
 3 files changed, 16 insertions(+), 5 deletions(-)

diff -puN fs/block_dev.c~fix-mpage_writepage-for-pages-with-buffers fs/block_dev.c
--- a/fs/block_dev.c~fix-mpage_writepage-for-pages-with-buffers
+++ a/fs/block_dev.c
@@ -716,10 +716,12 @@ int bdev_write_page(struct block_device
 
 	set_page_writeback(page);
 	result = ops->rw_page(bdev, sector + get_start_sect(bdev), page, true);
-	if (result)
+	if (result) {
 		end_page_writeback(page);
-	else
+	} else {
+		clean_page_buffers(page);
 		unlock_page(page);
+	}
 	blk_queue_exit(bdev->bd_queue);
 	return result;
 }
diff -puN fs/mpage.c~fix-mpage_writepage-for-pages-with-buffers fs/mpage.c
--- a/fs/mpage.c~fix-mpage_writepage-for-pages-with-buffers
+++ a/fs/mpage.c
@@ -468,6 +468,16 @@ static void clean_buffers(struct page *p
 		try_to_free_buffers(page);
 }
 
+/*
+ * For situations where we want to clean all buffers attached to a page.
+ * We don't need to calculate how many buffers are attached to the page,
+ * we just need to specify a number larger than the maximum number of buffers.
+ */
+void clean_page_buffers(struct page *page)
+{
+	clean_buffers(page, ~0U);
+}
+
 static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 		      void *data)
 {
@@ -605,10 +615,8 @@ alloc_new:
 	if (bio == NULL) {
 		if (first_unmapped == blocks_per_page) {
 			if (!bdev_write_page(bdev, blocks[0] << (blkbits - 9),
-								page, wbc)) {
-				clean_buffers(page, first_unmapped);
+								page, wbc))
 				goto out;
-			}
 		}
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 				BIO_MAX_PAGES, GFP_NOFS|__GFP_HIGH);
diff -puN include/linux/buffer_head.h~fix-mpage_writepage-for-pages-with-buffers include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~fix-mpage_writepage-for-pages-with-buffers
+++ a/include/linux/buffer_head.h
@@ -232,6 +232,7 @@ int generic_write_end(struct file *, str
 				loff_t, unsigned, unsigned,
 				struct page *, void *);
 void page_zero_new_buffers(struct page *page, unsigned from, unsigned to);
+void clean_page_buffers(struct page *page);
 int cont_write_begin(struct file *, struct address_space *, loff_t,
 			unsigned, unsigned, struct page **, void **,
 			get_block_t *, loff_t *);
_

Patches currently in -mm which might be from willy@infradead.org are


