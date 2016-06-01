From: akpm@linux-foundation.org
Subject: [folded-dropped]
 zram-align-zcomp-interface-to-crypto-comp-api.patch removed from -mm tree
Date: Tue, 31 May 2016 19:01:04 -0700
Message-ID: <574e41e0./RZDElPU/sSxyite%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbcFACBH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 22:01:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: align zcomp interface to crypto comp API
has been removed from the -mm tree.  Its filename was
     zram-align-zcomp-interface-to-crypto-comp-api.patch

This patch was dropped because it was folded into zram-switch-to-crypto-compress-api.patch

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: align zcomp interface to crypto comp API

A cosmetic change:
update zcomp interface to be more aligned with the crypto API.

Link: http://lkml.kernel.org/r/20160531122017.2878-4-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    5 ++---
 drivers/block/zram/zcomp.h    |    5 ++---
 drivers/block/zram/zram_drv.c |    2 +-
 3 files changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-align-zcomp-interface-to-crypto-comp-api drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-align-zcomp-interface-to-crypto-comp-api
+++ a/drivers/block/zram/zcomp.c
@@ -103,7 +103,7 @@ void zcomp_stream_put(struct zcomp *comp
 }
 
 int zcomp_compress(struct zcomp_strm *zstrm,
-		const unsigned char *src, unsigned int *dst_len)
+		const void *src, unsigned int *dst_len)
 {
 	/*
 	 * Our dst memory (zstrm->buffer) is always `2 * PAGE_SIZE' sized
@@ -127,8 +127,7 @@ int zcomp_compress(struct zcomp_strm *zs
 }
 
 int zcomp_decompress(struct zcomp_strm *zstrm,
-		const unsigned char *src,
-		size_t src_len, unsigned char *dst)
+		const void *src, unsigned int src_len, void *dst)
 {
 	unsigned int dst_len = PAGE_SIZE;
 
diff -puN drivers/block/zram/zcomp.h~zram-align-zcomp-interface-to-crypto-comp-api drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-align-zcomp-interface-to-crypto-comp-api
+++ a/drivers/block/zram/zcomp.h
@@ -49,11 +49,10 @@ struct zcomp_strm *zcomp_stream_get(stru
 void zcomp_stream_put(struct zcomp *comp);
 
 int zcomp_compress(struct zcomp_strm *zstrm,
-		const unsigned char *src, unsigned int *dst_len);
+		const void *src, unsigned int *dst_len);
 
 int zcomp_decompress(struct zcomp_strm *zstrm,
-		const unsigned char *src,
-		size_t src_len, unsigned char *dst);
+		const void *src, unsigned int src_len, void *dst);
 
 bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
 #endif /* _ZCOMP_H_ */
diff -puN drivers/block/zram/zram_drv.c~zram-align-zcomp-interface-to-crypto-comp-api drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-align-zcomp-interface-to-crypto-comp-api
+++ a/drivers/block/zram/zram_drv.c
@@ -563,7 +563,7 @@ static int zram_decompress_page(struct z
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle;
-	size_t size;
+	unsigned int size;
 
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	handle = meta->table[index].handle;
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-add-more-compression-algorithms.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

