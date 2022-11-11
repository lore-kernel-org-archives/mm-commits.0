Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE57BC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 11 Nov 2022 23:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbiKKXII (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Nov 2022 18:08:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiKKXIB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Nov 2022 18:08:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B265E9CD
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 15:07:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1707B8281D
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 23:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F26C433D6;
        Fri, 11 Nov 2022 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668208059;
        bh=S2HhNy+oi58Kvi36HJKEbcAtTbRV+1zrCZ7D4Cp7oqk=;
        h=Date:To:From:Subject:From;
        b=QzEMCfm60tvsQRCFE5JFlNwbWGqwH65DOVkGtWu8xEQsoufrL5Gl3qvaYN+GAG5k/
         nLma9vRpdl7MhaYQseC6s8x9GdjCbYs8A68GAKv0HZx6WYJIf3CDFaVOwZgYQ/FJMG
         P8Cpqzc0mDtnWjuI5Dk+mjRPCokzbNcIlB/bUeCg=
Date:   Fri, 11 Nov 2022 15:07:38 -0800
To:     mm-commits@vger.kernel.org, nathan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-introduce-recompress-sysfs-knob-fix.patch added to mm-unstable branch
Message-Id: <20221111230739.41F26C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: we should always zero out err variable in recompress loop
has been added to the -mm mm-unstable branch.  Its filename is
     zram-introduce-recompress-sysfs-knob-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-introduce-recompress-sysfs-knob-fix.patch

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
zram-introduce-recompress-sysfs-knob-fix.patch
zram-add-recompress-flag-to-read_block_state.patch
zram-clarify-writeback_store-comment.patch
zram-use-is_err_value-to-check-for-zs_malloc-errors.patch
zram-remove-redundant-checks-from-zram_recompress.patch
zram-add-algo-parameter-support-to-zram_recompress.patch
documentation-add-zram-recompression-documentation.patch
zram-add-incompressible-writeback.patch
zram-add-incompressible-flag-to-read_block_state.patch

