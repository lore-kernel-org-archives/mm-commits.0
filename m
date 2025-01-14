Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A223C717
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837067; cv=none; b=JXb07E3tC6+4qIYhEMnEkwQpV5ku73OAFpuyfc7Iit+0LWmeZUeMg9CWfTj2nHuedPOpg92E078xN15AgvuBPnR5fyDIDYL537tJWuptv4G0csbU9cMRD3DlUsodKPnd2EQJwGMkBU4dm75M1O9ajZcM8A0HJWPYITUh1FDbOho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837067; c=relaxed/simple;
	bh=R9JAZMceYcoIhDSGKYyfQUuOF/K5/zmJNvvu4g0zWWk=;
	h=Date:To:From:Subject:Message-Id; b=mWSQTMC/rBVMYSJdpTJ5fK6DNjXrhnejB8h4+VOZWswSG3G68/UKLn4f4SChFSYjhhNZTsH1mqB0FwgXPT3yaBnExagVp6dw+IcMxWzOwMauDUP7zc8N/U+cDYFwQuyGKQzpQxv68zhLb0qU7QPVg59x5hGcD3TNrfKtLYhCMP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RJQzapCz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RJQzapCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F35DC4CEDD;
	Tue, 14 Jan 2025 06:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837067;
	bh=R9JAZMceYcoIhDSGKYyfQUuOF/K5/zmJNvvu4g0zWWk=;
	h=Date:To:From:Subject:From;
	b=RJQzapCz+98MF/Pavf0YgnOek5F3vvtfak+qvjZeh9SwYmKdKlSnoX2xtVXR8wyYR
	 PHLRQ3JQTj4XAtFxQKoAs5Plu0b9+eze2qzoo5EP4tD6iKgtwvui7iiekUCFmPSK6c
	 JFh7jXyZCdF9UoTHsYsmZ7R4+CZgxDFuOuqcNf6o=
Date: Mon, 13 Jan 2025 22:44:26 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,nphamcs@gmail.com,muchun.song@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch removed from -mm tree
Message-Id: <20250114064427.5F35DC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg/hugetlb: remove memcg hugetlb try-commit-cancel protocol
has been removed from the -mm tree.  Its filename was
     memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: memcg/hugetlb: remove memcg hugetlb try-commit-cancel protocol
Date: Wed, 11 Dec 2024 12:39:51 -0800

This patch fully removes the mem_cgroup_{try, commit, cancel}_charge
functions, as well as their hugetlb variants.

Link: https://lkml.kernel.org/r/20241211203951.764733-4-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   22 -----------
 mm/memcontrol.c            |   65 +----------------------------------
 2 files changed, 3 insertions(+), 84 deletions(-)

--- a/include/linux/memcontrol.h~memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol
+++ a/include/linux/memcontrol.h
@@ -620,8 +620,6 @@ static inline bool mem_cgroup_below_min(
 		page_counter_read(&memcg->memory);
 }
 
-void mem_cgroup_commit_charge(struct folio *folio, struct mem_cgroup *memcg);
-
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
 /**
@@ -646,9 +644,6 @@ static inline int mem_cgroup_charge(stru
 	return __mem_cgroup_charge(folio, mm, gfp);
 }
 
-int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
-		long nr_pages);
-
 int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
@@ -679,7 +674,6 @@ static inline void mem_cgroup_uncharge_f
 	__mem_cgroup_uncharge_folios(folios);
 }
 
-void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages);
 void mem_cgroup_replace_folio(struct folio *old, struct folio *new);
 void mem_cgroup_migrate(struct folio *old, struct folio *new);
 
@@ -1154,23 +1148,12 @@ static inline bool mem_cgroup_below_min(
 	return false;
 }
 
-static inline void mem_cgroup_commit_charge(struct folio *folio,
-		struct mem_cgroup *memcg)
-{
-}
-
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
 {
 	return 0;
 }
 
-static inline int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg,
-		gfp_t gfp, long nr_pages)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
 {
         return 0;
@@ -1194,11 +1177,6 @@ static inline void mem_cgroup_uncharge_f
 {
 }
 
-static inline void mem_cgroup_cancel_charge(struct mem_cgroup *memcg,
-		unsigned int nr_pages)
-{
-}
-
 static inline void mem_cgroup_replace_folio(struct folio *old,
 		struct folio *new)
 {
--- a/mm/memcontrol.c~memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol
+++ a/mm/memcontrol.c
@@ -2383,21 +2383,6 @@ done_restock:
 	return 0;
 }
 
-/**
- * mem_cgroup_cancel_charge() - cancel an uncommitted try_charge() call.
- * @memcg: memcg previously charged.
- * @nr_pages: number of pages previously charged.
- */
-void mem_cgroup_cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	if (mem_cgroup_is_root(memcg))
-		return;
-
-	page_counter_uncharge(&memcg->memory, nr_pages);
-	if (do_memsw_account())
-		page_counter_uncharge(&memcg->memsw, nr_pages);
-}
-
 static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 {
 	VM_BUG_ON_FOLIO(folio_memcg_charged(folio), folio);
@@ -2411,18 +2396,6 @@ static void commit_charge(struct folio *
 	folio->memcg_data = (unsigned long)memcg;
 }
 
-/**
- * mem_cgroup_commit_charge - commit a previously successful try_charge().
- * @folio: folio to commit the charge to.
- * @memcg: memcg previously charged.
- */
-void mem_cgroup_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
-{
-	css_get(&memcg->css);
-	commit_charge(folio, memcg);
-	memcg1_commit_charge(folio, memcg);
-}
-
 static inline void __mod_objcg_mlstate(struct obj_cgroup *objcg,
 				       struct pglist_data *pgdat,
 				       enum node_stat_item idx, int nr)
@@ -4510,7 +4483,9 @@ static int charge_memcg(struct folio *fo
 	if (ret)
 		goto out;
 
-	mem_cgroup_commit_charge(folio, memcg);
+	css_get(&memcg->css);
+	commit_charge(folio, memcg);
+	memcg1_commit_charge(folio, memcg);
 out:
 	return ret;
 }
@@ -4528,40 +4503,6 @@ int __mem_cgroup_charge(struct folio *fo
 }
 
 /**
- * mem_cgroup_hugetlb_try_charge - try to charge the memcg for a hugetlb folio
- * @memcg: memcg to charge.
- * @gfp: reclaim mode.
- * @nr_pages: number of pages to charge.
- *
- * This function is called when allocating a huge page folio to determine if
- * the memcg has the capacity for it. It does not commit the charge yet,
- * as the hugetlb folio itself has not been obtained from the hugetlb pool.
- *
- * Once we have obtained the hugetlb folio, we can call
- * mem_cgroup_commit_charge() to commit the charge. If we fail to obtain the
- * folio, we should instead call mem_cgroup_cancel_charge() to undo the effect
- * of try_charge().
- *
- * Returns 0 on success. Otherwise, an error code is returned.
- */
-int mem_cgroup_hugetlb_try_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			long nr_pages)
-{
-	/*
-	 * If hugetlb memcg charging is not enabled, do not fail hugetlb allocation,
-	 * but do not attempt to commit charge later (or cancel on error) either.
-	 */
-	if (mem_cgroup_disabled() || !memcg ||
-		!cgroup_subsys_on_dfl(memory_cgrp_subsys) || !memcg_accounts_hugetlb())
-		return -EOPNOTSUPP;
-
-	if (try_charge(memcg, gfp, nr_pages))
-		return -ENOMEM;
-
-	return 0;
-}
-
-/**
  * mem_cgroup_charge_hugetlb - charge the memcg for a hugetlb folio
  * @folio: folio being charged
  * @gfp: reclaim mode
_

Patches currently in -mm which might be from joshua.hahnjy@gmail.com are

mm-damon-paddr-improve-readability-of-damon_pa_stat.patch

