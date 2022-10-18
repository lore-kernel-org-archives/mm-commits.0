Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D07C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 23:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJRXVY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Oct 2022 19:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiJRXVC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2022 19:21:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79176855B0
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 16:21:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D21B82190
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 23:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA039C433D7;
        Tue, 18 Oct 2022 23:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666135258;
        bh=5anidVOts0l09GgHTBAjARUJoe0ChfQNiua5IQTCkc0=;
        h=Date:To:From:Subject:From;
        b=yENpAgyX+BSDb57wLX3Tm3pOea+FowsroKeu8xHu0v6pWoGhDI2TizWlh4e8LwHe9
         0GLY1a/CpW6ES6CBiaUaR1zxpI42PnZb48ektnJO4/3qa08RdRPzzHEan+UaecM+wB
         q7kurSf52mAtQNzvwlU/Xz7y8BkB5VquTg8FPrps=
Date:   Tue, 18 Oct 2022 16:20:58 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-use-is_err_value-to-check-for-zs_malloc-errors.patch added to mm-unstable branch
Message-Id: <20221018232058.CA039C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: use IS_ERR_VALUE() to check for zs_malloc() errors
has been added to the -mm mm-unstable branch.  Its filename is
     zram-use-is_err_value-to-check-for-zs_malloc-errors.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-use-is_err_value-to-check-for-zs_malloc-errors.patch

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

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
documentation-add-recompression-documentation.patch
zram-add-recompression-algorithm-choice-to-kconfig.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch

