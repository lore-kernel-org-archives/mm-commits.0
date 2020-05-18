From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
 added to -mm tree
Date: Mon, 18 May 2020 14:46:10 -0700
Message-ID: <20200518214610.NfWrJE_jn%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726250AbgERVqL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 May 2020 17:46:11 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guoqing.jiang@cloud.ionos.com, mm-commits@vger.kernel.org, song@kernel.org


The patch titled
     Subject: md: remove __clear_page_buffers and use attach/detach_page_private
has been added to the -mm tree.  Its filename is
     md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

include-linux-pagemaph-introduce-attach-detach_page_private.patch
md-remove-__clear_page_buffers-and-use-attach-detach_page_private.patch
btrfs-use-attach-detach_page_private.patch
fs-bufferc-use-attach-detach_page_private.patch
f2fs-use-attach-detach_page_private.patch
iomap-use-attach-detach_page_private.patch
ntfs-replace-attach_page_buffers-with-attach_page_private.patch
orangefs-use-attach-detach_page_private.patch
buffer_headh-remove-attach_page_buffers.patch
mm-migratec-call-detach_page_private-to-cleanup-code.patch
