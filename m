From: akpm@linux-foundation.org
Subject: [folded-merged] zram-delete-custom-lzo-lz4-v3.patch removed from
 -mm tree
Date: Tue, 26 Jul 2016 14:50:29 -0700
Message-ID: <5797db25.lWru3YXmHazEeXh1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbcGZVua (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 17:50:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram-delete-custom-lzo-lz4-v3
has been removed from the -mm tree.  Its filename was
     zram-delete-custom-lzo-lz4-v3.patch

This patch was dropped because it was folded into zram-delete-custom-lzo-lz4.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram-delete-custom-lzo-lz4-v3

Link: http://lkml.kernel.org/r/20160604024902.11778-6-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/block/zram/zcomp.c~zram-delete-custom-lzo-lz4-v3 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-delete-custom-lzo-lz4-v3
+++ a/drivers/block/zram/zcomp.c
@@ -20,7 +20,9 @@
 
 static const char * const backends[] = {
 	"lzo",
+#if IS_ENABLED(CONFIG_CRYPTO_LZ4)
 	"lz4",
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
zram-add-more-compression-algorithms-v3.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

