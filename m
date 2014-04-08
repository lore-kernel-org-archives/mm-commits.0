From: akpm@linux-foundation.org
Subject: [merged] zram-delete-zram_init_device.patch removed from -mm tree
Date: Tue, 08 Apr 2014 14:05:33 -0700
Message-ID: <5344649d.17QLXk89RWk2lPPg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56687 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaDHVFe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:05:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, minchan@kernel.org, jmarchan@redhat.com, sergey.senozhatsky@gmail.com

Subject: [merged] zram-delete-zram_init_device.patch removed from -mm tree
To: sergey.senozhatsky@gmail.com,jmarchan@redhat.com,minchan@kernel.org,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:05:33 -0700


The patch titled
     Subject: zram: delete zram_init_device()
has been removed from the -mm tree.  Its filename was
     zram-delete-zram_init_device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zram: delete zram_init_device()

allocate new `zram_meta' in disksize_store() only for uninitialised zram
device, saving a number of allocations and deallocations in case if
disksize_store() was called on currently used device.  at the same time
zram_meta stack variable is not necessary, because we can set ->meta
directly.  there is also no need in setting QUEUE_FLAG_NONROT queue on
every disksize_store(), set it once during device creation.

[minchan@kernel.org: handle zram->meta alloc fail case]
[minchan@kernel.org: prevent lockdep spew of init_lock]
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-delete-zram_init_device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-delete-zram_init_device
+++ a/drivers/block/zram/zram_drv.c
@@ -533,14 +533,6 @@ static void zram_reset_device(struct zra
 	up_write(&zram->init_lock);
 }
 
-static void zram_init_device(struct zram *zram, struct zram_meta *meta)
-{
-	/* zram devices sort of resembles non-rotational disks */
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
-	zram->meta = meta;
-	pr_debug("Initialization done!\n");
-}
-
 static ssize_t disksize_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -556,17 +548,18 @@ static ssize_t disksize_store(struct dev
 	meta = zram_meta_alloc(disksize);
 	if (!meta)
 		return -ENOMEM;
+
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
-		up_write(&zram->init_lock);
 		zram_meta_free(meta);
+		up_write(&zram->init_lock);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
+	zram->meta = meta;
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	zram_init_device(zram, meta);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -776,7 +769,8 @@ static int create_device(struct zram *zr
 
 	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
