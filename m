Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D28428312D
	for <mm-commits@vger.kernel.org>; Tue, 18 Nov 2025 18:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763489559; cv=none; b=f4QgzD+AavzMRllBxRRdYfSrHnodIic8RbL0jkX0xvZ5Oq1umXzbeh22zXcRWD0BLyaMFGMfi5JNhq4Oqkc3Ys93+nvcm4iCwFna22uz9LzbhOB95UMH7Id//TboakxWfiPwyv9zGGvda3L86bULCMKpLSyzuMDzmwnnb6uTtuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763489559; c=relaxed/simple;
	bh=6rfs/1au2yimLIAG2CDQaILXSRaPLiePvZenyBU8oUo=;
	h=Date:To:From:Subject:Message-Id; b=TMkTPkn9CktJ+hp6KOzZO2I/k5PTd3UwFxIlBSVzZTZgHS/52TXcbOSjIeBdQe636v9tULcETGaxpO47ZA3nH31MN/kWKVZAfYfrmGbCv3LlCtqZE8OGx18hfW1boDZAj1Vh6iKBqWTF6kK0mm9Ah4C9g+ZKOQpdsQodaDqPux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a+9n1+I0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a+9n1+I0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A27FC4AF09;
	Tue, 18 Nov 2025 18:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763489558;
	bh=6rfs/1au2yimLIAG2CDQaILXSRaPLiePvZenyBU8oUo=;
	h=Date:To:From:Subject:From;
	b=a+9n1+I008GNWtc8m18kHcvA2BNSzmskdu7tvuo0i0bpzgDjkY/uU4uS154/2/nox
	 3eXzOUt4nhMx0/J4bu4vQyW+8w5AjmK0sbUXNGmIXPhKJE7ipTI9emoGiIpYNj7WQJ
	 cQUA88FSYIw3svZNywi/rxVcXDhHiUSXoLH9M2CE=
Date: Tue, 18 Nov 2025 10:12:37 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-writeback-batch-size-device-attr.patch added to mm-unstable branch
Message-Id: <20251118181238.9A27FC4AF09@smtp.kernel.org>
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
Date: Tue, 18 Nov 2025 16:29:56 +0900

Introduce writeback_batch_size device attribute so that the maximum number
of in-flight writeback bio requests can be configured at run-time
per-device.  This essentially enables batched bio writeback.

Link: https://lkml.kernel.org/r/20251118073000.1928107-3-senozhatsky@chromium.org
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
@@ -1183,7 +1216,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2826,6 +2859,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2847,6 +2881,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2908,6 +2943,7 @@ static int zram_add(void)
 
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
zram-rework-bdev-block-allocation.patch
zram-read-slot-block-idx-under-slot-lock.patch

