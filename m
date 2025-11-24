Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341F63358B6
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025844; cv=none; b=QdhyX1WffOtvuSOv4+IaH3mVSzPT+pWjGYFJzdEfV8ChEG84IuxhGgw/NRXbuzKtfrOlyxM0OCuPSM7ZN9TdzcILVXrSk/0wrrDSltfeW3V+UGl1KKbfFnrxHJgHr4dLZFEswsdCg6xMeuKt1Q/5Aq0UV3BS/1GO/LcirUBm3cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025844; c=relaxed/simple;
	bh=iW5jRBkINeVukbamGMLnw3EMH+Ea3OviEPrYGJyqmVA=;
	h=Date:To:From:Subject:Message-Id; b=n23g8R7ABdJJx2rc358v4gX0ya83jESvVLBhGYFiNiXaIQ/4XX94iJ+gZuOhcgrezCwZtVkFPn38bBUHQ5VYlj7durmnPW0fVdN9e/eE9wFxt+rIBg7DBWapAHy7xekP0uz10V8hDBMsc2gi6BH2H8YBye6FyE14+oxq/1Zeuf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TQ6bUy5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TQ6bUy5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065F0C4CEF1;
	Mon, 24 Nov 2025 23:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025844;
	bh=iW5jRBkINeVukbamGMLnw3EMH+Ea3OviEPrYGJyqmVA=;
	h=Date:To:From:Subject:From;
	b=TQ6bUy5gCboCr89oM9VNp6k3UAoNPj9JOqRB0MDeQU+ma6Uz4zIc4w8N6zEEZR7aJ
	 Z+VW9GDHp4zu2Vz2rE5NmDvC0JwA29vH6Q1UWWLb8HaIqQ2Sb/JnewvVobjhgpEEnY
	 8K6pkmqSFmD6lzXSZJ2nJk+NYPh4WJd58APzcN98=
Date: Mon, 24 Nov 2025 15:10:43 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-writeback-batch-size-device-attr.patch removed from -mm tree
Message-Id: <20251124231044.065F0C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add writeback batch size device attr
has been removed from the -mm tree.  Its filename was
     zram-add-writeback-batch-size-device-attr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: add writeback batch size device attr
Date: Sat, 22 Nov 2025 16:40:25 +0900

Introduce writeback_batch_size device attribute so that the maximum number
of in-flight writeback bio requests can be configured at run-time
per-device.  This essentially enables batched bio writeback.

Link: https://lkml.kernel.org/r/20251122074029.3948921-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   46 +++++++++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |    1 
 2 files changed, 41 insertions(+), 6 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-add-writeback-batch-size-device-attr
+++ a/drivers/block/zram/zram_drv.c
@@ -590,6 +590,40 @@ static ssize_t writeback_limit_show(stru
 	return sysfs_emit(buf, "%llu\n", val);
 }
 
+static ssize_t writeback_batch_size_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u32 val;
+
+	if (kstrtouint(buf, 10, &val))
+		return -EINVAL;
+
+	if (!val)
+		return -EINVAL;
+
+	down_write(&zram->init_lock);
+	zram->wb_batch_size = val;
+	up_write(&zram->init_lock);
+
+	return len;
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
@@ -781,10 +815,7 @@ static void release_wb_ctl(struct zram_w
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
@@ -799,7 +830,7 @@ static struct zram_wb_ctl *init_wb_ctl(v
 	init_waitqueue_head(&wb_ctl->done_wait);
 	spin_lock_init(&wb_ctl->done_lock);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1200,7 +1231,7 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2843,6 +2874,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2864,6 +2896,7 @@ static struct attribute *zram_disk_attrs
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2925,6 +2958,7 @@ static int zram_add(void)
 
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


