Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0DAC11F69
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5B8361468
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:53:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238511AbhGABzj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABzi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:55:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEFF36105A;
        Thu,  1 Jul 2021 01:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104388;
        bh=qRlUoZqlfmnGmyW2QHh7SLhKVxgwA/JqiVj3PKTOkRg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=t0sy5+tBcrORpQOFMKI85BgpTEmT4w3nYcK/PGkSiQ/h8IBvJG+b0a/ggAa6Sz7iL
         96AtpS+L1YVWyHk2+cQzp/IstcdxweoEOSchXgiym/HI6za7Noha2VJSjhJte2Wmr3
         SaTO8A3AXfFyZ6hOxVmS7HSKtXfeYMBvhg1kkPY4=
Date:   Wed, 30 Jun 2021 18:53:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, huyue2@yulong.com, linux-mm@kvack.org,
        minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org, sergey.senozhatsky@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 111/192] zram: move backing_dev under macro
 CONFIG_ZRAM_WRITEBACK
Message-ID: <20210701015307.EtNdJcvyZ%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
