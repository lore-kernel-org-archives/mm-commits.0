From: akpm@linux-foundation.org
Subject: [merged]
 md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
 removed from -mm tree
Date: Tue, 02 Jun 2020 14:39:23 -0700
Message-ID: <20200602213923.7UufYt9mO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726320AbgFBVjY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 17:39:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guoqing.jiang@cloud.ionos.com, mm-commits@vger.kernel.org, song@kernel.org


The patch titled
     Subject: md: remove __clear_page_buffers and use attach/detach_page_private
has been removed from the -mm tree.  Its filename was
     md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: md: remove __clear_page_buffers and use attach/detach_page_private

After introduction attach/detach_page_private in pagemap.h, we can remove
the duplicated code and call the new functions.

Link: http://lkml.kernel.org/r/20200517214718.468-3-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/md-bitmap.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/md/md-bitmap.c~md-remove-__clear_page_buffers-and-use-attach-detach_page_private
+++ a/drivers/md/md-bitmap.c
@@ -324,14 +324,6 @@ static void end_bitmap_write(struct buff
 		wake_up(&bitmap->write_wait);
 }
 
-/* copied from buffer.c */
-static void
-__clear_page_buffers(struct page *page)
-{
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
-}
 static void free_buffers(struct page *page)
 {
 	struct buffer_head *bh;
@@ -345,7 +337,7 @@ static void free_buffers(struct page *pa
 		free_buffer_head(bh);
 		bh = next;
 	}
-	__clear_page_buffers(page);
+	detach_page_private(page);
 	put_page(page);
 }
 
@@ -374,7 +366,7 @@ static int read_page(struct file *file,
 		ret = -ENOMEM;
 		goto out;
 	}
-	attach_page_buffers(page, bh);
+	attach_page_private(page, bh);
 	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		block = blk_cur;
_

Patches currently in -mm which might be from guoqing.jiang@cloud.ionos.com are
