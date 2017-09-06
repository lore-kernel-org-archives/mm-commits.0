From: akpm@linux-foundation.org
Subject: [folded-merged]
 zram-clean-up-duplicated-codes-in-__zram_bvec_write-fix.patch removed from
 -mm tree
Date: Wed, 06 Sep 2017 15:57:48 -0700
Message-ID: <59b07d6c.P1XKwl7W6N2MpEom%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45780 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753542AbdIFW5t (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 18:57:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyisheng1@huawei.com, juno.choi@lge.com, minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix compr_data_size stat
has been removed from the -mm tree.  Its filename was
     zram-clean-up-duplicated-codes-in-__zram_bvec_write-fix.patch

This patch was dropped because it was folded into zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch

------------------------------------------------------
From: Yisheng Xie <xieyisheng1@huawei.com>
Subject: zram: fix compr_data_size stat

The compr_data_size is a stat for compressed size of pages stored, which
should be updated when we compresse a page.

Link: http://lkml.kernel.org/r/1502707447-6944-1-git-send-email-xieyisheng1@huawei.com
Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Juneho Choi <juno.choi@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/block/zram/zram_drv.c~zram-clean-up-duplicated-codes-in-__zram_bvec_write-fix drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-clean-up-duplicated-codes-in-__zram_bvec_write-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -697,6 +697,7 @@ static int __zram_bvec_write(struct zram
 
 	zcomp_stream_put(zram->comp);
 	zs_unmap_object(zram->mem_pool, handle);
+	atomic64_add(comp_len, &zram->stats.compr_data_size);
 out:
 	/*
 	 * Free memory associated with this sector
_

Patches currently in -mm which might be from xieyisheng1@huawei.com are

zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-write-incompressible-pages-to-backing-device-fix.patch
zram-read-page-from-backing-device-fix.patch

