Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6664C246778
	for <mm-commits@vger.kernel.org>; Sun,  6 Sep 2026 01:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788659119; cv=none; b=vEM57Zi6m/axmsChgJkaZ32tZCoQBeiAOPPN5MaGca1xDKyMvuz3E0n+5qYp+/br9DRmLY9vK2tHQ7d4lzuzHN4G/eFj46zDfd/s8EAEGumuhjqKiPf8PsB4a5kWzP4NDkpNihDtWww2m+G9RgWAn/5VVjll8X/gLKA4rGkuJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788659119; c=relaxed/simple;
	bh=Pfja9pIW23PltK2jJ7gcULBhWGfnlyjPVmuVwHLCFP0=;
	h=Date:To:From:Subject:Message-Id; b=DUzuFbsTCnbqgW/WGkjt/Sob5aMft4KtVRSt/vaEKFJ+okh6dY5fgHWmyZJ2xzn9oCmWa9kvY3g1oXKZ+/14LZEBu4ifqOgIPWbVEFIaRBBGUmZjyiQQSBKEO3VreyKofYTPqlUvL6FiP2Rej3iPgMdD8TreWaZIoqqvXFHDu0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Uv884dh6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Uv884dh6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E781F00A3A;
	Sun,  6 Sep 2026 01:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788659117;
	bh=OhnV7L1LszysMliEFwlD2w3z8ErpV4itzhI3QWuchS0=;
	h=Date:To:From:Subject;
	b=Uv884dh6XOwXgvEVeiz4nG0CEMP0Zt/v727pjIG+joDnN1BrBVB627VKpN9yaaFPm
	 zNnfnDEsdax2hI2B6cgcEpHPHTQ7v1of+goovXD9MxvkwR5o6uq1SsH/MIrPNH/p51
	 k3Bvc1o3hhOBBXtRmEwE+/js9NRRMKAN9cAnXU44=
Date: Sat, 05 Sep 2026 18:45:17 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch added to mm-new branch
Message-Id: <20260906014517.D4E781F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memcg: redirect stats updates of dying memcgs for all hierarchies
has been added to the -mm mm-new branch.  Its filename is
     mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch

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
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: memcg: redirect stats updates of dying memcgs for all hierarchies
Date: Fri, 4 Sep 2026 17:45:54 +0800

Patch series "mm: workingset: fix the shadow node budget under MGLRU", v3.

Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
number of lru pages") broke the workingset shadow node budget under MGLRU:
lruvec_lru_size() reads mz->lru_zone_size, which MGLRU never maintains, so
count_shadow_nodes() sees the evictable LRU lists as empty and the shadow
shrinker reclaims eviction tokens almost as fast as they are created,
losing thrashing protection.

Patch 1 extends the dying-mcg stat redirection (previously cgroup v1 only)
to all hierarchies, addressing the reparenting race that motivated
7404bd37cfbe.

Patch 2 then switches count_shadow_nodes() back to
lruvec_page_state_local(), which both classic LRU and MGLRU maintain.

Patch 3 recovers the performance.  Patch 1 added an unconditional
rcu_read_lock() to the stat update fast path; patch 3 checks
memcg_is_dying() first and takes the RCU lock only on the rare dying path.


This patch (of 3):

get_non_dying_memcg_start() redirects the stat updates of a dying memcg to
its closest non-dying ancestor, but only on cgroup v1; on cgroup v2 the
stats keep being accounted to the dying memcg itself.

A later patch in this series restores lruvec_page_state_local() in
count_shadow_nodes() to fix the broken workingset shadow node budget under
MGLRU.  count_shadow_nodes() is the only reader of those non-hierarchical
state_locals on cgroup v2: when a memcg is offlined, its pages are
reparented to the ancestor but their stat updates keep being accounted to
the dying memcg, so count_shadow_nodes() computes a wrong shadow node
budget and workingset thrashing protection is lost.  This is user visible
as premature reclaim of hot page cache and degraded performance under
memory pressure.  Apply the redirection to all hierarchies to fix this.

Offlining is rare, so the added cost on the stat update fast path is
limited to an rcu_read_lock() and a css_is_dying() check; the upward walk
happens only while a memcg is dying.

Link: https://lore.kernel.org/cover.1788514750.git.zhuhui@kylinos.cn
Link: https://lore.kernel.org/8a3fe5e6a076cdd9ac997125cb6c6a0948e1a6b6.1788514750.git.zhuhui@kylinos.cn
Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the number of lru pages")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies
+++ a/mm/memcontrol.c
@@ -873,20 +873,14 @@ static long memcg_state_val_in_pages(int
 	return val < 0 ? -res : res;
 }
 
-#ifdef CONFIG_MEMCG_V1
 /*
- * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
- * reparenting of non-hierarchical state_locals.
+ * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race
+ * with reparenting of non-hierarchical state_locals.  Offlining a
+ * memcg is rare, so do the redirection for all cgroup hierarchies.
  */
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
-							   bool *rcu_locked)
+static inline struct mem_cgroup *
+get_non_dying_memcg_start(struct mem_cgroup *memcg, bool *rcu_locked)
 {
-	/* Rebinding can cause this value to be changed at runtime */
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
-		*rcu_locked = false;
-		return memcg;
-	}
-
 	rcu_read_lock();
 	*rcu_locked = true;
 
@@ -898,22 +892,8 @@ static inline struct mem_cgroup *get_non
 
 static inline void get_non_dying_memcg_end(bool rcu_locked)
 {
-	if (!rcu_locked)
-		return;
-
 	rcu_read_unlock();
 }
-#else
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
-							   bool *rcu_locked)
-{
-	return memcg;
-}
-
-static inline void get_non_dying_memcg_end(bool rcu_locked)
-{
-}
-#endif
 
 static void __mod_memcg_state(struct mem_cgroup *memcg,
 			      enum memcg_stat_item idx, long val)
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-vmstat-annotate-data-race-for-per-cpu-pageset-fields.patch
mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch
mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch
mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

