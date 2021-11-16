Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B7E8C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0397561B4C
	for <mm-commits@archiver.kernel.org>; Tue, 16 Nov 2021 04:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbhKPE4n (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 23:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236864AbhKPEzf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 23:55:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC63D60EFD;
        Tue, 16 Nov 2021 04:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637038359;
        bh=0AGtMXsvi9uCH5noC4kU5sbtFr61l5XyInVZIZnNtJs=;
        h=Date:From:To:Subject:From;
        b=cQ/sqRhdC2FCzj8Lzu3d5bhAMVdN1WfpbYyKYXn3IsS0uDRyTEqdNj0Pgm7sIID0+
         vDrwqyROdpmGxrHYq0V6eLDMvQutht5x476LQlJ16ZrfVHiwByl3hv/HY0TSwqhkt5
         jsIi+aTNm5mCh0dntcJnOQPmuTOif3vzXEXmNYXg=
Date:   Mon, 15 Nov 2021 20:52:38 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, bvanassche@acm.org, mcgrof@kernel.org,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Subject:  + zram-use-attribute_groups.patch added to -mm tree
Message-ID: <20211116045238.fXGkMqmxB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use ATTRIBUTE_GROUPS
has been added to the -mm tree.  Its filename is
     zram-use-attribute_groups.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-use-attribute_groups.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-use-attribute_groups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: zram: use ATTRIBUTE_GROUPS

Embrace ATTRIBUTE_GROUPS to avoid boiler plate code.  This should not
introduce any functional changes.

Link: https://lkml.kernel.org/r/20211028203600.2157356-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-attribute_groups
+++ a/drivers/block/zram/zram_drv.c
@@ -1901,14 +1901,7 @@ static struct attribute *zram_disk_attrs
 	NULL,
 };
 
-static const struct attribute_group zram_disk_attr_group = {
-	.attrs = zram_disk_attrs,
-};
-
-static const struct attribute_group *zram_disk_attr_groups[] = {
-	&zram_disk_attr_group,
-	NULL,
-};
+ATTRIBUTE_GROUPS(zram_disk);
 
 /*
  * Allocate and initialize new zram device. the function returns
@@ -1980,7 +1973,7 @@ static int zram_add(void)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
-	ret = device_add_disk(NULL, zram->disk, zram_disk_attr_groups);
+	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
 		goto out_cleanup_disk;
 
_

Patches currently in -mm which might be from mcgrof@kernel.org are

zram-use-attribute_groups.patch

