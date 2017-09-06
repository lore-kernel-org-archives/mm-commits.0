From: akpm@linux-foundation.org
Subject: [patch 024/119] zram: add interface to specif backing
 device
Date: Wed, 06 Sep 2017 16:19:54 -0700
Message-ID: <20170906231954.Cqnax_xF6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49426 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753963AbdIFXTz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 19:19:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, juno.choi@lge.com, minchan@kernel.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org

From: Minchan Kim <minchan@kernel.org>
Subject: zram: add interface to specif backing device

For writeback feature, user should set up backing device before the zram
working.  This patch enables the interface via
/sys/block/zramX/backing_dev.

Currently, it supports block device only but it could be enhanced for file
as well.

Link: http://lkml.kernel.org/r/1498459987-24562-5-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Juneho Choi <juno.choi@lge.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |  142 ++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_drv.h |    5 +
 2 files changed, 147 insertions(+)

diff -puN drivers/block/zram/zram_drv.c~zram-add-interface-to-specify-backing-device drivers/block/zram/zram_drv.c
--- a/drivers/block/zram/zram_drv.c~zram-add-interface-to-specify-backing-device
+++ a/drivers/block/zram/zram_drv.c
@@ -270,6 +270,141 @@ static ssize_t mem_used_max_store(struct
 	return len;
 }
 
+#ifdef CONFIG_ZRAM_WRITEBACK
+static bool zram_wb_enabled(struct zram *zram)
+{
+	return zram->backing_dev;
+}
+
+static void reset_bdev(struct zram *zram)
+{
+	struct block_device *bdev;
+
+	if (!zram_wb_enabled(zram))
+		return;
+
+	bdev = zram->bdev;
+	if (zram->old_block_size)
+		set_blocksize(bdev, zram->old_block_size);
+	blkdev_put(bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
+	/* hope filp_close flush all of IO */
+	filp_close(zram->backing_dev, NULL);
+	zram->backing_dev = NULL;
+	zram->old_block_size = 0;
+	zram->bdev = NULL;
+}
+
+static ssize_t backing_dev_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	struct file *file = zram->backing_dev;
+	char *p;
+	ssize_t ret;
+
+	down_read(&zram->init_lock);
+	if (!zram_wb_enabled(zram)) {
+		memcpy(buf, "none\n", 5);
+		up_read(&zram->init_lock);
+		return 5;
+	}
+
+	p = file_path(file, buf, PAGE_SIZE - 1);
+	if (IS_ERR(p)) {
+		ret = PTR_ERR(p);
+		goto out;
+	}
+
+	ret = strlen(p);
+	memmove(buf, p, ret);
+	buf[ret++] = '\n';
+out:
+	up_read(&zram->init_lock);
+	return ret;
+}
+
+static ssize_t backing_dev_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	char *file_name;
+	struct file *backing_dev = NULL;
+	struct inode *inode;
+	struct address_space *mapping;
+	unsigned int old_block_size = 0;
+	struct block_device *bdev = NULL;
+	int err;
+	struct zram *zram = dev_to_zram(dev);
+
+	file_name = kmalloc(PATH_MAX, GFP_KERNEL);
+	if (!file_name)
+		return -ENOMEM;
+
+	down_write(&zram->init_lock);
+	if (init_done(zram)) {
+		pr_info("Can't setup backing device for initialized device\n");
+		err = -EBUSY;
+		goto out;
+	}
+
+	strlcpy(file_name, buf, len);
+
+	backing_dev = filp_open(file_name, O_RDWR|O_LARGEFILE, 0);
+	if (IS_ERR(backing_dev)) {
+		err = PTR_ERR(backing_dev);
+		backing_dev = NULL;
+		goto out;
+	}
+
+	mapping = backing_dev->f_mapping;
+	inode = mapping->host;
+
+	/* Support only block device in this moment */
+	if (!S_ISBLK(inode->i_mode)) {
+		err = -ENOTBLK;
+		goto out;
+	}
+
+	bdev = bdgrab(I_BDEV(inode));
+	err = blkdev_get(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL, zram);
+	if (err < 0)
+		goto out;
+
+	old_block_size = block_size(bdev);
+	err = set_blocksize(bdev, PAGE_SIZE);
+	if (err)
+		goto out;
+
+	reset_bdev(zram);
+
+	zram->old_block_size = old_block_size;
+	zram->bdev = bdev;
+	zram->backing_dev = backing_dev;
+	up_write(&zram->init_lock);
+
+	pr_info("setup backing device %s\n", file_name);
+	kfree(file_name);
+
+	return len;
+out:
+	if (bdev)
+		blkdev_put(bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
+
+	if (backing_dev)
+		filp_close(backing_dev, NULL);
+
+	up_write(&zram->init_lock);
+
+	kfree(file_name);
+
+	return err;
+}
+
+#else
+static bool zram_wb_enabled(struct zram *zram) { return false; }
+static inline void reset_bdev(struct zram *zram) {};
+#endif
+
+
 /*
  * We switched to per-cpu streams and this attr is not needed anymore.
  * However, we will keep it around for some time, because:
@@ -953,6 +1088,7 @@ static void zram_reset_device(struct zra
 	zram_meta_free(zram, disksize);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	zcomp_destroy(comp);
+	reset_bdev(zram);
 }
 
 static ssize_t disksize_store(struct device *dev,
@@ -1078,6 +1214,9 @@ static DEVICE_ATTR_WO(mem_limit);
 static DEVICE_ATTR_WO(mem_used_max);
 static DEVICE_ATTR_RW(max_comp_streams);
 static DEVICE_ATTR_RW(comp_algorithm);
+#ifdef CONFIG_ZRAM_WRITEBACK
+static DEVICE_ATTR_RW(backing_dev);
+#endif
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
@@ -1088,6 +1227,9 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_mem_used_max.attr,
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
+#ifdef CONFIG_ZRAM_WRITEBACK
+	&dev_attr_backing_dev.attr,
+#endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
 	&dev_attr_debug_stat.attr,
diff -puN drivers/block/zram/zram_drv.h~zram-add-interface-to-specify-backing-device drivers/block/zram/zram_drv.h
--- a/drivers/block/zram/zram_drv.h~zram-add-interface-to-specify-backing-device
+++ a/drivers/block/zram/zram_drv.h
@@ -115,5 +115,10 @@ struct zram {
 	 * zram is claimed so open request will be failed
 	 */
 	bool claim; /* Protected by bdev->bd_mutex */
+#ifdef CONFIG_ZRAM_WRITEBACK
+	struct file *backing_dev;
+	struct block_device *bdev;
+	unsigned int old_block_size;
+#endif
 };
 #endif
_
