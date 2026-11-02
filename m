Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793659992;
	b=vAmJ+pQlO/zBPDJ5+8xsdL5UcQtjF7xm/mYA1ZdEh7zw7Jqa2JLb9ISkts8Qg9XlBj1O
	 YIsLtlmEyb1B0oYorkthIdCKnKD671LIM3bGdmt+gUHJs6qUEghRoFEYluw7fkzEx47u9
	 3fEyFWitl9L6GdDqRciz41gHihOoCk/FC8pPdb9Sadfv064/T23OetWDEWDCkXxA+xf9q
	 awG8rBQ7/QzyGNASO/FstuiSe0irG3YaLN4QS4gdAFklFOAEi6jg7s6szvK8ZG/K6zeTL
	 xpoy6SlKyy4BBWWpS2AfRK9u0iCX55FGX+umC8n/ez5hQKnkqru+sSGpGBosls3RZjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793659992;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=n7AYsRWf4IU2gpjRaeK9FLqCuOQkuQAWdhWFHA1jDRM=;
	b=BBYDmrqnO9IjIZHzGIGa5BH43jIb3jwS3jlZkVXcg9tJP6k4E/XHc62jftr/wZ9ZpKI6
	 OWGnqmcs3qWWXcWPM+efTPC0oZn0vT5fF7+ATNQRGNbn0oX9i41NRfzHv5COHzEOdwY4c
	 ChTUZBrgB9dALedMzDfVj1Jl+/xQhZJjeRyBTEFfHRIq3oYUhuuvwWmtZ4hbMAbLSBkDq
	 xQ5FsaaVD8cfiGMw5BoqO3YtuufbU5SeQRcEspUlkaT7wOFAtGosQ+QZ5CAZNZPKORmd8
	 L+z4cXrgGxShw217XKAVqcLqtbiL28wGAJ8JGGP+3rVWNgFYRieX3tVScPTqEulEMYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dJxh1mAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ED1606A327
	for <mm-commits@vger.kernel.org>; Mon,  2 Nov 2026 22:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dJxh1mAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5EC1F00A16;
	Mon,  2 Nov 2026 22:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793659991;
	bh=n7AYsRWf4IU2gpjRaeK9FLqCuOQkuQAWdhWFHA1jDRM=;
	h=Date:To:From:Subject;
	b=dJxh1mAWimRqSwdCGanPCtbulKTD1PxFEoDjFat4m1rMtsTQQNv5aKBQbFyrXZTKJ
	 IBW4HeZcKwghL5Xog/t/Tr8KRtwGpsriXt80d796MUhatbY7NFjerFUvQHt7J8dJLq
	 o5RXw/Mo1Y7HTsO0IiNTWA7csk8/0w99m9ynUge4=
Date: Mon, 02 Nov 2026 14:53:11 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,shakeel.butt@linux.dev,
	rppt@kernel.org,roman.gushchin@linux.dev,qi.zheng@linux.dev,
	osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,
	mt4022@columbia.edu,mike.kravetz@oracle.com,mhocko@kernel.org,
	linmiaohe@huawei.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,
	fvdl@google.com,david@kernel.org,chris@chrisdown.name,
	baolin.wang@linux.alibaba.com,chengkaitao@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch added to mm-new branch
Message-Id: <20261102225311.6B5EC1F00A16@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: fix NR_HUGETLB accounting for surplus folios
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch

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
From: Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: mm/hugetlb: fix NR_HUGETLB accounting for surplus folios
Date: Mon, 02 Nov 2026 10:49:10 +0800

NR_HUGETLB is incremented in the allocation entry points, but decremented
unconditionally in free_huge_folio(). Surplus folios allocated while
gathering reservations can be freed without passing through those entry
points, leaving an unmatched decrement in the per-node counter.

This happens when reservation gathering fails or allocates more folios
than needed, or when the overcommit recheck rejects a newly allocated
surplus folio. These paths cause nr_hugetlb in /proc/vmstat to underreport
usage.

Move node accounting to the underlying folio state transitions. Increment
NR_HUGETLB when dequeuing a free folio or allocating a fresh surplus or
migration folio, and decrement it when returning the folio to the pool or
removing it from active use. Balance the temporary increment when surplus
folios gathered for reservations are added to the free pool.

Separate memcg statistics from node accounting, updating them after a
successful charge and before uncharging. This keeps node accounting
balanced independently of whether the folio is charged to a memcg.

Link: https://lore.kernel.org/20261102024910.31486-4-kaitao.cheng@linux.dev
Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
---

 mm/hugetlb.c    |   42 +++++++++++++++++++++++++++---------------
 mm/memcontrol.c |    6 +-----
 2 files changed, 28 insertions(+), 20 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios
+++ a/mm/hugetlb.c
@@ -1288,6 +1288,8 @@ static struct folio *dequeue_hugetlb_fol
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    pages_per_huge_page(h));
 		return folio;
 	}
 
@@ -1416,6 +1418,9 @@ void remove_hugetlb_folio(struct hstate
 		folio_clear_hugetlb_freed(folio);
 		h->free_huge_pages--;
 		h->free_huge_pages_node[nid]--;
+	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 	}
 	if (adjust_surplus) {
 		h->surplus_huge_pages--;
@@ -1693,6 +1698,17 @@ struct hstate *size_to_hstate(unsigned l
 	return NULL;
 }
 
+static void mod_hugetlb_memcg_state(struct folio *folio, int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	guard(rcu)();
+	memcg = folio_memcg(folio);
+	if (memcg)
+		mod_memcg_lruvec_state(mem_cgroup_lruvec(memcg, folio_pgdat(folio)),
+				       NR_HUGETLB, nr_pages);
+}
+
 void free_huge_folio(struct folio *folio)
 {
 	/*
@@ -1740,7 +1756,7 @@ void free_huge_folio(struct folio *folio
 				     pages_per_huge_page(h), folio);
 	hugetlb_cgroup_uncharge_folio_rsvd(hstate_index(h),
 					  pages_per_huge_page(h), folio);
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, -pages_per_huge_page(h));
+	mod_hugetlb_memcg_state(folio, -pages_per_huge_page(h));
 	mem_cgroup_uncharge(folio);
 	if (restore_reserve)
 		h->resv_huge_pages++;
@@ -1756,6 +1772,8 @@ void free_huge_folio(struct folio *folio
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
 	} else {
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		arch_clear_hugetlb_flags(folio);
 		enqueue_hugetlb_folio(h, folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
@@ -2123,6 +2141,9 @@ static struct folio *alloc_surplus_huget
 	 */
 	account_new_hugetlb_folio(h, folio);
 
+	/* The overcommit recheck below can free this folio. */
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
+
 	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
@@ -2160,6 +2181,7 @@ static struct folio *alloc_migrate_huget
 
 	spin_lock_irq(&hugetlb_lock);
 	account_new_hugetlb_folio(h, folio);
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB, pages_per_huge_page(h));
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
@@ -2218,10 +2240,6 @@ struct folio *alloc_hugetlb_folio_reserv
 
 	spin_unlock_irq(&hugetlb_lock);
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB,
-				      folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2249,9 +2267,6 @@ struct folio *alloc_hugetlb_folio_nodema
 						    nmask);
 	}
 
-	if (folio)
-		lruvec_stat_mod_folio(folio, NR_HUGETLB, folio_nr_pages(folio));
-
 	return folio;
 }
 
@@ -2369,6 +2384,8 @@ retry:
 		if ((--needed) < 0)
 			break;
 		/* Add the page to the hugetlb allocator */
+		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+				    -(long)pages_per_huge_page(h));
 		enqueue_hugetlb_folio(h, folio);
 	}
 free:
@@ -2944,13 +2961,6 @@ struct folio *hugetlb_alloc_folio(struct
 
 	ret = mem_cgroup_charge_hugetlb(folio, mm,
 					gfp | __GFP_RETRY_MAYFAIL);
-	/*
-	 * Unconditionally increment NR_HUGETLB here because if
-	 * mem_cgroup_charge_hugetlb failed, freeing the page will
-	 * decrement NR_HUGETLB.
-	 */
-	lruvec_stat_mod_folio(folio, NR_HUGETLB, nr_pages);
-
 	if (ret == -ENOMEM) {
 		folio_put(folio);
 		/*
@@ -2965,6 +2975,8 @@ struct folio *hugetlb_alloc_folio(struct
 		return ERR_PTR(-ENOSPC);
 	}
 
+	mod_hugetlb_memcg_state(folio, nr_pages);
+
 	return folio;
 
  err_uncharge_hugetlb_cgroup:
--- a/mm/memcontrol.c~mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios
+++ a/mm/memcontrol.c
@@ -5439,11 +5439,7 @@ int mem_cgroup_charge_hugetlb(struct fol
 	struct mem_cgroup *memcg = get_mem_cgroup_from_mm(mm);
 	int ret = 0;
 
-	/*
-	 * Even memcg does not account for hugetlb, we still want to update
-	 * system-level stats via lruvec_stat_mod_folio. Return 0, and skip
-	 * charging the memcg.
-	 */
+	/* Skip charging unless hugetlb accounting is enabled for cgroup v2. */
 	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
 		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		goto out;
_

Patches currently in -mm which might be from chengkaitao@kylinos.cn are

mm-hugetlb_cma-fix-incorrect-hugetlb_cma_size-assignment-on-malformed-input.patch
mm-hugetlb-preserve-persistent-flags-when-returning-folios-to-the-pool.patch
mm-hugetlb-fix-nr_hugetlb-accounting-for-surplus-folios.patch

