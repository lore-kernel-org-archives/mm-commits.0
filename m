Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0B5C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiGRAWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiGRAUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DA5270F
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 876DCB80EF1
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28979C341C0;
        Mon, 18 Jul 2022 00:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103529;
        bh=JYXO7Y0ETOE8quA/ff55do5ZAddsuw5uBckenapOQxc=;
        h=Date:To:From:Subject:From;
        b=0JD1eAK9oaycK10YEbWkYlaNibwoSQk5cYELkcSAxMzCoJIZORffy8Q9/mYFY//c+
         xjzxs2np9EEctVLH/AevNfm+9x8Hl2PcBD2Iz37IwU5kP6mdpKLwGeguF4V2qVCCJv
         ByoV7bWQI7j+5NUmGEeEb86UseUxqLmefk4qlGLU=
Date:   Sun, 17 Jul 2022 17:18:48 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, axboe@kernel.dk,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-unused-zram_wb_devops-warning.patch removed from -mm tree
Message-Id: <20220718001849.28979C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: fix unused 'zram_wb_devops' warning
has been removed from the -mm tree.  Its filename was
     zram-fix-unused-zram_wb_devops-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: zram: fix unused 'zram_wb_devops' warning
Date: Wed, 8 Jun 2022 15:25:34 +0800

drivers/block/zram/zram_drv.c:55:45: warning: 'zram_wb_devops' defined but not used [-Wunused-const-variable=]

Fix the above warning if CONFIG_ZRAM_WRITEBACK not enabled.

Link: https://lkml.kernel.org/r/20220608072534.68850-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/block/zram/zram_drv.c~zram-fix-unused-zram_wb_devops-warning
+++ a/drivers/block/zram/zram_drv.c
@@ -52,7 +52,9 @@ static unsigned int num_devices = 1;
 static size_t huge_class_size;
 
 static const struct block_device_operations zram_devops;
+#ifdef CONFIG_ZRAM_WRITEBACK
 static const struct block_device_operations zram_wb_devops;
+#endif
 
 static void zram_free_page(struct zram *zram, size_t index);
 static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


