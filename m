Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E213264FF
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334372; cv=none; b=M0qSH+DqezwFp9HKmElfSTUn2y6BzQgjUhfj+Scl7bkKrzotf4am+YaqgpvHAxeICP2aNuy+NtVcKZdrNnCO4gjP3yvW6/zKxjUIAnwfc1IcTNjJfpOUc3sKU7hY55pGQRI93K2+XkjPBbV+AG7dVw8kLdr7q53xgFb0emcyNYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334372; c=relaxed/simple;
	bh=jTXmlBmqDbrq4IAS0BYrkfFOXiFkY6R6h3WNv0U8C6w=;
	h=Date:To:From:Subject:Message-Id; b=rxZZ1YnlZ+d2xdReRaPyVRvfU084B02gaqnD+gfCfcIFoOJOiAZb7DsZYcvbye9j+H7ufZxmeMbmhumzj8yc24VW24rVwNejFNMnUyem9dqNryuD+txv5bGnvBFGiehB6KAiL+WuzVkLhf+Htq0RkWmy3RIs4xOqE87XSX4KOTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v1E4Vmw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v1E4Vmw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2EA1F0089B;
	Wed,  7 Oct 2026 00:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334370;
	bh=LoBHlTJY0GYmz3p9tEaMspDjA2mNS3nJqakJ1wYYGUw=;
	h=Date:To:From:Subject;
	b=v1E4Vmw5zDoSuDpA22KSr+2PldMxrn0NdhnE5ZVvop3JXhOF6saP8mqQ7gJ6hPxio
	 Wk1A4uFovuRG8R43BkyHJllv9Idih0nGmXw4sWRrTF+2hKS4P8PRTfH3Ta7yRp4+A9
	 Pi91Ngw9JgmjUDaUPDi7z7MXtrKBKH0IEibL3JyE=
Date: Tue, 06 Oct 2026 17:52:50 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch removed from -mm tree
Message-Id: <20261007005250.CD2EA1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
has been removed from the -mm tree.  Its filename was
     mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
Date: Wed, 2 Sep 2026 07:24:17 +0800

During aging, a folio's generation may already have been updated by
folio_update_gen(), even though it has not yet been moved to the
corresponding generation list.  Such folios are hotter than those already
in that generation.

It makes sense for inc_min_seq() to increment the generation of folios
that were never promoted during aging and move them to the tail of the new
oldest generation.  However, folios that were already promoted should
instead be moved to the head of their updated generation, just as
sort_folio() does in scan_folios().

Otherwise, promoted folios could end up behind folios that were never
promoted, effectively inverting their hot/cold ordering.

Link: https://lore.kernel.org/20260901232421.40157-4-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/vmscan.c~mm-mglru-enhance-cold-hot-inversion-handling-in-inc_min_seq
+++ a/mm/vmscan.c
@@ -3954,9 +3954,17 @@ static bool inc_min_seq(struct lruvec *l
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
-			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-			if (gen_increased)
+			/*
+			 * If gen_increased is false, this is a promotion. Put folios
+			 * at the head of the promoted gen. Otherwise, put them at
+			 * the tail of the second-oldest gen.
+			 */
+			if (gen_increased) {
 				delta += nr_pages;
+				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			} else {
+				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			}
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

