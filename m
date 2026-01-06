Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655FB2BE7B2
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725488; cv=none; b=tfcfh2iPfx2NcuF8IKNoyH+h9BrEU0AsGXlQfWnTJOl/SBqx+KueSd1r9JEzNVtJKcATnCi0iHFjS6jehocVhJHemD+XPOmgkRPu6bdt5ijHigFyZ8CaMHBsTM+TOFETJi5ODI+HGK4zxbAVl2ypt+Y9iER63imaAelVPJnlA4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725488; c=relaxed/simple;
	bh=5PHpKpW/yKy0qzIp3yGaxXs3/J/nxxF60/evZsId64o=;
	h=Date:To:From:Subject:Message-Id; b=GL7cQkgf72MSZuHsDYRGzoNdaH3oOTiXxsYTppVpOpFQSYgZGXhOP9UYvRaTwkOJ+Gr0w1PLJbgN3E1rVBiXJNw8lw8YaxX5SnAEdskrS90J3Q+OiagcP1Xl0ZaMaxiv6uveoex05BZa6lS1NUyP9O6CLhNaPcR+5AWWW4Rz9/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ixA7lzfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ixA7lzfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D471EC116C6;
	Tue,  6 Jan 2026 18:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725487;
	bh=5PHpKpW/yKy0qzIp3yGaxXs3/J/nxxF60/evZsId64o=;
	h=Date:To:From:Subject:From;
	b=ixA7lzfkMOgmohA/0yzSQOsy3MwRiuIIJ9iIAMh70GfXGwRjGN8wC2QEE8MI0tNLy
	 sXPHjShUGLtfMA60SAUImcOoTt2X4us03wncQKH+J4NaO1mIIt97atQIY4RCgFhY+l
	 JHVCDnCfVtt5iS0QHgNny/ILKEXDVhXdKTnhqJNA=
Date: Tue, 06 Jan 2026 10:51:27 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch added to mm-new branch
Message-Id: <20260106185127.D471EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: use cgroup ID instead of private memcg ID
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-use-cgroup-id-instead-of-private-memcg-id.patch

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

