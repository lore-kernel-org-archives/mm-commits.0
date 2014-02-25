From: akpm@linux-foundation.org
Subject: + zram-delete-zram_init_device.patch added to -mm tree
Date: Tue, 25 Feb 2014 12:28:25 -0800
Message-ID: <530cfce9.eiQxIB8Hc/mKoWIE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708AbaBYU2Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Feb 2014 15:28:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com

Subject: + zram-delete-zram_init_device.patch added to -mm tree
To: sergey.senozhatsky@gmail.com,minchan@kernel.org
From: akpm@linux-foundation.org
Date: Tue, 25 Feb 2014 12:28:25 -0800


The patch titled
     Subject: zram: delete zram_init_device()
has been added to the -mm tree.  Its filename is
     zram-delete-zram_init_device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-delete-zram_init_device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-delete-zram_init_device.patch

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
Subject: zram: delete zram_init_device()

allocate new `zram_meta' in disksize_store() only for uninitialised zram
device, saving a number of allocations and deallocations in case if
disksize_store() was called on currently used device.  at the same time
zram_meta stack variable is not necessary, because we can set ->meta
directly.  there is also no need in setting QUEUE_FLAG_NONROT queue on
every disksize_store(), set it once during device creation.

[minchan@kernel.org]: handled zram->meta alloc fail case.
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff -puN drivers/block/zram/zram_drv.c~zram-delete-zram_init_device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-delete-zram_init_device
+++ a/drivers/block/zram/zram_drv.c
@@ -533,40 +533,32 @@ static void zram_reset_device(struct zra
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
 	u64 disksize;
-	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
 		return -EINVAL;
 
-	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(disksize);
-	if (!meta)
-		return -ENOMEM;
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
-		zram_meta_free(meta);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
+	disksize = PAGE_ALIGN(disksize);
+	zram->meta = zram_meta_alloc(disksize);
+	if (!zram->meta) {
+		up_write(&zram->init_lock);
+		return -ENOMEM;
+	}
+
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	zram_init_device(zram, meta);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -776,7 +768,8 @@ static int create_device(struct zram *zr
 
 	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
