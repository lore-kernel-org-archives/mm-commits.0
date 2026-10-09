Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33793FCB3A;
	Fri,  9 Oct 2026 05:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525424; cv=none; b=BxyPkbou2VW1GVG61znZi/I+/cbuiaxilwTp6bkhcM3wXJSt3UPbOTZObDQOHvwpiZFwJZOdeE2tck442qySFqJcHnAwNKrQWJa8VBKU2/TeaecV0zBW1IoLiobVYh3+1w/me+qyCIa41sk4/jBbK/jBqIUrcjt172AV65bjOck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525424; c=relaxed/simple;
	bh=wrCUxn/NVA6e7tPFGWSFvWUyK8NSfW2SqR5kQWzr0Dc=;
	h=Date:To:From:Subject:Message-Id; b=XecErNnrH26YtstCf0dD2nojhZWRetw2UxDbYC0x5Ihsp9qBb0RgJ61aPjtEEv5qfpvSLX6bb2MNMlSMKiSkaSwHdMM1P0kbMpmRr5hQN2GcZHsu5Fz4cTAVHdHOfkiHEsGSrmsG2FJi/d/Rkx2NLIURdW6kqyed+CFy5d4ExiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Mvhqvd9I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Mvhqvd9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63501F000FF;
	Fri,  9 Oct 2026 05:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525422;
	bh=UhHjPUOD6x0kJmU30n81lnI+Z+oQDPPT61p1VA7qk+Y=;
	h=Date:To:From:Subject;
	b=Mvhqvd9ICxjG1GlazHkkLYO8QDF5UkSxhgB7xYJX0c6Es8DHxGOZHm4OZBuel4l+b
	 t54dHIfTVB87wI3GYnyVQn9Fo6m0Q5jwxs77rtwAh28x7v6k3rGfUmB0Czpr8x/htO
	 xn8/sJJPZy8o4E803ICFNBaWIzuB/ACI/B7Fz14c=
Date: Thu, 08 Oct 2026 22:57:02 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch removed from -mm tree
Message-Id: <20261009055702.B63501F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: redirect stats updates of dying memcgs for all hierarchies
has been removed from the -mm tree.  Its filename was
     mm-memcg-redirect-stats-updates-of-dying-memcgs-for-all-hierarchies.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: memcg: redirect stats updates of dying memcgs for all hierarchies
Date: Fri, 11 Sep 2026 16:00:48 +0800

Patch series "mm: workingset: fix the shadow node budget under MGLRU", v5.

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

Patch 4 closes an accounting gap that patch 2 makes visible: on cgroup v2,
reparent_state_local() never moves the dying memcg's non-hierarchical
lruvec stats to the parent, so the parent receives the uncharges without
the matching charges and its state_local underflows.  Patch 4 reparents
those stats, mirroring cgroup v1.

Performance testing
===================

The test script and the raw results are available at [1].

Environment: 10-vCPU QEMU guest, 8 GiB RAM, cgroup v2; 7 runs per
configuration, medians reported.  Workloads:

  w1-anon-churn: single-threaded anon fault/charge loop in a memcg
                 (MADV_DONTNEED + re-fault, no reclaim).  Every touch
                 is a real fault with charge and memcg stat updates,
                 so it stresses exactly the fast path patch 1 changes.
                 This is the meaningful signal: it is not reclaim-bound,
                 so the small fast-path overhead is not drowned out.
  w2-file-churn: file read loop under memory.high pressure
                 (reclaim-bound; the differences below are within
                 run-to-run noise and are shown for completeness only).
  w3-reparent:   reparent accounting sanity check.

w1-anon-churn (pages/s):

                 classic LRU          MGLRU
base             4393028              4377122
patches 1-2      4385996   (-0.2%)    4352887   (-0.6%)
patches 1-3      4381832   (-0.3%)    4377053   (+0.0%)

w2-file-churn (MB/s):

                 classic LRU          MGLRU
base             8277                 8226
patches 1-2      8226      (-0.6%)    8123      (-1.3%)
patches 1-3      8157      (-1.4%)    8294      (+0.8%)

w3-reparent passed on all kernels.

The small overhead visible with patches 1-2 comes from the redirection
added by patch 1; patch 3 brings w1 back to the base level in both LRU
configurations.  The w2-file-churn differences are within run-to-run
noise: that workload is reclaim-bound and too noisy to expose the small
fast-path overhead, so w1-anon-churn is the meaningful signal.  Patch 4
only touches the memcg offline path and is not exercised by these
workloads.


This patch (of 4):

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

Link: https://lore.kernel.org/cover.1789096175.git.zhuhui@kylinos.cn
Link: https://lore.kernel.org/c1ef4ef6a84cac479e573f4423b734dc8176f7d5.1789096175.git.zhuhui@kylinos.cn
Link: https://gist.github.com/teawater/32f373ec41d185d840455eb167321a5a [1]
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
Cc: <stable@vger.kernel.org>
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


