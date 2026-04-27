Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D213E8C61
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313498; cv=none; b=sD3rON87BuWpwociVQDqyf3d9Sghq8WYDFTMF0IAZ3rZDzon8249ydFTH0+VHPe200gcrFdh6AzplLIO+GJuc1BV8v6D9N6upHZEeqYTPhZA/raJ4jY39Yf4cgudWN3yykQPHlvUO9KApsgsZwthWFUShkrzSqs2PazJ0jpa8jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313498; c=relaxed/simple;
	bh=nO6DNOI8CXh05pCZFUDIMDx5+a9TYD2o5z536AiBz1Q=;
	h=Date:To:From:Subject:Message-Id; b=PF0RT5jYtUAqTgGygmhHEaKV6CDY9Lp2j6HF7h46Bie54eNpqORUZoz3IV0Yj5j9A2BhObzs3NKv6t7lGclu29unTdCdmGHM+hRQb4feSppyp82C3TDRdroTzzj1glKCq5WNJTgbbg/eEmtaOzYLuFB9okfiY5BvXhAK+BFNEdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g5PJL2/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g5PJL2/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3BAC2BCB4;
	Mon, 27 Apr 2026 18:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313497;
	bh=nO6DNOI8CXh05pCZFUDIMDx5+a9TYD2o5z536AiBz1Q=;
	h=Date:To:From:Subject:From;
	b=g5PJL2/ZAlF/+PbXZkStJ2X1PS5MVDCSff8YINvmQlCuCM1qGpwUyRxn7MCnK4vF0
	 ViuEBOQfvYvVB5yzWiXDrznlb93/0AQdgGkWTNkLqBSgLztYUxPjWKLO1A3XRhwURZ
	 +nGxERKls5ZW/B0qb2WqO8cnArv2nPOXybrkP5Gk=
Date: Mon, 27 Apr 2026 11:11:37 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch removed from -mm tree
Message-Id: <20260427181137.BE3BAC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: use the common routine for dirty/writeback reactivation
has been removed from the -mm tree.  Its filename was
     mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: use the common routine for dirty/writeback reactivation
Date: Fri, 24 Apr 2026 01:43:20 +0800

Currently MGLRU will move the dirty writeback folios to the second oldest
gen instead of reactivate them like the classical LRU.  This might help to
reduce the LRU contention as it skipped the isolation.  But as a result we
will see these folios at the LRU tail more frequently leading to
inefficient reclaim.

Besides, the dirty / writeback check after isolation in shrink_folio_list
is more accurate and covers more cases.  So instead, just drop the special
handling for dirty writeback, use the common routine and re-activate it
like the classical LRU.

This should in theory improve the scan efficiency.  These folios will be
rotated back to LRU tail once writeback is done so there is no risk of
hotness inversion.  And now each reclaim loop will have a higher success
rate.  This also prepares for unifying the writeback and throttling
mechanism with classical LRU, we keep these folios far from tail so
detecting the tail batch will have a similar pattern with classical LRU.

The micro optimization that avoids LRU contention by skipping the
isolation is gone, which should be fine.  Compared to IO and writeback
cost, the isolation overhead is trivial.

And using the common routine also keeps the folio's referenced bits (tier
bits), which could improve metrics in the long term.  Also no more need to
clean reclaim bit as the common routine will make use of it.

Note the common routine updates a few throttling and writeback counters,
which are not used, and never have been for the MGLRU case.  We will start
making use of these in later commits.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-9-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/vmscan.c |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/mm/vmscan.c~mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation
+++ a/mm/vmscan.c
@@ -4578,7 +4578,6 @@ static bool sort_folio(struct lruvec *lr
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4628,21 +4627,6 @@ static bool sort_folio(struct lruvec *lr
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (writeback || (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4664,9 +4648,6 @@ static bool isolate_folio(struct lruvec
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
-	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
-
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

