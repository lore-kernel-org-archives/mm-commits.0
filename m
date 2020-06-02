From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 042/128] fs/buffer.c: use
 attach/detach_page_private
Date: Mon, 01 Jun 2020 21:47:48 -0700
Message-ID: <20200602044748.KgHRPaSqS%akpm@linux-foundation.org>
References: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgFBErt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:47:49 -0400
In-Reply-To: <20200601214457.919c35648e96a2b46b573fe1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guoqing.jiang@cloud.ionos.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: fs/buffer.c: use attach/detach_page_private

Since the new pair function is introduced, we can call them to clean the
code in buffer.c.

Link: http://lkml.kernel.org/r/20200517214718.468-5-guoqing.jiang@cloud.ionos.com
Signed-off-by: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/fs/buffer.c~fs-bufferc-use-attach-detach_page_private
+++ a/fs/buffer.c
@@ -123,14 +123,6 @@ void __wait_on_buffer(struct buffer_head
 }
 EXPORT_SYMBOL(__wait_on_buffer);
 
-static void
-__clear_page_buffers(struct page *page)
-{
-	ClearPagePrivate(page);
-	set_page_private(page, 0);
-	put_page(page);
-}
-
 static void buffer_io_error(struct buffer_head *bh, char *msg)
 {
 	if (!test_bit(BH_Quiet, &bh->b_state))
@@ -906,7 +898,7 @@ link_dev_buffers(struct page *page, stru
 		bh = bh->b_this_page;
 	} while (bh);
 	tail->b_this_page = head;
-	attach_page_buffers(page, head);
+	attach_page_private(page, head);
 }
 
 static sector_t blkdev_max_block(struct block_device *bdev, unsigned int size)
@@ -1587,7 +1579,7 @@ void create_empty_buffers(struct page *p
 			bh = bh->b_this_page;
 		} while (bh != head);
 	}
-	attach_page_buffers(page, head);
+	attach_page_private(page, head);
 	spin_unlock(&page->mapping->private_lock);
 }
 EXPORT_SYMBOL(create_empty_buffers);
@@ -2574,7 +2566,7 @@ static void attach_nobh_buffers(struct p
 			bh->b_this_page = head;
 		bh = bh->b_this_page;
 	} while (bh != head);
-	attach_page_buffers(page, head);
+	attach_page_private(page, head);
 	spin_unlock(&page->mapping->private_lock);
 }
 
@@ -3234,7 +3226,7 @@ drop_buffers(struct page *page, struct b
 		bh = next;
 	} while (bh != head);
 	*buffers_to_free = head;
-	__clear_page_buffers(page);
+	detach_page_private(page);
 	return 1;
 failed:
 	return 0;
_
