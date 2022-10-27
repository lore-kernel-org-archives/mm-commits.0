Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CF94FA3742
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbiJ0UEM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiJ0UEB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:04:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F853F1CB
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D323624D6
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F614C433D7;
        Thu, 27 Oct 2022 20:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901035;
        bh=/GYUYscLeiSOVy7NDAUqd5V9qf0lNfUxfXhOYe7DGyc=;
        h=Date:To:From:Subject:From;
        b=DO5K28AFHQV+9Q/6Hcq4iNH06ut63rlJCpqjMyAx36VE9wIsGLHkbpl7RJIgx7OKe
         zsHyPd+5t6aB+hkDBr2tezOuZv8Occa7tEKi52mtI+QC20M3rThmIF/de9ynXArNGP
         Qad+ydZyKVJzOi+2zWcNDGylQRjJ2Woi/h1SxgJM=
Date:   Thu, 27 Oct 2022 13:03:54 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-huge-size-watermark-cannot-be-global.patch added to mm-unstable branch
Message-Id: <20221027200355.7F614C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: huge size watermark cannot be global
has been added to the -mm mm-unstable branch.  Its filename is
     zram-huge-size-watermark-cannot-be-global.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-huge-size-watermark-cannot-be-global.patch

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
Subject: zram: huge size watermark cannot be global
Date: Thu, 27 Oct 2022 13:26:47 +0900

ZRAM will pass pool specific limit on number of pages per-zspages which
will affect pool's characteristics.  Namely huge size class watermark
value.  Move huge_class_size to struct zram, because this value now can be
unique to the pool (zram device).

Link: https://lkml.kernel.org/r/20221027042651.234524-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/block/zram/zram_drv.c~zram-huge-size-watermark-cannot-be-global
+++ a/drivers/block/zram/zram_drv.c
@@ -50,12 +50,6 @@ static const char *default_comp_algs[ZRA
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
-/*
- * Pages that compress to sizes equals or greater than this are stored
- * uncompressed in memory.
- */
-static size_t huge_class_size;
-
 static const struct block_device_operations zram_devops;
 
 static void zram_free_page(struct zram *zram, size_t index);
@@ -1259,8 +1253,7 @@ static bool zram_meta_alloc(struct zram
 		return false;
 	}
 
-	if (!huge_class_size)
-		huge_class_size = zs_huge_class_size(zram->mem_pool);
+	zram->huge_class_size = zs_huge_class_size(zram->mem_pool);
 	return true;
 }
 
@@ -1488,7 +1481,7 @@ compress_again:
 		return ret;
 	}
 
-	if (comp_len >= huge_class_size)
+	if (comp_len >= zram->huge_class_size)
 		comp_len = PAGE_SIZE;
 	/*
 	 * handle allocation has 2 paths:
@@ -1665,7 +1658,7 @@ static int zram_recompress(struct zram *
 	 * in a way that will save us memory. Mark the object so that we
 	 * don't attempt to re-compress it again (RECOMP_SKIP).
 	 */
-	if (comp_len_next >= huge_class_size ||
+	if (comp_len_next >= zram->huge_class_size ||
 	    comp_len_next >= comp_len_prev ||
 	    class_index_next >= class_index_prev ||
 	    ret) {
--- a/drivers/block/zram/zram_drv.h~zram-huge-size-watermark-cannot-be-global
+++ a/drivers/block/zram/zram_drv.h
@@ -121,6 +121,11 @@ struct zram {
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_ZCOMPS];
 	/*
+	 * Pages that compress to sizes equal or greater than this are stored
+	 * uncompressed in memory.
+	 */
+	size_t huge_class_size;
+	/*
 	 * zram is claimed so open request will be failed
 	 */
 	bool claim; /* Protected by disk->open_mutex */
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
zsmalloc-turn-zspage-order-into-runtime-variable.patch
zsmalloc-move-away-from-page-order-defines.patch
zsmalloc-make-huge-class-watermark-zs_pool-member.patch
zram-huge-size-watermark-cannot-be-global.patch
zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch
zram-add-pages_per_pool_page-device-attribute.patch
documentation-document-zram-pages_per_pool_page-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch

