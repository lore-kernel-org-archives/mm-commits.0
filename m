From: akpm@linux-foundation.org
Subject: + zram-pass-gfp-from-zcomp-frontend-to-backend.patch added to -mm tree
Date: Mon, 30 Nov 2015 16:10:17 -0800
Message-ID: <565ce569.dzvghzVzGhpWbwtj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35806 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbbLAAKS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2015 19:10:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: pass gfp from zcomp frontend to backend
has been added to the -mm tree.  Its filename is
     zram-pass-gfp-from-zcomp-frontend-to-backend.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-pass-gfp-from-zcomp-frontend-to-backend.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-pass-gfp-from-zcomp-frontend-to-backend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: pass gfp from zcomp frontend to backend

Each zcomp backend uses own gfp flag but it's pointless because the
context they could be called is driven by upper layer(ie, zcomp frontend).
 As well, zcomp frondend could call them in different context.  One
context(ie, zram init part) is it should be better to make sure successful
allocation other context(ie, further stream allocation part for
accelarating I/O speed) is just optional so let's pass gfp down from
driver (ie, zcomp frontend) like normal MM convention.

[sergey.senozhatsky@gmail.com: add missing __vmalloc zero and highmem gfps]
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c     |   24 ++++++++++++++++--------
 drivers/block/zram/zcomp.h     |    2 +-
 drivers/block/zram/zcomp_lz4.c |   16 +++-------------
 drivers/block/zram/zcomp_lzo.c |   16 +++-------------
 4 files changed, 23 insertions(+), 35 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-pass-gfp-from-zcomp-frontend-to-backend drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-pass-gfp-from-zcomp-frontend-to-backend
+++ a/drivers/block/zram/zcomp.c
@@ -74,18 +74,18 @@ static void zcomp_strm_free(struct zcomp
  * allocate new zcomp_strm structure with ->private initialized by
  * backend, return NULL on error
  */
-static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
+static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp, gfp_t flags)
 {
-	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_NOIO);
+	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), flags);
 	if (!zstrm)
 		return NULL;
 
-	zstrm->private = comp->backend->create();
+	zstrm->private = comp->backend->create(flags);
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
-	zstrm->buffer = (void *)__get_free_pages(GFP_NOIO | __GFP_ZERO, 1);
+	zstrm->buffer = (void *)__get_free_pages(flags | __GFP_ZERO, 1);
 	if (!zstrm->private || !zstrm->buffer) {
 		zcomp_strm_free(comp, zstrm);
 		zstrm = NULL;
@@ -120,8 +120,16 @@ static struct zcomp_strm *zcomp_strm_mul
 		/* allocate new zstrm stream */
 		zs->avail_strm++;
 		spin_unlock(&zs->strm_lock);
-
-		zstrm = zcomp_strm_alloc(comp);
+		/*
+		 * This function can be called in swapout/fs write path
+		 * so we can't use GFP_FS|IO. And it assumes we already
+		 * have at least one stream in zram initialization so we
+		 * don't do best effort to allocate more stream in here.
+		 * A default stream will work well without further multiple
+		 * streams. That's why we use NORETRY | NOWARN | NOMEMALLOC.
+		 */
+		zstrm = zcomp_strm_alloc(comp, GFP_NOIO | __GFP_NORETRY |
+					__GFP_NOWARN | __GFP_NOMEMALLOC);
 		if (!zstrm) {
 			spin_lock(&zs->strm_lock);
 			zs->avail_strm--;
@@ -209,7 +217,7 @@ static int zcomp_strm_multi_create(struc
 	zs->max_strm = max_strm;
 	zs->avail_strm = 1;
 
-	zstrm = zcomp_strm_alloc(comp);
+	zstrm = zcomp_strm_alloc(comp, GFP_KERNEL);
 	if (!zstrm) {
 		kfree(zs);
 		return -ENOMEM;
@@ -259,7 +267,7 @@ static int zcomp_strm_single_create(stru
 
 	comp->stream = zs;
 	mutex_init(&zs->strm_lock);
-	zs->zstrm = zcomp_strm_alloc(comp);
+	zs->zstrm = zcomp_strm_alloc(comp, GFP_KERNEL);
 	if (!zs->zstrm) {
 		kfree(zs);
 		return -ENOMEM;
diff -puN drivers/block/zram/zcomp.h~zram-pass-gfp-from-zcomp-frontend-to-backend drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-pass-gfp-from-zcomp-frontend-to-backend
+++ a/drivers/block/zram/zcomp.h
@@ -33,7 +33,7 @@ struct zcomp_backend {
 	int (*decompress)(const unsigned char *src, size_t src_len,
 			unsigned char *dst);
 
-	void *(*create)(void);
+	void *(*create)(gfp_t flags);
 	void (*destroy)(void *private);
 
 	const char *name;
diff -puN drivers/block/zram/zcomp_lz4.c~zram-pass-gfp-from-zcomp-frontend-to-backend drivers/block/zram/zcomp_lz4.c
--- a/drivers/block/zram/zcomp_lz4.c~zram-pass-gfp-from-zcomp-frontend-to-backend
+++ a/drivers/block/zram/zcomp_lz4.c
@@ -15,24 +15,14 @@
 
 #include "zcomp_lz4.h"
 
-static void *zcomp_lz4_create(void)
+static void *zcomp_lz4_create(gfp_t flags)
 {
 	void *ret;
 
-	/*
-	 * This function can be called in swapout/fs write path
-	 * so we can't use GFP_FS|IO. And it assumes we already
-	 * have at least one stream in zram initialization so we
-	 * don't do best effort to allocate more stream in here.
-	 * A default stream will work well without further multiple
-	 * streams. That's why we use NORETRY | NOWARN | NOMEMALLOC.
-	 */
-	ret = kzalloc(LZ4_MEM_COMPRESS, GFP_NOIO | __GFP_NORETRY |
-					__GFP_NOWARN | __GFP_NOMEMALLOC);
+	ret = kzalloc(LZ4_MEM_COMPRESS, flags);
 	if (!ret)
 		ret = __vmalloc(LZ4_MEM_COMPRESS,
-				GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN |
-				__GFP_NOMEMALLOC | __GFP_ZERO | __GFP_HIGHMEM,
+				flags | __GFP_ZERO | __GFP_HIGHMEM,
 				PAGE_KERNEL);
 	return ret;
 }
diff -puN drivers/block/zram/zcomp_lzo.c~zram-pass-gfp-from-zcomp-frontend-to-backend drivers/block/zram/zcomp_lzo.c
--- a/drivers/block/zram/zcomp_lzo.c~zram-pass-gfp-from-zcomp-frontend-to-backend
+++ a/drivers/block/zram/zcomp_lzo.c
@@ -15,24 +15,14 @@
 
 #include "zcomp_lzo.h"
 
-static void *lzo_create(void)
+static void *lzo_create(gfp_t flags)
 {
 	void *ret;
 
-	/*
-	 * This function can be called in swapout/fs write path
-	 * so we can't use GFP_FS|IO. And it assumes we already
-	 * have at least one stream in zram initialization so we
-	 * don't do best effort to allocate more stream in here.
-	 * A default stream will work well without further multiple
-	 * streams. That's why we use NORETRY | NOWARN | NOMEMALLOC.
-	 */
-	ret = kzalloc(LZO1X_MEM_COMPRESS, GFP_NOIO | __GFP_NORETRY |
-					__GFP_NOWARN | __GFP_NOMEMALLOC);
+	ret = kzalloc(LZO1X_MEM_COMPRESS, flags);
 	if (!ret)
 		ret = __vmalloc(LZO1X_MEM_COMPRESS,
-				GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN |
-				__GFP_NOMEMALLOC | __GFP_ZERO | __GFP_HIGHMEM,
+				flags | __GFP_ZERO | __GFP_HIGHMEM,
 				PAGE_KERNEL);
 	return ret;
 }
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-pass-gfp-from-zcomp-frontend-to-backend.patch

