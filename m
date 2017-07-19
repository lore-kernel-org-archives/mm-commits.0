From: akpm@linux-foundation.org
Subject: + zram-inlining-zram_compress.patch added to -mm tree
Date: Wed, 19 Jul 2017 16:08:11 -0700
Message-ID: <596fe65b.CyqNZkAzq2z+xO/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38968 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933474AbdGSXIM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 19:08:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, juno.choi@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: inline zram_compress
has been added to the -mm tree.  Its filename is
     zram-inlining-zram_compress.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-inlining-zram_compress.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-inlining-zram_compress.patch

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
Subject: zram: inline zram_compress

zram_compress does several things, compress, entry alloc and check
limitation.  I did for just readbility but it hurts modulization.:( So
this patch removes zram_compress functions and inline it in
__zram_bvec_write for upcoming patches.

Link: http://lkml.kernel.org/r/1498459987-24562-3-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   64 +++++++++++---------------------
 1 file changed, 22 insertions(+), 42 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-inlining-zram_compress drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-inlining-zram_compress
+++ a/drivers/block/zram/zram_drv.c
@@ -589,25 +589,38 @@ out:
 	return ret;
 }
 
-static int zram_compress(struct zram *zram, struct zcomp_strm **zstrm,
-			struct page *page,
-			unsigned long *out_handle, unsigned int *out_comp_len)
+static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
 {
 	int ret;
-	unsigned int comp_len;
-	void *src;
 	unsigned long alloced_pages;
 	unsigned long handle = 0;
+	unsigned int comp_len = 0;
+	void *src, *dst, *mem;
+	struct zcomp_strm *zstrm;
+	struct page *page = bvec->bv_page;
+	unsigned long element = 0;
+	enum zram_pageflags flags = 0;
+
+	mem = kmap_atomic(page);
+	if (page_same_filled(mem, &element)) {
+		kunmap_atomic(mem);
+		/* Free memory associated with this sector now. */
+		flags = ZRAM_SAME;
+		atomic64_inc(&zram->stats.same_pages);
+		goto out;
+	}
+	kunmap_atomic(mem);
 
 compress_again:
+	zstrm = zcomp_stream_get(zram->comp);
 	src = kmap_atomic(page);
-	ret = zcomp_compress(*zstrm, src, &comp_len);
+	ret = zcomp_compress(zstrm, src, &comp_len);
 	kunmap_atomic(src);
 
 	if (unlikely(ret)) {
+		zcomp_stream_put(zram->comp);
 		pr_err("Compression failed! err=%d\n", ret);
-		if (handle)
-			zs_free(zram->mem_pool, handle);
+		zs_free(zram->mem_pool, handle);
 		return ret;
 	}
 
@@ -639,7 +652,6 @@ compress_again:
 		handle = zs_malloc(zram->mem_pool, comp_len,
 				GFP_NOIO | __GFP_HIGHMEM |
 				__GFP_MOVABLE);
-		*zstrm = zcomp_stream_get(zram->comp);
 		if (handle)
 			goto compress_again;
 		return -ENOMEM;
@@ -649,43 +661,11 @@ compress_again:
 	update_used_max(zram, alloced_pages);
 
 	if (zram->limit_pages && alloced_pages > zram->limit_pages) {
+		zcomp_stream_put(zram->comp);
 		zs_free(zram->mem_pool, handle);
 		return -ENOMEM;
 	}
 
-	*out_handle = handle;
-	*out_comp_len = comp_len;
-	return 0;
-}
-
-static int __zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index)
-{
-	int ret;
-	unsigned long handle = 0;
-	unsigned int comp_len = 0;
-	void *src, *dst, *mem;
-	struct zcomp_strm *zstrm;
-	struct page *page = bvec->bv_page;
-	unsigned long element = 0;
-	enum zram_pageflags flags = 0;
-
-	mem = kmap_atomic(page);
-	if (page_same_filled(mem, &element)) {
-		kunmap_atomic(mem);
-		/* Free memory associated with this sector now */
-		atomic64_inc(&zram->stats.same_pages);
-		flags = ZRAM_SAME;
-		goto out;
-	}
-	kunmap_atomic(mem);
-
-	zstrm = zcomp_stream_get(zram->comp);
-	ret = zram_compress(zram, &zstrm, page, &handle, &comp_len);
-	if (ret) {
-		zcomp_stream_put(zram->comp);
-		return ret;
-	}
