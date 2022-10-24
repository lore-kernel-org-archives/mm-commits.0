Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0201C67871
	for <mm-commits@archiver.kernel.org>; Mon, 24 Oct 2022 22:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbiJXWUg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Oct 2022 18:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbiJXWUL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 24 Oct 2022 18:20:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294BC310115
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 13:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C96AFB811FB
        for <mm-commits@vger.kernel.org>; Mon, 24 Oct 2022 20:35:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC33C433C1;
        Mon, 24 Oct 2022 20:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666643736;
        bh=cbEZ8Y8ix0HwQ+e/Is0ESYMmuTrDWltuYSTkD0FPS4A=;
        h=Date:To:From:Subject:From;
        b=W3eyvQzJQrXzaA0gL5ylNwE278cuWnWtbBVPoOFetrFNkl0VoQE5gohD2FtPvgd1P
         V+B/N4QoMddnpRtyNMkAapsd0XXngNREElXh3bvEIp/rHdoUqWZjqgpk2AO3zDCac9
         CS1Gopn2wrrMos12QRYPiDsodAredxhrk4iWXsA8=
Date:   Mon, 24 Oct 2022 13:35:35 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch added to mm-unstable branch
Message-Id: <20221024203536.6BC33C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc/zram: pass zspage order to zs_create_pool()
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch

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
Subject: zsmalloc/zram: pass zspage order to zs_create_pool()
Date: Tue, 25 Oct 2022 01:12:09 +0900

Allow zsmalloc pool owner to specify max zspage (during pool creation), so
that different pools can have different characteristics.

Link: https://lkml.kernel.org/r/20221024161213.3221725-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    3 ++-
 include/linux/zsmalloc.h      |    2 +-
 mm/zsmalloc.c                 |   11 ++++++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zsmalloc-zram-pass-zspage-order-to-zs_create_pool
+++ a/drivers/block/zram/zram_drv.c
@@ -1253,7 +1253,8 @@ static bool zram_meta_alloc(struct zram
 	if (!zram->table)
 		return false;
 
-	zram->mem_pool = zs_create_pool(zram->disk->disk_name);
+	zram->mem_pool = zs_create_pool(zram->disk->disk_name,
+					ZS_DEFAULT_PAGE_ORDER);
 	if (!zram->mem_pool) {
 		vfree(zram->table);
 		return false;
--- a/include/linux/zsmalloc.h~zsmalloc-zram-pass-zspage-order-to-zs_create_pool
+++ a/include/linux/zsmalloc.h
@@ -53,7 +53,7 @@ struct zs_pool_stats {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(const char *name);
+struct zs_pool *zs_create_pool(const char *name, u32 zspage_order);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size, gfp_t flags);
--- a/mm/zsmalloc.c~zsmalloc-zram-pass-zspage-order-to-zs_create_pool
+++ a/mm/zsmalloc.c
@@ -369,7 +369,7 @@ static void *zs_zpool_create(const char
 	 * different contexts and its caller must provide a valid
 	 * gfp mask.
 	 */
-	return zs_create_pool(name);
+	return zs_create_pool(name, ZS_DEFAULT_PAGE_ORDER);
 }
 
 static void zs_zpool_destroy(void *pool)
@@ -2177,6 +2177,7 @@ static int zs_register_shrinker(struct z
 /**
  * zs_create_pool - Creates an allocation pool to work from.
  * @name: pool name to be created
+ * @zspage_order: maximum order of zspage
  *
  * This function must be called before anything when using
  * the zsmalloc allocator.
@@ -2184,17 +2185,21 @@ static int zs_register_shrinker(struct z
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(const char *name)
+struct zs_pool *zs_create_pool(const char *name, u32 zspage_order)
 {
 	int i;
 	struct zs_pool *pool;
 	struct size_class *prev_class = NULL;
 
+	if (WARN_ON(zspage_order < ZS_MIN_PAGE_ORDER ||
+		    zspage_order > ZS_MAX_PAGE_ORDER))
+		return NULL;
+
 	pool = kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool)
 		return NULL;
 
-	pool->max_pages_per_zspage = 1U << ZS_MIN_PAGE_ORDER;
+	pool->max_pages_per_zspage = 1U << zspage_order;
 	/* min_alloc_size must be multiple of ZS_ALIGN */
 	pool->min_alloc_size = (pool->max_pages_per_zspage << PAGE_SHIFT) >>
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
zsmalloc-zram-pass-zspage-order-to-zs_create_pool.patch
zram-add-pool_page_order-device-attribute.patch
documentation-document-zram-pool_page_order-attribute.patch
zsmalloc-break-out-of-loop-when-found-perfect-zspage-order.patch
zsmalloc-make-sure-we-select-best-zspage-size.patch

