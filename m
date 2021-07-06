Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 255E8C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F4E561CA0
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:20:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhGFTXU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231749AbhGFTXU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B8B761C9C;
        Tue,  6 Jul 2021 19:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599240;
        bh=hL17nY0IaTsV54+5wPHMCm98DgiNr2I3+aHXXrDl7jM=;
        h=Date:From:To:Subject:From;
        b=vHxasVg2TePbXji59nEpwD++65VlbY1JoHoemqv8xkUPDadSXW4B4Kx1qfEpOpWzT
         wX8hGg9DU13AqtCmabbBBMegySPjLhIRCKsnpQRxtYy104dg37VlmsTlWAbs5PguA0
         xT2hM96jILr0eBNl2eoO/vAVm9KpuqFZtYlJSFJY=
Date:   Tue, 06 Jul 2021 12:20:40 -0700
From:   akpm@linux-foundation.org
To:     huyue2@yulong.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org, sergey.senozhatsky@gmail.com
Subject:  [merged]
 zram-move-backing_dev-under-macro-config_zram_writeback.patch removed from
 -mm tree
Message-ID: <20210706192040.bXA7XTz1Z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: move backing_dev under macro CONFIG_ZRAM_WRITEBACK
has been removed from the -mm tree.  Its filename was
     zram-move-backing_dev-under-macro-config_zram_writeback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yue Hu <huyue2@yulong.com>
Subject: zram: move backing_dev under macro CONFIG_ZRAM_WRITEBACK

backing_dev is never used when not enable CONFIG_ZRAM_WRITEBACK and it's
introduced from writeback feature.  So it's needless also affect
readability in that case.

Link: https://lkml.kernel.org/r/20210521060544.2385-1-zbestahu@gmail.com
Signed-off-by: Yue Hu <huyue2@yulong.com>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.h~zram-move-backing_dev-under-macro-config_zram_writeback
+++ a/drivers/block/zram/zram_drv.h
@@ -113,8 +113,8 @@ struct zram {
 	 * zram is claimed so open request will be failed
 	 */
 	bool claim; /* Protected by bdev->bd_mutex */
-	struct file *backing_dev;
 #ifdef CONFIG_ZRAM_WRITEBACK
+	struct file *backing_dev;
 	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
 	u64 bd_wb_limit;
_

Patches currently in -mm which might be from huyue2@yulong.com are


