Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D14C43217
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 04:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiKIEEl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 23:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiKIEE2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 23:04:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B40F1E70F
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 20:04:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB45E617EA
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 04:04:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBDBC433C1;
        Wed,  9 Nov 2022 04:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667966666;
        bh=Jhb3VlSdTLuAbLmGEqCrvbAXMDK9k4WtU/iQinQeBKI=;
        h=Date:To:From:Subject:From;
        b=K1tDqmqkHQ9Hyjthj5zo7TNfAPYAQQAMIlRAAho0UoALjW5eFBwrGcpdMdQ1HqXNO
         cbTcR+VbwQAP/yOWb8N+3BAaeW/JZ1xe7isC3RZkv76IsNGIXZbfQtgwigVJGUY2Sx
         bqXHxwf4yrDllqV3hteLUn67iRoaOm5FGj670WJk=
Date:   Tue, 08 Nov 2022 20:04:25 -0800
To:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] documentation-add-recompression-documentation.patch removed from -mm tree
Message-Id: <20221109040426.3EBDBC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: documentation: add recompression documentation
has been removed from the -mm tree.  Its filename was
     documentation-add-recompression-documentation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: documentation: add recompression documentation
Date: Tue, 18 Oct 2022 13:55:29 +0900

Document user-space visible device attributes that are enabled by
ZRAM_MULTI_COMP.

Link: https://lkml.kernel.org/r/20221018045533.2396670-6-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |   55 ++++++++++++++++++
 1 file changed, 55 insertions(+)

--- a/Documentation/admin-guide/blockdev/zram.rst~documentation-add-recompression-documentation
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -401,6 +401,61 @@ budget in next setting is user's job.
 If admin wants to measure writeback count in a certain period, they could
 know it via /sys/block/zram0/bd_stat's 3rd column.
 
+recompression
+-------------
+
+With CONFIG_ZRAM_MULTI_COMP, zram can recompress idle/huge pages using
+alternative (secondary) compression algorithm. The basic idea is that
+alternative compression algorithm can provide better compression ratio
+at a price of (potentially) slower compression/decompression speeds.
+Alternative compression algorithm can, for example, be more successful
+compressing huge pages (those that default algorithm failed to compress).
+Another application is idle pages recompression - pages that are cold and
+sit in the memory can be recompressed using more effective algorithm and,
+hence, reduce zsmalloc memory usage.
+
+With CONFIG_ZRAM_MULTI_COMP, zram will setup two compression algorithms
+per-CPU: primary and secondary ones. Primary zram compressor is explained
+in "3) Select compression algorithm", the secondary algorithm is configured
+in a similar way, using recomp_algorithm device attribute:
+
+Examples::
+
+	#show supported recompression algorithms
+	cat /sys/block/zramX/recomp_algorithm
+	zstd [lzo]
+
+	#select zstd recompression algorithm
+	echo zstd > /sys/block/zramX/recomp_algorithm
+
+Another device attribute that CONFIG_ZRAM_MULTI_COMP enables is recompress,
+which controls recompression:
+
+Examples::
+
+	#IDLE pages recompression is activated by `idle` mode
+	echo idle > /sys/block/zramX/recompress
+
+	#HUGE pages recompression is activated by `huge` mode
+	echo huge > /sys/block/zram0/recompress
+
+	#HUGE_IDLE pages recompression is activated by `huge_idle` mode
+	echo huge_idle > /sys/block/zramX/recompress
+
+The number of idle pages can be significant, so user-space can pass a size
+watermark value (in bytes) to the recompress knob, to filter out idle pages
+for recompression: zram will recompress only idle pages of equal or greater
+size:::
+
+	#recompress idle pages larger than 3000 bytes
+	echo 3000 > /sys/block/zramX/recompress
+
+	#recompress idle pages larger than 2000 bytes
+	echo 2000 > /sys/block/zramX/recompress
+
+Recompression is mostly focused on idle pages (except for huge pages
+recompression), so it works better in conjunction with memory tracking.
+
 memory tracking
 ===============
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

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

