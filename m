From: akpm@linux-foundation.org
Subject: [patch 21/51] zram: fix null dereference of handle
Date: Tue, 03 Oct 2017 16:15:19 -0700
Message-ID: <59d41a07.IWMgZ4mDihA+5rOT%akpm__28930.0550743521$1507072526$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdJCXPV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky.work@gmail.com, stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: fix null dereference of handle

In testing I found handle passed to zs_map_object in __zram_bvec_read is
NULL so eh kernel goes oops in pin_object().

The reason is there is no routine to check the slot's freeing after
getting the slot's lock.  This patch fixes it.

[minchan@kernel.org: v2]
  Link: http://lkml.kernel.org/r/1505887347-10881-1-git-send-email-minchan@kernel.org
Link: http://lkml.kernel.org/r/1505788488-26723-1-git-send-email-minchan@kernel.org
Fixes: 1f7319c74275 ("zram: partial IO refactoring")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   36 ++++++++++----------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-null-dereference-of-handle drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-null-dereference-of-handle
+++ a/drivers/block/zram/zram_drv.c
@@ -766,27 +766,6 @@ static void zram_slot_unlock(struct zram
 	bit_spin_unlock(ZRAM_ACCESS, &zram->table[index].value);
 }
 
-static bool zram_same_page_read(struct zram *zram, u32 index,
-				struct page *page,
-				unsigned int offset, unsigned int len)
-{
-	zram_slot_lock(zram, index);
-	if (unlikely(!zram_get_handle(zram, index) ||
-			zram_test_flag(zram, index, ZRAM_SAME))) {
-		void *mem;
-
-		zram_slot_unlock(zram, index);
-		mem = kmap_atomic(page);
-		zram_fill_page(mem + offset, len,
-					zram_get_element(zram, index));
-		kunmap_atomic(mem);
-		return true;
-	}
-	zram_slot_unlock(zram, index);
-
-	return false;
-}
-
 static void zram_meta_free(struct zram *zram, u64 disksize)
 {
 	size_t num_pages = disksize >> PAGE_SHIFT;
@@ -884,11 +863,20 @@ static int __zram_bvec_read(struct zram
 		zram_slot_unlock(zram, index);
 	}
 
-	if (zram_same_page_read(zram, index, page, 0, PAGE_SIZE))
-		return 0;
