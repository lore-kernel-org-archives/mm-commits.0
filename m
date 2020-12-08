Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499D9C4361B
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 23:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F7AB23B19
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 23:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgLHXw7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Dec 2020 18:52:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbgLHXw7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Dec 2020 18:52:59 -0500
Date:   Tue, 08 Dec 2020 15:52:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607471538;
        bh=zrbSON/wu0TYgDiYK1pbX0RNGZmECWEgTAJLf5wLylI=;
        h=From:To:Subject:From;
        b=UbxKtjfYvgN5veqaRy/voDK4KWP8RHZwmIfQDji7KIA0+ewbMv+fBZpRr61yXwCRa
         cfQl8bPIOic/uwOsMjZnwGlzdTzskyH4PhKFqGF71m54fHNhFgu2zJZjDmSBqX3Kto
         t+62XgSw5f/kpWyRj2e1R+UcDLrrpPx+zykNICPo=
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com,
        minchan@kernel.org, rsalvaterra@gmail.com
Subject:  + zram-break-the-strict-dependency-from-lzo.patch added to
 -mm tree
Message-ID: <20201208235217.uwCNP%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
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

>From the beginning, the zram block device always enabled CRYPTO_LZO, since
lzo-rle is hardcoded as the fallback compression algorithm. As a consequence, on
systems where another compression algorithm is chosen (e.g. CRYPTO_ZSTD), the
lzo kernel module becomes unused, while still having to be built/loaded.

This patch removes the hardcoded lzo-rle dependency and allows the user to
select the default compression algorithm for zram at build time. The previous
behaviour is kept, as the default algorithm is still lzo-rle.

Link: https://lkml.kernel.org/r/20201207121245.50529-1-rsalvaterra@gmail.com
Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
Suggested-by: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig    |   42 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zcomp.c    |    2 +
 drivers/block/zram/zram_drv.c |    2 -
 3 files changed, 44 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/Kconfig~zram-break-the-strict-dependency-from-lzo
+++ a/drivers/block/zram/Kconfig
@@ -2,7 +2,7 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK && SYSFS && ZSMALLOC && CRYPTO
-	select CRYPTO_LZO
+	depends on CRYPTO_LZO || CRYPTO_ZSTD || CRYPTO_LZ4 || CRYPTO_LZ4HC || CRYPTO_842
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
 	  Pages written to these disks are compressed and stored in memory
@@ -14,6 +14,46 @@ config ZRAM
 
 	  See Documentation/admin-guide/blockdev/zram.rst for more information.
 
+choice
+	prompt "Default zram compressor"
+	default ZRAM_DEF_COMP_LZORLE
+	depends on ZRAM
+
+config ZRAM_DEF_COMP_LZORLE
+	bool "lzo-rle"
+	depends on CRYPTO_LZO
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
+	depends on CRYPTO_LZO
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

