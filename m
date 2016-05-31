From: akpm@linux-foundation.org
Subject: + zram-rename-zstrm-find-release-functions.patch added to -mm
 tree
Date: Tue, 31 May 2016 12:10:39 -0700
Message-ID: <574de1af.TSWbhsCGjy8Upwn4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48671 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbcEaTKl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 15:10:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, iamjoonsoo.kim@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: rename zstrm find-release functions
has been added to the -mm tree.  Its filename is
     zram-rename-zstrm-find-release-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-rename-zstrm-find-release-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-rename-zstrm-find-release-functions.patch

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

perf reported run-time fio (max jobs=3)

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

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-rename-zstrm-find-release-functions.patch
zram-switch-to-crypto-compress-api.patch
zram-align-zcomp-interface-to-crypto-comp-api.patch
zram-use-crypto-api-to-check-alg-availability.patch
zram-cosmetic-cleanup-documentation.patch
zram-delete-custom-lzo-lz4.patch
zram-add-more-compression-algorithms.patch
zram-drop-gfp_t-from-zcomp_strm_alloc.patch

