Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E743C4167
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439186; cv=none; b=ByACAfBL3g8GgsE6Z8k0gYLdbplnE4OAeU6TY3yQEAFWNSdzlU7Vvjmyb7WHaDhJF0ZQ2ZZ1VsENltbI1fvzyhvLdPkT1kUvSe3q10Kv4vNemATYXBrIkN+4nCmgkMqXa1JLp8CRahMI89c4RGrU4KgmcFKq/Agpd71jKn9jUxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439186; c=relaxed/simple;
	bh=hxMP9DlS7V02Vz48o428UF5opTNtdLIfhbQcJx+bT/s=;
	h=Date:To:From:Subject:Message-Id; b=T7vwZP9aQsBha+cbV344DCmsgt91L1mOWO/gDwJvDjO/jo8yU1ThEEBY3t1Ewkp/h9UoVv9X+HiDVKg+bqZKk7T1wFJqs2j7RWFnDvOJQzyFXpNjHqDSLpfkddD7iegE3BKMALFre336Wlsh/xRRAwHKrHACejWeG0L4/YhFQvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HgxepT5G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HgxepT5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21D4A1F00893;
	Tue,  2 Jun 2026 22:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439185;
	bh=9m0obGOPOTOWEN0MFq3trtYHdrw6sjM+nj7oxvIgT+U=;
	h=Date:To:From:Subject;
	b=HgxepT5GrmruB/M2aHkSs5h0eJptylEW/I7iNBJORWvZDSy30nX3J4ydhVtB4EoK/
	 keMWJCJdGi8tjmtvDkA9jvvryDIPZzZ60PlvQG9ndJPekbYrMU11g7NIFMXZJCgTNT
	 x2bpMRx0xgEVM58lxEO8PJNNZR8f6IkW+p9N8LDs=
Date: Tue, 02 Jun 2026 15:26:24 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-dont-abort-scan-immediately-right-after-aging.patch removed from -mm tree
Message-Id: <20260602222625.21D4A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: don't abort scan immediately right after aging
has been removed from the -mm tree.  Its filename was
     mm-mglru-dont-abort-scan-immediately-right-after-aging.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: don't abort scan immediately right after aging
Date: Tue, 28 Apr 2026 02:06:59 +0800

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

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-8-02fabb92dc43@tencent.com
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
@@ -4989,7 +4989,7 @@ static bool should_abort_scan(struct lru
  */
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool need_rotate = false;
+	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5007,8 +5007,7 @@ static bool try_to_shrink_lruvec(struct
 		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
-			/* stop scanning as it's low on cold folios */
-			break;
+			should_age = true;
 		}
 
 		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
@@ -5019,6 +5018,13 @@ static bool try_to_shrink_lruvec(struct
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


