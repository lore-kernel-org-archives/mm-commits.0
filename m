Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801F72F6164
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025846; cv=none; b=ja1qDuzLHwbhcqlhog2C491GbYgkSSCTYBB8G95XRp+FCnoa3w37iVngdzKuIMetkqKNjbhCbCZKU/0NkXqw7o6+eUjGQE1TGfklLaBsc5NJICKuy156QJcU4jhJJdCwWRCLl4NrhwZRh2XfynUlmT+dWRwT40tvhcPlLIcGq8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025846; c=relaxed/simple;
	bh=znbh610DMPhmbLhclKakniGAa7n7d8DTKuEp/zG6ZTM=;
	h=Date:To:From:Subject:Message-Id; b=q93I3xQSuRg6RHxOiu2GpKuDLNWk/408dP8YDq3rQaBlA0GpH6peKvRU0wVH+n3oB5z31Vz6YcDZ6IYe8BYJLx8p4VXXvj6AH8py3gEvBjr95QusuinpdmUl24NqaAcbz6oHmfXujHldFPpgH5MAWFqTbGU0210SvDwdOIByEKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UoadA5si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UoadA5si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3797AC4CEF1;
	Mon, 24 Nov 2025 23:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025846;
	bh=znbh610DMPhmbLhclKakniGAa7n7d8DTKuEp/zG6ZTM=;
	h=Date:To:From:Subject:From;
	b=UoadA5siy7jSvlwLp1yUL4aMWnmRcXuwt4pR4hm5HtJ7WofFa9Hv5Z75pdoMW37h1
	 5crYmSZWap4t/XmspUDjykFHoXv9mXNzdc6uQDBcgznKw2sgHx5CG4fL6qwr5wMMZB
	 qU7Szm3pOoc8xzwLV/o78FUe7cR+6b/8e/b9vTWQ=
Date: Mon, 24 Nov 2025 15:10:45 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-drop-wb_limit_lock.patch removed from -mm tree
Message-Id: <20251124231046.3797AC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: drop wb_limit_lock
has been removed from the -mm tree.  Its filename was
     zram-drop-wb_limit_lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: drop wb_limit_lock
Date: Sat, 22 Nov 2025 16:40:27 +0900

We don't need wb_limit_lock.  Writeback limit setters take an exclusive
write zram init_lock, while wb_limit modifications happen only from a
single task and under zram read init_lock.  No concurrent wb_limit
modifications are possible (we permit only one post-processing task at a
time).  Add lockdep assertions to wb_limit mutators.

While at it, fixup coding styles.

Link: https://lkml.kernel.org/r/20251122074029.3948921-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
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
@@ -532,9 +532,7 @@ static ssize_t writeback_limit_enable_st
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -549,9 +547,7 @@ static ssize_t writeback_limit_enable_sh
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -569,9 +565,7 @@ static ssize_t writeback_limit_store(str
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -579,15 +573,13 @@ static ssize_t writeback_limit_store(str
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
@@ -869,18 +861,18 @@ release_wb_ctl:
 
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
@@ -1005,13 +997,10 @@ static int zram_writeback_slots(struct z
 	u32 index = 0;
 
 	while ((pps = select_pp_slot(ctl))) {
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
-			spin_unlock(&zram->wb_limit_lock);
 			ret = -EIO;
 			break;
 		}
-		spin_unlock(&zram->wb_limit_lock);
 
 		while (!req) {
 			req = zram_select_idle_req(wb_ctl);
@@ -2962,7 +2951,6 @@ static int zram_add(void)
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
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


