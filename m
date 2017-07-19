From: akpm@linux-foundation.org
Subject: + zram-add-free-space-management-in-backing-device.patch added to -mm tree
Date: Wed, 19 Jul 2017 16:08:17 -0700
Message-ID: <596fe661.30lcubraQYYzB+ty%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38990 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933478AbdGSXIS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 19:08:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, juno.choi@lge.com, sergey.senozhatsky@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: zram: add free space management in backing device
has been added to the -mm tree.  Its filename is
     zram-add-free-space-management-in-backing-device.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zram-add-free-space-management-in-backing-device.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zram-add-free-space-management-in-backing-device.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zram: add free space management in backing device

With backing device, zram needs management of free space of backing
device.

This patch adds bitmap logic to manage free space which is very naive. 
However, it would be simple enough as considering uncompressible pages's
frequenty in zram.

Link: http://lkml.kernel.org/r/1498459987-24562-6-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   48 +++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h |    3 ++
 2 files changed, 50 insertions(+), 1 deletion(-)

diff -puN drivers/block/zram/zram_drv.c~zram-add-free-space-management-in-backing-device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-free-space-management-in-backing-device
+++ a/drivers/block/zram/zram_drv.c
@@ -292,6 +292,9 @@ static void reset_bdev(struct zram *zram
 	zram->backing_dev = NULL;
 	zram->old_block_size = 0;
 	zram->bdev = NULL;
+
+	kvfree(zram->bitmap);
+	zram->bitmap = NULL;
 }
 
 static ssize_t backing_dev_show(struct device *dev,
@@ -330,7 +333,8 @@ static ssize_t backing_dev_store(struct
 	struct file *backing_dev = NULL;
 	struct inode *inode;
 	struct address_space *mapping;
-	unsigned int old_block_size = 0;
+	unsigned int bitmap_sz, old_block_size = 0;
+	unsigned long nr_pages, *bitmap = NULL;
 	struct block_device *bdev = NULL;
 	int err;
 	struct zram *zram = dev_to_zram(dev);
@@ -369,16 +373,27 @@ static ssize_t backing_dev_store(struct
 	if (err < 0)
 		goto out;
 
+	nr_pages = i_size_read(inode) >> PAGE_SHIFT;
+	bitmap_sz = BITS_TO_LONGS(nr_pages) * sizeof(long);
+	bitmap = kvzalloc(bitmap_sz, GFP_KERNEL);
+	if (!bitmap) {
+		err = -ENOMEM;
+		goto out;
+	}
+
 	old_block_size = block_size(bdev);
 	err = set_blocksize(bdev, PAGE_SIZE);
 	if (err)
 		goto out;
 
 	reset_bdev(zram);
+	spin_lock_init(&zram->bitmap_lock);
 
 	zram->old_block_size = old_block_size;
 	zram->bdev = bdev;
 	zram->backing_dev = backing_dev;
+	zram->bitmap = bitmap;
+	zram->nr_pages = nr_pages;
 	up_write(&zram->init_lock);
 
 	pr_info("setup backing device %s\n", file_name);
@@ -386,6 +401,9 @@ static ssize_t backing_dev_store(struct
 
 	return len;
 out:
+	if (bitmap)
+		kvfree(bitmap);
+
 	if (bdev)
 		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
 
@@ -399,6 +417,34 @@ out:
 	return err;
 }
 
+static unsigned long get_entry_bdev(struct zram *zram)
+{
+	unsigned long entry;
+
+	spin_lock(&zram->bitmap_lock);
+	/* skip 0 bit to confuse zram.handle = 0 */
+	entry = find_next_zero_bit(zram->bitmap, zram->nr_pages, 1);
+	if (entry == zram->nr_pages) {
+		spin_unlock(&zram->bitmap_lock);
+		return 0;
+	}
+
+	set_bit(entry, zram->bitmap);
+	spin_unlock(&zram->bitmap_lock);
+
+	return entry;
+}
+
+static void put_entry_bdev(struct zram *zram, unsigned long entry)
+{
+	int was_set;
+
+	spin_lock(&zram->bitmap_lock);
+	was_set = test_and_clear_bit(entry, zram->bitmap);
+	spin_unlock(&zram->bitmap_lock);
+	WARN_ON_ONCE(!was_set);
+}
+
 #else
 static bool zram_wb_enabled(struct zram *zram) { return false; }
 static inline void reset_bdev(struct zram *zram) {};
diff -puN drivers/block/zram/zram_drv.h~zram-add-free-space-management-in-backing-device drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-add-free-space-management-in-backing-device
+++ a/drivers/block/zram/zram_drv.h
@@ -119,6 +119,9 @@ struct zram {
 	struct file *backing_dev;
 	struct block_device *bdev;
 	unsigned int old_block_size;
+	unsigned long *bitmap;
+	unsigned long nr_pages;
+	spinlock_t bitmap_lock;
 #endif
 };
 #endif
_

Patches currently in -mm which might be from minchan@kernel.org are

zram-clean-up-duplicated-codes-in-__zram_bvec_write.patch
zram-inlining-zram_compress.patch
zram-rename-zram_decompress_page-with-__zram_bvec_read.patch
zram-add-interface-to-specify-backing-device.patch
zram-add-free-space-management-in-backing-device.patch
zram-identify-asynchronous-ios-return-value.patch
zram-write-incompressible-pages-to-backing-device.patch
zram-read-page-from-backing-device.patch
zram-add-config-and-doc-file-for-writeback-feature.patch

