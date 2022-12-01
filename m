Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DD0C47088
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiLAAIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiLAAGc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:06:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E1387CBD
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:02:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8B1A6176C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282C0C433D6;
        Thu,  1 Dec 2022 00:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852950;
        bh=IsCGdIDzPPF418shCNVmX6gYXzfzSfgzJ4799ns+tWQ=;
        h=Date:To:From:Subject:From;
        b=Os8T9dItsoDmDoCdhTWmSex+V1xCmDQ2cf4B4CdGNvpo3e8lczyzPxVhfrzJXTRza
         ehaLdANMrybTJ+QqjXQzPF04lsdDaEv4LL2GRzH3DnNCCXiJok/D29T5dtyTVM9zkl
         BgKg86AZQBYRSRQJi/lGNaWM3+NMsFkXFq1+zfw4=
Date:   Wed, 30 Nov 2022 16:02:29 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-remove-unused-stats-fields.patch removed from -mm tree
Message-Id: <20221201000230.282C0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: remove unused stats fields
has been removed from the -mm tree.  Its filename was
     zram-remove-unused-stats-fields.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: remove unused stats fields
Date: Thu, 17 Nov 2022 23:13:26 +0900

We don't show num_reads and num_writes since we removed corresponding
sysfs nodes in 2017.  Block layer stats are exposed via
/sys/block/zramX/stat file.

However, we still increment those atomic vars and store them in zram
stats.  Remove leftovers.

Link: https://lkml.kernel.org/r/20221117141326.1105181-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 --
 drivers/block/zram/zram_drv.h |    2 --
 2 files changed, 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-unused-stats-fields
+++ a/drivers/block/zram/zram_drv.c
@@ -1981,11 +1981,9 @@ static int zram_bvec_rw(struct zram *zra
 	int ret;
 
 	if (!op_is_write(op)) {
-		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset, bio);
 		flush_dcache_page(bvec->bv_page);
 	} else {
-		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset, bio);
 	}
 
--- a/drivers/block/zram/zram_drv.h~zram-remove-unused-stats-fields
+++ a/drivers/block/zram/zram_drv.h
@@ -76,8 +76,6 @@ struct zram_table_entry {
 
 struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
-	atomic64_t num_reads;	/* failed + successful */
-	atomic64_t num_writes;	/* --do-- */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


