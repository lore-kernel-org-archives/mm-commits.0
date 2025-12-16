Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E21923BF9B
	for <mm-commits@vger.kernel.org>; Tue, 16 Dec 2025 19:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765912816; cv=none; b=m0m9tPb8sjW3VO06S+lZiwSwqliDLfGnb9DRyxMOYArw7MP8oVx8/WgIBhDQluNgGvS/11d2p8wsr8ReXTIWw3zy1WcyRozZBjoPZHGrnJnsgoWAexq6sxyza/oxy4Bp5+OQVh7D+Cu5W5f/+ys1Zb/W9WaNe758TE9/4L1zom0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765912816; c=relaxed/simple;
	bh=0jOSuQMHu0/HqJ3EBMP0Wkl8IySz4pr2NQZ8wWKdN9A=;
	h=Date:To:From:Subject:Message-Id; b=s0cnpfciRHLVI6Z0aY1mDbRMHXfqCqALvGWNwk7knetz+pqi4C/YvpzVBAvWg4yZRvxbvIwmjvfvKz+EFryL2AW4fqkepgx5HiRDFtoYWmQFbDO8C7JsGZ/9y0PcrBgwn2AgiprxO9wmHR8DkwlqtCRlY6DOPsMgtkEbcHXA74g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2atHd/hg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2atHd/hg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E888C4CEF1;
	Tue, 16 Dec 2025 19:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765912816;
	bh=0jOSuQMHu0/HqJ3EBMP0Wkl8IySz4pr2NQZ8wWKdN9A=;
	h=Date:To:From:Subject:From;
	b=2atHd/hgF3Fce4YbvA26PcnAAryXu0EZPoOgc3XvqLZDZioo4TDrMl/oARKNKsa+I
	 lYDBlAloBVg8O5GMiYk2KzTwBt/TmlhUVMZggHricyqjOK+BoX7VKpRMmNcKOkO9yM
	 LATBVJzzBFGPlfQAyB/2aTvz8rOxxkCGZqTrUTEw=
Date: Tue, 16 Dec 2025 11:20:15 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,gregkh@linuxfoundation.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-drop-pp_in_progress.patch added to mm-new branch
Message-Id: <20251216192016.1E888C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: drop pp_in_progress
has been added to the -mm mm-new branch.  Its filename is
     zram-drop-pp_in_progress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-drop-pp_in_progress.patch

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
Subject: zram: drop pp_in_progress
Date: Tue, 16 Dec 2025 16:13:42 +0900

pp_in_progress makes sure that only one post-processing (writeback or
recomrpession) is active at any given time.  Functionality wise it,
basically, shadows zram init_lock, when init_lock is acquired in writer
mode.

Switch recompress_store() and writeback_store() to take zram init_lock in
writer mode, like all store() sysfs handlers should do, so that we can
drop pp_in_progress.  Recompression and writeback can be somewhat slow, so
holding init_lock in writer mode can block zram attrs reads, but in
reality the only zram attrs reads that take place are mm_stat reads, and
usually it's the same process that reads mm_stat and does recompression or
writeback.

Link: https://lkml.kernel.org/r/20251216071342.687993-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   32 ++++++++------------------------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 8 insertions(+), 25 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-pp_in_progress
+++ a/drivers/block/zram/zram_drv.c
@@ -902,7 +902,7 @@ release_wb_ctl:
 
 static void zram_account_writeback_rollback(struct zram *zram)
 {
-	lockdep_assert_held_read(&zram->init_lock);
+	lockdep_assert_held_write(&zram->init_lock);
 
 	if (zram->wb_limit_enable)
 		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
@@ -910,7 +910,7 @@ static void zram_account_writeback_rollb
 
 static void zram_account_writeback_submit(struct zram *zram)
 {
-	lockdep_assert_held_read(&zram->init_lock);
+	lockdep_assert_held_write(&zram->init_lock);
 
 	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
@@ -1264,24 +1264,16 @@ static ssize_t writeback_store(struct de
 	ssize_t ret = len;
 	int err, mode = 0;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
-	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1))
-		return -EAGAIN;
-
-	if (!zram->backing_dev) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (!zram->backing_dev)
+		return -ENODEV;
 
 	pp_ctl = init_pp_ctl();
-	if (!pp_ctl) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!pp_ctl)
+		return -ENOMEM;
 
 	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
@@ -1358,7 +1350,6 @@ static ssize_t writeback_store(struct de
 out:
 	release_pp_ctl(zram, pp_ctl);
 	release_wb_ctl(wb_ctl);
-	atomic_set(&zram->pp_in_progress, 0);
 
 	return ret;
 }
@@ -2622,14 +2613,10 @@ static ssize_t recompress_store(struct d
 	if (threshold >= huge_class_size)
 		return -EINVAL;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
-	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1))
-		return -EAGAIN;
-
 	if (algo) {
 		bool found = false;
 
@@ -2700,7 +2687,6 @@ out:
 	if (page)
 		__free_page(page);
 	release_pp_ctl(zram, ctl);
-	atomic_set(&zram->pp_in_progress, 0);
 	return ret;
 }
 #endif
@@ -2891,7 +2877,6 @@ static void zram_reset_device(struct zra
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
@@ -3127,7 +3112,6 @@ static int zram_add(void)
 	zram->disk->fops = &zram_devops;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
-	atomic_set(&zram->pp_in_progress, 0);
 	zram_comp_params_reset(zram);
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
--- a/drivers/block/zram/zram_drv.h~zram-drop-pp_in_progress
+++ a/drivers/block/zram/zram_drv.h
@@ -143,6 +143,5 @@ struct zram {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
 	struct dentry *debugfs_dir;
 #endif
-	atomic_t pp_in_progress;
 };
 #endif
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

