From: akpm@linux-foundation.org
Subject: + zram-delete-custom-lzo-lz4.patch added to -mm tree
Date: Tue, 31 May 2016 12:10:50 -0700
Message-ID: <574de1ba.jmxeUDJPwOEVMAdH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbcEaTKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: delete custom lzo/lz4
has been added to the -mm tree.  Its filename is
     zram-delete-custom-lzo-lz4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-delete-custom-lzo-lz4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-delete-custom-lzo-lz4.patch

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
Subject: zram: delete custom lzo/lz4

Remove lzo/lz4 backends, we use crypto API now.

Link: http://lkml.kernel.org/r/20160531122017.2878-7-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/Kconfig     |    9 ----
 drivers/block/zram/Makefile    |    4 --
 drivers/block/zram/zcomp.c     |    2 -
 drivers/block/zram/zcomp.h     |   15 --------
 drivers/block/zram/zcomp_lz4.c |   56 -------------------------------
 drivers/block/zram/zcomp_lz4.h |   17 ---------
 drivers/block/zram/zcomp_lzo.c |   56 -------------------------------
 drivers/block/zram/zcomp_lzo.h |   17 ---------
 8 files changed, 1 insertion(+), 175 deletions(-)

diff -puN drivers/block/zram/Kconfig~zram-delete-custom-lzo-lz4 drivers/block/zram/Kconfig
--- a/drivers/block/zram/Kconfig~zram-delete-custom-lzo-lz4
+++ a/drivers/block/zram/Kconfig
@@ -13,12 +13,3 @@ config ZRAM
 	  disks and maybe many more.
 
 	  See zram.txt for more information.
-
-config ZRAM_LZ4_COMPRESS
-	bool "Enable LZ4 algorithm support"
-	depends on ZRAM
-	select CRYPTO_LZ4
-	default n
-	help
-	  This option enables LZ4 compression algorithm support. Compression
-	  algorithm can be changed using `comp_algorithm' device attribute.
diff -puN drivers/block/zram/Makefile~zram-delete-custom-lzo-lz4 drivers/block/zram/Makefile
--- a/drivers/block/zram/Makefile~zram-delete-custom-lzo-lz4
+++ a/drivers/block/zram/Makefile
@@ -1,5 +1,3 @@
-zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
-
-zram-$(CONFIG_ZRAM_LZ4_COMPRESS) += zcomp_lz4.o
+zram-y	:=	zcomp.o zram_drv.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff -puN drivers/block/zram/zcomp.c~zram-delete-custom-lzo-lz4 drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-delete-custom-lzo-lz4
+++ a/drivers/block/zram/zcomp.c
@@ -20,9 +20,7 @@
 
 static const char * const backends[] = {
 	"lzo",
-#ifdef CONFIG_ZRAM_LZ4_COMPRESS
 	"lz4",
-#endif
 	NULL
 };
 
diff -puN drivers/block/zram/zcomp.h~zram-delete-custom-lzo-lz4 drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-delete-custom-lzo-lz4
+++ a/drivers/block/zram/zcomp.h
@@ -16,24 +16,9 @@ struct zcomp_strm {
 	struct crypto_comp *tfm;
 };
 
-/* static compression backend */
-struct zcomp_backend {
-	int (*compress)(const unsigned char *src, unsigned char *dst,
-			size_t *dst_len, void *private);
-
-	int (*decompress)(const unsigned char *src, size_t src_len,
-			unsigned char *dst);
-
-	void *(*create)(gfp_t flags);
-	void (*destroy)(void *private);
-
-	const char *name;
-};
-
 /* dynamic per-device compression frontend */
 struct zcomp {
 	struct zcomp_strm * __percpu *stream;
-	struct zcomp_backend *backend;
 	struct notifier_block notifier;
 
 	const char *name;
diff -puN drivers/block/zram/zcomp_lz4.c~zram-delete-custom-lzo-lz4 /dev/null
--- a/drivers/block/zram/zcomp_lz4.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (C) 2014 Sergey Senozhatsky.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/lz4.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-
-#include "zcomp_lz4.h"
-
-static void *zcomp_lz4_create(gfp_t flags)
-{
-	void *ret;
-
-	ret = kmalloc(LZ4_MEM_COMPRESS, flags);
-	if (!ret)
-		ret = __vmalloc(LZ4_MEM_COMPRESS,
-				flags | __GFP_HIGHMEM,
-				PAGE_KERNEL);
-	return ret;
-}
-
-static void zcomp_lz4_destroy(void *private)
-{
-	kvfree(private);
-}
-
-static int zcomp_lz4_compress(const unsigned char *src, unsigned char *dst,
-		size_t *dst_len, void *private)
-{
-	/* return  : Success if return 0 */
-	return lz4_compress(src, PAGE_SIZE, dst, dst_len, private);
-}
-
-static int zcomp_lz4_decompress(const unsigned char *src, size_t src_len,
-		unsigned char *dst)
-{
-	size_t dst_len = PAGE_SIZE;
-	/* return  : Success if return 0 */
-	return lz4_decompress_unknownoutputsize(src, src_len, dst, &dst_len);
-}
-
-struct zcomp_backend zcomp_lz4 = {
-	.compress = zcomp_lz4_compress,
-	.decompress = zcomp_lz4_decompress,
-	.create = zcomp_lz4_create,
-	.destroy = zcomp_lz4_destroy,
-	.name = "lz4",
-};
diff -puN drivers/block/zram/zcomp_lz4.h~zram-delete-custom-lzo-lz4 /dev/null
--- a/drivers/block/zram/zcomp_lz4.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * Copyright (C) 2014 Sergey Senozhatsky.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ZCOMP_LZ4_H_
-#define _ZCOMP_LZ4_H_
-
-#include "zcomp.h"
-
-extern struct zcomp_backend zcomp_lz4;
-
-#endif /* _ZCOMP_LZ4_H_ */
diff -puN drivers/block/zram/zcomp_lzo.c~zram-delete-custom-lzo-lz4 /dev/null
--- a/drivers/block/zram/zcomp_lzo.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * Copyright (C) 2014 Sergey Senozhatsky.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/lzo.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-
-#include "zcomp_lzo.h"
-
-static void *lzo_create(gfp_t flags)
-{
-	void *ret;
-
-	ret = kmalloc(LZO1X_MEM_COMPRESS, flags);
-	if (!ret)
-		ret = __vmalloc(LZO1X_MEM_COMPRESS,
-				flags | __GFP_HIGHMEM,
-				PAGE_KERNEL);
-	return ret;
-}
-
-static void lzo_destroy(void *private)
-{
-	kvfree(private);
-}
-
-static int lzo_compress(const unsigned char *src, unsigned char *dst,
-		size_t *dst_len, void *private)
-{
-	int ret = lzo1x_1_compress(src, PAGE_SIZE, dst, dst_len, private);
-	return ret == LZO_E_OK ? 0 : ret;
-}
-
-static int lzo_decompress(const unsigned char *src, size_t src_len,
-		unsigned char *dst)
-{
-	size_t dst_len = PAGE_SIZE;
-	int ret = lzo1x_decompress_safe(src, src_len, dst, &dst_len);
-	return ret == LZO_E_OK ? 0 : ret;
-}
-
-struct zcomp_backend zcomp_lzo = {
-	.compress = lzo_compress,
-	.decompress = lzo_decompress,
-	.create = lzo_create,
-	.destroy = lzo_destroy,
-	.name = "lzo",
-};
diff -puN drivers/block/zram/zcomp_lzo.h~zram-delete-custom-lzo-lz4 /dev/null
--- a/drivers/block/zram/zcomp_lzo.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/*
- * Copyright (C) 2014 Sergey Senozhatsky.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#ifndef _ZCOMP_LZO_H_
-#define _ZCOMP_LZO_H_
-
-#include "zcomp.h"
-
-extern struct zcomp_backend zcomp_lzo;
