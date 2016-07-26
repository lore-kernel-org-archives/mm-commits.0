From: akpm@linux-foundation.org
Subject: [patch 035/126] zram: rename zstrm find-release functions
Date: Tue, 26 Jul 2016 15:22:42 -0700
Message-ID: <5797e2b2.9f+xLTDHEI2mRtsw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117AbcGZWWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:22:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: rename zstrm find-release functions

This has started as a 'add zlib support' work, but after some thinking I
saw no blockers for a bigger change -- a switch to crypto API.

We don't have an idle zstreams list anymore and our write path now works
absolutely differently, preventing preemption during compression.  This
removes possibilities of read paths preempting writes at wrong places and
opens the door for a move from custom LZO/LZ4 compression backends
implementation to a more generic one, using crypto compress API.

This patch set also eliminates the need of a new context-less crypto API
interface, which was quite hard to sell, so we can move along faster.

benchmarks:

(x86_64, 4GB, zram-perf script)

perf reported run-time fio (max jobs=3).  I performed fio test with the
increasing number of parallel jobs (max to 3) on a 3G zram device, using
`static' data and the following crypto comp algorithms:

	842, deflate, lz4, lz4hc, lzo

the output was:
 - test running time (which can tell us what algorithms performs faster)
and
 - zram mm_stat (which tells the compressed memory size, max used memory, etc).

It's just for information.  for example, LZ4HC has twice the running time
of LZO, but the compressed memory size is: 23592960 vs 34603008 bytes.

test-fio-zram-842
     197.907655282 seconds time elapsed
     201.623142884 seconds time elapsed
     226.854291345 seconds time elapsed
test-fio-zram-DEFLATE
     253.259516155 seconds time elapsed
     258.148563401 seconds time elapsed
     290.251909365 seconds time elapsed
test-fio-zram-LZ4
      27.022598717 seconds time elapsed
      29.580522717 seconds time elapsed
      33.293463430 seconds time elapsed
test-fio-zram-LZ4HC
      56.393954615 seconds time elapsed
      74.904659747 seconds time elapsed
     101.940998564 seconds time elapsed
test-fio-zram-LZO
      28.155948075 seconds time elapsed
      30.390036330 seconds time elapsed
      34.455773159 seconds time elapsed


zram mm_stat-s (max fio jobs=3)

test-fio-zram-842
mm_stat (jobs1): 3221225472 673185792 690266112        0 690266112        0        0
mm_stat (jobs2): 3221225472 673185792 690266112        0 690266112        0        0
mm_stat (jobs3): 3221225472 673185792 690266112        0 690266112        0        0
test-fio-zram-DEFLATE
mm_stat (jobs1): 3221225472  24379392  37761024        0  37761024        0        0
mm_stat (jobs2): 3221225472  24379392  37761024        0  37761024        0        0
mm_stat (jobs3): 3221225472  24379392  37761024        0  37761024        0        0
test-fio-zram-LZ4
mm_stat (jobs1): 3221225472  23592960  37761024        0  37761024        0        0
mm_stat (jobs2): 3221225472  23592960  37761024        0  37761024        0        0
mm_stat (jobs3): 3221225472  23592960  37761024        0  37761024        0        0
test-fio-zram-LZ4HC
mm_stat (jobs1): 3221225472  23592960  37761024        0  37761024        0        0
mm_stat (jobs2): 3221225472  23592960  37761024        0  37761024        0        0
mm_stat (jobs3): 3221225472  23592960  37761024        0  37761024        0        0
test-fio-zram-LZO
mm_stat (jobs1): 3221225472  34603008  50335744        0  50335744        0        0
mm_stat (jobs2): 3221225472  34603008  50335744        0  50335744        0        0
mm_stat (jobs3): 3221225472  34603008  50335744        0  50339840        0        0


This patch (of 8):

We don't perform any zstream idle list lookup anymore, so
zcomp_strm_find()/zcomp_strm_release() names are not representative.

Rename to zcomp_stream_get()/zcomp_stream_put().

Link: http://lkml.kernel.org/r/20160531122017.2878-2-sergey.senozhatsky@gmail.com
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c    |    4 ++--
 drivers/block/zram/zcomp.h    |    4 ++--
 drivers/block/zram/zram_drv.c |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/block/zram/zcomp.c~zram-rename-zstrm-find-release-functions drivers/block/zram/zcomp.c
--- a/drivers/block/zram/zcomp.c~zram-rename-zstrm-find-release-functions
+++ a/drivers/block/zram/zcomp.c
@@ -95,12 +95,12 @@ bool zcomp_available_algorithm(const cha
 	return find_backend(comp) != NULL;
 }
 
-struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
+struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
 {
 	return *get_cpu_ptr(comp->stream);
 }
 
-void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
+void zcomp_stream_put(struct zcomp *comp)
 {
 	put_cpu_ptr(comp->stream);
 }
diff -puN drivers/block/zram/zcomp.h~zram-rename-zstrm-find-release-functions drivers/block/zram/zcomp.h
--- a/drivers/block/zram/zcomp.h~zram-rename-zstrm-find-release-functions
+++ a/drivers/block/zram/zcomp.h
@@ -48,8 +48,8 @@ bool zcomp_available_algorithm(const cha
 struct zcomp *zcomp_create(const char *comp);
 void zcomp_destroy(struct zcomp *comp);
 
-struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
-void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
+struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
+void zcomp_stream_put(struct zcomp *comp);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		const unsigned char *src, size_t *dst_len);
diff -puN drivers/block/zram/zram_drv.c~zram-rename-zstrm-find-release-functions drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-rename-zstrm-find-release-functions
+++ a/drivers/block/zram/zram_drv.c
@@ -695,7 +695,7 @@ compress_again:
 		goto out;
 	}
 
-	zstrm = zcomp_strm_find(zram->comp);
+	zstrm = zcomp_stream_get(zram->comp);
 	ret = zcomp_compress(zram->comp, zstrm, uncmem, &clen);
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
@@ -734,7 +734,7 @@ compress_again:
 				__GFP_NOWARN |
 				__GFP_HIGHMEM);
 	if (!handle) {
-		zcomp_strm_release(zram->comp, zstrm);
+		zcomp_stream_put(zram->comp);
 		zstrm = NULL;
 
 		atomic64_inc(&zram->stats.writestall);
@@ -769,7 +769,7 @@ compress_again:
 		memcpy(cmem, src, clen);
 	}
 
-	zcomp_strm_release(zram->comp, zstrm);
+	zcomp_stream_put(zram->comp);
 	zstrm = NULL;
 	zs_unmap_object(meta->mem_pool, handle);
 
@@ -789,7 +789,7 @@ compress_again:
 	atomic64_inc(&zram->stats.pages_stored);
 out:
 	if (zstrm)
-		zcomp_strm_release(zram->comp, zstrm);
+		zcomp_stream_put(zram->comp);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
 	return ret;
_
