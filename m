Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20A52701B8
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744916; cv=none; b=ePMbtbWNB2/56kU56EGL1cnqh8x8C940hNJzCtQfWd0ARXqihraDld7AfjG7nCJH6oN8wB6/L9xMOfaLuw2w8xf6bq4FJtf4crAv9//xRziD0Ogq19H8AsSTw6/sDZewtFDz9dt8iuGNzxyaCaxPTAYqIUhz23jKQhPFYJh0WVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744916; c=relaxed/simple;
	bh=wgdGaF4nXz2WGhPqfLv8wES0xkuIEu6IK+rzTvyBySQ=;
	h=Date:To:From:Subject:Message-Id; b=abTGJFAIPB8Pf7kZIdxG/+1Uk7C+j27dSZarqOjmUObSkd9hga5AlSUyjmJQOSGo5OZX+rC3uL+hPdrcwvgV8iLiH+tau48Fcv+HBVVmHNlq7VZRFNCPM2EWJkPHiWyfU7vu2QF67fQb6Xu5+nBtf3LRHmLwlsPy6V5TfhbI27Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XzfAUcyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XzfAUcyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6F3C4CEF7;
	Sun, 29 Mar 2026 00:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744916;
	bh=wgdGaF4nXz2WGhPqfLv8wES0xkuIEu6IK+rzTvyBySQ=;
	h=Date:To:From:Subject:From;
	b=XzfAUcyIt7pbC6Zvp09fex+SRkFjRinmMOP0k2zIMItYUS4FI9GjAW3IndnCBb5os
	 3ss5/s8c+vtRf8ArBxbW63Joa4kK5eMpwR/dktScGeyJBYul6lYGoaOmhjAqLiLJuF
	 3xPvADga3z90XlR2xmLNhth8Uc3nsU/YT5f/pguw=
Date: Sat, 28 Mar 2026 17:41:56 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,minchan@kernel.org,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-change-scan_slots-to-return-void.patch removed from -mm tree
Message-Id: <20260329004156.9A6F3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: change scan_slots to return void
has been removed from the -mm tree.  Its filename was
     zram-change-scan_slots-to-return-void.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: change scan_slots to return void
Date: Tue, 17 Mar 2026 12:23:19 +0900

scan_slots_for_writeback() and scan_slots_for_recompress() work in a "best
effort" fashion, if they cannot allocate memory for a new pp-slot
candidate they just return and post-processing selects slots that were
successfully scanned thus far.  scan_slots functions never return errors
and their callers never check the return status, so convert them to return
void.

Link: https://lkml.kernel.org/r/20260317032349.753645-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-change-scan_slots-to-return-void
+++ a/drivers/block/zram/zram_drv.c
@@ -1196,9 +1196,9 @@ static int parse_mode(char *val, u32 *mo
 	return 0;
 }
 
-static int scan_slots_for_writeback(struct zram *zram, u32 mode,
-				    unsigned long lo, unsigned long hi,
-				    struct zram_pp_ctl *ctl)
+static void scan_slots_for_writeback(struct zram *zram, u32 mode,
+				     unsigned long lo, unsigned long hi,
+				     struct zram_pp_ctl *ctl)
 {
 	u32 index = lo;
 
@@ -1230,8 +1230,6 @@ next:
 			break;
 		index++;
 	}
-
-	return 0;
 }
 
 static ssize_t writeback_store(struct device *dev,
@@ -2368,8 +2366,8 @@ static bool highest_priority_algorithm(s
 	return true;
 }
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
-				     struct zram_pp_ctl *ctl)
+static void scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio,
+				      struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
 	unsigned long index;
@@ -2404,8 +2402,6 @@ next:
 		if (!ok)
 			break;
 	}
-
-	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


