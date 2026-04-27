Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92B93DD50D
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777313500; cv=none; b=KCjLPfPMAkSFoT+vRPQD5/nO0nGbNCb7WP/8cJzAi0NlUzV0H2C+po0ADnrnS2WP+hgTK72fHMnY9huLioIX5ANnY7iC2t7uior3Ubc0JnTPW/Qtu8b8lDn6Q/ZspLh+HrhKFy42uJWcPelBOPFv2RQf+6edsn95Ud3HySmqckU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777313500; c=relaxed/simple;
	bh=svCHr4MnRWSeq63S8mVfB7fkTP/uzyEG0mCMBHzo7oU=;
	h=Date:To:From:Subject:Message-Id; b=b7w5pw27Dg/Ucj7eE5n2EssAgaOu2L+ANFproNnmvbWUgFMv1NFMEgGeleE0okj0R5r0q//P1y/dgLFCijmx/fcbMGhB3acbTgNvEvEDhRhwATrkm7uZwI2OX4PX7z6ntwgvpl+Etva5uGgA0iWnNB5gOLiTvsRsWC+GkId4ems=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qxv4xRLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qxv4xRLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A762DC19425;
	Mon, 27 Apr 2026 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777313500;
	bh=svCHr4MnRWSeq63S8mVfB7fkTP/uzyEG0mCMBHzo7oU=;
	h=Date:To:From:Subject:From;
	b=qxv4xRLy06t8WFtQQ3ec14FBNV/k8X9qsTM6+6O157J9J8Jl3gShj9vrnxKdtfOxE
	 5nOKL9Q2Ocx08FzPQ3jC8irHc9zC/GFk5Bcz9yutB5ZlwdzvwGszkRIw4U3qbagbCS
	 WKrbZvVCKtc6omdzxrcHKQiYkqC7JPRpWsY324wU=
Date: Mon, 27 Apr 2026 11:11:40 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch removed from -mm tree
Message-Id: <20260427181140.A762DC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: remove no longer used reclaim argument for folio protection
has been removed from the -mm tree.  Its filename was
     mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: remove no longer used reclaim argument for folio protection
Date: Fri, 24 Apr 2026 01:43:22 +0800

Now dirty reclaim folios are handled after isolation, not before, since
dirty reactivation must take the folio off LRU first, and that helps to
unify the dirty handling logic.

So this argument is no longer needed.  Just remove it.

Link: https://lore.kernel.org/20260424-mglru-reclaim-v6-11-a57622d770c3@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 mm/vmscan.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/mm/vmscan.c~mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection
+++ a/mm/vmscan.c
@@ -3220,7 +3220,7 @@ static int folio_update_gen(struct folio
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3239,9 +3239,6 @@ static int folio_inc_gen(struct lruvec *
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-		/* for folio_end_writeback() */
-		if (reclaiming)
-			new_flags |= BIT(PG_reclaim);
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
@@ -3855,7 +3852,7 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio, false);
+			new_gen = folio_inc_gen(lruvec, folio);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 
 			/* don't count the workingset being lazily promoted */
@@ -4607,7 +4604,7 @@ static bool sort_folio(struct lruvec *lr
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4622,7 +4619,7 @@ static bool sort_folio(struct lruvec *lr
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

