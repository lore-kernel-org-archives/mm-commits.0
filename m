Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FB3ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiILDd3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiILDbk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:31:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90021409C
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57F846116D
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0AAC433D6;
        Mon, 12 Sep 2022 03:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953388;
        bh=tBadT6m7TtKkoXeBi91Pw5/s7pqLlFIolr0nDqC8HQ0=;
        h=Date:To:From:Subject:From;
        b=UI9+BYQGMzycW755Ks3g+dSi62VyVJ1VfgaxiNNrab0UaUYOGz37RA+qzSnRhOHR3
         REgnsjn64bkoEvESx0Dk/ZnRSZSjqU+pTU809S+jRHhd+5TL7WGFj5KsdAd9rF49GS
         0qGhdgafe1SgdCQQ9CHz2+UM8UPDQYt+tTJc1gZg=
Date:   Sun, 11 Sep 2022 20:29:48 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset.patch removed from -mm tree
Message-Id: <20220912032948.AB0AAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
has been removed from the -mm tree.  Its filename was
     block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: drivers/block/zram/zram_drv.c: do not keep dangling zcomp pointer after zram reset
Date: Wed, 24 Aug 2022 12:51:00 +0900

We do all reset operations under write lock, so we don't need to save
->disksize and ->comp to stack variables.  Another thing is that ->comp is
freed during zram reset, but comp pointer is not NULL-ed, so zram keeps
the freed pointer value.

Link: https://lkml.kernel.org/r/20220824035100.971816-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~block-zram-do-not-keep-dangling-zcomp-pointer-after-zram-reset
+++ a/drivers/block/zram/zram_drv.c
@@ -1710,9 +1710,6 @@ out:
 
 static void zram_reset_device(struct zram *zram)
 {
-	struct zcomp *comp;
-	u64 disksize;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -1722,17 +1719,15 @@ static void zram_reset_device(struct zra
 		return;
 	}
 
-	comp = zram->comp;
-	disksize = zram->disksize;
-	zram->disksize = 0;
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 
 	/* I/O operation under all of CPU are done so let's free */
-	zram_meta_free(zram, disksize);
+	zram_meta_free(zram, zram->disksize);
+	zram->disksize = 0;
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	zcomp_destroy(comp);
+	zcomp_destroy(zram->comp);
+	zram->comp = NULL;
 	reset_bdev(zram);
 
 	up_write(&zram->init_lock);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


