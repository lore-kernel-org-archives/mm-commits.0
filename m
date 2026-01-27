Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E71B318EFF
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486683; cv=none; b=hmjvqpUKcpNP4RH2exHD3S0oWmbLntmtEhK9lAzYJ3NMGCyPKO8z7TEGSByLiOdO6RBGgbgtfvaXG+ZedQZ9KWHo4JZtAPu0WHOt13KglA3B4WDq1aLCc7Rg6aDKQhm+3jDm2rLhlYcM+MaqpEdMM4yzchlAKh7gH8mcpW/SyU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486683; c=relaxed/simple;
	bh=dwTR6PDz5VqdczJjruuDEnQ5apU2O2ge0y9hHA9MrTM=;
	h=Date:To:From:Subject:Message-Id; b=AE2Ckng8JyHa/YjfPiy6C1vIDdgiVufv9hlemVGvDgEaOFkQ0kYVuGOwa4uJQGox5LGpw6GSNXjxTZdD4ex8vYq/JguNaHRYfez8I9f4RqyCvbP0v1mZI3iNn6dct+vL8S8g9wlzEUjyaeF1Xltjd0sDuNO0iB0bCISPMeJHZr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x4DrR8iQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x4DrR8iQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45752C116C6;
	Tue, 27 Jan 2026 04:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486683;
	bh=dwTR6PDz5VqdczJjruuDEnQ5apU2O2ge0y9hHA9MrTM=;
	h=Date:To:From:Subject:From;
	b=x4DrR8iQbsyIJW5+2LFtI/6BQWeOAmjNqICyOIfetWZaPull4uhOFhhelRfwNNSrF
	 ioJgBdWeF1upEIt0IhlkIPilc6u2RKc+5Jc3vhouPvqHOUIh+WHNDmyGyKuIQykMJ+
	 LCUg/Q/DlhTiDupnP5u/jxzlUOUf+9O9vqDoUwHc=
Date: Mon, 26 Jan 2026 20:04:42 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch removed from -mm tree
Message-Id: <20260127040443.45752C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: rename mem_cgroup_ino() to mem_cgroup_id()
has been removed from the -mm tree.  Its filename was
     memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Date: Thu, 25 Dec 2025 15:21:16 -0800

Rename mem_cgroup_ino() to mem_cgroup_id() and mem_cgroup_get_from_ino()
to mem_cgroup_get_from_id().  These functions now use cgroup IDs (from
cgroup_id()) rather than inode numbers, so the names should reflect that.

[shakeel.butt@linux.dev: replace ino with id, per SeongJae]
  Link: https://lkml.kernel.org/r/flkqanhyettp5uq22bjwg37rtmnpeg3mghznsylxcxxgaafpl4@nov2x7tagma7
[akpm@linux-foundation.org: build fix]
Link: https://lkml.kernel.org/r/20251225232116.294540-9-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/damon/core.c            |    2 +-
 mm/damon/ops-common.c      |    2 +-
 mm/damon/sysfs-schemes.c   |    2 +-
 mm/memcontrol.c            |    4 ++--
 mm/shrinker_debug.c        |   10 +++++-----
 mm/vmscan.c                |    6 +++---
 7 files changed, 17 insertions(+), 17 deletions(-)

--- a/include/linux/memcontrol.h~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id
+++ a/include/linux/memcontrol.h
@@ -830,12 +830,12 @@ static inline unsigned short mem_cgroup_
 }
 struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id);
 
-static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino);
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id);
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1288,12 +1288,12 @@ static inline struct mem_cgroup *mem_cgr
 	return NULL;
 }
 
-static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_id(struct mem_cgroup *memcg)
 {
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
+static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	return NULL;
 }
--- a/mm/damon/core.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id
+++ a/mm/damon/core.c
@@ -2094,7 +2094,7 @@ static unsigned long damos_get_node_memc
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
-	memcg = mem_cgroup_get_from_ino(goal->memcg_id);
+	memcg = mem_cgroup_get_from_id(goal->memcg_id);
 	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 			return 0;
--- a/mm/damon/ops-common.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id
+++ a/mm/damon/ops-common.c
@@ -274,7 +274,7 @@ bool damos_folio_filter_match(struct dam
 		if (!memcg)
 			matched = false;
 		else
-			matched = filter->memcg_id == mem_cgroup_ino(memcg);
+			matched = filter->memcg_id == mem_cgroup_id(memcg);
 		rcu_read_unlock();
 		break;
 	case DAMOS_FILTER_TYPE_YOUNG:
--- a/mm/damon/sysfs-schemes.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id
+++ a/mm/damon/sysfs-schemes.c
@@ -2513,7 +2513,7 @@ static int damon_sysfs_memcg_path_to_id(
 		if (!mem_cgroup_online(memcg))
 			continue;
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
-			*id = mem_cgroup_ino(memcg);
+			*id = mem_cgroup_id(memcg);
 			found = true;
 			break;
 		}
--- a/mm/memcontrol.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id
+++ a/mm/memcontrol.c
@@ -3615,13 +3615,13 @@ struct mem_cgroup *mem_cgroup_from_priva
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
+struct mem_cgroup *mem_cgroup_get_from_id(u64 id)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
 	struct mem_cgroup *memcg = NULL;
 
-	cgrp = cgroup_get_from_id(ino);
+	cgrp = cgroup_get_from_id(id);
 	if (IS_ERR(cgrp))
 		return NULL;
 
--- a/mm/shrinker_debug.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id
+++ a/mm/shrinker_debug.c
@@ -70,7 +70,7 @@ static int shrinker_debugfs_count_show(s
 					       memcg_aware ? memcg : NULL,
 					       count_per_node);
 		if (total) {
-			seq_printf(m, "%llu", mem_cgroup_ino(memcg));
+			seq_printf(m, "%llu", mem_cgroup_id(memcg));
 			for_each_node(nid)
 				seq_printf(m, " %lu", count_per_node[nid]);
 			seq_putc(m, '\n');
@@ -107,7 +107,7 @@ static ssize_t shrinker_debugfs_scan_wri
 {
 	struct shrinker *shrinker = file->private_data;
 	unsigned long nr_to_scan = 0, read_len;
-	u64 ino;
+	u64 id;
 	struct shrink_control sc = {
 		.gfp_mask = GFP_KERNEL,
 	};
@@ -120,7 +120,7 @@ static ssize_t shrinker_debugfs_scan_wri
 		return -EFAULT;
 	kbuf[read_len] = '\0';
 
-	if (sscanf(kbuf, "%llu %d %lu", &ino, &nid, &nr_to_scan) != 3)
+	if (sscanf(kbuf, "%llu %d %lu", &id, &nid, &nr_to_scan) != 3)
 		return -EINVAL;
 
 	if (nid < 0 || nid >= nr_node_ids)
@@ -130,7 +130,7 @@ static ssize_t shrinker_debugfs_scan_wri
 		return size;
 
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
-		memcg = mem_cgroup_get_from_ino(ino);
+		memcg = mem_cgroup_get_from_id(id);
 		if (!memcg)
 			return -ENOENT;
 
@@ -138,7 +138,7 @@ static ssize_t shrinker_debugfs_scan_wri
 			mem_cgroup_put(memcg);
 			return -ENOENT;
 		}
-	} else if (ino != 0) {
+	} else if (id != 0) {
 		return -EINVAL;
 	}
 
--- a/mm/vmscan.c~memcg-rename-mem_cgroup_ino-to-mem_cgroup_id
+++ a/mm/vmscan.c
@@ -5416,7 +5416,7 @@ static int lru_gen_seq_show(struct seq_f
 		if (memcg)
 			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
 #endif
-		seq_printf(m, "memcg %llu %s\n", mem_cgroup_ino(memcg), path);
+		seq_printf(m, "memcg %llu %s\n", mem_cgroup_id(memcg), path);
 	}
 
 	seq_printf(m, " node %5d\n", nid);
@@ -5512,12 +5512,12 @@ static int run_cmd(char cmd, u64 memcg_i
 		return -EINVAL;
 
 	if (!mem_cgroup_disabled()) {
-		memcg = mem_cgroup_get_from_ino(memcg_id);
+		memcg = mem_cgroup_get_from_id(memcg_id);
 		if (!memcg)
 			return -EINVAL;
 	}
 
-	if (memcg_id != mem_cgroup_ino(memcg))
+	if (memcg_id != mem_cgroup_id(memcg))
 		goto done;
 
 	sc->target_mem_cgroup = memcg;
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


