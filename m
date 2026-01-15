Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B107C45BE3
	for <mm-commits@vger.kernel.org>; Thu, 15 Jan 2026 19:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768505676; cv=none; b=ZkiFDPSuZu+4F5hS2x+BTjYP/0N3G9ONytak+8jjE0DsJgMlnchZm7PphOImc/nG0O9BHOxVSZq+L3sK6Akv6x2qVrBX3sLo8SnBufMc1pPKP4fjJxwYamhEU+KGXaBEFe77GHoCch3hfLp0BYkC9VIBk24UNK78zK5DG02mSOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768505676; c=relaxed/simple;
	bh=bPR14gU9YJEFcvyRO9TeuEotgqmKmTHtflTfPIAnNJs=;
	h=Date:To:From:Subject:Message-Id; b=MAB9tLylDZADBA9EsvXj4OchHX0/qbYzT3iLGv6ifbv5/KvRTzDQMExjkal+BRzWVh/qMOuofWCqhr8pnhbUDBX7Lk2sLMftSzUePb726RWdO6O2Y7LkBmcLWwbFW0DKucUoo35XHGmkDG/RJTC39qEjiim23ydIbGcZH/QbRnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DLhtEdpe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DLhtEdpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455D1C116D0;
	Thu, 15 Jan 2026 19:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768505676;
	bh=bPR14gU9YJEFcvyRO9TeuEotgqmKmTHtflTfPIAnNJs=;
	h=Date:To:From:Subject:From;
	b=DLhtEdpe+9K8VU9rwT1IEvxBljrHh4JIolMV6Cvo5FE57wpks+KObuqSHQzgcZYnQ
	 79ziahcTlEI2z03PQ9yF34LgrZO1wGF95Xn4SXkxTR1p+lRT3mHxw0DBcCYLImqSYa
	 LvFkh3te/eD0Gneb6pG8tLnw2CUBH5KCBHcMA39A=
Date: Thu, 15 Jan 2026 11:34:35 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,bgeffon@google.com,axboe@kernel.dk,akpm@linux-foundation.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-rename-init_lock-to-dev_lock.patch added to mm-new branch
Message-Id: <20260115193436.455D1C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: rename init_lock to dev_lock
has been added to the -mm mm-new branch.  Its filename is
     zram-rename-init_lock-to-dev_lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-rename-init_lock-to-dev_lock.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: rename init_lock to dev_lock
Date: Thu, 15 Jan 2026 17:08:07 +0900

init_lock has completely outgrown its initial purpose and is no longer
used only to "prevent concurrent execution of device init" as the stale
comment suggests.  The scope of this lock is much bigger now.

These days this lock (rw_semaphore) controls how a task owns the
corresponding zram device: either in shared mode or in exclusive mode.

All zram device attribute writes should own the device in exclusive mode,
which synchronizes these tasks and prevents, for example, concurrent
execution of recompression and writeback.

All zram device attribute reads should own the device in shared mode.

Rename the lock to dev_lock to better reflect its current purpose.

Link: https://lkml.kernel.org/r/20260115080807.3957860-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   60 ++++++++++++++++----------------
 drivers/block/zram/zram_drv.h |    4 +-
 2 files changed, 32 insertions(+), 32 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-rename-init_lock-to-dev_lock
+++ a/drivers/block/zram/zram_drv.c
@@ -365,7 +365,7 @@ static ssize_t initstate_show(struct dev
 	u32 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	val = init_done(zram);
 
 	return sysfs_emit(buf, "%u\n", val);
@@ -391,7 +391,7 @@ static ssize_t mem_limit_store(struct de
 	if (buf == tmp) /* no chars parsed, invalid input */
 		return -EINVAL;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	zram->limit_pages = PAGE_ALIGN(limit) >> PAGE_SHIFT;
 
 	return len;
@@ -409,7 +409,7 @@ static ssize_t mem_used_max_store(struct
 	if (err || val != 0)
 		return -EINVAL;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	if (init_done(zram)) {
 		atomic_long_set(&zram->stats.max_used_pages,
 				zs_get_total_pages(zram->mem_pool));
@@ -477,7 +477,7 @@ static ssize_t idle_store(struct device
 			return -EINVAL;
 	}
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
@@ -539,7 +539,7 @@ static ssize_t bd_stat_show(struct devic
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	ret = sysfs_emit(buf,
 			 "%8llu %8llu %8llu\n",
 			 FOUR_K((u64)atomic64_read(&zram->stats.bd_count)),
@@ -559,7 +559,7 @@ static ssize_t writeback_compressed_stor
 	if (kstrtobool(buf, &val))
 		return -EINVAL;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	if (init_done(zram)) {
 		return -EBUSY;
 	}
@@ -576,7 +576,7 @@ static ssize_t writeback_compressed_show
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	val = zram->wb_compressed;
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -592,7 +592,7 @@ static ssize_t writeback_limit_enable_st
 	if (kstrtoull(buf, 10, &val))
 		return -EINVAL;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	zram->wb_limit_enable = val;
 
 	return len;
@@ -605,7 +605,7 @@ static ssize_t writeback_limit_enable_sh
 	bool val;
 	struct zram *zram = dev_to_zram(dev);
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	val = zram->wb_limit_enable;
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -631,7 +631,7 @@ static ssize_t writeback_limit_store(str
 	 */
 	val = rounddown(val, PAGE_SIZE / 4096);
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	zram->bd_wb_limit = val;
 
 	return len;
@@ -643,7 +643,7 @@ static ssize_t writeback_limit_show(stru
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	val = zram->bd_wb_limit;
 
 	return sysfs_emit(buf, "%llu\n", val);
@@ -662,7 +662,7 @@ static ssize_t writeback_batch_size_stor
 	if (!val)
 		return -EINVAL;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	zram->wb_batch_size = val;
 
 	return len;
@@ -675,7 +675,7 @@ static ssize_t writeback_batch_size_show
 	u32 val;
 	struct zram *zram = dev_to_zram(dev);
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	val = zram->wb_batch_size;
 
 	return sysfs_emit(buf, "%u\n", val);
@@ -703,7 +703,7 @@ static ssize_t backing_dev_show(struct d
 	char *p;
 	ssize_t ret;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	file = zram->backing_dev;
 	if (!file) {
 		memcpy(buf, "none\n", 5);
@@ -737,7 +737,7 @@ static ssize_t backing_dev_store(struct
 	if (!file_name)
 		return -ENOMEM;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	if (init_done(zram)) {
 		pr_info("Can't setup backing device for initialized device\n");
 		err = -EBUSY;
@@ -901,7 +901,7 @@ release_wb_ctl:
 
 static void zram_account_writeback_rollback(struct zram *zram)
 {
-	lockdep_assert_held_write(&zram->init_lock);
+	lockdep_assert_held_write(&zram->dev_lock);
 
 	if (zram->wb_limit_enable)
 		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
@@ -909,7 +909,7 @@ static void zram_account_writeback_rollb
 
 static void zram_account_writeback_submit(struct zram *zram)
 {
-	lockdep_assert_held_write(&zram->init_lock);
+	lockdep_assert_held_write(&zram->dev_lock);
 
 	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
@@ -1263,7 +1263,7 @@ static ssize_t writeback_store(struct de
 	ssize_t ret = len;
 	int err, mode = 0;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
@@ -1566,7 +1566,7 @@ static ssize_t read_block_state(struct f
 	if (!kbuf)
 		return -ENOMEM;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	if (!init_done(zram)) {
 		kvfree(kbuf);
 		return -EINVAL;
@@ -1669,7 +1669,7 @@ static int __comp_algorithm_store(struct
 		return -EINVAL;
 	}
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	if (init_done(zram)) {
 		kfree(compressor);
 		pr_info("Can't change algorithm for initialized device\n");
@@ -1797,7 +1797,7 @@ static ssize_t comp_algorithm_show(struc
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t sz;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	sz = zcomp_available_show(zram->comp_algs[ZRAM_PRIMARY_COMP], buf, 0);
 	return sz;
 }
@@ -1823,7 +1823,7 @@ static ssize_t recomp_algorithm_show(str
 	ssize_t sz = 0;
 	u32 prio;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		if (!zram->comp_algs[prio])
 			continue;
@@ -1881,7 +1881,7 @@ static ssize_t compact_store(struct devi
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
@@ -1896,7 +1896,7 @@ static ssize_t io_stat_show(struct devic
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	ret = sysfs_emit(buf,
 			"%8llu %8llu 0 %8llu\n",
 			(u64)atomic64_read(&zram->stats.failed_reads),
@@ -1917,7 +1917,7 @@ static ssize_t mm_stat_show(struct devic
 
 	memset(&pool_stats, 0x00, sizeof(struct zs_pool_stats));
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	if (init_done(zram)) {
 		mem_used = zs_get_total_pages(zram->mem_pool);
 		zs_pool_stats(zram->mem_pool, &pool_stats);
@@ -1948,7 +1948,7 @@ static ssize_t debug_stat_show(struct de
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_read)(&zram->dev_lock);
 	ret = sysfs_emit(buf,
 			"version: %d\n0 %8llu\n",
 			version,
@@ -2614,7 +2614,7 @@ static ssize_t recompress_store(struct d
 	if (threshold >= huge_class_size)
 		return -EINVAL;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
@@ -2866,7 +2866,7 @@ static void zram_destroy_comps(struct zr
 
 static void zram_reset_device(struct zram *zram)
 {
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 
 	zram->limit_pages = 0;
 
@@ -2896,7 +2896,7 @@ static ssize_t disksize_store(struct dev
 	if (!disksize)
 		return -EINVAL;
 
-	guard(rwsem_write)(&zram->init_lock);
+	guard(rwsem_write)(&zram->dev_lock);
 	if (init_done(zram)) {
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
@@ -3091,7 +3091,7 @@ static int zram_add(void)
 		goto out_free_dev;
 	device_id = ret;
 
-	init_rwsem(&zram->init_lock);
+	init_rwsem(&zram->dev_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
 	zram->wb_compressed = false;
--- a/drivers/block/zram/zram_drv.h~zram-rename-init_lock-to-dev_lock
+++ a/drivers/block/zram/zram_drv.h
@@ -111,8 +111,8 @@ struct zram {
 	struct zcomp *comps[ZRAM_MAX_COMPS];
 	struct zcomp_params params[ZRAM_MAX_COMPS];
 	struct gendisk *disk;
-	/* Prevent concurrent execution of device init */
-	struct rw_semaphore init_lock;
+	/* Locks the device either in exclusive or in shared mode */
+	struct rw_semaphore dev_lock;
 	/*
 	 * the number of pages zram can consume for storing compressed data
 	 */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-document-writeback_batch_size.patch
zram-move-bd_stat-to-writeback-section.patch
zram-rename-zram_free_page.patch
zram-switch-to-guard-for-init_lock.patch
zram-consolidate-device-attr-declarations.patch
zram-use-u32-for-entry-ac_time-tracking.patch
zram-rename-internal-slot-api.patch
zram-trivial-fix-of-recompress_slot-coding-styles.patch
zram-drop-pp_in_progress.patch
zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zram-rename-init_lock-to-dev_lock.patch

