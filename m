Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A66222E004
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 18:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405059; cv=none; b=s7TASLVzv/Jhq/itiLIsUmKyF/svay47jc0nCFN6szUZ4jvDURqG1S4Lao3mo4QdTfySZFhStAU0JyeVWfA2YaZ4JxDQk+/7lidxWoTda1hgOCFnZWXz8YQ+7WaTCHet19JJk2C/WhhFyBp8e93AazlzUWTb5J+1CHwnixFzLW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405059; c=relaxed/simple;
	bh=ebu8ebmtK2bzgAwm8s68UWBE1uhgvJs9OGwe7VJoXnw=;
	h=Date:To:From:Subject:Message-Id; b=rqlnZmKVCaGhJplPgHmQe85uYQerv7o55R0EGZJY+yngx6SZoYZkWdEA0afpHLijfibtuIOWFQd6qM9TFa+IEqV4tV8QkkJDkKnudtVK64rMMuj73zFJUjm4/NDqIhKyir50Pbsbv4r+zAdsA0Jprgom2Ntl/vYyC26OfGsO/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eLFjjGqp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eLFjjGqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866B1C2BCB6;
	Mon, 17 Nov 2025 18:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763405058;
	bh=ebu8ebmtK2bzgAwm8s68UWBE1uhgvJs9OGwe7VJoXnw=;
	h=Date:To:From:Subject:From;
	b=eLFjjGqpS/jT1dKSyK0uOrVQ9sFHwfuFF8XtRmqGyPJZ2X+GJWJAvhRWtgmri0WEE
	 yssiVIO93p1+swR98lUgbCicBxpA48nhopSswccnVgQtxncKMp1nzxigekpWMqhv07
	 bLx35JvV5r7nlXcNsgetjBrfW69xUZ0n+Ej/3i5A=
Date: Mon, 17 Nov 2025 10:44:16 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-writeback-batch-size-device-attr.patch added to mm-unstable branch
Message-Id: <20251117184418.866B1C2BCB6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add writeback batch size device attr
has been added to the -mm mm-unstable branch.  Its filename is
     zram-add-writeback-batch-size-device-attr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-writeback-batch-size-device-attr.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Date: Sat, 15 Nov 2025 11:34:45 +0900

Introduce writeback_batch_size device attribute so that the maximum number
of in-flight writeback bio requests can be configured at run-time
per-device.  This essentially enables batched bio writeback.

Link: https://lkml.kernel.org/r/20251115023447.495417-3-senozhatsky@chromium.org
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
@@ -588,6 +588,42 @@ static ssize_t writeback_limit_show(stru
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
@@ -775,10 +811,7 @@ static void release_wb_ctl(struct zram_w
 	kfree(wb_ctl);
 }
 
-/* XXX: should be a per-device sysfs attr */
-#define ZRAM_WB_REQ_CNT 32
-
-static struct zram_wb_ctl *init_wb_ctl(void)
+static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 {
 	struct zram_wb_ctl *wb_ctl;
 	int i;
@@ -792,7 +825,7 @@ static struct zram_wb_ctl *init_wb_ctl(v
 	atomic_set(&wb_ctl->num_inflight, 0);
 	init_completion(&wb_ctl->done);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1180,7 +1213,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2821,6 +2854,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2842,6 +2876,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2903,6 +2938,7 @@ static int zram_add(void)
 
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_batch_size = 32;
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

