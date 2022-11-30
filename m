Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ECCCC4321E
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiK3XrX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiK3XrW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:47:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2241E2CCB8
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:47:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1D69B81D59
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D7FC433D7;
        Wed, 30 Nov 2022 23:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852038;
        bh=U9gcgAbUnPMUfX07Dq0G9I9lx8as6/GGbksJr0yejkI=;
        h=Date:To:From:Subject:From;
        b=1l5AiT6C4zGvR/VSTpJEbzx0YlLMa2uaim1ZqqvCyP55T727O3OA39nS39oMwD4M7
         828pdy4S3D1L4xraEPzX9uWmiN5EG759/45sc/N2FDG2EXmKwvTiidlQI/b5J5bzh0
         NEd7a5aQQsoX/Wo2Shl+Szn1TklGPL6uNQt6BEwI=
Date:   Wed, 30 Nov 2022 15:47:17 -0800
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] zram-introduce-recompress-sysfs-knob-fix.patch removed from -mm tree
Message-Id: <20221130234718.78D7FC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: we should always zero out err variable in recompress loop
has been removed from the -mm tree.  Its filename was
     zram-introduce-recompress-sysfs-knob-fix.patch

This patch was dropped because it was folded into zram-introduce-recompress-sysfs-knob.patch

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: we should always zero out err variable in recompress loop
Date: Thu, 10 Nov 2022 23:34:23 +0900

Link: https://lkml.kernel.org/r/20221110143423.3250790-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/zram/zram_drv.c~zram-introduce-recompress-sysfs-knob-fix
+++ a/drivers/block/zram/zram_drv.c
@@ -1839,7 +1839,7 @@ static ssize_t recompress_store(struct d
 
 	ret = len;
 	for (index = 0; index < nr_pages; index++) {
-		int err;
+		int err = 0;
 
 		zram_slot_lock(zram, index);
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-preparation-for-multi-zcomp-support.patch
zram-add-recompression-algorithm-sysfs-knob.patch
zram-factor-out-wb-and-non-wb-zram-read-functions.patch
zram-introduce-recompress-sysfs-knob.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch
docs-abi-zram-document-zram-recompress-sysfs-knobs.patch
zram-remove-unused-stats-fields.patch
zswap-do-not-allocate-from-atomic-pool.patch

