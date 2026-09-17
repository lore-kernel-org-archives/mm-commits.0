Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDC33EDACD
	for <mm-commits@vger.kernel.org>; Thu, 17 Sep 2026 05:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789621323; cv=none; b=dYgBW3Euwzo1jR5cEuDhfr61ZHB5FnLd9l0vq75IBxgbrqoqkjEW9FdJqE35uMO84t3wdEpG74mJGAN+V7Bi/FgPZ6Xm2MmTA7nX7WeSpXfKhcDoVFPT+SD5hEk7BgI5SdfKRk13aZhctblxgiDjsw+Zhwcubjxh+1gDxx5qCdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789621323; c=relaxed/simple;
	bh=fhOZdGKSelXWu4ZeUd7eV6CHMWqVcwrMI9QdT0iEtAM=;
	h=Date:To:From:Subject:Message-Id; b=aPVxFvJ3HMjv4pJYFn6CV/gz5k9yWgKqkfYgTJAICBtcFWBxn1J7HxZXbizq6zbfBXBqDDqtNK/J6tRAMhNJ5S0wy/O0EkD4FfVE+qM+uHr1BHDisWCubetrSdBHH+Gct/Pna289XXScl7kZVVD8aq8vfYTcAGfCf3i8KvhkeTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Qp6JQC4v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Qp6JQC4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7096C1F000FF;
	Thu, 17 Sep 2026 05:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789621321;
	bh=IClsUFh8bysbJbVb5wI13IM3rzJACgJES1P/2qUcdx4=;
	h=Date:To:From:Subject;
	b=Qp6JQC4vlmp0eGn1gxS5X1rfqnU+7dnwompqSiQv9m1VYsWVwE46IkM7xppmZ4E69
	 5JQBgr7BAN72myXA+k71Nc9jpZvaRmtQorpWkZHQQuZVGVid3sr35UwT9G4UBOVdyR
	 PlPloc0LUjzOZ6mo7nr4+/2kpejUz2C8vMXmo1fQ=
Date: Wed, 16 Sep 2026 22:02:00 -0700
To: mm-commits@vger.kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch removed from -mm tree
Message-Id: <20260917050201.7096C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: redirect stats updates of dying memcgs for all hierarchies
has been removed from the -mm tree.  Its filename was
     mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch

This patch was dropped because an updated version will be issued

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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
mm-workingset-use-lruvec_page_state_local-to-count-lru-pages.patch
mm-memcg-skip-the-rcu-lock-when-the-memcg-is-not-dying.patch

