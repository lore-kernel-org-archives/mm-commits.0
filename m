Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764D41849
	for <mm-commits@vger.kernel.org>; Wed, 25 Sep 2024 00:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225593; cv=none; b=NsFKGcRDLXgalsved89sB4z/PpmSsaqvfwfaAVdl6CcPOW8bm6n9gR1HxBqAHyZKRj5v7qf4tm5lIc+FvzKZ3gRacGPDKsACn8eHTkVH4tPNPYJtqdkzKKqDTVU4vkIVK6bCa2J3J//vlTDkMsxhcQ+gVOW35pwdAzJsWtvTEls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225593; c=relaxed/simple;
	bh=SaJaiCSqGVAv49LEDutThe2rK00rMevY8D2VhZeki0k=;
	h=Date:To:From:Subject:Message-Id; b=HhXSBwvBs4A6MVHwCwvJnU/2BzbM1sLh7ES0YfaPBRSW+KjYuBjTcwutoKbJ6rZVX4vw1muRTJ1IJcxdX1HFrxKYsl8NMKEWDkl3ozCNgw1wkWP7cjSDw6Ga58HHwdUKvUdGVpYjMvQsCL+DqG6fLTwWNR1TBJxvgSHBUcwcsuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vuWXCj3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vuWXCj3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CE8C4CEC4;
	Wed, 25 Sep 2024 00:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727225592;
	bh=SaJaiCSqGVAv49LEDutThe2rK00rMevY8D2VhZeki0k=;
	h=Date:To:From:Subject:From;
	b=vuWXCj3X2P3p5+tBTTpvW9Be9gZqLgkL7M+LPPQRAALfFBcjC3v7secl5PECWeDDB
	 hZAcd1pkWypqr9obkrMEjsRbxtyjwUMDXaWresOrdKCUukQsujMKliq4Wpnzon9KIu
	 HwHmDRru03A9cDMYjwjBkH2/+tv89SJxQng1arB0=
Date: Tue, 24 Sep 2024 17:53:12 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-permit-only-one-post-processing-operation-at-a-time.patch added to mm-unstable branch
Message-Id: <20240925005312.D8CE8C4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: permit only one post-processing operation at a time
has been added to the -mm mm-unstable branch.  Its filename is
     zram-permit-only-one-post-processing-operation-at-a-time.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-permit-only-one-post-processing-operation-at-a-time.patch

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
Subject: zram: permit only one post-processing operation at a time
Date: Tue, 17 Sep 2024 11:09:07 +0900

Both recompress and writeback soon will unlock slots during processing,
which makes things too complex wrt possible race-conditions.  We still
want to clear PP_SLOT in slot_free, because this is how we figure out that
slot that was selected for post-processing has been released under us and
when we start post-processing we check if slot still has PP_SLOT set.  At
the same time, theoretically, we can have something like this:

CPU0			    CPU1

recompress
scan slots
set PP_SLOT
unlock slot
			slot_free
			clear PP_SLOT

			allocate PP_SLOT
			writeback
			scan slots
			set PP_SLOT
			unlock slot
select PP-slot
test PP_SLOT

So recompress will not detect that slot has been re-used and re-selected
for concurrent writeback post-processing.

Make sure that we only permit on post-processing operation at a time.  So
now recompress and writeback post-processing don't race against each
other, we only need to handle slot re-use (slot_free and write), which is
handled individually by each pp operation.

Having recompress and writeback competing for the same slots is not
exactly good anyway (can't imagine anyone doing that).

Link: https://lkml.kernel.org/r/20240917021020.883356-3-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/blockdev/zram.rst |    2 ++
 drivers/block/zram/zram_drv.c               |   16 ++++++++++++++++
 drivers/block/zram/zram_drv.h               |    1 +
 3 files changed, 19 insertions(+)

--- a/Documentation/admin-guide/blockdev/zram.rst~zram-permit-only-one-post-processing-operation-at-a-time
+++ a/Documentation/admin-guide/blockdev/zram.rst
@@ -47,6 +47,8 @@ The list of possible return codes:
 -ENOMEM	  zram was not able to allocate enough memory to fulfil your
 	  needs.
 -EINVAL	  invalid input has been provided.
+-EAGAIN	  re-try operation later (e.g. when attempting to run recompress
+	  and writeback simultaneously).
 ========  =============================================================
 
 If you use 'echo', the returned value is set by the 'echo' utility,
--- a/drivers/block/zram/zram_drv.c~zram-permit-only-one-post-processing-operation-at-a-time
+++ a/drivers/block/zram/zram_drv.c
@@ -627,6 +627,12 @@ static ssize_t writeback_store(struct de
 		goto release_init_lock;
 	}
 
+	/* Do not permit concurrent post-processing actions. */
+	if (atomic_xchg(&zram->pp_in_progress, 1)) {
+		up_read(&zram->init_lock);
+		return -EAGAIN;
+	}
+
 	if (!zram->backing_dev) {
 		ret = -ENODEV;
 		goto release_init_lock;
@@ -753,6 +759,7 @@ next:
 		free_block_bdev(zram, blk_idx);
 	__free_page(page);
 release_init_lock:
+	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
 
 	return ret;
@@ -1883,6 +1890,12 @@ static ssize_t recompress_store(struct d
 		goto release_init_lock;
 	}
 
+	/* Do not permit concurrent post-processing actions. */
+	if (atomic_xchg(&zram->pp_in_progress, 1)) {
+		up_read(&zram->init_lock);
+		return -EAGAIN;
+	}
+
 	if (algo) {
 		bool found = false;
 
@@ -1950,6 +1963,7 @@ next:
 	__free_page(page);
 
 release_init_lock:
+	atomic_set(&zram->pp_in_progress, 0);
 	up_read(&zram->init_lock);
 	return ret;
 }
@@ -2146,6 +2160,7 @@ static void zram_reset_device(struct zra
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
+	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
@@ -2383,6 +2398,7 @@ static int zram_add(void)
 	zram->disk->fops = &zram_devops;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
+	atomic_set(&zram->pp_in_progress, 0);
 
 	/* Actual capacity set using sysfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
--- a/drivers/block/zram/zram_drv.h~zram-permit-only-one-post-processing-operation-at-a-time
+++ a/drivers/block/zram/zram_drv.h
@@ -140,5 +140,6 @@ struct zram {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
 	struct dentry *debugfs_dir;
 #endif
+	atomic_t pp_in_progress;
 };
 #endif
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch

