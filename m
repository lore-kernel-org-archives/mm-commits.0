Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 236FDECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 31 Oct 2022 22:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbiJaW3W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Oct 2022 18:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiJaW3S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2022 18:29:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DEA26D6
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 15:28:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E072FB81AD7
        for <mm-commits@vger.kernel.org>; Mon, 31 Oct 2022 22:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89586C433D6;
        Mon, 31 Oct 2022 22:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667255333;
        bh=YVoerWS1AohM1W9MshdbCZNtuL7YnE2ga3ng7XcoGgE=;
        h=Date:To:From:Subject:From;
        b=uc91qiFEM+JeHvc8T1HPN9IrAAWENEFX0YNaLoRR5rg3mD4sf3KoM6KWUfv0GWcfx
         XQVXJfsTzKFSIxymFYuA30sbdMfOteT7BBwFcdX5fgn4NSOSZgN+4RI1i0avAVF4Pk
         rUZ3osVL5Md5MIcXmKfx+QGVWQl1UpvzkdI0vwiM=
Date:   Mon, 31 Oct 2022 15:28:52 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-huge-size-watermark-cannot-be-global.patch added to mm-unstable branch
Message-Id: <20221031222853.89586C433D6@smtp.kernel.org>
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
Date: Mon, 31 Oct 2022 14:41:04 +0900

ZRAM will pass pool specific limit on number of pages per-zspages which
will affect pool's characteristics.  Namely huge size class watermark
value.  Move huge_class_size to struct zram, because this value now can be
unique to the pool (zram device).

Link: https://lkml.kernel.org/r/20221031054108.541190-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   13 +++----------
 drivers/block/zram/zram_drv.h |    5 +++++
 2 files changed, 8 insertions(+), 10 deletions(-)

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

