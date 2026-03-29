Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A491A6835
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744856; cv=none; b=Dw0lO/t9RCdsdgCr0NaSB7g2caNDDZ/bqwypfWbGKp8f99g+2cqMw7DJRZjiMZ9NvDEI/7l/yzyilW0OFntcrVngcCkGNlNdn3Ak5RkmQTbvkLtHpOylnYxU76w/7z+W9z+SGQCSGbHfMQr7aeeTSwXEtnXTTHJptEKMEUkW160=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744856; c=relaxed/simple;
	bh=ecTd5RSGGo3q5TNmmgXasEFrTg/+K8xo36et5927OVg=;
	h=Date:To:From:Subject:Message-Id; b=BNdh5YvXwH470quj8RTpk0CTX5BjimeV6d0RzupETZlh+pKUG8Vma1sf/4HFz8j5p8N1dVR/0zL4SGhePc63Tj9ZKHx/Z9EkCAWsDRutvJqWb7UwXLM/V8F2rMmb/qJHZLBNqLQX3dBVogwR5xV/4Q+ZiiJUR2P3Dsw3BP20BiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Xv3epUFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Xv3epUFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD652C4CEF7;
	Sun, 29 Mar 2026 00:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744856;
	bh=ecTd5RSGGo3q5TNmmgXasEFrTg/+K8xo36et5927OVg=;
	h=Date:To:From:Subject:From;
	b=Xv3epUFI1nY2IKZbjs20Adf2CBtYegFYpSE9T7BdRYJw8+7JWMOrNsZjBAeEv32NV
	 c/O/EaySJNW/aB9tDsSLw/r+KIGu0WVY7giboDHJfV+r4XcWQ6P5CiiFzZnYuE3SSl
	 KjjtSlEvBdVmeapSdvalUEOrQpm1tE/86lQcrtwU=
Date: Sat, 28 Mar 2026 17:40:55 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,gaoxu2@honor.com,bgeffon@google.com,axboe@kernel.dk,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-drop-num_active_comps.patch removed from -mm tree
Message-Id: <20260329004055.DD652C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: drop ->num_active_comps
has been removed from the -mm tree.  Its filename was
     zram-drop-num_active_comps.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: drop ->num_active_comps
Date: Wed, 11 Mar 2026 17:42:46 +0900

It's not entirely correct to use ->num_active_comps for max-prio limit, as
->num_active_comps just tells the number of configured algorithms, not the
max configured priority.  For instance, in the following theoretical
example:

    [lz4] [nil] [nil] [deflate]

->num_active_comps is 2, while the actual max-prio is 3.

Drop ->num_active_comps and use ZRAM_MAX_COMPS instead.

Link: https://lkml.kernel.org/r/20260311084312.1766036-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: gao xu <gaoxu2@honor.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   29 ++++++++++++++++-------------
 drivers/block/zram/zram_drv.h |    1 -
 2 files changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-drop-num_active_comps
+++ a/drivers/block/zram/zram_drv.c
@@ -2324,6 +2324,18 @@ static int zram_bvec_write(struct zram *
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
+static bool highest_priority_algorithm(struct zram *zram, u32 prio)
+{
+	u32 p;
+
+	for (p = prio + 1; p < ZRAM_MAX_COMPS; p++) {
+		if (zram->comp_algs[p])
+			return false;
+	}
+
+	return true;
+}
+
 static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 				     struct zram_pp_ctl *ctl)
 {
@@ -2471,12 +2483,11 @@ static int recompress_slot(struct zram *
 		 * Secondary algorithms failed to re-compress the page
 		 * in a way that would save memory.
 		 *
-		 * Mark the object incompressible if the max-priority
-		 * algorithm couldn't re-compress it.
+		 * Mark the object incompressible if the max-priority (the
+		 * last configured one) algorithm couldn't re-compress it.
 		 */
-		if (prio < zram->num_active_comps)
-			return 0;
-		set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
+		if (highest_priority_algorithm(zram, prio))
+			set_slot_flag(zram, index, ZRAM_INCOMPRESSIBLE);
 		return 0;
 	}
 
@@ -2608,12 +2619,6 @@ static ssize_t recompress_store(struct d
 		}
 	}
 
-	prio_max = min(prio_max, (u32)zram->num_active_comps);
-	if (prio >= prio_max) {
-		ret = -EINVAL;
-		goto out;
-	}
-
 	if (prio < ZRAM_SECONDARY_COMP || prio >= ZRAM_MAX_COMPS) {
 		ret = -EINVAL;
 		goto out;
@@ -2826,7 +2831,6 @@ static void zram_destroy_comps(struct zr
 		if (!comp)
 			continue;
 		zcomp_destroy(comp);
-		zram->num_active_comps--;
 	}
 
 	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++)
@@ -2891,7 +2895,6 @@ static ssize_t disksize_store(struct dev
 		}
 
 		zram->comps[prio] = comp;
-		zram->num_active_comps++;
 	}
 	zram->disksize = disksize;
 	set_capacity_and_notify(zram->disk, zram->disksize >> SECTOR_SHIFT);
--- a/drivers/block/zram/zram_drv.h~zram-drop-num_active_comps
+++ a/drivers/block/zram/zram_drv.h
@@ -125,7 +125,6 @@ struct zram {
 	 */
 	u64 disksize;	/* bytes */
 	const char *comp_algs[ZRAM_MAX_COMPS];
-	s8 num_active_comps;
 	/*
 	 * zram is claimed so open request will be failed
 	 */
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


