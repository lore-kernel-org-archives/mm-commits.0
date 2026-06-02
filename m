Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3825A3BE162
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439176; cv=none; b=iDb8nWduwKRgQu3bB2q4NXzYf4mcw5kVug5aXULmXOebYCpbThQ5rtOXh/wrLPCc3Qv6oHlZVAgwdj2AEmztMps9OOnJZs/KeN62QKKRNH/vN6A+usnALItAfg9VWM2xYqHVhopJSYt2MS9IXfOLLD0yxsEJ+l9C0muIEeAQE40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439176; c=relaxed/simple;
	bh=fcqb6NBgmsKTFon/R70MUC3OIsS+50jISYjpBuX3FwI=;
	h=Date:To:From:Subject:Message-Id; b=HSN90JJX+B6ZhgkPVLAlY7kob1L0i1/sPXjB2id/RGA/WIIkEOp05vVMTtKcUyWV3V2FgpUrvqH4Y2Oqiox9HmeH1IEEdbdKRudQTsT+vXrvyh0eRJ/6I5fraZfQaFiUNB0lH71PF+hSCORakM7Zpz/h2RSrneHd88EICbIZ2R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yaPeJe6j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yaPeJe6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AA01F00899;
	Tue,  2 Jun 2026 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439175;
	bh=MZcHtsVMcdmAvEJmv6Uo5UdPgyn6kqa4SSI4vrSmFQ8=;
	h=Date:To:From:Subject;
	b=yaPeJe6jr2CX3UAn39Bx0sJ1W3g59jVeJiFkSW7RWZAWM9eqTZU8UksLcBkYwY8eB
	 ls5+q8c1y22RDapqZNFUVh0+Hd7BxV2w6OdxPN6NAATDK7ZxJFL3Jp4tlDFIULFZwI
	 /16H+k+XNulX57NS4s4c3XUuf9ro7ITW8tEHB1GY=
Date: Tue, 02 Jun 2026 15:26:14 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-rename-variables-related-to-aging-and-rotation.patch removed from -mm tree
Message-Id: <20260602222615.14AA01F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: rename variables related to aging and rotation
has been removed from the -mm tree.  Its filename was
     mm-mglru-rename-variables-related-to-aging-and-rotation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: rename variables related to aging and rotation
Date: Tue, 28 Apr 2026 02:06:53 +0800

The current variable name isn't helpful.  Make the variable names more
meaningful.

Only naming change, no behavior change.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-2-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Suggested-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-rename-variables-related-to-aging-and-rotation
+++ a/mm/vmscan.c
@@ -4938,7 +4938,7 @@ static bool should_run_aging(struct lruv
  */
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc, int swappiness)
 {
-	bool success;
+	bool need_aging;
 	unsigned long nr_to_scan;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MAX_SEQ(lruvec);
@@ -4946,7 +4946,7 @@ static long get_nr_to_scan(struct lruvec
 	if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
 		return -1;
 
-	success = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
+	need_aging = should_run_aging(lruvec, max_seq, swappiness, &nr_to_scan);
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (nr_to_scan && !mem_cgroup_online(memcg))
@@ -4955,7 +4955,7 @@ static long get_nr_to_scan(struct lruvec
 	nr_to_scan = apply_proportional_protection(memcg, sc, nr_to_scan);
 
 	/* try to get away with not aging at the default priority */
-	if (!success || sc->priority == DEF_PRIORITY)
+	if (!need_aging || sc->priority == DEF_PRIORITY)
 		return nr_to_scan >> sc->priority;
 
 	/* stop scanning this lruvec as it's low on cold folios */
@@ -5044,7 +5044,7 @@ static bool try_to_shrink_lruvec(struct
 
 static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 {
-	bool success;
+	bool need_rotate;
 	unsigned long scanned = sc->nr_scanned;
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
@@ -5062,7 +5062,7 @@ static int shrink_one(struct lruvec *lru
 		memcg_memory_event(memcg, MEMCG_LOW);
 	}
 
-	success = try_to_shrink_lruvec(lruvec, sc);
+	need_rotate = try_to_shrink_lruvec(lruvec, sc);
 
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
@@ -5072,10 +5072,10 @@ static int shrink_one(struct lruvec *lru
 
 	flush_reclaim_state(sc);
 
-	if (success && mem_cgroup_online(memcg))
+	if (need_rotate && mem_cgroup_online(memcg))
 		return MEMCG_LRU_YOUNG;
 
-	if (!success && lruvec_is_sizable(lruvec, sc))
+	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
 		return 0;
 
 	/* one retry if offlined or too small */
_

Patches currently in -mm which might be from kasong@tencent.com are


