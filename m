Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F6B3ACF04
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313495; cv=none; b=s96ZKSKNJL7wHJOWG94ZdDsDmr8zmzkcGN8mWPG3s324VKvS5XiFPOqEao8f25i1fsq8RyI46bMxMmhoVQFEHg+B48yy8kvxHEde04yHn2/EGwn98arTnbzz+G4CPLXTgNq176aL9ObvJD2QWca8NzrBSlUNgN4tcKYCbPqPcR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313495; c=relaxed/simple;
	bh=r1FNWOdHpBVTz0eIz1rzKgBKiQZWn7X5IF6desf6ok4=;
	h=Date:To:From:Subject:Message-Id; b=EDXEwd4a72m1M/dHGlgnWuyBAg85HPFHPlTQ9eq7bRSXPLlQ9UJmq0CrQ0MV0CvWN30UxwKacUvpxPmlfyqURWddTvYS2xt3+IMolsAuqwre6Khfs8CxtU/KJuWuDktakrSdP+nZktjwQhT/JqZ13m1ELHMAod9m0oS5IXn4pFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Z9XA8uyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Z9XA8uyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D867FC19425;
	Mon, 27 Apr 2026 18:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313494;
	bh=r1FNWOdHpBVTz0eIz1rzKgBKiQZWn7X5IF6desf6ok4=;
	h=Date:To:From:Subject:From;
	b=Z9XA8uyDj/zHpySjLvTTjGBCW1SeZYVfNdcmQM5ylxP/9pqacr1VOq2a8K0TXXaR1
	 i/stY440iAeobUiQuau8xvB/nT4Je23xtk8ApJbzsLN29uoD48aIxww13pXnqj/Q8m
	 lIzFAiXIP+tNPKRSImGPyI6CNoe6mD9vRlKMNGLE=
Date: Mon, 27 Apr 2026 11:11:34 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-dont-abort-scan-immediately-right-after-aging.patch removed from -mm tree
Message-Id: <20260427181134.D867FC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: don't abort scan immediately right after aging
has been removed from the -mm tree.  Its filename was
     mm-mglru-dont-abort-scan-immediately-right-after-aging.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: don't abort scan immediately right after aging
Date: Fri, 24 Apr 2026 01:43:18 +0800

Right now, if eviction triggers aging, the reclaimer will abort.  This is
not the optimal strategy for several reasons.

Aborting the reclaim early wastes a reclaim cycle when under pressure, and
for concurrent reclaim, if the LRU is under aging, all concurrent
reclaimers might fail.  And if the age has just finished, new cold folios
exposed by the aging are not reclaimed until the next reclaim iteration.

What's more, the current aging trigger is quite lenient, having 3 gens
with a reclaim priority lower than default will trigger aging, and blocks
reclaiming from one memcg.  This wastes reclaim retry cycles easily.  And
in the worst case, if the reclaim is making slower progress and all
following attempts fail due to being blocked by aging, it triggers
unexpected early OOM.

And if a lruvec requires aging, it doesn't mean it's hot.  Instead, the
lruvec could be idle for quite a while, and hence it might contain lots of
cold folios to be reclaimed.

While it's helpful to rotate memcg LRU after aging for global reclaim, as
global reclaim fairness is coupled with the rotation in shrink_many, memcg
fairness is instead handled by cgroup iteration in shrink_node_memcgs. 
So, for memcg level pressure, this abort is not the key part for keeping
the fairness.  And in most cases, there is no need to age, and fairness
must be achieved by upper-level reclaim control.

So instead, just keep the scanning going unless one whole batch of folios
failed to be isolated or enough folios have been scanned, which is
triggered by evict_folios returning 0.  And only abort for global reclaim
after one batch, so when there are fewer memcgs, progress is still made,
and the fairness mechanism described above still works fine.

And in most cases, the one more batch attempt for global reclaim might
just be enough to satisfy what the reclaimer needs, hence improving global
reclaim performance by reducing reclaim retry cycles.

Rotation is still there after the reclaim is done, which still follows the
comment in mmzone.h.  And fairness still looking good.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-7-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/vmscan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-mglru-dont-abort-scan-immediately-right-after-aging
+++ a/mm/vmscan.c
@@ -4984,7 +4984,7 @@ static bool should_abort_scan(struct lru
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5002,8 +5002,7 @@ static bool try_to_shrink_lruvec(struct
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			/* stop scanning as it's low on cold folios */
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5014,6 +5013,13 @@ static bool try_to_shrink_lruvec(struct
 		if (should_abort_scan(lruvec, sc))
 			break;
 
+		/*
+		 * Root reclaim needs rotation when low on cold folio for better
+		 * fairness. Cgroup reclaim gets fairness from the iterator.
+		 */
+		if (root_reclaim(sc) && should_age)
+			break;
+
 		nr_to_scan -= delta;
 		cond_resched();
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

