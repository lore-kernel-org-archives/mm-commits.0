Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A70C2C678DC
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjASBUL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjASBSS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:18:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C4069B0D
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B036BB81FBB
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502CEC433EF;
        Thu, 19 Jan 2023 01:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090949;
        bh=ba2NpPE7JKV0FhbEMYOuWRPvKpYmdGK3cbS2j5Z10uM=;
        h=Date:To:From:Subject:From;
        b=riajcdympBmD5Sfi59hPhLov4BEo5zYs4+Aw4PcEPrGRArOCobY57iF9mkqMMqw1B
         EEENBLw62ATV4AyH8tF566CpwfqydMQ4eh38WnmJ9K4gmRS/wNNewL0yLBUsqsgE8O
         ysCMebgd5lxCZks3c57deEZEaLoMKLMZU1Dc/Vbc=
Date:   Wed, 18 Jan 2023 17:15:48 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        jhs2.lee@samsung.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fix-typos-in-comments.patch removed from -mm tree
Message-Id: <20230119011549.502CEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: fix typos in comments
has been removed from the -mm tree.  Its filename was
     zram-fix-typos-in-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: JeongHyeon Lee <jhs2.lee@samsung.com>
Subject: zram: fix typos in comments
Date: Fri, 23 Dec 2022 13:03:31 +0900

- The double `range` is duplicated in comment, remove one.
 - change `syfs` to `sysfs`

Link: https://lkml.kernel.org/r/20221223040331.4194-1-jhs2.lee@samsung.com
Signed-off-by: JeongHyeon Lee <jhs2.lee@samsung.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-typos-in-comments
+++ a/drivers/block/zram/zram_drv.c
@@ -190,7 +190,7 @@ static inline bool valid_io_request(stru
 
 	end = start + (size >> SECTOR_SHIFT);
 	bound = zram->disksize >> SECTOR_SHIFT;
-	/* out of range range */
+	/* out of range */
 	if (unlikely(start >= bound || end > bound || start > end))
 		return false;
 
@@ -2385,7 +2385,7 @@ static int zram_add(void)
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
 
-	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
+	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
 	/* zram devices sort of resembles non-rotational disks */
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, zram->disk->queue);
_

Patches currently in -mm which might be from jhs2.lee@samsung.com are


