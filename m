Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46359C43219
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 04:04:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiKIEEr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 23:04:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKIEEk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 23:04:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4BB1E724
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 20:04:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE22B617A4
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 04:04:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336D9C433D7;
        Wed,  9 Nov 2022 04:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667966671;
        bh=tIjbeJq+Ebu30CA9OSzLWDoY80rzp782DJ2+qUjXIp8=;
        h=Date:To:From:Subject:From;
        b=U9DfqJKaBHcJ363AgmyWl41hFUWg8N0Wkqsbqk09aWrbMkJLWB/vR9g3rAobur1RA
         erSyJ23jITj/rGay3Tt2+ZVZyZtPp6fl8qqjbLG5owu9+oNgCHK9Qe0yc4JptJRObr
         fJ65PKghUZyTEFwLYgtcB+HtJQ8HinDCOjCRh8BA=
Date:   Tue, 08 Nov 2022 20:04:30 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-use-is_err_value-to-check-for-zs_malloc-errors.patch removed from -mm tree
Message-Id: <20221109040431.336D9C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: use IS_ERR_VALUE() to check for zs_malloc() errors
has been removed from the -mm tree.  Its filename was
     zram-use-is_err_value-to-check-for-zs_malloc-errors.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use IS_ERR_VALUE() to check for zs_malloc() errors
Date: Tue, 18 Oct 2022 13:55:33 +0900

Avoid type casts that are needed for IS_ERR() and use IS_ERR_VALUE()
instead.

Link: https://lkml.kernel.org/r/20221018045533.2396670-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-is_err_value-to-check-for-zs_malloc-errors
+++ a/drivers/block/zram/zram_drv.c
@@ -1503,19 +1503,19 @@ compress_again:
 	 * if we have a 'non-null' handle here then we are coming
 	 * from the slow path and handle has already been allocated.
 	 */
-	if (IS_ERR((void *)handle))
+	if (IS_ERR_VALUE(handle))
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				__GFP_KSWAPD_RECLAIM |
 				__GFP_NOWARN |
 				__GFP_HIGHMEM |
 				__GFP_MOVABLE);
-	if (IS_ERR((void *)handle)) {
+	if (IS_ERR_VALUE(handle)) {
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_ZCOMP]);
 		atomic64_inc(&zram->stats.writestall);
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
 				__GFP_MOVABLE);
-		if (IS_ERR((void *)handle))
+		if (IS_ERR_VALUE(handle))
 			return PTR_ERR((void *)handle);
 
 		if (comp_len != PAGE_SIZE)
@@ -1682,7 +1682,7 @@ static int zram_recompress(struct zram *
 				__GFP_NOWARN |
 				__GFP_HIGHMEM |
 				__GFP_MOVABLE);
-	if (IS_ERR((void *)handle_next)) {
+	if (IS_ERR_VALUE(handle_next)) {
 		zcomp_stream_put(zram->comps[ZRAM_SECONDARY_ZCOMP]);
 		return PTR_ERR((void *)handle_next);
 	}
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-move-away-from-page-order-defines.patch
zsmalloc-make-huge-class-watermark-zs_pool-member.patch
zram-huge-size-watermark-cannot-be-global.patch
zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch
zram-add-pages_per_pool_page-device-attribute.patch
documentation-document-zram-pages_per_pool_page-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

