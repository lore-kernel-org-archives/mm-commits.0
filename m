From: akpm@linux-foundation.org
Subject: + zram-fix-incorrectly-stat-with-failed_reads.patch added to -mm
 tree
Date: Wed, 13 Aug 2014 13:59:43 -0700
Message-ID: <53ebd1bf.PveL2qZ9Q1nVA6ZL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:61536 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaHMU7o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 16:59:44 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so100975pab.4
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 13:59:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chao2.yu@samsung.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix incorrect stat with failed_reads
has been added to the -mm tree.  Its filename is
     zram-fix-incorrectly-stat-with-failed_reads.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-fix-incorrectly-stat-with-failed_reads.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-fix-incorrectly-stat-with-failed_reads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chao Yu <chao2.yu@samsung.com>
Subject: zram: fix incorrect stat with failed_reads

Since we allocate a temporary buffer in zram_bvec_read to handle partial
page operations in 924bd88d703e ("Staging: zram: allow partial page
operations"), our ->failed_reads value may be incorrect as we do not
increase its value when failing to allocate the temporary buffer.

Let's fix this issue and correct the annotation of failed_reads.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Cc: Minchan Kim <minchan@kernel.org>            
Cc: Nitin Gupta <ngupta@vflare.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   10 +++++++---
 drivers/block/zram/zram_drv.h |    2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-fix-incorrectly-stat-with-failed_reads drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-fix-incorrectly-stat-with-failed_reads
+++ a/drivers/block/zram/zram_drv.c
@@ -378,7 +378,6 @@ static int zram_decompress_page(struct z
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
-		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
 	}
 
@@ -547,8 +546,6 @@ out:
 		zcomp_strm_release(zram->comp, zstrm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
-	if (ret)
-		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
 }
 
@@ -566,6 +563,13 @@ static int zram_bvec_rw(struct zram *zra
 		ret = zram_bvec_write(zram, bvec, index, offset);
 	}
 
+	if (unlikely(ret)) {
+		if (rw == READ)
+			atomic64_inc(&zram->stats.failed_reads);
+		else
+			atomic64_inc(&zram->stats.failed_writes);
+	}
+
 	return ret;
 }
 
diff -puN drivers/block/zram/zram_drv.h~zram-fix-incorrectly-stat-with-failed_reads drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-fix-incorrectly-stat-with-failed_reads
+++ a/drivers/block/zram/zram_drv.h
@@ -84,7 +84,7 @@ struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
 	atomic64_t num_writes;	/* --do-- */
-	atomic64_t failed_reads;	/* should NEVER! happen */
+	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
_

Patches currently in -mm which might be from chao2.yu@samsung.com are

origin.patch
zram-fix-incorrectly-stat-with-failed_reads.patch
linux-next.patch

