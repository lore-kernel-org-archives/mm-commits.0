Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B091AC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 04:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjBZEbR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 23:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBZEbN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 23:31:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC767AA4
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3A0FB80956
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 04:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7FBC433D2;
        Sun, 26 Feb 2023 04:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677385867;
        bh=rviduVVrbk3BWgAG+Jog0C+muFoJmogzRxZXME9vrnQ=;
        h=Date:To:From:Subject:From;
        b=g4/9gKNiSp/G964UOInu6W3/9vy7xPY4djlx6iitfoo8KWNs/1t/obzz5h6C7aoQl
         JYtZq9MXaqfgK2IoDzocP3CnyNQRysa8ZQVa0NY6qbBuMGH62tftif++Bhot/lHDDw
         xCCFeOsgjI+V6UbyGWRBYtHqHaiHK9kzNS1E77mw=
Date:   Sat, 25 Feb 2023 20:31:06 -0800
To:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, geert+renesas@glider.be,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix.patch added to mm-unstable branch
Message-Id: <20230226043107.5E7FBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use atomic_long_read() to read atomic_long_t
has been added to the -mm mm-unstable branch.  Its filename is
     zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix.patch

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
From: Geert Uytterhoeven <geert+renesas@glider.be>
Subject: zram: use atomic_long_read() to read atomic_long_t
Date: Sat, 25 Feb 2023 13:15:23 +0100

On 32-bit:

    drivers/block/zram/zram_drv.c: In function `mm_stat_show':
    drivers/block/zram/zram_drv.c:1234:23: error: passing argument 1 of `atomic64_read' from incompatible pointer type [-Werror=incompatible-pointer-types]
     1234 |    (u64)atomic64_read(&pool_stats.objs_moved));
	  |                       ^~~~~~~~~~~~~~~~~~~~~~
	  |                       |
	  |                       atomic_long_t * {aka struct <anonymous> *}
    In file included from ./include/linux/atomic.h:82,
		     from ./include/linux/mm_types_task.h:13,
		     from ./include/linux/mm_types.h:5,
		     from ./include/linux/buildid.h:5,
		     from ./include/linux/module.h:14,
		     from drivers/block/zram/zram_drv.c:18:
    ./include/linux/atomic/atomic-instrumented.h:644:33: note: expected `const atomic64_t *' {aka `const struct <anonymous> *'} but argument is of type `atomic_long_t *' {aka `struct <anonymous> *'}
      644 | atomic64_read(const atomic64_t *v)
	  |               ~~~~~~~~~~~~~~~~~~^

Fix this by using atomic_long_read() instead.

Link: https://lkml.kernel.org/r/20230225121523.3288544-1-geert+renesas@glider.be
Fixes: b7d89654a988a2a4 ("zram: show zsmalloc objs_moved stat in mm_stat")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by; <noreply@ellerman.id.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/block/zram/zram_drv.c~zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix
+++ b/drivers/block/zram/zram_drv.c
@@ -1221,7 +1221,7 @@ static ssize_t mm_stat_show(struct device *dev,
 	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
 	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu %8llu %8llu\n",
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu %8llu %8lu\n",
 			orig_size << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.compr_data_size),
 			mem_used << PAGE_SHIFT,
@@ -1231,7 +1231,7 @@ static ssize_t mm_stat_show(struct device *dev,
 			atomic_long_read(&pool_stats.pages_compacted),
 			(u64)atomic64_read(&zram->stats.huge_pages),
 			(u64)atomic64_read(&zram->stats.huge_pages_since),
-			(u64)atomic64_read(&pool_stats.objs_moved));
+			atomic_long_read(&pool_stats.objs_moved));
 	up_read(&zram->init_lock);
 
 	return ret;
_

Patches currently in -mm which might be from geert+renesas@glider.be are

zram-show-zsmalloc-objs_moved-stat-in-mm_stat-fix.patch

