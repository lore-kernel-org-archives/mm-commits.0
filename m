Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FFB3BFE31
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439178; cv=none; b=K+7N8s4ndyENpxLNMXZp9s659+Sa0DQBqAJuznlSaDz27YX7Aa50er0LswNB6el18ryfrNzoTQLMgnhKgG0+MQP5vynAFdcEQlDKcSErQxxyFj36AFP+LgWxc05D65+W+Wt/Js7Tx5AWLjBpKR05e/8OqVPL/hMjdBEcbLJ9K0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439178; c=relaxed/simple;
	bh=OYxDaF+BsX1kYInWnd3P1eOiL1SbZH+4BDXUWq5a1Wo=;
	h=Date:To:From:Subject:Message-Id; b=aaPxfPab+amSzmZkDlDNGMA3HnaQne2r7jPgZnFY+8zBAIcl88w5oa2l74zHNUXoc9vyJTKbGnl6lyr6Q6U88zhbTlj+KcboZYbuvSSQm7trSWuVm7ozgWVLTyBCjP1UwxrqodNgN6smLHoUbgfl0CYoufDGbq7+pdvw65q1U2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dFulH/3G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dFulH/3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCE61F00893;
	Tue,  2 Jun 2026 22:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439176;
	bh=q8N84x3v+0g3KKPHWJ++RDma4EUA8RS/DyNdhItem+U=;
	h=Date:To:From:Subject;
	b=dFulH/3GU//1Q4qHMG9+FiLg40lVsG/Fa3viiJGUStLH+iy3JPI8+6WpXZsl0kSUy
	 ZBQ116jvPajbrFLZReCtBJWQ4y/Ei7D62j8voeVP1NjKaFsfrLuJZSPZ49f/kwea3H
	 ZsqMynxh+PxIDmdNAvCaxD/xSl8Yxw0M+zCeaH9w=
Date: Tue, 02 Jun 2026 15:26:16 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch removed from -mm tree
Message-Id: <20260602222616.BFCE61F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: relocate the LRU scan batch limit to callers
has been removed from the -mm tree.  Its filename was
     mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: relocate the LRU scan batch limit to callers
Date: Tue, 28 Apr 2026 02:06:54 +0800

Same as active / inactive LRU, MGLRU isolates and scans folios in batches.
The batch split is done hidden deep in the helper, which makes the code
harder to follow.  The helper's arguments are also confusing since callers
usually request more folios than the batch size, so the helper almost
never processes the full requested amount.

Move the batch splitting into the top loop to make it cleaner, there
should be no behavior change.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-3-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
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

 mm/vmscan.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-relocate-the-lru-scan-batch-limit-to-callers
+++ a/mm/vmscan.c
@@ -4699,10 +4699,10 @@ static int scan_folios(unsigned long nr_
 	int scanned = 0;
 	int isolated = 0;
 	int skipped = 0;
-	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
-	int remaining = scan_batch;
+	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
+	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
 
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
@@ -4755,7 +4755,7 @@ static int scan_folios(unsigned long nr_
 	mod_lruvec_state(lruvec, item, isolated);
 	mod_lruvec_state(lruvec, PGREFILL, sorted);
 	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
-	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
+	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
 	if (type == LRU_GEN_FILE)
@@ -4991,7 +4991,7 @@ static bool should_abort_scan(struct lru
 
 static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
-	long nr_to_scan;
+	long nr_batch, nr_to_scan;
 	unsigned long scanned = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 
@@ -5002,7 +5002,8 @@ static bool try_to_shrink_lruvec(struct
 		if (nr_to_scan <= 0)
 			break;
 
-		delta = evict_folios(nr_to_scan, lruvec, sc, swappiness);
+		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;
 
@@ -5627,6 +5628,7 @@ static int run_aging(struct lruvec *lruv
 static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_control *sc,
 			int swappiness, unsigned long nr_to_reclaim)
 {
+	int nr_batch;
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (seq + MIN_NR_GENS > max_seq)
@@ -5643,8 +5645,8 @@ static int run_eviction(struct lruvec *l
 		if (sc->nr_reclaimed >= nr_to_reclaim)
 			return 0;
 
-		if (!evict_folios(nr_to_reclaim - sc->nr_reclaimed, lruvec, sc,
-				  swappiness))
+		nr_batch = min(nr_to_reclaim - sc->nr_reclaimed, MAX_LRU_BATCH);
+		if (!evict_folios(nr_batch, lruvec, sc, swappiness))
 			return 0;
 
 		cond_resched();
_

Patches currently in -mm which might be from kasong@tencent.com are


