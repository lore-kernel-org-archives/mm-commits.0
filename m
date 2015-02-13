From: akpm@linux-foundation.org
Subject: [merged] zram-free-meta-table-in-zram_meta_free.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 12:21:14 -0800
Message-ID: <54de5cba.DSQDfniJaIsSK0BR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48947 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbbBMUVP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opensource.ganesh@gmail.com, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: free meta table in zram_meta_free
has been removed from the -mm tree.  Its filename was
     zram-free-meta-table-in-zram_meta_free.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: zram: free meta table in zram_meta_free

zram_meta_alloc() and zram_meta_free() are a pair.  In
zram_meta_alloc(), meta table is allocated.  So it it better to free it
in zram_meta_free().

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   33 +++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-free-meta-table-in-zram_meta_free drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-free-meta-table-in-zram_meta_free
+++ a/drivers/block/zram/zram_drv.c
@@ -307,8 +307,21 @@ static inline int valid_io_request(struc
 	return 1;
 }
 
-static void zram_meta_free(struct zram_meta *meta)
+static void zram_meta_free(struct zram_meta *meta, u64 disksize)
 {
+	size_t num_pages = disksize >> PAGE_SHIFT;
+	size_t index;
+
+	/* Free all pages that are still in this zram device */
+	for (index = 0; index < num_pages; index++) {
+		unsigned long handle = meta->table[index].handle;
+
+		if (!handle)
+			continue;
+
+		zs_free(meta->mem_pool, handle);
+	}
+
 	zs_destroy_pool(meta->mem_pool);
 	vfree(meta->table);
 	kfree(meta);
@@ -704,9 +717,6 @@ static void zram_bio_discard(struct zram
 
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
-	size_t index;
-	struct zram_meta *meta;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -716,20 +726,9 @@ static void zram_reset_device(struct zra
 		return;
 	}
 
-	meta = zram->meta;
-	/* Free all pages that are still in this zram device */
-	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
-		unsigned long handle = meta->table[index].handle;
-		if (!handle)
-			continue;
-
-		zs_free(meta->mem_pool, handle);
-	}
-
 	zcomp_destroy(zram->comp);
 	zram->max_comp_streams = 1;
