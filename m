Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836B2217673
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188421; cv=none; b=cSYvpdhtWFdTwNkXvIUM60Wur649TzcV+s6MAicVuATfpQuinEejjkO5kCUv7iD7kAwiw3PRsk5UqfzN/xTbNx49BGh2eyuftaWuDtYksWWjgU7yP1IE6JAOkREwLwZQa7JHXMJpmbJxKJq6BJ6Ii4aqkpk4aN1aTPBSK6TSx6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188421; c=relaxed/simple;
	bh=ZCjja6ogWvpmpP5FUXxP05dLBoXcTgQPmOqntjh+ito=;
	h=Date:To:From:Subject:Message-Id; b=AV4Vjvbwb0J6uqf4Exw41BjOLLwjDzmzVifych29RkIVH9xPLxLSuc5wd7tPywBHuVPzrADYDORwXaXsCLkJ/SawkxxizTHR2E18cFg89tMjvSUakG9AGktjPa6gu8LA7LPrIU+a2Z/CmunJmS5TFPJ+4p/jPUwdMmjfYnJsSMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W9dnJw0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W9dnJw0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588D3C4CEEC;
	Mon, 17 Mar 2025 05:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188421;
	bh=ZCjja6ogWvpmpP5FUXxP05dLBoXcTgQPmOqntjh+ito=;
	h=Date:To:From:Subject:From;
	b=W9dnJw0y1EzHMFbiPm9xZQuNPk9uMY+tgHPIvgGW+iNPedMFyDsEQpbFHiOF4OQzL
	 ELE1avPPgA1y9v3WX66k/pnd/Lcke5valR+1dW7ESYbWFQWTfrJnwv9s56PGqo+Fpt
	 UE9UKWsC9QpVq6Mz/jRWAFTJy5++tjqrC8qzAVk8=
Date: Sun, 16 Mar 2025 22:13:40 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-filter-out-recomp-targets-based-on-priority.patch removed from -mm tree
Message-Id: <20250317051341.588D3C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: filter out recomp targets based on priority
has been removed from the -mm tree.  Its filename was
     zram-filter-out-recomp-targets-based-on-priority.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: filter out recomp targets based on priority
Date: Mon, 3 Mar 2025 11:03:18 +0900

Do no select for post processing slots that are already compressed with
same or higher priority compression algorithm.

This should save some memory, as previously we would still put those
entries into corresponding post-processing buckets and filter them out
later in recompress_slot().

Link: https://lkml.kernel.org/r/20250303022425.285971-10-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-filter-out-recomp-targets-based-on-priority
+++ a/drivers/block/zram/zram_drv.c
@@ -1823,7 +1823,7 @@ static int zram_bvec_write(struct zram *
 #define RECOMPRESS_IDLE		(1 << 0)
 #define RECOMPRESS_HUGE		(1 << 1)
 
-static int scan_slots_for_recompress(struct zram *zram, u32 mode,
+static int scan_slots_for_recompress(struct zram *zram, u32 mode, u32 prio_max,
 				     struct zram_pp_ctl *ctl)
 {
 	unsigned long nr_pages = zram->disksize >> PAGE_SHIFT;
@@ -1855,6 +1855,10 @@ static int scan_slots_for_recompress(str
 		    zram_test_flag(zram, index, ZRAM_INCOMPRESSIBLE))
 			goto next;
 
+		/* Already compressed with same of higher priority */
+		if (zram_get_priority(zram, index) + 1 >= prio_max)
+			goto next;
+
 		pps->index = index;
 		place_pp_slot(zram, ctl, pps);
 		pps = NULL;
@@ -1911,6 +1915,16 @@ static int recompress_slot(struct zram *
 	zram_clear_flag(zram, index, ZRAM_IDLE);
 
 	class_index_old = zs_lookup_class_index(zram->mem_pool, comp_len_old);
+
+	prio = max(prio, zram_get_priority(zram, index) + 1);
+	/*
+	 * Recompression slots scan should not select slots that are
+	 * already compressed with a higher priority algorithm, but
+	 * just in case
+	 */
+	if (prio >= prio_max)
+		return 0;
+
 	/*
 	 * Iterate the secondary comp algorithms list (in order of priority)
 	 * and try to recompress the page.
@@ -1919,13 +1933,6 @@ static int recompress_slot(struct zram *
 		if (!zram->comps[prio])
 			continue;
 
-		/*
-		 * Skip if the object is already re-compressed with a higher
-		 * priority algorithm (or same algorithm).
-		 */
-		if (prio <= zram_get_priority(zram, index))
-			continue;
-
 		num_recomps++;
 		zstrm = zcomp_stream_get(zram->comps[prio]);
 		src = kmap_local_page(page);
@@ -2150,7 +2157,7 @@ static ssize_t recompress_store(struct d
 		goto release_init_lock;
 	}
 
-	scan_slots_for_recompress(zram, mode, ctl);
+	scan_slots_for_recompress(zram, mode, prio_max, ctl);
 
 	ret = len;
 	while ((pps = select_pp_slot(ctl))) {
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


