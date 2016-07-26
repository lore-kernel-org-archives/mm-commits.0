From: akpm@linux-foundation.org
Subject: [folded-merged] zram-add-more-compression-algorithms-v3.patch
 removed from -mm tree
Date: Tue, 26 Jul 2016 14:51:07 -0700
Message-ID: <5797db4b.Wx4WXuHr/ZqJY8vx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbcGZVvI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:51:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-add-more-compression-algorithms-v3
has been removed from the -mm tree.  Its filename was
     zram-add-more-compression-algorithms-v3.patch

This patch was dropped because it was folded into zram-add-more-compression-algorithms.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram-add-more-compression-algorithms-v3

Link: http://lkml.kernel.org/r/20160604024902.11778-7-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/block/zram/zcomp.c~zram-add-more-compression-algorithms-v3 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-add-more-compression-algorithms-v3
+++ a/drivers/block/zram/zcomp.c
@@ -23,9 +23,15 @@ static const char * const backends[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_DEFLATE)
 	"deflate",
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_LZ4HC)
 	"lz4hc",
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_842)
 	"842",
+#endif
 	NULL
 };
 
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-add-more-compression-algorithms.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

