From: akpm@linux-foundation.org
Subject: [patch 043/131] zram: remove zlib from the list of
 recommended algorithms
Date: Wed, 15 Nov 2017 17:33:53 -0800
Message-ID: <20171116013353.LaYZeLwOS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38994 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933588AbdKPBdz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:33:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky.work@gmail.com, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: zram: remove zlib from the list of recommended algorithms

ZSTD tends to outperform deflate/inflate, thus we remove zlib from the
list of recommended algorithms and recommend zstd instead.

Link: http://lkml.kernel.org/r/20170912050005.3247-2-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-remove-zlib-from-the-list-of-recommended-algorithms drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-remove-zlib-from-the-list-of-recommended-algorithms
+++ a/drivers/block/zram/zcomp.c
@@ -23,9 +23,6 @@ static const char * const backends[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
 #endif
-#if IS_ENABLED(CONFIG_CRYPTO_DEFLATE)
-	"deflate",
-#endif
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4HC)
 	"lz4hc",
 #endif
_
