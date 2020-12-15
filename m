Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD018C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81BEC223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgLODPp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:15:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728099AbgLODOs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:14:48 -0500
Date:   Mon, 14 Dec 2020 19:14:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002073;
        bh=YIzkzGHCJIJlhIEtuN/X9msULixgrrg91oy0LYJLqOk=;
        h=From:To:Subject:In-Reply-To:From;
        b=EMfJePIdQIlGfWf4g1v8P2RaZhw3TRrobtlqUjk6QmJCdGFHcfH0geg8vwS2W17Pb
         H+5igw4HJUhbDu/uafCCYmBdyM6CRJw2wr+u5ndTUikkMlKbPVCRgV4j5gigZBUsNT
         3WhwQ/QpfBntKRlKtMdcGYsZZ58j+jNG47pid5p8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, minchan@kernel.org,
        mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 191/200] zram: add stat to gather incompressible
 pages since zram set up
Message-ID: <20201215031432.3CNcuJlbk%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: add stat to gather incompressible pages since zram set up

Currently, zram supports the stat via /sys/block/zram/mm_stat to represent
how many of incompressible pages are stored at the moment but it couldn't
show how many times incompressible pages were wrote down since zram set
up.  It's also good indication to see how zram is effective in the system.

Link: https://lkml.kernel.org/r/20201130201907.1284910-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    1 +
 drivers/block/zram/zram_drv.c               |    6 ++++--
 drivers/block/zram/zram_drv.h               |    1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-add-stat-to-gather-incompressible-pages-since-zram-set-up
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -266,6 +266,7 @@ line of text and contains the following
                   No memory is allocated for such pages.
  pages_compacted  the number of pages freed during compaction
  huge_pages	  the number of incompressible pages
+ huge_pages_since the number of incompressible pages since zram set up
  ================ =============================================================
 
 File /sys/block/zram<id>/bd_stat
--- a/drivers/block/zram/zram_drv.c~zram-add-stat-to-gather-incompressible-pages-since-zram-set-up
+++ a/drivers/block/zram/zram_drv.c
@@ -1084,7 +1084,7 @@ static ssize_t mm_stat_show(struct devic
 	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
 	ret = scnprintf(buf, PAGE_SIZE,
-			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu\n",
+			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu %8llu\n",
 			orig_size << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.compr_data_size),
 			mem_used << PAGE_SHIFT,
@@ -1092,7 +1092,8 @@ static ssize_t mm_stat_show(struct devic
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.same_pages),
 			pool_stats.pages_compacted,
-			(u64)atomic64_read(&zram->stats.huge_pages));
+			(u64)atomic64_read(&zram->stats.huge_pages),
+			(u64)atomic64_read(&zram->stats.huge_pages_since));
 	up_read(&zram->init_lock);
 
 	return ret;
@@ -1424,6 +1425,7 @@ out:
 	if (comp_len == PAGE_SIZE) {
 		zram_set_flag(zram, index, ZRAM_HUGE);
 		atomic64_inc(&zram->stats.huge_pages);
+		atomic64_inc(&zram->stats.huge_pages_since);
 	}
 
 	if (flags) {
--- a/drivers/block/zram/zram_drv.h~zram-add-stat-to-gather-incompressible-pages-since-zram-set-up
+++ a/drivers/block/zram/zram_drv.h
@@ -78,6 +78,7 @@ struct zram_stats {
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	atomic64_t same_pages;		/* no. of same element filled pages */
 	atomic64_t huge_pages;		/* no. of huge pages */
+	atomic64_t huge_pages_since;	/* no. of huge pages since zram set up */
 	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
 	atomic64_t writestall;		/* no. of write slow paths */
_
