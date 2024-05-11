Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE9D47A74
	for <mm-commits@vger.kernel.org>; Sat, 11 May 2024 22:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467341; cv=none; b=bssnHyxQ8tz0KFje/fCMSZUDJBRHAOGn0JFKvilddbBSjYMHQD4DQX7w9KNZ5lisgFjMNUSe1OwgFL0vhligf7TmC8vC0qrNLY/BVarUoeV20NDSnx6q+fIpwR63TPSLrZWDHbVyjwUPr9bxPqZW9J43mDiXJInKSIPwOakak1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467341; c=relaxed/simple;
	bh=jD/G9X+eNlP5nE0iu5quJIM2y0Luwrv094eIJNFOVHU=;
	h=Date:To:From:Subject:Message-Id; b=AhjpfSYX4pMKbOsq8PuHaQYyXXAM+xfpgeKSGs30U9syhDBG/LjwLw1e6QxMrk4agz+jIIXdX8TY84l3DYY3wjYCtZdoVF/IC82tIGbVX8wHzh12OiZWvnoS3U1v6G7S60BDOJ8c+8RyftkpMHdVtjTsZqv+69bJ3qh6j9uGesM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w5hdSJ91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w5hdSJ91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF80C32781;
	Sat, 11 May 2024 22:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715467341;
	bh=jD/G9X+eNlP5nE0iu5quJIM2y0Luwrv094eIJNFOVHU=;
	h=Date:To:From:Subject:From;
	b=w5hdSJ91j1WzCR2LMNEBSry7hw+UhBdcogTIQZ3yFEIHFdTD8NMKJDEDYkn+KfAVq
	 z08j9JBYzDWdlXmmadQyw56dPrHAuvW1q8nE2NjEig9VF9t6YL65ssAAktRwU2mmE8
	 XQ9UrPJnms2uzWy62wsl0yOc6LlJx3lGthRFS1Ks=
Date: Sat, 11 May 2024 15:42:20 -0700
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,xiujianfeng@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool.patch removed from -mm tree
Message-Id: <20240511224221.4FF80C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memcg: make alloc_mem_cgroup_per_node_info() return bool
has been removed from the -mm tree.  Its filename was
     mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm: memcg: make alloc_mem_cgroup_per_node_info() return bool
Date: Tue, 7 May 2024 13:23:24 +0000

alloc_mem_cgroup_per_node_info() returns int that doesn't map to any errno
error code.  The only existing caller doesn't really need an error code so
change the function to return bool (true on success) because this is
slightly less confusing and more consistent with the other code.

Link: https://lkml.kernel.org/r/20240507132324.1158510-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-make-alloc_mem_cgroup_per_node_info-return-bool
+++ a/mm/memcontrol.c
@@ -5637,13 +5637,13 @@ struct mem_cgroup *mem_cgroup_get_from_i
 }
 #endif
 
-static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
+static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
 
 	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, node);
 	if (!pn)
-		return 1;
+		return false;
 
 	pn->lruvec_stats = kzalloc_node(sizeof(struct lruvec_stats),
 					GFP_KERNEL_ACCOUNT, node);
@@ -5659,11 +5659,11 @@ static int alloc_mem_cgroup_per_node_inf
 	pn->memcg = memcg;
 
 	memcg->nodeinfo[node] = pn;
-	return 0;
+	return true;
 fail:
 	kfree(pn->lruvec_stats);
 	kfree(pn);
-	return 1;
+	return false;
 }
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
@@ -5736,7 +5736,7 @@ static struct mem_cgroup *mem_cgroup_all
 	}
 
 	for_each_node(node)
-		if (alloc_mem_cgroup_per_node_info(memcg, node))
+		if (!alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
 
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are


