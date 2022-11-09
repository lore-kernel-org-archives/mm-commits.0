Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20EDC4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 04:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiKIEEn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 23:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiKIEEi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 23:04:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91DA1E722
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 20:04:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D56561874
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 04:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C48C433C1;
        Wed,  9 Nov 2022 04:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667966667;
        bh=5D8PHTgyGTcFMV1v/j2iiFgJ00HmUQxPrBCZUSYjt4Y=;
        h=Date:To:From:Subject:From;
        b=tUSHwd2X5e1Mf0bZ3ztlX5Shenzqyjek7kSMp83CGMgTITd7OsAb413JDiytCrpfH
         0WEIHs9G6MnQ0py/X+/BdrkyUgCvj/oSSqyoaRyMxwNGX+jlOK911A/2Saa8R73+Qn
         iJ2C6q/AkR1k+tsIu77oktZdVwTm4zKm0PGzrWBY=
Date:   Tue, 08 Nov 2022 20:04:26 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] zram-add-recompression-algorithm-choice-to-kconfig.patch removed from -mm tree
Message-Id: <20221109040427.90C48C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zram: add recompression algorithm choice to Kconfig
has been removed from the -mm tree.  Its filename was
     zram-add-recompression-algorithm-choice-to-kconfig.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add recompression algorithm choice to Kconfig
Date: Tue, 18 Oct 2022 13:55:30 +0900

Make (secondary) recompression algorithm selectable just like we do it for
the (primary) default one.

Link: https://lkml.kernel.org/r/20221018045533.2396670-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |   40 ++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_drv.c |    2 -
 2 files changed, 41 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/Kconfig~zram-add-recompression-algorithm-choice-to-kconfig
+++ a/drivers/block/zram/Kconfig
@@ -93,3 +93,43 @@ config ZRAM_MULTI_COMP
 
 	SIZE (in bytes) parameter sets the object size watermark: idle
 	objects that are of a smaller size will not get recompressed.
+
+choice
+	prompt "Default zram recompression algorithm"
+	default ZRAM_DEF_RECOMP_ZSTD
+	depends on ZRAM && ZRAM_MULTI_COMP
+
+config ZRAM_DEF_RECOMP_LZORLE
+	bool "lzo-rle"
+	depends on CRYPTO_LZO
+
+config ZRAM_DEF_RECOMP_ZSTD
+	bool "zstd"
+	depends on CRYPTO_ZSTD
+
+config ZRAM_DEF_RECOMP_LZ4
+	bool "lz4"
+	depends on CRYPTO_LZ4
+
+config ZRAM_DEF_RECOMP_LZO
+	bool "lzo"
+	depends on CRYPTO_LZO
+
+config ZRAM_DEF_RECOMP_LZ4HC
+	bool "lz4hc"
+	depends on CRYPTO_LZ4HC
+
+config ZRAM_DEF_RECOMP_842
+	bool "842"
+	depends on CRYPTO_842
+
+endchoice
+
+config ZRAM_DEF_RECOMP
+	string
+	default "lzo-rle" if ZRAM_DEF_RECOMP_LZORLE
+	default "zstd" if ZRAM_DEF_RECOMP_ZSTD
+	default "lz4" if ZRAM_DEF_RECOMP_LZ4
+	default "lzo" if ZRAM_DEF_RECOMP_LZO
+	default "lz4hc" if ZRAM_DEF_RECOMP_LZ4HC
+	default "842" if ZRAM_DEF_RECOMP_842
--- a/drivers/block/zram/zram_drv.c~zram-add-recompression-algorithm-choice-to-kconfig
+++ a/drivers/block/zram/zram_drv.c
@@ -44,7 +44,7 @@ static int zram_major;
 static const char *default_comp_algs[ZRAM_MAX_ZCOMPS] = {
 	CONFIG_ZRAM_DEF_COMP,
 #ifdef CONFIG_ZRAM_MULTI_COMP
-	"zstd",
+	CONFIG_ZRAM_DEF_RECOMP,
 #endif
 };
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

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

