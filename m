Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6DD1E22F8
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 21:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733953508; cv=none; b=SqLc0rFeCpbdJfdljWJE5y57YzcHhsrRJHtUYcktCNfnpff3KzskW8Kgzp/2/amNHfHZC5aFOGXAAYIcsLg4todvIBMrWVrxuAxzAMIeCmz3OHuHscIdzUqLe3sDsCvFhCEqPobrjuxvKExu0cHJxN4Vr1gRocQGuC3WtCfRNyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733953508; c=relaxed/simple;
	bh=jORB2SEiLqp49oCw9pqfGcVfOFg6wPwyuMCtPw7sGjY=;
	h=Date:To:From:Subject:Message-Id; b=HWft/FRiyUwkPG6w5ZBuIkOATHtGr8fhqILvU2urNANEV87k9QlqCySDpG6dRYUbp7zb8QL+LfbAg5IDfN58agjBh3H0xoPqmgKmyoVGFKGOJ+pIRZX80OnhyG/2nTLjeAXmDP90nSNypJg2o1hWlX+H4qayp/6mlPNZNE2mO+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YOv5JA/h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YOv5JA/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DBBC4CED2;
	Wed, 11 Dec 2024 21:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733953507;
	bh=jORB2SEiLqp49oCw9pqfGcVfOFg6wPwyuMCtPw7sGjY=;
	h=Date:To:From:Subject:From;
	b=YOv5JA/hIx0iPFTQEHMsX5zWdc2sLJ99AVBv1T6Jmfjm6rBVA6M2lWnVgAbS+Q9rK
	 N21ntkpcQi+iDGjMd6Y83JqQ5ukklWprbq5DOX3mzoRwNValNOZvlL1m7hbS7WMOVv
	 uU2Of4/BMwUdnbOxucJIEEA4CMd0Ulchna8C04v0=
Date: Wed, 11 Dec 2024 13:45:05 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch added to mm-unstable branch
Message-Id: <20241211214507.74DBBC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg/hugetlb: introduce mem_cgroup_charge_hugetlb
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
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
 	return ERR_PTR(-ENOMEM);
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

memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch
memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch
memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch

