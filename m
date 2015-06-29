From: akpm@linux-foundation.org
Subject: [merged] zram-cosmetic-zram_bvec_write-cleanup.patch removed from -mm tree
Date: Mon, 29 Jun 2015 13:46:30 -0700
Message-ID: <5591aea6.eqLE0omzpdbjc4dr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbbF2Uqc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:46:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: cosmetic zram_bvec_write() cleanup
has been removed from the -mm tree.  Its filename was
     zram-cosmetic-zram_bvec_write-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: cosmetic zram_bvec_write() cleanup

`bool locked' local variable tells us if we should perform
zcomp_strm_release() or not (jumped to `out' label before
zcomp_strm_find() occurred), which is equivalent to `zstrm' being or not
being NULL.  remove `locked' and check `zstrm' instead.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-cosmetic-zram_bvec_write-cleanup drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-cosmetic-zram_bvec_write-cleanup
+++ a/drivers/block/zram/zram_drv.c
@@ -642,8 +642,7 @@ static int zram_bvec_write(struct zram *
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
-	struct zcomp_strm *zstrm;
-	bool locked = false;
+	struct zcomp_strm *zstrm = NULL;
 	unsigned long alloced_pages;
 
 	page = bvec->bv_page;
@@ -663,7 +662,6 @@ static int zram_bvec_write(struct zram *
 	}
 
 	zstrm = zcomp_strm_find(zram->comp);
-	locked = true;
 	user_mem = kmap_atomic(page);
 
 	if (is_partial_io(bvec)) {
@@ -735,7 +733,7 @@ static int zram_bvec_write(struct zram *
 	}
 
 	zcomp_strm_release(zram->comp, zstrm);
-	locked = false;
+	zstrm = NULL;
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/*
@@ -753,7 +751,7 @@ static int zram_bvec_write(struct zram *
 	atomic64_add(clen, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.pages_stored);
 out:
-	if (locked)
+	if (zstrm)
 		zcomp_strm_release(zram->comp, zstrm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

