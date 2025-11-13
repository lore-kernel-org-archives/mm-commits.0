Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FEB324B07
	for <mm-commits@vger.kernel.org>; Thu, 13 Nov 2025 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074696; cv=none; b=TOBaD+EiY/PwCVCWRsGTUX3WxVcylC4F9QOel0NwHMSN9FTfmJYjTn6fQGi1V45a2Nv/xxq7aU9CubK9NmRDHAOjZ/WNLuicefBDoneR53h4f55j+QgNh8S3vRm2fLym5HA0hFeTZB69vsHiRETvEWIzg5O95jcRW7elDU1pkLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074696; c=relaxed/simple;
	bh=iv0iWEwpvgE3Ct/9SoMTUZZFSo+FjVwNEKTeDJdhTPA=;
	h=Date:To:From:Subject:Message-Id; b=k87LY4egk+w9YOHPEkkmSPth6BvhST2MMqAETXa661OjSVZ/dFv35bD98E4p2IucwNsQLMJ78a5MzaSQ9teK42QGdwLV0DD+R4UophlmhXpRukWtU1wOaWQd9L6WXOVFT6Q6BaMIXbW5NAMXrOq4Oi3ZoZvuYjmvdLQLiS9Xnh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Itu6CP43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Itu6CP43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259A4C4CEF7;
	Thu, 13 Nov 2025 22:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763074695;
	bh=iv0iWEwpvgE3Ct/9SoMTUZZFSo+FjVwNEKTeDJdhTPA=;
	h=Date:To:From:Subject:From;
	b=Itu6CP43jn8opi9WFhWCzgDUv08Q7FG/xQoT2SDxIAGOT6UmygkQVW0PaXSqAC+J3
	 HI9jnaiPTe/7QDjKPVhUaxIRkoWYTY2DUTFvfhVXUo5suORSi2OglLDNlssjNXw+b8
	 r+1C5X3WBuPrFxgBtUXVRvsWxZ5MJrp3JB6IAkk8=
Date: Thu, 13 Nov 2025 14:58:14 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-writeback-batch-size-device-attr.patch added to mm-new branch
Message-Id: <20251113225815.259A4C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add writeback batch size device attr
has been added to the -mm mm-new branch.  Its filename is
     zram-add-writeback-batch-size-device-attr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-writeback-batch-size-device-attr.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add writeback batch size device attr
Date: Thu, 13 Nov 2025 17:54:00 +0900

Introduce writeback_batch_size device attribute so that the maximum number
of in-flight writeback bio requests can be configured at run-time
per-device.  This essentially enables batched bio writeback.

Link: https://lkml.kernel.org/r/20251113085402.1811522-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   48 ++++++++++++++++++++++++++++----
 drivers/block/zram/zram_drv.h |    1 
 2 files changed, 43 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-writeback-batch-size-device-attr
+++ a/drivers/block/zram/zram_drv.c
@@ -570,6 +570,42 @@ static ssize_t writeback_limit_show(stru
 	return sysfs_emit(buf, "%llu\n", val);
 }
 
+static ssize_t writeback_batch_size_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u32 val;
+	ssize_t ret = -EINVAL;
+
+	if (kstrtouint(buf, 10, &val))
+		return ret;
+
+	if (!val)
+		val = 1;
+
+	down_read(&zram->init_lock);
+	zram->wb_batch_size = val;
+	up_read(&zram->init_lock);
+	ret = len;
+
+	return ret;
+}
+
+static ssize_t writeback_batch_size_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	u32 val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	val = zram->wb_batch_size;
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%u\n", val);
+}
+
 static void reset_bdev(struct zram *zram)
 {
 	if (!zram->backing_dev)
@@ -776,10 +812,7 @@ static void release_wb_ctl(struct zram_w
 	kfree(wb_ctl);
 }
 
-/* XXX: should be a per-device sysfs attr */
-#define ZRAM_WB_REQ_CNT 1
-
-static struct zram_wb_ctl *init_wb_ctl(void)
+static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 {
 	struct zram_wb_ctl *wb_ctl;
 	int i;
@@ -793,7 +826,7 @@ static struct zram_wb_ctl *init_wb_ctl(v
 	atomic_set(&wb_ctl->num_inflight, 0);
 	init_completion(&wb_ctl->done);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1182,7 +1215,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2823,6 +2856,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2844,6 +2878,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2905,6 +2940,7 @@ static int zram_add(void)
 
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_batch_size = 1;
 	spin_lock_init(&zram->wb_limit_lock);
 #endif
 
--- a/drivers/block/zram/zram_drv.h~zram-add-writeback-batch-size-device-attr
+++ a/drivers/block/zram/zram_drv.h
@@ -129,6 +129,7 @@ struct zram {
 	struct file *backing_dev;
 	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
+	u32 wb_batch_size;
 	u64 bd_wb_limit;
 	struct block_device *bdev;
 	unsigned long *bitmap;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch

