Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D71B4C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 00:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbiKJAbf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 19:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232214AbiKJAbX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 19:31:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07F429CB2
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 16:31:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1FCCE61D25
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 00:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76752C433D7;
        Thu, 10 Nov 2022 00:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668040266;
        bh=A43PmxzK/cGZwPaUoAA9Ga1ebyqM6vdnrK2rJxnEEqs=;
        h=Date:To:From:Subject:From;
        b=OUJxReG5Q2tvIf3CcgSBfV4R9tC52P9Xrh0kXJ2werdCXr1CLBizj0hkqWbpzc7CI
         ssQLUJVFKaAh5IvIVzegKF9c0nbUknEZns7fXlTmnBwbIjCSbta7vL54d0Njugbs5M
         3/++VTtEG7QNqFMfVx8GgV4t/8ZL/mU4Zm2iE7+A=
Date:   Wed, 09 Nov 2022 16:31:05 -0800
To:     mm-commits@vger.kernel.org, suleiman@google.com, nphamcs@gmail.com,
        ngupta@vflare.org, minchan@kernel.org, avromanov@sberdevices.ru,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-redundant-checks-from-zram_recompress.patch added to mm-unstable branch
Message-Id: <20221110003106.76752C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove redundant checks from zram_recompress()
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-redundant-checks-from-zram_recompress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-redundant-checks-from-zram_recompress.patch

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
Subject: zram: remove redundant checks from zram_recompress()
Date: Wed, 9 Nov 2022 20:50:43 +0900

Size class index comparison is powerful enough so we can remove object
size comparisons.

Link: https://lkml.kernel.org/r/20221109115047.2921851-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Suleiman Souhlal <suleiman@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-remove-redundant-checks-from-zram_recompress
+++ a/drivers/block/zram/zram_drv.c
@@ -1722,9 +1722,7 @@ static int zram_recompress(struct zram *
 							comp_len_new);
 
 		/* Continue until we make progress */
-		if (comp_len_new >= huge_class_size ||
-		    comp_len_new >= comp_len_old ||
-		    class_index_new >= class_index_old ||
+		if (class_index_new >= class_index_old ||
 		    (threshold && comp_len_new >= threshold)) {
 			zcomp_stream_put(zram->comps[prio]);
 			continue;
@@ -1747,9 +1745,7 @@ static int zram_recompress(struct zram *
 	 * that would save memory, mark the object as incompressible so that
 	 * we will not try to compress it again.
 	 */
-	if (comp_len_new >= huge_class_size ||
-	    comp_len_new >= comp_len_old ||
-	    class_index_new >= class_index_old) {
+	if (class_index_new >= class_index_old) {
 		zram_set_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
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

