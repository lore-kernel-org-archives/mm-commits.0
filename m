Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ADF3C678D5
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBWT4t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:56:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjBWT4q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:56:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43942125B9
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:56:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1D4EB81A06
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D20C433D2;
        Thu, 23 Feb 2023 19:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677182202;
        bh=C7zBMXJYeRRXWKw7tyThmV1uBhxL45ZhE6uIwUDK7SI=;
        h=Date:To:From:Subject:From;
        b=pdxvAVDQ7763UoiBWpyc7KLzmrPOYHPEXvClNKHL4thOlf+fabkGCqa1zoWdsw6vL
         LlUECoLMTvvVVLRPBvtN3u/sEBkHgdR5rUQkOMyTsplZxXPrfGhhCTXlGrCnDfclLq
         28Fz769cUos8yMJDW0zAlrcCBoo2gJo3hpzTr79A=
Date:   Thu, 23 Feb 2023 11:56:42 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-show-zsmalloc-objs_moved-stat-in-mm_stat.patch added to mm-unstable branch
Message-Id: <20230223195642.A0D20C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: show zsmalloc objs_moved stat in mm_stat
has been added to the -mm mm-unstable branch.  Its filename is
     zram-show-zsmalloc-objs_moved-stat-in-mm_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-show-zsmalloc-objs_moved-stat-in-mm_stat.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: show zsmalloc objs_moved stat in mm_stat
Date: Thu, 23 Feb 2023 12:04:51 +0900

Extend zram mm_show with new objs_moved zs_pool_stats.

Link: https://lkml.kernel.org/r/20230223030451.543162-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    1 +
 drivers/block/zram/zram_drv.c               |    5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-show-zsmalloc-objs_moved-stat-in-mm_stat
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -267,6 +267,7 @@ line of text and contains the following
  pages_compacted  the number of pages freed during compaction
  huge_pages	  the number of incompressible pages
  huge_pages_since the number of incompressible pages since zram set up
+ objs_moved       The number of objects moved during pool compaction
  ================ =============================================================
 
 File /sys/block/zram<id>/bd_stat
--- a/drivers/block/zram/zram_drv.c~zram-show-zsmalloc-objs_moved-stat-in-mm_stat
+++ a/drivers/block/zram/zram_drv.c
@@ -1223,7 +1223,7 @@ static ssize_t mm_stat_show(struct devic
 	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
 	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu %8llu\n",
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu %8llu %8llu\n",
 			orig_size << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.compr_data_size),
 			mem_used << PAGE_SHIFT,
@@ -1232,7 +1232,8 @@ static ssize_t mm_stat_show(struct devic
 			(u64)atomic64_read(&zram->stats.same_pages),
 			atomic_long_read(&pool_stats.pages_compacted),
 			(u64)atomic64_read(&zram->stats.huge_pages),
-			(u64)atomic64_read(&zram->stats.huge_pages_since));
+			(u64)atomic64_read(&zram->stats.huge_pages_since),
+			(u64)atomic64_read(&pool_stats.objs_moved));
 	up_read(&zram->init_lock);
 
 	return ret;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-remove-stat-and-fullness-enums.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-extend-compaction-statistics.patch
zram-show-zsmalloc-objs_moved-stat-in-mm_stat.patch

