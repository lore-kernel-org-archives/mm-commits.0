Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D48531A55E
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 18:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405066; cv=none; b=diRx6kkHWiaG75gtpna0/up0COZZQgJWY7I1A4oAWy07JdT1jHoBPpOvoxLaDmCHSHKVQftthZkIRjtc8iCiesmM9GTvtjENTq5+Zs05gRDGCL80tqZon+bfkNhbxAV2/f7LClcTS1eHOar8rhGYJTqNn2+I8HeQXGcrSAACoZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405066; c=relaxed/simple;
	bh=FlVZxy3Kv2HYHHqCEpzYOXdr7m0jRNavWEAzHKWy0y8=;
	h=Date:To:From:Subject:Message-Id; b=cjfNDT2jYAUfN6wYDhINht1PFSJelCuzxveCM0XMh4Wwl0udSTqvLAKnwfKxewKeCdol5z9LZ2Fg8ZIuyxi5oUNO1w4ZcVfjueRZxYk8NZ3uKVxGF6BZNhYzjRs50dgyknI6tQIj6k6nV+7dLKkCZhEyhyJBMYzTcD7sXXiQEwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TKKcQlX2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TKKcQlX2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905B6C19423;
	Mon, 17 Nov 2025 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763405065;
	bh=FlVZxy3Kv2HYHHqCEpzYOXdr7m0jRNavWEAzHKWy0y8=;
	h=Date:To:From:Subject:From;
	b=TKKcQlX2I9J2w4kKdKEtH1vMgfJbbCup44WuAWBYOKJW9JT/MUmi1P+L+kdmPDNMY
	 gQqLrYySqGRJw5vrHsh1XEEIqHfnGSzWbmP2K9LQOnAByYwecgOrHIJNw07UfLMl6r
	 TOTxpqoVNpchknVxrW7tHaTRXMRpBYtYPU2dKYWI=
Date: Mon, 17 Nov 2025 10:44:24 -0800
To: mm-commits@vger.kernel.org,ywen.chen@foxmail.com,richardycc@google.com,minchan@google.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-wb_limit_lock.patch added to mm-unstable branch
Message-Id: <20251117184425.905B6C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: drop wb_limit_lock
has been added to the -mm mm-unstable branch.  Its filename is
     zram-drop-wb_limit_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-wb_limit_lock.patch

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
Subject: zram: drop wb_limit_lock
Date: Sat, 15 Nov 2025 11:34:47 +0900

We don't need wb_limit_lock.  Writeback limit setters take an exclusive
write zram init_lock, while wb_limit modifications happen only from a
single task and under zram read init_lock.  No concurrent wb_limit
modifications are possible (we permit only one post-processing task at a
time).  Add lockdep assertions to wb_limit mutators.

While at it, fixup coding styles.

Link: https://lkml.kernel.org/r/20251115023447.495417-5-senozhatsky@chromium.org
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
@@ -530,9 +530,7 @@ static ssize_t writeback_limit_enable_st
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -547,9 +545,7 @@ static ssize_t writeback_limit_enable_sh
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -567,9 +563,7 @@ static ssize_t writeback_limit_store(str
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -577,15 +571,13 @@ static ssize_t writeback_limit_store(str
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
@@ -864,18 +856,18 @@ release_wb_ctl:
 
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
@@ -990,13 +982,10 @@ static int zram_writeback_slots(struct z
 
 	blk_start_plug(&io_plug);
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
@@ -2942,7 +2931,6 @@ static int zram_add(void)
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

zram-add-writeback-batch-size-device-attr.patch
zram-take-write-lock-in-wb-limit-store-handlers.patch
zram-drop-wb_limit_lock.patch

