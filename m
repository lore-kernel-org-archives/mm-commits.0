Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208E0FA3740
	for <mm-commits@archiver.kernel.org>; Thu, 27 Oct 2022 20:04:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236516AbiJ0UEN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236972AbiJ0UD6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2022 16:03:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C4E89952
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 13:03:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80E20B82640
        for <mm-commits@vger.kernel.org>; Thu, 27 Oct 2022 20:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166A6C433D6;
        Thu, 27 Oct 2022 20:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666901032;
        bh=zhCTnkR++p/Um7KpGsJOWhZ8BnakTp9TjhiT4ZV5X4E=;
        h=Date:To:From:Subject:From;
        b=0dA5TL6sCMoGQhjO9itLSPAE4i6y1EuDcIygpod875h4F4E+/yv43NchYZUws8BT/
         xb4al0c5nnzpRkkVjXCkC3tjn4g71M0xLP2ZCEV/D5p5o6B5Wp7ERvxZd4vaYKT6wt
         y2lImoOsw5xuKZejU+P/kpU7+sPYbBhtp++cuauY=
Date:   Thu, 27 Oct 2022 13:03:51 -0700
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        avromanov@sberdevices.ru, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-move-away-from-page-order-defines.patch added to mm-unstable branch
Message-Id: <20221027200352.166A6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: move away from page order defines
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-move-away-from-page-order-defines.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-move-away-from-page-order-defines.patch

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
Subject: zsmalloc: move away from page order defines
Date: Thu, 27 Oct 2022 13:26:45 +0900

There is no reason for us to require pages per-zspage to be a power of
two.  Rename macros and use plain limit numbers there instead of 2 ^ N
values.  This will let us to have more tunable limits.

Link: https://lkml.kernel.org/r/20221027042651.234524-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Alexey Romanov <avromanov@sberdevices.ru>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/zsmalloc.h~zsmalloc-move-away-from-page-order-defines
+++ a/include/linux/zsmalloc.h
@@ -33,17 +33,15 @@ enum zs_mapmode {
 	 */
 };
 
-#define ZS_PAGE_ORDER_2		2
-#define ZS_PAGE_ORDER_4		4
-
 /*
- * A single 'zspage' is composed of up to 2^N discontiguous 0-order (single)
- * pages. ZS_MAX_PAGE_ORDER defines upper limit on N, ZS_MIN_PAGE_ORDER
- * defines lower limit on N. ZS_DEFAULT_PAGE_ORDER is recommended value.
+ * A single 'zspage' is composed of up to N discontiguous 0-order
+ * (single) pages. ZS_MAX_PAGES_PER_ZSPAGE defines upper limit on N,
+ * ZS_MIN_PAGES_PER_ZSPAGE defines lower limit on N.
+ * ZS_DEFAULT_PAGES_PER_ZSPAGE is a recommended value.
  */
-#define ZS_MIN_PAGE_ORDER	ZS_PAGE_ORDER_2
-#define ZS_MAX_PAGE_ORDER	ZS_PAGE_ORDER_4
-#define ZS_DEFAULT_PAGE_ORDER	ZS_PAGE_ORDER_2
+#define ZS_MIN_PAGES_PER_ZSPAGE	1
+#define ZS_MAX_PAGES_PER_ZSPAGE	16
+#define ZS_DEFAULT_PAGES_PER_ZSPAGE	4
 
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
--- a/mm/zsmalloc.c~zsmalloc-move-away-from-page-order-defines
+++ a/mm/zsmalloc.c
@@ -74,8 +74,6 @@
  */
 #define ZS_ALIGN		8
 
-#define ZS_MAX_PAGES_PER_ZSPAGE	(_AC(1, UL) << ZS_MAX_PAGE_ORDER)
-
 #define ZS_HANDLE_SIZE (sizeof(unsigned long))
 
 /*
@@ -2215,7 +2213,7 @@ struct zs_pool *zs_create_pool(const cha
 	if (!pool)
 		return NULL;
 
-	max_pages_per_zspage = 1U << ZS_DEFAULT_PAGE_ORDER;
+	max_pages_per_zspage = ZS_DEFAULT_PAGES_PER_ZSPAGE;
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

