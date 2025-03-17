Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029FC54279
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 00:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172076; cv=none; b=La8yCSJs1kI8unP1SLudh+8kQma80Vi1bF0Yq4o8fdgCJD64YVFExbhEGV+W0CQS8Nognnffh42QLmMaRsu1IFgldfKXSBygjPfr1G9mMC4ZlvNETNwir+02LBHeL4BPlh26S7TaozDuELP1VlZJJxxfBdmbK+83K+3N15Z1BSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172076; c=relaxed/simple;
	bh=8rFmMx17uh1YuOReZ3o31ONgPlHBuKUA54WlmFEJwAk=;
	h=Date:To:From:Subject:Message-Id; b=L3JSFPMm82oHDXRG9a36UhJjs8nWxnUFs0Zix7zqIeBbOD49x24Ch5uj/gVkpbMXAOFmxxzMTG76Uqyl3KWQOa6iZHIjjehIf0ZvNrHFQ8cjxukaKjV0GWHmdYPFPZ1VYLWbMW1UIzCHl4y5g4fmzG0YJREVHvijcFc3qq+mJdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=do/dMvAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="do/dMvAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C99C4CEE9;
	Mon, 17 Mar 2025 00:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172075;
	bh=8rFmMx17uh1YuOReZ3o31ONgPlHBuKUA54WlmFEJwAk=;
	h=Date:To:From:Subject:From;
	b=do/dMvAlceiEFSm1f9n7cZa9QyPfsNedhl1+cwujQvWYkFuQBjhclJwq1Qv+Y5Ogn
	 TckNu9zKpdZr6eWyZGjdnJ35Vv2NHAIhvI76h3G4Vgt7pB0fSaF25u2ioTxdrC16mS
	 P6k0yGxc9E3oxHThZJOQnEhGtbLANSv+M0jVTq5w=
Date: Sun, 16 Mar 2025 17:41:15 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch removed from -mm tree
Message-Id: <20250317004115.C2C99C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcontrol: fix swap counter leak from offline cgroup
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: fix swap counter leak from offline cgroup
Date: Thu, 6 Mar 2025 10:31:33 +0800

Commit 6769183166b3 removed the parameter of id from swap_cgroup_record()
and get the memcg id from mem_cgroup_id(folio_memcg(folio)).  However, the
caller of it may update a different memcg's counter instead of
folio_memcg(folio).

E.g.  in the caller of mem_cgroup_swapout(), @swap_memcg could be
different with @memcg and update the counter of @swap_memcg, but
swap_cgroup_record() records the wrong memcg's ID.  When it is uncharged
from __mem_cgroup_uncharge_swap(), the swap counter will leak since the
wrong recorded ID.

Fix it by bringing the parameter of id back.

Link: https://lkml.kernel.org/r/20250306023133.44838-1-songmuchun@bytedance.com
Fixes: 6769183166b3 ("mm/swap_cgroup: decouple swap cgroup recording and clearing")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_cgroup.h |    4 ++--
 mm/memcontrol.c             |    4 ++--
 mm/swap_cgroup.c            |    7 ++++---
 3 files changed, 8 insertions(+), 7 deletions(-)

--- a/include/linux/swap_cgroup.h~mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup
+++ a/include/linux/swap_cgroup.h
@@ -6,7 +6,7 @@
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
 
-extern void swap_cgroup_record(struct folio *folio, swp_entry_t ent);
+extern void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
 extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
 extern int swap_cgroup_swapon(int type, unsigned long max_pages);
@@ -15,7 +15,7 @@ extern void swap_cgroup_swapoff(int type
 #else
 
 static inline
-void swap_cgroup_record(struct folio *folio, swp_entry_t ent)
+void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent)
 {
 }
 
--- a/mm/memcontrol.c~mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup
+++ a/mm/memcontrol.c
@@ -4993,7 +4993,7 @@ void mem_cgroup_swapout(struct folio *fo
 		mem_cgroup_id_get_many(swap_memcg, nr_entries - 1);
 	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
 
-	swap_cgroup_record(folio, entry);
+	swap_cgroup_record(folio, mem_cgroup_id(swap_memcg), entry);
 
 	folio_unqueue_deferred_split(folio);
 	folio->memcg_data = 0;
@@ -5055,7 +5055,7 @@ int __mem_cgroup_try_charge_swap(struct
 		mem_cgroup_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, entry);
+	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
 
 	return 0;
 }
--- a/mm/swap_cgroup.c~mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup
+++ a/mm/swap_cgroup.c
@@ -58,9 +58,11 @@ static unsigned short __swap_cgroup_id_x
  * entries must not have been charged
  *
  * @folio: the folio that the swap entry belongs to
+ * @id: mem_cgroup ID to be recorded
  * @ent: the first swap entry to be recorded
  */
-void swap_cgroup_record(struct folio *folio, swp_entry_t ent)
+void swap_cgroup_record(struct folio *folio, unsigned short id,
+			swp_entry_t ent)
 {
 	unsigned int nr_ents = folio_nr_pages(folio);
 	struct swap_cgroup *map;
@@ -72,8 +74,7 @@ void swap_cgroup_record(struct folio *fo
 	map = swap_cgroup_ctrl[swp_type(ent)].map;
 
 	do {
-		old = __swap_cgroup_id_xchg(map, offset,
-					    mem_cgroup_id(folio_memcg(folio)));
+		old = __swap_cgroup_id_xchg(map, offset, id);
 		VM_BUG_ON(old);
 	} while (++offset != end);
 }
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


