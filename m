Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3BAC2B9F2
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 20:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01CFC610A8
	for <mm-commits@archiver.kernel.org>; Sat, 22 May 2021 20:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhEVUys (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 May 2021 16:54:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231372AbhEVUys (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 22 May 2021 16:54:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9BCC61164;
        Sat, 22 May 2021 20:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621716802;
        bh=DDkBx2qasx/IP8MEIcqu88ExIfu6ppi4dMvnp9OhZeY=;
        h=Date:From:To:Subject:From;
        b=r5rzTBUSdGJu8sE75+oPCf2zGDXTUR8RUOKu4e9IjHAkxzHFwqh0cHQ0sqtzV7WvM
         WvzB8QwoGP5cG2W0Zh4Mei3Ke467QF4lcHIH51QvlsSzCj28zPiYOqLwfye7AUFMt2
         J1XmnMQIFshbWtk0iIcpbMLmuwLEIdUImTnjTsJw=
Date:   Sat, 22 May 2021 13:53:22 -0700
From:   akpm@linux-foundation.org
To:     huyue2@yulong.com, minchan@kernel.org, mm-commits@vger.kernel.org,
        senozhatsky@chromium.org, sergey.senozhatsky@gmail.com
Subject:  +
 zram-move-backing_dev-under-macro-config_zram_writeback.patch added to -mm
 tree
Message-ID: <20210522205322.0FLaF2SHR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: move backing_dev under macro CONFIG_ZRAM_WRITEBACK
has been added to the -mm tree.  Its filename is
     zram-move-backing_dev-under-macro-config_zram_writeback.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-move-backing_dev-under-macro-config_zram_writeback.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-move-backing_dev-under-macro-config_zram_writeback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

zram-move-backing_dev-under-macro-config_zram_writeback.patch

