From: akpm@linux-foundation.org
Subject: [patch 08/11] zram: fix operator precedence to get offset
Date: Thu, 13 Apr 2017 14:56:35 -0700
Message-ID: <58eff413.xuiIeiNVLtNTJJrP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751371AbdDMV4g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Apr 2017 17:56:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, stable@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: fix operator precedence to get offset

In zram_rw_page, the logic to get offset is wrong by operator precedence
(i.e., "<<" is higher than "&").  With wrong offset, zram can corrupt the
user's data.  This patch fixes it.

Fixes: 8c7f01025 ("zram: implement rw_page operation of zram")
Link: http://lkml.kernel.org/r/1492042622-12074-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-operator-precedence-to-get-offset drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-operator-precedence-to-get-offset
+++ a/drivers/block/zram/zram_drv.c
@@ -928,7 +928,7 @@ static int zram_rw_page(struct block_dev
 	}
 
 	index = sector >> SECTORS_PER_PAGE_SHIFT;
-	offset = sector & (SECTORS_PER_PAGE - 1) << SECTOR_SHIFT;
+	offset = (sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
 	bv.bv_page = page;
 	bv.bv_len = PAGE_SIZE;
_
