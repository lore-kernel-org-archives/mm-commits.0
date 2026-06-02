Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FB53C1979
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439189; cv=none; b=FecEEBZfQYnDs6kOaFcMRUQCRaljwv93m5TA0Mzd3ZW7aL6gkkcxMgjfwEm1V1duavjX4k1pYs6oTYJX4QzrSQebTaQffHXBAjXm2CIVF19BmBnPJopMS3+vVbKAXpO7U6QDJKcTEdcYqP9+rWX2RYybFueJATaOVNk5y1ja1WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439189; c=relaxed/simple;
	bh=2ynV3CoQor1QNBQo0dsmusQ5vIxbtCNOYDzrL9tU+pw=;
	h=Date:To:From:Subject:Message-Id; b=nJ2u8eJ+7SJRIBAWNJA2FX3DHYrr0uUDk4JOOIpq/hFWx7dMgtJkUs8lxpVmm0FFhhpBSZ7/kaA1T4BjNT7XHJBOcIXJVO9H4ZRqFBJlU9zukFbxo9KliTtHv2IbBB7pHM9HtzD8mLFUmlMezqWzNjS3UAnvggu7Dzgovj93jio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p40QvZmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p40QvZmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A0F1F00893;
	Tue,  2 Jun 2026 22:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439188;
	bh=p2meY4Pdw+WuDXi4QzOgMcybfnEJwE7zodY/S91wbDc=;
	h=Date:To:From:Subject;
	b=p40QvZmK/cjZogxHZqKLIJbg633zDJ83/4W7aFVAGYsLh1+1DT61Hm9TrxfEh+b6E
	 EwVG4+acelaj6pNqAsTDQIUics8q3oAhZob/2GxussQrMtVZQKr1CZ0Nx6IAbJA7K4
	 zXzfh89u5QdlijFSwO8j5ndeve1mwzK8lZcluW+M=
Date: Tue, 02 Jun 2026 15:26:28 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,vernon2gm@gmail.com,surenb@google.com,stevensd@google.com,shakeel.butt@linux.dev,mhocko@kernel.org,ljs@kernel.org,lenohou@gmail.com,laoar.shao@gmail.com,kaleshsingh@google.com,hannes@cmpxchg.org,david@kernel.org,chrisl@kernel.org,chenridong@huaweicloud.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,axelrasmussen@google.com,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch removed from -mm tree
Message-Id: <20260602222628.91A0F1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: use the common routine for dirty/writeback reactivation
has been removed from the -mm tree.  Its filename was
     mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: use the common routine for dirty/writeback reactivation
Date: Tue, 28 Apr 2026 02:07:01 +0800

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

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-10-02fabb92dc43@tencent.com
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
@@ -4582,7 +4582,6 @@ static bool sort_folio(struct lruvec *lr
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4632,21 +4631,6 @@ static bool sort_folio(struct lruvec *lr
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
 
@@ -4668,9 +4652,6 @@ static bool isolate_folio(struct lruvec
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
-	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
-
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 
_

Patches currently in -mm which might be from kasong@tencent.com are


