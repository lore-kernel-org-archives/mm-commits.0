Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43479C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 17 Nov 2022 20:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbiKQU0h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 17 Nov 2022 15:26:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiKQU0g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2022 15:26:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA0A697DE
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 12:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 879D36223F
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2022 20:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE5DC433D6;
        Thu, 17 Nov 2022 20:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668716794;
        bh=c13HR66sNjQsRTgmU/HQ+cqt59IhZBnfSwdMROdBzqc=;
        h=Date:To:From:Subject:From;
        b=0Xxknic8kOn1kKqEzdzy5zEB0HxV0dduip8+9BU2iWii2nOBRV5pr6M6drbhG6qsy
         DCef8xry8HKvJ96AhznbldVOip0BcmVktPQGLnQAVUK1+vFD+4d0TsTpvvYn9ynKvp
         A+2oqI1TTgPT+XBTYtABZdhspQQqQptY4SrEHgv8=
Date:   Thu, 17 Nov 2022 12:26:33 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-remove-unused-stats-fields.patch added to mm-unstable branch
Message-Id: <20221117202633.DEE5DC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: remove unused stats fields
has been added to the -mm mm-unstable branch.  Its filename is
     zram-remove-unused-stats-fields.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-remove-unused-stats-fields.patch

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
Subject: zram: remove unused stats fields
Date: Thu, 17 Nov 2022 23:13:26 +0900

We don't show num_reads and num_writes since we removed corresponding
sysfs nodes in 2017.  Block layer stats are exposed via
/sys/block/zramX/stat file.

However, we still increment those atomic vars and store them in zram
stats.  Remove leftovers.

Link: https://lkml.kernel.org/r/20221117141326.1105181-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
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
zram-remove-unused-stats-fields.patch

