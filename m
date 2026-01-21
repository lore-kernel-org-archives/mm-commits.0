Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24B435F8AE
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966083; cv=none; b=pITjrT2ti5oeLUFXRuBwFHPMXTu1F9bWINdZoZKoZGkSi02THbnbYxuT0ecM284BSJsXyuDMKzZSvOc8/CddikM1BFAiFKmfSbx/5knNYW2bsw8fEyEbLgDXNRdRhYf1fU8MjH3MzWjlv3Ox2l+tHL3xuqjXwOBRIQoKuNAl8Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966083; c=relaxed/simple;
	bh=9PD9LSF6+MoQvzxJeb9wV6SfQ62Qk6X/1uEXHTsYnm0=;
	h=Date:To:From:Subject:Message-Id; b=nn6xvp2VFeLdocoF5HjV830rFT2bikUMGOK0gbpkjCxp8hxzDY6YmPY6OttJmiaegSO7nEpLpCaGYu6B277ZZ578/VqdiOD1SdJnKQmmF9N8bXT0R6blPPkXJG3TmEE/1vIZ7dzFo36yR/NOAhZ7XyCY+kYeWJeo1ZSNgNZbAZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZZS8mUOF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZZS8mUOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC9DC16AAE;
	Wed, 21 Jan 2026 03:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966083;
	bh=9PD9LSF6+MoQvzxJeb9wV6SfQ62Qk6X/1uEXHTsYnm0=;
	h=Date:To:From:Subject:From;
	b=ZZS8mUOFMk6ucMCsMi8s71K0Md9qoJw0Hg5KvUbtyTcZwkTPESgj7uKmqiKH4UjaR
	 PDzb8a866fTXsButrKC1Pcd3wxFqc7gnlSVwfDt6rSUNe2Bv9173b2/Cdqffukpy+v
	 VnMOTxiwF38JKQVdp7HOaetO1YpHAdwArvej8uLI=
Date: Tue, 20 Jan 2026 19:28:02 -0800
To: mm-commits@vger.kernel.org,minchan@kernel.org,gregkh@linuxfoundation.org,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-drop-pp_in_progress.patch removed from -mm tree
Message-Id: <20260121032803.6FC9DC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: drop pp_in_progress
has been removed from the -mm tree.  Its filename was
     zram-drop-pp_in_progress.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2619,14 +2610,10 @@ static ssize_t recompress_store(struct d
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
 
@@ -2697,7 +2684,6 @@ out:
 	if (page)
 		__free_page(page);
 	release_pp_ctl(zram, ctl);
-	atomic_set(&zram->pp_in_progress, 0);
 	return ret;
 }
 #endif
@@ -2888,7 +2874,6 @@ static void zram_reset_device(struct zra
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
@@ -3124,7 +3109,6 @@ static int zram_add(void)
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

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

