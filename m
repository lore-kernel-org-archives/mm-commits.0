Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDD8C63777
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 20:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28EA320643
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 20:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="waGTAxOJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbgK3UmI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 15:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726716AbgK3UmI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 15:42:08 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9EE520643;
        Mon, 30 Nov 2020 20:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606768887;
        bh=i4vCeOZHQVyLtcrJ3OaHkqipwPln4GNfmC4IWCFcWQg=;
        h=Date:From:To:Subject:From;
        b=waGTAxOJL73YZXZwAMho0BuWXUnZZQjnzabz+NbELXlAy+GrcCYiRrCuOCcG5C9wo
         iKjLZpfeIr7enu9oJXAxgre0lUJ5fzqN4aH2c0+BKoTRuMgsxus8EtjR3MbxU/Mjhp
         8s3ydrlan66i4Dskyw9sHFAMJNpWnTCX7Qb4FDK0=
Date:   Mon, 30 Nov 2020 12:41:26 -0800
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky.work@gmail.com
Subject:  +
 zram-add-stat-to-gather-incompressible-pages-since-zram-set-up.patch added
 to -mm tree
Message-ID: <20201130204126.vQeku2E_m%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add stat to gather incompressible pages since zram set up
has been added to the -mm tree.  Its filename is
     zram-add-stat-to-gather-incompressible-pages-since-zram-set-up.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-add-stat-to-gather-incompressible-pages-since-zram-set-up.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-add-stat-to-gather-incompressible-pages-since-zram-set-up.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: add stat to gather incompressible pages since zram set up

Currently, zram supports the stat via /sys/block/zram/mm_stat to represent
how many of incompressible pages are stored at the moment but it couldn't
show how many times incompressible pages were wrote down since zram set
up.  It's also good indication to see how zram is effective in the system.

Link: https://lkml.kernel.org/r/20201130201907.1284910-1-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
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

Patches currently in -mm which might be from minchan@kernel.org are

mm-zsmallocc-drop-zsmalloc_pgtable_mapping.patch
zram-support-a-page-writeback.patch
zram-add-stat-to-gather-incompressible-pages-since-zram-set-up.patch

