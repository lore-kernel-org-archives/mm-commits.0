Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7756223C717
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837066; cv=none; b=GkpU4ec8XOmNEfJ5yxOoSqycIVI0pJ5GwtNt5StbmAHyqXm/E57RYAu4NiGJZB17BptbiuA58qSfSqW4G1wj2lKSVBwfielUOQkWeIl2WOctV57Lu7RpYs9oZE7UcmIYF9Jj98OUrfEcCTUXZavnrNqNV+Crn2LIM6l7qTX2qwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837066; c=relaxed/simple;
	bh=9siJhDcbABy+3HvAuth4GRP3T53kTOC4vaxfhv1EA6s=;
	h=Date:To:From:Subject:Message-Id; b=V6TfFbWujGM2PDZBrUCpayUPBIUm7uynnmF4RjiJ3TEcW20LpvKPv4xmVB+ZpZaqmDys1J8vr4EkdSn5WTASWdOrxkiuz2cWrqKBiX0s7LCBxqtAzIXadZijnS/T1pg9WFnH6IeQEk9DPWTaxY5YeRXoTMS/L3AfaUWyWM6Jdzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gvj/MT/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gvj/MT/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C922C4CEDD;
	Tue, 14 Jan 2025 06:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837066;
	bh=9siJhDcbABy+3HvAuth4GRP3T53kTOC4vaxfhv1EA6s=;
	h=Date:To:From:Subject:From;
	b=Gvj/MT/lC73KZwDvFRjcQojTsSudQVptcNRNQSVdey/k5yHva75V8uPCXdDNPDi55
	 saOsqOYhpKZKsaItOa9csLmm1GuI0icTa8ncbE/5SIv04MBJKNNSdamcoSsYLikn3X
	 M3YVJt/IyANLRAvEqMxssWfn4wTUMHLMkxQnxS0g=
Date: Mon, 13 Jan 2025 22:44:25 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch removed from -mm tree
Message-Id: <20250114064426.4C922C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg/hugetlb: introduce mem_cgroup_charge_hugetlb
has been removed from the -mm tree.  Its filename was
     memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: memcg/hugetlb: introduce mem_cgroup_charge_hugetlb
Date: Wed, 11 Dec 2024 12:39:50 -0800

This patch introduces mem_cgroup_charge_hugetlb which combines the logic
of mem_cgroup_hugetlb_try_charge / mem_cgroup_hugetlb_commit_charge and
removes the need for mem_cgroup_hugetlb_cancel_charge.  It also reduces
the footprint of memcg in hugetlb code and consolidates all memcg related
error paths into one.

Link: https://lkml.kernel.org/r/20241211203951.764733-3-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/hugetlb.c               |   35 ++++++++++++++---------------------
 mm/memcontrol.c            |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 21 deletions(-)

--- a/include/linux/memcontrol.h~memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb
+++ a/include/linux/memcontrol.h
@@ -649,6 +649,8 @@ static inline int mem_cgroup_charge(stru
 int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
 		long nr_pages);
 
+int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
+
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 				  gfp_t gfp, swp_entry_t entry);
 
@@ -1169,6 +1171,11 @@ static inline int mem_cgroup_hugetlb_try
 	return 0;
 }
 
+static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
+{
+        return 0;
+}
+
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
 			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry)
 {
--- a/mm/hugetlb.c~memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb
+++ a/mm/hugetlb.c
@@ -2981,21 +2981,13 @@ struct folio *alloc_hugetlb_folio(struct
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long map_chg, map_commit, nr_pages = pages_per_huge_page(h);
+	long map_chg, map_commit;
 	long gbl_chg;
-	int memcg_charge_ret, ret, idx;
+	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	struct mem_cgroup *memcg;
 	bool deferred_reserve;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
-	memcg = get_mem_cgroup_from_current();
-	memcg_charge_ret = mem_cgroup_hugetlb_try_charge(memcg, gfp, nr_pages);
-	if (memcg_charge_ret == -ENOMEM) {
-		mem_cgroup_put(memcg);
-		return ERR_PTR(-ENOMEM);
-	}
-
 	idx = hstate_index(h);
 	/*
 	 * Examine the region/reserve map to determine if the process
@@ -3003,12 +2995,8 @@ struct folio *alloc_hugetlb_folio(struct
 	 * code of zero indicates a reservation exists (no change).
 	 */
 	map_chg = gbl_chg = vma_needs_reservation(h, vma, addr);
-	if (map_chg < 0) {
-		if (!memcg_charge_ret)
-			mem_cgroup_cancel_charge(memcg, nr_pages);
-		mem_cgroup_put(memcg);
+	if (map_chg < 0)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	/*
 	 * Processes that did not create the mapping will have no
@@ -3106,10 +3094,18 @@ struct folio *alloc_hugetlb_folio(struct
 		}
 	}
 
-	if (!memcg_charge_ret)
-		mem_cgroup_commit_charge(folio, memcg);
+	ret = mem_cgroup_charge_hugetlb(folio, gfp);
+	/*
+	 * Unconditionally increment NR_HUGETLB here. If it turns out that
+	 * mem_cgroup_charge_hugetlb failed, then immediately free the page and
+	 * decrement NR_HUGETLB.
+	 */
 	lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
-	mem_cgroup_put(memcg);
+
+	if (ret == -ENOMEM) {
+		free_huge_folio(folio);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	return folio;
 
@@ -3124,9 +3120,6 @@ out_subpool_put:
 		hugepage_subpool_put_pages(spool, 1);
 out_end_reservation:
 	vma_end_reservation(h, vma, addr);
-	if (!memcg_charge_ret)
-		mem_cgroup_cancel_charge(memcg, nr_pages);
-	mem_cgroup_put(memcg);
 	return ERR_PTR(-ENOSPC);
 }
 
--- a/mm/memcontrol.c~memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb
+++ a/mm/memcontrol.c
@@ -4562,6 +4562,40 @@ int mem_cgroup_hugetlb_try_charge(struct
 }
 
 /**
+ * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
+ * @folio: folio being charged
+ * @gfp: reclaim mode
+ *
+ * This function is called when allocating a huge page folio, after the page has
+ * already been obtained and charged to the appropriate hugetlb cgroup
+ * controller (if it is enabled).
+ *
+ * Returns ENOMEM if the memcg is already full.
+ * Returns 0 if either the charge was successful, or if we skip the charging.
+ */
+int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
+{
+	struct mem_cgroup *memcg = get_mem_cgroup_from_current();
+	int ret = 0;
+
+	/*
+	 * Even memcg does not account for hugetlb, we still want to update
+	 * system-level stats via lruvec_stat_mod_folio. Return 0, and skip
+	 * charging the memcg.
+	 */
+	if (mem_cgroup_disabled() || !memcg_accounts_hugetlb() ||
+		!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		goto out;
+
+	if (charge_memcg(folio, memcg, gfp))
+		ret = -ENOMEM;
+
+out:
+	mem_cgroup_put(memcg);
+	return ret;
+}
+
+/**
  * mem_cgroup_swapin_charge_folio - Charge a newly allocated folio for swapin.
  * @folio: folio to charge.
  * @mm: mm context of the victim
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-damon-paddr-improve-readability-of-damon_pa_stat.patch

