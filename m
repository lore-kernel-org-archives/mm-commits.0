Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D97C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 04:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiKIEEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 23:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKIEEk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 23:04:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B7E1E726
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 20:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DC5B81B05
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 04:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11053C433C1;
        Wed,  9 Nov 2022 04:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667966670;
        bh=cA3YR867zmmmTuh9wMCs4vs4V5575vtX+mbhEWmhVK0=;
        h=Date:To:From:Subject:From;
        b=TICC6a5pbOPP29UL/JZc3uAp5NRdyHLdeCS2dON57D8SEv4P1Ighx4v+P46iV+CAo
         Uj5xzCFtrJ1FspsI6megzk+EbBA1oh7Gv1pdZpQPxELr6+Uc3Fn601vGqkesFrJf3r
         hacmnY3HyZLyZc7h5bJGQA3b71Jfh3oCoZGvurHw=
Date:   Tue, 08 Nov 2022 20:04:29 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-clarify-writeback_store-comment.patch removed from -mm tree
Message-Id: <20221109040430.11053C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: clarify writeback_store() comment
has been removed from the -mm tree.  Its filename was
     zram-clarify-writeback_store-comment.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: clarify writeback_store() comment
Date: Tue, 18 Oct 2022 13:55:32 +0900

Re-phrase writeback BIO error comment.

Link: https://lkml.kernel.org/r/20221018045533.2396670-9-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-clarify-writeback_store-comment
+++ a/drivers/block/zram/zram_drv.c
@@ -755,8 +755,12 @@ static ssize_t writeback_store(struct de
 			zram_clear_flag(zram, index, ZRAM_IDLE);
 			zram_slot_unlock(zram, index);
 			/*
-			 * Return last IO error unless every IO were
-			 * not suceeded.
+			 * BIO errors are not fatal, we continue and simply
+			 * attempt to writeback the remaining objects (pages).
+			 * At the same time we need to signal user-space that
+			 * some writes (at least one, but also could be all of
+			 * them) were not successful and we do so by returning
+			 * the most recent BIO error.
 			 */
 			ret = err;
 			continue;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-move-away-from-page-order-defines.patch
zsmalloc-make-huge-class-watermark-zs_pool-member.patch
zram-huge-size-watermark-cannot-be-global.patch
zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch
zram-add-pages_per_pool_page-device-attribute.patch
documentation-document-zram-pages_per_pool_page-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

