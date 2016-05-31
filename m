From: akpm@linux-foundation.org
Subject: + zram-align-zcomp-interface-to-crypto-comp-api.patch added to
 -mm tree
Date: Tue, 31 May 2016 12:10:44 -0700
Message-ID: <574de1b4.NzXzA9xOz3wABaLn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbcEaTKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: align zcomp interface to crypto comp API
has been added to the -mm tree.  Its filename is
     zram-align-zcomp-interface-to-crypto-comp-api.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-align-zcomp-interface-to-crypto-comp-api.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-align-zcomp-interface-to-crypto-comp-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
zram-align-zcomp-interface-to-crypto-comp-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-add-more-compression-algorithms.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

