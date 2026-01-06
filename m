Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC6A345CA8
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725496; cv=none; b=ntFSikE+VrmDWVgw/y1Hiqv4PxcZnudztKzCnuPsBhvtB/FWoxpRDDYBLT9v9pBLQb4jmYbn/zqd1cEy4+zdaWeHav7zz8FOmmweE5rxASYEWtttmJAUsrD6Nd7Tlev9BeXIi75cFCxPZeVjpfP0hrvZvBJ7p4smuUH3Wsk2JXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725496; c=relaxed/simple;
	bh=wGRquRalnARIRQ1DKNxAqujycZ13zvlB/iB9gm6KuP4=;
	h=Date:To:From:Subject:Message-Id; b=dkJmVDFyxYSEshf9thhI7IPXXB9MUIMB0tV4RjGdJE/F0FV8gt5noVOhi0CA7TmEu4KI0HwO+a+gK6dFN16jlccNk3QOIqmDE9sdNLCKYOLoVwARkSkRCs7PqFIiTBMlYU7UcAEzJ5dGKLnLMXHjdae4m8vTWr78ni1woe5p0Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OLiRJ/LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OLiRJ/LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E7A1C116C6;
	Tue,  6 Jan 2026 18:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725496;
	bh=wGRquRalnARIRQ1DKNxAqujycZ13zvlB/iB9gm6KuP4=;
	h=Date:To:From:Subject:From;
	b=OLiRJ/LPM9K//3UNrcoZ+5STSx0d3EI/6xF9fP061oE1iBv97aGTPYvVEqHmDwIKL
	 Dpzx9lhK0NYBZV8Vl4XJnnvAizouxwFdE/fg2P0IhyoyT0KMffoM1Fr6ny3SW3xpho
	 2Wqq8ZKGTUIjrVCBo/HTnv2r8g7ZFn0Ugc4mJ/xY=
Date: Tue, 06 Jan 2026 10:51:35 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch added to mm-new branch
Message-Id: <20260106185136.2E7A1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: rename mem_cgroup_ino() to mem_cgroup_id()
has been added to the -mm mm-new branch.  Its filename is
     memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Date: Thu, 25 Dec 2025 15:21:16 -0800

Rename mem_cgroup_ino() to mem_cgroup_id() and mem_cgroup_get_from_ino()
to mem_cgroup_get_from_id().  These functions now use cgroup IDs (from
cgroup_id()) rather than inode numbers, so the names should reflect that.

Link: https://lkml.kernel.org/r/20251225232116.294540-9-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Xu <weixugc@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 ++++----
 mm/damon/core.c            |    2 +-
 mm/damon/ops-common.c      |    2 +-
 mm/damon/sysfs-schemes.c   |    2 +-
 mm/memcontrol.c            |    2 +-
 mm/shrinker_debug.c        |   10 +++++-----
 mm/vmscan.c                |    6 +++---
 7 files changed, 16 insertions(+), 16 deletions(-)

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
+struct mem_cgroup *mem_cgroup_get_from_id(u64 ino);
 
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
+static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
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
@@ -3615,7 +3615,7 @@ struct mem_cgroup *mem_cgroup_from_priva
 	return xa_load(&mem_cgroup_private_ids, id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
+struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
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
@@ -5440,7 +5440,7 @@ static int lru_gen_seq_show(struct seq_f
 		if (memcg)
 			cgroup_path(memcg->css.cgroup, m->private, PATH_MAX);
 #endif
-		seq_printf(m, "memcg %llu %s\n", mem_cgroup_ino(memcg), path);
+		seq_printf(m, "memcg %llu %s\n", mem_cgroup_id(memcg), path);
 	}
 
 	seq_printf(m, " node %5d\n", nid);
@@ -5536,12 +5536,12 @@ static int run_cmd(char cmd, u64 memcg_i
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

lib-buildid-use-__kernel_read-for-sleepable-context.patch
mm-damon-core-get-memcg-reference-before-access.patch
memcg-introduce-private-id-api-for-in-kernel-users.patch
memcg-expose-mem_cgroup_ino-and-mem_cgroup_get_from_ino-unconditionally.patch
memcg-mem_cgroup_get_from_ino-returns-null-on-error.patch
memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch
mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch
mm-vmscan-use-cgroup-id-instead-of-private-memcg-id-in-lru_gen-interface.patch
memcg-remove-unused-mem_cgroup_id-and-mem_cgroup_from_id.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id.patch

