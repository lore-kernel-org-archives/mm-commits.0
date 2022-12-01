Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B32C4708D
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiLAAEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiLAADX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:03:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3D8D67E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:01:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38710B81D80
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DAAC433D7;
        Thu,  1 Dec 2022 00:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852891;
        bh=mD3dvwqxnevNbR2anT3UIoqvBo/s+mvW4R1idjVN2ZY=;
        h=Date:To:From:Subject:From;
        b=J8rRYIihUqRPHErncBgvmYObrc3vmvXtflwYBgkVWNuH78cBjuQLPo2oj/o+0yswA
         9ungozLJJEvGjLZsWQpB4iOoZRXUu3GGnXr+yDQ0D0ieMnh2Ckm8bO8TwCjoBxDg5l
         65IwFOfWwm5hgZ1Wfsfkr4kmoEj40ZHerMDL6fCo=
Date:   Wed, 30 Nov 2022 16:01:31 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        akpm@linux-foundation.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-use-is_err_value-to-check-for-zs_malloc-errors.patch removed from -mm tree
Message-Id: <20221201000131.D2DAAC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: use IS_ERR_VALUE() to check for zs_malloc() errors
has been removed from the -mm tree.  Its filename was
     zram-use-is_err_value-to-check-for-zs_malloc-errors.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: use IS_ERR_VALUE() to check for zs_malloc() errors
Date: Wed, 9 Nov 2022 20:50:41 +0900

Avoid typecasts that are needed for IS_ERR() and use IS_ERR_VALUE()
instead.

Link: https://lkml.kernel.org/r/20221109115047.2921851-8-senozhatsky@chromium.org
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-use-is_err_value-to-check-for-zs_malloc-errors
+++ a/drivers/block/zram/zram_drv.c
@@ -1542,19 +1542,19 @@ compress_again:
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
 		zcomp_stream_put(zram->comps[ZRAM_PRIMARY_COMP]);
 		atomic64_inc(&zram->stats.writestall);
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
 				__GFP_MOVABLE);
-		if (IS_ERR((void *)handle))
+		if (IS_ERR_VALUE(handle))
 			return PTR_ERR((void *)handle);
 
 		if (comp_len != PAGE_SIZE)
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


