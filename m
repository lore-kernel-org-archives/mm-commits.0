Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793599525;
	b=pl5o0Jxi31edOLKMcHDgqClt0cV7KaqoLdP931EXvhpnF3TxbZs8QuOkfJ79raCNphN/
	 f61+2paaimf2Seuri6LooNKLnrUolte9Be1qjlCnDuCjToRB8uZbOita8VF3YE31qahqq
	 s/aC0DrZCOg6+DzaAPbbiP6NtgBkBcU7lHN6ivo/YPoi0eCxoYZyjRUmht9QTfzmagdDa
	 IKOc1u+Mj/D9NOMNvMXKxC103ZJvkTip6axmJrpaGzyGTVx7WVnmy468g3vxyV6P0X4UA
	 VbrL8yKEsAGIV0fqHmGzIbmWuQO8aFWFJUGX0p8uCA1nLJFbUlFXksiLtt8u5gRzNeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793599525;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=EvRDLIyRukuEEEKW025QyKRU5VrvvC7QXba5R4Z6tjc=;
	b=mkTRPJJ6zN34GFlET2VbFrPFUeQwD6kLnBCNPbpOhLxOhtGupxqlywIzUm4nK6uCFXWR
	 p8cOETPkUmkvv04aJLXci6V+1tdy5o2ll9GJwCL+UYOORKWhflsmz161BsbhO6J948mUE
	 +6dTzd8Vm23FyWrZqGB6GbCyOisqTuwQxXAoukG31Hr7rExGzkDnz38L9X/apHwGlBQ5s
	 HDW74v0gwBKmNnGo4PDt6aFUyvyNkb74K3/rWexZJiGPqckNCydR4cQ4F4skk3zZHX2tl
	 c87YqE01G2t8XrVCE4svf0ESodIN9pSrW8JzDtNSEgM2V0bxtDvA3gwmmPaSmB2q+1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ztAtrkjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADC5606A339
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 06:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ztAtrkjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3071F000C1;
	Mon,  2 Nov 2026 06:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793599524;
	bh=EvRDLIyRukuEEEKW025QyKRU5VrvvC7QXba5R4Z6tjc=;
	h=Date:To:From:Subject;
	b=ztAtrkjlhrbejyC3lVjv69xv9W8j8rzX2eaIpkTe2wB47ImYVLtr/zwxoj6gOvr+2
	 xTLSF6vUAF0j2vJxecpgN9XNbuxdB7ZWW4QzImF+zTYjMMw4FvOfdPt4n4HSMiv3OO
	 yEhBrpoi2FS8p2fXQC75z4v8Z1y/Li1yfWZZ+zN0=
Date: Sun, 01 Nov 2026 22:05:24 -0800
To: mm-commits@vger.kernel.org,richardycc@google.com,minchan@kernel.org,
	josef@toxicpanda.com,bgeffon@google.com,senozhatsky@chromium.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-fix-quadratic-writeback-bitmap-search.patch added to mm-nonmm-unstable branch
Message-Id: <20261102060524.BA3071F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: zram: fix quadratic writeback bitmap search
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     zram-fix-quadratic-writeback-bitmap-search.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-fix-quadratic-writeback-bitmap-search.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: zram: fix quadratic writeback bitmap search
Date: Fri, 30 Oct 2026 13:16:49 +0900

zram_reserve_bdev_block() always scans writeback's bitmap from offset 0,
which results in quadratic complexity.  Introduce per-device bitmap cursor
member that is set to next to most recently allocated bit, so next time
the bitmap scan starts from that offset.

Link: https://lore.kernel.org/20da9e9a5ffefd1e6875e311d3740b9f3c1061f3.1793333729.git.senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Richard Chang <richardycc@google.com>
Cc: Josef Bacik <josef@toxicpanda.com>
---

 drivers/block/zram/zram_drv.c |   17 ++++++++++++++---
 drivers/block/zram/zram_drv.h |    1 +
 2 files changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fix-quadratic-writeback-bitmap-search
+++ a/drivers/block/zram/zram_drv.c
@@ -694,6 +694,7 @@ static void reset_bdev(struct zram *zram
 	zram->disk->fops = &zram_devops;
 	kvfree(zram->bitmap);
 	zram->bitmap = NULL;
+	zram->bitmap_cursor = 0;
 	zram->nr_pages = 0;
 }
 
@@ -786,6 +787,7 @@ static ssize_t backing_dev_store(struct
 	zram->bdev = I_BDEV(inode);
 	zram->backing_dev = backing_dev;
 	zram->bitmap = bitmap;
+	zram->bitmap_cursor = 0;
 	zram->nr_pages = nr_pages;
 
 	pr_info("setup backing device %s\n", file_name);
@@ -807,10 +809,19 @@ static unsigned long zram_reserve_bdev_b
 {
 	unsigned long blk_idx;
 
-	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, 0);
-	if (blk_idx == zram->nr_pages)
-		return INVALID_BDEV_BLOCK;
+	/* continue after the last allocated block */
+	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages,
+				     zram->bitmap_cursor);
+	/* wrap */
+	if (blk_idx == zram->nr_pages) {
+		blk_idx = find_next_zero_bit(zram->bitmap, zram->bitmap_cursor,
+					     0);
+		/* bitmap is full */
+		if (blk_idx == zram->bitmap_cursor)
+			return INVALID_BDEV_BLOCK;
+	}
 
+	zram->bitmap_cursor = blk_idx + 1;
 	set_bit(blk_idx, zram->bitmap);
 	atomic64_inc(&zram->stats.bd_count);
 	return blk_idx;
--- a/drivers/block/zram/zram_drv.h~zram-fix-quadratic-writeback-bitmap-search
+++ a/drivers/block/zram/zram_drv.h
@@ -152,6 +152,7 @@ struct zram {
 	u64 bd_wb_limit;
 	struct block_device *bdev;
 	unsigned long *bitmap;
+	unsigned long bitmap_cursor;
 	unsigned long nr_pages;
 #endif
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-prefix-backends-printk-s.patch
zram-remove-debugfs-entry-on-init-failure.patch
zram-reset-writeback-state-in-zram_reset_device.patch
zram-move-mark_slot_accessed-under-existing-slot-lock-sections.patch
zram-remove-stale-warn_on-from-zram_read_page.patch
zram-zstd-do-not-allocate-empty-c-d-dictionaries.patch
zram-lz4hc-pre-initialize-dictionary-stream-in-setup_params.patch
zram-lz4-use-lz4_decompress_safe_usingdict.patch
zram-lz4hc-use-lz4_decompress_safe_usingdict.patch
zram-zstd-do-not-use-kvzalloc-for-zstd-allocations.patch
zram-split-zcomp-into-separate-r-w-streams.patch
zram-introduce-shared-decompression-streams.patch
zram-allocate-bounce-buffer-for-spanning-objects.patch
zram-borrow-idle-decompression-streams-in-exclusive-mode.patch
zram-use-a-singleton-compression-context-for-recompression.patch
zram-fix-quadratic-writeback-bitmap-search.patch

