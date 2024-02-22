Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521B28F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560071; cv=none; b=aY/k2wnC1ALSZJNSkNd0GGJ7LyXxD+48XrkiDO8IQA+2kZzxqy6btiIWdLjUoyeRxuNMUp8yvKjap3n+Ihx3AnT+kXWUMz+9upc9mgEbIVhCVg6b/LdCFyjYKnEdraZpt9qvRc2nqSlqA0U0y6Hr0oyMyCkS1pTO3YEptl3MPPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560071; c=relaxed/simple;
	bh=ImHwWIbNO+moT08Q/AxVrJCk0kS2t/qXb9psY2ShHW8=;
	h=Date:To:From:Subject:Message-Id; b=EhKKWwU54YJYgFCnNtYPAkCrbseClagYM5GydlnGEVAvrAS2cLsIvGq6LpUSvgGuXhIzQ0Yptd0QKNwd9s7NvK9BUUO0YM3n/fH/RAkZDFw0y0SZvRhLpOlFj6ZRnzJeeagAUuwTxvLQc6pH+ljmXG65U25Xc14JYkZXKb5rg+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rckBZ/Ut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rckBZ/Ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1993C43394;
	Thu, 22 Feb 2024 00:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560070;
	bh=ImHwWIbNO+moT08Q/AxVrJCk0kS2t/qXb9psY2ShHW8=;
	h=Date:To:From:Subject:From;
	b=rckBZ/UtZDagrb3hyvopnDqZVbBom16ky010u4V1i7QaNo17Mx4BYMq8o6h6ojS/v
	 NqeU9D1sO3AqAOhkb/hSvTMA+y2baQc7Hv7RW1CoP0JqEUIOQN0HY3ndbzdxCszXwL
	 BF5teQ1GgPMikngvxGFHsuQA2/zSKMq9khbL+hN8=
Date: Wed, 21 Feb 2024 16:01:10 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-return-the-folio-in-union-mc_target.patch removed from -mm tree
Message-Id: <20240222000110.D1993C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: return the folio in union mc_target
has been removed from the -mm tree.  Its filename was
     memcg-return-the-folio-in-union-mc_target.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: memcg: return the folio in union mc_target
Date: Thu, 11 Jan 2024 18:12:17 +0000

All users of target.page convert it to the folio, so we can just return
the folio directly and save a few calls to compound_head().

Link: https://lkml.kernel.org/r/20240111181219.3462852-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~memcg-return-the-folio-in-union-mc_target
+++ a/mm/memcontrol.c
@@ -5873,7 +5873,7 @@ static int mem_cgroup_do_precharge(unsig
 }
 
 union mc_target {
-	struct page	*page;
+	struct folio	*folio;
 	swp_entry_t	ent;
 };
 
@@ -6095,7 +6095,7 @@ out:
  * Return:
  * * MC_TARGET_NONE - If the pte is not a target for move charge.
  * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
- *   move charge. If @target is not NULL, the page is stored in target->page
+ *   move charge. If @target is not NULL, the folio is stored in target->folio
  *   with extra refcnt taken (Caller should release it).
  * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
  *   target for charge migration.  If @target is not NULL, the entry is
@@ -6160,7 +6160,7 @@ static enum mc_target_type get_mctgt_typ
 			    is_device_coherent_page(page))
 				ret = MC_TARGET_DEVICE;
 			if (target)
-				target->page = page;
+				target->folio = page_folio(page);
 		}
 		if (!ret || !target) {
 			if (target)
@@ -6210,7 +6210,7 @@ static enum mc_target_type get_mctgt_typ
 				put_page(page);
 				return MC_TARGET_NONE;
 			}
-			target->page = page;
+			target->folio = page_folio(page);
 		}
 	}
 	return ret;
@@ -6440,7 +6440,7 @@ static int mem_cgroup_move_charge_pte_ra
 		}
 		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
 		if (target_type == MC_TARGET_PAGE) {
-			folio = page_folio(target.page);
+			folio = target.folio;
 			if (folio_isolate_lru(folio)) {
 				if (!mem_cgroup_move_account(folio, true,
 							     mc.from, mc.to)) {
@@ -6452,7 +6452,7 @@ static int mem_cgroup_move_charge_pte_ra
 			folio_unlock(folio);
 			folio_put(folio);
 		} else if (target_type == MC_TARGET_DEVICE) {
-			folio = page_folio(target.page);
+			folio = target.folio;
 			if (!mem_cgroup_move_account(folio, true,
 						     mc.from, mc.to)) {
 				mc.precharge -= HPAGE_PMD_NR;
@@ -6482,7 +6482,7 @@ retry:
 			device = true;
 			fallthrough;
 		case MC_TARGET_PAGE:
-			folio = page_folio(target.page);
+			folio = target.folio;
 			/*
 			 * We can have a part of the split pmd here. Moving it
 			 * can be done but it would be too convoluted so simply
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-replace-two-calls-to-compound_order-with-folio_order.patch
writeback-remove-a-duplicate-prototype-for-tag_pages_for_writeback.patch
writeback-factor-folio_prepare_writeback-out-of-write_cache_pages.patch
writeback-factor-writeback_get_batch-out-of-write_cache_pages.patch
writeback-simplify-the-loops-in-write_cache_pages.patch
pagevec-add-ability-to-iterate-a-queue.patch
writeback-use-the-folio_batch-queue-iterator.patch
writeback-move-the-folio_prepare_writeback-loop-out-of-write_cache_pages.patch
writeback-remove-a-use-of-write_cache_pages-from-do_writepages.patch
bounds-support-non-power-of-two-config_nr_cpus.patch

