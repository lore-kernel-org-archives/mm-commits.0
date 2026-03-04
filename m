Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7E136F40A
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646307; cv=none; b=UUHfZw131YA13nB/jPXwRCAbxmJ78DlTScuRTaEx7PO8t0hlW1f5drB3JyXCjWekymLV1ukuYk882cac3f+Ek3aU3JC/feay6dh+v8KHN9gj6Q2G1cj4hYrBoCLNzEZHA0qom2Nm56iO+au2M6wdNe6uBNok9XCh8cBs6wkGAds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646307; c=relaxed/simple;
	bh=+dtYAIMVUkmmEPOxMJ88rxVIbPdvXOmx93J/dUA79Yo=;
	h=Date:To:From:Subject:Message-Id; b=Q6BMFPRqbYZCsBGpgkeiS9hgbhbeVKVVL18pEU63sNWUy1yxPGDT4jctIA064z34y/DH83k091blkHax0fscZRFzxfFnqELoYE+y3rnEtsivzxoEywT7GWZGIhGS0Y3fZ+Qh15n8a/nzG4tVUTOiuAbNUxisa+0RufQZdaw0yBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gap17Ls/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gap17Ls/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2FFC4CEF7;
	Wed,  4 Mar 2026 17:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646307;
	bh=+dtYAIMVUkmmEPOxMJ88rxVIbPdvXOmx93J/dUA79Yo=;
	h=Date:To:From:Subject:From;
	b=Gap17Ls/NT/E13QTgr+nrWaN7Lrifl+SqdxA4EUx/iDreik2D0aKE6wARmr2362Tk
	 plWRrFGL2RpXxrqmgEYbbjtwJ3H9O9iT59mylccj56d2V9Z0vpBLo6A0uqrz7+fmwA
	 wz3JLVc2E8xmuyJ+LgXCH2AayGj3QOedujR/r2Wk=
Date: Wed, 04 Mar 2026 09:45:06 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,skhan@linuxfoundation.org,richardycc@google.com,philipp.reisner@linbit.com,minchan@kernel.org,lars.ellenberg@linbit.com,corbet@lwn.net,christoph.boehmwalder@linbit.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] zram-rename-writeback_compressed-device-attr.patch removed from -mm tree
Message-Id: <20260304174507.3A2FFC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: rename writeback_compressed device attr
has been removed from the -mm tree.  Its filename was
     zram-rename-writeback_compressed-device-attr.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: rename writeback_compressed device attr
Date: Thu, 26 Feb 2026 11:54:21 +0900

Rename writeback_compressed attr to compressed_writeback to avoid possible
confusion and have more natural naming.  writeback_compressed may look
like an alternative version of writeback while in fact
writeback_compressed only sets a writeback property.  Make this
distinction more clear with a new compressed_writeback name.

This updates a feature which is new in 7.0-rcX.

Link: https://lkml.kernel.org/r/20260226025429.1042083-1-senozhatsky@chromium.org
Fixes: 4c1d61389e8e ("zram: introduce writeback_compressed device attribute")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Christoph Böhmwalder" <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-block-zram  |    4 +--
 Documentation/admin-guide/blockdev/zram.rst |    6 ++--
 drivers/block/zram/zram_drv.c               |   24 +++++++++---------
 drivers/block/zram/zram_drv.h               |    2 -
 4 files changed, 18 insertions(+), 18 deletions(-)

--- a/Documentation/ABI/testing/sysfs-block-zram~zram-rename-writeback_compressed-device-attr
+++ a/Documentation/ABI/testing/sysfs-block-zram
@@ -151,11 +151,11 @@ Description:
 		The algorithm_params file is write-only and is used to setup
 		compression algorithm parameters.
 
-What:		/sys/block/zram<id>/writeback_compressed
+What:		/sys/block/zram<id>/compressed_writeback
 Date:		Decemeber 2025
 Contact:	Richard Chang <richardycc@google.com>
 Description:
-		The writeback_compressed device atrribute toggles compressed
+		The compressed_writeback device atrribute toggles compressed
 		writeback feature.
 
 What:		/sys/block/zram<id>/writeback_batch_size
--- a/Documentation/admin-guide/blockdev/zram.rst~zram-rename-writeback_compressed-device-attr
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -216,7 +216,7 @@ writeback_limit   	WO	specifies the maxi
 writeback_limit_enable  RW	show and set writeback_limit feature
 writeback_batch_size	RW	show and set maximum number of in-flight
 				writeback operations
-writeback_compressed	RW	show and set compressed writeback feature
+compressed_writeback	RW	show and set compressed writeback feature
 comp_algorithm    	RW	show and change the compression algorithm
 algorithm_params	WO	setup compression algorithm parameters
 compact           	WO	trigger memory compaction
@@ -439,11 +439,11 @@ budget in next setting is user's job.
 By default zram stores written back pages in decompressed (raw) form, which
 means that writeback operation involves decompression of the page before
 writing it to the backing device.  This behavior can be changed by enabling
-`writeback_compressed` feature, which causes zram to write compressed pages
+`compressed_writeback` feature, which causes zram to write compressed pages
 to the backing device, thus avoiding decompression overhead.  To enable
 this feature, execute::
 
-	$ echo yes > /sys/block/zramX/writeback_compressed
+	$ echo yes > /sys/block/zramX/compressed_writeback
 
 Note that this feature should be configured before the `zramX` device is
 initialized.
--- a/drivers/block/zram/zram_drv.c~zram-rename-writeback_compressed-device-attr
+++ a/drivers/block/zram/zram_drv.c
@@ -549,7 +549,7 @@ static ssize_t bd_stat_show(struct devic
 	return ret;
 }
 
-static ssize_t writeback_compressed_store(struct device *dev,
+static ssize_t compressed_writeback_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t len)
 {
@@ -564,12 +564,12 @@ static ssize_t writeback_compressed_stor
 		return -EBUSY;
 	}
 
-	zram->wb_compressed = val;
+	zram->compressed_wb = val;
 
 	return len;
 }
 
-static ssize_t writeback_compressed_show(struct device *dev,
+static ssize_t compressed_writeback_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
@@ -577,7 +577,7 @@ static ssize_t writeback_compressed_show
 	struct zram *zram = dev_to_zram(dev);
 
 	guard(rwsem_read)(&zram->dev_lock);
-	val = zram->wb_compressed;
+	val = zram->compressed_wb;
 
 	return sysfs_emit(buf, "%d\n", val);
 }
@@ -946,7 +946,7 @@ static int zram_writeback_complete(struc
 		goto out;
 	}
 
-	if (zram->wb_compressed) {
+	if (zram->compressed_wb) {
 		/*
 		 * ZRAM_WB slots get freed, we need to preserve data required
 		 * for read decompression.
@@ -960,7 +960,7 @@ static int zram_writeback_complete(struc
 	set_slot_flag(zram, index, ZRAM_WB);
 	set_slot_handle(zram, index, req->blk_idx);
 
-	if (zram->wb_compressed) {
+	if (zram->compressed_wb) {
 		if (huge)
 			set_slot_flag(zram, index, ZRAM_HUGE);
 		set_slot_size(zram, index, size);
@@ -1100,7 +1100,7 @@ static int zram_writeback_slots(struct z
 		 */
 		if (!test_slot_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram->wb_compressed)
+		if (zram->compressed_wb)
 			err = read_from_zspool_raw(zram, req->page, index);
 		else
 			err = read_from_zspool(zram, req->page, index);
@@ -1429,7 +1429,7 @@ static void zram_async_read_endio(struct
 	 *
 	 * Keep the existing behavior for now.
 	 */
-	if (zram->wb_compressed == false) {
+	if (zram->compressed_wb == false) {
 		/* No decompression needed, complete the parent IO */
 		bio_endio(req->parent);
 		bio_put(bio);
@@ -1508,7 +1508,7 @@ static int read_from_bdev_sync(struct zr
 	flush_work(&req.work);
 	destroy_work_on_stack(&req.work);
 
-	if (req.error || zram->wb_compressed == false)
+	if (req.error || zram->compressed_wb == false)
 		return req.error;
 
 	return decompress_bdev_page(zram, page, index);
@@ -3007,7 +3007,7 @@ static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
 static DEVICE_ATTR_RW(writeback_batch_size);
-static DEVICE_ATTR_RW(writeback_compressed);
+static DEVICE_ATTR_RW(compressed_writeback);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -3031,7 +3031,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
 	&dev_attr_writeback_batch_size.attr,
-	&dev_attr_writeback_compressed.attr,
+	&dev_attr_compressed_writeback.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -3091,7 +3091,7 @@ static int zram_add(void)
 	init_rwsem(&zram->dev_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
-	zram->wb_compressed = false;
+	zram->compressed_wb = false;
 #endif
 
 	/* gendisk structure */
--- a/drivers/block/zram/zram_drv.h~zram-rename-writeback_compressed-device-attr
+++ a/drivers/block/zram/zram_drv.h
@@ -133,7 +133,7 @@ struct zram {
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
 	bool wb_limit_enable;
-	bool wb_compressed;
+	bool compressed_wb;
 	u32 wb_batch_size;
 	u64 bd_wb_limit;
 	struct block_device *bdev;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-do-not-autocorrect-bad-recompression-parameters.patch
zram-drop-num_active_comps.patch
zram-recompression-priority-param-should-override-algo.patch
zram-update-recompression-documentation.patch
zram-remove-chained-recompression.patch

