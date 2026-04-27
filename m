Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86F733123F
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314213; cv=none; b=G4lHxUlOMRLbDp1Lg+QyNVaba+s+BNG9T4eCSIyL7OMW00zmVIA6auyh+APTpOsUYjQLYf5fIkIczZlUYpkNgExYEH1g9UGBV7+04kNnq+2etTvwnfWeAcThnFfjcN0ZkoZnpjnx4isXcM2oU9UGaD3syF32EA+FA483MZ5TlxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314213; c=relaxed/simple;
	bh=kTooc3lMNWwJdb178pJ7+pxFqZjx6IxOGdT4J9K/3pg=;
	h=Date:To:From:Subject:Message-Id; b=Yo06l/1PqO0V1+Fl+SzkgKnDLoAsTmek8usFvHJJegQvBzaLl5F8NdPArir7qr1fMSW4A3WLdadnNnCEe6vBqUbLYpL9C3dD8u6WR6HVZg7lhnUaJh2MjBM4MnLGIe5oU4AvWEIh7lvB0Sn3I0NlVnT9mRPXbNCgDUl0JutJJhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q7+wde02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q7+wde02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1735C19425;
	Mon, 27 Apr 2026 18:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777314213;
	bh=kTooc3lMNWwJdb178pJ7+pxFqZjx6IxOGdT4J9K/3pg=;
	h=Date:To:From:Subject:From;
	b=Q7+wde02c9BZqwKLchek8WIXKEMNplzxg6fk/R4OPMCxIGrDoLs7SY1HbdCkf5Mfp
	 26HH1GACePLwk95gyfl0zMUoJORMLBXT9vdCnQ8zCPkclSkUhPwLyp6+ADQnwIFDhO
	 AbdyQEn/ycpbrgbn/zLGZmAsMSH/9vtmtYasA5Yg=
Date: Mon, 27 Apr 2026 11:23:33 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch added to mm-new branch
Message-Id: <20260427182333.A1735C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: remove no longer used reclaim argument for folio protection
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch

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
Subject: mm/mglru: remove no longer used reclaim argument for folio protection
Date: Tue, 28 Apr 2026 02:07:03 +0800

Now dirty reclaim folios are handled after isolation, not before, since
dirty reactivation must take the folio off LRU first, and that helps to
unify the dirty handling logic.

So this argument is no longer needed.  Just remove it.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-12-02fabb92dc43@tencent.com
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

