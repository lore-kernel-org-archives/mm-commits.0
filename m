Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46681EC4DC
	for <mm-commits@vger.kernel.org>; Wed, 11 Dec 2024 21:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733953509; cv=none; b=BbMywu+YVrydXTsc8Rr6pHhdGaO3eVh3TdPphUyraxrJApc+irs6lctqpFwYyehKrjispnhNGuLIKv0/geGlSxz7S0bK3SnAUFvZRPAii20/YdlP9PUe7X7VYh0YDrm0OtnqAwWplDZY3jcUoqK9lc4ENlGgVA8fzOW1RWvLsR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733953509; c=relaxed/simple;
	bh=NZ34STNCWvkMq0QQtmzQ7urcFvPHOl5647AfTo2M4YY=;
	h=Date:To:From:Subject:Message-Id; b=SUkp8unUHsj3f91KkUhMhQWQjJ29gStzvEvUt/tnSegOtu2HcH6V+F2zAXqTi4g0VG36rrVsRPXQbLEHbxdwPjCslXlE6SOop6AuRVK/MuqPcfISctL++DJDNfj3c7x66FzWIdDC9JwWUI9x1n38y49afAFH9Sb735w6lg0Szwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1OyABIa4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1OyABIa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93B1C4CED2;
	Wed, 11 Dec 2024 21:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1733953509;
	bh=NZ34STNCWvkMq0QQtmzQ7urcFvPHOl5647AfTo2M4YY=;
	h=Date:To:From:Subject:From;
	b=1OyABIa4yatHRUvta5OXnV+8T56yi/GM1OvL6d8rv5uLGOhp5+nJ3bhNwDYB73AUT
	 Cv23mQDwvpV50iQeqPAoWd6deSqTVSa0rMbo9n1Hdgqoqs5M0Cx9AiHlM/IbdpN3Rd
	 eP7jYbZzhzFQlOcR7HpEyMRvwOXvXC5hnHwv+DN4=
Date: Wed, 11 Dec 2024 13:45:07 -0800
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,mhocko@kernel.org,hannes@cmpxchg.org,joshua.hahnjy@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch added to mm-unstable branch
Message-Id: <20241211214508.E93B1C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg/hugetlb: remove memcg hugetlb try-commit-cancel protocol
has been added to the -mm mm-unstable branch.  Its filename is
     memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch

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
Subject: memcg/hugetlb: remove memcg hugetlb try-commit-cancel protocol
Date: Wed, 11 Dec 2024 12:39:51 -0800

This patch fully removes the mem_cgroup_{try, commit, cancel}_charge
functions, as well as their hugetlb variants.

Link: https://lkml.kernel.org/r/20241211203951.764733-4-joshua.hahnjy@gmail.com
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <songmuchun@bytedance.com>
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

memcg-hugetlb-introduce-memcg_accounts_hugetlb.patch
memcg-hugetlb-introduce-mem_cgroup_charge_hugetlb.patch
memcg-hugetlb-remove-memcg-hugetlb-try-commit-cancel-protocol.patch

