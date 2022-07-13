Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22F87C43334
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 16:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236463AbiGMQ1H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 12:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235889AbiGMQ1H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 12:27:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7156466
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 09:27:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55CD2B820DD
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 16:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32C9C34114;
        Wed, 13 Jul 2022 16:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657729622;
        bh=wnvLl6q/01zLMdQ2Hx0VMP9QDORZkPOs76Fj6yxMUqw=;
        h=Date:To:From:Subject:From;
        b=0L8ZW4vt8md+W4T6h+LMdJd3MDU//wxc63TlADGJdqcj7uDa1OmK9e3SVenp6/DL/
         Q4liJXEPMTtEPOREnu9D1sZQ1G8s9CCbZIndSyZHpDo5cDmbIfzjNh4kc6ZBN4zDO9
         jnVuvhUIrZwDS6/vtj3fCtD5+c9RMf8bOrWyIo9M=
Date:   Wed, 13 Jul 2022 09:27:00 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, axboe@kernel.dk,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-unused-zram_wb_devops-warning.patch added to mm-unstable branch
Message-Id: <20220713162701.D32C9C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix unused 'zram_wb_devops' warning
has been added to the -mm mm-unstable branch.  Its filename is
     zram-fix-unused-zram_wb_devops-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-unused-zram_wb_devops-warning.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

zram-fix-unused-zram_wb_devops-warning.patch

