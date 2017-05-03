From: akpm@linux-foundation.org
Subject: [patch 084/102] zram: use zram_free_page instead of
 open-coded
Date: Wed, 03 May 2017 14:55:53 -0700
Message-ID: <20170503215553.qR46fkWxP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52684 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV5Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hare@suse.com, jthumshirn@suse.de, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: use zram_free_page instead of open-coded

The zram_free_page already handles NULL handle case and same page so use
it to reduce error probability.  (Acutaully, I made a mistake when I
handled same page feature)

Link: http://lkml.kernel.org/r/1492052365-16169-7-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-use-zram_free_page-instead-of-open-coded drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-use-zram_free_page-instead-of-open-coded
+++ a/drivers/block/zram/zram_drv.c
@@ -480,17 +480,8 @@ static void zram_meta_free(struct zram *
 	size_t index;
 
 	/* Free all pages that are still in this zram device */
-	for (index = 0; index < num_pages; index++) {
-		unsigned long handle = zram_get_handle(zram, index);
-		/*
-		 * No memory is allocated for same element filled pages.
-		 * Simply clear same page flag.
-		 */
-		if (!handle || zram_test_flag(zram, index, ZRAM_SAME))
-			continue;
-
-		zs_free(zram->mem_pool, handle);
-	}
+	for (index = 0; index < num_pages; index++)
+		zram_free_page(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
@@ -978,9 +969,6 @@ static void zram_reset_device(struct zra
 
 	comp = zram->comp;
 	disksize = zram->disksize;
