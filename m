Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5882F3614
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334371; cv=none; b=odWFEKRXb5zfSbs30IBSnWbCg2PqPefOcatzooipQu5jjIhnhTRJHYBgelMd/+NFV4gwbUCmF/q4DBR/5ThptkcrqO+vqvUatZE386cnGxpq/4aNhbeUHjjl/Bd/MOkYk8tz6TDLsFW3YKBnmi2O2Vk0Y+PXrNNsgKSQAdHElrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334371; c=relaxed/simple;
	bh=DwLOvkv9jynbOWnH4AuEpWLDf0BteFHYJSdJpTAoU+M=;
	h=Date:To:From:Subject:Message-Id; b=SrSwftaAnEuQLEfOr21PLvtLPqZNZjIaKuAaNBaYXcgMPLDIy2tmPFAt5/rHUTvH3GvIs7pNTdCahxrPHDgC2gfVUb0HlDfCBR3hjz58SSvWZq86k5Txqp7MzgMPNrzqHupKsQDi6HIvmRvQXE5oPLtakhVWcX+CjLUtnkRUHFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kcNhLiLZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kcNhLiLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A101F0089C;
	Wed,  7 Oct 2026 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334369;
	bh=UXcvbtQdNQWqib5TAlIepmd0sN9h6lh7mSlvi6wIviw=;
	h=Date:To:From:Subject;
	b=kcNhLiLZSlHBOcQRasFHkHKGwhHS0dr/huiS2KbihSLcx24Xz6SuxJsbY0KZjQUIC
	 BbFWhO0GubTw6CZ5hzsfNshTNobEMYpg6/ay3z2PMzWEF7z1GpNv8FSlmsCGY7KclP
	 6pXlm4HleBlSFDnQ/SEv9toe+/TXvE8kc+KV8Raw=
Date: Tue, 06 Oct 2026 17:52:49 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,xueyuan.chen21@gmail.com,weixugc@google.com,stevensd@chromium.org,shakeel.butt@linux.dev,ridong.chen@linux.dev,mhocko@kernel.org,ljs@kernel.org,lianux.mm@gmail.com,kunwu.chan@gmail.com,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,axelrasmussen@google.com,baohua@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch removed from -mm tree
Message-Id: <20261007005249.B9A101F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
has been removed from the -mm tree.  Its filename was
     mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Wed, 2 Sep 2026 07:24:16 +0800

Currently, folio_inc_gen() updates lrugen->nr_pages for every folio as it
advances generations.  Instead, accumulate the size changes and update
lrugen->nr_pages in a batch after scanning the entire oldest generation,
or when the scan stops because remaining reaches zero.

Since we only move folios from the oldest generation to the second oldest
generation, the active/inactive state cannot change.  We can therefore
skip __lru_update_size().

Link: https://lore.kernel.org/20260901232421.40157-3-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
---

 mm/vmscan.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mm-mglru-batch-update-lrugen-nr_pages-in-inc_min_seq
+++ a/mm/vmscan.c
@@ -3923,6 +3923,7 @@ static bool inc_min_seq(struct lruvec *l
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
+	int target_gen = (old_gen + 1) % MAX_NR_GENS;
 
 	/* For file type, skip the check if swappiness is anon only */
 	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
@@ -3932,35 +3933,47 @@ static bool inc_min_seq(struct lruvec *l
 	if (!type && !swappiness)
 		goto done;
 
+	VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
+	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) !=
+			lru_gen_is_active(lruvec, target_gen));
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
+		long delta = 0;
 
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
+			long nr_pages = folio_nr_pages(folio);
 			int refs = folio_lru_refs(folio);
 			bool workingset = folio_test_workingset(folio);
+			bool gen_increased;
 
 			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio);
+			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-
+			if (gen_increased)
+				delta += nr_pages;
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
-				int delta = folio_nr_pages(folio);
 
 				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + delta);
+					   lrugen->protected[hist][type][tier] + nr_pages);
 			}
 
 			if (!--remaining)
-				return false;
+				break;
 		}
+		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
+			   lrugen->nr_pages[old_gen][type][zone] - delta);
+		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
+			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		if (!remaining)
+			return false;
 	}
 done:
 	reset_ctrl_pos(lruvec, type, true);
_

Patches currently in -mm which might be from baohua@kernel.org are

mm-mglru-restore-accidentally-removed-seq-max_seq-check.patch

