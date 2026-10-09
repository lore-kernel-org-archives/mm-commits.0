Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6944740F726;
	Fri,  9 Oct 2026 05:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525517; cv=none; b=KcOfpl5vRWRaOq8gJsfBKCLsjGo1yTZGj6NHhchPIkRJhRrLOJiSxZKrZNutUppUvSmil+qOAW4TfLtrHN3ivPEA2YCnELJcgKqrK7aRU/HiSKRXFNDAZrSnSFoPLMDags3LFnPwtt3eDRLcg/o+yW/6wbsvbHuGLhXohVyNn+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525517; c=relaxed/simple;
	bh=HNHwlyulERrNgJq+D/JTK1VNH7fNkfHCHTinFuJj8YI=;
	h=Date:To:From:Subject:Message-Id; b=mPfiSNmvcnymf5ieUQUjFwB4DQP6dwcJW5lyyz5cuhJXQC3zT4CDO9ToXk8x3gImISIkiPuPzmGzFPSUUAtfwI1jTcNyji4olNio1j6xBoAe/hDiqN8DyKPKar99HAG/ELUoV5y+3LPnMm1XdGH4w5eo9vCuirS5Kx7UQr5c4Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GRDsaloO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GRDsaloO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED6B1F00893;
	Fri,  9 Oct 2026 05:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525516;
	bh=ZwMf04IOolWopGJqfhK2jETxsFhAkPxdUgqADRNfjGk=;
	h=Date:To:From:Subject;
	b=GRDsaloOHCdZTbu2lXkmqN0LvLw47z4yoRaXIqpslwfCJ3k/ttss+tcA2xWhjF17h
	 YL0U7FVJUmIKDWFVqyqbXmvJJKKPVtlGJ1vhGSpG8KO6fBIrtKxqzuCoge55aIRW99
	 opdX+sNu5XQRK1XffPJ7oc8qj2KwMfqo66I8sDGc=
Date: Thu, 08 Oct 2026 22:58:35 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanchu@google.com,weixugc@google.com,tj@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,chris@chrisdown.name,baohua@kernel.org,axelrasmussen@google.com,chenridong@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch removed from -mm tree
Message-Id: <20261009055836.3ED6B1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mglru: fix ineffective memory protection for non-kswapd reclaim
has been removed from the -mm tree.  Its filename was
     mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ridong Chen <chenridong@xiaomi.com>
Subject: mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Mon, 7 Sep 2026 10:54:45 +0800

For MGLRU, memory.min/low is not honored during global proactive reclaim
(writing to the root memory.reclaim) and global direct reclaim, because
these paths shrink memcgs using stale protection (emin/elow).  It can be
reproduced as follows:

  # echo 7 > /sys/kernel/mm/lru_gen/enabled
  # cd /sys/fs/cgroup
  # mkdir -p a/b
  # echo 100M > a/memory.min
  # echo +memory > a/cgroup.subtree_control
  # echo 100M > a/b/memory.min
  # echo $$ > a/b/cgroup.procs
  # dd if=/dev/zero of=/tmp/testfile bs=1M count=200
  # cat a/b/memory.current
  222650368
  # echo 500M > memory.reclaim
  -bash: echo: write error: Resource temporarily unavailable
  # cat a/b/memory.current
  6070272

memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
protection.  The traditional LRU path is not affected because
shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
visits during a top-down tree walk.

Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
moved the protection computation into lru_gen_age_node(), which only runs
for kswapd.  Non-kswapd global reclaim reaches shrink_one() through
lru_gen_shrink_node() -> shrink_many() without any protection computation,
so emin/elow are whatever a previous kswapd run left behind - or zero if
kswapd never ran on this node.  Relying on a prior kswapd pass is not
correct either: a memcg's emin/elow are derived from its ancestors'
memory.min/low settings and from children_min_usage, both of which change
over time, so emin/elow go stale even after kswapd has run and must be
recomputed at the point of reclaim.

Introduce mem_cgroup_calculate_protection_path() which computes emin/elow
along the root-to-target path only, by iterating through the cgroup
ancestors array top-down.  This avoids the full tree traversal that would
be needed with mem_cgroup_calculate_protection(), limiting the cost to
O(depth) per memcg - typically 3-5 levels.

Call it from shrink_one() for the non-kswapd path so that each memcg about
to be shrunk has correct protection values.

Link: https://lore.kernel.org/20260907025445.1836238-3-ridong.chen@linux.dev
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Assisted-by: Claude:claude-opus-4-8
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <stable@vger.kernel.org>
---

 include/linux/memcontrol.h |   10 +++++++
 mm/memcontrol.c            |   45 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                |    8 +++++-
 3 files changed, 62 insertions(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim
+++ a/include/linux/memcontrol.h
@@ -1921,6 +1921,16 @@ static inline bool memcg_is_dying(struct
 }
 #endif /* CONFIG_MEMCG */
 
+#if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg);
+#else
+static inline void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+							struct mem_cgroup *memcg)
+{
+}
+#endif
+
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
 bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
 void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
--- a/mm/memcontrol.c~mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim
+++ a/mm/memcontrol.c
@@ -5267,6 +5267,51 @@ void mem_cgroup_calculate_protection(str
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+#ifdef CONFIG_LRU_GEN
+/**
+ * mem_cgroup_calculate_protection_path - compute protection along a path
+ * @root: the top ancestor of the sub-tree being checked (NULL for root_mem_cgroup)
+ * @memcg: the target memory cgroup
+ *
+ * Walk the ancestor path from @root down to @memcg and compute the effective
+ * protection at each level.  This is safe for isolated queries because it
+ * ensures parents are computed before children.
+ */
+void mem_cgroup_calculate_protection_path(struct mem_cgroup *root,
+					  struct mem_cgroup *memcg)
+{
+	bool recursive_protection =
+		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
+	struct cgroup *cg;
+	int root_level, i;
+
+	if (mem_cgroup_disabled())
+		return;
+
+	if (!root)
+		root = root_mem_cgroup;
+
+	if (memcg == root)
+		return;
+
+	root_level = root->css.cgroup->level;
+	cg = memcg->css.cgroup;
+
+	rcu_read_lock();
+	for (i = root_level + 1; i <= cg->level; i++) {
+		struct mem_cgroup *cur;
+
+		cur = mem_cgroup_from_css(cgroup_css(cg->ancestors[i],
+						     &memory_cgrp_subsys));
+		if (cur)
+			page_counter_calculate_protection(&root->memory,
+							  &cur->memory,
+							  recursive_protection);
+	}
+	rcu_read_unlock();
+}
+#endif /* CONFIG_LRU_GEN */
+
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
--- a/mm/vmscan.c~mm-mglru-fix-ineffective-memory-protection-for-non-kswapd-reclaim
+++ a/mm/vmscan.c
@@ -5251,7 +5251,13 @@ static int shrink_one(struct lruvec *lru
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 
-	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
+	/*
+	 * For kswapd, mem_cgroup_calculate_protection() has already
+	 * been called during the top-down cgroup traversal.
+	 */
+	if (!current_is_kswapd())
+		mem_cgroup_calculate_protection_path(NULL, memcg);
+
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
_

Patches currently in -mm which might be from chenridong@xiaomi.com are

mm-vmscan-put-rotation-missed-folios-at-the-lru-tail.patch

