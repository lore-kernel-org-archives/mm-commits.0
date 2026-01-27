Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6113191AF
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486678; cv=none; b=CmXMzGjOoFHhIyosE7cajLtJnx2vXyPvUFm0aZwDAlJcfiK1CNZywtmPSrvz1rckwHPj6wMlt1GHfyZef8naBpjiWIfBx/gIXjN0zN7XqqeX/H00YHmP23/G1Ap6i0VNtM3H37tfebh5S/8hDxn0V7wx1SdFQ++oQiHXxRVXvbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486678; c=relaxed/simple;
	bh=TlaqC0d/0UzsVa7HDA/pjLOLzYfLJRgYbXVP2h8WHIc=;
	h=Date:To:From:Subject:Message-Id; b=FizwIudXdUWVdtv7ocgLMbfWfKk4XaSGO3NxJh9p3ef+zInF4CI9f80Makxc90jD8Eyz8gwF3CUHrymTn5wUxSYaIBhQJloPvHtnwL9900UOIw5bDPhiWaDlMGWS4IDMK4IeKZ2g/NqwxzXhlLg253Jda5r1ZZ+379Tx1sSRyYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X2mEBaDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X2mEBaDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E723EC116C6;
	Tue, 27 Jan 2026 04:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486678;
	bh=TlaqC0d/0UzsVa7HDA/pjLOLzYfLJRgYbXVP2h8WHIc=;
	h=Date:To:From:Subject:From;
	b=X2mEBaDbxA868AC/encQHmro+1I+K8pZAgCXjC3UqVpMPxWbLtnNjvPInxjIob3DC
	 9kid0eKTAY1WY/f8zkY1AZChtzed0+R9MjA0fvwuAsK41KfHVkY7N6gxATP9J8vIzz
	 3EPbHwNeBGExpmsk0O/AFsWytei7UgY7JK/AoZpg=
Date: Mon, 26 Jan 2026 20:04:37 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch removed from -mm tree
Message-Id: <20260127040437.E723EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memcg: use cgroup_id() instead of cgroup_ino() for memcg ID
has been removed from the -mm tree.  Its filename was
     memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: use cgroup_id() instead of cgroup_ino() for memcg ID
Date: Thu, 25 Dec 2025 15:21:12 -0800

Switch mem_cgroup_ino() from using cgroup_ino() to cgroup_id().  The
cgroup_ino() returns the kernfs inode number while cgroup_id() returns the
kernfs node ID.  For 64-bit systems, they are the same.  Also
cgroup_get_from_id() expects 64-bit node ID which is called by
mem_cgroup_get_from_ino().

Change the type from unsigned long to u64 to match cgroup_id()'s return
type, and update the format specifiers accordingly.

Note that the names mem_cgroup_ino() and mem_cgroup_get_from_ino() are now
misnomers since they deal with cgroup IDs rather than inode numbers.  A
follow-up patch will rename them.

Link: https://lkml.kernel.org/r/20251225232116.294540-5-shakeel.butt@linux.dev
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

 include/linux/memcontrol.h |   10 +++++-----
 mm/memcontrol.c            |    2 +-
 mm/shrinker_debug.c        |    7 ++++---
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/memcontrol.h~memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id
+++ a/include/linux/memcontrol.h
@@ -836,12 +836,12 @@ static inline unsigned short mem_cgroup_
 }
 struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
 
-static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
 {
-	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
+	return memcg ? cgroup_id(memcg->css.cgroup) : 0;
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
+struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino);
 
 static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
 {
@@ -1306,12 +1306,12 @@ static inline struct mem_cgroup *mem_cgr
 	return NULL;
 }
 
-static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
+static inline u64 mem_cgroup_ino(struct mem_cgroup *memcg)
 {
 	return 0;
 }
 
-static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
+static inline struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
 {
 	return NULL;
 }
--- a/mm/memcontrol.c~memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id
+++ a/mm/memcontrol.c
@@ -3620,7 +3620,7 @@ struct mem_cgroup *mem_cgroup_from_id(un
 	return mem_cgroup_from_private_id(id);
 }
 
-struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
+struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
--- a/mm/shrinker_debug.c~memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id
+++ a/mm/shrinker_debug.c
@@ -70,7 +70,7 @@ static int shrinker_debugfs_count_show(s
 					       memcg_aware ? memcg : NULL,
 					       count_per_node);
 		if (total) {
-			seq_printf(m, "%lu", mem_cgroup_ino(memcg));
+			seq_printf(m, "%llu", mem_cgroup_ino(memcg));
 			for_each_node(nid)
 				seq_printf(m, " %lu", count_per_node[nid]);
 			seq_putc(m, '\n');
@@ -106,7 +106,8 @@ static ssize_t shrinker_debugfs_scan_wri
 					   size_t size, loff_t *pos)
 {
 	struct shrinker *shrinker = file->private_data;
-	unsigned long nr_to_scan = 0, ino, read_len;
+	unsigned long nr_to_scan = 0, read_len;
+	u64 ino;
 	struct shrink_control sc = {
 		.gfp_mask = GFP_KERNEL,
 	};
@@ -119,7 +120,7 @@ static ssize_t shrinker_debugfs_scan_wri
 		return -EFAULT;
 	kbuf[read_len] = '\0';
 
-	if (sscanf(kbuf, "%lu %d %lu", &ino, &nid, &nr_to_scan) != 3)
+	if (sscanf(kbuf, "%llu %d %lu", &ino, &nid, &nr_to_scan) != 3)
 		return -EINVAL;
 
 	if (nid < 0 || nid >= nr_node_ids)
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


