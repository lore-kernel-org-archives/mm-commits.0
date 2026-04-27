Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4779C3E8C55
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313505; cv=none; b=r8/giVnpf3ZdfLEFdRBvZnEwvNJVzCGw22lJvNhFLXlSfKEOcgkQ7vrNHkgGZbS94LyO41v0QhiboOGI3JJ1z0UtodVSchR/nc7BY5yuYAaYvtP/OmrQmODkT9/2Q8HmOaAmBDGDJXwc3MpKs5Naipv0lTJaGUcOnlk4y3Tc334=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313505; c=relaxed/simple;
	bh=h2q+5a1buvsJSH/YCEZ+WAV6Nw9D1W7b1w/EDTRj+bU=;
	h=Date:To:From:Subject:Message-Id; b=SQKBAEksAWjp+Q5LVe0M6CZMmphoWDbPrBiGPtkA+biAOrHZ0lZEiiN/yd68DwDCbtkk9oMctp04R5HO1feRrvrI/gB7jpu5hlztp3TgzClUmPHDxk9u+aMSOJT4iL1PlNbWIuVUsinNCDgYtv6VK8bjA5BdBUm+aV5F8cNV620=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S7qS9Ztx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S7qS9Ztx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB46BC19425;
	Mon, 27 Apr 2026 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313504;
	bh=h2q+5a1buvsJSH/YCEZ+WAV6Nw9D1W7b1w/EDTRj+bU=;
	h=Date:To:From:Subject:From;
	b=S7qS9ZtxHYcA61Cx/3Cm7MWteYF3/TBq3fZeTfgedslTcMN8Hs8XMChKqfPb2tRzy
	 LkfVYQSk/+Vny8944HJv/OtXqzY1MU818k91g7T4fbz6S0UkI32G/YXAFQaaca9Lmn
	 HRKNGXVfBhSBvndsGrqjtSvU/S1ydvkjlYFOU0R4=
Date: Mon, 27 Apr 2026 11:11:44 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch removed from -mm tree
Message-Id: <20260427181144.DB46BC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vmscan: unify writeback reclaim statistic and throttling
has been removed from the -mm tree.  Its filename was
     mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/vmscan: unify writeback reclaim statistic and throttling
Date: Fri, 24 Apr 2026 01:43:25 +0800

Currently MGLRU and non-MGLRU handle the reclaim statistic and writeback
handling very differently, especially throttling.  Basically MGLRU just
ignored the throttling part.

Let's just unify this part, use a helper to deduplicate the code so both
setups will share the same behavior.

Test using following reproducer using bash:

  echo "Setup a slow device using dm delay"
  dd if=/dev/zero of=/var/tmp/backing bs=1M count=2048
  LOOP=$(losetup --show -f /var/tmp/backing)
  mkfs.ext4 -q $LOOP
  echo "0 $(blockdev --getsz $LOOP) delay $LOOP 0 0 $LOOP 0 1000" | \
      dmsetup create slow_dev
  mkdir -p /mnt/slow && mount /dev/mapper/slow_dev /mnt/slow

  echo "Start writeback pressure"
  sync && echo 3 > /proc/sys/vm/drop_caches
  mkdir /sys/fs/cgroup/test_wb
  echo 128M > /sys/fs/cgroup/test_wb/memory.max
  (echo $BASHPID > /sys/fs/cgroup/test_wb/cgroup.procs && \
      dd if=/dev/zero of=/mnt/slow/testfile bs=1M count=192)

  echo "Clean up"
  echo "0 $(blockdev --getsz $LOOP) error" | dmsetup load slow_dev
  dmsetup resume slow_dev
  umount -l /mnt/slow && sync
  dmsetup remove slow_dev

Before this commit, `dd` will get OOM killed immediately if MGLRU is
enabled.  Classic LRU is fine.

After this commit, throttling is now effective and no more spin on LRU or
premature OOM.  Stress test on other workloads also looking good.

Global throttling is not here yet, we will fix that separately later.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-14-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Chen Ridong <chenridong@huaweicloud.com>
Tested-by: Leno Hou <lenohou@gmail.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   92 +++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 49 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-unify-writeback-reclaim-statistic-and-throttling
+++ a/mm/vmscan.c
@@ -1942,6 +1942,44 @@ static int current_may_throttle(void)
 	return !(current->flags & PF_LOCAL_THROTTLE);
 }
 
+static void handle_reclaim_writeback(unsigned long nr_taken,
+				     struct pglist_data *pgdat,
+				     struct scan_control *sc,
+				     struct reclaim_stat *stat)
+{
+	/*
+	 * If dirty folios are scanned that are not queued for IO, it
+	 * implies that flushers are not doing their job. This can
+	 * happen when memory pressure pushes dirty folios to the end of
+	 * the LRU before the dirty limits are breached and the dirty
+	 * data has expired. It can also happen when the proportion of
+	 * dirty folios grows not through writes but through memory
+	 * pressure reclaiming all the clean cache. And in some cases,
+	 * the flushers simply cannot keep up with the allocation
+	 * rate. Nudge the flusher threads in case they are asleep.
+	 */
+	if (stat->nr_unqueued_dirty == nr_taken) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
+	sc->nr.dirty += stat->nr_dirty;
+	sc->nr.congested += stat->nr_congested;
+	sc->nr.writeback += stat->nr_writeback;
+	sc->nr.immediate += stat->nr_immediate;
+	sc->nr.taken += nr_taken;
+}
+
 /*
  * shrink_inactive_list() is a helper for shrink_node().  It returns the number
  * of reclaimed pages
@@ -2005,39 +2043,7 @@ static unsigned long shrink_inactive_lis
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
-
-	/*
-	 * If dirty folios are scanned that are not queued for IO, it
-	 * implies that flushers are not doing their job. This can
-	 * happen when memory pressure pushes dirty folios to the end of
-	 * the LRU before the dirty limits are breached and the dirty
-	 * data has expired. It can also happen when the proportion of
-	 * dirty folios grows not through writes but through memory
-	 * pressure reclaiming all the clean cache. And in some cases,
-	 * the flushers simply cannot keep up with the allocation
-	 * rate. Nudge the flusher threads in case they are asleep.
-	 */
-	if (stat.nr_unqueued_dirty == nr_taken) {
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 *
-		 * Flusher may not be able to issue writeback quickly
-		 * enough for cgroupv1 writeback throttling to work
-		 * on a large system.
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
-	sc->nr.dirty += stat.nr_dirty;
-	sc->nr.congested += stat.nr_congested;
-	sc->nr.writeback += stat.nr_writeback;
-	sc->nr.immediate += stat.nr_immediate;
-	sc->nr.taken += nr_taken;
-
+	handle_reclaim_writeback(nr_taken, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			nr_scanned, nr_reclaimed, &stat, sc->priority, file);
 	return nr_reclaimed;
@@ -4824,26 +4830,13 @@ static int evict_folios(unsigned long nr
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	/* Retry pass is only meant for clean folios without new isolation */
+	if (isolated)
+		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (stat.nr_unqueued_dirty == isolated) {
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
-		/*
-		 * For cgroupv1 dirty throttling is achieved by waking up
-		 * the kernel flusher here and later waiting on folios
-		 * which are in writeback to finish (see shrink_folio_list()).
-		 */
-		if (!writeback_throttling_sane(sc))
-			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
-	}
-
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -4886,6 +4879,7 @@ retry:
 
 	if (!list_empty(&list)) {
 		skip_retry = true;
+		isolated = 0;
 		goto retry;
 	}
 
_

Patches currently in -mm which might be from kasong@tencent.com are


