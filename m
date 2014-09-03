From: akpm@linux-foundation.org
Subject: [merged] zram-fix-incorrectly-stat-with-failed_reads.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:27 -0700
Message-ID: <54075687.bKZ0Cw1nolIQQeJz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbaICR52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chao2.yu@samsung.com, jmarchan@redhat.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: fix incorrect stat with failed_reads
has been removed from the -mm tree.  Its filename was
     zram-fix-incorrectly-stat-with-failed_reads.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chao Yu <chao2.yu@samsung.com>
Subject: zram: fix incorrect stat with failed_reads

Since we allocate a temporary buffer in zram_bvec_read to handle partial
page operations in 924bd88d703e ("Staging: zram: allow partial page
operations"), our ->failed_reads value may be incorrect as we do not
increase its value when failing to allocate the temporary buffer.

Let's fix this issue and correct the annotation of failed_reads.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
Acked-by: Minchan Kim <minchan@kernel.org>
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

zram-add-num_discard_req-discarded-for-discard-stat.patch
linux-next.patch

