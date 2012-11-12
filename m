From: akpm@linux-foundation.org
Subject: [merged] drbd-use-copy_highpage.patch removed from -mm tree
Date: Mon, 12 Nov 2012 13:09:52 -0800
Message-ID: <20121112210953.0F74A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:40174 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab2KLVJy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Nov 2012 16:09:54 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt11so429096wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Nov 2012 13:09:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, drbd-dev@lists.linbit.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drbd: use copy_highpage
has been removed from the -mm tree.  Its filename was
     drbd-use-copy_highpage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: drbd: use copy_highpage

Use copy_highpage() to copy from one page to another.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/drbd/drbd_bitmap.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/block/drbd/drbd_bitmap.c~drbd-use-copy_highpage drivers/block/drbd/drbd_bitmap.c
--- a/drivers/block/drbd/drbd_bitmap.c~drbd-use-copy_highpage
+++ a/drivers/block/drbd/drbd_bitmap.c
@@ -977,13 +977,8 @@ static void bm_page_io_async(struct bm_a
 	bm_set_page_unchanged(b->bm_pages[page_nr]);
 
 	if (ctx->flags & BM_AIO_COPY_PAGES) {
-		void *src, *dest;
 		page = mempool_alloc(drbd_md_io_page_pool, __GFP_HIGHMEM|__GFP_WAIT);
-		dest = kmap_atomic(page);
-		src = kmap_atomic(b->bm_pages[page_nr]);
-		memcpy(dest, src, PAGE_SIZE);
-		kunmap_atomic(src);
-		kunmap_atomic(dest);
+		copy_highpage(page, b->bm_pages[page_nr]);
 		bm_store_page_idx(page, page_nr);
 	} else
 		page = b->bm_pages[page_nr];
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch

