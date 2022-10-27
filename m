Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A52BFA3743
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbiJ0UEO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiJ0UEC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:04:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC195C943
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECDAC624DA
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:03:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF34C433D6;
        Thu, 27 Oct 2022 20:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901037;
        bh=4NJ8p88Z+ZxKwj66q0ldIPBiJwQv+nSLTECzV0cl5uY=;
        h=Date:To:From:Subject:From;
        b=Bd0pL+hSEeY4z+S0RNTHU6ToMXfpmdahbMFtUoeejxW306tosnOg5H0fiSvg+wSO3
         TKFg7UKz551plW6PSWZAd1xfLycARqG0nNczvkggrBVxYZFcowsgUHwBUE+krfuBlk
         4DoKtPqNe1kmlfGe9EP/v0OeqBLCRmXWoYhdifXQ=
Date:   Thu, 27 Oct 2022 13:03:56 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch added to mm-unstable branch
Message-Id: <20221027200357.3FF34C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: pass limit on pages per-zspage to zs_create_pool()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool.patch

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
Subject: zsmalloc: pass limit on pages per-zspage to zs_create_pool()
Date: Thu, 27 Oct 2022 13:26:48 +0900

Allow zsmalloc pool owner to specify max number of pages per-zspage
(during pool creation), so that different pools can have different
characteristics.

By default we pass ZS_DEFAULT_PAGES_PER_ZSPAGE which is 4 (matches the
current order 2 zspages limit).

Link: https://lkml.kernel.org/r/20221027042651.234524-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/drivers/block/zram/zram_drv.c~zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool
+++ a/drivers/block/zram/zram_drv.c
@@ -1247,7 +1247,8 @@ static bool zram_meta_alloc(struct zram
 	if (!zram->table)
 		return false;
 
-	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
+	zram->mem_pool = zs_create_pool(zram->disk->disk_name,
+					ZS_DEFAULT_PAGES_PER_ZSPAGE);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
 		return false;
--- a/include/linux/zsmalloc.h~zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool
+++ a/include/linux/zsmalloc.h
@@ -50,7 +50,7 @@ struct zs_pool_stats {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(const char *name);
+struct zs_pool *zs_create_pool(const char *name, u32 max_pages_per_zspage);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags);
--- a/mm/zsmalloc.c~zsmalloc-pass-limit-on-pages-per-zspage-to-zs_create_pool
+++ a/mm/zsmalloc.c
@@ -366,7 +366,7 @@ static void *zs_zpool_create(const char
 	 * different contexts and its caller must provide a valid
 	 * gfp mask.
 	 */
-	return zs_create_pool(name);
+	return zs_create_pool(name, ZS_DEFAULT_PAGES_PER_ZSPAGE);
 }
 
 static void zs_zpool_destroy(void *pool)
@@ -2195,6 +2195,7 @@ static int zs_register_shrinker(struct z
 /**
  * zs_create_pool - Creates an allocation pool to work from.
  * @name: pool name to be created
+ * @max_pages_per_zspage: maximum number of pages per-zspage
  *
  * This function must be called before anything when using
  * the zsmalloc allocator.
@@ -2202,18 +2203,20 @@ static int zs_register_shrinker(struct z
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(const char *name)
+struct zs_pool *zs_create_pool(const char *name, u32 max_pages_per_zspage)
 {
 	int i;
 	struct zs_pool *pool;
 	struct size_class *prev_class = NULL;
-	u32 max_pages_per_zspage;
+
+	if (WARN_ON(max_pages_per_zspage < ZS_MIN_PAGES_PER_ZSPAGE ||
+		    max_pages_per_zspage > ZS_MAX_PAGES_PER_ZSPAGE))
+		return NULL;
 
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
-	max_pages_per_zspage = ZS_DEFAULT_PAGES_PER_ZSPAGE;
 	/* min_alloc_size must be multiple of ZS_ALIGN */
 	pool->min_alloc_size = (max_pages_per_zspage << PAGE_SHIFT) >>
 		OBJ_INDEX_BITS;
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

