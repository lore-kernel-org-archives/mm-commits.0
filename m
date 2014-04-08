From: akpm@linux-foundation.org
Subject: [merged] zram-remove-good-and-bad-compress-stats.patch removed
 from -mm tree
Date: Tue, 08 Apr 2014 14:01:49 -0700
Message-ID: <534463bd.Y46gSRAsC6HcTFvN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbaDHVBu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:01:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-remove-good-and-bad-compress-stats.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:01:49 -0700


The patch titled
     Subject: zram: remove good and bad compress stats
has been removed from the -mm tree.  Its filename was
     zram-remove-good-and-bad-compress-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: remove good and bad compress stats

Remove `good' and `bad' compressed sub-requests stats.  RW request may
cause a number of RW sub-requests.  zram used to account `good' compressed
sub-queries (with compressed size less than 50% of original size), `bad'
compressed sub-queries (with compressed size greater that 75% of original
size), leaving sub-requests with compression size between 50% and 75% of
original size not accounted and not reported.  zram already accounts each
sub-request's compression size so we can calculate real device compression
ratio.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   11 -----------
 drivers/block/zram/zram_drv.h |    2 --
 2 files changed, 13 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-remove-good-and-bad-compress-stats drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-remove-good-and-bad-compress-stats
+++ a/drivers/block/zram/zram_drv.c
@@ -293,7 +293,6 @@ static void zram_free_page(struct zram *
 {
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
-	u16 size = meta->table[index].size;
 
 	if (unlikely(!handle)) {
 		/*
@@ -307,14 +306,8 @@ static void zram_free_page(struct zram *
 		return;
 	}
 
-	if (unlikely(size > max_zpage_size))
-		atomic_dec(&zram->stats.bad_compress);
-
 	zs_free(meta->mem_pool, handle);
 
-	if (size <= PAGE_SIZE / 2)
-		atomic_dec(&zram->stats.good_compress);
-
 	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
 	atomic_dec(&zram->stats.pages_stored);
 
@@ -478,7 +471,6 @@ static int zram_bvec_write(struct zram *
 	}
 
 	if (unlikely(clen > max_zpage_size)) {
-		atomic_inc(&zram->stats.bad_compress);
 		clen = PAGE_SIZE;
 		src = NULL;
 		if (is_partial_io(bvec))
@@ -518,9 +510,6 @@ static int zram_bvec_write(struct zram *
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_size);
 	atomic_inc(&zram->stats.pages_stored);
-	if (clen <= PAGE_SIZE / 2)
-		atomic_inc(&zram->stats.good_compress);
