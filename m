Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4052EACEE
	for <mm-commits@vger.kernel.org>; Tue,  6 Jan 2026 18:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725485; cv=none; b=ZsIReHcQMSJ2eWbXEgmYIt9TqA3eV14vu0WnYsHB1Bu9jEb5r6qVth0zGhcjvASspI8WKmN0Ti7ZJjk8aCkz7TSq4gfmURXN1wSx4GXP3sF9hHcsrnQ5YPle6eQ2UyxFibt0Som3XFxXsAJ5YQd11CI6rHV6nIbFq41uw1yx3sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725485; c=relaxed/simple;
	bh=qtbRnP9ExB/Wog39mFFmAEh5vDehl6V1Pr8ZHpq5WeA=;
	h=Date:To:From:Subject:Message-Id; b=KlkQAd3T3xKypq67oioHxWEMM+fGLXHjVuxnH0C5qXABAK+txCyqTYZAGmJclV+rN1LWQAzPVVS3MTQQPD6c8asbwRm29GsnuBG7ITTsnScupXLegin9n6Espi2b2X29ACZKQtUscMMqBJevyov8br8uqTGfLpVghdd8XzPgWog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=osOQbNK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="osOQbNK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB95EC116C6;
	Tue,  6 Jan 2026 18:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767725484;
	bh=qtbRnP9ExB/Wog39mFFmAEh5vDehl6V1Pr8ZHpq5WeA=;
	h=Date:To:From:Subject:From;
	b=osOQbNK9wpuPBFw1akdJZBknvDTMKO6g+eYPCXC2ZC1ye8MnLfGjtTh8lIypYC2fF
	 8XyayIhoy6bL11Owwti0pfaDhjXsldhMKxwkrnTBvEc304vK/g/u/aCVol6XiQsxoc
	 Su7Q8f63OCG6C4r2333MCDwib/b5zs9E2gX83d1U=
Date: Tue, 06 Jan 2026 10:51:24 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yuanchu@google.com,weixugc@google.com,sj@kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,hannes@cmpxchg.org,david@kernel.org,david@fromorbit.com,axelrasmussen@google.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch added to mm-new branch
Message-Id: <20260106185124.DB95EC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: use cgroup_id() instead of cgroup_ino() for memcg ID
has been added to the -mm mm-new branch.  Its filename is
     memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-use-cgroup_id-instead-of-cgroup_ino-for-memcg-id.patch

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

