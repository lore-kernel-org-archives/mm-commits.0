Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34609C56202
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 21:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C012F2075A
	for <mm-commits@archiver.kernel.org>; Wed, 25 Nov 2020 21:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aAfbPQTm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgKYVbR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 16:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730364AbgKYVbR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 25 Nov 2020 16:31:17 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04F9D206E0;
        Wed, 25 Nov 2020 21:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606339863;
        bh=GKbg7EsjP6FiOQPuUvcO0uHmeuiilbzhiuGQJAbPr/0=;
        h=Date:From:To:Subject:From;
        b=aAfbPQTmlLdEbU8FJrnzVBbR2ABiOEA5I8UmGLF6QJHTWwvAKs3ihm3dTTEbbxtuS
         Va8mnqX/ynXglBlltHc1B2Q0YPOFvG8WOrQ0n+ZwvwR0s+dS4Vd/ZD5aTt7rb5k7+S
         AQaok3Q/KTNLn+S0LGIKvFOfgODQewDEPsefPSzs=
Date:   Wed, 25 Nov 2020 13:31:02 -0800
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        rsalvaterra@gmail.com, sergey.senozhatsky.work@gmail.com
Subject:  + zram-break-the-strict-dependency-from-lzo.patch added
 to -mm tree
Message-ID: <20201125213102.EI9Vpki-V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zram: break the strict dependency from lzo
has been added to the -mm tree.  Its filename is
     zram-break-the-strict-dependency-from-lzo.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zram-break-the-strict-dependency-from-lzo.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zram-break-the-strict-dependency-from-lzo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rui Salvaterra <rsalvaterra@gmail.com>
Subject: zram: break the strict dependency from lzo

Since the beginning, the zram block device always enabled CRYPTO_LZO,
since lzo-rle is hardcoded as the fallback compression algorithm.  As a
consequence, on systems where another compression algorithm is chosen
(e.g.  CRYPTO_ZSTD), the lzo kernel module becomes unused, while still
having to be built/loaded.

This patch removes the hardcoded lzo-rle dependency and allows the user to
select the default compression algorithm for zram at build time.  The
previous behaviour is kept, as the default algorithm is still lzo-rle.

Link: https://lkml.kernel.org/r/20201122095051.4819-1-rsalvaterra@gmail.com
Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
Suggested-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |   41 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zcomp.c    |    2 +
 drivers/block/zram/zram_drv.c |    2 -
 3 files changed, 43 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-break-the-strict-dependency-from-lzo
+++ a/drivers/block/zram/Kconfig
@@ -2,7 +2,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK && SYSFS && ZSMALLOC && CRYPTO
-	select CRYPTO_LZO
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
 	  Pages written to these disks are compressed and stored in memory
@@ -14,6 +13,46 @@ config ZRAM
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
 
+choice
+	prompt "Default zram compressor"
+	default ZRAM_DEF_COMP_LZORLE
+	depends on ZRAM || CRYPTO_ZSTD || CRYPTO_LZ4 || CRYPTO_LZ4HC || CRYPTO_842
+
+config ZRAM_DEF_COMP_LZORLE
+	bool "lzo-rle"
+	select CRYPTO_LZO
+
+config ZRAM_DEF_COMP_ZSTD
+	bool "zstd"
+	depends on CRYPTO_ZSTD
+
+config ZRAM_DEF_COMP_LZ4
+	bool "lz4"
+	depends on CRYPTO_LZ4
+
+config ZRAM_DEF_COMP_LZO
+	bool "lzo"
+	select CRYPTO_LZO
+
+config ZRAM_DEF_COMP_LZ4HC
+	bool "lz4hc"
+	depends on CRYPTO_LZ4HC
+
+config ZRAM_DEF_COMP_842
+	bool "842"
+	depends on CRYPTO_842
+
+endchoice
+
+config ZRAM_DEF_COMP
+	string
+	default "lzo-rle" if ZRAM_DEF_COMP_LZORLE
+	default "zstd" if ZRAM_DEF_COMP_ZSTD
+	default "lz4" if ZRAM_DEF_COMP_LZ4
+	default "lzo" if ZRAM_DEF_COMP_LZO
+	default "lz4hc" if ZRAM_DEF_COMP_LZ4HC
+	default "842" if ZRAM_DEF_COMP_842
+
 config ZRAM_WRITEBACK
        bool "Write back incompressible or idle page to backing device"
        depends on ZRAM
--- a/drivers/block/zram/zcomp.c~zram-break-the-strict-dependency-from-lzo
+++ a/drivers/block/zram/zcomp.c
@@ -15,8 +15,10 @@
 #include "zcomp.h"
 
 static const char * const backends[] = {
+#if IS_ENABLED(CONFIG_CRYPTO_LZO)
 	"lzo",
 	"lzo-rle",
+#endif
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
 #endif
--- a/drivers/block/zram/zram_drv.c~zram-break-the-strict-dependency-from-lzo
+++ a/drivers/block/zram/zram_drv.c
@@ -42,7 +42,7 @@ static DEFINE_IDR(zram_index_idr);
 static DEFINE_MUTEX(zram_index_mutex);
 
 static int zram_major;
-static const char *default_compressor = "lzo-rle";
+static const char *default_compressor = CONFIG_ZRAM_DEF_COMP;
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
_

Patches currently in -mm which might be from rsalvaterra@gmail.com are

zram-break-the-strict-dependency-from-lzo.patch

