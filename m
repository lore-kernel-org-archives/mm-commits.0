Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69D93191DE
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486679; cv=none; b=ItG6S5xD1lVWqOgE1t0l/KSTmoUsoYucm2006B8MxopnIMsyFyUUg6xvR/FW+Qii7mXLFF6XrBnL9yzAJTALQ9vYc521OT6uAfpPpRE0WomwY47QBE8t6YFRlJTEzA7+b0Fi8zfWPNS9K7ZjovguzN+3MqYRUmItcM//TfGr8/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486679; c=relaxed/simple;
	bh=iEEUSnKX4XfiJBRSQWASuVAoGJDeEOokYUPnr5sr3UA=;
	h=Date:To:From:Subject:Message-Id; b=HwsgQp466Wl7/ZUJEQZsekmaSXfouzrMzMR7JA268M3aCKlqFpK1el9yb61tmwctT0rDqChyAVagutI0KjAnAiamaHDlkwFR7sM3P+Lss5vJ6cka96qRW0jL7bOFNnU4YKwtrYJIpQvr4d54nDyyttpqzgsgYjmiHHLzX9A08Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GB4COyWI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GB4COyWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469B8C116C6;
	Tue, 27 Jan 2026 04:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486679;
	bh=iEEUSnKX4XfiJBRSQWASuVAoGJDeEOokYUPnr5sr3UA=;
	h=Date:To:From:Subject:From;
	b=GB4COyWI1J3CdZDeyct9p3X8eRFF7+zfqIyldLWyeAtlUGvuFvLo+/fd2D1PjPf5b
	 TeP5YsL24WFaJK5+j+UJS8aehnUXxc8S2AALxFVk+KS7u++kHGKJFRfDemX4HcybU9
	 sNIhrtjliNqmmR3hGxTt+xwRpOE8RxD07bcFZ25o=
Date: Mon, 26 Jan 2026 20:04:38 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch removed from -mm tree
Message-Id: <20260127040439.469B8C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: use cgroup ID instead of private memcg ID
has been removed from the -mm tree.  Its filename was
     mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: mm/damon: use cgroup ID instead of private memcg ID
Date: Thu, 25 Dec 2025 15:21:13 -0800

DAMON was using the internal private memcg ID which is meant for tracking
kernel objects that outlive their cgroup.  Switch to using the public
cgroup ID instead.

Link: https://lkml.kernel.org/r/20251225232116.294540-6-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: SeongJae Park <sj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
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

 include/linux/damon.h    |    4 ++--
 mm/damon/core.c          |    7 ++-----
 mm/damon/ops-common.c    |    2 +-
 mm/damon/sysfs-schemes.c |    8 ++++----
 4 files changed, 9 insertions(+), 12 deletions(-)

--- a/include/linux/damon.h~mm-damon-use-cgroup-id-instead-of-private-memcg-id
+++ a/include/linux/damon.h
@@ -203,7 +203,7 @@ struct damos_quota_goal {
 		u64 last_psi_total;
 		struct {
 			int nid;
-			unsigned short memcg_id;
+			u64 memcg_id;
 		};
 	};
 	struct list_head list;
@@ -419,7 +419,7 @@ struct damos_filter {
 	bool matching;
 	bool allow;
 	union {
-		unsigned short memcg_id;
+		u64 memcg_id;
 		struct damon_addr_range addr_range;
 		int target_idx;
 		struct damon_size_range sz_range;
--- a/mm/damon/core.c~mm-damon-use-cgroup-id-instead-of-private-memcg-id
+++ a/mm/damon/core.c
@@ -2094,16 +2094,13 @@ static unsigned long damos_get_node_memc
 	unsigned long used_pages, numerator;
 	struct sysinfo i;
 
-	rcu_read_lock();
-	memcg = mem_cgroup_from_id(goal->memcg_id);
-	if (!memcg || !mem_cgroup_tryget(memcg)) {
-		rcu_read_unlock();
+	memcg = mem_cgroup_get_from_ino(goal->memcg_id);
+	if (!memcg) {
 		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
 			return 0;
 		else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
 			return 10000;
 	}
-	rcu_read_unlock();
 
 	mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
--- a/mm/damon/ops-common.c~mm-damon-use-cgroup-id-instead-of-private-memcg-id
+++ a/mm/damon/ops-common.c
@@ -274,7 +274,7 @@ bool damos_folio_filter_match(struct dam
 		if (!memcg)
 			matched = false;
 		else
-			matched = filter->memcg_id == mem_cgroup_id(memcg);
+			matched = filter->memcg_id == mem_cgroup_ino(memcg);
 		rcu_read_unlock();
 		break;
 	case DAMOS_FILTER_TYPE_YOUNG:
--- a/mm/damon/sysfs-schemes.c~mm-damon-use-cgroup-id-instead-of-private-memcg-id
+++ a/mm/damon/sysfs-schemes.c
@@ -2494,7 +2494,7 @@ static bool damon_sysfs_memcg_path_eq(st
 	return false;
 }
 
-static int damon_sysfs_memcg_path_to_id(char *memcg_path, unsigned short *id)
+static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
 {
 	struct mem_cgroup *memcg;
 	char *path;
@@ -2509,11 +2509,11 @@ static int damon_sysfs_memcg_path_to_id(
 
 	for (memcg = mem_cgroup_iter(NULL, NULL, NULL); memcg;
 			memcg = mem_cgroup_iter(NULL, memcg, NULL)) {
-		/* skip removed memcg */
-		if (!mem_cgroup_id(memcg))
+		/* skip offlined memcg */
+		if (!mem_cgroup_online(memcg))
 			continue;
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
-			*id = mem_cgroup_id(memcg);
+			*id = mem_cgroup_ino(memcg);
 			found = true;
 			break;
 		}
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


