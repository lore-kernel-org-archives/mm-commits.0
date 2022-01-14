Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65732C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiANWJ1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BAF0C061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:09:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D8D50CE19A9
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046ADC36AEC;
        Fri, 14 Jan 2022 22:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198163;
        bh=chqW46Vo2JD2NNMvF3sjlrNHvbfLhnBMRF+ydxRlpy8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=T7FAG8Bfnr3p+XepYjkOZfbFqa1aNWxifETuENZLktATsjc3NLw8YSKoJjF+M42KG
         TjeYv1SBQssmCSZ9YERMbxrmlt5Kifrh1GVvyXQgXnWFzuh4w5yXhX0o477e0wLQ3m
         mT6X3tkcq+2A4JCo3ozJpAQnI/wThygn0sFuDGmY=
Date:   Fri, 14 Jan 2022 14:09:22 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, bvanassche@acm.org,
        linux-mm@kvack.org, mcgrof@kernel.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org, torvalds@linux-foundation.org
Subject:  [patch 117/146] zram: use ATTRIBUTE_GROUPS
Message-ID: <20220114220922.EyQYZ4NNz%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -1903,14 +1903,7 @@ static struct attribute *zram_disk_attrs
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
@@ -1982,7 +1975,7 @@ static int zram_add(void)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
-	ret = device_add_disk(NULL, zram->disk, zram_disk_attr_groups);
+	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
 		goto out_cleanup_disk;
 
_
