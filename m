Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79239403135;
	Fri,  9 Oct 2026 05:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525428; cv=none; b=rVVRS61pzstxIaxXQNmZZGraPwwheRZA6wlWp4yx2xeYSwJgyLQuChjLxx6KL0wtESblj42LdoC7U3faHCzOz5lEELF9ksnfR20q1v/p8+uBWqGa4wVabZpzeoTSfJeLGgFsT0LkcpDh2575fGK52YZeHiaObdWRKIzgIxwii0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525428; c=relaxed/simple;
	bh=83WVmTET/8N6eGWvBvPYpXX+HiakpnJLG2isnQoya9k=;
	h=Date:To:From:Subject:Message-Id; b=ibwKJuIHNrGV/AvNXYOgd+M2r2KCfZlAn+HLh4OsgOiYUWTPYjjH+aSX7AoxuXOxtL22LbiQKD51NUL1gNs8v/z1fiCva7ZAutaiaWyqyJnhRbaOwK3QzPtbIgqHox1fHY35LKESqRlBz/xGQPIwCji4B0IxZSHkkAZuvRbORj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UsrEkoX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UsrEkoX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C92C1F00893;
	Fri,  9 Oct 2026 05:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525427;
	bh=R5S2Ho90Jh+mIXe9kpKzBDz8sHrirHr8MkVQ37Y2mBM=;
	h=Date:To:From:Subject;
	b=UsrEkoX/FNQqu1eGP4U7UvwuFdC+ygyG0Tp4YUdTF2QA9pVWPTMMNfHHjYG1E1qOC
	 +ru7Q2J6QypGP2NoIj4YkNm50r+wVjHvviWgrAfhonjbnf818opWF2Py7Vg3YFtY5h
	 8cg46bS+AH4YzmsSzsHFjsRa4n4Zcy38SxRYfnv0=
Date: Thu, 08 Oct 2026 22:57:06 -0700
To: mm-commits@vger.kernel.org,yuanchu@google.com,weixugc@google.com,stable@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,ljs@kernel.org,kasong@tencent.com,hannes@cmpxchg.org,david@kernel.org,baohua@kernel.org,axelrasmussen@google.com,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-reparent-non-hierarchical-lruvec-stats-on-cgroup-v2.patch removed from -mm tree
Message-Id: <20261009055707.4C92C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2
has been removed from the -mm tree.  Its filename was
     mm-memcg-reparent-non-hierarchical-lruvec-stats-on-cgroup-v2.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <zhuhui@kylinos.cn>
Subject: mm: memcg: reparent non-hierarchical lruvec stats on cgroup v2
Date: Fri, 11 Sep 2026 16:00:51 +0800

On cgroup v2, reparent_state_local() returns early and never moves the
dying memcg's non-hierarchical state_local base counts to its parent. 
Meanwhile memcg_reparent_objcgs() rewrites objcg->memcg to the parent, so
when the reparented folios are freed later, the negative deltas land on
the parent's lruvec.  The parent therefore receives the uncharges without
ever having received the matching charges, and its state_local
(NR_LRU_BASE + lru, MEMCG_SOCK, NR_SLAB_RECLAIMABLE_B,
NR_SLAB_UNRECLAIMABLE_B) permanently underflows.  Since
lruvec_page_state_local() clamps negative values to zero, the underflow
masks the parent's own legitimate pages.

count_shadow_nodes() is the only reader of these non-hierarchical
state_locals on cgroup v2, so the underflow directly distorts the
workingset shadow node budget.

Fix this by reparenting the lruvec state_locals on cgroup v2 as well,
mirroring what cgroup v1 already does.  Only the lruvec stats consumed by
count_shadow_nodes() are moved; the memcg-level stats are left alone
because on v2 they are exposed through the rstat hierarchical tree and are
not read from state_local.

Link: https://lore.kernel.org/4a7a64eed2b145ad535fedaea3624f8310c29d5b.1789096175.git.zhuhui@kylinos.cn
Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: <stable@vger.kernel.org>
---

 mm/memcontrol-v1.h |    5 +++--
 mm/memcontrol.c    |   42 ++++++++++++++++++++++++++++--------------
 2 files changed, 31 insertions(+), 16 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-reparent-non-hierarchical-lruvec-stats-on-cgroup-v2
+++ a/mm/memcontrol.c
@@ -233,14 +233,29 @@ static inline struct obj_cgroup *__memcg
 	return objcg;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool force);
 
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+/*
+ * Reparent the non-hierarchical lruvec stats that count_shadow_nodes() reads
+ * to approximate the shadow node budget.  They are not exposed to userspace
+ * on cgroup v2, but they must follow the reparented folios; otherwise the
+ * ancestor would only receive the negative deltas when the folios are freed
+ * without ever having received the positive base, and its local stats would
+ * permanently underflow.
+ */
+static void reparent_v2_lruvec_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return;
+	int i;
 
+	for (i = 0; i < NR_LRU_LISTS; i++)
+		reparent_memcg_lruvec_state_local(memcg, parent, NR_LRU_BASE + i);
+
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_RECLAIMABLE_B);
+	reparent_memcg_lruvec_state_local(memcg, parent, NR_SLAB_UNRECLAIMABLE_B);
+}
+
+static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
+{
 	/*
 	 * Reparent stats exposed non-hierarchically. Flush @memcg's stats first
 	 * to read its stats accurately , and conservatively flush @parent's
@@ -249,17 +264,18 @@ static inline void reparent_state_local(
 	 */
 	__mem_cgroup_flush_stats(memcg, true);
 
-	/* The following counts are all non-hierarchical and need to be reparented. */
-	reparent_memcg1_state_local(memcg, parent);
-	reparent_memcg1_lruvec_state_local(memcg, parent);
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		reparent_v2_lruvec_state_local(memcg, parent);
+	} else {
+#ifdef CONFIG_MEMCG_V1
+		/* The following counts are all non-hierarchical and need to be reparented. */
+		reparent_memcg1_state_local(memcg, parent);
+		reparent_memcg1_lruvec_state_local(memcg, parent);
+#endif
+	}
 
 	__mem_cgroup_flush_stats(parent, true);
 }
-#else
-static inline void reparent_state_local(struct mem_cgroup *memcg, struct mem_cgroup *parent)
-{
-}
-#endif
 
 static inline void reparent_locks(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
 {
@@ -571,7 +587,6 @@ unsigned long lruvec_page_state_local(st
 	return x;
 }
 
-#ifdef CONFIG_MEMCG_V1
 static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 				     enum node_stat_item idx, long val);
 
@@ -593,7 +608,6 @@ void reparent_memcg_lruvec_state_local(s
 		__mod_memcg_lruvec_state(parent_pn, idx, value);
 	}
 }
-#endif
 
 /* Subset of vm_event_item to report for memcg event stats */
 static const unsigned int memcg_vm_event_stat[] = {
--- a/mm/memcontrol-v1.h~mm-memcg-reparent-non-hierarchical-lruvec-stats-on-cgroup-v2
+++ a/mm/memcontrol-v1.h
@@ -25,6 +25,9 @@ int memory_stat_show(struct seq_file *m,
 struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
 						    unsigned int n);
 
+void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
+				       struct mem_cgroup *parent, int idx);
+
 /* Cgroup v1-specific declarations */
 #ifdef CONFIG_MEMCG_V1
 
@@ -67,8 +70,6 @@ void reparent_memcg1_lruvec_state_local(
 
 void reparent_memcg_state_local(struct mem_cgroup *memcg,
 				struct mem_cgroup *parent, int idx);
-void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
-				       struct mem_cgroup *parent, int idx);
 
 void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
 static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are


