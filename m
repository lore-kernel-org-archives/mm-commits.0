From: akpm@linux-foundation.org
Subject: - ps3-flash-rom-storage-driver-updates-after-final-review.patch removed from -mm tree
Date: Sat, 21 Jul 2007 04:35:13 -0700
Message-ID: <200707211135.l6LBZDFR014260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60941 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937595AbXGULgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 21 Jul 2007 07:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com, James.Bottomley@steeleye.com, benh@kernel.crashing.org, geoffrey.levand@am.sony.com, jens.axboe@oracle.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ps3flash: updates after final review
has been removed from the -mm tree.  Its filename was
     ps3-flash-rom-storage-driver-updates-after-final-review.patch

This patch was dropped because it was folded into ps3-flash-rom-storage-driver.patch

------------------------------------------------------
Subject: ps3flash: updates after final review
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

ps3flash: updates after final review:
  o Kill confusing ps3flash_priv() macro, open code it instead
  o ps3flash_llseek(): Add missing locking (using i_mutex)
  o Replace do_div_llr() by `/' and `%'
  o ps3flash_read(): Use a common return for the error path
  o Minor coding style fixes not reported by checkpatch

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ps3flash.c |   59 ++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 24 deletions(-)

diff -puN drivers/char/ps3flash.c~ps3-flash-rom-storage-driver-updates-after-final-review drivers/char/ps3flash.c
--- a/drivers/char/ps3flash.c~ps3-flash-rom-storage-driver-updates-after-final-review
+++ a/drivers/char/ps3flash.c
@@ -34,7 +34,6 @@
 struct ps3flash_private {
 	struct mutex mutex;	/* Bounce buffer mutex */
 };
-#define ps3flash_priv(dev)	((dev)->sbd.core.driver_data)
 
 static struct ps3_storage_device *ps3flash_dev;
 
@@ -81,28 +80,35 @@ static ssize_t ps3flash_write_chunk(stru
 static loff_t ps3flash_llseek(struct file *file, loff_t offset, int origin)
 {
 	struct ps3_storage_device *dev = ps3flash_dev;
-	u64 size = dev->regions[dev->region_idx].size*dev->blk_size;
+	loff_t res;
 
+	mutex_lock(&file->f_mapping->host->i_mutex);
 	switch (origin) {
 	case 1:
 		offset += file->f_pos;
 		break;
 	case 2:
-		offset += size;
+		offset += dev->regions[dev->region_idx].size*dev->blk_size;
 		break;
 	}
-	if (offset < 0)
-		return -EINVAL;
+	if (offset < 0) {
+		res = -EINVAL;
+		goto out;
+	}
 
 	file->f_pos = offset;
-	return file->f_pos;
+	res = file->f_pos;
+
+out:
+	mutex_unlock(&file->f_mapping->host->i_mutex);
+	return res;
 }
 
 static ssize_t ps3flash_read(struct file *file, char __user *buf, size_t count,
 			     loff_t *pos)
 {
 	struct ps3_storage_device *dev = ps3flash_dev;
-	struct ps3flash_private *priv = ps3flash_priv(dev);
+	struct ps3flash_private *priv = dev->sbd.core.driver_data;
 	u64 size, start_sector, end_sector, offset;
 	ssize_t sectors_read;
 	size_t remaining, n;
@@ -115,15 +121,16 @@ static ssize_t ps3flash_read(struct file
 	if (*pos >= size || !count)
 		return 0;
 
-	if (*pos+count > size) {
+	if (*pos + count > size) {
 		dev_dbg(&dev->sbd.core,
 			"%s:%u Truncating count from %zu to %llu\n", __func__,
 			__LINE__, count, size - *pos);
 		count = size - *pos;
 	}
 
-	start_sector = do_div_llr(*pos, dev->blk_size, &offset);
-	end_sector = DIV_ROUND_UP(*pos+count, dev->blk_size);
+	start_sector = *pos / dev->blk_size;
+	offset = *pos % dev->blk_size;
+	end_sector = DIV_ROUND_UP(*pos + count, dev->blk_size);
 
 	remaining = count;
 	do {
@@ -134,7 +141,7 @@ static ssize_t ps3flash_read(struct file
 						     0);
 		if (sectors_read < 0) {
 			mutex_unlock(&priv->mutex);
-			return sectors_read;
+			goto fail;
 		}
 
 		n = min(remaining, sectors_read*dev->blk_size-offset);
@@ -143,7 +150,8 @@ static ssize_t ps3flash_read(struct file
 			__func__, __LINE__, n, dev->bounce_buf+offset, buf);
 		if (copy_to_user(buf, dev->bounce_buf+offset, n)) {
 			mutex_unlock(&priv->mutex);
-			return -EFAULT;
+			sectors_read = -EFAULT;
+			goto fail;
 		}
 
 		mutex_unlock(&priv->mutex);
@@ -156,13 +164,16 @@ static ssize_t ps3flash_read(struct file
 	} while (remaining > 0);
 
 	return count;
+
+fail:
+	return sectors_read;
 }
 
 static ssize_t ps3flash_write(struct file *file, const char __user *buf,
 			      size_t count, loff_t *pos)
 {
 	struct ps3_storage_device *dev = ps3flash_dev;
-	struct ps3flash_private *priv = ps3flash_priv(dev);
+	struct ps3flash_private *priv = dev->sbd.core.driver_data;
 	u64 size, chunk_sectors, start_write_sector, end_write_sector,
 	    end_read_sector, start_read_sector, head, tail, offset;
 	ssize_t res;
@@ -177,7 +188,7 @@ static ssize_t ps3flash_write(struct fil
 	if (*pos >= size || !count)
 		return 0;
 
-	if (*pos+count > size) {
+	if (*pos + count > size) {
 		dev_dbg(&dev->sbd.core,
 			"%s:%u Truncating count from %zu to %llu\n", __func__,
 			__LINE__, count, size - *pos);
@@ -186,13 +197,13 @@ static ssize_t ps3flash_write(struct fil
 
 	chunk_sectors = dev->bounce_size / dev->blk_size;
 
-	start_write_sector = do_div_llr(*pos, dev->bounce_size, &offset) *
-			     chunk_sectors;
-	end_write_sector = DIV_ROUND_UP(*pos+count, dev->bounce_size) *
+	start_write_sector = *pos / dev->bounce_size * chunk_sectors;
+	offset = *pos % dev->bounce_size;
+	end_write_sector = DIV_ROUND_UP(*pos + count, dev->bounce_size) *
 			   chunk_sectors;
 
 	end_read_sector = DIV_ROUND_UP(*pos, dev->blk_size);
-	start_read_sector = (*pos+count) / dev->blk_size;
+	start_read_sector = (*pos + count) / dev->blk_size;
 
 	/*
 	 * As we have to write in 256 KiB chunks, while we can read in blk_size
@@ -204,8 +215,8 @@ static ssize_t ps3flash_write(struct fil
 	 * All of this is complicated by using only one 256 KiB bounce buffer.
 	 */
 
-	head = end_read_sector-start_write_sector;
-	tail = end_write_sector-start_read_sector;
+	head = end_read_sector - start_write_sector;
+	tail = end_write_sector - start_read_sector;
 
 	remaining = count;
 	do {
@@ -355,7 +366,7 @@ static int __devinit ps3flash_probe(stru
 		goto fail;
 	}
 
-	ps3flash_priv(dev) = priv;
+	dev->sbd.core.driver_data = priv;
 	mutex_init(&priv->mutex);
 
 	dev->bounce_size = ps3flash_bounce_buffer.size;
@@ -381,7 +392,7 @@ fail_teardown:
 	ps3stor_teardown(dev);
 fail_free_priv:
 	kfree(priv);
-	ps3flash_priv(dev) = NULL;
+	dev->sbd.core.driver_data = NULL;
 fail:
 	ps3flash_dev = NULL;
 	return error;
@@ -393,8 +404,8 @@ static int ps3flash_remove(struct ps3_sy
 
 	misc_deregister(&ps3flash_misc);
 	ps3stor_teardown(dev);
-	kfree(ps3flash_priv(dev));
-	ps3flash_priv(dev) = NULL;
+	kfree(dev->sbd.core.driver_data);
+	dev->sbd.core.driver_data = NULL;
 	ps3flash_dev = NULL;
 	return 0;
 }
_

Patches currently in -mm which might be from Geert.Uytterhoeven@sonycom.com are

origin.patch
ps3-disk-storage-driver.patch
ps3-bd-dvd-cd-rom-storage-driver.patch
ps3-flash-rom-storage-driver.patch
ps3-flash-rom-storage-driver-updates-after-final-review.patch
ps3fb-enable-vt_hw_console_binding-for-proper-kexec.patch
ps3fb-shrink-default-virtual-frame-buffer-size-from-18-to-9-mib.patch
ps3fb-set-fbinfo_reads_fast-to-speed-up-text-console-scrolling.patch
