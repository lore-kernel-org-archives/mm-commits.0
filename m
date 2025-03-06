Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFE527D76B
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 23:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302704; cv=none; b=Vq0Q5wci7hyjMDVUkBj3c7GDM5tDuy5JTEHEbRH7SwUOGsGCoM3SZ/e7iVZ4UtB73TzEU5hpRWfgqy0jrC6PKqDyHt0HkUFLOijN7KpJ/68ceheFFK761WTAFIXzBEi4wvunJT0mT8wgCQ6JmyfaZusINhyKE216k8PAxS/9Q8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302704; c=relaxed/simple;
	bh=KJjeHv6FMgRyZpzv9EDQqlcYx2Q6LlABLXeV7xOOFtY=;
	h=Date:To:From:Subject:Message-Id; b=Rl0h+thQV5EnU2URv7jw92k3csVbOLbmQzf5ZiePXOzniZ+Y+KIGvS0Zlffv7gluJQEFw0VOGd3puh3vVZECwOlxpmFMaDrZhamo6/nXHAjX1xSzQVxfMB1DqGrZjTQbGjZXRKH5xSdEJChBfO0zvNbGxnRD5XiIoRMy8wF+ub8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TgPhMi+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TgPhMi+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 833F9C4CEE0;
	Thu,  6 Mar 2025 23:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741302703;
	bh=KJjeHv6FMgRyZpzv9EDQqlcYx2Q6LlABLXeV7xOOFtY=;
	h=Date:To:From:Subject:From;
	b=TgPhMi+3ubW4fbGk2MWCRAUQ19uXfJNNM/xRvC37CX5x+NFsDFrPiIepMPqmYLRm2
	 hn9CnX2ropKqP0ZrKBD7uftYWBcH10JL186J2LGJIozDcPRv4RzYiVTkrU2aP4Vo22
	 Vb2BWnDXWVMaaeuLB7Uh/QllX4M8m7vrFC0m1/bE=
Date: Thu, 06 Mar 2025 15:11:42 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,mhocko@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,chrisl@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch added to mm-hotfixes-unstable branch
Message-Id: <20250306231143.833F9C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcontrol: fix swap counter leak from offline cgroup
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

mm-memcontrol-fix-swap-counter-leak-from-offline-cgroup.patch

