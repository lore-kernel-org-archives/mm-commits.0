Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DFC3AA514
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 18:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776968081; cv=none; b=m7stSf+JlZGzFUG+P+QqtHKN0gKMrNZqSpjjjyQy7NcdPOr+hDfk8Bka2ByR0AHDA2NB10+rOxeARiPUZGwln4EJQBoFhu1zZ5uN5VGzcNKLGw4V9FLMHIhgA9u+Aigwx1v+7y7+3c+KLYkppdAF/hMczgn9Zuwzfn9mVofyrPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776968081; c=relaxed/simple;
	bh=Cfn0JIIdl81bAxL3gtRHKd9AN2Bye8lrJzRMQv9yYbg=;
	h=Date:To:From:Subject:Message-Id; b=XLftFBPFbOSoj0UUroPTA3X4nrifB2STyx6kDrsi8K1iPL0iTNUNOEHuBvdJXf6mOIU5eRs/T5Iy/7FvQG+Vtsj1z3oiit+em/oXAikYBCm8WhpzORpBEw3nA4JSIP3ip9T8FLMdl24qt+oDHnmvfdY1A4+iha8WZNpL3QiXVEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MB+9PF3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MB+9PF3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2918C2BCAF;
	Thu, 23 Apr 2026 18:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776968080;
	bh=Cfn0JIIdl81bAxL3gtRHKd9AN2Bye8lrJzRMQv9yYbg=;
	h=Date:To:From:Subject:From;
	b=MB+9PF3N6OktaHfzg8GRMvw4JFqRlMJBbMaI3s4SBY8za2wtehQd7XyZkFr1GXM3J
	 Rn9XvimlGaTA1pY1Q7MjC53+xCIZo8S+q5uYSpWj1IS8EX1xhfWu+qoMqFtZI8AxQY
	 YkHJry3O8TwMKpLBVhgJsDFjtE/wddF1Z2FSk7qU=
Date: Thu, 23 Apr 2026 11:14:40 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-simplify-and-improve-dirty-writeback-handling.patch added to mm-new branch
Message-Id: <20260423181440.A2918C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: simplify and improve dirty writeback handling
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-simplify-and-improve-dirty-writeback-handling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-simplify-and-improve-dirty-writeback-handling.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: simplify and improve dirty writeback handling
Date: Fri, 24 Apr 2026 01:43:21 +0800

Right now the flusher wakeup mechanism for MGLRU is less responsive and
unlikely to trigger compared to classical LRU.  The classical LRU wakes
the flusher if one batch of folios passed to shrink_folio_list is
unevictable due to under writeback.  MGLRU instead check and handle this
after the whole reclaim loop is done.

We previously even saw OOM problems due to passive flusher, which were
fixed but still not perfect [1].

We have just unified the dirty folio counting and activation routine, now
just move the dirty flush into the loop right after shrink_folio_list. 
This improves the performance a lot for workloads involving heavy
writeback and prepares for throttling too.

Test with YCSB workloadb showed a major performance improvement:

Before this series:
Throughput(ops/sec): 62485.02962831822
AverageLatency(us): 500.9746963330107
pgpgin 159347462
workingset_refault_file 34522071

After this commit:
Throughput(ops/sec): 80857.08510208207
AverageLatency(us): 386.653262968934
pgpgin 112233121
workingset_refault_file 19516246

The performance is a lot better with significantly lower refault.  We also
observed similar or higher performance gain for other real-world
workloads.

We were concerned that the dirty flush could cause more wear for SSD: that
should not be the problem here, since the wakeup condition is when the
dirty folios have been pushed to the tail of LRU, which indicates that
memory pressure is so high that writeback is blocking the workload
already.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-10-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Link: https://lore.kernel.org/linux-mm/20241026115714.1437435-1-jingxiangzeng.cas@gmail.com/ [1]
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Ridong <chenridong@huaweicloud.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
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

 mm/vmscan.c |   41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

--- a/mm/vmscan.c~mm-mglru-simplify-and-improve-dirty-writeback-handling
+++ a/mm/vmscan.c
@@ -4724,8 +4724,6 @@ static int scan_folios(unsigned long nr_
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
-	if (type == LRU_GEN_FILE)
-		sc->nr.file_taken += isolated;
 
 	*isolatedp = isolated;
 	return scanned;
@@ -4833,12 +4831,27 @@ static int evict_folios(unsigned long nr
 		return scanned;
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
-	sc->nr.unqueued_dirty += stat.nr_unqueued_dirty;
 	sc->nr_reclaimed += reclaimed;
 	trace_mm_vmscan_lru_shrink_inactive(pgdat->node_id,
 			type_scanned, reclaimed, &stat, sc->priority,
 			type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 
+	/*
+	 * If too many file cache in the coldest generation can't be evicted
+	 * due to being dirty, wake up the flusher.
+	 */
+	if (stat.nr_unqueued_dirty == isolated) {
+		wakeup_flusher_threads(WB_REASON_VMSCAN);
+
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
 	list_for_each_entry_safe_reverse(folio, next, &list, lru) {
 		DEFINE_MIN_SEQ(lruvec);
 
@@ -4999,28 +5012,6 @@ static bool try_to_shrink_lruvec(struct
 		cond_resched();
 	}
 
-	/*
-	 * If too many file cache in the coldest generation can't be evicted
-	 * due to being dirty, wake up the flusher.
-	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
-		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
-
-		wakeup_flusher_threads(WB_REASON_VMSCAN);
-
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
 	return need_rotate;
 }
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

