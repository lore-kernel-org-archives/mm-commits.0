Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB792C433F5
	for <mm-commits@archiver.kernel.org>; Sat,  7 May 2022 18:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379034AbiEGTBg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 7 May 2022 15:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238531AbiEGTBf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 7 May 2022 15:01:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9576C62E2
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 11:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45B0CB80C6D
        for <mm-commits@vger.kernel.org>; Sat,  7 May 2022 18:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14CBC385A6;
        Sat,  7 May 2022 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651949864;
        bh=csW+3nmxV3sla/Rdda+XGfc9kor0+qc8/dZhNXc4Td4=;
        h=Date:To:From:Subject:From;
        b=d6L2PRBY0OVt4f05lTC2OrKALJUeL7FDc9+vpcF1uixRVrjj+Q01uRj81hoW6NJ6T
         +pyEaklpsyKDBH2Kj9BQUNILuj4vYprBZgVefKX8SAyc4Ul8zp7oJleFEFyBxTGfw+
         ZeJfck6MOKzQJ+wVGGIORdGSfzWIYYyHlfS0o8os=
Date:   Sat, 07 May 2022 11:57:44 -0700
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        ngupta@vflare.org, minchan@kernel.org, ddrokosov@sberdevices.ru,
        avromanov@sberdevices.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-double-compression-logic.patch added to mm-unstable branch
Message-Id: <20220507185744.D14CBC385A6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove double compression logic
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-double-compression-logic.patch

This patch should soon appear in the mm-unstable branch at
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
From: Alexey Romanov <avromanov@sberdevices.ru>
Subject: zram: remove double compression logic

The 2nd trial allocation under per-cpu presumption has been used to
prevent regression of allocation failure.  However, it makes trouble for
maintenance without significant benefit.  The slowpath branch is executed
extremely rarely: getting there is problematic.  Therefore, we delete this
branch.

Since b09ab054b69b ("zram: support BDI_CAP_STABLE_WRITES"), zram has used
QUEUE_FLAG_STABLE_WRITES to prevent buffer change between 1st and 2nd
memory allocations.  Since we remove second trial memory allocation logic,
we could remove the STABLE_WRITES flag because there is no change buffer
to be modified under us.

Link: https://lkml.kernel.org/r/20220505094443.11728-1-avromanov@sberdevices.ru
Signed-off-by: Alexey Romanov <avromanov@sberdevices.ru>
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   42 +++++++-------------------------
 drivers/block/zram/zram_drv.h |    1 
 2 files changed, 10 insertions(+), 33 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-double-compression-logic
+++ a/drivers/block/zram/zram_drv.c
@@ -1144,15 +1144,14 @@ static ssize_t bd_stat_show(struct devic
 static ssize_t debug_stat_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	int version = 1;
+	int version = 2;
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
 	down_read(&zram->init_lock);
 	ret = scnprintf(buf, PAGE_SIZE,
-			"version: %d\n%8llu %8llu\n",
+			"version: %d\n%8llu\n",
 			version,
-			(u64)atomic64_read(&zram->stats.writestall),
 			(u64)atomic64_read(&zram->stats.miss_free));
 	up_read(&zram->init_lock);
 
@@ -1368,7 +1367,6 @@ static int __zram_bvec_write(struct zram
 	}
 	kunmap_atomic(mem);
 
-compress_again:
 	zstrm = zcomp_stream_get(zram->comp);
 	src = kmap_atomic(page);
 	ret = zcomp_compress(zstrm, src, &comp_len);
@@ -1377,39 +1375,20 @@ compress_again:
 	if (unlikely(ret)) {
 		zcomp_stream_put(zram->comp);
 		pr_err("Compression failed! err=%d\n", ret);
-		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
 	if (comp_len >= huge_class_size)
 		comp_len = PAGE_SIZE;
-	/*
-	 * handle allocation has 2 paths:
-	 * a) fast path is executed with preemption disabled (for
-	 *  per-cpu streams) and has __GFP_DIRECT_RECLAIM bit clear,
-	 *  since we can't sleep;
-	 * b) slow path enables preemption and attempts to allocate
-	 *  the page with __GFP_DIRECT_RECLAIM bit set. we have to
-	 *  put per-cpu compression stream and, thus, to re-do
-	 *  the compression once handle is allocated.
-	 *
-	 * if we have a 'non-null' handle here then we are coming
-	 * from the slow path and handle has already been allocated.
-	 */
-	if (!handle)
-		handle = zs_malloc(zram->mem_pool, comp_len,
-				__GFP_KSWAPD_RECLAIM |
-				__GFP_NOWARN |
-				__GFP_HIGHMEM |
-				__GFP_MOVABLE);
-	if (!handle) {
+
+	handle = zs_malloc(zram->mem_pool, comp_len,
+			__GFP_KSWAPD_RECLAIM |
+			__GFP_NOWARN |
+			__GFP_HIGHMEM |
+			__GFP_MOVABLE);
+
+	if (unlikely(!handle)) {
 		zcomp_stream_put(zram->comp);
-		atomic64_inc(&zram->stats.writestall);
-		handle = zs_malloc(zram->mem_pool, comp_len,
-				GFP_NOIO | __GFP_HIGHMEM |
-				__GFP_MOVABLE);
-		if (handle)
-			goto compress_again;
 		return -ENOMEM;
 	}
 
@@ -1967,7 +1946,6 @@ static int zram_add(void)
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
 		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
-	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, zram->disk->queue);
 	ret = device_add_disk(NULL, zram->disk, zram_disk_groups);
 	if (ret)
 		goto out_cleanup_disk;
--- a/drivers/block/zram/zram_drv.h~zram-remove-double-compression-logic
+++ a/drivers/block/zram/zram_drv.h
@@ -81,7 +81,6 @@ struct zram_stats {
 	atomic64_t huge_pages_since;	/* no. of huge pages since zram set up */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
-	atomic64_t writestall;		/* no. of write slow paths */
 	atomic64_t miss_free;		/* no. of missed free */
 #ifdef	CONFIG_ZRAM_WRITEBACK
 	atomic64_t bd_count;		/* no. of pages in backing device */
_

Patches currently in -mm which might be from avromanov@sberdevices.ru are

zram-remove-double-compression-logic.patch

