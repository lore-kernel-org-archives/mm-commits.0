From: akpm@linux-foundation.org
Subject: + zram-fix-null-dereference-of-handle.patch added to -mm tree
Date: Mon, 25 Sep 2017 15:16:37 -0700
Message-ID: <59c98045.olse0Du16ETMS/Bl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935505AbdIYWQl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 25 Sep 2017 18:16:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky.work@gmail.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix null dereference of handle
has been added to the -mm tree.  Its filename is
     zram-fix-null-dereference-of-handle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-null-dereference-of-handle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-null-dereference-of-handle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: fix null dereference of handle

In testing I found handle passed to zs_map_object in __zram_bvec_read is
NULL so eh kernel goes oops in pin_object().

The reason is there is no routine to check the slot's freeing after
getting the slot's lock.  This patch fixes it.

Link: http://lkml.kernel.org/r/1505788488-26723-1-git-send-email-minchan@kernel.org
Fixes: 1f7319c74275 ("zram: partial IO refactoring")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   34 +++++++++-----------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

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
@@ -884,11 +863,18 @@ static int __zram_bvec_read(struct zram
 		zram_slot_unlock(zram, index);
 	}
 
-	if (zram_same_page_read(zram, index, page, 0, PAGE_SIZE))
-		return 0;
