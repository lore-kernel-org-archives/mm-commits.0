Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80B932ABFE
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966036; cv=none; b=gxoFc4wBGgyOonicZI8s5cOoHD7YLOOIIAgTF6heTGkSwts0YTSDySrX0xEGm9hLBCk5MYePm6F26ts0+QKk1Lm2/cE4Mtyh1uKuW5ToJLzssfKMM4872juVZy2glV9riHXIHpdNMY9G6/Pu9NqE9A8wVLix6p7NAlIpLQ7vDG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966036; c=relaxed/simple;
	bh=BB8SgtYtdDrSvWvAUe3ZwIafT7V1DjGDTV9twkvWEPU=;
	h=Date:To:From:Subject:Message-Id; b=P89R4pdAzj9ZjXn00UTfiwVvEAl8ORZaViDw2cXjevp8gjk5clXNeZ4DRArklFKhzn0f5fhdAWkyHk1Y5oRs5iJhQVUSO+EbbqNqpq6E+0ZTmX6Hcpu3nkwTW3FdX+VqcfuCZTzs5yvylPbENm6zpcQMReGAr1gVnNZsV5bZz9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VUi14dYB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VUi14dYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67726C19423;
	Wed, 21 Jan 2026 03:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966036;
	bh=BB8SgtYtdDrSvWvAUe3ZwIafT7V1DjGDTV9twkvWEPU=;
	h=Date:To:From:Subject:From;
	b=VUi14dYBxcc5z30/XihVBHHWcBjO+dPcSfgEyBny7IsIBF/PxSPchQFLnPRh4+h2j
	 VCGHoq5ckjUblMAgcxn4cN/zU+dox3LUT9CKcnX92Uz5+XAaoHqi/5B0miiIkcvx3/
	 eRP5e/k86ONNodzqIDfRbbptuTzzoxDLGJOIqJJA=
Date: Tue, 20 Jan 2026 19:27:15 -0800
To: mm-commits@vger.kernel.org,stevensd@google.com,richardycc@google.com,minchan@google.com,clm@meta.com,bgeffon@google.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-fixup-read_block_state.patch removed from -mm tree
Message-Id: <20260121032716.67726C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: fixup read_block_state()
has been removed from the -mm tree.  Its filename was
     zram-fixup-read_block_state.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: fixup read_block_state()
Date: Thu, 15 Jan 2026 12:30:06 +0900

ac_time is now in seconds, do not use ktime_to_timespec64()

[akpm@linux-foundation.org: remove now-unused local `ts']
[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20260115033031.3818977-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Chris Mason <clm@meta.com>
Closes: https://lkml.kernel.org/r/20260114124522.1326519-1-clm@meta.com
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Stevens <stevensd@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-fixup-read_block_state
+++ a/drivers/block/zram/zram_drv.c
@@ -1570,7 +1570,6 @@ static ssize_t read_block_state(struct f
 	ssize_t index, written = 0;
 	struct zram *zram = file->private_data;
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
-	struct timespec64 ts;
 
 	kbuf = kvmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -1589,11 +1588,9 @@ static ssize_t read_block_state(struct f
 		if (!slot_allocated(zram, index))
 			goto next;
 
-		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
-			index, (s64)ts.tv_sec,
-			ts.tv_nsec / NSEC_PER_USEC,
+			"%12zd %12u.%06d %c%c%c%c%c%c\n",
+			index, zram->table[index].attr.ac_time, 0,
 			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
 			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-use-actual-object-size-to-detect-spans.patch
zsmalloc-introduce-sg-list-based-object-read-api.patch
zsmalloc-introduce-sg-list-based-object-read-api-fix.patch
zram-rename-init_lock-to-dev_lock.patch
zsmalloc-make-common-caches-global.patch

