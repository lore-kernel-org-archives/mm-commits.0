From: akpm@linux-foundation.org
Subject: [patch 036/108] zram: count same page write as page_stored
Date: Thu, 06 Jul 2017 15:37:12 -0700
Message-ID: <20170706223712.KA8t9mZ3z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34998 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751723AbdGFWhN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:37:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: count same page write as page_stored

Regardless of whether it is same page or not, it's surely write and stored
to zram so we should increase pages_stored stat.  Otherwise, user can see
zero value via mm_stats although he writes a lot of pages to zram.

Link: http://lkml.kernel.org/r/1494834068-27004-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-count-same-page-write-as-page_stored drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-count-same-page-write-as-page_stored
+++ a/drivers/block/zram/zram_drv.c
@@ -469,6 +469,7 @@ static bool zram_same_page_write(struct
 		zram_slot_unlock(zram, index);
 
 		atomic64_inc(&zram->stats.same_pages);
+		atomic64_inc(&zram->stats.pages_stored);
 		return true;
 	}
 	kunmap_atomic(mem);
@@ -524,6 +525,7 @@ static void zram_free_page(struct zram *
 		zram_clear_flag(zram, index, ZRAM_SAME);
 		zram_set_element(zram, index, 0);
 		atomic64_dec(&zram->stats.same_pages);
+		atomic64_dec(&zram->stats.pages_stored);
 		return;
 	}
 
_
