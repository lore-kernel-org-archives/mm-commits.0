From: akpm@linux-foundation.org
Subject: [patch 040/126] zram: add more compression algorithms
Date: Tue, 26 Jul 2016 15:22:56 -0700
Message-ID: <5797e2c0.pW2nm3c6/heyMWYl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117AbcGZWW6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: add more compression algorithms

Add "deflate", "lz4hc", "842" algorithms to the list of known compression
backends.  The real availability of those algorithms, however, depends on
the corresponding CONFIG_CRYPTO_FOO config options.

[sergey.senozhatsky@gmail.com: zram-add-more-compression-algorithms-v3]
  Link: http://lkml.kernel.org/r/20160604024902.11778-7-sergey.senozhatsky@gmail.com
Link: http://lkml.kernel.org/r/20160531122017.2878-8-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/block/zram/zcomp.c~zram-add-more-compression-algorithms drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-add-more-compression-algorithms
+++ a/drivers/block/zram/zcomp.c
@@ -23,6 +23,15 @@ static const char * const backends[] = {
 #if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
 #endif
+#if IS_ENABLED(CONFIG_CRYPTO_DEFLATE)
+	"deflate",
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_LZ4HC)
+	"lz4hc",
+#endif
+#if IS_ENABLED(CONFIG_CRYPTO_842)
+	"842",
+#endif
 	NULL
 };
 
_
