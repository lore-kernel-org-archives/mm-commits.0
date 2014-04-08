From: akpm@linux-foundation.org
Subject: [merged] zram-move-comp-allocation-out-of-init_lock.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:09:49 -0700
Message-ID: <5344659d.rzPMAKXvBFDcvINK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756761AbaDHVJu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:09:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-move-comp-allocation-out-of-init_lock.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:09:49 -0700


The patch titled
     Subject: zram: move comp allocation out of init_lock
has been removed from the -mm tree.  Its filename was
     zram-move-comp-allocation-out-of-init_lock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: move comp allocation out of init_lock

While fixing lockdep spew of ->init_lock reported by Sasha Levin [1],
Minchan Kim noted [2] that it's better to move compression backend
allocation (using GPF_KERNEL) out of the ->init_lock lock, same way as
with zram_meta_alloc(), in order to prevent the same lockdep spew.

[1] https://lkml.org/lkml/2014/2/27/337
[2] https://lkml.org/lkml/2014/3/3/32

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reported-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-move-comp-allocation-out-of-init_lock drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-move-comp-allocation-out-of-init_lock
+++ a/drivers/block/zram/zram_drv.c
@@ -580,9 +580,10 @@ static ssize_t disksize_store(struct dev
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	u64 disksize;
+	struct zcomp *comp;
 	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
-	int err;
+	int err = -EINVAL;
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
@@ -593,30 +594,32 @@ static ssize_t disksize_store(struct dev
 	if (!meta)
 		return -ENOMEM;
 
+	comp = zcomp_create(zram->compressor, zram->max_comp_streams);
+	if (!comp) {
+		pr_info("Cannot initialise %s compressing backend\n",
+				zram->compressor);
+		goto out_cleanup;
+	}
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
+		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		err = -EBUSY;
-		goto out_free_meta;
-	}
-
-	zram->comp = zcomp_create(zram->compressor, zram->max_comp_streams);
-	if (!zram->comp) {
-		pr_info("Cannot initialise %s compressing backend\n",
-				zram->compressor);
-		err = -EINVAL;
-		goto out_free_meta;
+		goto out_cleanup;
 	}
 
 	zram->meta = meta;
+	zram->comp = comp;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
 	up_write(&zram->init_lock);
 
 	return len;
 
-out_free_meta:
-	up_write(&zram->init_lock);
+out_cleanup:
+	if (comp)
+		zcomp_destroy(comp);
 	zram_meta_free(meta);
 	return err;
 }
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

origin.patch

