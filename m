Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69833271E6
	for <mm-commits@vger.kernel.org>; Thu, 13 Nov 2025 22:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074698; cv=none; b=jSjCqlcu9FTSsFskDfV7iIHgUE/9PVgsWc4zFvoctOhoJpCTGPwLBWGeIuRuOoYjcSbiC3/dm+W34DC6K82pxxt8NsorA55kbTSeFUEVceERZvlUMEBW52DFTzBaQRCXb5vKMhp2JiHcWsC06JlPLjaOIChwNHfNk1ywQKjbCms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074698; c=relaxed/simple;
	bh=IwXjWlf9+/gwxxWYwdJGA+IuaIS2ijAxuAfdvq1+KQc=;
	h=Date:To:From:Subject:Message-Id; b=bkns2m4ctktSyG4VjG+ZMAoXPLSUgYU7SSpk/yj8NcMWfDxHMhs8qLaAGFXrpSvyDqQ01vwOGDQA6rLQhK9YfWGBxmvZFPWFGACdamzC1zAnkqz+yMr5cRK7U0O9cE2VGoTECFSSEXQAhTbqlUwihwqQiz4E6G6xgzdx2DfVEIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ieEYeANI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ieEYeANI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F0AC19424;
	Thu, 13 Nov 2025 22:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763074697;
	bh=IwXjWlf9+/gwxxWYwdJGA+IuaIS2ijAxuAfdvq1+KQc=;
	h=Date:To:From:Subject:From;
	b=ieEYeANIWTQBz/UjmfhZDFGZ3aZPuVo/PyShmqb2MNhtKplAW0ZPH8xPRlLWbfILr
	 leA/qLxvcDZTR9X2pEhXe+pILy0WGO9LjaO7qh05+/jvVXCs/eGAxY37OZShYfNDHX
	 aGISESBXvOfz0NIjt7U2gAg+H021hr4DMCJ5K8kM=
Date: Thu, 13 Nov 2025 14:58:17 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-wb_limit_lock.patch added to mm-new branch
Message-Id: <20251113225817.96F0AC19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: drop wb_limit_lock
has been added to the -mm mm-new branch.  Its filename is
     zram-drop-wb_limit_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-wb_limit_lock.patch

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
Subject: zram: drop wb_limit_lock
Date: Thu, 13 Nov 2025 17:54:02 +0900

We don't need wb_limit_lock.  Writeback limit setters take an exclusive
write zram init_lock, while wb_limit modifications happen only from a
single task and under zram read init_lock.  No concurrent wb_limit
modifications are possible (we permit only one post-processing task at a
time).  Add lockdep assertions to wb_limit mutators.

While at it, fixup coding styles.

Link: https://lkml.kernel.org/r/20251113085402.1811522-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   22 +++++-----------------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 5 insertions(+), 18 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-wb_limit_lock
+++ a/drivers/block/zram/zram_drv.c
@@ -512,9 +512,7 @@ static ssize_t writeback_limit_enable_st
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -529,9 +527,7 @@ static ssize_t writeback_limit_enable_sh
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -549,9 +545,7 @@ static ssize_t writeback_limit_store(str
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -559,15 +553,13 @@ static ssize_t writeback_limit_store(str
 }
 
 static ssize_t writeback_limit_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+				    struct device_attribute *attr, char *buf)
 {
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->bd_wb_limit;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%llu\n", val);
@@ -866,18 +858,18 @@ release_wb_ctl:
 
 static void zram_account_writeback_rollback(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable)
 		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static void zram_account_writeback_submit(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
@@ -991,13 +983,10 @@ static int zram_writeback_slots(struct z
 
 	blk_start_plug(&wb_ctl->plug);
 	while ((pps = select_pp_slot(ctl))) {
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
-			spin_unlock(&zram->wb_limit_lock);
 			ret = -EIO;
 			break;
 		}
-		spin_unlock(&zram->wb_limit_lock);
 
 		while (!req) {
 			req = select_idle_req(wb_ctl);
@@ -2944,7 +2933,6 @@ static int zram_add(void)
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 1;
-	spin_lock_init(&zram->wb_limit_lock);
 #endif
 
 	/* gendisk structure */
--- a/drivers/block/zram/zram_drv.h~zram-drop-wb_limit_lock
+++ a/drivers/block/zram/zram_drv.h
@@ -127,7 +127,6 @@ struct zram {
 	bool claim; /* Protected by disk->open_mutex */
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
-	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
 	u32 wb_batch_size;
 	u64 bd_wb_limit;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch

